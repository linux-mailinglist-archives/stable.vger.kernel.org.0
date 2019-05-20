Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41D73229D2
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 04:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbfETCDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 May 2019 22:03:25 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:39505
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726786AbfETCDZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 19 May 2019 22:03:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v67WAPFusspV4Na++nTAAaHMTMAUhVCwGAFZkhqJawo=;
 b=QxUvbXmhaYhHynZ3q1kmG4Osd/ltbF6qfyFnPaRQpwnReIl/gBP3DtyTHp7FXrD31oVBb1QWCZSq02gVU9A8ANS+Se2yukyOLn0iOCchTHK/13SlVO2Hli+O7EJk9YroqWyiYRw5AVjSYK+yaIsApxZD/UWXukx327gdhNEazqU=
Received: from AM0PR04MB4481.eurprd04.prod.outlook.com (52.135.147.15) by
 AM0PR04MB4628.eurprd04.prod.outlook.com (52.135.148.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.17; Mon, 20 May 2019 02:03:19 +0000
Received: from AM0PR04MB4481.eurprd04.prod.outlook.com
 ([fe80::3173:24:d401:2378]) by AM0PR04MB4481.eurprd04.prod.outlook.com
 ([fe80::3173:24:d401:2378%6]) with mapi id 15.20.1900.020; Mon, 20 May 2019
 02:03:19 +0000
From:   Peng Fan <peng.fan@nxp.com>
To:     "mturquette@baylibre.com" <mturquette@baylibre.com>,
        "sboyd@kernel.org" <sboyd@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peng Fan <peng.fan@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH V3] clk: imx: imx8mm: fix int pll clk gate
