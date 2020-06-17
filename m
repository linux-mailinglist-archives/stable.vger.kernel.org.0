Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44451FC872
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 10:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbgFQIVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 04:21:33 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:41172 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725901AbgFQIVd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jun 2020 04:21:33 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-151-NNVoDzt9NdeCYy0h9mSXPw-1; Wed, 17 Jun 2020 09:21:29 +0100
X-MC-Unique: NNVoDzt9NdeCYy0h9mSXPw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 17 Jun 2020 09:21:28 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 17 Jun 2020 09:21:28 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Charan Teja Kalla' <charante@codeaurora.org>,
        "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        "DRI mailing list" <dri-devel@lists.freedesktop.org>
CC:     Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
        "vinmenon@codeaurora.org" <vinmenon@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] dmabuf: use spinlock to access dmabuf->name
Thread-Topic: [PATCH] dmabuf: use spinlock to access dmabuf->name
Thread-Index: AQHWRHCUCFGeEhsHd0uEJ3SlJWBlmajcdwBw
Date:   Wed, 17 Jun 2020 08:21:28 +0000
Message-ID: <b686a288cff640acaea1111fed650b02@AcuMS.aculab.com>
References: <316a5cf9-ca71-6506-bf8b-e79ded9055b2@codeaurora.org>
 <14063C7AD467DE4B82DEDB5C278E8663010F365EF5@fmsmsx107.amr.corp.intel.com>
 <14063C7AD467DE4B82DEDB5C278E8663010F365F7D@fmsmsx107.amr.corp.intel.com>
 <5b960c9a-ef9d-b43d-716d-113efc793fe5@codeaurora.org>
In-Reply-To: <5b960c9a-ef9d-b43d-716d-113efc793fe5@codeaurora.org>
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

RnJvbTogQ2hhcmFuIFRlamEgS2FsbGENCj4gU2VudDogMTcgSnVuZSAyMDIwIDA3OjI5DQouLi4N
Cj4gPj4gSWYgbmFtZSBpcyBmcmVlZCB5b3Ugd2lsbCBjb3B5IGdhcmJhZ2UsIGJ1dCB0aGUgb25s
eSB3YXkNCj4gPj4gZm9yIHRoYXQgdG8gaGFwcGVuIGlzIHRoYXQgX3NldF9uYW1lIG9yIF9yZWxl
YXNlIGhhdmUgdG8gYmUgY2FsbGVkDQo+ID4+IGF0IGp1c3QgdGhlIHJpZ2h0IHRpbWUuDQo+ID4+
DQo+ID4+IEFuZCB0aGUgYWJvdmUgd291bGQgcHJvYmFibHkgb25seSBiZSBhbiBpc3N1ZSBpZiB0
aGUgc2V0X25hbWUNCj4gPj4gd2FzIGNhbGxlZCwgc28geW91IHdpbGwgZ2V0IE5VTEwgb3IgYSBy
ZWFsIG5hbWUuDQo+IA0KPiBBbmQgdGhlcmUgZXhpc3RzIGEgdXNlLWFmdGVyLWZyZWUgdG8gYXZv
aWQgd2hpY2ggcmVxdWlyZXMgdGhlIGxvY2suIFNheQ0KPiB0aGF0IG1lbWNweSgpIGluIGRtYWJ1
ZmZzX2RuYW1lIGlzIGluIHByb2dyZXNzIGFuZCBpbiBwYXJhbGxlbCBfc2V0X25hbWUNCj4gd2ls
bCBmcmVlIHRoZSBzYW1lIGJ1ZmZlciB0aGF0IG1lbWNweSBpcyBvcGVyYXRpbmcgb24uDQoNCklm
IHRoZSBuYW1lIGlzIGJlaW5nIGxvb2tlZCBhdCB3aGlsZSB0aGUgaXRlbSBpcyBiZWluZyBmcmVl
ZA0KeW91IGFsbW9zdCBjZXJ0YWlubHkgaGF2ZSBtdWNoIGJpZ2dlciBwcm9ibGVtcyB0aGF0IGp1
c3QNCnRoZSBuYW1lIGJlaW5nIGEgJ2p1bmsnIHBvaW50ZXIuDQoNCglEYXZpZC4NCg0KLQ0KUmVn
aXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRv
biBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

