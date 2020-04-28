Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC18F1BB754
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 09:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgD1HUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 03:20:02 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2116 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726256AbgD1HUC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 03:20:02 -0400
Received: from lhreml723-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 63BC56160F22BE4F602B;
        Tue, 28 Apr 2020 08:20:00 +0100 (IST)
Received: from fraeml705-chm.china.huawei.com (10.206.15.54) by
 lhreml723-chm.china.huawei.com (10.201.108.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1913.5; Tue, 28 Apr 2020 08:19:59 +0100
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml705-chm.china.huawei.com (10.206.15.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Tue, 28 Apr 2020 09:19:59 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.1913.007;
 Tue, 28 Apr 2020 09:19:59 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     David Laight <David.Laight@ACULAB.COM>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "rgoldwyn@suse.de" <rgoldwyn@suse.de>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        Krzysztof Struczynski <krzysztof.struczynski@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 3/6] ima: Fix ima digest hash table key calculation
Thread-Topic: [PATCH v2 3/6] ima: Fix ima digest hash table key calculation
Thread-Index: AQHWHH8K4uf8EKnxYkeHh4WY3Jdlg6iMq38AgAA0TFCAAAXnAIABO/Wg
Date:   Tue, 28 Apr 2020 07:19:59 +0000
Message-ID: <c998edbed55d4fe78df9a3b224dd0101@huawei.com>
References: <20200427102900.18887-1-roberto.sassu@huawei.com>
 <20200427102900.18887-3-roberto.sassu@huawei.com>
 <84ecd8f2576849b29876448df66824fc@AcuMS.aculab.com>
 <90e19242fd8445cf93728c0946c03c19@huawei.com>
 <5786ad88cd184e5791bc285d5cac6ecc@AcuMS.aculab.com>
In-Reply-To: <5786ad88cd184e5791bc285d5cac6ecc@AcuMS.aculab.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.19.165]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYXZpZCBMYWlnaHQgW21haWx0
bzpEYXZpZC5MYWlnaHRAQUNVTEFCLkNPTV0NCj4gU2VudDogTW9uZGF5LCBBcHJpbCAyNywgMjAy
MCA0OjI4IFBNDQo+IFRvOiBSb2JlcnRvIFNhc3N1IDxyb2JlcnRvLnNhc3N1QGh1YXdlaS5jb20+
OyB6b2hhckBsaW51eC5pYm0uY29tOw0KPiByZ29sZHd5bkBzdXNlLmRlDQo+IENjOiBsaW51eC1p
bnRlZ3JpdHlAdmdlci5rZXJuZWwub3JnOyBsaW51eC1zZWN1cml0eS1tb2R1bGVAdmdlci5rZXJu
ZWwub3JnOw0KPiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBTaWx2aXUgVmxhc2NlYW51
DQo+IDxTaWx2aXUuVmxhc2NlYW51QGh1YXdlaS5jb20+OyBLcnp5c3p0b2YgU3RydWN6eW5za2kN
Cj4gPGtyenlzenRvZi5zdHJ1Y3p5bnNraUBodWF3ZWkuY29tPjsgc3RhYmxlQHZnZXIua2VybmVs
Lm9yZw0KPiBTdWJqZWN0OiBSRTogW1BBVENIIHYyIDMvNl0gaW1hOiBGaXggaW1hIGRpZ2VzdCBo
YXNoIHRhYmxlIGtleSBjYWxjdWxhdGlvbg0KPiANCj4gRnJvbTogUm9iZXJ0byBTYXNzdQ0KPiA+
IFNlbnQ6IDI3IEFwcmlsIDIwMjAgMTM6NTENCj4gLi4uDQo+ID4gPiA+IC1zdGF0aWMgaW5saW5l
IHVuc2lnbmVkIGxvbmcgaW1hX2hhc2hfa2V5KHU4ICpkaWdlc3QpDQo+ID4gPiA+ICtzdGF0aWMg
aW5saW5lIHVuc2lnbmVkIGludCBpbWFfaGFzaF9rZXkodTggKmRpZ2VzdCkNCj4gPiA+ID4gIHsN
Cj4gPiA+ID4gLQlyZXR1cm4gaGFzaF9sb25nKCpkaWdlc3QsIElNQV9IQVNIX0JJVFMpOw0KPiA+
ID4gPiArCXJldHVybiAoKih1bnNpZ25lZCBpbnQgKilkaWdlc3QgJSBJTUFfTUVBU1VSRV9IVEFC
TEVfU0laRSk7DQo+ID4gPg0KPiA+ID4gVGhhdCBhbG1vc3QgY2VydGFpbmx5IGlzbid0IHJpZ2h0
Lg0KPiA+ID4gSXQgZmFsbHMgZm91bCBvZiB0aGUgKihpbnRlZ2VyX3R5cGUgKilwdHIgYmVpbmcg
YWxtb3N0IGFsd2F5cyB3cm9uZy4NCj4gPg0KPiA+IEkgZGlkbid0IGZpbmQgdGhlIHByb2JsZW0u
IENhbiB5b3UgcGxlYXNlIGV4cGxhaW4/DQo+IA0KPiBUaGUgZ2VuZXJhbCBwcm9ibGVtIHdpdGgg
KihpbnRfdHlwZSAqKXB0ciBpcyB0aGF0IGl0IGRvZXMgY29tcGxldGVseQ0KPiB0aGUgd3Jvbmcg
dGhpbmcgaWYgJ3B0cicgaXMgdGhlIGFkZHJlc3Mgb2YgYSBsYXJnZXIgaW50ZWdlciB0eXBlIG9u
DQo+IGEgYmlnLWVuZGlhbiBzeXN0ZW0uDQo+IFlvdSBtYXkgYWxzbyBnZXQgYSBtaXNhbGlnbmVk
IGFjY2VzcyB0cmFwLg0KPiANCj4gSW4gdGhpcyBjYXNlIEkgZ3Vlc3MgdGhhdCBkaWdlc3QgaXMg
YWN0dWFsbHkgdThbU0hBMV9ESUdFU1RfU0laRV0uDQo+IE1heWJlIHdoYXQgeW91IHNob3VsZCBy
ZXR1cm4gaXM6DQo+IAkoZGlnZXN0WzBdIHwgZGlnZXN0WzFdIDw8IDgpICUgSU1BX01FQVNVUkVf
SFRBQkxFX1NJWkU7DQo+IGFuZCBjb21tZW50IHRoYXQgdGhlcmUgaXMgbm8gcG9pbnQgdGFraW5n
IGEgaGFzaCBvZiBwYXJ0IG9mDQo+IGEgU0hBMSBkaWdlc3QuDQoNCk9rLCB0aGFua3MuDQoNClJv
YmVydG8NCg0KSFVBV0VJIFRFQ0hOT0xPR0lFUyBEdWVzc2VsZG9yZiBHbWJILCBIUkIgNTYwNjMN
Ck1hbmFnaW5nIERpcmVjdG9yOiBMaSBQZW5nLCBMaSBKaWFuLCBTaGkgWWFubGkNCg0KDQo+IAlE
YXZpZA0KPiANCj4gLQ0KPiBSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9h
ZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywNCj4gTUsxIDFQVCwgVUsNCj4gUmVnaXN0cmF0
aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==
