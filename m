Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70991E4722
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 17:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389520AbgE0PR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 11:17:27 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:51859 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387833AbgE0PR0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 11:17:26 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-108-6dEhZDTeOT-9ivl6WFz16Q-1; Wed, 27 May 2020 16:17:23 +0100
X-MC-Unique: 6dEhZDTeOT-9ivl6WFz16Q-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 27 May 2020 16:17:22 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 27 May 2020 16:17:22 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Liang, Kan'" <kan.liang@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "ak@linux.intel.com" <ak@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] perf/x86/intel/uncore: Fix oops when counting IMC uncore
 events on some TGL
Thread-Topic: [PATCH] perf/x86/intel/uncore: Fix oops when counting IMC uncore
 events on some TGL
Thread-Index: AQHWNCLukMKeXYb1T0G/ZA+cFsVVx6i75DXQgAAOAgCAABGM4P//8pEAgAAVAHA=
Date:   Wed, 27 May 2020 15:17:22 +0000
Message-ID: <a891f75d599c4978ba941de73c6a667b@AcuMS.aculab.com>
References: <1590582647-90675-1-git-send-email-kan.liang@linux.intel.com>
 <869fafc80da84d188678c1cbb0267a0b@AcuMS.aculab.com>
 <ed3d86b7-2f75-cfe9-bc74-5f2c29ef2540@linux.intel.com>
 <d64c3c684ccd46daa5bb326dbbb277b0@AcuMS.aculab.com>
 <9f0ed889-590e-6f7a-85bd-c4be43e993f3@linux.intel.com>
