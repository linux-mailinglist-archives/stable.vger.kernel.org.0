Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84F6B6BF99D
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 12:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjCRLr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 07:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjCRLr0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 07:47:26 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2468F3E60C
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 04:47:22 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-59-2y__38tnPk6ZP3ZtTrDFnQ-1; Sat, 18 Mar 2023 11:47:19 +0000
X-MC-Unique: 2y__38tnPk6ZP3ZtTrDFnQ-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.47; Sat, 18 Mar
 2023 11:47:15 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.047; Sat, 18 Mar 2023 11:47:15 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     =?utf-8?B?J0lscG8gSsOkcnZpbmVuJw==?= 
        <ilpo.jarvinen@linux.intel.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 2/2] serial: 8250: Fix serial8250_tx_empty() race with
 DMA Tx
Thread-Topic: [PATCH v2 2/2] serial: 8250: Fix serial8250_tx_empty() race with
 DMA Tx
Thread-Index: AQHZWMRTccAjepUKg0S0Al/dSgkBsq8AalpA
Date:   Sat, 18 Mar 2023 11:47:15 +0000
Message-ID: <52fae6e3e7254a96beefd2774f7d6254@AcuMS.aculab.com>
References: <20230317113318.31327-1-ilpo.jarvinen@linux.intel.com>
 <20230317113318.31327-3-ilpo.jarvinen@linux.intel.com>
In-Reply-To: <20230317113318.31327-3-ilpo.jarvinen@linux.intel.com>
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

