Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBC682E63B
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 22:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbfE2Ufd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 16:35:33 -0400
Received: from mail-eopbgr790111.outbound.protection.outlook.com ([40.107.79.111]:48784
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726189AbfE2Ufc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 16:35:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=wavesemi.onmicrosoft.com; s=selector1-wavesemi-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L2k0n3qIbNr6ZM4f/coYp/H7qaweEG8hU+uCm65qpEk=;
 b=lkClLO4vUqine1+YidD4J2XCHbv9TfZJ7xF9bVUjJGQZO6FCv4T06Xo2BwM2xgF5mSJJYhjmaUqjT0tTPs5ucHqgAHJ97XUzwrT5TOfrR35VpcPlqEEctmM02o7feuwbGVZlykTEshkExV2jIBPc0g1qS4fmNg3cEvkbm+Me2lE=
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com (10.174.162.17) by
 MWHPR2201MB1071.namprd22.prod.outlook.com (10.174.169.145) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Wed, 29 May 2019 20:35:29 +0000
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::90ff:8d19:8459:834b]) by MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::90ff:8d19:8459:834b%7]) with mapi id 15.20.1922.021; Wed, 29 May 2019
 20:35:29 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     Paul Burton <pburton@wavecomp.com>
CC:     "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        Paul Burton <pburton@wavecomp.com>,
        Julien Cristau <jcristau@debian.org>,
        Yunqiang Su <ysu@wavecomp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>
