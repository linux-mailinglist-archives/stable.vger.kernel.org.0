Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A44132142C
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 09:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfEQH1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 03:27:08 -0400
Received: from mail-eopbgr80085.outbound.protection.outlook.com ([40.107.8.85]:6658
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726893AbfEQH1I (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 May 2019 03:27:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bhZjDN2ZVQoc+RchWUkdNoIkiO7Pz2E3XwsAtc3vEWI=;
 b=eKN7cutLnBTapOgGavIkaxQIwbg9bqqrYwOs1i4xIC0jBJxs1zFHBT1T+VY8VGVtQebqP6VpevxqI0n0+wzxoo+ay2FiTYZQZBdAVsTcbIyUyv/K4iW/mucXjA5gN1d3TIPBUjqepfwRPjnISZQ9JyDzx1tu5iOjxRMHlp0TJbY=
Received: from AM0PR04MB4481.eurprd04.prod.outlook.com (52.135.147.15) by
 AM0PR04MB4658.eurprd04.prod.outlook.com (52.135.149.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.17; Fri, 17 May 2019 07:27:03 +0000
Received: from AM0PR04MB4481.eurprd04.prod.outlook.com
 ([fe80::3173:24:d401:2378]) by AM0PR04MB4481.eurprd04.prod.outlook.com
 ([fe80::3173:24:d401:2378%6]) with mapi id 15.20.1900.010; Fri, 17 May 2019
 07:27:03 +0000
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
Subject: [PATCH V2] clk: imx: imx8mm: fix int pll clk gate
Thread-Topic: [PATCH V2] clk: imx: imx8mm: fix int pll clk gate
Thread-Index: AQHVDIHsPBmx0qvGqk+whAsCcaHkFA==
Date:   Fri, 17 May 2019 07:27:03 +0000
Message-ID: <20190517074039.22614-1-peng.fan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.16.4
x-clientproxiedby: HK0PR01CA0051.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::15) To AM0PR04MB4481.eurprd04.prod.outlook.com
 (2603:10a6:208:70::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peng.fan@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b53e6245-023d-4cc2-32ec-08d6da990eae
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM0PR04MB4658;
x-ms-traffictypediagnostic: AM0PR04MB4658:
x-microsoft-antispam-prvs: <AM0PR04MB4658640FBE6C11A0D0029CB6880B0@AM0PR04MB4658.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:336;
x-forefront-prvs: 0040126723
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39860400002)(376002)(396003)(136003)(346002)(189003)(199004)(53936002)(386003)(476003)(6486002)(5660300002)(6506007)(4326008)(102836004)(14444005)(7736002)(256004)(36756003)(2616005)(68736007)(66476007)(73956011)(1076003)(66556008)(64756008)(66446008)(50226002)(66946007)(66066001)(2906002)(6436002)(44832011)(486006)(186003)(6512007)(305945005)(52116002)(71200400001)(8936002)(7416002)(99286004)(71190400001)(2201001)(25786009)(81156014)(81166006)(110136005)(26005)(8676002)(6116002)(86362001)(478600001)(14454004)(2501003)(316002)(54906003)(3846002)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4658;H:AM0PR04MB4481.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: D26b/oY1UZkujZBnI/JK+8WyDvn6GI6v0vcPuRJsRIAUPoBrtmf5xt8WwOA6lvV4J6TX0LuQI29JLyvBcB3DDWUpszHCWpoGmNQB70DFWOXB+SNZJNqBct7WKQyTBlRKWix2dem9yVd/+QK4rPGXHUGz+365kmfTyBFjs1jG+qcEG3UpzH2JyVMwFacjiwb2A6287KKIYZ8LsqknB6HJ9IrXOLjEIeGK/9hsbOonNeKbnqVIwEA6IROjlAXmhEZOAAhsqub5mqpP4USetwGJpNj65vC9Ktj84KiI96Kd5QKwypfteJZ2gmGnVy/UEHBvagcen48xqIsq+3oApZaxAHGTLZdCvYJ6llFVQeB2YXYBIDgOam3pyQbo2zQhKi693PVwUJhQiUHuvCz8+XLZt1ScvUqoQh5q4KtZVTCPY5U=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b53e6245-023d-4cc2-32ec-08d6da990eae
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2019 07:27:03.5709
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4658
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Rml4ZXM6IGJhNTYyNWMzZTI3ICgiY2xrOiBpbXg6IEFkZCBjbG9jayBkcml2ZXIgc3VwcG9ydCBm
b3IgaW14OG1tIikNClRvIEZyYWMgcGxsLCB0aGUgZ2F0ZSBzaGlmdCBpcyAxMywgaG93ZXZlciB0
byBJbnQgUExMIHRoZSBnYXRlIHNoaWZ0DQppcyAxMS4NCg0KQ2M6IDxzdGFibGVAdmdlci5rZXJu
ZWwub3JnPg0KU2lnbmVkLW9mZi1ieTogUGVuZyBGYW4gPHBlbmcuZmFuQG54cC5jb20+DQpSZXZp
ZXdlZC1ieTogRmFiaW8gRXN0ZXZhbSA8ZmVzdGV2YW1AZ21haWwuY29tPg0KUmV2aWV3ZWQtYnk6
IEphY2t5IEJhaSA8cGluZy5iYWlAbnhwLmNvbT4NCi0tLQ0KDQpWMjoNCiBVcGRhdGUgY29tbWl0
IHdpdGggRml4ZXMsIEFkZCBSLWIgYW5kIGNjIHN0YWJsZQ0KDQogZHJpdmVycy9jbGsvaW14L2Ns
ay1pbXg4bW0uYyB8IDEyICsrKysrKy0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlv
bnMoKyksIDYgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2Nsay9pbXgvY2xr
LWlteDhtbS5jIGIvZHJpdmVycy9jbGsvaW14L2Nsay1pbXg4bW0uYw0KaW5kZXggMWVmODQzOGUz
ZDZkLi4xMjJhODFhYjhlNDggMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2Nsay9pbXgvY2xrLWlteDht
bS5jDQorKysgYi9kcml2ZXJzL2Nsay9pbXgvY2xrLWlteDhtbS5jDQpAQCAtNDQ5LDEyICs0NDks
MTIgQEAgc3RhdGljIGludCBfX2luaXQgaW14OG1tX2Nsb2Nrc19pbml0KHN0cnVjdCBkZXZpY2Vf
bm9kZSAqY2NtX25vZGUpDQogCWNsa3NbSU1YOE1NX0FVRElPX1BMTDJfT1VUXSA9IGlteF9jbGtf
Z2F0ZSgiYXVkaW9fcGxsMl9vdXQiLCAiYXVkaW9fcGxsMl9ieXBhc3MiLCBiYXNlICsgMHgxNCwg
MTMpOw0KIAljbGtzW0lNWDhNTV9WSURFT19QTEwxX09VVF0gPSBpbXhfY2xrX2dhdGUoInZpZGVv
X3BsbDFfb3V0IiwgInZpZGVvX3BsbDFfYnlwYXNzIiwgYmFzZSArIDB4MjgsIDEzKTsNCiAJY2xr
c1tJTVg4TU1fRFJBTV9QTExfT1VUXSA9IGlteF9jbGtfZ2F0ZSgiZHJhbV9wbGxfb3V0IiwgImRy
YW1fcGxsX2J5cGFzcyIsIGJhc2UgKyAweDUwLCAxMyk7DQotCWNsa3NbSU1YOE1NX0dQVV9QTExf
T1VUXSA9IGlteF9jbGtfZ2F0ZSgiZ3B1X3BsbF9vdXQiLCAiZ3B1X3BsbF9ieXBhc3MiLCBiYXNl
ICsgMHg2NCwgMTMpOw0KLQljbGtzW0lNWDhNTV9WUFVfUExMX09VVF0gPSBpbXhfY2xrX2dhdGUo
InZwdV9wbGxfb3V0IiwgInZwdV9wbGxfYnlwYXNzIiwgYmFzZSArIDB4NzQsIDEzKTsNCi0JY2xr
c1tJTVg4TU1fQVJNX1BMTF9PVVRdID0gaW14X2Nsa19nYXRlKCJhcm1fcGxsX291dCIsICJhcm1f
cGxsX2J5cGFzcyIsIGJhc2UgKyAweDg0LCAxMyk7DQotCWNsa3NbSU1YOE1NX1NZU19QTEwxX09V
VF0gPSBpbXhfY2xrX2dhdGUoInN5c19wbGwxX291dCIsICJzeXNfcGxsMV9ieXBhc3MiLCBiYXNl
ICsgMHg5NCwgMTMpOw0KLQljbGtzW0lNWDhNTV9TWVNfUExMMl9PVVRdID0gaW14X2Nsa19nYXRl
KCJzeXNfcGxsMl9vdXQiLCAic3lzX3BsbDJfYnlwYXNzIiwgYmFzZSArIDB4MTA0LCAxMyk7DQot
CWNsa3NbSU1YOE1NX1NZU19QTEwzX09VVF0gPSBpbXhfY2xrX2dhdGUoInN5c19wbGwzX291dCIs
ICJzeXNfcGxsM19ieXBhc3MiLCBiYXNlICsgMHgxMTQsIDEzKTsNCisJY2xrc1tJTVg4TU1fR1BV
X1BMTF9PVVRdID0gaW14X2Nsa19nYXRlKCJncHVfcGxsX291dCIsICJncHVfcGxsX2J5cGFzcyIs
IGJhc2UgKyAweDY0LCAxMSk7DQorCWNsa3NbSU1YOE1NX1ZQVV9QTExfT1VUXSA9IGlteF9jbGtf
Z2F0ZSgidnB1X3BsbF9vdXQiLCAidnB1X3BsbF9ieXBhc3MiLCBiYXNlICsgMHg3NCwgMTEpOw0K
KwljbGtzW0lNWDhNTV9BUk1fUExMX09VVF0gPSBpbXhfY2xrX2dhdGUoImFybV9wbGxfb3V0Iiwg
ImFybV9wbGxfYnlwYXNzIiwgYmFzZSArIDB4ODQsIDExKTsNCisJY2xrc1tJTVg4TU1fU1lTX1BM
TDFfT1VUXSA9IGlteF9jbGtfZ2F0ZSgic3lzX3BsbDFfb3V0IiwgInN5c19wbGwxX2J5cGFzcyIs
IGJhc2UgKyAweDk0LCAxMSk7DQorCWNsa3NbSU1YOE1NX1NZU19QTEwyX09VVF0gPSBpbXhfY2xr
X2dhdGUoInN5c19wbGwyX291dCIsICJzeXNfcGxsMl9ieXBhc3MiLCBiYXNlICsgMHgxMDQsIDEx
KTsNCisJY2xrc1tJTVg4TU1fU1lTX1BMTDNfT1VUXSA9IGlteF9jbGtfZ2F0ZSgic3lzX3BsbDNf
b3V0IiwgInN5c19wbGwzX2J5cGFzcyIsIGJhc2UgKyAweDExNCwgMTEpOw0KIA0KIAkvKiBTWVMg
UExMIGZpeGVkIG91dHB1dCAqLw0KIAljbGtzW0lNWDhNTV9TWVNfUExMMV80ME1dID0gaW14X2Ns
a19maXhlZF9mYWN0b3IoInN5c19wbGwxXzQwbSIsICJzeXNfcGxsMV9vdXQiLCAxLCAyMCk7DQot
LSANCjIuMTYuNA0KDQo=
