Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF0117F756
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgCJMXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:23:38 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:31803 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726224AbgCJMXi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 08:23:38 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-134-nZB81PfeP52EGTki-0E5KQ-1; Tue, 10 Mar 2020 12:23:34 +0000
X-MC-Unique: nZB81PfeP52EGTki-0E5KQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 10 Mar 2020 12:23:34 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 10 Mar 2020 12:23:34 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Chris Wilson' <chris@chris-wilson.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] list: Prevent compiler reloads inside 'safe' list
 iteration
Thread-Topic: [PATCH] list: Prevent compiler reloads inside 'safe' list
 iteration
Thread-Index: AQHV9r1KBrT+D4Vo2U+Op9v/Nv0od6hBsdzwgAAEwQCAAAWYAA==
Date:   Tue, 10 Mar 2020 12:23:34 +0000
Message-ID: <723d527a4ad349b78bf11d52eba97c0e@AcuMS.aculab.com>
References: <20200310092119.14965-1-chris@chris-wilson.co.uk>
 <2e936d8fd2c445beb08e6dd3ee1f3891@AcuMS.aculab.com>
 <158384100886.16414.15741589015363013386@build.alporthouse.com>
In-Reply-To: <158384100886.16414.15741589015363013386@build.alporthouse.com>
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