Thread-Topic: [PATCH V3] clk: imx: imx8mm: fix int pll clk gate
Thread-Index: AQHVDrAyQ1ZpJItbgUWgZmYb6FWXWQ==
Date:   Mon, 20 May 2019 02:03:19 +0000
Message-ID: <20190520021702.3531-1-peng.fan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.16.4
x-clientproxiedby: HK2PR02CA0160.apcprd02.prod.outlook.com
 (2603:1096:201:1f::20) To AM0PR04MB4481.eurprd04.prod.outlook.com
 (2603:10a6:208:70::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peng.fan@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad5505f9-d739-41b1-de4d-08d6dcc75461
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM0PR04MB4628;
x-ms-traffictypediagnostic: AM0PR04MB4628:
x-microsoft-antispam-prvs: <AM0PR04MB4628BA9BAE10652958BC4B1588060@AM0PR04MB4628.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:386;
x-forefront-prvs: 004395A01C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(136003)(39860400002)(346002)(396003)(189003)(199004)(25786009)(305945005)(2906002)(52116002)(99286004)(2501003)(486006)(316002)(44832011)(476003)(1076003)(14444005)(68736007)(2616005)(53936002)(256004)(66066001)(36756003)(71200400001)(71190400001)(6436002)(4326008)(386003)(6506007)(186003)(3846002)(6116002)(6486002)(26005)(5660300002)(102836004)(6512007)(66476007)(8936002)(7736002)(14454004)(81156014)(81166006)(66446008)(54906003)(8676002)(86362001)(66556008)(2201001)(66946007)(110136005)(64756008)(73956011)(478600001)(50226002)(7416002)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4628;H:AM0PR04MB4481.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lnREfV7/y+twbPywYdw/Cs4vYm5s0IzfozCGDQihASUGJwIAI2Piaz+SuTDeGhvoMFCT+sYf87zi5rldyq4A5XcG/Wb6mceIdaf+YRLoUmqim4OA7za0wUDuxtkMDEtxccuDYn2slOb/nTzTLxguAFRPgfY9+fvW0KPbzmdyGf6hy0xifoFdZDg1PBPcYtdcfYaudD8VwYk1Vj+seB1aaAgXix0IVmbQiKkpqoKES7CBFj7QWgP9QDF7+Zn+0U67qlJvjhMLD7YjgzjSCeTyEgdB0F77T/mJqNF7H1UI3VprJe+dnvkD5MpDdrrYfg6V1c3QV50Pw1fNt5uvvdVoYWtIwxzzcQW6gayXcbe8qH65ow+cKwKcqu03JHjlait5oLSSaoesHVPN9X7w54X6Q1U0zupS/TyXiuR2ZgMjx0g=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad5505f9-d739-41b1-de4d-08d6dcc75461
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2019 02:03:19.4075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4628
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VG8gRnJhYyBwbGwsIHRoZSBnYXRlIHNoaWZ0IGlzIDEzLCBob3dldmVyIHRvIEludCBQTEwgdGhl
IGdhdGUgc2hpZnQNCmlzIDExLg0KDQpDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+DQpGaXhl
czogYmE1NjI1YzNlMjcgKCJjbGs6IGlteDogQWRkIGNsb2NrIGRyaXZlciBzdXBwb3J0IGZvciBp
bXg4bW0iKQ0KU2lnbmVkLW9mZi1ieTogUGVuZyBGYW4gPHBlbmcuZmFuQG54cC5jb20+DQpSZXZp
ZXdlZC1ieTogRmFiaW8gRXN0ZXZhbSA8ZmVzdGV2YW1AZ21haWwuY29tPg0KUmV2aWV3ZWQtYnk6
IEphY2t5IEJhaSA8cGluZy5iYWlAbnhwLmNvbT4NCi0tLQ0KDQpWMzoNCiBNb3ZlIEZpeGVzIFRh
ZyB0byBjb3JyZWN0IHBsYWNlDQpWMjoNCiBVcGRhdGUgY29tbWl0IHdpdGggRml4ZXMsIEFkZCBS
LWIgYW5kIGNjIHN0YWJsZQ0KDQogZHJpdmVycy9jbGsvaW14L2Nsay1pbXg4bW0uYyB8IDEyICsr
KysrKy0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25z
KC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2Nsay9pbXgvY2xrLWlteDhtbS5jIGIvZHJpdmVy
cy9jbGsvaW14L2Nsay1pbXg4bW0uYw0KaW5kZXggMWVmODQzOGUzZDZkLi4xMjJhODFhYjhlNDgg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL2Nsay9pbXgvY2xrLWlteDhtbS5jDQorKysgYi9kcml2ZXJz
L2Nsay9pbXgvY2xrLWlteDhtbS5jDQpAQCAtNDQ5LDEyICs0NDksMTIgQEAgc3RhdGljIGludCBf
X2luaXQgaW14OG1tX2Nsb2Nrc19pbml0KHN0cnVjdCBkZXZpY2Vfbm9kZSAqY2NtX25vZGUpDQog
CWNsa3NbSU1YOE1NX0FVRElPX1BMTDJfT1VUXSA9IGlteF9jbGtfZ2F0ZSgiYXVkaW9fcGxsMl9v
dXQiLCAiYXVkaW9fcGxsMl9ieXBhc3MiLCBiYXNlICsgMHgxNCwgMTMpOw0KIAljbGtzW0lNWDhN
TV9WSURFT19QTEwxX09VVF0gPSBpbXhfY2xrX2dhdGUoInZpZGVvX3BsbDFfb3V0IiwgInZpZGVv
X3BsbDFfYnlwYXNzIiwgYmFzZSArIDB4MjgsIDEzKTsNCiAJY2xrc1tJTVg4TU1fRFJBTV9QTExf
T1VUXSA9IGlteF9jbGtfZ2F0ZSgiZHJhbV9wbGxfb3V0IiwgImRyYW1fcGxsX2J5cGFzcyIsIGJh
c2UgKyAweDUwLCAxMyk7DQotCWNsa3NbSU1YOE1NX0dQVV9QTExfT1VUXSA9IGlteF9jbGtfZ2F0
ZSgiZ3B1X3BsbF9vdXQiLCAiZ3B1X3BsbF9ieXBhc3MiLCBiYXNlICsgMHg2NCwgMTMpOw0KLQlj
bGtzW0lNWDhNTV9WUFVfUExMX09VVF0gPSBpbXhfY2xrX2dhdGUoInZwdV9wbGxfb3V0IiwgInZw
dV9wbGxfYnlwYXNzIiwgYmFzZSArIDB4NzQsIDEzKTsNCi0JY2xrc1tJTVg4TU1fQVJNX1BMTF9P
VVRdID0gaW14X2Nsa19nYXRlKCJhcm1fcGxsX291dCIsICJhcm1fcGxsX2J5cGFzcyIsIGJhc2Ug
KyAweDg0LCAxMyk7DQotCWNsa3NbSU1YOE1NX1NZU19QTEwxX09VVF0gPSBpbXhfY2xrX2dhdGUo
InN5c19wbGwxX291dCIsICJzeXNfcGxsMV9ieXBhc3MiLCBiYXNlICsgMHg5NCwgMTMpOw0KLQlj
bGtzW0lNWDhNTV9TWVNfUExMMl9PVVRdID0gaW14X2Nsa19nYXRlKCJzeXNfcGxsMl9vdXQiLCAi
c3lzX3BsbDJfYnlwYXNzIiwgYmFzZSArIDB4MTA0LCAxMyk7DQotCWNsa3NbSU1YOE1NX1NZU19Q
TEwzX09VVF0gPSBpbXhfY2xrX2dhdGUoInN5c19wbGwzX291dCIsICJzeXNfcGxsM19ieXBhc3Mi
LCBiYXNlICsgMHgxMTQsIDEzKTsNCisJY2xrc1tJTVg4TU1fR1BVX1BMTF9PVVRdID0gaW14X2Ns
a19nYXRlKCJncHVfcGxsX291dCIsICJncHVfcGxsX2J5cGFzcyIsIGJhc2UgKyAweDY0LCAxMSk7
DQorCWNsa3NbSU1YOE1NX1ZQVV9QTExfT1VUXSA9IGlteF9jbGtfZ2F0ZSgidnB1X3BsbF9vdXQi
LCAidnB1X3BsbF9ieXBhc3MiLCBiYXNlICsgMHg3NCwgMTEpOw0KKwljbGtzW0lNWDhNTV9BUk1f
UExMX09VVF0gPSBpbXhfY2xrX2dhdGUoImFybV9wbGxfb3V0IiwgImFybV9wbGxfYnlwYXNzIiwg
YmFzZSArIDB4ODQsIDExKTsNCisJY2xrc1tJTVg4TU1fU1lTX1BMTDFfT1VUXSA9IGlteF9jbGtf
Z2F0ZSgic3lzX3BsbDFfb3V0IiwgInN5c19wbGwxX2J5cGFzcyIsIGJhc2UgKyAweDk0LCAxMSk7
DQorCWNsa3NbSU1YOE1NX1NZU19QTEwyX09VVF0gPSBpbXhfY2xrX2dhdGUoInN5c19wbGwyX291
dCIsICJzeXNfcGxsMl9ieXBhc3MiLCBiYXNlICsgMHgxMDQsIDExKTsNCisJY2xrc1tJTVg4TU1f
U1lTX1BMTDNfT1VUXSA9IGlteF9jbGtfZ2F0ZSgic3lzX3BsbDNfb3V0IiwgInN5c19wbGwzX2J5
cGFzcyIsIGJhc2UgKyAweDExNCwgMTEpOw0KIA0KIAkvKiBTWVMgUExMIGZpeGVkIG91dHB1dCAq
Lw0KIAljbGtzW0lNWDhNTV9TWVNfUExMMV80ME1dID0gaW14X2Nsa19maXhlZF9mYWN0b3IoInN5
c19wbGwxXzQwbSIsICJzeXNfcGxsMV9vdXQiLCAxLCAyMCk7DQotLSANCjIuMTYuNA0KDQo=