Subject: Re: [PATCH 1/2] MIPS: Bounds check virt_addr_valid
Thread-Topic: [PATCH 1/2] MIPS: Bounds check virt_addr_valid
Thread-Index: AQHVFXd9GkRqXxEIYUuNu8zTlmfmBqaCkSqA
Date:   Wed, 29 May 2019 20:35:28 +0000
Message-ID: <MWHPR2201MB1277D5885A96C71221415DC2C11F0@MWHPR2201MB1277.namprd22.prod.outlook.com>
References: <20190528170444.1557-1-paul.burton@mips.com>
In-Reply-To: <20190528170444.1557-1-paul.burton@mips.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR08CA0024.namprd08.prod.outlook.com
 (2603:10b6:a03:100::37) To MWHPR2201MB1277.namprd22.prod.outlook.com
 (2603:10b6:301:24::17)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.94.197.246]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47fe38aa-9776-45b1-269d-08d6e4752fec
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR2201MB1071;
x-ms-traffictypediagnostic: MWHPR2201MB1071:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MWHPR2201MB1071B053ED450F3A8061C8C9C11F0@MWHPR2201MB1071.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0052308DC6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(396003)(376002)(39850400004)(136003)(199004)(189003)(54906003)(26005)(74316002)(6116002)(2906002)(66066001)(71200400001)(7736002)(52536014)(102836004)(5660300002)(25786009)(486006)(66476007)(66556008)(64756008)(66446008)(71190400001)(3846002)(476003)(11346002)(73956011)(305945005)(44832011)(186003)(66946007)(446003)(42882007)(81156014)(7696005)(76176011)(52116002)(478600001)(14454004)(53936002)(4326008)(256004)(6246003)(316002)(6862004)(33656002)(8936002)(229853002)(9686003)(8676002)(6436002)(966005)(6306002)(68736007)(6506007)(99286004)(55016002)(81166006)(386003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR2201MB1071;H:MWHPR2201MB1277.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fvI/jIRBz7iws76H4frUlMETgl85hmwyzygk7q8NqYEeh+Z7N9IWzZybrPeLbdD9JBr1BnbnuepmZsHNusZ5GPlc/7EHBys63f45/TlrniZo9J27cjxtE2u5VwZsbs+nTo80WkCwXi9cbPD575AMMx/CF77OBlv1/b0xjr0aJqpKS6jm/pj7aR8q1ozZRrrrqLSbc/hPTP+/mZ6Rbrin/YD48X4mYfa3JqiacjKRaXLmJrmMA7NekkN2YFQKKKRwy4ajKM8334a99Du2GdZ/p96WgFjqn9sv/BLShb47KHUPX3PRROfTsiSTVj6L9Bw7Jyojm2UQqmQQQXFXzt/K0juvdDpxQGKq4lIqzbKkNlBW5O5j7iVw/NBUrDCCat2Y6GyAY9Myq6FO0wTNwFDi2ROuQuJpl32PYeH0v42T+xU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47fe38aa-9776-45b1-269d-08d6e4752fec
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2019 20:35:28.9719
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pburton@wavecomp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1071
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8sDQoNClBhdWwgQnVydG9uIHdyb3RlOg0KPiBUaGUgdmlydF9hZGRyX3ZhbGlkKCkgZnVu
Y3Rpb24gaXMgbWVhbnQgdG8gcmV0dXJuIHRydWUgaWZmDQo+IHZpcnRfdG9fcGFnZSgpIHdpbGwg
cmV0dXJuIGEgdmFsaWQgc3RydWN0IHBhZ2UgcmVmZXJlbmNlLiBUaGlzIGlzIHRydWUNCj4gaWZm
IHRoZSBhZGRyZXNzIHByb3ZpZGVkIGlzIGZvdW5kIHdpdGhpbiB0aGUgdW5tYXBwZWQgYWRkcmVz
cyByYW5nZQ0KPiBiZXR3ZWVuIFBBR0VfT0ZGU0VUICYgTUFQX0JBU0UsIGJ1dCB3ZSBkb24ndCBj
dXJyZW50bHkgY2hlY2sgZm9yIHRoYXQNCj4gY29uZGl0aW9uLiBJbnN0ZWFkIHdlIHNpbXBseSBt
YXNrIHRoZSBhZGRyZXNzIHRvIG9idGFpbiB3aGF0IHdpbGwgYmUgYQ0KPiBwaHlzaWNhbCBhZGRy
ZXNzIGlmIHRoZSB2aXJ0dWFsIGFkZHJlc3MgaXMgaW5kZWVkIGluIHRoZSBkZXNpcmVkIHJhbmdl
LA0KPiBzaGlmdCBpdCB0byBmb3JtIGEgUEZOICYgdGhlbiBjYWxsIHBmbl92YWxpZCgpLiBUaGlz
IGNhbiBpbmNvcnJlY3RseQ0KPiByZXR1cm4gdHJ1ZSBpZiBjYWxsZWQgd2l0aCBhIHZpcnR1YWwg
YWRkcmVzcyB3aGljaCwgYWZ0ZXIgbWFza2luZywNCj4gaGFwcGVucyB0byBmb3JtIGEgcGh5c2lj
YWwgYWRkcmVzcyBjb3JyZXNwb25kaW5nIHRvIGEgdmFsaWQgUEZOLg0KPiANCj4gRm9yIGV4YW1w
bGUgd2UgbWF5IHZtYWxsb2MgYW4gYWRkcmVzcyBpbiB0aGUga2VybmVsIG1hcHBlZCByZWdpb24N
Cj4gc3RhcnRpbmcgYSBNQVBfQkFTRSAmIG9idGFpbiB0aGUgdmlydHVhbCBhZGRyZXNzOg0KPiAN
Cj4gYWRkciA9IDB4YzAwMDAwMDAwMDAwMjAwMA0KPiANCj4gV2hlbiBtYXNrZWQgYnkgdmlydF90
b19waHlzKCksIHdoaWNoIHVzZXMgX19wYSgpICYgaW4gdHVybiBDUEhZU0FERFIoKSwNCj4gd2Ug
b2J0YWluIHRoZSBmb2xsb3dpbmcgKGJvZ3VzKSBwaHlzaWNhbCBhZGRyZXNzOg0KPiANCj4gYWRk
ciA9IDB4MjAwMA0KPiANCj4gSW4gYSBjb21tb24gc3lzdGVtIHdpdGggUEhZU19PRkZTRVQ9MCB0
aGlzIHdpbGwgY29ycmVzcG9uZCB0byBhIHZhbGlkDQo+IHN0cnVjdCBwYWdlIHdoaWNoIHNob3Vs
ZCByZWFsbHkgYmUgYWNjZXNzZWQgYnkgdmlydHVhbCBhZGRyZXNzDQo+IFBBR0VfT0ZGU0VUKzB4
MjAwMCwgY2F1c2luZyB2aXJ0X2FkZHJfdmFsaWQoKSB0byBpbmNvcnJlY3RseSByZXR1cm4gMQ0K
PiBpbmRpY2F0aW5nIHRoYXQgdGhlIG9yaWdpbmFsIGFkZHJlc3MgY29ycmVzcG9uZHMgdG8gYSBz
dHJ1Y3QgcGFnZS4NCj4gDQo+IFRoaXMgaXMgZXF1aXZhbGVudCB0byB0aGUgQVJNNjQgY2hhbmdl
IG1hZGUgaW4gY29tbWl0IGNhMjE5NDUyYzZiOA0KPiAoImFybTY0OiBDb3JyZWN0bHkgYm91bmRz
IGNoZWNrIHZpcnRfYWRkcl92YWxpZCIpLg0KPiANCj4gVGhpcyBmaXhlcyBmYWxsb3V0IHdoZW4g
aGFyZGVuZWQgdXNlcmNvcHkgaXMgZW5hYmxlZCBjYXVzZWQgYnkgdGhlDQo+IHJlbGF0ZWQgY29t
bWl0IDUxN2UxZmJlYjY1ZiAoIm1tL3VzZXJjb3B5OiBEcm9wIGV4dHJhDQo+IGlzX3ZtYWxsb2Nf
b3JfbW9kdWxlKCkgY2hlY2siKSB3aGljaCByZW1vdmVkIGEgY2hlY2sgZm9yIHRoZSB2bWFsbG9j
DQo+IHJhbmdlIHRoYXQgd2FzIHByZXNlbnQgZnJvbSB0aGUgaW50cm9kdWN0aW9uIG9mIHRoZSBo
YXJkZW5lZCB1c2VyY29weQ0KPiBmZWF0dXJlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogUGF1bCBC
dXJ0b24gPHBhdWwuYnVydG9uQG1pcHMuY29tPg0KPiBSZWZlcmVuY2VzOiBjYTIxOTQ1MmM2Yjgg
KCJhcm02NDogQ29ycmVjdGx5IGJvdW5kcyBjaGVjayB2aXJ0X2FkZHJfdmFsaWQiKQ0KPiBSZWZl
cmVuY2VzOiA1MTdlMWZiZWI2NWYgKCJtbS91c2VyY29weTogRHJvcCBleHRyYSBpc192bWFsbG9j
X29yX21vZHVsZSgpIGNoZWNrIikNCj4gUmVwb3J0ZWQtYnk6IEp1bGllbiBDcmlzdGF1IDxqY3Jp
c3RhdUBkZWJpYW4ub3JnPg0KPiBUZXN0ZWQtYnk6IFl1blFpYW5nIFN1IDx5c3VAd2F2ZWNvbXAu
Y29tPg0KPiBVUkw6IGh0dHBzOi8vYnVncy5kZWJpYW4ub3JnL2NnaS1iaW4vYnVncmVwb3J0LmNn
aT9idWc9OTI5MzY2DQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnICMgdjQuMTIrDQo+IFJl
dmlld2VkLWJ5OiBQaGlsaXBwZSBNYXRoaWV1LURhdWTDg8KpIDxmNGJ1Z0BhbXNhdC5vcmc+DQoN
ClNlcmllcyBhcHBsaWVkIHRvIG1pcHMtZml4ZXMuDQoNClRoYW5rcywNCiAgICBQYXVsDQoNClsg
VGhpcyBtZXNzYWdlIHdhcyBhdXRvLWdlbmVyYXRlZDsgaWYgeW91IGJlbGlldmUgYW55dGhpbmcg
aXMgaW5jb3JyZWN0DQogIHRoZW4gcGxlYXNlIGVtYWlsIHBhdWwuYnVydG9uQG1pcHMuY29tIHRv
IHJlcG9ydCBpdC4gXQ0K
