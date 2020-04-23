Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8967C1B5905
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 12:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgDWKVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 06:21:08 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2087 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725854AbgDWKVH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 06:21:07 -0400
Received: from lhreml737-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id BEFCE37216D8C8C0F9D0;
        Thu, 23 Apr 2020 11:21:04 +0100 (IST)
Received: from fraeml703-chm.china.huawei.com (10.206.15.52) by
 lhreml737-chm.china.huawei.com (10.201.108.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1913.5; Thu, 23 Apr 2020 11:21:04 +0100
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml703-chm.china.huawei.com (10.206.15.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Thu, 23 Apr 2020 12:21:03 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.1913.007;
 Thu, 23 Apr 2020 12:21:03 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Mimi Zohar <zohar@linux.ibm.com>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Krzysztof Struczynski <krzysztof.struczynski@huawei.com>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 3/5] ima: Fix ima digest hash table key calculation
Thread-Topic: [PATCH 3/5] ima: Fix ima digest hash table key calculation
Thread-Index: AQHWAsCL0WxU1zQQXUO+TcKy4wW9saiFqfKAgAD8PeA=
Date:   Thu, 23 Apr 2020 10:21:03 +0000
Message-ID: <11984a05a5624f64aed1ec6b0d0b75ff@huawei.com>
References: <20200325161116.7082-1-roberto.sassu@huawei.com>
         <20200325161116.7082-3-roberto.sassu@huawei.com>
 <1587588987.5165.20.camel@linux.ibm.com>
In-Reply-To: <1587588987.5165.20.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.15.0]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCkhVQVdFSSBURUNITk9MT0dJRVMgRHVlc3NlbGRvcmYgR21iSCwgSFJCIDU2MDYzDQpNYW5h
Z2luZyBEaXJlY3RvcjogTGkgUGVuZywgTGkgSmlhbiwgU2hpIFlhbmxpDQoNCg0KPiAtLS0tLU9y
aWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNaW1pIFpvaGFyIFttYWlsdG86em9oYXJAbGlu
dXguaWJtLmNvbV0NCj4gU2VudDogV2VkbmVzZGF5LCBBcHJpbCAyMiwgMjAyMCAxMDo1NiBQTQ0K
PiBUbzogUm9iZXJ0byBTYXNzdSA8cm9iZXJ0by5zYXNzdUBodWF3ZWkuY29tPg0KPiBDYzogbGlu
dXgtaW50ZWdyaXR5QHZnZXIua2VybmVsLm9yZzsgbGludXgtc2VjdXJpdHktbW9kdWxlQHZnZXIu
a2VybmVsLm9yZzsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgS3J6eXN6dG9mIFN0
cnVjenluc2tpDQo+IDxrcnp5c3p0b2Yuc3RydWN6eW5za2lAaHVhd2VpLmNvbT47IFNpbHZpdSBW
bGFzY2VhbnUNCj4gPFNpbHZpdS5WbGFzY2VhbnVAaHVhd2VpLmNvbT47IHN0YWJsZUB2Z2VyLmtl
cm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCAzLzVdIGltYTogRml4IGltYSBkaWdlc3Qg
aGFzaCB0YWJsZSBrZXkgY2FsY3VsYXRpb24NCj4gDQo+IEhpIFJvYmVydG8sIEtyc3lzenRvZiwN
Cj4gDQo+IE9uIFdlZCwgMjAyMC0wMy0yNSBhdCAxNzoxMSArMDEwMCwgUm9iZXJ0byBTYXNzdSB3
cm90ZToNCj4gPiBGcm9tOiBLcnp5c3p0b2YgU3RydWN6eW5za2kgPGtyenlzenRvZi5zdHJ1Y3p5
bnNraUBodWF3ZWkuY29tPg0KPiA+DQo+ID4gRnVuY3Rpb24gaGFzaF9sb25nKCkgYWNjZXB0cyB1
bnNpZ25lZCBsb25nLCB3aGlsZSBjdXJyZW50bHkgb25seSBvbmUgYnl0ZQ0KPiA+IGlzIHBhc3Nl
ZCBmcm9tIGltYV9oYXNoX2tleSgpLCB3aGljaCBjYWxjdWxhdGVzIGEga2V5IGZvciBpbWFfaHRh
YmxlLg0KPiBVc2UNCj4gPiBtb3JlIGJ5dGVzIHRvIGF2b2lkIGZyZXF1ZW50IGNvbGxpc2lvbnMu
DQo+ID4NCj4gPiBMZW5ndGggb2YgdGhlIGJ1ZmZlciBpcyBub3QgZXhwbGljaXRseSBwYXNzZWQg
YXMgYSBmdW5jdGlvbiBwYXJhbWV0ZXIsDQo+ID4gYmVjYXVzZSB0aGlzIGZ1bmN0aW9uIGV4cGVj
dHMgYSBkaWdlc3Qgd2hvc2UgbGVuZ3RoIGlzIGdyZWF0ZXIgdGhhbiB0aGUNCj4gPiBzaXplIG9m
IHVuc2lnbmVkIGxvbmcuDQo+IA0KPiBTb21laG93IEkgbWlzc2VkIHRoZSBvcmlnaW5hbCByZXBv
cnQgb2YgdGhpcyBwcm9ibGVtwqBodHRwczovL2xvcmUua2Vybg0KPiBlbC5vcmcvcGF0Y2h3b3Jr
L3BhdGNoLzY3NDY4NC8uIMKgVGhpcyBwYXRjaCBpcyBkZWZpbml0ZWx5IGJldHRlciwgYnV0DQo+
IGhvdyBtYW55IHVuaXF1ZSBrZXlzIGFyZSBhY3R1YWxseSBiZWluZyB1c2VkPyDCoElzIGl0IGFu
eXdoZXJlIG5lYXINCj4gSU1BX01FQVNVUkVfSFRBQkxFX1NJWkUoNTEyKT8NCg0KSSBkaWQgYSBz
bWFsbCB0ZXN0ICh3aXRoIDEwNDMgbWVhc3VyZW1lbnRzKToNCg0Kc2xvdHM6IDI1MCwgbWF4IGRl
cHRoOiA5ICh3aXRob3V0IHRoZSBwYXRjaCkNCnNsb3RzOiA0NDgsIG1heCBkZXB0aDogNyAod2l0
aCB0aGUgcGF0Y2gpDQoNClRoZW4sIEkgaW5jcmVhc2VkIHRoZSBudW1iZXIgb2YgYml0cyB0byAx
MDoNCg0Kc2xvdHM6IDI1MSwgbWF4IGRlcHRoOiA5ICh3aXRob3V0IHRoZSBwYXRjaCkNCnNsb3Rz
OiA2NjAsIG1heCBkZXB0aDogNCAod2l0aCB0aGUgcGF0Y2gpDQoNCj4gRG8gd2UgbmVlZCBhIG5l
dyBzZWN1cml0eWZzIGVudHJ5IHRvIGRpc3BsYXkgdGhlIG51bWJlciB1c2VkPw0KDQpQcm9iYWJs
eSBpdCBpcyB1c2VmdWwgb25seSBpZiB0aGUgYWRtaW5pc3RyYXRvciBjYW4gZGVjaWRlIHRoZSBu
dW1iZXIgb2Ygc2xvdHMuDQoNClJvYmVydG8NCg0KSFVBV0VJIFRFQ0hOT0xPR0lFUyBEdWVzc2Vs
ZG9yZiBHbWJILCBIUkIgNTYwNjMNCk1hbmFnaW5nIERpcmVjdG9yOiBMaSBQZW5nLCBMaSBKaWFu
LCBTaGkgWWFubGkNCg0KDQo+ID4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gPiBGaXhl
czogMzMyM2VlYzkyMWVmICgiaW50ZWdyaXR5OiBJTUEgYXMgYW4gaW50ZWdyaXR5IHNlcnZpY2Ug
cHJvdmlkZXIiKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IEtyenlzenRvZiBTdHJ1Y3p5bnNraSA8a3J6
eXN6dG9mLnN0cnVjenluc2tpQGh1YXdlaS5jb20+DQo+ID4gLS0tDQo+ID4gIHNlY3VyaXR5L2lu
dGVncml0eS9pbWEvaW1hLmggfCAyICstDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlv
bigrKSwgMSBkZWxldGlvbigtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL3NlY3VyaXR5L2ludGVn
cml0eS9pbWEvaW1hLmggYi9zZWN1cml0eS9pbnRlZ3JpdHkvaW1hL2ltYS5oDQo+ID4gaW5kZXgg
NjQzMTdkOTUzNjNlLi5jZjAwMjJjMmJjMTQgMTAwNjQ0DQo+ID4gLS0tIGEvc2VjdXJpdHkvaW50
ZWdyaXR5L2ltYS9pbWEuaA0KPiA+ICsrKyBiL3NlY3VyaXR5L2ludGVncml0eS9pbWEvaW1hLmgN
Cj4gPiBAQCAtMTc3LDcgKzE3Nyw3IEBAIGV4dGVybiBzdHJ1Y3QgaW1hX2hfdGFibGUgaW1hX2h0
YWJsZTsNCj4gPg0KPiA+ICBzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGxvbmcgaW1hX2hhc2hfa2V5
KHU4ICpkaWdlc3QpDQo+ID4gIHsNCj4gPiAtCXJldHVybiBoYXNoX2xvbmcoKmRpZ2VzdCwgSU1B
X0hBU0hfQklUUyk7DQo+ID4gKwlyZXR1cm4gaGFzaF9sb25nKCooKHVuc2lnbmVkIGxvbmcgKilk
aWdlc3QpLCBJTUFfSEFTSF9CSVRTKTsNCj4gPiAgfQ0KPiA+DQo+ID4gICNkZWZpbmUgX19pbWFf
aG9va3MoaG9vaykJCVwNCg0K
