Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD526245438
	for <lists+stable@lfdr.de>; Sun, 16 Aug 2020 00:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgHOWRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Aug 2020 18:17:50 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:20411 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726598AbgHOWRt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Aug 2020 18:17:49 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-194-UGUS_GsnMmaZTp2qO2jNHA-1; Sat, 15 Aug 2020 23:17:45 +0100
X-MC-Unique: UGUS_GsnMmaZTp2qO2jNHA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sat, 15 Aug 2020 23:17:44 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sat, 15 Aug 2020 23:17:44 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Nick Desaulniers' <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC:     =?utf-8?B?RMOhdmlkIEJvbHZhbnNrw70=?= <david.bolvansky@gmail.com>,
        "Eli Friedman" <efriedma@quicinc.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        "Joe Perches" <joe@perches.com>, Tony Luck <tony.luck@intel.com>,
        Yury Norov <yury.norov@gmail.com>,
        Daniel Axtens <dja@axtens.net>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Dan Williams <dan.j.williams@intel.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: RE: [PATCH] lib/string.c: implement stpcpy
Thread-Topic: [PATCH] lib/string.c: implement stpcpy
Thread-Index: AQHWcppzTiVsnmYgIU+NJ5yVXFbTpak5vH3w
Date:   Sat, 15 Aug 2020 22:17:44 +0000
Message-ID: <213d67e912f340b0815dd4bd989befce@AcuMS.aculab.com>
References: <20200815002417.1512973-1-ndesaulniers@google.com>
In-Reply-To: <20200815002417.1512973-1-ndesaulniers@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogTmljayBEZXNhdWxuaWVycw0KPiBTZW50OiAxNSBBdWd1c3QgMjAyMCAwMToyNA0KPiAN
Cj4gTExWTSBpbXBsZW1lbnRlZCBhIHJlY2VudCAibGliY2FsbCBvcHRpbWl6YXRpb24iIHRoYXQg
bG93ZXJzIGNhbGxzIHRvDQo+IGBzcHJpbnRmKGRlc3QsICIlcyIsIHN0cilgIHdoZXJlIHRoZSBy
ZXR1cm4gdmFsdWUgaXMgdXNlZCB0bw0KPiBgc3RwY3B5KGRlc3QsIHN0cikgLSBkZXN0YC4gVGhp
cyBnZW5lcmFsbHkgYXZvaWRzIHRoZSBtYWNoaW5lcnkgaW52b2x2ZWQNCj4gaW4gcGFyc2luZyBm
b3JtYXQgc3RyaW5ncy4NCj4gDQo+IGBzdHBjcHlgIGlzIGp1c3QgbGlrZSBgc3RyY3B5YCBleGNl
cHQ6DQo+IDEuIGl0IHJldHVybnMgdGhlIHBvaW50ZXIgdG8gdGhlIG5ldyB0YWlsIG9mIGBkZXN0
YC4gVGhpcyBhbGxvd3MgeW91IHRvDQo+ICAgIGNoYWluIG11bHRpcGxlIGNhbGxzIHRvIGBzdHBj
cHlgIGluIG9uZSBzdGF0ZW1lbnQuDQo+IDIuIGl0IHJlcXVpcmVzIHRoZSBwYXJhbWV0ZXJzIG5v
dCB0byBvdmVybGFwLiAgQ2FsbGluZyBgc3ByaW50ZmAgd2l0aA0KPiAgICBvdmVybGFwcGluZyBh
cmd1bWVudHMgd2FzIGNsYXJpZmllZCBpbiBJU08gQzk5IGFuZCBQT1NJWC4xLTIwMDEgdG8gYmUN
Cj4gICAgdW5kZWZpbmVkIGJlaGF2aW9yLg0KPiANCj4gYHN0cGNweWAgd2FzIGZpcnN0IHN0YW5k
YXJkaXplZCBpbiBQT1NJWC4xLTIwMDguDQo+IA0KPiBJbXBsZW1lbnQgdGhpcyBzbyB0aGF0IHdl
IGRvbid0IG9ic2VydmUgbGlua2FnZSBmYWlsdXJlcyBkdWUgdG8gbWlzc2luZw0KPiBzeW1ib2wg
ZGVmaW5pdGlvbnMgZm9yIGBzdHBjcHlgLg0KPiANCi4uDQouLi4NCj4gZGlmZiAtLWdpdCBhL2lu
Y2x1ZGUvbGludXgvc3RyaW5nLmggYi9pbmNsdWRlL2xpbnV4L3N0cmluZy5oDQo+IGluZGV4IGIx
ZjM4OTRhMGEzZS4uZTU3MGI5YjEwZjUwIDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL2xpbnV4L3N0
cmluZy5oDQo+ICsrKyBiL2luY2x1ZGUvbGludXgvc3RyaW5nLmgNCj4gQEAgLTMxLDYgKzMxLDkg
QEAgc2l6ZV90IHN0cmxjcHkoY2hhciAqLCBjb25zdCBjaGFyICosIHNpemVfdCk7DQo+ICAjaWZu
ZGVmIF9fSEFWRV9BUkNIX1NUUlNDUFkNCj4gIHNzaXplX3Qgc3Ryc2NweShjaGFyICosIGNvbnN0
IGNoYXIgKiwgc2l6ZV90KTsNCj4gICNlbmRpZg0KPiArI2lmbmRlZiBfX0hBVkVfQVJDSF9TVFBD
UFkNCj4gK2V4dGVybiBjaGFyICpzdHBjcHkoY2hhciAqX19yZXN0cmljdCwgY29uc3QgY2hhciAq
X19yZXN0cmljdF9fKTsNCj4gKyNlbmRpZg0KPiANCj4gIC8qIFdyYXBzIGNhbGxzIHRvIHN0cnNj
cHkoKS9tZW1zZXQoKSwgbm8gYXJjaCBzcGVjaWZpYyBjb2RlIHJlcXVpcmVkICovDQo+ICBzc2l6
ZV90IHN0cnNjcHlfcGFkKGNoYXIgKmRlc3QsIGNvbnN0IGNoYXIgKnNyYywgc2l6ZV90IGNvdW50
KTsNCj4gZGlmZiAtLWdpdCBhL2xpYi9zdHJpbmcuYyBiL2xpYi9zdHJpbmcuYw0KPiBpbmRleCA2
MDEyYzM4NWZiMzEuLjgxYmM0ZDYyYzI1NiAxMDA2NDQNCj4gLS0tIGEvbGliL3N0cmluZy5jDQo+
ICsrKyBiL2xpYi9zdHJpbmcuYw0KPiBAQCAtMjcyLDYgKzI3MiwyOSBAQCBzc2l6ZV90IHN0cnNj
cHlfcGFkKGNoYXIgKmRlc3QsIGNvbnN0IGNoYXIgKnNyYywgc2l6ZV90IGNvdW50KQ0KPiAgfQ0K
PiAgRVhQT1JUX1NZTUJPTChzdHJzY3B5X3BhZCk7DQo+IA0KPiArI2lmbmRlZiBfX0hBVkVfQVJD
SF9TVFBDUFkNCi4uLg0KPiArI3VuZGVmIHN0cGNweQ0KPiArY2hhciAqc3RwY3B5KGNoYXIgKl9f
cmVzdHJpY3RfXyBkZXN0LCBjb25zdCBjaGFyICpfX3Jlc3RyaWN0X18gc3JjKQ0KPiArew0KPiAr
CXdoaWxlICgoKmRlc3QrKyA9ICpzcmMrKykgIT0gJ1wwJykNCj4gKwkJLyogbm90aGluZyAqLzsN
Cj4gKwlyZXR1cm4gZGVzdDsNCj4gK30NCj4gKyNlbmRpZg0KPiArDQoNCkhtbW1tLi4uLg0KTWF5
YmUgdGhlIGNvbXBpbGVyIHNob3VsZCBqdXN0IGlubGluZSB0aGUgYWJvdmU/DQoNCk9UT0ggdGhl
cmUgYXJlIGZhc3RlciBjb3BpZXMgb24gNjRiaXQgc3lzdGVtcw0KKGZvciBtb2RlcmF0ZSBsZW5n
dGggc3RyaW5ncykuDQoNCkl0IHdvdWxkIGFsc28gYmUgbmljZXIgaWYgdGhlIGNvbXBpbGVyIGFj
dHVhbGx5IHVzZWQvcmVxdWlyZWQNCmEgc3ltYm9sIGluIHRoZSAncmVzZXJ2ZWQgZm9yIHRoZSBp
bXBsZW1lbnRhdGlvbicgbmFtZXNwYWNlLg0KVGhlbiB0aGUgbGlua2VyIHNob3VsZCBiZSBhYmxl
IHRvIGRvIGEgZml4dXAgdG8gYSBkaWZmZXJlbnRseQ0KbmFtZSBzeW1ib2wgLSBpZiB0aGF0IGlz
IHJlcXVpcmVkLg0KDQpCdXQgY29tcGlsZXIgd3JpdGVycyBlbmpveSBtYWtpbmcgZW1iZWRkZWQg
Y29kZXJzIGxpZmUgaGVsbC4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtl
c2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBV
Sw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

