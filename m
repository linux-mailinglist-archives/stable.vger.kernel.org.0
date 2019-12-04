Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12944112FD9
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 17:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbfLDQS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 11:18:56 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:46059 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727990AbfLDQS4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 11:18:56 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-51-1dN_2ZUoNVmFbAyoH-JP6g-1; Wed, 04 Dec 2019 16:18:52 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 4 Dec 2019 16:18:52 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 4 Dec 2019 16:18:52 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Paul Burton' <paulburton@kernel.org>
CC:     "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] MIPS: Use __copy_{to,from}_user() for emulated FP
 loads/stores
Thread-Topic: [PATCH] MIPS: Use __copy_{to,from}_user() for emulated FP
 loads/stores
Thread-Index: AQHVqhshCXVq7CTTBEufX7LGTbPWHKep0u6ggABLQQCAAAO1QA==
Date:   Wed, 4 Dec 2019 16:18:52 +0000
Message-ID: <e220ba9a19da41abba599b5873afa494@AcuMS.aculab.com>
References: <20191203204933.1642259-1-paulburton@kernel.org>
 <f5e09155580d417e9dcd07b1c20786ed@AcuMS.aculab.com>
 <20191204154048.eotzglp4rdlx4yzl@lantea.localdomain>
In-Reply-To: <20191204154048.eotzglp4rdlx4yzl@lantea.localdomain>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: 1dN_2ZUoNVmFbAyoH-JP6g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogUGF1bCBCdXJ0b24NCj4gU2VudDogMDQgRGVjZW1iZXIgMjAxOSAxNTo0MQ0KPiBPbiBX
ZWQsIERlYyAwNCwgMjAxOSBhdCAxMToxNDowOEFNICswMDAwLCBEYXZpZCBMYWlnaHQgd3JvdGU6
DQo+ID4gRnJvbTogUGF1bCBCdXJ0b24NCj4gPiA+IFNlbnQ6IDAzIERlY2VtYmVyIDIwMTkgMjA6
NTANCj4gPiA+IE91ciBGUFUgZW11bGF0b3IgY3VycmVudGx5IHVzZXMgX19nZXRfdXNlcigpICYg
X19wdXRfdXNlcigpIHRvIHBlcmZvcm0NCj4gPiA+IGVtdWxhdGVkIGxvYWRzICYgc3RvcmVzLiBU
aGlzIGlzIHByb2JsZW1hdGljIGJlY2F1c2UgX19nZXRfdXNlcigpICYNCj4gPiA+IF9fcHV0X3Vz
ZXIoKSBhcmUgb25seSBzdWl0YWJsZSBmb3IgbmF0dXJhbGx5IGFsaWduZWQgbWVtb3J5IGFjY2Vz
c2VzLA0KPiA+ID4gYW5kIHRoZSBhZGRyZXNzIHdlJ3JlIGFjY2Vzc2luZyBpcyBlbnRpcmVseSB1
bmRlciB0aGUgY29udHJvbCBvZg0KPiA+ID4gdXNlcmxhbmQuDQo+ID4gPg0KPiA+ID4gVGhpcyBh
bGxvd3MgdXNlcmxhbmQgdG8gY2F1c2UgYSBrZXJuZWwgcGFuaWMgYnkgc2ltcGx5IHBlcmZvcm1p
bmcgYW4NCj4gPiA+IHVuYWxpZ25lZCBmbG9hdGluZyBwb2ludCBsb2FkIG9yIHN0b3JlIC0gdGhl
IGtlcm5lbCB3aWxsIGhhbmRsZSB0aGUNCj4gPiA+IGFkZHJlc3MgZXJyb3IgZXhjZXB0aW9uIGJ5
IGF0dGVtcHRpbmcgdG8gZW11bGF0ZSB0aGUgaW5zdHJ1Y3Rpb24sIGFuZCBpbg0KPiA+ID4gdGhl
IHByb2Nlc3MgaXQgbWF5IGdlbmVyYXRlIGFub3RoZXIgYWRkcmVzcyBlcnJvciBleGNlcHRpb24g
aXRzZWxmLg0KPiA+ID4gVGhpcyB0aW1lIHRoZSBleGNlcHRpb24gaXMgdGFrZW4gd2l0aCBFUEMg
cG9pbnRpbmcgYXQgdGhlIGtlcm5lbHMgRlBVDQo+ID4gPiBlbXVsYXRpb24gY29kZSwgYW5kIHdl
IGhpdCBhIGRpZV9pZl9rZXJuZWwoKSBpbg0KPiA+ID4gZW11bGF0ZV9sb2FkX3N0b3JlX2luc24o
KS4NCj4gPg0KPiA+IFdvbid0IHRoaXMgYmUgdHJ1ZSBvZiBhbG1vc3QgYWxsIGNvZGUgdGhhdCB1
c2VzIGdldF91c2VyKCkgYW5kIHB1dF91c2VyKCkNCj4gPiAod2l0aCBvciB3aXRob3V0IHRoZSBs
ZWFkaW5nIF9fKS4NCj4gDQo+IE9ubHkgaWYgdGhlIGFkZHJlc3MgYmVpbmcgYWNjZXNzZWQgaXMg
dW5kZXIgdGhlIGNvbnRyb2wgb2YgdXNlcmxhbmQgdG8NCj4gdGhlIGV4dGVudCB0aGF0IGl0IGNh
biBjcmVhdGUgYW4gdW5hbGlnbmVkIGFkZHJlc3MuIFlvdSdyZSByaWdodCB0aGF0DQo+IG1heSBi
ZSBtb3JlIHdpZGVzcHJlYWQgdGhvdWdoOyBpdCBuZWVkcyBjaGVja2luZy4uLg0KDQpMb29rIGF0
IChmb3IgZXhhbXBsZSkgdGhlIHJlY3ZtbXNnKCkgY29kZSBvciBlcG9sbF93YWl0KCkuDQoNCkkn
ZCBleHBlY3QgYWxsIGdldC9wdXRfdXNlcigpIHRvIGJlIHBvdGVudGlhbGx5IHVuYWxpZ25lZC4N
ClRoZSB1c2VyIG1pZ2h0IGhhdmUgdG8gdHJ5IGhhcmQgKHRvIGF2b2lkIGFsbCB0aGUgZmF1bHRz
IGluIHVzZXJzcGFjZSkNCmJ1dCBhbnkgYnVmZmVyIHBhc3NlZCB0byB0aGUga2VybmVsIGNhbiBw
b3RlbnRpYWxseSBiZSBtaXNhbGlnbmVkIGFuZA0Kbm90aGluZyAoSSd2ZSBzZWVuKSBpcyBkb2N1
bWVudGVkIGFzIHJldHVybmluZyBFRkFVTFQvU0lHU0VHVg0KZm9yIHN1Y2ggdW5hbGlnbmVkIGJ1
ZmZlcnMuDQoNCkluICdkYXlzIG9mIHlvcmUuLi4nIFNQQVJDIHN5c3RlbXMgd291bGQgaGF2ZSBk
b25lIGEgU0lHU0VHViBmb3INCmFueSBtaXNhbGlnbmVkIGFjY2VzcyBpbiB1c2Vyc3BhY2UuDQpO
b3Qgc3VyZSB3aHkgTGludXggZXZlciB0aG91Z2h0IGl0IHdhcyBuZWNlc3NhcnkgdG8gJ2ZpeHVw
JyBzdWNoIGZhdWx0cy4NCk9UT0ggaXQgaXMgdG9vIGxhdGUgdG8gY2hhbmdlIHRoYXQgYmVoYXZp
b3VyIChhdCBsZWFzdCBmb3IgZXhpc3RpbmcgcG9ydHMpLg0KDQo+IFdlIHVzZWQgdG8gaGF2ZSBz
ZXBhcmF0ZSBnZXRfdXNlcl91bmFsaWduZWQoKSAmIHB1dF91c2VyX3VuYWxpZ25lZCgpDQo+IHdo
aWNoIHdvdWxkIHN1Z2dlc3QgdGhhdCBpdCdzIGV4cGVjdGVkIHRoYXQgZ2V0X3VzZXIoKSAmIHB1
dF91c2VyKCkNCj4gcmVxdWlyZSB0aGVpciBhY2Nlc3NlcyBiZSBhbGlnbmVkLCBidXQgdGhleSB3
ZXJlIHJlbW92ZWQgYnkgY29tbWl0DQo+IDMxNzBkOGQyMjZjMiAoImtpbGwge19fLH17Z2V0LHB1
dH1fdXNlcl91bmFsaWduZWQoKSIpIGluIHY0LjEzLg0KPiANCj4gQnV0IHBlcmhhcHMgd2Ugc2hv
dWxkIGp1c3QgdGFrZSB0aGUgc2Vjb25kIEFkRUwgZXhjZXB0aW9uICYgcmVjb3ZlciB2aWENCj4g
dGhlIGZpeHVwcyB0YWJsZS4gV2UgZGVmaW5pdGVseSBkb24ndCByaWdodCBub3cuLi4gTmVlZHMg
ZnVydGhlcg0KPiBpbnZlc3RpZ2F0aW9uLi4uDQoNCmdldC9wdXRfdXNlciBjYW4gZmF1bHQgYmVj
YXVzZSB0aGUgdXNlciBwYWdlIGlzIGFic2VudCAoZXRjKS4NClNvIHRoZXJlIG11c3QgYmUgY29k
ZSB0byAnZXhwZWN0JyBhIGZhdWx0IG9uIHRob3NlIGluc3RydWN0aW9ucy4NCg0KCURhdmlkDQoN
Ci0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJt
LCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChX
YWxlcykNCg==

