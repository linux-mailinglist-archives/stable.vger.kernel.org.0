Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694B62540E3
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 10:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgH0Ibd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 04:31:33 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:30501 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727996AbgH0Ibd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 04:31:33 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-64-r33Q5FlvO0ymSv-cNb_SXQ-1; Thu, 27 Aug 2020 09:31:29 +0100
X-MC-Unique: r33Q5FlvO0ymSv-cNb_SXQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 27 Aug 2020 09:31:28 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 27 Aug 2020 09:31:28 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alexander Graf' <graf@amazon.com>,
        'Thomas Gleixner' <tglx@linutronix.de>,
        'X86 ML' <x86@kernel.org>
CC:     'Andy Lutomirski' <luto@kernel.org>,
        'LKML' <linux-kernel@vger.kernel.org>,
        'Andrew Cooper' <andrew.cooper3@citrix.com>,
        "'Paul E. McKenney'" <paulmck@kernel.org>,
        'Alexandre Chartre' <alexandre.chartre@oracle.com>,
        'Frederic Weisbecker' <frederic@kernel.org>,
        'Paolo Bonzini' <pbonzini@redhat.com>,
        'Sean Christopherson' <sean.j.christopherson@intel.com>,
        'Masami Hiramatsu' <mhiramat@kernel.org>,
        'Petr Mladek' <pmladek@suse.com>,
        'Steven Rostedt' <rostedt@goodmis.org>,
        'Joel Fernandes' <joel@joelfernandes.org>,
        'Boris Ostrovsky' <boris.ostrovsky@oracle.com>,
        'Juergen Gross' <jgross@suse.com>,
        "'Mathieu Desnoyers'" <mathieu.desnoyers@efficios.com>,
        'Josh Poimboeuf' <jpoimboe@redhat.com>,
        'Will Deacon' <will@kernel.org>,
        'Tom Lendacky' <thomas.lendacky@amd.com>,
        'Wei Liu' <wei.liu@kernel.org>,
        'Michael Kelley' <mikelley@microsoft.com>,
        'Jason Chen CJ' <jason.cj.chen@intel.com>,
        "'Zhao Yakui'" <yakui.zhao@intel.com>,
        "'Peter Zijlstra (Intel)'" <peterz@infradead.org>,
        'Avi Kivity' <avi@scylladb.com>,
        "'Herrenschmidt, Benjamin'" <benh@amazon.com>,
        "'robketr@amazon.de'" <robketr@amazon.de>,
        "'amos@scylladb.com'" <amos@scylladb.com>,
        'Brian Gerst' <brgerst@gmail.com>,
        "'stable@vger.kernel.org'" <stable@vger.kernel.org>,
        'Alex bykov' <alex.bykov@scylladb.com>
Subject: RE: x86/irq: Unbreak interrupt affinity setting
Thread-Topic: x86/irq: Unbreak interrupt affinity setting
Thread-Index: AQHWe+aKb+AhwM2rPkq6/MK3Hcp5nKlK5iEAgAAGXqCAAAItAIAAsfPQ
Date:   Thu, 27 Aug 2020 08:31:28 +0000
Message-ID: <5943d64220ee457b82f9a61fe17318e9@AcuMS.aculab.com>
References: <20200826115357.3049-1-graf@amazon.com>
 <87k0xlv5w5.fsf@nanos.tec.linutronix.de>
 <fd87a87d-7d8a-9959-6c81-f49003a43c21@amazon.com>
 <87blixuuny.fsf@nanos.tec.linutronix.de>
 <873649utm4.fsf@nanos.tec.linutronix.de>
 <87wo1ltaxz.fsf@nanos.tec.linutronix.de>
 <db3e28b59d404f55aff83120c077d6f6@AcuMS.aculab.com>
 <42ae8716e425495c964ae7372bd7ff52@AcuMS.aculab.com>
 <014fd671-73c1-97f3-cc92-73c2cf9576af@amazon.com>
