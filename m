Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F13E67D832
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 23:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbjAZWKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 17:10:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233157AbjAZWKf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 17:10:35 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B25144BE8
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 14:10:23 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-405-y5mIwwBZNUOlhd0pYTFUaw-1; Thu, 26 Jan 2023 22:10:20 +0000
X-MC-Unique: y5mIwwBZNUOlhd0pYTFUaw-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.45; Thu, 26 Jan
 2023 22:10:19 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.045; Thu, 26 Jan 2023 22:10:19 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Hernan Ponce de Leon' <hernan.poncedeleon@huaweicloud.com>,
        "Peter Zijlstra" <peterz@infradead.org>
CC:     Waiman Long <longman@redhat.com>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        "boqun.feng@gmail.com" <boqun.feng@gmail.com>,
        "akpm@osdl.org" <akpm@osdl.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "joel@joelfernandes.org" <joel@joelfernandes.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "diogo.behrens@huawei.com" <diogo.behrens@huawei.com>,
        "jonas.oberhauser@huawei.com" <jonas.oberhauser@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hernan Ponce de Leon" <hernanl.leon@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>
Subject: RE: [PATCH] Fix data race in mark_rt_mutex_waiters
Thread-Topic: [PATCH] Fix data race in mark_rt_mutex_waiters
Thread-Index: AQHZMcpF963KryQ2wkKgjWr8rumcCK6xQHyQ
Date:   Thu, 26 Jan 2023 22:10:19 +0000
Message-ID: <004045af7a2b4abaa5f4d9840371da60@AcuMS.aculab.com>
References: <20230120135525.25561-1-hernan.poncedeleon@huaweicloud.com>
 <562c883b-b2c3-3a27-f045-97e7e3281e0b@linux.intel.com>
 <20230120155439.GI2948950@paulmck-ThinkPad-P17-Gen-1>
 <9a1c7959-4b8c-94df-a3e2-e69be72bfd7d@huaweicloud.com>
 <20230123164014.GN2948950@paulmck-ThinkPad-P17-Gen-1>
 <f17dcce0-d510-a112-3127-984e8e73f480@huaweicloud.com>
 <d1e28124-b7a7-ae19-87ec-b1dcd3701b61@redhat.com>
 <Y8/+2YBRD4rFySjh@hirez.programming.kicks-ass.net>
 <ae90e931-df19-9d60-610c-57dc34494d8e@redhat.com>
 <c300747a-cf81-0e2d-77ec-f861421291f9@huaweicloud.com>
 <Y9Jv9yL8x7/TAq/X@hirez.programming.kicks-ass.net>
 <9da70674-42e0-9aaa-edab-c606ca8dd2e8@huaweicloud.com>
In-Reply-To: <9da70674-42e0-9aaa-edab-c606ca8dd2e8@huaweicloud.com>
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

RnJvbTogSGVybmFuIFBvbmNlIGRlIExlb24NCj4gU2VudDogMjYgSmFudWFyeSAyMDIzIDIxOjA3
DQouLi4NCj4gICBzdGF0aWMgX19hbHdheXNfaW5saW5lIHZvaWQgcnRfbXV0ZXhfY2xlYXJfb3du
ZXIoc3RydWN0IHJ0X211dGV4X2Jhc2UNCj4gKmxvY2spDQo+IEBAIC0yMzIsMTIgKzIzMiw3IEBA
IHN0YXRpYyBfX2Fsd2F5c19pbmxpbmUgYm9vbA0KPiBydF9tdXRleF9jbXB4Y2hnX3JlbGVhc2Uo
c3RydWN0IHJ0X211dGV4X2Jhc2UgKmxvY2ssDQo+ICAgICovDQo+ICAgc3RhdGljIF9fYWx3YXlz
X2lubGluZSB2b2lkIG1hcmtfcnRfbXV0ZXhfd2FpdGVycyhzdHJ1Y3QgcnRfbXV0ZXhfYmFzZQ0K
PiAqbG9jaykNCj4gICB7DQo+IC0JdW5zaWduZWQgbG9uZyBvd25lciwgKnAgPSAodW5zaWduZWQg
bG9uZyAqKSAmbG9jay0+b3duZXI7DQo+IC0NCj4gLQlkbyB7DQo+IC0JCW93bmVyID0gKnA7DQo+
IC0JfSB3aGlsZSAoY21weGNoZ19yZWxheGVkKHAsIG93bmVyLA0KPiAtCQkJCSBvd25lciB8IFJU
X01VVEVYX0hBU19XQUlURVJTKSAhPSBvd25lcik7DQo+ICsJYXRvbWljX2xvbmdfb3IoUlRfTVVU
RVhfSEFTX1dBSVRFUlMsIChhdG9taWNfbG9uZ190ICopJmxvY2stPm93bmVyKTsNCg0KVGhlc2Ug
KihpbnRfdHlwZSAqKSZmb28gYWNjZXNzZXMgKHF1aXRlIG9mdGVuIGp1c3QgcGxhaW4gd3Jvbmcp
DQptYWRlIG1lIGxvb2sgdXAgdGhlIGRlZmluaXRpb25zLg0KDQpBbGwgb25lIGJpZyBhY2NpZGVu
dCB3YWl0aW5nIHRvIGhhcHBlbi4uLg0KUlRfTVVURVhfSEFTX1dBSVRFUlMgaXMgZGVmaW5lZCBp
biBhIGRpZmZlcmVudCBoZWFkZXIgdG8gdGhlIHN0cnVjdHVyZS4NClRoZSBleHBsYW5hdG9yeSBj
b21tZW50IGlzIGluIGEgM3JkIGZpbGUuDQoNCkl0IHdvdWxkIGFsbCBiZSBzYWZlciBpZiBsb2Nr
LT5vd25lciB3ZXJlIGF0b21pY19sb25nX3Qgd2l0aCBhIGNvbW1lbnQNCnRoYXQgaXQgd2FzIHRo
ZSB3YWl0aW5nIHRhc2tfc3RydWN0IHwgUlRfTVVURVhfSEFTX1dBSVRFUlMuDQoNCkdpdmVuIHRo
ZSBhY3R1YWwgZGVmaW5pdGlvbiBpcyBydF9tdXRleF9iYXNlX2lzX2xvY2tlZCgpIGV2ZW4gY29y
cmVjdD8NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxl
eSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0
aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

