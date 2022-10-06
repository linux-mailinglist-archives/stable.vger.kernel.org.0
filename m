Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA145F6293
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 10:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiJFI0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Oct 2022 04:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiJFIZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Oct 2022 04:25:57 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD3A925A4
        for <stable@vger.kernel.org>; Thu,  6 Oct 2022 01:25:20 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-220-ogqXoB6DMemx0vexCKXnvA-1; Thu, 06 Oct 2022 09:25:17 +0100
X-MC-Unique: ogqXoB6DMemx0vexCKXnvA-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 6 Oct
 2022 09:25:15 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.040; Thu, 6 Oct 2022 09:25:15 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jim Mattson' <jmattson@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "sjitindarsingh@gmail.com" <sjitindarsingh@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "bp@suse.de" <bp@suse.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
        "daniel.sneddon@linux.intel.com" <daniel.sneddon@linux.intel.com>,
        "pawan.kumar.gupta@linux.intel.com" 
        <pawan.kumar.gupta@linux.intel.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] x86/speculation: Mitigate eIBRS PBRSB predictions with
 WRMSR
Thread-Topic: [PATCH] x86/speculation: Mitigate eIBRS PBRSB predictions with
 WRMSR
Thread-Index: AQHY2QnwhQ6wwn4vH0yiWThIF9O5Ta4BBb5Q
Date:   Thu, 6 Oct 2022 08:25:15 +0000
Message-ID: <a056259f338e411581b882555ed608cb@AcuMS.aculab.com>
References: <20221005220227.1959-1-surajjs@amazon.com>
 <CALMp9eTy2w_ZbkVSVvTwOW3wYH6vnn5waEWc0BesXL-kYRFy4g@mail.gmail.com>
In-Reply-To: <CALMp9eTy2w_ZbkVSVvTwOW3wYH6vnn5waEWc0BesXL-kYRFy4g@mail.gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogSmltIE1hdHRzb24NCj4gU2VudDogMDUgT2N0b2JlciAyMDIyIDIzOjI5DQo+IA0KPiBP
biBXZWQsIE9jdCA1LCAyMDIyIGF0IDM6MDMgUE0gU3VyYWogSml0aW5kYXIgU2luZ2ggPHN1cmFq
anNAYW1hem9uLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiB0bDtkcjogVGhlIGV4aXN0aW5nIG1pdGln
YXRpb24gZm9yIGVJQlJTIFBCUlNCIHByZWRpY3Rpb25zIHVzZXMgYW4gSU5UMyB0bw0KPiA+IGVu
c3VyZSBhIGNhbGwgaW5zdHJ1Y3Rpb24gcmV0aXJlcyBiZWZvcmUgYSBmb2xsb3dpbmcgdW5iYWxh
bmNlZCBSRVQuIFJlcGxhY2UNCj4gPiB0aGlzIHdpdGggYSBXUk1TUiBzZXJpYWxpc2luZyBpbnN0
cnVjdGlvbiB3aGljaCBoYXMgYSBsb3dlciBwZXJmb3JtYW5jZQ0KPiA+IHBlbmFsdHkuDQo+IA0K
PiBUaGUgSU5UMyBpcyBvbmx5IG9uIGEgc3BlY3VsYXRpdmUgcGF0aCBhbmQgc2hvdWxkIG5vdCBp
bXBhY3QgcGVyZm9ybWFuY2UuDQoNCkRvZXNuJ3QgdGhhdCBkZXBlbmQgb24gaG93IHF1aWNrbHkg
dGhlIGNwdSBjYW4gYWJvcnQgdGhlDQpkZWNvZGUgYW5kIGV4ZWN1dGlvbiBvZiB0aGUgSU5UMyBp
bnN0cnVjdGlvbj8NCklOVDMgaXMgYm91bmQgdG8gZ2VuZXJhdGUgYSBsb3Qgb2YgdW9wcyBhbmQv
b3IgYmUgbWljcm9jb2RlZC4NCg0KT2xkIGNwdSBjb3VsZG4ndCBhYm9ydCBmcHUgaW5zdHJ1Y3Rp
b25zLg0KSUlSQyB0aGUgSW50ZWwgcGVyZm9ybWFuY2UgZ3VpZGUgZXZlbiBzdWdnZXN0ZWQgbm90
IGludGVybGVhdmluZw0KY29kZSBhbmQgZGF0YSBiZWNhdXNlIHRoZSBkYXRhIG1pZ2h0IGdldCBz
cGVjdWxhdGl2ZWx5IGV4ZWN1dGVkDQphbmQgdGFrZSBhIGxvbmcgdGltZSB0byBhYm9ydC4NCg0K
SSBhY3R1YWxseSB3b25kZXIgd2hldGhlciAnSk1QUyAuJyAoZWIgZmUpIHNob3VsZG4ndCBiZSB1
c2VkDQppbnN0ZWFkIG9mIElOVDMgKGNjKSBiZWNhdXNlIGl0IGlzIGZhc3QgdG8gZGVjb2RlIGFu
ZCBleGVjdXRlLg0KQnV0IEknbSBubyBleHBlY3QgaGVyZS4NCg0KCURhdmlkDQoNCi0NClJlZ2lz
dGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24g
S2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

