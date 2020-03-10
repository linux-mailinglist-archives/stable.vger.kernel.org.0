Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D81ED180120
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 16:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgCJPGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 11:06:01 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:54141 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726295AbgCJPGB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 11:06:01 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-210-iSMpx19TOieG95yzzI3csw-1; Tue, 10 Mar 2020 15:05:58 +0000
X-MC-Unique: iSMpx19TOieG95yzzI3csw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 10 Mar 2020 15:05:57 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 10 Mar 2020 15:05:57 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Marco Elver' <elver@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>
CC:     Chris Wilson <chris@chris-wilson.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] list: Prevent compiler reloads inside 'safe' list
 iteration
Thread-Topic: [PATCH] list: Prevent compiler reloads inside 'safe' list
 iteration
Thread-Index: AQHV9r1KBrT+D4Vo2U+Op9v/Nv0od6hBsdzwgAAEwQCAAAWYAIAAIYhOgAAPJuA=
Date:   Tue, 10 Mar 2020 15:05:57 +0000
Message-ID: <77ff4da6b0a7448c947af6de4fb43cdb@AcuMS.aculab.com>
References: <20200310092119.14965-1-chris@chris-wilson.co.uk>
 <2e936d8fd2c445beb08e6dd3ee1f3891@AcuMS.aculab.com>
 <158384100886.16414.15741589015363013386@build.alporthouse.com>
 <723d527a4ad349b78bf11d52eba97c0e@AcuMS.aculab.com>
 <20200310125031.GY2935@paulmck-ThinkPad-P72>
 <CANpmjNNT3HY7i9TywX0cAFqBtx2J3qOGOUG5nHzxAZ4bk_qgtg@mail.gmail.com>
In-Reply-To: <CANpmjNNT3HY7i9TywX0cAFqBtx2J3qOGOUG5nHzxAZ4bk_qgtg@mail.gmail.com>
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

RnJvbTogTWFyY28gRWx2ZXINCj4gU2VudDogMTAgTWFyY2ggMjAyMCAxNDoxMA0KLi4uDQo+IEZX
SVcsIGZvciB3cml0ZXMgd2UncmUgYWxyZWFkeSBiZWluZyBxdWl0ZSBnZW5lcm91cywgaW4gdGhh
dCBwbGFpbg0KPiBhbGlnbmVkIHdyaXRlcyB1cCB0byB3b3JkLXNpemUgYXJlIGFzc3VtZWQgdG8g
YmUgImF0b21pYyIgd2l0aCB0aGUNCj4gZGVmYXVsdCAoY29uc2VydmF0aXZlKSBjb25maWcsIGku
ZS4gbWFya2luZyBzdWNoIHdyaXRlcyBpcyBvcHRpb25hbC4NCj4gQWx0aG91Z2gsIHRoYXQncyBh
IGdlbmVyb3VzIGFzc3VtcHRpb24gdGhhdCBpcyBub3QgYWx3YXlzIGd1YXJhbnRlZWQNCj4gdG8g
aG9sZCAoaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8yMDE5MDgyMTEwMzIwMC5rcHVmd3R2
aXFocGJ1djJuQHdpbGxpZS10aGUtdHJ1Y2svKS4NCg0KUmVtaW5kIG1lIHRvIHN0YXJ0IHdyaXRp
bmcgZXZlcnl0aGluZyBpbiBhc3NlbWJsZXIuDQoNClRoYXQgYW5kIHRvIG1hcmsgYWxsIHN0cnVj
dHVyZSBtZW1iZXJzICd2b2xhdGlsZScuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJl
c3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsx
IDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

