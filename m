Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5236BE2BC
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 09:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbjCQILB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 04:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbjCQIKy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 04:10:54 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF170CD675
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 01:10:22 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-304-MWU-jB63O1-wjO_6J_lLaw-1; Fri, 17 Mar 2023 08:09:17 +0000
X-MC-Unique: MWU-jB63O1-wjO_6J_lLaw-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.47; Fri, 17 Mar
 2023 08:09:15 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.047; Fri, 17 Mar 2023 08:09:15 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     =?utf-8?B?J0lscG8gSsOkcnZpbmVuJw==?= 
        <ilpo.jarvinen@linux.intel.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 2/2] serial: 8250: Fix serial8250_tx_empty() race with DMA
 Tx
Thread-Topic: [PATCH 2/2] serial: 8250: Fix serial8250_tx_empty() race with
 DMA Tx
Thread-Index: AQHZWArCK8WwTTBjQ0K/guscWP8/fq7+nMjw
Date:   Fri, 17 Mar 2023 08:09:14 +0000
Message-ID: <55704d488ee644f5a710841f3912b25f@AcuMS.aculab.com>
References: <20230316132452.76478-1-ilpo.jarvinen@linux.intel.com>
 <20230316132452.76478-3-ilpo.jarvinen@linux.intel.com>
