Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13F2C2CCBE
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 18:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfE1Q4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 12:56:49 -0400
Received: from mail-eopbgr750118.outbound.protection.outlook.com ([40.107.75.118]:62977
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726512AbfE1Q4t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 May 2019 12:56:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=wavesemi.onmicrosoft.com; s=selector1-wavesemi-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U2hiJeg71rAVO/C28b0VW05V5OVjr2MQ+o6501cDk28=;
 b=ZUgj5ewwIQpj+riKaWh6/V9sHRCyASh5B1Wy4zHmi6BmosCeTsugzXhPN9xd27kneU8zJGD+C2jtl3BLlYfStETef9GQTU6n2GnKxpvRH0amwmPB5wd1ZgvRmYeA4IRuRjZP98ZUCtR6mRCZRXKc+Q/26t3dxNBP+Udx9U8xLMQ=
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com (10.174.162.17) by
 MWHPR2201MB1568.namprd22.prod.outlook.com (10.172.63.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Tue, 28 May 2019 16:56:42 +0000
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::90ff:8d19:8459:834b]) by MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::90ff:8d19:8459:834b%7]) with mapi id 15.20.1922.021; Tue, 28 May 2019
 16:56:42 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>
CC:     Paul Burton <pburton@wavecomp.com>, Archer Yan <ayan@wavecomp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH] irqchip/mips-gic: Use the correct local interrupt map
 registers
Thread-Topic: [PATCH] irqchip/mips-gic: Use the correct local interrupt map
 registers
Thread-Index: AQHVFXZSM9UrjGFoZkKtgNi33S6f+Q==
Date:   Tue, 28 May 2019 16:56:41 +0000
Message-ID: <20190528165630.32016-1-paul.burton@mips.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29)
 To MWHPR2201MB1277.namprd22.prod.outlook.com (2603:10b6:301:24::17)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.21.0
