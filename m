Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0AF92F813E
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 17:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbhAOQvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 11:51:44 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:52587 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726402AbhAOQvn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 11:51:43 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-238-43bXRc6VN6K86cygnykhPQ-1; Fri, 15 Jan 2021 16:50:04 +0000
X-MC-Unique: 43bXRc6VN6K86cygnykhPQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 15 Jan 2021 16:50:01 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 15 Jan 2021 16:50:01 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Sergei Shtylyov' <sergei.shtylyov@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Ross Zwisler <zwisler@google.com>
Subject: RE: [PATCH 1/2] xhci: make sure TRB is fully written before giving it
 to the controller
Thread-Topic: [PATCH 1/2] xhci: make sure TRB is fully written before giving
 it to the controller
Thread-Index: AQHW611WujW4oTE1fkaGhqCs5AdVqaoo5DZw
Date:   Fri, 15 Jan 2021 16:50:01 +0000
Message-ID: <b70e0bb512d44f00ac5f8380ba450ba6@AcuMS.aculab.com>
References: <20210115161907.2875631-1-mathias.nyman@linux.intel.com>
 <20210115161907.2875631-2-mathias.nyman@linux.intel.com>
 <42c6632e-28f1-9aae-e1a6-3525bb493c58@gmail.com>
In-Reply-To: <42c6632e-28f1-9aae-e1a6-3525bb493c58@gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogU2VyZ2VpIFNodHlseW92DQo+IFNlbnQ6IDE1IEphbnVhcnkgMjAyMSAxNjo0MA0KPiAN
Cj4gT24gMS8xNS8yMSA3OjE5IFBNLCBNYXRoaWFzIE55bWFuIHdyb3RlOg0KPiANCj4gPiBPbmNl
IHRoZSBjb21tYW5kIHJpbmcgZG9vcmJlbGwgaXMgcnVuZyB0aGUgeEhDIGNvbnRyb2xsZXIgd2ls
bCBwYXJzZSBhbGwNCj4gPiBjb21tYW5kIFRSQnMgb24gdGhlIGNvbW1hbmQgcmluZyB0aGF0IGhh
dmUgdGhlIGN5Y2xlIGJpdCBzZXQgcHJvcGVybHkuDQo+ID4NCj4gPiBJZiB0aGUgZHJpdmVyIGp1
c3Qgc3RhcnRlZCB3cml0aW5nIHRoZSBuZXh0IGNvbW1hbmQgVFJCIHRvIHRoZSByaW5nIHdoZW4N
Cj4gPiBoYXJkd2FyZSBmaW5pc2hlZCB0aGUgcHJldmlvdXMgVFJCLCB0aGVuIEhXIG1pZ2h0IGZl
dGNoIGFuIGluY29tcGxldGUgVFJCDQo+ID4gYXMgbG9uZyBhcyBpdHMgY3ljbGUgYml0IHNldCBj
b3JyZWN0bHkuDQo+ID4NCj4gPiBBIGNvbW1hbmQgVFJCIGlzIDE2IGJ5dGVzICgxMjggYml0cykg
bG9uZy4NCj4gPiBEcml2ZXIgd3JpdGVzIHRoZSBjb21tYW5kIFRSQiBpbiBmb3VyIDMyIGJpdCBj
aHVua3MsIHdpdGggdGhlIGNodW5rDQo+ID4gY29udGFpbmluZyB0aGUgY3ljbGUgYml0IGxhc3Qu
IFRoaXMgZG9lcyBob3dldmVyIG5vdCBndWFyYW50ZWUgdGhhdA0KPiA+IGNodW5rcyBhY3R1YWxs
eSBnZXQgd3JpdHRlbiBpbiB0aGF0IG9yZGVyLg0KPiA+DQo+ID4gVGhpcyB3YXMgZGV0ZWN0ZWQg
aW4gc3RyZXNzIHRlc3Rpbmcgd2hlbiBjYW5jZWxpbmcgVVJCcyB3aXRoIHNldmVyYWwNCj4gPiBj
b25uZWN0ZWQgVVNCIGRldmljZXMuDQo+ID4gVHdvIGNvbnNlY3V0aXZlICJTZXQgVFIgRGVxdWV1
ZSBwb2ludGVyIiBjb21tYW5kcyBnb3QgcXVldWVkIHJpZ2h0DQo+ID4gYWZ0ZXIgZWFjaCBvdGhl
ciwgYW5kIHRoZSBzZWNvbmQgb25lIHdhcyBvbmx5IHBhcnRpYWxseSB3cml0dGVuIHdoZW4NCj4g
PiB0aGUgY29udHJvbGxlciBwYXJzZWQgaXQsIGNhdXNpbmcgdGhlIGRlcXVldWUgcG9pbnRlciB0
byBiZSBzZXQNCj4gPiB0byBib2d1cyB2YWx1ZXMuIFRoaXMgd2FzIHNlZW4gYXMgZXJyb3IgbWVz
c2FnZXM6DQo+ID4NCj4gPiAiTWlzbWF0Y2ggYmV0d2VlbiBjb21wbGV0ZWQgU2V0IFRSIERlcSBQ
dHIgY29tbWFuZCAmIHhIQ0kgaW50ZXJuYWwgc3RhdGUiDQo+ID4NCj4gPiBTb2x1dGlvbiBpcyB0
byBhZGQgYSB3cml0ZSBtZW1vcnkgYmFycmllciBiZWZvcmUgd3JpdGluZyB0aGUgY3ljbGUgYml0
Lg0KPiA+DQo+ID4gQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPiA+IFRlc3RlZC1ieTog
Um9zcyBad2lzbGVyIDx6d2lzbGVyQGdvb2dsZS5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogTWF0
aGlhcyBOeW1hbiA8bWF0aGlhcy5ueW1hbkBsaW51eC5pbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4g
IGRyaXZlcnMvdXNiL2hvc3QveGhjaS1yaW5nLmMgfCAyICsrDQo+ID4gIDEgZmlsZSBjaGFuZ2Vk
LCAyIGluc2VydGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9ob3N0
L3hoY2ktcmluZy5jIGIvZHJpdmVycy91c2IvaG9zdC94aGNpLXJpbmcuYw0KPiA+IGluZGV4IDU2
NzdiODFjMDkxNS4uY2YwYzkzYTkwMjAwIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvdXNiL2hv
c3QveGhjaS1yaW5nLmMNCj4gPiArKysgYi9kcml2ZXJzL3VzYi9ob3N0L3hoY2ktcmluZy5jDQo+
ID4gQEAgLTI5MzEsNiArMjkzMSw4IEBAIHN0YXRpYyB2b2lkIHF1ZXVlX3RyYihzdHJ1Y3QgeGhj
aV9oY2QgKnhoY2ksIHN0cnVjdCB4aGNpX3JpbmcgKnJpbmcsDQo+ID4gIAl0cmItPmZpZWxkWzBd
ID0gY3B1X3RvX2xlMzIoZmllbGQxKTsNCj4gPiAgCXRyYi0+ZmllbGRbMV0gPSBjcHVfdG9fbGUz
MihmaWVsZDIpOw0KPiA+ICAJdHJiLT5maWVsZFsyXSA9IGNwdV90b19sZTMyKGZpZWxkMyk7DQo+
ID4gKwkvKiBtYWtlIHN1cmUgVFJCIGlzIGZ1bGx5IHdyaXR0ZW4gYmVmb3JlIGdpdmluZyBpdCB0
byB0aGUgY29udHJvbGxlciAqLw0KPiA+ICsJd21iKCk7DQo+IA0KPiAgICBIYXZlIHlvdSB0cmll
ZCB0aGUgbGlnaHRlciBiYXJyaWVyLCBkbWFfd21iKCk/IElJUkMsIGl0IGV4aXN0cyBmb3IgdGhl
c2UgZXhhY3QgY2FzZXMuLi4NCg0KSXNuJ3QgZG1hX3dtYigpIG5lZWRlZCBiZXR3ZWVuIHRoZSBs
YXN0IG1lbW9yeSB3cml0ZSBhbmQgdGhlIGlvX3dyaXRlIHRvIHRoZSBkb29yYmVsbD8NCkhlcmUg
d2UgbmVlZCB0byBlbnN1cmUgdGhlIHR3byBtZW1vcnkgd3JpdGVzIGFyZW4ndCByZS1vcmRlcmVk
Lg0KQXBhcnQgZnJvbSBhbHBoYSBpc24ndCBhIGJhcnJpZXIoKSBsaWtlbHkgdG8gYmUgZW5vdWdo
IGZvciB0aGF0Lg0KSXQgaXMgd29ydGggY2hlY2tpbmcgdGhhdCB0aGUgZmFpbGluZyBjb21waWxl
cyBkaWRuJ3QgaGF2ZSB0aGUgd3JpdGVzIHJlb3JkZXJlZC4NCg0KCURhdmlkDQoNCj4gDQo+ID4g
IAl0cmItPmZpZWxkWzNdID0gY3B1X3RvX2xlMzIoZmllbGQ0KTsNCj4gPg0KPiA+ICAJdHJhY2Vf
eGhjaV9xdWV1ZV90cmIocmluZywgdHJiKTsNCj4gDQo+IE1CUiwgU2VyZ2VpDQoNCi0NClJlZ2lz
dGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24g
S2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

