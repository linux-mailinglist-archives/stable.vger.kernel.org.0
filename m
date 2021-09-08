Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89693403D35
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 18:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346472AbhIHQC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 12:02:56 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:35016 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235991AbhIHQCz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 12:02:55 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-228-r6fXZtf1PPeuGpV28TwQBA-1; Wed, 08 Sep 2021 17:01:45 +0100
X-MC-Unique: r6fXZtf1PPeuGpV28TwQBA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Wed, 8 Sep 2021 17:01:43 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Wed, 8 Sep 2021 17:01:43 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
        <linux-tip-commits@vger.kernel.org>
CC:     Lukas Hannen <lukas.hannen@opensource.tttech-industrial.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: RE: [tip: timers/urgent] time: Handle negative seconds correctly in
 timespec64_to_ns()
Thread-Topic: [tip: timers/urgent] time: Handle negative seconds correctly in
 timespec64_to_ns()
Thread-Index: AQHXpMkzlZUT75FKtkqpqy/t13Z0QquaSvLg
Date:   Wed, 8 Sep 2021 16:01:43 +0000
Message-ID: <a4bbf640306c42429afda8a4fc396f98@AcuMS.aculab.com>
References: =?utf-8?q?=3CAM6PR01MB541637BD6F336B8FFB72AF80EEC69=40AM6PR01M?=
 =?utf-8?q?B5416=2Eeurprd01=2Eprod=2Eexchangelabs=2Ecom=3E?=
 <163111620295.25758.18154572095175068828.tip-bot2@tip-bot2>
In-Reply-To: <163111620295.25758.18154572095175068828.tip-bot2@tip-bot2>
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

