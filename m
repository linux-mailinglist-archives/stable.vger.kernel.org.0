Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10CE536F6B
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 11:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbfFFJF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 05:05:26 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:48640 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727458AbfFFJFZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 05:05:25 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-40-6UGy0nLHMBKpA3Kyw3XgcA-1; Thu, 06 Jun 2019 10:05:22 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 6 Jun 2019 10:05:21 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 6 Jun 2019 10:05:21 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Linus Torvalds' <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Davidlohr Bueso" <dbueso@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>,
        "e@80x24.org" <e@80x24.org>, Jason Baron <jbaron@akamai.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "omar.kilani@gmail.com" <omar.kilani@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        stable <stable@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: RE: [PATCH -mm 0/1] signal: simplify
 set_user_sigmask/restore_user_sigmask
Thread-Topic: [PATCH -mm 0/1] signal: simplify
 set_user_sigmask/restore_user_sigmask
Thread-Index: AQHVG8OiWeMKMn2zNEeA0y96arbBsKaOUFtA
Date:   Thu, 6 Jun 2019 09:05:21 +0000
Message-ID: <1285a2e60e3748d8825b9b0e3500cd28@AcuMS.aculab.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com> <20190604134117.GA29963@redhat.com>
 <20190605155801.GA25165@redhat.com>
 <CAHk-=wjkNx8u4Mcm5dfSQKYQmLQAv1Z1yGLDZvty7BVSj4eqBA@mail.gmail.com>
In-Reply-To: <CAHk-=wjkNx8u4Mcm5dfSQKYQmLQAv1Z1yGLDZvty7BVSj4eqBA@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: 6UGy0nLHMBKpA3Kyw3XgcA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogTGludXMgVG9ydmFsZHMNCj4gU2VudDogMDUgSnVuZSAyMDE5IDE4OjI1DQo+IE9uIFdl
ZCwgSnVuIDUsIDIwMTkgYXQgODo1OCBBTSBPbGVnIE5lc3Rlcm92IDxvbGVnQHJlZGhhdC5jb20+
IHdyb3RlOg0KPiA+DQo+ID4gVG8gc2ltcGxpZnkgdGhlIHJldmlldywgcGxlYXNlIHNlZSB0aGUg
Y29kZSB3aXRoIHRoaXMgcGF0Y2ggYXBwbGllZC4NCj4gPiBJIGFtIHVzaW5nIGVwb2xsX3B3YWl0
KCkgYXMgYW4gZXhhbXBsZSBiZWNhdXNlIGl0IGxvb2tzIHZlcnkgc2ltcGxlLg0KPiANCj4gSSBs
aWtlIGl0Lg0KPiANCj4gSG93ZXZlci4NCj4gDQo+IEkgdGhpbmsgSSdkIGxpa2UgaXQgZXZlbiBt
b3JlIGlmIHdlIGp1c3Qgc2FpZCAid2UgZG9uJ3QgbmVlZA0KPiByZXN0b3JlX3NhdmVkX3NpZ21h
c2sgQVQgQUxMIi4NCj4gDQo+IFdoaWNoIHdvdWxkIGJlIGZhaXJseSBlYXN5IHRvIGRvIHdpdGgg
c29tZXRoaW5nIGxpa2UgdGhlIGF0dGFjaGVkLi4uDQoNClRoYXQgd291bGQgYWx3YXlzIGNhbGwg
dGhlIHNpZ25hbCBoYW5kbGVycyBldmVuIHdoZW4gRUlOVFIgd2Fzbid0DQpiZWluZyByZXR1cm5l
ZCAod2hpY2ggSSB0aGluayBvdWdodCB0byBoYXBwZW4gLi4uKS4NClRoZSByZWFsIHB1cnBvc2Ug
b2YgcmVzdG9yZV9zYXZlZF9zaWdtYXNrKCkgaXMgdG8gc3RvcCBzaWduYWwNCmhhbmRsZXJzIHRo
YXQgYXJlIGVuYWJsZWQgYnkgdGhlIHRlbXBvcmFyeSBtYXNrIGJlaW5nIGNhbGxlZC4NCg0KSWYg
YSBzaWduYWwgaGFuZGxlciBpcyBjYWxsZWQsIEkgcHJlc3VtZSB0aGF0IHRoZSB0cmFtcG9saW5l
DQpjYWxscyBiYWNrIGludG8gdGhlIGtlcm5lbCB0byBnZXQgZnVydGhlciBoYW5kbGVycyBjYWxs
ZWQNCmFuZCB0byBmaW5hbGx5IHJlc3RvcmUgdGhlIG9yaWdpbmFsIHNpZ25hbCBtYXNrPw0KDQpX
aGF0IGhhcHBlbnMgaWYgYSBzaWduYWwgaGFuZGxlciBjYWxscyBzb21ldGhpbmcgdGhhdA0Kd291
bGQgbm9ybWFsbHkgd3JpdGUgdG8gY3VycmVudC0+c2F2ZWRfc2lnbWFzaz8NCg0KCURhdmlkDQoN
Ci0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJt
LCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChX
YWxlcykNCg==

