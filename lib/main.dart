import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final controller = ScreenshotController();
  @override
  Widget build(BuildContext context) => Screenshot(
      controller: controller,
      child: Scaffold(
        appBar: AppBar(title: Text("Take Snap")),
        body: Column(
          children: [
            buildImage(),
            const SizedBox(height: 32),
            ElevatedButton(
                onPressed: () async {
                  final image = await controller.capture();
                  if (image == null) return;
                  await saveImage(image);
                },
                child: Text("Capture Screen")),
            const SizedBox(height: 32),
            ElevatedButton(
                onPressed: () async {
                  final image =
                      await controller.captureFromWidget(buildImage());
                  saveAndShare(image);
                },
                child: Text("Capture Widget"))
          ],
        ),
      ));
  Future<String> saveImage(Uint8List bytes) async {
    await [Permission.storage].request();
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', "-")
        .replaceAll(':', "-");
    final name = "screenshot_$time";
    final result = await ImageGallerySaver.saveImage(bytes, name: name);
    return result['filePath'];
  }

  Future saveAndShare(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/flutter.png');
    image.writeAsBytesSync(bytes);
    final text = "Save By Lottery App";
    await Share.shareFiles([image.path], text: text);
  }
}

Widget buildImage() => Stack(
      children: [
        AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              'https://www.google.com/search?q=image&sxsrf=APq-WBsf-6xClcEPOVTdkrQaa_dYwKhdxA:1645615406081&tbm=isch&source=iu&ictx=1&vet=1&fir=gxFxsvFBmxeZ9M%252C0JWe7yDOKrVFAM%252C_%253BQKujF23VvyowQM%252C0tEu10TvCUWwrM%252C_%253BDH7p1w2o_fIU8M%252CBa_eiczVaD9-zM%252C_%253Bl5RllJHFLw5NyM%252CLOSptVP0p_ZwUM%252C_%253Bn5hAWsQ-sgKo_M%252C-UStXW0dQEx4SM%252C_%253B2DNOEjVi-CBaYM%252CAOz9-XMe1ixZJM%252C_%253BA4G7eW2zetaunM%252Cl3NoP295SYrYvM%252C_%253B1Y5Fex7Bw6VMkM%252CYAMnwpTKFlPEWM%252C_%253BMOAYgJU89sFKnM%252CygIoihldBPn-LM%252C_%253BOInJdS8dQ-WcBM%252CZpSxnunkhSO6zM%252C_%253BqXynBYpZpHkhWM%252C4O2GvGuD-Cf09M%252C_%253BbDjlNH-20Ukm8M%252CG9GbNX6HcZ2O_M%252C_%253BkwgHAQqTiLQXLM%252CR0KnAtfyBDsyiM%252C_%253Bz4_uU0QB2pe-SM%252C7SySw5zvOgPYAM%252C_&usg=AI4_-kTnOE8wiY-MXdiHo0ifx8jIcObZDQ&sa=X&ved=2ahUKEwjMlt2N25X2AhXtzoUKHZE9AC8Q9QF6BAgDEAE#imgrc=gxFxsvFBmxeZ9M',
              fit: BoxFit.cover,
            )),
        Positioned(
          bottom: 16,
          right: 0,
          left: 0,
          child: Center(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            color: Colors.black,
            child: Text("Lottery:"),
          )),
        )
      ],
    );