RnJvbTogQ2hyaXMgV2lsc29uDQo+IFNlbnQ6IDEwIE1hcmNoIDIwMjAgMTE6NTANCj4gDQo+IFF1
b3RpbmcgRGF2aWQgTGFpZ2h0ICgyMDIwLTAzLTEwIDExOjM2OjQxKQ0KPiA+IEZyb206IENocmlz
IFdpbHNvbg0KPiA+ID4gU2VudDogMTAgTWFyY2ggMjAyMCAwOToyMQ0KPiA+ID4gSW5zdHJ1Y3Qg
dGhlIGNvbXBpbGVyIHRvIHJlYWQgdGhlIG5leHQgZWxlbWVudCBpbiB0aGUgbGlzdCBpdGVyYXRp
b24NCj4gPiA+IG9uY2UsIGFuZCB0aGF0IGl0IGlzIG5vdCBhbGxvd2VkIHRvIHJlbG9hZCB0aGUg
dmFsdWUgZnJvbSB0aGUgc3RhbGUNCj4gPiA+IGVsZW1lbnQgbGF0ZXIuIFRoaXMgaXMgaW1wb3J0
YW50IGFzIGR1cmluZyB0aGUgY291cnNlIG9mIHRoZSBzYWZlDQo+ID4gPiBpdGVyYXRpb24sIHRo
ZSBzdGFsZSBlbGVtZW50IG1heSBiZSBwb2lzb25lZCAodW5iZWtub3duc3QgdG8gdGhlDQo+ID4g
PiBjb21waWxlcikuDQo+ID4NCj4gPiBFaD8NCj4gPiBJIHRob3VnaHQgYW55IGZ1bmN0aW9uIGNh
bGwgd2lsbCBzdG9wIHRoZSBjb21waWxlciBiZWluZyBhbGxvd2VkDQo+ID4gdG8gcmVsb2FkIHRo
ZSB2YWx1ZS4NCj4gPiBUaGUgJ3NhZmUnIGxvb3AgaXRlcmF0b3JzIGFyZSBvbmx5ICdzYWZlJyBh
Z2FpbnN0IGNhbGxlZA0KPiA+IGNvZGUgcmVtb3ZpbmcgdGhlIGN1cnJlbnQgaXRlbSBmcm9tIHRo
ZSBsaXN0Lg0KPiA+DQo+ID4gPiBUaGlzIGhlbHBzIHByZXZlbnQga2NzYW4gd2FybmluZ3Mgb3Zl
ciAndW5zYWZlJyBjb25kdWN0IGluIHJlbGVhc2luZyB0aGUNCj4gPiA+IGxpc3QgZWxlbWVudHMg
ZHVyaW5nIGxpc3RfZm9yX2VhY2hfZW50cnlfc2FmZSgpIGFuZCBmcmllbmRzLg0KPiA+DQo+ID4g
U291bmRzIGxpa2Uga2NzYW4gaXMgYnVnZ3kgPz8/Pw0KPiANCj4gVGhlIHdhcm5pbmcga2NzYW4g
Z2F2ZSBtYWRlIHNlbnNlIChhIHN0cmFuZ2UgY2FzZSB3aGVyZSB0aGUgZW1wdHlpbmcgdGhlDQo+
IGxpc3QgZnJvbSBpbnNpZGUgdGhlIHNhZmUgaXRlcmF0b3Igd291bGQgYWxsb3cgdGhhdCBsaXN0
IHRvIGJlIHRha2VuDQo+IHVuZGVyIGEgZ2xvYmFsIG11dGV4IGFuZCBoYXZlIG9uZSBleHRyYSBy
ZXF1ZXN0IGFkZGVkIHRvIGl0LiBUaGUNCj4gbGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKCkgc2hv
dWxkIGJlIG9rIGluIHRoaXMgc2NlbmFyaW8sIHNvIGxvbmcgYXMgdGhlDQo+IG5leHQgZWxlbWVu
dCBpcyByZWFkIGJlZm9yZSB0aGlzIGVsZW1lbnQgaXMgZHJvcHBlZCwgYW5kIHRoZSBjb21waWxl
ciBpcw0KPiBpbnN0cnVjdGVkIG5vdCB0byByZWxvYWQgdGhlIGVsZW1lbnQuDQoNCk5vcm1hbGx5
IHRoZSBsb29wIGl0ZXJhdGlvbiBjb2RlIGhhcyB0byBob2xkIHRoZSBtdXRleC4NCkkgZ3Vlc3Mg
aXQgY2FuIGJlIHJlbGVhc2VkIGluc2lkZSB0aGUgbG9vcCBwcm92aWRlZCBubyBvdGhlcg0KY29k
ZSBjYW4gZXZlciBkZWxldGUgZW50cmllcy4NCg0KPiBrY3NhbiBpcyBhIGxpdHRsZSBtb3JlIGlu
c2lzdGVudCBvbiBoYXZpbmcgdGhhdCBhbm5vdGF0aW9uIDopDQo+IA0KPiBJbiB0aGlzIGluc3Rh
bmNlIEkgd291bGQgc2F5IGl0IHdhcyBhIGZhbHNlIHBvc2l0aXZlIGZyb20ga2NzYW4sIGJ1dCBJ
DQo+IGNhbiBzZWUgd2h5IGl0IHdvdWxkIGNvbXBsYWluIGFuZCBzdXNwZWN0IHRoYXQgZ2l2ZW4g
YSBzdWZmaWNpZW50bHkNCj4gYWdncmVzc2l2ZSBjb21waWxlciwgd2UgbWF5IGJlIGNhdWdodCBv
dXQgYnkgYSBsYXRlIHJlbG9hZCBvZiB0aGUgbmV4dA0KPiBlbGVtZW50Lg0KDQpJZiB5b3UgaGF2
ZToNCglmb3IgKDsgcDsgcCA9IG5leHQpIHsNCgkJbmV4dCA9IHAtPm5leHQ7DQoJCWV4dGVybmFs
X2Z1bmN0aW9uX2NhbGwodm9pZCk7DQoJfQ0KdGhlIGNvbXBpbGVyIG11c3QgYXNzdW1lIHRoYXQg
dGhlIGZ1bmN0aW9uIGNhbGwNCmNhbiBjaGFuZ2UgJ3AtPm5leHQnIGFuZCByZWFkIGl0IGJlZm9y
ZSB0aGUgY2FsbC4NCg0KSXMgdGhpcyBhIGxpc3Qgd2l0aCBzdHJhbmdlIGxvY2tpbmcgcnVsZXM/
DQpUaGUgb25seSBkZWxldGVzIGFyZSBmcm9tIHdpdGhpbiB0aGUgbG9vcC4NCkFkZHMgYW5kIGRl
bGV0ZXMgYXJlIGxvY2tlZC4NClRoZSBsaXN0IHRyYXZlcnNhbCBpc24ndCBsb2NrZWQuDQoNCkkg
c3VzcGVjdCBrY3NhbiBibGVhdHMgYmVjYXVzZSBpdCBkb2Vzbid0IGFzc3VtZSB0aGUgY29tcGls
ZXINCndpbGwgdXNlIGEgc2luZ2xlIGluc3RydWN0aW9uL21lbW9yeSBvcGVyYXRpb24gdG8gcmVh
ZCBwLT5uZXh0Lg0KVGhhdCBpcyBqdXN0IHN0dXBpZC4NCg0KCURhdmlkDQoNCg0KDQoJCQ0KDQot
DQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwg
TWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2Fs
ZXMpDQo=

