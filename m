Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1057579472
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 09:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbiGSHpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 03:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiGSHpP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 03:45:15 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6BC4C6417
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 00:45:13 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-195-w4wS7Z9kPLWuciSaR4LFhw-1; Tue, 19 Jul 2022 08:45:10 +0100
X-MC-Unique: w4wS7Z9kPLWuciSaR4LFhw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Tue, 19 Jul 2022 08:45:08 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Tue, 19 Jul 2022 08:45:08 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Tvrtko Ursulin' <tvrtko.ursulin@linux.intel.com>,
        'Mauro Carvalho Chehab' <mauro.chehab@linux.intel.com>
CC:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        =?utf-8?B?VGhvbWFzIEhlbGxzdHLDtm0=?= 
        <thomas.hellstrom@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [Intel-gfx] [PATCH v2 01/21] drm/i915/gt: Ignore TLB
 invalidations on idle engines
Thread-Topic: [Intel-gfx] [PATCH v2 01/21] drm/i915/gt: Ignore TLB
 invalidations on idle engines
Thread-Index: AQHYmrY8zdEzbxnvNkSYe57Mev6je62ERXnQgAD1jgCAABUfUA==
Date:   Tue, 19 Jul 2022 07:45:08 +0000
Message-ID: <0259b5ae72c44d9b8dd12c3431c0c36f@AcuMS.aculab.com>
References: <cover.1657800199.git.mchehab@kernel.org>
 <c014a1d743fa46a6b57f02bffb7badf438136442.1657800199.git.mchehab@kernel.org>
 <76318fe1-37dc-8a1e-317e-76333995b8ca@linux.intel.com>
 <20220718165341.30ee6e31@maurocar-mobl2>
 <b244f88e85a44485be9038c622fa13b1@AcuMS.aculab.com>
 <7ed6b275-e0d3-12b7-cdbe-c43994e92b47@linux.intel.com>
In-Reply-To: <7ed6b275-e0d3-12b7-cdbe-c43994e92b47@linux.intel.com>
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

RnJvbTogVHZydGtvIFVyc3VsaW4NCj4gU2VudDogMTkgSnVseSAyMDIyIDA4OjI1DQouLi4NCj4g
PiBJdCdzIG5vdCBvbmx5IHRoZSBUTEIgZmx1c2hlcyB0aGF0IGNhdXNlIGdyaWVmLg0KPiA+DQo+
ID4gVGhlcmUgaXMgYSBsb29wIHRoYXQgZm9yY2VzIGEgd3JpdGUtYmFjayBvZiBhbGwgdGhlIGZy
YW1lIGJ1ZmZlciBwYWdlcy4NCj4gPiBXaXRoIGEgbGFyZ2UgZGlzcGxheSBhbmQgc29tZSBjcHUg
KGxpa2UgbXkgSXZ5IGJyaWRnZSBvbmUpIHRoYXQNCj4gPiB0YWtlcyBsb25nIGVub3VnaCB3aXRo
IHByZS1lbXB0aW9uIGRpc2FibGVkIHRoYXQgd2FrZXVwIG9mIFJUIHByb2Nlc3Nlcw0KPiA+IChh
bmQgYW55IHBpbm5lZCB0byB0aGUgY3B1KSB0YWtlcyBmYXIgbG9uZ2VyIHRoYW4gb25lIG1pZ2h0
IGhhdmUNCj4gPiB3aXNoZWQgZm9yLg0KPiA+DQo+ID4gU2luY2Ugc29tZSBYIHNlcnZlcnMgcmVx
dWVzdCBhIGZsdXNoIGV2ZXJ5IGZldyBzZWNvbmRzIHRoaXMgbWFrZXMNCj4gPiB0aGUgc3lzdGVt
IHVudXNhYmxlIGZvciBzb21lIHdvcmtsb2Fkcy4NCj4gDQo+IE9rIFRMQiBpbnZhbGlkYXRpb25z
IGFzIGRpc2N1c3NlZCBpbiB0aGlzIHBhdGNoIGRvZXMgbm90IGFwcGx5IHRvDQo+IEl2eWJyaWRn
ZS4gQnV0IHdoYXQgaXMgdGhlIHdyaXRlIGJhY2sgbG9vcCB5b3UgbWVudGlvbiB3aGljaCBpcyBj
YXVzaW5nDQo+IHlvdSBncmllZj8gV2hhdCBzaXplIGZyYW1lIGJ1ZmZlcnMgYXJlIHdlIHRhbGtp
bmcgYWJvdXQgaGVyZT8gSWYgdGhleQ0KPiBkb24ndCBmaXQgaW4gdGhlIG1hcHBhYmxlIGFyZWEg
cmVjZW50bHkgd2UgbWVyZ2VkIGEgcGF0Y2gqIHdoaWNoDQo+IGltcHJvdmVzIHRoaW5ncyBpbiB0
aGF0IHNpdHVhdGlvbiBidXQgbm90IHN1cmUgeW91IGFyZSBoaXR0aW5nIGV4YWN0bHkgdGhhdC4N
Cg0KSSBmb3VuZCB0aGUgb2xkIGVtYWlsOg0KDQpXaGF0IEkndmUgZm91bmQgaXMgdGhhdCB0aGUg
SW50ZWwgaTkxNSBncmFwaGljcyBkcml2ZXIgdXNlcyB0aGUgJ2V2ZW50c191bmJvdW5kJw0Ka2Vy
bmVsIHdvcmtlciB0aHJlYWQgdG8gcGVyaW9kaWNhbGx5IGV4ZWN1dGUgZHJtX2NmbHVzaF9zZygp
Lg0KKHNlZSBodHRwczovL2dpdGh1Yi5jb20vdG9ydmFsZHMvbGludXgvYmxvYi9tYXN0ZXIvZHJp
dmVycy9ncHUvZHJtL2RybV9jYWNoZS5jKQ0KDQpJJ20gZ3Vlc3NpbmcgdGhpcyBpcyB0byBlbnN1
cmUgdGhhdCBhbnkgd3JpdGVzIHRvIGdyYXBoaWNzIG1lbW9yeSBiZWNvbWUNCnZpc2libGUgaXMg
YSBzZW1pLXRpbWVseSBtYW5uZXIuDQoNClRoaXMgbG9vcCB0YWtlcyBhYm91dCAxdXMgcGVyIGl0
ZXJhdGlvbiBzcGxpdCBmYWlybHkgZXZlbmx5IGJldHdlZW4gd2hhdGV2ZXIgaXMgaW4NCmZvcl9l
YWNoX3NnX3BhZ2UoKSBhbmQgZHJtX2NmbHVzaF9wYWdlKCkuDQpXaXRoIGEgMjU2MHgxNDQwIGRp
c3BsYXkgdGhlIGxvb3AgY291bnQgaXMgMzYwMCAoNCBieXRlcy9waXhlbCkgYW5kIHRoZSB3aG9s
ZQ0KZnVuY3Rpb24gdGFrZXMgYXJvdW5kIDMuM21zLg0KDQpJSVJDIHRoZSBmaXJzdCBmZXcgcGFn
ZSBmbHVzaGVzIGFyZSBxdWljayAoSSBiZXQgdGhleSBnbyBpbnRvIGEgZmlmbykNCmFuZCB0aGVu
IHRoZXkgYWxsIGdldCBzbG93Lg0KVGhlIGZsdXNoZXMgYXJlIGFjdHVhbGx5IHJlcXVlc3RlZCBm
cm9tIHVzZXJzcGFjZS4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lk
ZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0K
UmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

