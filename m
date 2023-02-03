Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09E296896BC
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbjBCKcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:32:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233572AbjBCKam (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:30:42 -0500
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617C31ADFB;
        Fri,  3 Feb 2023 02:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1675420183; x=1706956183;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version:content-id:
   content-transfer-encoding;
  bh=uG7mFBp8AN4ZXnQ+vh2PoeO3OMcmFfjJzOtsOXzYJ5M=;
  b=lcfBKB/lS96z3QNOfsXi4Af8pQi5E8odE6Jn4vUIUdA+QZFAZAwGsg7D
   PDcmMLuCD4f+3eXF+lIB3CIIL5c9ubj1hkFzfTzeYFqMGY3savhqiqywP
   whwzjlBYKpJNdZlegPYAefJ3pHSuTJS8TOtrMRi8aJpjjVi9qM6UFEvUC
   KMpwLl2bLUMl4Vq97Qwfnn6EqwVEVqLqffgk8ndZiTr1br3kbZWoRgeRS
   BvF7T5TRGlnEu+rt4toHKPbf5JEKGAtXZKd40ka7gqEHRR20fF4buVjgm
   UAVyp61YxjVgkJdFYaKtR7QiMahCd1hFCn4dy09Zezy1/b1WBszzkRnNl
   g==;
X-IronPort-AV: E=Sophos;i="5.97,270,1669071600"; 
   d="scan'208";a="28852043"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 03 Feb 2023 11:29:41 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Fri, 03 Feb 2023 11:29:41 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Fri, 03 Feb 2023 11:29:41 +0100
X-IronPort-AV: E=Sophos;i="5.97,270,1669071600"; 
   d="scan'208";a="28852042"
Received: from vmail02.tq-net.de ([10.150.72.12])
  by mx1.tq-group.com with ESMTP; 03 Feb 2023 11:29:41 +0100
Received: from vmail01.tq-net.de (10.150.72.11) by vmail02.tq-net.de
 (10.150.72.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Fri, 3 Feb
 2023 11:29:41 +0100
Received: from vmail01.tq-net.de ([10.150.72.11]) by vmail01.tq-net.de
 ([10.150.72.11]) with mapi id 15.01.2507.017; Fri, 3 Feb 2023 11:29:41 +0100
From:   "Stein, Alexander" <Alexander.Stein@tq-group.com>
To:     "tudor.ambarus@linaro.org" <tudor.ambarus@linaro.org>,
        "pratyush@kernel.org" <pratyush@kernel.org>,
        "michael@walle.cc" <michael@walle.cc>,
        "lrannou@baylibre.com" <lrannou@baylibre.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH v3] mtd: spi-nor: Fix shift-out-of-bounds in
 spi_nor_set_erase_type
Thread-Topic: [PATCH v3] mtd: spi-nor: Fix shift-out-of-bounds in
 spi_nor_set_erase_type
Thread-Index: AQHZN7psQ7a7VvJFl067ZPmyIcgN1w==
Date:   Fri, 3 Feb 2023 10:29:41 +0000
Message-ID: <4df4c0bb5d51aadf1dcd465fc594ad1d356523f7.camel@tq-group.com>
References: <20230203070754.50677-1-tudor.ambarus@linaro.org>
In-Reply-To: <20230203070754.50677-1-tudor.ambarus@linaro.org>
Accept-Language: de-DE, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.150.72.21]
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <2E4522578CB1E646B8C3BA94E78A1BD1@tq-group.com>
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgVHVkb3IsDQoNCkFtIEZyZWl0YWcsIGRlbSAwMy4wMi4yMDIzIHVtIDA5OjA3ICswMjAwIHNj
aHJpZWIgVHVkb3IgQW1iYXJ1czoNCj4gRnJvbTogTG91aXMgUmFubm91IDxscmFubm91QGJheWxp
YnJlLmNvbT4NCj4gDQo+IHNwaV9ub3Jfc2V0X2VyYXNlX3R5cGUoKSB3YXMgdXNlZCBlaXRoZXIg
dG8gc2V0IG9yIHRvIG1hc2sgb3V0IGFuDQo+IGVyYXNlDQo+IHR5cGUuIFdoZW4gd2UgdXNlZCBp
dCB0byBtYXNrIG91dCBhbiBlcmFzZSB0eXBlIGEgc2hpZnQtb3V0LW9mLWJvdW5kcw0KPiB3YXMg
aGl0Og0KPiBVQlNBTjogc2hpZnQtb3V0LW9mLWJvdW5kcyBpbiBkcml2ZXJzL210ZC9zcGktbm9y
L2NvcmUuYzoyMjM3OjI0DQo+IHNoaWZ0IGV4cG9uZW50IDQyOTQ5NjcyOTUgaXMgdG9vIGxhcmdl
IGZvciAzMi1iaXQgdHlwZSAnaW50Jw0KPiANCj4gVGhlIHNldHRpbmcgb2YgdGhlIHNpemVfe3No
aWZ0LCBtYXNrfSBhbmQgb2YgdGhlIG9wY29kZSBhcmUNCj4gdW5uZWNlc3NhcnkNCj4gd2hlbiB0
aGUgZXJhc2Ugc2l6ZSBpcyB6ZXJvLCBhcyB0aHJvdWdob3V0IHRoZSBjb2RlIGp1c3QgdGhlIGVy
YXNlDQo+IHNpemUNCj4gaXMgY29uc2lkZXJlZCB0byBkZXRlcm1pbmUgd2hldGhlciBhbiBlcmFz
ZSB0eXBlIGlzIHN1cHBvcnRlZCBvciBub3QuDQo+IFNldHRpbmcgdGhlIG9wY29kZSB0byAweEZG
IHdhcyB3cm9uZyB0b28gYXMgbm9ib2R5IGd1YXJhbnRlZXMgdGhhdA0KPiAweEZGDQo+IGlzIGFu
IHVudXNlZCBvcGNvZGUuIFRodXMgd2hlbiBtYXNraW5nIG91dCBhbiBlcmFzZSB0eXBlLCBqdXN0
IHNldA0KPiB0aGUNCj4gZXJhc2Ugc2l6ZSB0byB6ZXJvLiBUaGlzIHdpbGwgZml4IHRoZSBzaGlm
dC1vdXQtb2YtYm91bmRzLg0KPiANCj4gRml4ZXM6IDUzOTBhOGRmNzY5ZSAoIm10ZDogc3BpLW5v
cjogYWRkIHN1cHBvcnQgdG8gbm9uLXVuaWZvcm0gU0ZEUA0KPiBTUEkgTk9SIGZsYXNoIG1lbW9y
aWVzIikNCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gUmVwb3J0ZWQtYnk6IEFsZXhh
bmRlciBTdGVpbiA8QWxleGFuZGVyLlN0ZWluQHRxLWdyb3VwLmNvbT4NCj4gU2lnbmVkLW9mZi1i
eTogTG91aXMgUmFubm91IDxscmFubm91QGJheWxpYnJlLmNvbT4NCj4gW3RhOiByZWZpbmUgY2hh
bmdlcywgbmV3IGNvbW1pdCBtZXNzYWdlLCBmaXggY29tcGlsYXRpb24gZXJyb3JdDQo+IFNpZ25l
ZC1vZmYtYnk6IFR1ZG9yIEFtYmFydXMgPHR1ZG9yLmFtYmFydXNAbGluYXJvLm9yZz4NCg0KVGhh
bmtzLg0KVGVzdGVkLWJ5OiBBbGV4YW5kZXIgU3RlaW4gPEFsZXhhbmRlci5TdGVpbkB0cS1ncm91
cC5jb20+DQoNCj4gLS0tDQo+IMKgZHJpdmVycy9tdGQvc3BpLW5vci9jb3JlLmMgfCA5ICsrKysr
KysrKw0KPiDCoGRyaXZlcnMvbXRkL3NwaS1ub3IvY29yZS5oIHwgMSArDQo+IMKgZHJpdmVycy9t
dGQvc3BpLW5vci9zZmRwLmMgfCA0ICsrLS0NCj4gwqAzIGZpbGVzIGNoYW5nZWQsIDEyIGluc2Vy
dGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tdGQv
c3BpLW5vci9jb3JlLmMgYi9kcml2ZXJzL210ZC9zcGktbm9yL2NvcmUuYw0KPiBpbmRleCAyNDdk
MTAxNDg3OWEuLjIyY2IxOGI2Yzk0MSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9tdGQvc3BpLW5v
ci9jb3JlLmMNCj4gKysrIGIvZHJpdmVycy9tdGQvc3BpLW5vci9jb3JlLmMNCj4gQEAgLTIwMjUs
NiArMjAyNSwxNSBAQCB2b2lkIHNwaV9ub3Jfc2V0X2VyYXNlX3R5cGUoc3RydWN0DQo+IHNwaV9u
b3JfZXJhc2VfdHlwZSAqZXJhc2UsIHUzMiBzaXplLA0KPiDCoMKgwqDCoMKgwqDCoMKgZXJhc2Ut
PnNpemVfbWFzayA9ICgxIDw8IGVyYXNlLT5zaXplX3NoaWZ0KSAtIDE7DQo+IMKgfQ0KPiDCoA0K
PiArLyoqDQo+ICsgKiBzcGlfbm9yX21hc2tfZXJhc2VfdHlwZSgpIC0gbWFzayBvdXQgYW4gU1BJ
IE5PUiBlcmFzZSB0eXBlDQo+ICsgKiBAZXJhc2U6wqDCoMKgwqDCoHBvaW50ZXIgdG8gYSBzdHJ1
Y3R1cmUgdGhhdCBkZXNjcmliZXMgYW4gU1BJIE5PUg0KPiBlcmFzZSB0eXBlDQo+ICsgKi8NCj4g
K3ZvaWQgc3BpX25vcl9tYXNrX2VyYXNlX3R5cGUoc3RydWN0IHNwaV9ub3JfZXJhc2VfdHlwZSAq
ZXJhc2UpDQo+ICt7DQo+ICvCoMKgwqDCoMKgwqDCoGVyYXNlLT5zaXplID0gMDsNCj4gK30NCj4g
Kw0KPiDCoC8qKg0KPiDCoCAqIHNwaV9ub3JfaW5pdF91bmlmb3JtX2VyYXNlX21hcCgpIC0gSW5p
dGlhbGl6ZSB1bmlmb3JtIGVyYXNlIG1hcA0KPiDCoCAqIEBtYXA6wqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgdGhlIGVyYXNlIG1hcCBvZiB0aGUgU1BJIE5PUg0KPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9tdGQvc3BpLW5vci9jb3JlLmggYi9kcml2ZXJzL210ZC9zcGktbm9yL2NvcmUuaA0K
PiBpbmRleCBmNmQwMTJlMWY2ODEuLjI1NDIzMjI1YzI5ZCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVy
cy9tdGQvc3BpLW5vci9jb3JlLmgNCj4gKysrIGIvZHJpdmVycy9tdGQvc3BpLW5vci9jb3JlLmgN
Cj4gQEAgLTY4MSw2ICs2ODEsNyBAQCB2b2lkIHNwaV9ub3Jfc2V0X3BwX3NldHRpbmdzKHN0cnVj
dA0KPiBzcGlfbm9yX3BwX2NvbW1hbmQgKnBwLCB1OCBvcGNvZGUsDQo+IMKgDQo+IMKgdm9pZCBz
cGlfbm9yX3NldF9lcmFzZV90eXBlKHN0cnVjdCBzcGlfbm9yX2VyYXNlX3R5cGUgKmVyYXNlLCB1
MzINCj4gc2l6ZSwNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHU4IG9wY29kZSk7DQo+ICt2b2lkIHNwaV9ub3JfbWFza19lcmFzZV90eXBl
KHN0cnVjdCBzcGlfbm9yX2VyYXNlX3R5cGUgKmVyYXNlKTsNCj4gwqBzdHJ1Y3Qgc3BpX25vcl9l
cmFzZV9yZWdpb24gKg0KPiDCoHNwaV9ub3JfcmVnaW9uX25leHQoc3RydWN0IHNwaV9ub3JfZXJh
c2VfcmVnaW9uICpyZWdpb24pOw0KPiDCoHZvaWQgc3BpX25vcl9pbml0X3VuaWZvcm1fZXJhc2Vf
bWFwKHN0cnVjdCBzcGlfbm9yX2VyYXNlX21hcCAqbWFwLA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9tdGQvc3BpLW5vci9zZmRwLmMgYi9kcml2ZXJzL210ZC9zcGktbm9yL3NmZHAuYw0KPiBpbmRl
eCBmZDRkYWY4ZmE1ZGYuLjI5OGFiNWU1M2E4YyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9tdGQv
c3BpLW5vci9zZmRwLmMNCj4gKysrIGIvZHJpdmVycy9tdGQvc3BpLW5vci9zZmRwLmMNCj4gQEAg
LTg3NSw3ICs4NzUsNyBAQCBzdGF0aWMgaW50DQo+IHNwaV9ub3JfaW5pdF9ub25fdW5pZm9ybV9l
cmFzZV9tYXAoc3RydWN0IHNwaV9ub3IgKm5vciwNCj4gwqDCoMKgwqDCoMKgwqDCoCAqLw0KPiDC
oMKgwqDCoMKgwqDCoMKgZm9yIChpID0gMDsgaSA8IFNOT1JfRVJBU0VfVFlQRV9NQVg7IGkrKykN
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoIShyZWdpb25zX2VyYXNlX3R5
cGUgJiBCSVQoZXJhc2VbaV0uaWR4KSkpDQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgc3BpX25vcl9zZXRfZXJhc2VfdHlwZSgmZXJhc2VbaV0sIDAsIDB4
RkYpOw0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHNw
aV9ub3JfbWFza19lcmFzZV90eXBlKCZlcmFzZVtpXSk7DQo+IMKgDQo+IMKgwqDCoMKgwqDCoMKg
wqByZXR1cm4gMDsNCj4gwqB9DQo+IEBAIC0xMDg5LDcgKzEwODksNyBAQCBzdGF0aWMgaW50IHNw
aV9ub3JfcGFyc2VfNGJhaXQoc3RydWN0IHNwaV9ub3INCj4gKm5vciwNCj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZXJhc2VfdHlwZVtpXS5vcGNvZGUg
PSAoZHdvcmRzW1NGRFBfRFdPUkQoMildDQo+ID4+DQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoGVyYXNlX3R5cGVbaV0uaWR4ICoNCj4gOCkgJiAweEZGOw0KPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGVsc2UNCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBzcGlfbm9yX3NldF9lcmFzZV90eXBlKCZlcmFzZV90
eXBlW2ldLCAwdSwNCj4gMHhGRik7DQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgc3BpX25vcl9tYXNrX2VyYXNlX3R5cGUoJmVyYXNlX3R5cGVbaV0pOw0K
PiDCoMKgwqDCoMKgwqDCoMKgfQ0KPiDCoA0KPiDCoMKgwqDCoMKgwqDCoMKgLyoNCg==
