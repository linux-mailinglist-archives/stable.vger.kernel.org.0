Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB892CD10
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 19:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfE1RFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 13:05:05 -0400
Received: from mail-eopbgr760129.outbound.protection.outlook.com ([40.107.76.129]:47302
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726600AbfE1RFF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 May 2019 13:05:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=wavesemi.onmicrosoft.com; s=selector1-wavesemi-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TFFrmbFA9nqARmnrdqQo+9mxZQUWcKK4+0AIgxNUaxE=;
 b=FapHvhLUQqCXUqzXk4qDKYZUoRiv69wxINPAzszS917WwzMLJbthwDOsnUHT8IAfBd1bjYu8Lnq3fqanhnTjzhIhBtcZYTSZjUnO9XCF37zPBxQ7Jr/b8F4fdCv80EkfUFj0UQ4wVilvR5D3UCIxoiPdzWN9/rcMTNqAKY/vRaI=
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com (10.174.162.17) by
 MWHPR2201MB1152.namprd22.prod.outlook.com (10.174.167.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Tue, 28 May 2019 17:05:03 +0000
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::90ff:8d19:8459:834b]) by MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::90ff:8d19:8459:834b%7]) with mapi id 15.20.1922.021; Tue, 28 May 2019
 17:05:03 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>
CC:     Paul Burton <pburton@wavecomp.com>,
        Julien Cristau <jcristau@debian.org>,
        Yunqiang Su <ysu@wavecomp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH 1/2] MIPS: Bounds check virt_addr_valid
Thread-Topic: [PATCH 1/2] MIPS: Bounds check virt_addr_valid
Thread-Index: AQHVFXd9GkRqXxEIYUuNu8zTlmfmBg==
Date:   Tue, 28 May 2019 17:05:03 +0000
Message-ID: <20190528170444.1557-1-paul.burton@mips.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0060.namprd07.prod.outlook.com
 (2603:10b6:a03:60::37) To MWHPR2201MB1277.namprd22.prod.outlook.com
 (2603:10b6:301:24::17)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.21.0
