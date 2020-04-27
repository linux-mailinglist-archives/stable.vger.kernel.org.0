Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D6D1BA3D6
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 14:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgD0Mue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 08:50:34 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2113 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726769AbgD0Mue (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Apr 2020 08:50:34 -0400
Received: from lhreml706-cah.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 2C9E0CD18E7AF85C7D1E;
        Mon, 27 Apr 2020 13:50:32 +0100 (IST)
Received: from fraeml704-chm.china.huawei.com (10.206.15.53) by
 lhreml706-cah.china.huawei.com (10.201.108.47) with Microsoft SMTP Server
 (TLS) id 14.3.487.0; Mon, 27 Apr 2020 13:50:31 +0100
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Mon, 27 Apr 2020 14:50:30 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.1913.007;
 Mon, 27 Apr 2020 14:50:31 +0200
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
Thread-Index: AQHWHH8K4uf8EKnxYkeHh4WY3Jdlg6iMq38AgAA0TFA=
Date:   Mon, 27 Apr 2020 12:50:30 +0000
Message-ID: <90e19242fd8445cf93728c0946c03c19@huawei.com>
References: <20200427102900.18887-1-roberto.sassu@huawei.com>
 <20200427102900.18887-3-roberto.sassu@huawei.com>
 <84ecd8f2576849b29876448df66824fc@AcuMS.aculab.com>
In-Reply-To: <84ecd8f2576849b29876448df66824fc@AcuMS.aculab.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.23.166]
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
MCAxOjAwIFBNDQo+IFRvOiBSb2JlcnRvIFNhc3N1IDxyb2JlcnRvLnNhc3N1QGh1YXdlaS5jb20+
OyB6b2hhckBsaW51eC5pYm0uY29tOw0KPiByZ29sZHd5bkBzdXNlLmRlDQo+IENjOiBsaW51eC1p
bnRlZ3JpdHlAdmdlci5rZXJuZWwub3JnOyBsaW51eC1zZWN1cml0eS1tb2R1bGVAdmdlci5rZXJu
ZWwub3JnOw0KPiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBTaWx2aXUgVmxhc2NlYW51
DQo+IDxTaWx2aXUuVmxhc2NlYW51QGh1YXdlaS5jb20+OyBLcnp5c3p0b2YgU3RydWN6eW5za2kN
Cj4gPGtyenlzenRvZi5zdHJ1Y3p5bnNraUBodWF3ZWkuY29tPjsgc3RhYmxlQHZnZXIua2VybmVs
Lm9yZw0KPiBTdWJqZWN0OiBSRTogW1BBVENIIHYyIDMvNl0gaW1hOiBGaXggaW1hIGRpZ2VzdCBo
YXNoIHRhYmxlIGtleSBjYWxjdWxhdGlvbg0KPiANCj4gRnJvbTogUm9iZXJ0byBTYXNzdQ0KPiA+
IFNlbnQ6IDI3IEFwcmlsIDIwMjAgMTE6MjkNCj4gPiBGdW5jdGlvbiBoYXNoX2xvbmcoKSBhY2Nl
cHRzIHVuc2lnbmVkIGxvbmcsIHdoaWxlIGN1cnJlbnRseSBvbmx5IG9uZSBieXRlDQo+ID4gaXMg
cGFzc2VkIGZyb20gaW1hX2hhc2hfa2V5KCksIHdoaWNoIGNhbGN1bGF0ZXMgYSBrZXkgZm9yIGlt
YV9odGFibGUuDQo+ID4NCj4gPiBHaXZlbiB0aGF0IGhhc2hpbmcgdGhlIGRpZ2VzdCBkb2VzIG5v
dCBnaXZlIGNsZWFyIGJlbmVmaXRzIGNvbXBhcmVkIHRvDQo+ID4gdXNpbmcgdGhlIGRpZ2VzdCBp
dHNlbGYsIHJlbW92ZSBoYXNoX2xvbmcoKSBhbmQgcmV0dXJuIHRoZSBtb2R1bHVzDQo+ID4gY2Fs
Y3VsYXRlZCBvbiB0aGUgYmVnaW5uaW5nIG9mIHRoZSBkaWdlc3Qgd2l0aCB0aGUgbnVtYmVyIG9m
IHNsb3RzLiBBbHNvDQo+ID4gcmVkdWNlIHRoZSBkZXB0aCBvZiB0aGUgaGFzaCB0YWJsZSBieSBk
b3VibGluZyB0aGUgbnVtYmVyIG9mIHNsb3RzLg0KPiA+DQo+ID4gQ2M6IHN0YWJsZUB2Z2VyLmtl
cm5lbC5vcmcNCj4gPiBGaXhlczogMzMyM2VlYzkyMWVmICgiaW50ZWdyaXR5OiBJTUEgYXMgYW4g
aW50ZWdyaXR5IHNlcnZpY2UgcHJvdmlkZXIiKQ0KPiA+IENvLWRldmVsb3BlZC1ieTogUm9iZXJ0
byBTYXNzdSA8cm9iZXJ0by5zYXNzdUBodWF3ZWkuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFJv
YmVydG8gU2Fzc3UgPHJvYmVydG8uc2Fzc3VAaHVhd2VpLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5
OiBLcnp5c3p0b2YgU3RydWN6eW5za2kgPGtyenlzenRvZi5zdHJ1Y3p5bnNraUBodWF3ZWkuY29t
Pg0KPiA+IC0tLQ0KPiA+ICBzZWN1cml0eS9pbnRlZ3JpdHkvaW1hL2ltYS5oIHwgNiArKystLS0N
Cj4gPiAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4g
Pg0KPiA+IGRpZmYgLS1naXQgYS9zZWN1cml0eS9pbnRlZ3JpdHkvaW1hL2ltYS5oIGIvc2VjdXJp
dHkvaW50ZWdyaXR5L2ltYS9pbWEuaA0KPiA+IGluZGV4IDQ2N2RmZGJlYTI1Yy4uNmVlNDU4Y2Yx
MjRhIDEwMDY0NA0KPiA+IC0tLSBhL3NlY3VyaXR5L2ludGVncml0eS9pbWEvaW1hLmgNCj4gPiAr
KysgYi9zZWN1cml0eS9pbnRlZ3JpdHkvaW1hL2ltYS5oDQo+ID4gQEAgLTM2LDcgKzM2LDcgQEAg
ZW51bSB0cG1fcGNycyB7IFRQTV9QQ1IwID0gMCwgVFBNX1BDUjggPSA4IH07DQo+ID4gICNkZWZp
bmUgSU1BX0RJR0VTVF9TSVpFCQlTSEExX0RJR0VTVF9TSVpFDQo+ID4gICNkZWZpbmUgSU1BX0VW
RU5UX05BTUVfTEVOX01BWAkyNTUNCj4gPg0KPiA+IC0jZGVmaW5lIElNQV9IQVNIX0JJVFMgOQ0K
PiA+ICsjZGVmaW5lIElNQV9IQVNIX0JJVFMgMTANCj4gPiAgI2RlZmluZSBJTUFfTUVBU1VSRV9I
VEFCTEVfU0laRSAoMSA8PCBJTUFfSEFTSF9CSVRTKQ0KPiA+DQo+ID4gICNkZWZpbmUgSU1BX1RF
TVBMQVRFX0ZJRUxEX0lEX01BWF9MRU4JMTYNCj4gPiBAQCAtMTc5LDkgKzE3OSw5IEBAIHN0cnVj
dCBpbWFfaF90YWJsZSB7DQo+ID4gIH07DQo+ID4gIGV4dGVybiBzdHJ1Y3QgaW1hX2hfdGFibGUg
aW1hX2h0YWJsZTsNCj4gPg0KPiA+IC1zdGF0aWMgaW5saW5lIHVuc2lnbmVkIGxvbmcgaW1hX2hh
c2hfa2V5KHU4ICpkaWdlc3QpDQo+ID4gK3N0YXRpYyBpbmxpbmUgdW5zaWduZWQgaW50IGltYV9o
YXNoX2tleSh1OCAqZGlnZXN0KQ0KPiA+ICB7DQo+ID4gLQlyZXR1cm4gaGFzaF9sb25nKCpkaWdl
c3QsIElNQV9IQVNIX0JJVFMpOw0KPiA+ICsJcmV0dXJuICgqKHVuc2lnbmVkIGludCAqKWRpZ2Vz
dCAlIElNQV9NRUFTVVJFX0hUQUJMRV9TSVpFKTsNCj4gDQo+IFRoYXQgYWxtb3N0IGNlcnRhaW5s
eSBpc24ndCByaWdodC4NCj4gSXQgZmFsbHMgZm91bCBvZiB0aGUgKihpbnRlZ2VyX3R5cGUgKilw
dHIgYmVpbmcgYWxtb3N0IGFsd2F5cyB3cm9uZy4NCg0KSSBkaWRuJ3QgZmluZCB0aGUgcHJvYmxl
bS4gQ2FuIHlvdSBwbGVhc2UgZXhwbGFpbj8NCg0KVGhhbmtzDQoNClJvYmVydG8NCg0KSFVBV0VJ
IFRFQ0hOT0xPR0lFUyBEdWVzc2VsZG9yZiBHbWJILCBIUkIgNTYwNjMNCk1hbmFnaW5nIERpcmVj
dG9yOiBMaSBQZW5nLCBMaSBKaWFuLCBTaGkgWWFubGkNCg0KDQo+IAlEYXZpZA0KPiANCj4gLQ0K
PiBSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwg
TWlsdG9uIEtleW5lcywNCj4gTUsxIDFQVCwgVUsNCj4gUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2
IChXYWxlcykNCg0K
