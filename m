Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4197E1C0EFF
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 09:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbgEAHqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 03:46:55 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:41023 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728383AbgEAHqy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 03:46:54 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-236-crWB7YfiO5yLJYsQLeM4Tg-1; Fri, 01 May 2020 08:46:50 +0100
X-MC-Unique: crWB7YfiO5yLJYsQLeM4Tg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 1 May 2020 08:46:49 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 1 May 2020 08:46:49 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Andy Lutomirski' <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC:     Dan Williams <dan.j.williams@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        stable <stable@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Erwin Tsaur" <erwin.tsaur@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 0/2] Replace and improve "mcsafe" with copy_safe()
Thread-Topic: [PATCH v2 0/2] Replace and improve "mcsafe" with copy_safe()
Thread-Index: AQHWHx8fSK33XHL44ESHjM2jwgOtw6iS1wyw
Date:   Fri, 1 May 2020 07:46:48 +0000
Message-ID: <6c0ca300a3b54b86abac79d6549a0a40@AcuMS.aculab.com>
References: <158823509800.2094061.9683997333958344535.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAHk-=wh6d59KAG_6t+NrCLBz-i0OUSJrqurric=m0ZG850Ddkw@mail.gmail.com>
 <CALCETrVP5k25yCfknEPJm=XX0or4o2b2mnzmevnVHGNLNOXJ2g@mail.gmail.com>
 <CAHk-=widQfxhWMUN3bGxM_zg3az0fRKYvFoP8bEhqsCtaEDVAA@mail.gmail.com>
 <CALCETrVq11YVqGZH7J6A=tkHB1AZUWXnKwAfPUQ-m9qXjWfZtg@mail.gmail.com>
In-Reply-To: <CALCETrVq11YVqGZH7J6A=tkHB1AZUWXnKwAfPUQ-m9qXjWfZtg@mail.gmail.com>
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

RnJvbTogQW5keSBMdXRvbWlyc2tpDQo+IFNlbnQ6IDMwIEFwcmlsIDIwMjAgMTk6NDINCi4uLg0K
PiBJIHN1cHBvc2UgdGhlcmUgY291bGQgYmUgYSBjb25zaXN0ZW50IG5hbWluZyBsaWtlIHRoaXM6
DQo+IA0KPiBjb3B5X2Zyb21fdXNlcigpDQo+IGNvcHlfdG9fdXNlcigpDQo+IA0KPiBjb3B5X2Zy
b21fdW5jaGVja2VkX2tlcm5lbF9hZGRyZXNzKCkgW3doYXQgcHJvYmVfa2VybmVsX3JlYWQoKSBp
c10NCj4gY29weV90b191bmNoZWNrZWRfa2VybmVsX2FkZHJlc3MoKSBbd2hhdCBwcm9iZV9rZXJu
ZWxfd3JpdGUoKSBpc10NCj4gDQo+IGNvcHlfZnJvbV9mYWxsaWJsZSgpIFtmcm9tIGEga2VybmVs
IGFkZHJlc3MgdGhhdCBjYW4gZmFpbCB0byBhIGtlcm5lbA0KPiBhZGRyZXNzIHRoYXQgY2FuJ3Qg
ZmFpbF0NCj4gY29weV90b19mYWxsaWJsZSgpIFt0aGUgb3Bwb3NpdGUsIGJ1dCBob3BlZnVsbHkg
aWRlbnRpY2FsIHRvIG1lbWNweSgpIG9uIHg4Nl0NCj4gDQo+IGNvcHlfZnJvbV9mYWxsaWJsZV90
b191c2VyKCkNCj4gY29weV9mcm9tX3VzZXJfdG9fZmFsbGlibGUoKQ0KDQpZb3UgbWlzc2VkIG91
dDoNCmNvcHlfdG8vZnJvbV9pbygpDQpjb3B5X3RvX2lvX2Zyb21fdXNlcigpDQpjb3B5X2Zyb21f
aW9fdG9fdXNlcigpDQpBbGwgb2Ygd2hpY2ggd2FudCBhbGlnbmVkIGFkZHJlc3NlcyBvbiB0aGUg
J2lvJyBzaWRlLg0KDQpJdCBtaWdodCBldmVuIGJlIHdvcnRoIHNheWluZyB0aGF0IHRoZSBjb3B5
X3RvL2Zyb21faW8oKSBjYW4NCmZhaWwgZHVlIHRvIGJhZCBJTyBhY2Nlc3NlcyAocmF0aGVyIHRo
YW4gYmFkIGFkZHJlc3NlcykuDQpUaGlzIGlzIG5vdCBlbnRpcmVseSB1bmV4cGVjdGVkIHNpbmNl
IGFsbCBQQ0llIGFjY2Vzc2VzDQpjYW4gZmFpbCB1bmV4cGVjdGVkbHkgKHVzdWFsbHkgd2l0aG91
dCBhIHRyYXAgYW5kIHJldHVybmluZyAtMSkuDQpCdXQgYSBzeXN0ZW0gY291bGQgYXJyYW5nZSB0
byBnZW5lcmF0ZSBhIHN5bmNocm9ub3VzIGZhdWx0Lg0KDQpJZiB5b3UgYXJlIGNvcHlpbmcgZGly
ZWN0bHkgZnJvbSBpbyB0byB1c2VyIHlvdSBuZWVkIHRvDQpkaWZmZXJlbnRpYXRlIGJldHdlZW4g
YSB1c2VyIHBhZ2UgZmF1bHQgYW5kIGFuIGlvIGFjY2Vzcw0KZXJyb3IuIFRoZSBsYXR0ZXIgc2hv
dWxkbid0IGdlbmVyYXRlIFNJR1NFR1YuDQpQb3NzaWJseSByZXR1cm4gLUVGQVVMVCBvbiB1c2Vy
IHBhZ2UgZmF1bHQgYW5kICd0cmFuc2Zlcg0KbGVuZ3RoIHJlbWFpbmluZycgb24gaW8gYWNjZXNz
IGVycm9yLg0KQWx0aG91Z2ggZmlsbGluZyB0aGUgcmVzdCBvZiB0aGUgYnVmZmVyIHdpdGggMHhm
ZiBtaWdodCBiZQ0KYXBwcm9wcmlhdGUuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJl
c3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsx
IDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