RnJvbTogSWxwbyBKw6RydmluZW4NCj4gU2VudDogMTcgTWFyY2ggMjAyMyAxMTozMw0KPiBUbzog
bGludXgtc2VyaWFsQHZnZXIua2VybmVsLm9yZzsgR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hA
bGludXhmb3VuZGF0aW9uLm9yZz47IEppcmkgU2xhYnkNCj4gDQo+IFRoZXJlJ3MgYSBwb3RlbnRp
YWwgcmFjZSBiZWZvcmUgVEhSRS9URU1UIGRlYXNzZXJ0cyB3aGVuIERNQSBUeCBpcw0KPiBzdGFy
dGluZyB1cCAob3IgdGhlIG5leHQgYmF0Y2ggb2YgY29udGludW91cyBUeCBpcyBiZWluZyBzdWJt
aXR0ZWQpLg0KPiBUaGlzIGNhbiBsZWFkIHRvIG1pc2RldGVjdGluZyBUeCBlbXB0eSBjb25kaXRp
b24uDQo+IA0KPiBJdCBpcyBlbnRpcmVseSBub3JtYWwgZm9yIFRIUkUvVEVNVCB0byBiZSBzZXQg
Zm9yIHNvbWUgdGltZSBhZnRlciB0aGUNCj4gRE1BIFR4IGhhZCBiZWVuIHNldHVwIGluIHNlcmlh
bDgyNTBfdHhfZG1hKCkuIEFzIFR4IHNpZGUgaXMgZGVmaW5pdGVseQ0KPiBub3QgZW1wdHkgYXQg
dGhhdCBwb2ludCwgaXQgc2VlbXMgaW5jb3JyZWN0IGZvciBzZXJpYWw4MjUwX3R4X2VtcHR5KCkN
Cj4gY2xhaW0gVHggaXMgZW1wdHkuDQo+IA0KPiBGaXggdGhlIHJhY2UgYnkgYWxzbyBjaGVja2lu
ZyBpbiBzZXJpYWw4MjUwX3R4X2VtcHR5KCkgd2hldGhlciB0aGVyZSdzDQo+IERNQSBUeCBhY3Rp
dmUuDQo+IA0KPiBOb3RlOiBUaGlzIGZpeCBvbmx5IGFkZHJlc3NlcyBpbi1rZXJuZWwgcmFjZSBt
YWlubHkgdG8gbWFrZSB1c2luZw0KPiBUQ1NBRFJBSU4vRkxVU0ggcm9idXN0LiBVc2Vyc3BhY2Ug
Y2FuIHN0aWxsIGNhdXNlIG90aGVyIHJhY2VzIGJ1dCB0aGV5DQo+IHNlZW0gdXNlcnNwYWNlIGNv
bmN1cnJlbmN5IGNvbnRyb2wgcHJvYmxlbXMuDQoNCkxvb2tzIGJldHRlciwgYnV0IEknbSBub3Qg
c3VyZSBpdCBhY3R1YWxseSB3b3Jrcy4NCg0KSWYgaW50ZXJydXB0cyBhcmUgYmVpbmcgdXNlZCB0
byBjb3B5IGRhdGEgdG8gdGhlIHR4IGZpZm8gdGhlbg0KKGRlcGVuZGluZyBvbiBpbnRlcnJ1cHQg
bGF0ZW5jeSBhbmQgZXhhY3RseSB3aGVuIHRoZSBpbnRlcnJ1cHQNCmlzIHJlcXVlc3RlZCkgdGhl
IGNvZGUgbWlnaHQgcmVwb3J0ICd0eCBlbXB0eScgd2hlbiB0aGUgSVNSDQppcyBhYm91dCB0byBj
b3B5IGluIG1vcmUgZGF0YS4NCg0KTm93IHRoZSBkcmFpbi9mbHVzaCBjb2RlIG1pZ2h0IGFscmVh
ZHkgaGF2ZSBjaGVja2VkIHRoZXJlIGlzDQpubyBtb3JlIGRhdGEgcXVldWVkIGluIHRoZSBkcml2
ZXIgYmVmb3JlIGNhbGxpbmcgdGhpcywNCmJ1dCBtb3JlIGdlbmVyYWxseSBzaG91bGRuJ3QgaXQg
YmUgY2hlY2tpbmc6DQoJbm9fZGF0YV9xdWV1ZWRfaW5fZHJpdmVyICYmIGhhcmR3YXJlX2ZpZm9f
ZW1wdHkuDQoNCkFueSAnbm9fZGF0YV9xdWV1ZWRfaW5fZHJpdmVyJyBjaGVjayB3b3VsZCBwcm9i
YWJseSBpbmNsdWRlDQpkYXRhIHRoYXQgZG1hIGlzIGNvcHlpbmcgLSBzbyB0aGUgZXhwbGljaXQg
ZG1hIGNoZWNrIG1pZ2h0DQpub3QgYmUgbmVlZGVkLg0KDQoJRGF2aWQNCg0KPiANCj4gRml4ZXM6
IDllZTRiODNlNTFmNzQgKCJzZXJpYWw6IDgyNTA6IEFkZCBzdXBwb3J0IGZvciBkbWFlbmdpbmUi
KQ0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBTaWduZWQtb2ZmLWJ5OiBJbHBvIErD
pHJ2aW5lbiA8aWxwby5qYXJ2aW5lbkBsaW51eC5pbnRlbC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVy
cy90dHkvc2VyaWFsLzgyNTAvODI1MC5oICAgICAgfCAxMiArKysrKysrKysrKysNCj4gIGRyaXZl
cnMvdHR5L3NlcmlhbC84MjUwLzgyNTBfcG9ydC5jIHwgIDcgKysrKy0tLQ0KPiAgMiBmaWxlcyBj
aGFuZ2VkLCAxNiBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvdHR5L3NlcmlhbC84MjUwLzgyNTAuaCBiL2RyaXZlcnMvdHR5L3NlcmlhbC84
MjUwLzgyNTAuaA0KPiBpbmRleCAyODcxNTNkMzI1MzYuLjFlOGZlNDRhNzA5OSAxMDA2NDQNCj4g
LS0tIGEvZHJpdmVycy90dHkvc2VyaWFsLzgyNTAvODI1MC5oDQo+ICsrKyBiL2RyaXZlcnMvdHR5
L3NlcmlhbC84MjUwLzgyNTAuaA0KPiBAQCAtMzY1LDYgKzM2NSwxMyBAQCBzdGF0aWMgaW5saW5l
IHZvaWQgc2VyaWFsODI1MF9kb19wcmVwYXJlX3J4X2RtYShzdHJ1Y3QgdWFydF84MjUwX3BvcnQg
KnApDQo+ICAJaWYgKGRtYS0+cHJlcGFyZV9yeF9kbWEpDQo+ICAJCWRtYS0+cHJlcGFyZV9yeF9k
bWEocCk7DQo+ICB9DQo+ICsNCj4gK3N0YXRpYyBpbmxpbmUgYm9vbCBzZXJpYWw4MjUwX3R4X2Rt
YV9ydW5uaW5nKHN0cnVjdCB1YXJ0XzgyNTBfcG9ydCAqcCkNCj4gK3sNCj4gKwlzdHJ1Y3QgdWFy
dF84MjUwX2RtYSAqZG1hID0gcC0+ZG1hOw0KPiArDQo+ICsJcmV0dXJuIGRtYSAmJiBkbWEtPnR4
X3J1bm5pbmc7DQo+ICt9DQo+ICAjZWxzZQ0KPiAgc3RhdGljIGlubGluZSBpbnQgc2VyaWFsODI1
MF90eF9kbWEoc3RydWN0IHVhcnRfODI1MF9wb3J0ICpwKQ0KPiAgew0KPiBAQCAtMzgwLDYgKzM4
NywxMSBAQCBzdGF0aWMgaW5saW5lIGludCBzZXJpYWw4MjUwX3JlcXVlc3RfZG1hKHN0cnVjdCB1
YXJ0XzgyNTBfcG9ydCAqcCkNCj4gIAlyZXR1cm4gLTE7DQo+ICB9DQo+ICBzdGF0aWMgaW5saW5l
IHZvaWQgc2VyaWFsODI1MF9yZWxlYXNlX2RtYShzdHJ1Y3QgdWFydF84MjUwX3BvcnQgKnApIHsg
fQ0KPiArDQo+ICtzdGF0aWMgaW5saW5lIGJvb2wgc2VyaWFsODI1MF90eF9kbWFfcnVubmluZyhz
dHJ1Y3QgdWFydF84MjUwX3BvcnQgKnApDQo+ICt7DQo+ICsJcmV0dXJuIGZhbHNlOw0KPiArfQ0K
PiAgI2VuZGlmDQo+IA0KPiAgc3RhdGljIGlubGluZSBpbnQgbnMxNjU1MGFfZ290b19oaWdoc3Bl
ZWQoc3RydWN0IHVhcnRfODI1MF9wb3J0ICp1cCkNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdHR5
L3NlcmlhbC84MjUwLzgyNTBfcG9ydC5jIGIvZHJpdmVycy90dHkvc2VyaWFsLzgyNTAvODI1MF9w
b3J0LmMNCj4gaW5kZXggZmE0M2RmMDUzNDJiLi4xMDdiY2RmYjExOWMgMTAwNjQ0DQo+IC0tLSBh
L2RyaXZlcnMvdHR5L3NlcmlhbC84MjUwLzgyNTBfcG9ydC5jDQo+ICsrKyBiL2RyaXZlcnMvdHR5
L3NlcmlhbC84MjUwLzgyNTBfcG9ydC5jDQo+IEBAIC0yMDA1LDE4ICsyMDA1LDE5IEBAIHN0YXRp
YyBpbnQgc2VyaWFsODI1MF90eF90aHJlc2hvbGRfaGFuZGxlX2lycShzdHJ1Y3QgdWFydF9wb3J0
ICpwb3J0KQ0KPiAgc3RhdGljIHVuc2lnbmVkIGludCBzZXJpYWw4MjUwX3R4X2VtcHR5KHN0cnVj
dCB1YXJ0X3BvcnQgKnBvcnQpDQo+ICB7DQo+ICAJc3RydWN0IHVhcnRfODI1MF9wb3J0ICp1cCA9
IHVwX3RvX3U4MjUwcChwb3J0KTsNCj4gKwl1bnNpZ25lZCBpbnQgcmVzdWx0ID0gMDsNCj4gIAl1
bnNpZ25lZCBsb25nIGZsYWdzOw0KPiAtCXUxNiBsc3I7DQo+IA0KPiAgCXNlcmlhbDgyNTBfcnBt
X2dldCh1cCk7DQo+IA0KPiAgCXNwaW5fbG9ja19pcnFzYXZlKCZwb3J0LT5sb2NrLCBmbGFncyk7
DQo+IC0JbHNyID0gc2VyaWFsX2xzcl9pbih1cCk7DQo+ICsJaWYgKCFzZXJpYWw4MjUwX3R4X2Rt
YV9ydW5uaW5nKHVwKSAmJiB1YXJ0X2xzcl90eF9lbXB0eShzZXJpYWxfbHNyX2luKHVwKSkpDQo+
ICsJCXJlc3VsdCA9IFRJT0NTRVJfVEVNVDsNCj4gIAlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZw
b3J0LT5sb2NrLCBmbGFncyk7DQo+IA0KPiAgCXNlcmlhbDgyNTBfcnBtX3B1dCh1cCk7DQo+IA0K
PiAtCXJldHVybiB1YXJ0X2xzcl90eF9lbXB0eShsc3IpID8gVElPQ1NFUl9URU1UIDogMDsNCj4g
KwlyZXR1cm4gcmVzdWx0Ow0KPiAgfQ0KPiANCj4gIHVuc2lnbmVkIGludCBzZXJpYWw4MjUwX2Rv
X2dldF9tY3RybChzdHJ1Y3QgdWFydF9wb3J0ICpwb3J0KQ0KPiAtLQ0KPiAyLjMwLjINCg0KLQ0K
UmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1p
bHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVz
KQ0K