x-originating-ip: [12.94.197.246]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 373e4062-a519-4915-2a27-08d6e38ea009
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR2201MB1152;
x-ms-traffictypediagnostic: MWHPR2201MB1152:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MWHPR2201MB115219EE3F57808DE0CF87DFC11E0@MWHPR2201MB1152.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1303;
x-forefront-prvs: 00514A2FE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(376002)(39840400004)(136003)(366004)(189003)(199004)(68736007)(73956011)(2616005)(476003)(99286004)(186003)(316002)(64756008)(66446008)(66556008)(54906003)(66476007)(966005)(256004)(102836004)(478600001)(2906002)(42882007)(6506007)(14454004)(52116002)(386003)(6116002)(3846002)(81156014)(6486002)(2351001)(6916009)(81166006)(8676002)(6436002)(36756003)(5660300002)(5640700003)(50226002)(53936002)(26005)(2501003)(8936002)(25786009)(4326008)(71190400001)(71200400001)(6306002)(6512007)(66946007)(486006)(44832011)(66066001)(305945005)(1076003)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR2201MB1152;H:MWHPR2201MB1277.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LYOAGnXXNyJJ2YwU4KkRmvZ8NY37pN2KzXvMRNPw1f7QnHNEHkOyX0EbKf9V1q/mTYrnBpaNt7x+UcFsy9soH5MdvqTPS+zjmmKngotPNM9pqscjw4M3rN+4tfCIE2HM27hDYjImamy9OAHRw+RiuhWYLJ2KHw4S6XpNGhs2wk0j/MAje7yhWaTLZK3kFLlFrg9dzqrUoq4Odm5gN/RNDPUeMEOBrS7nvaIVSRYdry3TwjAKnUVhdK/PMwc4MDwxFzl9uqyRIZJPZmq45Z7I7Jt7Tzyod39NH6Okx8P5Db0lTQA0qt9oYejzPKt42hlI99ehFe/0YNe4UAnWo0h0Kxd4Iq7pdHi3kabRX3ANjDtdg6pj8GMM375NzERFbZRuaf59EQQCoSy2mn+qBaVYe+BBrhTz4Oj+zQ406rxPOUg=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 373e4062-a519-4915-2a27-08d6e38ea009
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2019 17:05:03.4334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pburton@wavecomp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1152
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VGhlIHZpcnRfYWRkcl92YWxpZCgpIGZ1bmN0aW9uIGlzIG1lYW50IHRvIHJldHVybiB0cnVlIGlm
Zg0KdmlydF90b19wYWdlKCkgd2lsbCByZXR1cm4gYSB2YWxpZCBzdHJ1Y3QgcGFnZSByZWZlcmVu
Y2UuIFRoaXMgaXMgdHJ1ZQ0KaWZmIHRoZSBhZGRyZXNzIHByb3ZpZGVkIGlzIGZvdW5kIHdpdGhp
biB0aGUgdW5tYXBwZWQgYWRkcmVzcyByYW5nZQ0KYmV0d2VlbiBQQUdFX09GRlNFVCAmIE1BUF9C
QVNFLCBidXQgd2UgZG9uJ3QgY3VycmVudGx5IGNoZWNrIGZvciB0aGF0DQpjb25kaXRpb24uIElu
c3RlYWQgd2Ugc2ltcGx5IG1hc2sgdGhlIGFkZHJlc3MgdG8gb2J0YWluIHdoYXQgd2lsbCBiZSBh
DQpwaHlzaWNhbCBhZGRyZXNzIGlmIHRoZSB2aXJ0dWFsIGFkZHJlc3MgaXMgaW5kZWVkIGluIHRo
ZSBkZXNpcmVkIHJhbmdlLA0Kc2hpZnQgaXQgdG8gZm9ybSBhIFBGTiAmIHRoZW4gY2FsbCBwZm5f
dmFsaWQoKS4gVGhpcyBjYW4gaW5jb3JyZWN0bHkNCnJldHVybiB0cnVlIGlmIGNhbGxlZCB3aXRo
IGEgdmlydHVhbCBhZGRyZXNzIHdoaWNoLCBhZnRlciBtYXNraW5nLA0KaGFwcGVucyB0byBmb3Jt
IGEgcGh5c2ljYWwgYWRkcmVzcyBjb3JyZXNwb25kaW5nIHRvIGEgdmFsaWQgUEZOLg0KDQpGb3Ig
ZXhhbXBsZSB3ZSBtYXkgdm1hbGxvYyBhbiBhZGRyZXNzIGluIHRoZSBrZXJuZWwgbWFwcGVkIHJl
Z2lvbg0Kc3RhcnRpbmcgYSBNQVBfQkFTRSAmIG9idGFpbiB0aGUgdmlydHVhbCBhZGRyZXNzOg0K
DQogIGFkZHIgPSAweGMwMDAwMDAwMDAwMDIwMDANCg0KV2hlbiBtYXNrZWQgYnkgdmlydF90b19w
aHlzKCksIHdoaWNoIHVzZXMgX19wYSgpICYgaW4gdHVybiBDUEhZU0FERFIoKSwNCndlIG9idGFp
biB0aGUgZm9sbG93aW5nIChib2d1cykgcGh5c2ljYWwgYWRkcmVzczoNCg0KICBhZGRyID0gMHgy
MDAwDQoNCkluIGEgY29tbW9uIHN5c3RlbSB3aXRoIFBIWVNfT0ZGU0VUPTAgdGhpcyB3aWxsIGNv
cnJlc3BvbmQgdG8gYSB2YWxpZA0Kc3RydWN0IHBhZ2Ugd2hpY2ggc2hvdWxkIHJlYWxseSBiZSBh
Y2Nlc3NlZCBieSB2aXJ0dWFsIGFkZHJlc3MNClBBR0VfT0ZGU0VUKzB4MjAwMCwgY2F1c2luZyB2
aXJ0X2FkZHJfdmFsaWQoKSB0byBpbmNvcnJlY3RseSByZXR1cm4gMQ0KaW5kaWNhdGluZyB0aGF0
IHRoZSBvcmlnaW5hbCBhZGRyZXNzIGNvcnJlc3BvbmRzIHRvIGEgc3RydWN0IHBhZ2UuDQoNClRo
aXMgaXMgZXF1aXZhbGVudCB0byB0aGUgQVJNNjQgY2hhbmdlIG1hZGUgaW4gY29tbWl0IGNhMjE5
NDUyYzZiOA0KKCJhcm02NDogQ29ycmVjdGx5IGJvdW5kcyBjaGVjayB2aXJ0X2FkZHJfdmFsaWQi
KS4NCg0KVGhpcyBmaXhlcyBmYWxsb3V0IHdoZW4gaGFyZGVuZWQgdXNlcmNvcHkgaXMgZW5hYmxl
ZCBjYXVzZWQgYnkgdGhlDQpyZWxhdGVkIGNvbW1pdCA1MTdlMWZiZWI2NWYgKCJtbS91c2VyY29w
eTogRHJvcCBleHRyYQ0KaXNfdm1hbGxvY19vcl9tb2R1bGUoKSBjaGVjayIpIHdoaWNoIHJlbW92
ZWQgYSBjaGVjayBmb3IgdGhlIHZtYWxsb2MNCnJhbmdlIHRoYXQgd2FzIHByZXNlbnQgZnJvbSB0
aGUgaW50cm9kdWN0aW9uIG9mIHRoZSBoYXJkZW5lZCB1c2VyY29weQ0KZmVhdHVyZS4NCg0KU2ln
bmVkLW9mZi1ieTogUGF1bCBCdXJ0b24gPHBhdWwuYnVydG9uQG1pcHMuY29tPg0KUmVmZXJlbmNl
czogY2EyMTk0NTJjNmI4ICgiYXJtNjQ6IENvcnJlY3RseSBib3VuZHMgY2hlY2sgdmlydF9hZGRy
X3ZhbGlkIikNClJlZmVyZW5jZXM6IDUxN2UxZmJlYjY1ZiAoIm1tL3VzZXJjb3B5OiBEcm9wIGV4
dHJhIGlzX3ZtYWxsb2Nfb3JfbW9kdWxlKCkgY2hlY2siKQ0KUmVwb3J0ZWQtYnk6IEp1bGllbiBD
cmlzdGF1IDxqY3Jpc3RhdUBkZWJpYW4ub3JnPg0KVGVzdGVkLWJ5OiBZdW5RaWFuZyBTdSA8eXN1
QHdhdmVjb21wLmNvbT4NClVSTDogaHR0cHM6Ly9idWdzLmRlYmlhbi5vcmcvY2dpLWJpbi9idWdy
ZXBvcnQuY2dpP2J1Zz05MjkzNjYNCkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnICMgdjQuMTIr
DQotLS0NCg0KIGFyY2gvbWlwcy9tbS9tbWFwLmMgfCA1ICsrKysrDQogMSBmaWxlIGNoYW5nZWQs
IDUgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEvYXJjaC9taXBzL21tL21tYXAuYyBiL2Fy
Y2gvbWlwcy9tbS9tbWFwLmMNCmluZGV4IDJmNjE2ZWJlYjdlMC4uNzc1NWExZmFkMDVhIDEwMDY0
NA0KLS0tIGEvYXJjaC9taXBzL21tL21tYXAuYw0KKysrIGIvYXJjaC9taXBzL21tL21tYXAuYw0K
QEAgLTIwMyw2ICsyMDMsMTEgQEAgdW5zaWduZWQgbG9uZyBhcmNoX3JhbmRvbWl6ZV9icmsoc3Ry
dWN0IG1tX3N0cnVjdCAqbW0pDQogDQogaW50IF9fdmlydF9hZGRyX3ZhbGlkKGNvbnN0IHZvbGF0
aWxlIHZvaWQgKmthZGRyKQ0KIHsNCisJdW5zaWduZWQgbG9uZyB2YWRkciA9ICh1bnNpZ25lZCBs
b25nKXZhZGRyOw0KKw0KKwlpZiAoKHZhZGRyIDwgUEFHRV9PRkZTRVQpIHx8ICh2YWRkciA+PSBN
QVBfQkFTRSkpDQorCQlyZXR1cm4gMDsNCisNCiAJcmV0dXJuIHBmbl92YWxpZChQRk5fRE9XTih2
aXJ0X3RvX3BoeXMoa2FkZHIpKSk7DQogfQ0KIEVYUE9SVF9TWU1CT0xfR1BMKF9fdmlydF9hZGRy
X3ZhbGlkKTsNCi0tIA0KMi4yMS4wDQoNCg==