PiBDb21taXR0ZXI6ICAgICBUaG9tYXMgR2xlaXhuZXIgPHRnbHhAbGludXRyb25peC5kZT4NCj4g
Q29tbWl0dGVyRGF0ZTogV2VkLCAwOCBTZXAgMjAyMSAxNzo0NDoyNiArMDI6MDANCj4gDQo+IHRp
bWU6IEhhbmRsZSBuZWdhdGl2ZSBzZWNvbmRzIGNvcnJlY3RseSBpbiB0aW1lc3BlYzY0X3RvX25z
KCkNCj4gDQo+IHRpbWVzcGVjNjRfbnMoKSBwcmV2ZW50cyBtdWx0aXBsaWNhdGlvbiBvdmVyZmxv
d3MgYnkgY29tcGFyaW5nIHRoZSBzZWNvbmRzDQo+IHZhbHVlIG9mIHRoZSB0aW1lc3BlYyB0byBL
VElNRV9TRUNfTUFYLiBJZiB0aGUgdmFsdWUgaXMgZ3JlYXRlciBvciBlcXVhbCBpdA0KPiByZXR1
cm5zIEtUSU1FX01BWC4NCj4gDQo+IEJ1dCB0aGF0IGNoZWNrIGNhc3RzIHRoZSBzaWduZWQgc2Vj
b25kcyB2YWx1ZSB0byB1bnNpZ25lZCB3aGljaCBtYWtlcyB0aGUNCj4gY29tcGFyaXNpb24gdHJ1
ZSBmb3IgYWxsIG5lZ2F0aXZlIHZhbHVlcyBhbmQgdGhlcmVmb3JlIHJldHVybiB3cm9uZ2x5DQo+
IEtUSU1FX01BWC4NCj4gDQo+IE5lZ2F0aXZlIHNlY29uZCB2YWx1ZXMgYXJlIHBlcmZlY3RseSB2
YWxpZCBhbmQgcmVxdWlyZWQgaW4gc29tZSBwbGFjZXMsDQo+IGUuZy4gcHRwX2Nsb2NrX2FkanRp
bWUoKS4NCj4gDQo+IFJlbW92ZSB0aGUgY2FzdCBhbmQgYWRkIGEgY2hlY2sgZm9yIHRoZSBuZWdh
dGl2ZSBib3VuZGFyeSB3aGljaCBpcyByZXF1aXJlZA0KPiB0byBwcmV2ZW50IHVuZGVmaW5lZCBi
ZWhhdmlvdXIgZHVlIHRvIG11bHRpcGxpY2F0aW9uIHVuZGVyZmxvdy4NCj4gDQo+IEZpeGVzOiBj
YjQ3NzU1NzI1ZGEgKCJ0aW1lOiBQcmV2ZW50IHVuZGVmaW5lZCBiZWhhdmlvdXIgaW4gdGltZXNw
ZWM2NF90b19ucygpIiknDQo+IFNpZ25lZC1vZmYtYnk6IEx1a2FzIEhhbm5lbiA8bHVrYXMuaGFu
bmVuQG9wZW5zb3VyY2UudHR0ZWNoLWluZHVzdHJpYWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBU
aG9tYXMgR2xlaXhuZXIgPHRnbHhAbGludXRyb25peC5kZT4NCj4gQ2M6IHN0YWJsZUB2Z2VyLmtl
cm5lbC5vcmcNCj4gTGluazoNCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci9BTTZQUjAxTUI1
NDE2MzdCRDZGMzM2QjhGRkI3MkFGODBFRUM2OUBBTTZQUjAxTUI1NDE2LmV1cnByZDAxLnByb2Qu
ZXhjaGFuZ2VsDQo+IGFicy5jb20NCj4gLS0tDQo+ICBpbmNsdWRlL2xpbnV4L3RpbWU2NC5oIHwg
IDkgKysrKysrKy0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAyIGRlbGV0
aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvdGltZTY0LmggYi9pbmNs
dWRlL2xpbnV4L3RpbWU2NC5oDQo+IGluZGV4IDUxMTdjYjUuLjgxYjk2ODYgMTAwNjQ0DQo+IC0t
LSBhL2luY2x1ZGUvbGludXgvdGltZTY0LmgNCj4gKysrIGIvaW5jbHVkZS9saW51eC90aW1lNjQu
aA0KPiBAQCAtMjUsNyArMjUsOSBAQCBzdHJ1Y3QgaXRpbWVyc3BlYzY0IHsNCj4gICNkZWZpbmUg
VElNRTY0X01JTgkJCSgtVElNRTY0X01BWCAtIDEpDQo+IA0KPiAgI2RlZmluZSBLVElNRV9NQVgJ
CQkoKHM2NCl+KCh1NjQpMSA8PCA2MykpDQo+ICsjZGVmaW5lIEtUSU1FX01JTgkJCSgtS1RJTUVf
TUFYIC0gMSkNCj4gICNkZWZpbmUgS1RJTUVfU0VDX01BWAkJCShLVElNRV9NQVggLyBOU0VDX1BF
Ul9TRUMpDQo+ICsjZGVmaW5lIEtUSU1FX1NFQ19NSU4JCQkoS1RJTUVfTUlOIC8gTlNFQ19QRVJf
U0VDKQ0KPiANCj4gIC8qDQo+ICAgKiBMaW1pdHMgZm9yIHNldHRpbWVvZmRheSgpOg0KPiBAQCAt
MTI0LDEwICsxMjYsMTMgQEAgc3RhdGljIGlubGluZSBib29sIHRpbWVzcGVjNjRfdmFsaWRfc2V0
dG9kKGNvbnN0IHN0cnVjdCB0aW1lc3BlYzY0ICp0cykNCj4gICAqLw0KPiAgc3RhdGljIGlubGlu
ZSBzNjQgdGltZXNwZWM2NF90b19ucyhjb25zdCBzdHJ1Y3QgdGltZXNwZWM2NCAqdHMpDQo+ICB7
DQo+IC0JLyogUHJldmVudCBtdWx0aXBsaWNhdGlvbiBvdmVyZmxvdyAqLw0KPiAtCWlmICgodW5z
aWduZWQgbG9uZyBsb25nKXRzLT50dl9zZWMgPj0gS1RJTUVfU0VDX01BWCkNCj4gKwkvKiBQcmV2
ZW50IG11bHRpcGxpY2F0aW9uIG92ZXJmbG93IC8gdW5kZXJmbG93ICovDQo+ICsJaWYgKHRzLT50
dl9zZWMgPj0gS1RJTUVfU0VDX01BWCkNCj4gIAkJcmV0dXJuIEtUSU1FX01BWDsNCj4gDQo+ICsJ
aWYgKHRzLT50dl9zZWMgPD0gS1RJTUVfU0VDX01JTikNCj4gKwkJcmV0dXJuIEtUSU1FX01JTjsN
Cj4gKw0KPiAgCXJldHVybiAoKHM2NCkgdHMtPnR2X3NlYyAqIE5TRUNfUEVSX1NFQykgKyB0cy0+
dHZfbnNlYzsNCj4gIH0NCg0KQWRkaW5nIHR2X25zZWMgY2FuIHN0aWxsIG92ZXJmbG93IC0gIGV2
ZW4gaWYgdHZfbnNlYyBpcyBib3VuZGVkIHRvICsvLSAxIHNlY29uZC4NClRoaXMgaXMgbm8gbW9y
ZSAnZ2FyYmFnZSBpbicgPT4gJ2dhcmJhZ2Ugb3V0JyB0aGFuIHRoZSBjb2RlIHdpdGhvdXQgdGhl
DQptdWx0aXBseSB1bmRlci9vdmVyZmxvdyBjaGVjay4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVy
ZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5
bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

