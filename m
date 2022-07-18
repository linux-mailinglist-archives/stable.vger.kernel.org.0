Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59A85786C0
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 17:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235080AbiGRPuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 11:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235077AbiGRPuN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 11:50:13 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E78DD22B34
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 08:50:11 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-117-A0hH_xv2Ml6J23bNz6aY3A-1; Mon, 18 Jul 2022 16:50:09 +0100
X-MC-Unique: A0hH_xv2Ml6J23bNz6aY3A-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Mon, 18 Jul 2022 16:50:06 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Mon, 18 Jul 2022 16:50:06 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Mauro Carvalho Chehab' <mauro.chehab@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
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
Thread-Index: AQHYmrY8zdEzbxnvNkSYe57Mev6je62ERXnQ
Date:   Mon, 18 Jul 2022 15:50:06 +0000
Message-ID: <b244f88e85a44485be9038c622fa13b1@AcuMS.aculab.com>
References: <cover.1657800199.git.mchehab@kernel.org>
        <c014a1d743fa46a6b57f02bffb7badf438136442.1657800199.git.mchehab@kernel.org>
        <76318fe1-37dc-8a1e-317e-76333995b8ca@linux.intel.com>
 <20220718165341.30ee6e31@maurocar-mobl2>
In-Reply-To: <20220718165341.30ee6e31@maurocar-mobl2>
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

RnJvbTogTWF1cm8gQ2FydmFsaG8gQ2hlaGFiDQo+IFNlbnQ6IDE4IEp1bHkgMjAyMiAxNTo1NA0K
PiANCj4gT24gTW9uLCAxOCBKdWwgMjAyMiAxNDoxNjoxMCArMDEwMA0KPiBUdnJ0a28gVXJzdWxp
biA8dHZydGtvLnVyc3VsaW5AbGludXguaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+ID4gT24gMTQv
MDcvMjAyMiAxMzowNiwgTWF1cm8gQ2FydmFsaG8gQ2hlaGFiIHdyb3RlOg0KPiA+ID4gRnJvbTog
Q2hyaXMgV2lsc29uIDxjaHJpcy5wLndpbHNvbkBpbnRlbC5jb20+DQo+ID4gPg0KPiA+ID4gQ2hl
Y2sgaWYgdGhlIGRldmljZSBpcyBwb3dlcmVkIGRvd24gcHJpb3IgdG8gYW55IGVuZ2luZSBhY3Rp
dml0eSwNCj4gPiA+IGFzLCBvbiBzdWNoIGNhc2VzLCBhbGwgdGhlIFRMQnMgd2VyZSBhbHJlYWR5
IGludmFsaWRhdGVkLCBzbyBhbg0KPiA+ID4gZXhwbGljaXQgVExCIGludmFsaWRhdGlvbiBpcyBu
b3QgbmVlZGVkLCB0aHVzIHJlZHVjaW5nIHRoZQ0KPiA+ID4gcGVyZm9ybWFuY2UgcmVncmVzc2lv
biBpbXBhY3QgZHVlIHRvIGl0Lg0KPiA+ID4NCj4gPiA+IFRoaXMgYmVjb21lcyBtb3JlIHNpZ25p
ZmljYW50IHdpdGggR3VDLCBhcyBpdCBjYW4gb25seSBkbyBzbyB3aGVuDQo+ID4gPiB0aGUgY29u
bmVjdGlvbiB0byB0aGUgR3VDIGlzIGF3YWtlLg0KPiA+ID4NCj4gPiA+IENjOiBzdGFibGVAdmdl
ci5rZXJuZWwub3JnDQo+ID4gPiBGaXhlczogNzkzOGQ2MTU5MWQzICgiZHJtL2k5MTU6IEZsdXNo
IFRMQnMgYmVmb3JlIHJlbGVhc2luZyBiYWNraW5nIHN0b3JlIikNCj4gPg0KPiA+IFBhdGNoIGl0
c2VsZiBsb29rcyBmaW5lIGJ1dCBJIGRvbid0IHRoaW5rIHdlIGNsb3NlZCBvbiB0aGUgaXNzdWUg
b2YNCj4gPiBzdGFibGUvZml4ZXMgb24gdGhpcyBwYXRjaD8NCj4gDQo+IE5vLCBiZWNhdXNlIFRM
QiBjYWNoZSBpbnZhbGlkYXRpb24gdGFrZXMgdGltZSBhbmQgY2F1c2VzIHRpbWUgb3V0cywgd2hp
Y2gNCj4gaW4gdHVybiBhZmZlY3RzIGFwcGxpY2F0aW9ucyBhbmQgcHJvZHVjZSBLZXJuZWwgd2Fy
bmluZ3MuDQoNCkl0J3Mgbm90IG9ubHkgdGhlIFRMQiBmbHVzaGVzIHRoYXQgY2F1c2UgZ3JpZWYu
DQoNClRoZXJlIGlzIGEgbG9vcCB0aGF0IGZvcmNlcyBhIHdyaXRlLWJhY2sgb2YgYWxsIHRoZSBm
cmFtZSBidWZmZXIgcGFnZXMuDQpXaXRoIGEgbGFyZ2UgZGlzcGxheSBhbmQgc29tZSBjcHUgKGxp
a2UgbXkgSXZ5IGJyaWRnZSBvbmUpIHRoYXQNCnRha2VzIGxvbmcgZW5vdWdoIHdpdGggcHJlLWVt
cHRpb24gZGlzYWJsZWQgdGhhdCB3YWtldXAgb2YgUlQgcHJvY2Vzc2VzDQooYW5kIGFueSBwaW5u
ZWQgdG8gdGhlIGNwdSkgdGFrZXMgZmFyIGxvbmdlciB0aGFuIG9uZSBtaWdodCBoYXZlDQp3aXNo
ZWQgZm9yLg0KDQpTaW5jZSBzb21lIFggc2VydmVycyByZXF1ZXN0IGEgZmx1c2ggZXZlcnkgZmV3
IHNlY29uZHMgdGhpcyBtYWtlcw0KdGhlIHN5c3RlbSB1bnVzYWJsZSBmb3Igc29tZSB3b3JrbG9h
ZHMuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkg
Um9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlv
biBObzogMTM5NzM4NiAoV2FsZXMpDQo=

