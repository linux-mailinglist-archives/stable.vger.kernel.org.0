Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8791A4CB3DD
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 01:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbiCCAgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 19:36:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbiCCAgS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 19:36:18 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 51C596E8FA
        for <stable@vger.kernel.org>; Wed,  2 Mar 2022 16:35:31 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-311-7RM7CtFePyCzuKvpOGMVlQ-1; Thu, 03 Mar 2022 00:35:28 +0000
X-MC-Unique: 7RM7CtFePyCzuKvpOGMVlQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Thu, 3 Mar 2022 00:35:27 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Thu, 3 Mar 2022 00:35:27 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alviro Iskandar Setiawan' <alviro.iskandar@gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
CC:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Hladky <hladky.jiri@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: RE: [PATCH v4 1/2] x86/delay: Fix the wrong asm constraint in
 `delay_loop()`
Thread-Topic: [PATCH v4 1/2] x86/delay: Fix the wrong asm constraint in
 `delay_loop()`
Thread-Index: AQHYLWA7QzUkKsf/ZkuVhNGB2yFzFqyszW4Q
Date:   Thu, 3 Mar 2022 00:35:27 +0000
Message-ID: <66212b59eb1647b59b900ca85e00f195@AcuMS.aculab.com>
References: <20220301094608.118879-1-ammarfaizi2@gnuweeb.org>
 <20220301094608.118879-2-ammarfaizi2@gnuweeb.org>
 <CAOG64qPgTv5tQNknuG9d-=oL2EPQQ1ys7xu2FoBpNLyzv1qYzA@mail.gmail.com>
In-Reply-To: <CAOG64qPgTv5tQNknuG9d-=oL2EPQQ1ys7xu2FoBpNLyzv1qYzA@mail.gmail.com>
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
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogQWx2aXJvIElza2FuZGFyIFNldGlhd2FuDQo+IFNlbnQ6IDAxIE1hcmNoIDIwMjIgMTE6
MzQNCj4gDQo+IE9uIFR1ZSwgTWFyIDEsIDIwMjIgYXQgNDo0NiBQTSBBbW1hciBGYWl6aSB3cm90
ZToNCj4gPiBGb3J0dW5hdGVseSwgdGhlIGNvbnN0cmFpbnQgdmlvbGF0aW9uIHRoYXQncyBmaXhl
ZCBieSBwYXRjaCAxIGRvZXNuJ3QNCj4gPiB5aWVsZCBhbnkgYnVnIGR1ZSB0byB0aGUgbmF0dXJl
IG9mIFN5c3RlbSBWIEFCSS4gU2hvdWxkIHdlIGJhY2twb3J0DQo+ID4gdGhpcz8NCj4gDQo+IGhp
IHNpciwgaXQgbWlnaHQgYWxzbyBiZSBpbnRlcmVzdGluZyB0byBrbm93IHRoYXQgZXZlbiBpZiBp
dCBuZXZlciBiZQ0KPiBpbmxpbmVkLCBpdCdzIHN0aWxsIHBvdGVudGlhbCB0byBicmVhay4NCj4g
DQo+IGZvciBleGFtcGxlIHRoaXMgY29kZSAoaHR0cHM6Ly9nb2Rib2x0Lm9yZy96L3hXTVR4aFRF
VCkNCj4gDQo+ICAgX19hdHRyaWJ1dGVfXygoX19ub2lubGluZV9fKSkgc3RhdGljIHZvaWQgeChp
bnQgYSkNCj4gICB7DQo+ICAgICAgIGFzbSgieG9ybFx0JSVyOGQsICUlcjhkIjo6ImEiKGEpKTsN
Cj4gICB9DQoNCkJ1dCB0aGlzIGNvZGUgaXNuJ3QgZG9pbmcgdGhhdC4NCkluIHlvdXIgZXhhbXBs
ZSB0aGUgY29tcGlsZXIgaGFzIGxvb2tlZCBhdCB0aGUgc3RhdGljIGZ1bmN0aW9uDQphbmQgcmVh
bGlzZWQgdGhhdCBpcyBkb2Vzbid0IHVzZSByOCBzbyBpdCBuZWVkIG5vdCBiZSBzYXZlZA0KZXZl
biB0aG91Z2ggaXQgaXMgYSB2b2xhdGlsZSByZWdpc3Rlci4NCg0KSW4gdGhpcyBjb2RlIHRoZSBj
b21waWxlciBrbm93cyAlYXggaXMgYmVpbmcgdXNlZCwgaXQganVzdA0KZG9lc24ndCBrbm93IGl0
IGlzIGNoYW5nZWQgLSBzbyBjb3VsZCBhc3N1bWUgdGhlIHZhbHVlDQppcyB1bmNoYW5nZWQuDQoN
ClRoZSBvbmx5IGNvZGUgdGhhdCBpcyBsaWtlbHkgdG8gYnJlYWsgaXM6DQoNCmludCBmKGludCBk
KQ0Kew0KCWQgKz0gMTA7DQoJX19kZWxheShkKTsNCglyZXR1cm4gZDsNCn0NCg0KV2hpY2ggbWln
aHQgbWFuYWdlIHRvIHJldHVybiB0aGUgdmFsdWUgb2YgJWVheCBtb2RpZmllZCBieSB0aGUgYXNt
Lg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJv
YWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24g
Tm86IDEzOTczODYgKFdhbGVzKQ0K