x-originating-ip: [12.94.197.246]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b77b9cd-799d-458d-aa96-08d6e38d7509
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR2201MB1568;
x-ms-traffictypediagnostic: MWHPR2201MB1568:
x-microsoft-antispam-prvs: <MWHPR2201MB156865EEA41FDCD910958FFEC11E0@MWHPR2201MB1568.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00514A2FE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39840400004)(136003)(376002)(396003)(346002)(366004)(199004)(189003)(2906002)(81156014)(316002)(3846002)(81166006)(36756003)(386003)(42882007)(44832011)(486006)(102836004)(52116002)(50226002)(6116002)(6506007)(476003)(186003)(305945005)(66066001)(8676002)(2616005)(26005)(99286004)(66476007)(53936002)(5660300002)(54906003)(110136005)(2501003)(14444005)(256004)(478600001)(66946007)(73956011)(6486002)(6436002)(14454004)(71200400001)(25786009)(1076003)(8936002)(7736002)(68736007)(4326008)(6512007)(66446008)(71190400001)(64756008)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR2201MB1568;H:MWHPR2201MB1277.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XqqjY1uysbROGyimiHxb++OQpQx2uI236Xmr20aE3ZqeeNoudGylPeCPOZ+aZN5se2ZK9aOLnRBCDzTVc+n6cnlugxwLUFdRFEOx+WUWJoWkwmmOQLkgkufI+Ag+E6TffBURxY6TWj/3rN0DmhZY6gC8aJViGWbsNDDYoWrrd2Z9A9JuQRD1RKVd2jEl29gZIdB1beiocjbGtz+jeg3Q3Z0ynqFJV1r+r7G1Q7Qnf2KRYvULV7n2H7V7rcceRiZOY44XJ9FvzGYaFRfYGHomkyjcuuZORmiN6AVebHIKlSEfb+bFvs+vzvvFPy68fB8PGCkqX8ITe+Wug0gsOKbtNdrg1PzwGUDSwNTe10mYBLEkbtpP4g1qWFKmED9Tfx9RTeOTWreUGhp3CoS5yi8xjvF2nHUHiI/IToCsPUZyOIY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b77b9cd-799d-458d-aa96-08d6e38d7509
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2019 16:56:41.8930
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pburton@wavecomp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1568
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VGhlIE1JUFMgR0lDIGNvbnRhaW5zIGEgYmxvY2sgb2YgcmVnaXN0ZXJzIHVzZWQgdG8gbWFwIGxv
Y2FsIGludGVycnVwdHMNCnRvIGEgcGFydGljdWxhciBDUFUgaW50ZXJydXB0IHBpbi4gU2luY2Ug
dGhlc2UgcmVnaXN0ZXJzIGFyZSBmb3VuZCBhdCBhDQpjb25zZWN1dGl2ZSByYW5nZSBvZiBhZGRy
ZXNzZXMgd2UgYWNjZXNzIHRoZW0gdXNpbmcgYW4gaW5kZXgsIHZpYSB0aGUNCihyZWFkfHdyaXRl
KV9naWNfdltsb11fbWFwIGFjY2Vzc29yIGZ1bmN0aW9ucy4gV2UgY3VycmVudGx5IHVzZSB2YWx1
ZXMNCmZyb20gZW51bSBtaXBzX2dpY19sb2NhbF9pbnRlcnJ1cHQgYXMgdGhvc2UgaW5kaWNlcy4N
Cg0KVW5mb3J0dW5hdGVseSB3aGlsc3QgZW51bSBtaXBzX2dpY19sb2NhbF9pbnRlcnJ1cHQgcHJv
dmlkZXMgdGhlIGNvcnJlY3QNCm9mZnNldHMgZm9yIGJpdHMgaW4gdGhlIHBlbmRpbmcgJiBtYXNr
IHJlZ2lzdGVycywgdGhlIG9yZGVyaW5nIG9mIHRoZQ0KbWFwIHJlZ2lzdGVycyBpcyBzdWJ0bHkg
ZGlmZmVyZW50Li4uIENvbXBhcmVkIHdpdGggdGhlIG9yZGVyaW5nIG9mDQpwZW5kaW5nICYgbWFz
ayBiaXRzLCB0aGUgbWFwIHJlZ2lzdGVycyBtb3ZlIHRoZSBGREMgZnJvbSB0aGUgZW5kIG9mIHRo
ZQ0KbGlzdCB0byBpbmRleCAzIGFmdGVyIHRoZSB0aW1lciBpbnRlcnJ1cHQuIEFzIGEgcmVzdWx0
IHRoZSBwZXJmb3JtYW5jZQ0KY291bnRlciAmIHNvZnR3YXJlIGludGVycnVwdHMgYXJlIHRoZXJl
Zm9yZSBhdCBpbmRpY2VzIDQtNiByYXRoZXIgdGhhbg0KaW5kaWNlcyAzLTUuDQoNCk5vdGFibHkg
dGhpcyBjYXVzZXMgcHJvYmxlbXMgd2l0aCBwZXJmb3JtYW5jZSBjb3VudGVyIGludGVycnVwdHMg
YmVpbmcNCmluY29ycmVjdGx5IG1hcHBlZCBvbiBzb21lIHN5c3RlbXMsIGFuZCBwcmVzdW1hYmx5
IHdpbGwgYWxzbyBjYXVzZQ0KcHJvYmxlbXMgZm9yIEZEQyBpbnRlcnJ1cHRzLg0KDQpJbnRyb2R1
Y2UgYSBmdW5jdGlvbiB0byBtYXAgZnJvbSBlbnVtIG1pcHNfZ2ljX2xvY2FsX2ludGVycnVwdCB0
byB0aGUNCmluZGV4IG9mIHRoZSBjb3JyZXNwb25kaW5nIG1hcCByZWdpc3RlciwgYW5kIHVzZSBp
dCB0byBlbnN1cmUgd2UgYWNjZXNzDQp0aGUgbWFwIHJlZ2lzdGVycyBmb3IgdGhlIGNvcnJlY3Qg
aW50ZXJydXB0cy4NCg0KU2lnbmVkLW9mZi1ieTogUGF1bCBCdXJ0b24gPHBhdWwuYnVydG9uQG1p
cHMuY29tPg0KRml4ZXM6IGEwZGM1Y2I1ZTMxYiAoImlycWNoaXA6IG1pcHMtZ2ljOiBTaW1wbGlm
eSBnaWNfbG9jYWxfaXJxX2RvbWFpbl9tYXAoKSIpDQpGaXhlczogZGE2MWZjZjlkNjJhICgiaXJx
Y2hpcDogbWlwcy1naWM6IFVzZSBpcnFfY3B1X29ubGluZSB0byAodW4pbWFzayBhbGwtVlAoRSkg
SVJRcyIpDQpSZXBvcnRlZC1hbmQtdGVzdGVkLWJ5OiBBcmNoZXIgWWFuIDxheWFuQHdhdmVjb21w
LmNvbT4NCkNjOiBUaG9tYXMgR2xlaXhuZXIgPHRnbHhAbGludXRyb25peC5kZT4NCkNjOiBKYXNv
biBDb29wZXIgPGphc29uQGxha2VkYWVtb24ubmV0Pg0KQ2M6IE1hcmMgWnluZ2llciA8bWFyYy56
eW5naWVyQGFybS5jb20+DQpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZyAjIHY0LjE0Kw0KLS0t
DQogYXJjaC9taXBzL2luY2x1ZGUvYXNtL21pcHMtZ2ljLmggfCAzMCArKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysNCiBkcml2ZXJzL2lycWNoaXAvaXJxLW1pcHMtZ2ljLmMgICB8ICA0ICsr
LS0NCiAyIGZpbGVzIGNoYW5nZWQsIDMyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQoN
CmRpZmYgLS1naXQgYS9hcmNoL21pcHMvaW5jbHVkZS9hc20vbWlwcy1naWMuaCBiL2FyY2gvbWlw
cy9pbmNsdWRlL2FzbS9taXBzLWdpYy5oDQppbmRleCA1NTgwNTlhOGYyMTguLjAyNzdiNTYxNTdh
ZiAxMDA2NDQNCi0tLSBhL2FyY2gvbWlwcy9pbmNsdWRlL2FzbS9taXBzLWdpYy5oDQorKysgYi9h
cmNoL21pcHMvaW5jbHVkZS9hc20vbWlwcy1naWMuaA0KQEAgLTMxNCw2ICszMTQsMzYgQEAgc3Rh
dGljIGlubGluZSBib29sIG1pcHNfZ2ljX3ByZXNlbnQodm9pZCkNCiAJcmV0dXJuIElTX0VOQUJM
RUQoQ09ORklHX01JUFNfR0lDKSAmJiBtaXBzX2dpY19iYXNlOw0KIH0NCiANCisvKioNCisgKiBt
aXBzX2dpY192eF9tYXBfcmVnKCkgLSBSZXR1cm4gR0lDX1Z4XzxpbnRyPl9NQVAgcmVnaXN0ZXIg
b2Zmc2V0DQorICogQGludHI6IEEgR0lDIGxvY2FsIGludGVycnVwdA0KKyAqDQorICogRGV0ZXJt
aW5lIHRoZSBpbmRleCBvZiB0aGUgR0lDX1ZMXzxpbnRyPl9NQVAgb3IgR0lDX1ZPXzxpbnRyPl9N
QVAgcmVnaXN0ZXINCisgKiB3aXRoaW4gdGhlIGJsb2NrIG9mIEdJQyBtYXAgcmVnaXN0ZXJzLiBU
aGlzIGlzIGFsbW9zdCB0aGUgc2FtZSBhcyB0aGUgb3JkZXINCisgKiBvZiBpbnRlcnJ1cHRzIGlu
IHRoZSBwZW5kaW5nICYgbWFzayByZWdpc3RlcnMsIGFzIHVzZWQgYnkgZW51bQ0KKyAqIG1pcHNf
Z2ljX2xvY2FsX2ludGVycnVwdCwgYnV0IG1vdmVzIHRoZSBGREMgaW50ZXJydXB0ICYgdGh1cyBv
ZmZzZXRzIHRoZQ0KKyAqIGludGVycnVwdHMgYWZ0ZXIgaXQuLi4NCisgKg0KKyAqIFJldHVybjog
VGhlIG1hcCByZWdpc3RlciBpbmRleCBjb3JyZXNwb25kaW5nIHRvIEBpbnRyLg0KKyAqDQorICog
VGhlIHJldHVybiB2YWx1ZSBpcyBzdWl0YWJsZSBmb3IgdXNlIHdpdGggdGhlIChyZWFkfHdyaXRl
KV9naWNfdltsb11fbWFwDQorICogYWNjZXNzb3IgZnVuY3Rpb25zLg0KKyAqLw0KK3N0YXRpYyBp
bmxpbmUgdW5zaWduZWQgaW50DQorbWlwc19naWNfdnhfbWFwX3JlZyhlbnVtIG1pcHNfZ2ljX2xv
Y2FsX2ludGVycnVwdCBpbnRyKQ0KK3sNCisJLyogV0QsIENvbXBhcmUgJiBUaW1lciBhcmUgMTox
ICovDQorCWlmIChpbnRyIDw9IEdJQ19MT0NBTF9JTlRfVElNRVIpDQorCQlyZXR1cm4gaW50cjsN
CisNCisJLyogRkRDIG1vdmVzIHRvIGFmdGVyIFRpbWVyLi4uICovDQorCWlmIChpbnRyID09IEdJ
Q19MT0NBTF9JTlRfRkRDKQ0KKwkJcmV0dXJuIEdJQ19MT0NBTF9JTlRfVElNRVIgKyAxOw0KKw0K
KwkvKiBBcyBhIHJlc3VsdCBldmVyeXRoaW5nIGVsc2UgaXMgb2Zmc2V0IGJ5IDEgKi8NCisJcmV0
dXJuIGludHIgKyAxOw0KK30NCisNCiAvKioNCiAgKiBnaWNfZ2V0X2MwX2NvbXBhcmVfaW50KCkg
LSBSZXR1cm4gY3AwIGNvdW50L2NvbXBhcmUgaW50ZXJydXB0IHZpcnENCiAgKg0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvaXJxY2hpcC9pcnEtbWlwcy1naWMuYyBiL2RyaXZlcnMvaXJxY2hpcC9pcnEt
bWlwcy1naWMuYw0KaW5kZXggZDMyMjY4Y2MxMTc0Li5mMzk4NTQ2OWMyMjEgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL2lycWNoaXAvaXJxLW1pcHMtZ2ljLmMNCisrKyBiL2RyaXZlcnMvaXJxY2hpcC9p
cnEtbWlwcy1naWMuYw0KQEAgLTM4OCw3ICszODgsNyBAQCBzdGF0aWMgdm9pZCBnaWNfYWxsX3Zw
ZXNfaXJxX2NwdV9vbmxpbmUoc3RydWN0IGlycV9kYXRhICpkKQ0KIAlpbnRyID0gR0lDX0hXSVJR
X1RPX0xPQ0FMKGQtPmh3aXJxKTsNCiAJY2QgPSBpcnFfZGF0YV9nZXRfaXJxX2NoaXBfZGF0YShk
KTsNCiANCi0Jd3JpdGVfZ2ljX3ZsX21hcChpbnRyLCBjZC0+bWFwKTsNCisJd3JpdGVfZ2ljX3Zs
X21hcChtaXBzX2dpY192eF9tYXBfcmVnKGludHIpLCBjZC0+bWFwKTsNCiAJaWYgKGNkLT5tYXNr
KQ0KIAkJd3JpdGVfZ2ljX3ZsX3NtYXNrKEJJVChpbnRyKSk7DQogfQ0KQEAgLTUxNyw3ICs1MTcs
NyBAQCBzdGF0aWMgaW50IGdpY19pcnFfZG9tYWluX21hcChzdHJ1Y3QgaXJxX2RvbWFpbiAqZCwg
dW5zaWduZWQgaW50IHZpcnEsDQogCXNwaW5fbG9ja19pcnFzYXZlKCZnaWNfbG9jaywgZmxhZ3Mp
Ow0KIAlmb3JfZWFjaF9vbmxpbmVfY3B1KGNwdSkgew0KIAkJd3JpdGVfZ2ljX3ZsX290aGVyKG1p
cHNfY21fdnBfaWQoY3B1KSk7DQotCQl3cml0ZV9naWNfdm9fbWFwKGludHIsIG1hcCk7DQorCQl3
cml0ZV9naWNfdm9fbWFwKG1pcHNfZ2ljX3Z4X21hcF9yZWcoaW50ciksIG1hcCk7DQogCX0NCiAJ
c3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmZ2ljX2xvY2ssIGZsYWdzKTsNCiANCi0tIA0KMi4yMS4w
DQoNCg==