In-Reply-To: <9f0ed889-590e-6f7a-85bd-c4be43e993f3@linux.intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogTGlhbmcsIEthbg0KPiBTZW50OiAyNyBNYXkgMjAyMCAxNjowMQ0KPiBPbiA1LzI3LzIw
MjAgMTA6NTEgQU0sIERhdmlkIExhaWdodCB3cm90ZToNCj4gPiBGcm9tOiBMaWFuZywgS2FuDQo+
ID4+IFNlbnQ6IDI3IE1heSAyMDIwIDE1OjQ3DQo+ID4+IE9uIDUvMjcvMjAyMCA4OjU5IEFNLCBE
YXZpZCBMYWlnaHQgd3JvdGU6DQo+ID4+PiBGcm9tOiBrYW4ubGlhbmdAbGludXguaW50ZWwuY29t
DQo+ID4+Pj4gU2VudDogMjcgTWF5IDIwMjAgMTM6MzENCj4gPj4+Pg0KPiA+Pj4+IEZyb206IEth
biBMaWFuZyA8a2FuLmxpYW5nQGxpbnV4LmludGVsLmNvbT4NCj4gPj4+Pg0KPiA+Pj4+IFdoZW4g
Y291bnRpbmcgSU1DIHVuY29yZSBldmVudHMgb24gc29tZSBUR0wgbWFjaGluZXMsIGFuIG9vcHMg
d2lsbCBiZQ0KPiA+Pj4+IHRyaWdnZXJlZC4NCj4gPj4+PiAgICAgWyAzOTMuMTAxMjYyXSBCVUc6
IHVuYWJsZSB0byBoYW5kbGUgcGFnZSBmYXVsdCBmb3IgYWRkcmVzczoNCj4gPj4+PiAgICAgZmZm
ZmI0NTIwMGUxNTg1OA0KPiA+Pj4+ICAgICBbIDM5My4xMDEyNjldICNQRjogc3VwZXJ2aXNvciBy
ZWFkIGFjY2VzcyBpbiBrZXJuZWwgbW9kZQ0KPiA+Pj4+ICAgICBbIDM5My4xMDEyNzFdICNQRjog
ZXJyb3JfY29kZSgweDAwMDApIC0gbm90LXByZXNlbnQgcGFnZQ0KPiA+Pj4+DQo+ID4+Pj4gQ3Vy
cmVudCBwZXJmIHVuY29yZSBkcml2ZXIgc3RpbGwgdXNlIHRoZSBJTUMgTUFQIFNJWkUgaW5oZXJp
dGVkIGZyb20NCj4gPj4+PiBTTkIsIHdoaWNoIGlzIDB4NjAwMC4NCj4gPj4+PiBIb3dldmVyLCB0
aGUgb2Zmc2V0IG9mIElNQyB1bmNvcmUgY291bnRlcnMgZm9yIHNvbWUgVEdMIG1hY2hpbmVzIGlz
DQo+ID4+Pj4gbGFyZ2VyIHRoYW4gMHg2MDAwLCBlLmcuIDB4ZDhhMC4NCj4gPj4+Pg0KPiA+Pj4+
IEVubGFyZ2UgdGhlIElNQyBNQVAgU0laRSBmb3IgVEdMIHRvIDB4ZTAwMC4NCj4gPj4+DQo+ID4+
PiBSZXBsYWNpbmcgb25lICdyYW5kb20nIGNvbnN0YW50IHdpdGggYSBkaWZmZXJlbnQgb25lDQo+
ID4+PiBkb2Vzbid0IHNlZW0gbGlrZSBhIHByb3BlciBmaXguDQo+ID4+Pg0KPiA+Pj4gU3VyZWx5
IHRoZSBhY3R1YWwgYm91bmRzIG9mIHRoZSAnbWVtb3J5JyBhcmVhIGFyZSBwcm9wZXJseQ0KPiA+
Pj4gZGVmaW5lZCBzb21ld2hlcmUuDQo+ID4+PiBPciBhdCBsZWFzdCBzaG91bGQgY29tZSBmcm9t
IGEgdGFibGUuDQo+ID4+Pg0KPiA+Pj4gWW91IGFsc28gbmVlZCB0byB2ZXJpZnkgdGhhdCB0aGUg
b2Zmc2V0cyBhcmUgd2l0aGluIHRoZSBtYXBwZWQgYXJlYS4NCj4gPj4+IEFuIHVuZXhwZWN0ZWQg
b2Zmc2V0IHNob3VsZG4ndCB0cnkgdG8gYWNjZXNzIGFuIGludmFsaWQgYWRkcmVzcy4NCj4gPj4N
Cj4gPj4gVGhhbmtzIGZvciB0aGUgcmV2aWV3Lg0KPiA+Pg0KPiA+PiBJIGFncmVlIHRoYXQgd2Ug
c2hvdWxkIGFkZCBhIGNoZWNrIGJlZm9yZSBtYXBwaW5nIHRoZSBhcmVhIHRvIHByZXZlbnQNCj4g
Pj4gdGhlIGlzc3VlIGhhcHBlbnMgYWdhaW4uDQo+ID4+DQo+ID4+IEkgdGhpbmsgdGhlIGNoZWNr
IHNob3VsZCBiZSBhIGdlbmVyaWMgY2hlY2sgZm9yIGFsbCBwbGF0Zm9ybXMgd2hpY2ggdHJ5DQo+
ID4+IHRvIG1hcCBhbiBhcmVhLCBub3QganVzdCBmb3IgVEdMLiBJIHdpbGwgc3VibWl0IGEgc2Vw
YXJhdGUgcGF0Y2ggZm9yIHRoZQ0KPiA+PiBjaGVjay4NCj4gPg0KPiA+IFlvdSBuZWVkIGEgY2hl
Y2sgdGhhdCB0aGUgYWN0dWFsIGFjY2VzcyBpcyB3aXRoaW5nIHRoZSBtYXBwZWQgYXJlYS4NCj4g
PiBTbyBpbnN0ZWFkIG9mIGdldHRpbmcgYW4gT09QUyB5b3UgZ2V0IGEgZXJyb3IuDQo+ID4NCj4g
PiBUaGlzIGlzIGFmdGVyIHlvdSd2ZSBtYXBwZWQgaXQuDQo+IA0KPiBTdXJlLiBXaWxsIGFkZCBh
IFdBUk5fT05DRSgpIGJlZm9yZSB0aGUgYWN0dWFsIGFjY2Vzcy4NCg0KTm8gdGhhdCB3aWxsIHN0
aWxsIHBhbmljIHNvbWUgc3lzdGVtcy4NCnByX3dhcm4oKSBpcyBhbGwgeW91IG5lZWQuDQoNCglE
YXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91
bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5
NzM4NiAoV2FsZXMpDQo=

