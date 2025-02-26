import 'package:flutter/material.dart';
import 'package:flutter_paypal/src/flutter_paypal.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Paypal',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Flutter Paypal Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: TextButton(
              onPressed: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => UsePaypal(
                            // 沙盒模式，生产环境需设为false
                            sandboxMode: true,
                            // PayPal开发者账号的客户端ID
                            clientId: "AW1TdvpSGbIM5iP4HJNI5TyTmwpY9Gv9dYw8_8yW5lYIbCqf326vrkrp0ce9TAqjEGMHiV3OqJM_aRT0",
                            // PayPal开发者账号的密钥
                            secretKey: "EHHtTDjnmTZATYBPiGzZC_AZUfMpMAzj2VZUeqlFUrRJA_C0pQNCxDccB5qoRQSEdcOnnKQhycuOWdP9",
                            // 支付成功后的回调URL，PayPal会将用户重定向到此URL
                            returnURL: "https://samplesite.com/return",
                            // 支付取消后的回调URL
                            cancelURL: "https://samplesite.com/cancel",
                            // 支付交易数据配置
                            transactions: const [
                              {
                                "amount": {
                                  "total": '10.12',
                                  "currency": "USD",
                                  "details": {
                                    "subtotal": '10.12',
                                    "shipping": '0',
                                    "shipping_discount": 0
                                  }
                                },
                                "description": "The payment transaction description.",
                                "item_list": {
                                  "items": [
                                    {
                                      "name": "A demo product",
                                      "quantity": 1,
                                      "price": '10.12',
                                      "currency": "USD"
                                    }
                                  ],

                                  "shipping_address": {
                                    "recipient_name": "Jane Foster",
                                    "line1": "Travis County",
                                    "line2": "",
                                    "city": "Austin",
                                    "country_code": "US",
                                    "postal_code": "73301",
                                    "phone": "+00000000",
                                    "state": "Texas"
                                  },
                                }
                              }
                            ],
                            note: "Contact us for any questions on your order.",
                            onSuccess: (Map params) async {
                              print("onSuccess: $params");

                              // 延迟显示对话框，确保导航动作完成
                              Future.delayed(const Duration(milliseconds: 300),
                                  () {
                                if (navigatorKey.currentContext != null) {
                                  showDialog(
                                    context: navigatorKey.currentContext!,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('支付成功'),
                                        content: SingleChildScrollView(
                                          child: Text(
                                              '收到的数据: \n\n${_formatMapData(params)}'),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text('关闭'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              });
                            },
                            onError: (error) {
                              print("onError: $error");
                              // 延迟显示对话框，确保导航动作完成
                              Future.delayed(const Duration(milliseconds: 300),
                                  () {
                                if (navigatorKey.currentContext != null) {
                                  showDialog(
                                    context: navigatorKey.currentContext!,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('支付失败'),
                                        content: Text('错误信息: \n\n$error'),
                                        backgroundColor: Colors.red[50],
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text('关闭'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              });
                            },
                            onCancel: (params) {
                              print('cancelled: $params');
                              // 延迟显示对话框，确保导航动作完成
                              Future.delayed(const Duration(milliseconds: 300),
                                  () {
                                if (navigatorKey.currentContext != null) {
                                  showDialog(
                                    context: navigatorKey.currentContext!,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('支付已取消'),
                                        content: Text('取消信息: \n\n$params'),
                                        backgroundColor: Colors.amber[50],
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text('关闭'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              });
                            }),
                      ),
                    )
                  },
              child: const Text("PayPal支付 10.12")),
        ));
  }

  String _formatMapData(Map data, {int indent = 0}) {
    String result = '';
    String indentStr = ' ' * indent;

    data.forEach((key, value) {
      if (value is Map) {
        result +=
            '$indentStr$key: {\n${_formatMapData(value, indent: indent + 2)}\n$indentStr}\n';
      } else if (value is List) {
        result += '$indentStr$key: [\n';
        for (var item in value) {
          if (item is Map) {
            result +=
                '$indentStr  {\n${_formatMapData(item, indent: indent + 4)}\n$indentStr  },\n';
          } else {
            result += '$indentStr  $item,\n';
          }
        }
        result += '$indentStr]\n';
      } else {
        result += '$indentStr$key: $value\n';
      }
    });

    return result;
  }
}
