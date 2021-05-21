Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447CF38C368
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 11:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236690AbhEUJk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 05:40:29 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:51177 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229588AbhEUJk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 05:40:28 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-48-ACZyF3WhMFusJGlOpJA7Qw-1; Fri, 21 May 2021 10:39:03 +0100
X-MC-Unique: ACZyF3WhMFusJGlOpJA7Qw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Fri, 21 May 2021 10:39:01 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Fri, 21 May 2021 10:39:01 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Marco Elver' <elver@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC:     "glider@google.com" <glider@google.com>,
        "dvyukov@google.com" <dvyukov@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>,
        Mel Gorman <mgorman@suse.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] kfence: use TASK_IDLE when awaiting allocation
Thread-Topic: [PATCH] kfence: use TASK_IDLE when awaiting allocation
Thread-Index: AQHXThvT1D7AluRty02nSL8F2LU+eKrtrQGA
Date:   Fri, 21 May 2021 09:39:01 +0000
Message-ID: <bc14f4f1a3874e55bef033246768a775@AcuMS.aculab.com>
References: <20210521083209.3740269-1-elver@google.com>
In-Reply-To: <20210521083209.3740269-1-elver@google.com>
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

RnJvbTogTWFyY28gRWx2ZXINCj4gU2VudDogMjEgTWF5IDIwMjEgMDk6MzINCj4gDQo+IFNpbmNl
IHdhaXRfZXZlbnQoKSB1c2VzIFRBU0tfVU5JTlRFUlJVUFRJQkxFIGJ5IGRlZmF1bHQsIHdhaXRp
bmcgZm9yIGFuDQo+IGFsbG9jYXRpb24gY291bnRzIHRvd2FyZHMgbG9hZC4gSG93ZXZlciwgZm9y
IEtGRU5DRSwgdGhpcyBkb2VzIG5vdCBtYWtlDQo+IGFueSBzZW5zZSwgc2luY2UgdGhlcmUgaXMg
bm8gYnVzeSB3b3JrIHdlJ3JlIGF3YWl0aW5nLg0KPiANCj4gSW5zdGVhZCwgdXNlIFRBU0tfSURM
RSB2aWEgd2FpdF9ldmVudF9pZGxlKCkgdG8gbm90IGNvdW50IHRvd2FyZHMgbG9hZC4NCg0KRG9l
c24ndCB0aGF0IGxldCB0aGUgcHJvY2VzcyBiZSBpbnRlcnJ1cHRpYmxlIGJ5IGEgc2lnbmFsLg0K
V2hpY2ggaXMgcHJvYmFibHkgbm90IGRlc2lyYWJsZS4NCg0KVGhlcmUgcmVhbGx5IG91Z2h0IHRv
IGJlIGEgd2F5IG9mIHNsZWVwaW5nIHdpdGggVEFTS19VTklOVEVSUlVQVElCTEUNCndpdGhvdXQg
Y2hhbmdpbmcgdGhlIGxvYWQtYXZlcmFnZS4NCg0KSUlSQyB0aGUgbG9hZC1hdmVyYWdlIGlzIHJl
YWxseSBpbnRlbmRlZCB0byBpbmNsdWRlIHByb2Nlc3Nlcw0KdGhhdCBhcmUgd2FpdGluZyBmb3Ig
ZGlzayAtIGVzcGVjaWFsbHkgZm9yIHN3YXAuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFk
ZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywg
TUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

