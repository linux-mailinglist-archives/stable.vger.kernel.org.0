Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF1F13C8A6
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 17:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728986AbgAOQBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 11:01:33 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:57834 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726483AbgAOQBd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 11:01:33 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-48-aB_HKFAFOgqZVfOEL6ySEg-1; Wed, 15 Jan 2020 16:01:29 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 15 Jan 2020 16:01:28 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 15 Jan 2020 16:01:28 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Waiman Long' <longman@redhat.com>, Christoph Hellwig <hch@lst.de>
CC:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] locking/rwsem: Fix kernel crash when spinning on
 RWSEM_OWNER_UNKNOWN
Thread-Topic: [PATCH] locking/rwsem: Fix kernel crash when spinning on
 RWSEM_OWNER_UNKNOWN
Thread-Index: AQHVy6/pULnrp2X9K02rMSrf0oH55Kfr1QMwgAAJ44CAAAJXgA==
Date:   Wed, 15 Jan 2020 16:01:28 +0000
Message-ID: <8930570b92aa435b941c99dff00c7802@AcuMS.aculab.com>
References: <20200114190303.5778-1-longman@redhat.com>
 <20200115065055.GA21219@lst.de>
 <021830af-fd89-50e5-ad26-6061e5abdce1@redhat.com>
 <45b976af3cf74555af7214993e7d614b@AcuMS.aculab.com>
 <4ac00b33-5397-3c69-6cba-cf3d9d375ea9@redhat.com>
In-Reply-To: <4ac00b33-5397-3c69-6cba-cf3d9d375ea9@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: aB_HKFAFOgqZVfOEL6ySEg-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogV2FpbWFuIExvbmcNCj4gU2VudDogMTUgSmFudWFyeSAyMDIwIDE1OjQ4DQouLi4NCj4g
SXQgZGVwZW5kcy4gSSBmaW5kIGl0IGhhcmQgdG8gcmVhZCBhbiBleHByZXNzaW9uIHdpdGggIiYi
IGFuZCAiJiYiDQo+IHdpdGhvdXQgcGFyZW50aGVzZXMuIEFueXdheSwgSSB3aWxsIGFkbWl0IHRo
YXQgdGhlIGFib3ZlIGNvZGUgaXMNCj4gaW5jb25zaXN0ZW50IGluIHRlcm0gb2YgaG93IHBhcmVu
dGhlc2VzIGFyZSB1c2VkLiBTbyBJIHdpbGwgY2hhbmdlIHRoYXQuDQoNCkNvbmRpdGlvbmFscyBj
b250YWluaW5nIGZyYWdtZW50cyBsaWtlIChhID09IGIgJiYgYyA9PSBkICYmIC4uLikNCmFyZSBt
dWNoIGVhc2llciB0byByZWFkIHdpdGhvdXQgYW55IGV4dHJhICgpLg0KDQpUaGUgb25seSBwcm9i
bGVtIHdpdGggJiYgaXMgdGhhdCB3aGVuIEsmUiBhZGRlZCBpdCB0byBDIHRoZXkgZGlkbid0DQpj
aGFuZ2UgdGhlIHByaW9yaXR5IG9mICYgdG8gYmUgaGlnaGVyIHRoYW4gPT0gKHdoZXJlIGl0IHNo
b3VsZCBiZSkuDQpBdCB0aGF0IHRpbWUgdGhleSBjb3VsZCBoYXZlIGNoYW5nZWQgYWxsIHRoZSBl
eGlzdGluZyBjb2RlLi4uDQpNb2Rlcm4gY29tcGlsZXJzIGRvIHdhcm4gYWJvdXQgKGEgPT0gYiAm
IGMpLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5
IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRp
b24gTm86IDEzOTczODYgKFdhbGVzKQ0K

