Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24DA61C2C95
	for <lists+stable@lfdr.de>; Sun,  3 May 2020 14:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbgECM5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 May 2020 08:57:36 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:39616 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728142AbgECM5f (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 May 2020 08:57:35 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-181-BT3qH9VsMz-dk4PkoNseiQ-1; Sun, 03 May 2020 13:57:31 +0100
X-MC-Unique: BT3qH9VsMz-dk4PkoNseiQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sun, 3 May 2020 13:57:30 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sun, 3 May 2020 13:57:30 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Linus Torvalds' <torvalds@linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        stable <stable@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paul Mackerras <paulus@samba.org>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 0/2] Replace and improve "mcsafe" with copy_safe()
Thread-Topic: [PATCH v2 0/2] Replace and improve "mcsafe" with copy_safe()
Thread-Index: AQHWH+ZTSK33XHL44ESHjM2jwgOtw6iWT55g
Date:   Sun, 3 May 2020 12:57:30 +0000
Message-ID: <a4aabe6f2ca649779a772a5f0365af6f@AcuMS.aculab.com>
References: <158823509800.2094061.9683997333958344535.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAHk-=wh6d59KAG_6t+NrCLBz-i0OUSJrqurric=m0ZG850Ddkw@mail.gmail.com>
 <CALCETrVP5k25yCfknEPJm=XX0or4o2b2mnzmevnVHGNLNOXJ2g@mail.gmail.com>
 <CAHk-=widQfxhWMUN3bGxM_zg3az0fRKYvFoP8bEhqsCtaEDVAA@mail.gmail.com>
 <CALCETrVq11YVqGZH7J6A=tkHB1AZUWXnKwAfPUQ-m9qXjWfZtg@mail.gmail.com>
 <20200430192258.GA24749@agluck-desk2.amr.corp.intel.com>
 <CAHk-=wg0Sza8uzQHzJbdt7FFc7bRK+o1BB=VBUGrQEvVv6+23w@mail.gmail.com>
 <CAPcyv4g0a406X9-=NATJZ9QqObim9Phdkb_WmmhsT9zvXsGSpw@mail.gmail.com>
 <CAHk-=wiMs=A90np0Hv5WjHY8HXQWpgtuq-xrrJvyk7_pNB4meg@mail.gmail.com>
 <CAPcyv4jvgCGU700x_U6EKyGsHwQBoPkJUF+6gP4YDPupjdViyQ@mail.gmail.com>
 <CAHk-=wiPkwF2+y6wZd=VD9BooKxHRWhSVW8dr+WSeeSPkJk7kQ@mail.gmail.com>
In-Reply-To: <CAHk-=wiPkwF2+y6wZd=VD9BooKxHRWhSVW8dr+WSeeSPkJk7kQ@mail.gmail.com>
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

RnJvbTogTGludXMgVG9ydmFsZHMNCj4gU2VudDogMDEgTWF5IDIwMjAgMTk6MjkNCi4uLg0KPiBB
bmQgYXMgRGF2aWRMIHBvaW50ZWQgb3V0IC0gaWYgeW91IGV2ZXIgaGF2ZSAiaW9tZW0iIGFzIGEg
c291cmNlIG9yDQo+IGRlc3RpbmF0aW9uLCB5b3UgbmVlZCB5ZXQgYW5vdGhlciBjYXNlLiBOb3Qg
YmVjYXVzZSB0aGV5IGNhbiB0YWtlDQo+IGFub3RoZXIga2luZCBvZiBmYXVsdCAoYWx0aG91Z2gg
b24gc29tZSBwbGF0Zm9ybXMgeW91IGhhdmUgdGhlIG1hY2hpbmUNCj4gY2hlY2tzIGZvciB0aGF0
IHRvbyksIGJ1dCBiZWNhdXNlIHRoZXkgaGF2ZSAqdmVyeSogZGlmZmVyZW50DQo+IHBlcmZvcm1h
bmNlIHByb2ZpbGVzIChhbmQgdGhlIEVSTVMgInJlcCBtb3ZzYiIgc3Vja3MgYmFieSBkb25rZXlz
DQo+IHRocm91Z2ggYSBzdHJhdykuDQoNCg0KSSB3YXMgYWN0dWFsbHkgdGhpbmtpbmcgdGhhdCB0
aGUgbnZkaW1tIGFjY2Vzc2VzIG5lZWQgdG8gYmUgdHJlYXRlZA0KbXVjaCBtb3JlIGxpa2UgKGNh
Y2hlZCkgbWVtb3J5IG1hcHBlZCBpbyBzcGFjZSB0aGFuIG5vcm1hbCBzeXN0ZW0NCm1lbW9yeS4N
ClNvIHRyZWF0aW5nIHRoZW0gdGhlIHNhbWUgYXMgImlvbWVtIiBhbmQgdGhlbiBoYXZpbmcgYWNj
ZXNzIGZ1bmN0aW9ucw0KdGhhdCByZXBvcnQgYWNjZXNzIGZhaWx1cmVzICh3aGljaCB0aGUgY3Vy
cmVudCByZWFkcSgpIGRvZXNuJ3QpDQptaWdodCBtYWtlIHNlbnNlLg0KDQpJZiB5b3UgYXJlIHVz
aW5nIG1lbW9yeSB0aGF0ICdtaWdodCBmYWlsJyBmb3Iga2VybmVsIGNvZGUgb3IgZGF0YQ0KeW91
IHJlYWxseSBnZXQgd2hhdCB5b3UgZGVzZXJ2ZS4NCg0KT1RPSCBzeXN0ZW0gcmVzcG9uc2UgdG8g
UENJZSBlcnJvcnMgaXMgY3VycmVudGx5IHJhdGhlciBwcm9ibGVtYXRpYy4NCk1vc3RseSByZWFk
cyB0aW1lIG91dCBhbmQgcmV0dXJuIH4wdS4NClRoaXMgY2FuIGJlIGNoZWNrZWQgZm9yIGFuZCwg
aWYgcG9zc2libHkgdmFsaWQsIGEgc2Vjb25kIGxvY2F0aW9uIHJlYWQuDQoNCkhvd2V2ZXIgd2Ug
aGF2ZSBhIHg4NiBzZXJ2ZXIgYm94IChJJ3ZlIGZvcmdvdHRlbiB3aGV0aGVyIGl0IGlzIEhQIG9y
DQpEZWxsKSB0aGF0IGdlbmVyYXRlcyBhbiBOTUkgd2hlbmV2ZXIgYSBQQ0llIGxpbmsgZ29lcyBk
b3duLg0KKFRoZSAncGxhdGZvcm0nIHRha2VzIHRoZSBBRVIgaW50ZXJydXB0IGFuZCB1c2VzIGFu
IE5NSSB0byBwYXNzDQppdCB0byB0aGUga2VybmVsIC0gd2hvc2UgYnJpZ2h0IGlkZWEgd2FzIGl0
IHRvIHVzZSBhbiBOTUk/Pz8pDQpUaGlzIGhhcHBlbnMgZXZlbiBhZnRlciB3ZSd2ZSBkb25lIGFu
ICdlY2hvIDEgPnJlbW92ZScuDQpUaGUgc3lzdGVtIGlzIHN1cHBvc2VkIHRvIGJlIE5FQlMgKEkg
dGhpbmsgdGhhdCBpcyB0aGUgdGVybSkgY29tcGxpYW50DQp3aGljaCBpcyBzdXBwb3NlZCB0byBi
ZSBzdWl0YWJsZSBmb3IgdGVsZXBob255IHdvcmsgKGluY2x1ZGluZw0KZW1lcmdlbmN5IGNhbGxz
KSwgYnV0IGFueSBQQ0llIGZhaWx1cmUgY3Jhc2hlcyB0aGUgYm94IQ0KDQpJJ3ZlIGFub3RoZXIg
c3lzdGVtIGhlcmUgdGhhdCBzb21ldGltZXMgZmFpbHMgdG8gYnJpbmcgdGhlIFBDSWUNCmxpbmsg
YmFjayB1cC4NCkkgZ3Vlc3MgdGhlc2UgY29kZSBwYXRocyBkb24ndCBnZXQgcmVndWxhciB0ZXN0
aW5nLg0KSW4gbXkgY2FzZSB0aGUgUENJZSBzbGF2ZSBpcyBhbiBmcGdhLCByZWxvYWRpbmcgdGhl
IGZwZ2EgaW1hZ2UNCihlaXRoZXIgb3ZlciBKVEFHIG9yIGFmdGVyIHJld3JpdGluZyBlZXByb20p
IGRvZXNuJ3QgYWx3YXlzIHdvcmsuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3Mg
TGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQ
VCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

