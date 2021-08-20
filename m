Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBDF83F2FF1
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 17:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241128AbhHTPq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 11:46:56 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:22362 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240997AbhHTPqw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Aug 2021 11:46:52 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-88-F1DQbSqpMu6M5LHnyNb7xg-1; Fri, 20 Aug 2021 16:46:12 +0100
X-MC-Unique: F1DQbSqpMu6M5LHnyNb7xg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Fri, 20 Aug 2021 16:46:11 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Fri, 20 Aug 2021 16:46:11 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Ard Biesheuvel' <ardb@kernel.org>, Joerg Roedel <joro@8bytes.org>
CC:     "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "hpa@zytor.com" <hpa@zytor.com>, Joerg Roedel <jroedel@suse.de>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@kernel.org>,
        Uros Bizjak <ubizjak@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fabio Aiuto <fabioaiuto83@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] x86/efi: Restore Firmware IDT in before
 ExitBootServices()
Thread-Topic: [PATCH] x86/efi: Restore Firmware IDT in before
 ExitBootServices()
Thread-Index: AQHXlZXa+jtHdymQB0W1fhKjcUB7Wqt8EPPg///0gwCAABNdkIAAKfIdgABE/BA=
Date:   Fri, 20 Aug 2021 15:46:11 +0000
Message-ID: <cdd7869a14ad4021acfacffa3918981c@AcuMS.aculab.com>
References: <20210820073429.19457-1-joro@8bytes.org>
 <e43eb0d137164270bf16258e6d11879e@AcuMS.aculab.com>
 <YR9tSuLyX8QHV5Pv@8bytes.org>
 <f68a175362984e4abbb0a1da2004c936@AcuMS.aculab.com>
 <YR+Bxgq4aIo1DI8j@8bytes.org>
 <CAMj1kXHj12FQn_488V_9k9k_LE51K=7n3sS9QnN9gkhBgzw-Kw@mail.gmail.com>
In-Reply-To: <CAMj1kXHj12FQn_488V_9k9k_LE51K=7n3sS9QnN9gkhBgzw-Kw@mail.gmail.com>
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

RnJvbTogQXJkIEJpZXNoZXV2ZWwNCj4gU2VudDogMjAgQXVndXN0IDIwMjEgMTI6MzINCj4gDQo+
IE9uIEZyaSwgMjAgQXVnIDIwMjEgYXQgMTI6MTksIEpvZXJnIFJvZWRlbCA8am9yb0A4Ynl0ZXMu
b3JnPiB3cm90ZToNCj4gPg0KPiA+IE9uIEZyaSwgQXVnIDIwLCAyMDIxIGF0IDA5OjAyOjQ2QU0g
KzAwMDAsIERhdmlkIExhaWdodCB3cm90ZToNCj4gPiA+IFNvIGFsbG9jYXRlIGFuZCBpbml0aWFs
aXNlIHRoZSBMaW51eCBJRFQgLSBzbyBlbnRyaWVzIGNhbiBiZSBhZGRlZC4NCj4gPiA+IEJ1dCBk
b24ndCBleGVjdXRlICdsaWR0JyB1bnRpbCBsYXRlciBvbi4NCj4gPg0KPiA+IFRoZSBJRFQgaXMg
bmVlZGVkIGluIHRoaXMgcGF0aCB0byBoYW5kbGUgI1ZDIGV4Y2VwdGlvbnMgY2F1c2VkIGJ5IENQ
VUlEDQo+ID4gaW5zdHJ1Y3Rpb25zLiBTbyBsb2FkaW5nIHRoZSBJRFQgbGF0ZXIgaXMgbm90IGFu
IG9wdGlvbi4NCj4gPg0KPiANCj4gVGhhdCBkb2VzIHJhaXNlIGEgcXVlc3Rpb24sIHRob3VnaC4g
RG9lcyBjaGFuZ2luZyB0aGUgSURUIGludGVyZmVyZQ0KPiB3aXRoIHRoZSBhYmlsaXR5IG9mIHRo
ZSBVRUZJIGJvb3Qgc2VydmljZXMgdG8gcmVjZWl2ZSBhbmQgaGFuZGxlIHRoZQ0KPiB0aW1lciBp
bnRlcnJ1cHQ/IEJlY2F1c2UgYmVmb3JlIEV4aXRCb290U2VydmljZXMoKSwgdGhhdCBpcyBvd25l
ZCBieQ0KPiB0aGUgZmlybXdhcmUsIGFuZCBVRUZJIGhlYXZpbHkgcmVsaWVzIG9uIGl0IGZvciBl
dmVyeXRoaW5nIChldmVudA0KPiBoYW5kbGluZywgcG9sbGluZyBtb2RlIGJsb2NrL25ldHdvcmsg
ZHJpdmVycywgZXRjKQ0KPiANCj4gSWYgcmVzdG9yaW5nIHRoZSBJRFQgdGVtcG9yYXJpbHkganVz
dCBwYXBlcnMgb3ZlciB0aGlzIGJ5IGNyZWF0aW5nDQo+IHRpbnkgd2luZG93cyB3aGVyZSB0aGUg
dGltZXIgaW50ZXJydXB0IHN0YXJ0cyB3b3JraW5nIGFnYWluLCB0aGlzIGlzDQo+IGJhZCwgYW5k
IHdlIG5lZWQgdG8gZmlndXJlIG91dCBhbm90aGVyIHdheSB0byBhZGRyZXNzIHRoZSBvcmlnaW5h
bA0KPiBwcm9ibGVtLg0KDQpDb3VsZCB0aGUgd2hvbGUgdGhpbmcgYmUgZmxpcHBlZD8NCg0KU28g
bG9hZCBhIHRlbXBvcmFyeSBJRFQgc28gdGhhdCB5b3UgY2FuIGRldGVjdCBpbnZhbGlkIGluc3Ry
dWN0aW9ucw0KYW5kIHJlc3RvcmUgdGhlIFVFRkkgSURUIGltbWVkaWF0ZWx5IGFmdGVyd2FyZHM/
DQoNCkknbSBndWVzc2luZyB0aGUgR0RUIGlzIGNoYW5nZWQgaW4gb3JkZXIgdG8gYWNjZXNzIGFs
bCBvZiBwaHlzaWNhbA0KbWVtb3J5ICh3ZWxsIGVub3VnaCB0byBsb2FkIHRoZSBrZXJuZWwpLg0K
Q291bGQgdGhhdCBiZSBkb25lIHVzaW5nIHRoZSBMRFQ/DQpJdCBpcyB1bmxpa2VseSB0aGF0IHRo
ZSBVRUZJIGNhcmVzIGFib3V0IHRoYXQ/DQoNCklzIHRoaXMgMzJiaXQgbm9uLXBhZ2VkIGNvZGU/
DQpSdW5uaW5nIHRoYXQgd2l0aCBhIHBoeXNpY2FsIG1lbW9yeSBvZmZzZXQgbWFkZSBteSBoZWFk
IGh1cnQuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1s
ZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJh
dGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