In-Reply-To: <20230316132452.76478-3-ilpo.jarvinen@linux.intel.com>
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogSWxwbyBKw6RydmluZW4NCj4gU2VudDogMTYgTWFyY2ggMjAyMyAxMzoyNQ0KPiANCj4g
VGhlcmUncyBhIHBvdGVudGlhbCByYWNlIGJlZm9yZSBUSFJFL1RFTVQgZGVhc3NlcnRzIHdoZW4g
RE1BIFR4IGlzDQo+IHN0YXJ0aW5nIHVwIChvciB0aGUgbmV4dCBiYXRjaCBvZiBjb250aW51b3Vz
IFR4IGlzIGJlaW5nIHN1Ym1pdHRlZCkuDQo+IFRoaXMgY2FuIGxlYWQgdG8gbWlzZGV0ZWN0aW5n
IFR4IGVtcHR5IGNvbmRpdGlvbi4NCj4gDQo+IEl0IGlzIGVudGlyZWx5IG5vcm1hbCBmb3IgVEhS
RS9URU1UIHRvIGJlIHNldCBmb3Igc29tZSB0aW1lIGFmdGVyIHRoZQ0KPiBETUEgVHggaGFkIGJl
ZW4gc2V0dXAgaW4gc2VyaWFsODI1MF90eF9kbWEoKS4gQXMgVHggc2lkZSBpcyBkZWZpbml0ZWx5
DQo+IG5vdCBlbXB0eSBhdCB0aGF0IHBvaW50LCBpdCBzZWVtcyBpbmNvcnJlY3QgZm9yIHNlcmlh
bDgyNTBfdHhfZW1wdHkoKQ0KPiBjbGFpbSBUeCBpcyBlbXB0eS4NCj4gDQo+IEZpeCB0aGUgcmFj
ZSBieSBhbHNvIGNoZWNraW5nIGluIHNlcmlhbDgyNTBfdHhfZW1wdHkoKSB3aGV0aGVyIHRoZXJl
J3MNCj4gRE1BIFR4IGFjdGl2ZS4NCj4gDQo+IE5vdGU6IFRoaXMgZml4IG9ubHkgYWRkcmVzc2Vz
IGluLWtlcm5lbCByYWNlIG1haW5seSB0byBtYWtlIHVzaW5nDQo+IFRDU0FEUkFJTi9GTFVTSCBy
b2J1c3QuIFVzZXJzcGFjZSBjYW4gc3RpbGwgY2F1c2Ugb3RoZXIgcmFjZXMgYnV0IHRoZXkNCj4g
c2VlbSB1c2Vyc3BhY2UgY29uY3VycmVuY3kgY29udHJvbCBwcm9ibGVtcy4NCj4gDQo+IEZpeGVz
OiA5ZWU0YjgzZTUxZjc0ICgic2VyaWFsOiA4MjUwOiBBZGQgc3VwcG9ydCBmb3IgZG1hZW5naW5l
IikNCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gU2lnbmVkLW9mZi1ieTogSWxwbyBK
w6RydmluZW4gPGlscG8uamFydmluZW5AbGludXguaW50ZWwuY29tPg0KPiAtLS0NCj4gIGRyaXZl
cnMvdHR5L3NlcmlhbC84MjUwLzgyNTAuaCAgICAgIHwgMTIgKysrKysrKysrKysrDQo+ICBkcml2
ZXJzL3R0eS9zZXJpYWwvODI1MC84MjUwX3BvcnQuYyB8ICA3ICsrKysrKy0NCj4gIDIgZmlsZXMg
Y2hhbmdlZCwgMTggaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvdHR5L3NlcmlhbC84MjUwLzgyNTAuaCBiL2RyaXZlcnMvdHR5L3NlcmlhbC84
MjUwLzgyNTAuaA0KLi4uDQo+ICBzdGF0aWMgaW5saW5lIGludCBuczE2NTUwYV9nb3RvX2hpZ2hz
cGVlZChzdHJ1Y3QgdWFydF84MjUwX3BvcnQgKnVwKQ0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy90
dHkvc2VyaWFsLzgyNTAvODI1MF9wb3J0LmMgYi9kcml2ZXJzL3R0eS9zZXJpYWwvODI1MC84MjUw
X3BvcnQuYw0KPiBpbmRleCBmYTQzZGYwNTM0MmIuLjQ5NTRjNGYxNWZiMiAxMDA2NDQNCj4gLS0t
IGEvZHJpdmVycy90dHkvc2VyaWFsLzgyNTAvODI1MF9wb3J0LmMNCj4gKysrIGIvZHJpdmVycy90
dHkvc2VyaWFsLzgyNTAvODI1MF9wb3J0LmMNCj4gQEAgLTIwMDYsMTcgKzIwMDYsMjIgQEAgc3Rh
dGljIHVuc2lnbmVkIGludCBzZXJpYWw4MjUwX3R4X2VtcHR5KHN0cnVjdCB1YXJ0X3BvcnQgKnBv
cnQpDQo+ICB7DQo+ICAJc3RydWN0IHVhcnRfODI1MF9wb3J0ICp1cCA9IHVwX3RvX3U4MjUwcChw
b3J0KTsNCj4gIAl1bnNpZ25lZCBsb25nIGZsYWdzOw0KPiArCWJvb2wgZG1hX3R4X3J1bm5pbmc7
DQo+ICAJdTE2IGxzcjsNCj4gDQo+ICAJc2VyaWFsODI1MF9ycG1fZ2V0KHVwKTsNCj4gDQo+ICAJ
c3Bpbl9sb2NrX2lycXNhdmUoJnBvcnQtPmxvY2ssIGZsYWdzKTsNCj4gIAlsc3IgPSBzZXJpYWxf
bHNyX2luKHVwKTsNCj4gKwlkbWFfdHhfcnVubmluZyA9IHNlcmlhbDgyNTBfdHhfZG1hX3J1bm5p
bmcodXApOw0KPiAgCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnBvcnQtPmxvY2ssIGZsYWdzKTsN
Cj4gDQo+ICAJc2VyaWFsODI1MF9ycG1fcHV0KHVwKTsNCj4gDQo+IC0JcmV0dXJuIHVhcnRfbHNy
X3R4X2VtcHR5KGxzcikgPyBUSU9DU0VSX1RFTVQgOiAwOw0KPiArCWlmICh1YXJ0X2xzcl90eF9l
bXB0eShsc3IpICYmICFkbWFfdHhfcnVubmluZykNCj4gKwkJcmV0dXJuIFRJT0NTRVJfVEVNVDsN
Cj4gKw0KPiArCXJldHVybiAwOw0KPiAgfQ0KDQpTaW5jZSBjaGVja2luZyB3aGV0aGVyIGRtYSBp
cyBhY3RpdmUgaXMgZmFzdCBidXQgcmVhZGluZw0KdGhlIGxzciBpcyBzbG93IGl0IGlzIHByb2Jh
Ymx5IGJldHRlciB0byBnZW5lcmF0ZSB0aGUgcmV0dXJuDQp2YWx1ZSBpbnNpZGUgdGhlIGxvY2sg
YW5kIHRlc3QgZm9yIGRtYSBmaXJzdC4NClNvbWV0aGluZyBsaWtlOg0KCXNwaW5fbG9jaygpDQoJ
cmVzdWx0ID0gMDsNCglpZiAoIXNlcmlhbDgyNTBfdHhfZG1hX3J1bm5pbmcodXApICYmDQoJICAg
IHVhcnRfbHNyX3R4X2VtcHR5KHNlcmlhbF9sc3JfaW4odXApKSkNCgkJcmVzdWx0ID0gVElPQ1NF
Ul9URU1UOw0KCX0NCglzcGluX3VubG9jaygpDQoJLi4uDQoJcmV0dXJuIHJlc3VsdDsNCg0KCURh
dmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3Vu
dCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3
Mzg2IChXYWxlcykNCg==

