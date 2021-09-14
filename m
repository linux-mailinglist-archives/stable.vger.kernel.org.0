Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A6340A8F6
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 10:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhINIPb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 04:15:31 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:24979 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229661AbhINIPb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 04:15:31 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-228-4zbg9E4KPh6_KsOvdYrc_g-1; Tue, 14 Sep 2021 09:14:12 +0100
X-MC-Unique: 4zbg9E4KPh6_KsOvdYrc_g-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Tue, 14 Sep 2021 09:14:11 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Tue, 14 Sep 2021 09:14:11 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'libaokun (A)'" <libaokun1@huawei.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC:     Arnd Bergmann <arnd@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        Kees Cook <keescook@chromium.org>
Subject: RE: [PATCH 5.14 018/334] nbd: add the check to prevent overflow in
 __nbd_ioctl()
Thread-Topic: [PATCH 5.14 018/334] nbd: add the check to prevent overflow in
 __nbd_ioctl()
Thread-Index: AQHXqQ4eXbMSnUIpgkqOMblgrD/eTKujLcBA
Date:   Tue, 14 Sep 2021 08:14:10 +0000
Message-ID: <27e1c6de36354620aaf8ed5a5fa944de@AcuMS.aculab.com>
References: <20210913131113.390368911@linuxfoundation.org>
 <CA+G9fYtdPnwf+fi4Oyxng65pWjW9ujZ7dd2Z-EEEHyJimNHN6g@mail.gmail.com>
 <YT+RKemKfg6GFq0S@kroah.com>
 <CAKwvOdmOAKTkgFK4Oke1SFGR_NxNqXe-buj1uyDgwZ4JdnP2Vg@mail.gmail.com>
 <CAKwvOdmCS5Q7AzUL5nziYVU7RrtRjoE9JjOXfVBWagO1Bzbsew@mail.gmail.com>
 <CA+icZUVuRaMs=bx775gDF88_xzy8LFkBA5xaK21hFDeYvgo12A@mail.gmail.com>
 <CAKwvOdmN3nQe8aL=jUwi0nGXzYQGic=NA2o40Q=yeHeafSsS3g@mail.gmail.com>
 <CAHk-=whwREzjT7=OSi5=qqOkQsvMkCOYVhyKQ5t8Rdq4bBEzuw@mail.gmail.com>
 <CAKwvOdkf3B41RRe8FDkw1H-0hBt1_PhZtZxBZ5pj0pyh7vDLmA@mail.gmail.com>
 <CAHk-=wjP2ijctPt2Hw3DagSZ-KgdRsO6zWTTKQNnSk0MajtJgA@mail.gmail.com>
 <CAKwvOd=ZG8sf1ZOkuidX_49VGkQE+BJDa19_vR4gh2FNQ2F_9Q@mail.gmail.com>
 <CAKwvOdkz4e3HdNKFvOdDDWVijB7AKaeP14_vAEbxWXD1AviVhA@mail.gmail.com>
 <CAKwvOdmtX8Y8eWESYj4W-H-KF7cZx6w1NbSjoSPt5x5U9ezQUQ@mail.gmail.com>
 <CAHk-=whjhJgk7hD-ftUy-8+9cenhMDHqaNKXOyeNVoMxZRD-_A@mail.gmail.com>
 <CAKwvOdnFRhKDZ3XuePSGsuxhOpuS5RmZ1u+MeN=PRPPKSS3wFg@mail.gmail.com>
 <db321a38-f5f6-34cd-2f4f-37fc82201798@huawei.com>
In-Reply-To: <db321a38-f5f6-34cd-2f4f-37fc82201798@huawei.com>
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

Li4uDQo+ICDCoMKgwqDCoMKgwqDCoCBjYXNlIE5CRF9TRVRfU0laRToNCj4gIMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gbmJkX3NldF9zaXplKG5iZCwgYXJnLCBjb25maWct
PmJsa3NpemUpOw0KPiAgwqDCoMKgwqDCoMKgwqAgY2FzZSBOQkRfU0VUX1NJWkVfQkxPQ0tTOg0K
PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoY2hlY2tfbXVsX292ZXJmbG93KChs
b2ZmX3QpYXJnLCBjb25maWctPmJsa3NpemUsDQo+ICZieXRlc2l6ZSkpDQo+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIGlmIChhcmcgJiYgKExMT05HX01BWCAvIGFyZyA8PSBjb25maWct
PmJsa3NpemUpKQ0KPiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCByZXR1cm4gLUVJTlZBTDsNCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0
dXJuIG5iZF9zZXRfc2l6ZShuYmQsIGJ5dGVzaXplLCBjb25maWctPmJsa3NpemUpOw0KPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gbmJkX3NldF9zaXplKG5iZCwgYXJnICog
Y29uZmlnLT5ibGtzaXplLA0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY29uZmlnLT5ibGtzaXplKTsNCg0KU2hv
dWxkbid0IHRoZXJlIGp1c3QgYmUgc2FuaXR5IGJvdW5kIGNoZWNrcyBvbiAnY29uZmlnLT5ibGtz
aXplJyBhbmQNCidhcmcnIHNvIHRoYXQgdGhlIHByb2R1Y3QgaXMgbmV2ZXIgZ29pbmcgdG8gb3Zl
cmZsb3c/DQoNCkl0IGlzbid0IGFzIHRob3VnaCBhbnkgdmFsdWVzIG5lYXIgdGhlIG92ZXJmbG93
IGxpbWl0IGFyZSBzYW5lLg0KDQpJIHN1c3BlY3QgeW91IGNvdWxkIGNoZWNrIGNvbmZpZy0+Ymxr
c2l6ZSA8PSA2NGsgJiYgYXJnIDw9IDMyaw0KYW5kIGV2ZW4gdGhhdCB3b3VsZCBiZSBnZW5lcm91
cy4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBS
b2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9u
IE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