In-Reply-To: <014fd671-73c1-97f3-cc92-73c2cf9576af@amazon.com>
Accept-Language: en-GB, en-US
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
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogQWxleGFuZGVyIEdyYWYNCj4gU2VudDogMjYgQXVndXN0IDIwMjAgMjM6NTMNCj4gDQo+
IE9uIDI2LjA4LjIwIDIzOjQ3LCBEYXZpZCBMYWlnaHQgd3JvdGU6DQo+ID4NCj4gPiBGcm9tOiBE
YXZpZCBMYWlnaHQNCj4gPj4gU2VudDogMjYgQXVndXN0IDIwMjAgMjI6MzcNCj4gPj4NCj4gPj4g
RnJvbTogVGhvbWFzIEdsZWl4bmVyDQo+ID4+PiBTZW50OiAyNiBBdWd1c3QgMjAyMCAyMToyMg0K
PiA+PiAuLi4NCj4gPj4+IE1vdmluZyBpbnRlcnJ1cHRzIG9uIHg4NiBoYXBwZW5zIGluIHNldmVy
YWwgc3RlcHMuIEEgbmV3IHZlY3RvciBvbiBhDQo+ID4+PiBkaWZmZXJlbnQgQ1BVIGlzIGFsbG9j
YXRlZCBhbmQgdGhlIHJlbGV2YW50IGludGVycnVwdCBzb3VyY2UgaXMNCj4gPj4+IHJlcHJvZ3Jh
bW1lZCB0byB0aGF0LiBCdXQgdGhhdCdzIHJhY3kgYW5kIHRoZXJlIG1pZ2h0IGJlIGFuIGludGVy
cnVwdA0KPiA+Pj4gYWxyZWFkeSBpbiBmbGlnaHQgdG8gdGhlIG9sZCB2ZWN0b3IuIFNvIHRoZSBv
bGQgdmVjdG9yIGlzIHByZXNlcnZlZCB1bnRpbA0KPiA+Pj4gdGhlIGZpcnN0IGludGVycnVwdCBh
cnJpdmVzIG9uIHRoZSBuZXcgdmVjdG9yIGFuZCB0aGUgbmV3IHRhcmdldCBDUFUuIE9uY2UNCj4g
Pj4+IHRoYXQgaGFwcGVucyB0aGUgb2xkIHZlY3RvciBpcyBjbGVhbmVkIHVwLCBidXQgdGhpcyBj
bGVhbnVwIHN0aWxsIGRlcGVuZHMNCj4gPj4+IG9uIHRoZSB2ZWN0b3IgbnVtYmVyIGJlaW5nIHN0
b3JlZCBpbiBwdF9yZWdzOjpvcmlnX2F4LCB3aGljaCBpcyBub3cgLTEuDQo+ID4+DQo+ID4+IEkg
c3VzcGVjdCB0aGF0IGl0IGlzIG11Y2ggbW9yZSAncmFjeScgdGhhbiB0aGF0IGZvciBQQ0ktWCBp
bnRlcnJ1cHRzLg0KPiA+PiBPbiB0aGUgaGFyZHdhcmUgc2lkZSB0aGVyZSBpcyBhbiBpbnRlcnJ1
cHQgZGlzYWJsZSBiaXQsIGFuZCBhZGRyZXNzDQo+ID4+IGFuZCBhIHZhbHVlLg0KPiA+PiBUbyBy
YWlzZSBhbiBpbnRlcnJ1cHQgdGhlIGhhcmR3YXJlIG11c3Qgd3JpdGUgdGhlIHZhbHVlIHRvIHRo
ZSBhZGRyZXNzLg0KPiA+Pg0KPiA+PiBJZiB0aGUgY3B1IG5lZWRzIHRvIG1vdmUgYW4gaW50ZXJy
dXB0IGJvdGggdGhlIGFkZHJlc3MgYW5kIHZhbHVlDQo+ID4+IG5lZWQgY2hhbmdpbmcsIGJ1dCB0
aGUgY3B1IHdvbnQgd3JpdGUgdGhlIGFkZHJlc3MgYW5kIHZhbHVlIHVzaW5nDQo+ID4+IHRoZSBz
YW1lIFRMUCwgc28gdGhlIGhhcmR3YXJlIGNvdWxkIHBvdGVudGlhbGx5IHdyaXRlIGEgdmFsdWUg
dG8NCj4gPj4gdGhlIHdyb25nIGFkZHJlc3MuDQo+ID4+IFdvcnNlIHRoYW4gdGhhdCwgdGhlIGhh
cmR3YXJlIGNvdWxkIGVhc2lseSBvbmx5IGxvb2sgYXQgdGhlIGFkZHJlc3MNCj4gPj4gYW5kIHZh
bHVlIGluIHRoZSBjbG9ja3MgYWZ0ZXIgY2hlY2tpbmcgdGhlIGludGVycnVwdCBpcyBlbmFibGVk
Lg0KPiA+PiBTbyBtYXNraW5nIHRoZSBpbnRlcnJ1cHQgaW1tZWRpYXRlbHkgcHJpb3IgdG8gY2hh
bmdpbmcgdGhlIHZlY3Rvcg0KPiA+PiBpbmZvIG1heSBub3QgYmUgZW5vdWdoLg0KPiA+Pg0KPiA+
PiBJdCBpcyBsaWtlbHkgdGhhdCBhIHJlYWQtYmFjayBvZiB0aGUgbWFzayBiZWZvcmUgdXBkYXRp
bmcgdGhlIHZlY3Rvcg0KPiA+PiBpcyBlbm91Z2guDQo+ID4NCj4gPiBCdXQgbm90IGVub3VnaCB0
byBhc3N1bWUgeW91IHdvbid0IHJlY2VpdmUgYW4gaW50ZXJydXB0IGFmdGVyIHJlYWRpbmcNCj4g
PiBiYWNrIHRoYXQgaW50ZXJydXB0cyBhcmUgbWFza2VkLg0KPiA+DQo+ID4gKEkndmUgaW1wbGVt
ZW50ZWQgdGhlIGhhcmR3YXJlIHNpZGUgZm9yIGFuIGZwZ2EgLi4uKQ0KPiANCj4gRG8gd2UgYWN0
dWFsbHkgY2FyZSBpbiB0aGlzIGNvbnRleHQ/IEFsbCB3ZSB3YW50IHRvIGtub3cgaGVyZSBpcyB3
aGV0aGVyDQo+IGEgZGV2aWNlIChvciBpcnFjaGlwIGluIGJldHdlZW4pIGhhcyBhY3R1YWxseSBu
b3RpY2VkIHRoYXQgaXQgc2hvdWxkDQo+IHBvc3QgdG8gYSBuZXcgdmVjdG9yLiBJZiB3ZSBnZXQg
aW50ZXJydXB0cyBvbiByYW5kb20gb3RoZXIgdmVjdG9ycyBpbg0KPiBiZXR3ZWVuLCB0aGV5IHdv
dWxkIHNpbXBseSBzaG93IHVwIGFzIHNwdXJpb3VzLCBubz8NCj4gDQo+IFNvIEkgZG9uJ3QgcXVp
dGUgc2VlIHdoZXJlIHRoaXMgcGF0Y2ggbWFrZXMgdGhlIHNpdHVhdGlvbiBhbnkgd29yc2UgdGhh
bg0KPiBiZWZvcmUuDQoNCk9oLCBpdCB3b24ndCBtYWtlIGl0IGFueSB3b3JzZS4NCkl0IGp1c3Qg
bWlnaHQgYmUgcmF0aGVyIHdvcnNlIHRoYW4gYW55b25lIGltYWdpbmVkLg0KDQoJRGF2aWQNCg0K
LQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0s
IE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdh
bGVzKQ0K

