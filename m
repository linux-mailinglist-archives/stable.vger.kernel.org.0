Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 442735865D0
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 09:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiHAHq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 03:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiHAHq1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 03:46:27 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4E2472CC99
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 00:46:26 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-405-Y1qdvxiGN3CazYPDeLT3AA-1; Mon, 01 Aug 2022 08:46:23 +0100
X-MC-Unique: Y1qdvxiGN3CazYPDeLT3AA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Mon, 1 Aug 2022 08:46:22 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Mon, 1 Aug 2022 08:46:22 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Steven Rostedt' <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [for-next][PATCH 21/21] tracing: Use a struct alignof to
 determine trace event field alignment
Thread-Topic: [for-next][PATCH 21/21] tracing: Use a struct alignof to
 determine trace event field alignment
Thread-Index: AQHYpRCiiZXga/pkuEmpCjyvwUgeD62Zqvzg
Date:   Mon, 1 Aug 2022 07:46:22 +0000
Message-ID: <a7d202457150472588df0bd3b7334b3f@AcuMS.aculab.com>
References: <20220731190329.641602282@goodmis.org>
 <20220731190435.611455708@goodmis.org>
In-Reply-To: <20220731190435.611455708@goodmis.org>
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogU3RldmVuIFJvc3RlZHQNCj4gU2VudDogMzEgSnVseSAyMDIyIDIwOjA0DQo+IA0KPiBh
bGlnbm9mKCkgZ2l2ZXMgYW4gYWxpZ25tZW50IG9mIHR5cGVzIGFzIHRoZXkgd291bGQgYmUgYXMg
c3RhbmRhbG9uZQ0KPiB2YXJpYWJsZXMuIEJ1dCBhbGlnbm1lbnQgaW4gc3RydWN0dXJlcyBtaWdo
dCBiZSBkaWZmZXJlbnQsIGFuZCB3aGVuDQo+IGJ1aWxkaW5nIHRoZSBmaWVsZHMgb2YgZXZlbnRz
LCB0aGUgYWxpZ25tZW50IG11c3QgYmUgdGhlIGFjdHVhbA0KPiBhbGlnbm1lbnQgb3RoZXJ3aXNl
IHRoZSBmaWVsZCBvZmZzZXRzIG1heSBub3QgbWF0Y2ggd2hhdCB0aGV5IGFjdHVhbGx5DQo+IGFy
ZS4NCj4gDQo+IFRoaXMgY2F1c2VkIHRyYWNlLWNtZCB0byBjcmFzaCwgYXMgbGlidHJhY2VldmVu
dCBkaWQgbm90IGNoZWNrIGlmIHRoZQ0KPiBmaWVsZCBvZmZzZXQgd2FzIGJpZ2dlciB0aGFuIHRo
ZSBldmVudC4gVGhlIHdyaXRlX21zciBhbmQgcmVhZF9tc3INCj4gZXZlbnRzIG9uIDMyIGJpdCBo
YWQgdGhlaXIgZmllbGRzIGluY29ycmVjdCwgYmVjYXVzZSBpdCBoYWQgYSB1NjQgZmllbGQNCj4g
YmV0d2VlbiB0d28gaW50cy4gYWxpZ25vZih1NjQpIHdvdWxkIGdpdmUgOCwgYnV0IHRoZSB1NjQg
ZmllbGQgd2FzIGF0IGENCj4gNCBieXRlIGFsaWdubWVudC4NCj4gDQo+IERlZmluZSBhIG1hY3Jv
IGFzOg0KPiANCj4gICAgQUxJR05fU1RSVUNURklFTEQodHlwZSkgKChpbnQpKG9mZnNldG9mKHN0
cnVjdCB7Y2hhciBhOyB0eXBlIGI7fSwgYikpKQ0KPiANCj4gd2hpY2ggZ2l2ZXMgdGhlIGFjdHVh
bCBhbGlnbm1lbnQgb2YgdHlwZXMgaW4gYSBzdHJ1Y3R1cmUuDQoNClRoZSBzaW1wbGVyOg0KCV9f
YWxpZ25vZl9fKHN0cnVjdCB7dHlwZSBiO30pDQphbHNvIHdvcmtzLg0KDQoJRGF2aWQNCg0KLQ0K
UmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1p
bHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVz
KQ0K

