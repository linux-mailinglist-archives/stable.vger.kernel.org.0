Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E04254B78E
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 14:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbfFSMAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 08:00:51 -0400
Received: from mail-eopbgr00116.outbound.protection.outlook.com ([40.107.0.116]:5412
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727067AbfFSMAv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jun 2019 08:00:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ABHzUELD5+im/vvvJ2ISewP7ApRyBRKxm0GD54OAcBU=;
 b=o/KvQPfTvkA7xPQs9q//tEuMbQdmm4lvN1FpJ3yn5iTPnpkXlyX6hwaqIjOQmAei3vr4+9XE6pG2Hp3SVTzrAKjXm8IElw0JyPcmOstI1VvOniaJ6zxfOJVrJoPuQz66L7P3jULkL+XKTZn3Bnte6l6GGzC6lyuUJZwCKg7DSS0=
Received: from HE1PR0702MB3675.eurprd07.prod.outlook.com (52.133.6.141) by
 HE1PR0702MB3753.eurprd07.prod.outlook.com (52.133.6.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.12; Wed, 19 Jun 2019 12:00:46 +0000
Received: from HE1PR0702MB3675.eurprd07.prod.outlook.com
 ([fe80::39:cb3e:563f:f6f9]) by HE1PR0702MB3675.eurprd07.prod.outlook.com
 ([fe80::39:cb3e:563f:f6f9%3]) with mapi id 15.20.2008.007; Wed, 19 Jun 2019
 12:00:46 +0000
From:   "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 4.14] perf machine: Guard against NULL in machine__exit()
Thread-Topic: [PATCH 4.14] perf machine: Guard against NULL in machine__exit()
Thread-Index: AQHVJpahWeLv25S4e0Sd5SL4xz8LbQ==
Date:   Wed, 19 Jun 2019 12:00:46 +0000
Message-ID: <20190619120030.6099-1-tommi.t.rantala@nokia.com>
Accept-Language: fi-FI, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-clientproxiedby: HE1PR05CA0247.eurprd05.prod.outlook.com
 (2603:10a6:3:fb::23) To HE1PR0702MB3675.eurprd07.prod.outlook.com
 (2603:10a6:7:8d::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tommi.t.rantala@nokia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [131.228.2.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc9ac109-12a5-41e1-a40f-08d6f4adc35d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:HE1PR0702MB3753;
x-ms-traffictypediagnostic: HE1PR0702MB3753:
x-microsoft-antispam-prvs: <HE1PR0702MB37539936AA2C130D916B6038B4E50@HE1PR0702MB3753.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:378;
x-forefront-prvs: 0073BFEF03
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(346002)(396003)(136003)(376002)(199004)(189003)(25786009)(68736007)(305945005)(8936002)(7736002)(14454004)(256004)(14444005)(486006)(6486002)(4326008)(6116002)(316002)(66066001)(8676002)(2616005)(1076003)(186003)(36756003)(102836004)(52116002)(476003)(2501003)(103116003)(3846002)(1730700003)(53936002)(81166006)(81156014)(6916009)(5640700003)(66476007)(64756008)(66556008)(26005)(66946007)(386003)(6436002)(99286004)(5660300002)(71200400001)(54906003)(6506007)(73956011)(478600001)(2351001)(2906002)(6512007)(86362001)(50226002)(66446008)(71190400001)(101420200001);DIR:OUT;SFP:1102;SCL:1;SRVR:HE1PR0702MB3753;H:HE1PR0702MB3675.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Gg+kXV/Fo2Pdx6YysvBofxvkvAAZbQ8g05CWlm5QQoW6YOLhD6URg7J+eO+QoyQXyhNf2Uvc+QvMAJY/xv8Yu6p4VHDztGkaKS52qCg9E8VsOwCrcYh+8gsRZAKe6ij3qMU3KTH9u343J3t++aUwXxyHDauykBGmg5XKMo6UIOJhMUf9CVlX1KODauVwRmlxOVtgQNeZoug1SJu06UiIGQbgcZlcOD6aYZD28+FxpzdG8hjBg4zFCdYTRZ1eDxdTHyqE+tte3swNjAWG+wZ7me3qoK3A+pH+oDvbY/IntUYXH0pcuMpibt2k9x/IVTLWO5kZqtFZ2ld6PSYt1LEUhJVwDdmn6jwvhGYIvEnou0wxQ6BcaDcOausvGoWOHxwUrvYmKNrijeGdCgawXGqYzOrM39H64cMLGeX/V1NzDgk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc9ac109-12a5-41e1-a40f-08d6f4adc35d
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2019 12:00:46.8014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tommi.t.rantala@nokia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0702MB3753
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogQXJuYWxkbyBDYXJ2YWxobyBkZSBNZWxvIDxhY21lQHJlZGhhdC5jb20+DQoNCmNvbW1p
dCA0YTIyMzNiMTk0Yzc3YWUxZWE4MzA0Y2I3YzAwYjU1MWRlNDMxM2YwIHVwc3RyZWFtLg0KDQpB
IHJlY2VudCBmaXggZm9yICdwZXJmIHRyYWNlJyBpbnRyb2R1Y2VkIGEgYnVnIHdoZXJlDQptYWNo
aW5lX19leGl0KHRyYWNlLT5ob3N0KSBjb3VsZCBiZSBjYWxsZWQgd2hpbGUgdHJhY2UtPmhvc3Qg
d2FzIHN0aWxsDQpOVUxMLCBzbyBtYWtlIHRoaXMgbW9yZSByb2J1c3QgYnkgZ3VhcmRpbmcgYWdh
aW5zdCBOVUxMLCBqdXN0IGxpa2UNCmZyZWUoKSBkb2VzLg0KDQpUaGUgcHJvYmxlbSBoYXBwZW5z
LCBmb3IgaW5zdGFuY2UsIHdoZW4gIXJvb3QgdXNlcnMgdHJ5IHRvIHJ1biAncGVyZg0KdHJhY2Un
Og0KDQogIFthY21lQGpvdWV0IGxpbnV4XSQgdHJhY2UNCiAgRXJyb3I6CU5vIHBlcm1pc3Npb25z
IHRvIHJlYWQgL3N5cy9rZXJuZWwvZGVidWcvdHJhY2luZy9ldmVudHMvcmF3X3N5c2NhbGxzL3N5
c18oZW50ZXJ8ZXhpdCkNCiAgSGludDoJVHJ5ICdzdWRvIG1vdW50IC1vIHJlbW91bnQsbW9kZT03
NTUgL3N5cy9rZXJuZWwvZGVidWcvdHJhY2luZycNCg0KICBwZXJmOiBTZWdtZW50YXRpb24gZmF1
bHQNCiAgT2J0YWluZWQgNyBzdGFjayBmcmFtZXMuDQogIFsweDRmMWIyZV0NCiAgL2xpYjY0L2xp
YmMuc28uNigrMHgzNjcxZikgWzB4N2Y0M2ExZGQ5NzFmXQ0KICBbMHg0ZjNmZWNdDQogIFsweDQ3
NDY4Yl0NCiAgWzB4NDJhMmRiXQ0KICAvbGliNjQvbGliYy5zby42KF9fbGliY19zdGFydF9tYWlu
KzB4ZTkpIFsweDdmNDNhMWRjMzUwOV0NCiAgWzB4NDJhNmM5XQ0KICBTZWdtZW50YXRpb24gZmF1
bHQgKGNvcmUgZHVtcGVkKQ0KICBbYWNtZUBqb3VldCBsaW51eF0kDQoNCkNjOiBBZHJpYW4gSHVu
dGVyIDxhZHJpYW4uaHVudGVyQGludGVsLmNvbT4NCkNjOiBBbGV4YW5kZXIgU2hpc2hraW4gPGFs
ZXhhbmRlci5zaGlzaGtpbkBsaW51eC5pbnRlbC5jb20+DQpDYzogQW5kcmVpIFZhZ2luIDxhdmFn
aW5Ab3BlbnZ6Lm9yZz4NCkNjOiBEYXZpZCBBaGVybiA8ZHNhaGVybkBnbWFpbC5jb20+DQpDYzog
SmlyaSBPbHNhIDxqb2xzYUBrZXJuZWwub3JnPg0KQ2M6IE5hbWh5dW5nIEtpbSA8bmFtaHl1bmdA
a2VybmVsLm9yZz4NCkNjOiBQZXRlciBaaWpsc3RyYSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+DQpD
YzogVmFzaWx5IEF2ZXJpbiA8dnZzQHZpcnR1b3p6by5jb20+DQpDYzogV2FuZyBOYW4gPHdhbmdu
YW4wQGh1YXdlaS5jb20+DQpGaXhlczogMzM5NzRhNDE0Y2UyICgicGVyZiB0cmFjZTogQ2FsbCBt
YWNoaW5lX19leGl0KCkgYXQgZXhpdCIpDQpTaWduZWQtb2ZmLWJ5OiBBcm5hbGRvIENhcnZhbGhv
IGRlIE1lbG8gPGFjbWVAcmVkaGF0LmNvbT4NClNpZ25lZC1vZmYtYnk6IFRvbW1pIFJhbnRhbGEg
PHRvbW1pLnQucmFudGFsYUBub2tpYS5jb20+DQotLS0NCiB0b29scy9wZXJmL3V0aWwvbWFjaGlu
ZS5jIHwgMyArKysNCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1n
aXQgYS90b29scy9wZXJmL3V0aWwvbWFjaGluZS5jIGIvdG9vbHMvcGVyZi91dGlsL21hY2hpbmUu
Yw0KaW5kZXggOTY4ZmQwNDU0ZTZiLi5kMjQ2MDgwY2Q4NWUgMTAwNjQ0DQotLS0gYS90b29scy9w
ZXJmL3V0aWwvbWFjaGluZS5jDQorKysgYi90b29scy9wZXJmL3V0aWwvbWFjaGluZS5jDQpAQCAt
MTU2LDYgKzE1Niw5IEBAIHZvaWQgbWFjaGluZV9fZGVsZXRlX3RocmVhZHMoc3RydWN0IG1hY2hp
bmUgKm1hY2hpbmUpDQogDQogdm9pZCBtYWNoaW5lX19leGl0KHN0cnVjdCBtYWNoaW5lICptYWNo
aW5lKQ0KIHsNCisJaWYgKG1hY2hpbmUgPT0gTlVMTCkNCisJCXJldHVybjsNCisNCiAJbWFjaGlu
ZV9fZGVzdHJveV9rZXJuZWxfbWFwcyhtYWNoaW5lKTsNCiAJbWFwX2dyb3Vwc19fZXhpdCgmbWFj
aGluZS0+a21hcHMpOw0KIAlkc29zX19leGl0KCZtYWNoaW5lLT5kc29zKTsNCi0tIA0KMi4yMC4x
DQoNCg==
