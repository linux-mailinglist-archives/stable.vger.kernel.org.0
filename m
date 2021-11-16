Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077FD452DFE
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 10:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbhKPJdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 04:33:23 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:36866 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233133AbhKPJdN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 04:33:13 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-239--w25oYSSNc6H4O020wqeeA-1; Tue, 16 Nov 2021 09:30:13 +0000
X-MC-Unique: -w25oYSSNc6H4O020wqeeA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Tue, 16 Nov 2021 09:30:12 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Tue, 16 Nov 2021 09:30:12 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alistair Delva' <adelva@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>
CC:     Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        "Khazhismel Kumykov" <khazhy@google.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Serge Hallyn" <serge@hallyn.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Moore <paul@paul-moore.com>,
        SElinux list <selinux@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Subject: RE: [PATCH] block: Check ADMIN before NICE for IOPRIO_CLASS_RT
Thread-Topic: [PATCH] block: Check ADMIN before NICE for IOPRIO_CLASS_RT
Thread-Index: AQHX2n2CNxSicaUdZEuXqRynLrd2WawF4ZBA
Date:   Tue, 16 Nov 2021 09:30:12 +0000
Message-ID: <43aeb7451621474ea0d7bee6b99039c3@AcuMS.aculab.com>
References: <20211115173850.3598768-1-adelva@google.com>
 <CAFqZXNvVHv8Oje-WV6MWMF96kpR6epTsbc-jv-JF+YJw=55i1w@mail.gmail.com>
 <CANDihLEFZAz8DwkkMGiDJnDMjxiUuSCanYsJtkRwa9RoyruLFA@mail.gmail.com>
In-Reply-To: <CANDihLEFZAz8DwkkMGiDJnDMjxiUuSCanYsJtkRwa9RoyruLFA@mail.gmail.com>
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

RnJvbTogQWxpc3RhaXIgRGVsdmENCj4gU2VudDogMTUgTm92ZW1iZXIgMjAyMSAxOTowOQ0KLi4u
DQo+ID4gPiAtICAgICAgICAgICAgICAgICAgICAgICBpZiAoIWNhcGFibGUoQ0FQX1NZU19OSUNF
KSAmJiAhY2FwYWJsZShDQVBfU1lTX0FETUlOKSkNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAg
ICAgIGlmICghY2FwYWJsZShDQVBfU1lTX0FETUlOKSAmJiAhY2FwYWJsZShDQVBfU1lTX05JQ0Up
KQ0KPiA+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gLUVQRVJNOw0K
DQpJc24ndCB0aGUgcmVhbCBwcm9ibGVtIHRoYXQgeW91IGFjdHVhbGx5IHdhbnQgdG8gdGVzdDoN
CgkJaWYgKCFjYXBhYmxlKENBUF9TWVNfTklDRSB8IENBUF9TWVNfQURNSU4pKQ0KCQkJcmV0dXJu
IC1FUEVSTTsNCnNvIHRoYXQgeW91IG9ubHkgZ2V0IHRoZSBmYWlsICdzcGxhdCcgd2hlbiBuZWl0
aGVyIGlzIHNldC4NCg0KVGhpcyB3aWxsIGJlIHRydWUgd2hlbmV2ZXIgbW9yZSB0aGFuIG9uZSBj
YXBhYmlsaXR5IGVuYWJsZXMgc29tZXRoaW5nLg0KDQpQb3NzaWJseSB0aGlzIG5lZWRzIHNvbWV0
aGluZyBsaWtlOg0KaW50IGNhcGFiYWxlX29yKHVuc2lnbmVkIGludCwgLi4uKTsNCiNkZWZpbmUg
Y2FwYWJhbGVfb3IoLi4uKSBjYXBhYmFibGVfb3IoX19WQV9MSVNUX18sIH4wdSkNCg0KCURhdmlk
DQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBG
YXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2
IChXYWxlcykNCg==

