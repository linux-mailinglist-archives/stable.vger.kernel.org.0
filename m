Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA14258AC2
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 10:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgIAIvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 04:51:23 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:39255 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727824AbgIAIvR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 04:51:17 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-118-LZ28NOJPPTaVtO94LDjr0g-1; Tue, 01 Sep 2020 09:51:13 +0100
X-MC-Unique: LZ28NOJPPTaVtO94LDjr0g-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 1 Sep 2020 09:51:12 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 1 Sep 2020 09:51:12 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Nick Desaulniers' <ndesaulniers@google.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Kees Cook <keescook@chromium.org>
CC:     Masahiro Yamada <masahiroy@kernel.org>,
        Joe Perches <joe@perches.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        stable <stable@vger.kernel.org>, Andy Lavr <andy.lavr@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "Sami Tolvanen" <samitolvanen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Yury Norov <yury.norov@gmail.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] lib/string.c: implement stpcpy
Thread-Topic: [PATCH v3] lib/string.c: implement stpcpy
Thread-Index: AQHWf+14nZWdJbVkRkiz0fwM7UWCxalTeddg
Date:   Tue, 1 Sep 2020 08:51:12 +0000
Message-ID: <5989b2666acb49ccb2d34a0b91f36923@AcuMS.aculab.com>
References: <20200825135838.2938771-1-ndesaulniers@google.com>
 <CAK7LNAQXo5-5W6hvNMEVPBPf3tRWaf-pQdSR-0OHyi4RCGhjsQ@mail.gmail.com>
 <d56bf7b93f7a28c4a90e4e16fd412e6934704346.camel@perches.com>
 <CAKwvOd=YrVtPsB7HYPO0N=K7QJm9KstayqqeYQERSaGtGy2Bjg@mail.gmail.com>
 <CAK7LNAQKwOo=Oas+7Du9+neSm=Ev6pxdPV7ges7eEEpW+jh8Ug@mail.gmail.com>
 <202008261627.7B2B02A@keescook>
 <CAHp75VfniSw3AFTyyDk2OoAChGx7S6wF7sZKpJXNHmk97BoRXA@mail.gmail.com>
 <202008271126.2C397BF6D@keescook>
 <CAHp75VeA6asim81CwxPD7LKc--DEvOWH9fwgQ9Bbb1Xf55OYKw@mail.gmail.com>
 <202008271523.88796F201F@keescook>
 <CAHp75VcGOvYOXCaQeux5PQ+tHRYF3W=173s80U=mDE-0zzwTXg@mail.gmail.com>
 <CAKwvOdnV6GySbhKGVEUBV5GdanR9xRWAFE0JPcpORR=2dmRWPg@mail.gmail.com>
In-Reply-To: <CAKwvOdnV6GySbhKGVEUBV5GdanR9xRWAFE0JPcpORR=2dmRWPg@mail.gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBPZiBjb3Vyc2UsIG5vICJUcnVlIFNjb3RzbWFuIiB3b3VsZCBhY2NpZGVudGFsbHkgbWlzdXNl
IEMgc3RyaW5nLmggQVBJIQ0KPiBodHRwczovL3lvdXJsb2dpY2FsZmFsbGFjeWlzLmNvbS9uby10
cnVlLXNjb3RzbWFuDQoNCkdvb2dsZSB3aWxsIGZpbmQgcGxlbnR5IG9mOg0KCXN0cltzdHJsZW4o
c3RyKV0gPSAwOw0KDQogICBEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUs
IEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJl
Z2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

