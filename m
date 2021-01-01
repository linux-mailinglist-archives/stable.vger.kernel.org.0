Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4072E8549
	for <lists+stable@lfdr.de>; Fri,  1 Jan 2021 19:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727155AbhAASfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jan 2021 13:35:09 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:60634 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727147AbhAASfJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jan 2021 13:35:09 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-122-YkMGaifVNxGZznooJROwZw-1; Fri, 01 Jan 2021 18:33:29 +0000
X-MC-Unique: YkMGaifVNxGZznooJROwZw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 1 Jan 2021 18:33:28 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 1 Jan 2021 18:33:28 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Andy Lutomirski' <luto@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>
CC:     Arnd Bergmann <arnd@arndb.de>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Will Deacon <will@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: RE: [RFC please help] membarrier: Rewrite sync_core_before_usermode()
Thread-Topic: [RFC please help] membarrier: Rewrite
 sync_core_before_usermode()
Thread-Index: AQHW3XrLzyrfomRRwUafqZ2cHH9jwqoTGagQ
Date:   Fri, 1 Jan 2021 18:33:28 +0000
Message-ID: <30c0fd4917264e75a911527715f5aed3@AcuMS.aculab.com>
References: <bf59ecb5487171a852bcc8cdd553ec797aedc485.1609093476.git.luto@kernel.org>
 <1609199804.yrsu9vagzk.astroid@bobo.none>
 <CALCETrX4v1KEf6ikVtFg6juh3Z_esJ-+6PLT1A21JJeTVh2k8g@mail.gmail.com>
In-Reply-To: <CALCETrX4v1KEf6ikVtFg6juh3Z_esJ-+6PLT1A21JJeTVh2k8g@mail.gmail.com>
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

RnJvbTogQW5keSBMdXRvbWlyc2tpDQo+IFNlbnQ6IDI5IERlY2VtYmVyIDIwMjAgMDA6MzYNCi4u
Lg0KPiBJIG1lYW4gdGhhdCB0aGUgbWFwcGluZyBmcm9tIHRoZSBuYW1lICJzeW5jX2NvcmUiIHRv
IGl0cyBzZW1hbnRpY3MgaXMNCj4geDg2IG9ubHkuICBUaGUgc3RyaW5nICJzeW5jX2NvcmUiIGFw
cGVhcnMgaW4gdGhlIGtlcm5lbCBvbmx5IGluDQo+IGFyY2gveDg2LCBtZW1iYXJyaWVyIGNvZGUs
IG1lbWJhcnJpZXIgZG9jcywgYW5kIGEgc2luZ2xlIFNHSSBkcml2ZXINCj4gdGhhdCBpcyB4ODYt
b25seS4gIFN1cmUsIHRoZSBpZGVhIG9mIHNlcmlhbGl6aW5nIHRoaW5ncyBpcyBmYWlybHkNCj4g
Z2VuZXJpYywgYnV0IGV4YWN0bHkgd2hhdCBvcGVyYXRpb25zIHNlcmlhbGl6ZSB3aGF0LCB3aGVu
IHRoaW5ncyBuZWVkDQo+IHNlcmlhbGl6YXRpb24sIGV0YyBpcyBxdWl0ZSBhcmNoaXRlY3R1cmUg
c3BlY2lmaWMuDQo+IA0KPiBIZWNrLCBvbiA0ODYgeW91IHNlcmlhbGl6ZSB0aGUgaW5zdHJ1Y3Rp
b24gc3RyZWFtIHdpdGggSk1QLg0KDQpEaWQgdGhlIDQ4NiBldmVuIGhhdmUgYSBtZW1vcnkgY2Fj
aGU/DQpOZXZlciBtaW5kIHNlcGFyYXRlIEkmRCBjYWNoZXMuDQpXaXRob3V0IGJyYW5jaCBwcmVk
aWN0aW9uIG9yIGFuIEkkIGEgam1wIGlzIGVub3VnaC4NCk5vIGlkZWEgaG93IHRoZSBkdWFsIDQ4
NiBib3ggd2UgaGFkIGFjdHVhbGx5IGJlaGF2ZWQuDQoNCkZvciBub24tU01QIHRoZSB4ODYgY3B1
cyB0ZW5kIHRvIHN0aWxsIGJlIGNvbXBhdGlibGUgd2l0aA0KdGhlIG9yaWdpbmFsIDgwODYgLSBz
byBhcmUgcHJldHR5IG11Y2ggZnVsbHkgY29oZXJlbnQuDQpJU1RSIHRoZSBtZW1vcnkgd3JpdGVz
IHdpbGwgaW52YWxpZGF0ZSBJJCBsaW5lcy4NCg0KQnV0IHRoZXJlIHdhcyBzb21lIGhhcmR3YXJl
IGNvbXBhdGliaWxpdHkgdGhhdCBtZWFudCBhIGxvYWQNCm9mIFBlbnRpdW0tNzUgc3lzdGVtcyB3
ZXJlICdzY2F2ZW5nZWQnIGZyb20gZGV2ZWxvcG1lbnQgZm9yDQphIGN1c3RvbWVyIC0gd2UgZ290
IGZhc3RlciBQLTI2NiBib3hlcyBhcyByZXBsYWNlbWVudHMuDQoNCk9UT0ggd2UgbmV2ZXIgZGlk
IHdvcmsgb3V0IGhvdyB0byBkbyB0aGUgcmVxdWlyZWQgJ2JhcnJpZXInDQp3aGVuIHN3aXRjaGlu
ZyBhIFZpYSBDMyB0byBhbmQgZnJvbSAxNi1iaXQgbW9kZS4NClNvbWV0aW1lcyBpdCB3b3JrZWQs
IG90aGVyIHRpbWVzIHRoZSBjcHUgd2VudCBBV09MLg0KQmVzdCBndWVzcyB3YXMgdGhhdCBpdCBz
b21ldGltZXMgZXhlY3V0ZWQgcHJlLWRlY29kZWQNCmluc3RydWN0aW9ucyBmb3IgdGhlIHdyb25n
IG1vZGUgd2hlbiByZXR1cm5pbmcgZnJvbSB0aGUNCmZ1bmN0aW9uIGNhbGwgdGhhdCBmbGlwcGVk
IG1vZGVzLg0KDQpUaGVuIHRoZXJlIGlzIHRoZSBQLVBybyBlcmEgSW50ZWwgZG9jIHRoYXQgc2F5
cyB0aGF0IElPUi9JT1cNCmFyZW4ndCBzZXF1ZW5jZWQgd3J0IG1lbW9yeSBhY2Nlc3Nlcy4NCkZv
cnR1bmF0ZWx5IGFsbCB4ODYgcHJvY2Vzc29ycyBoYXZlIHNlcXVlbmNlZCB0aGVtLg0KV2hpY2gg
aXMgd2hhdCB0aGUgY3VycmVudCBkb2NzIHNheS4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQg
QWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVz
LCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

