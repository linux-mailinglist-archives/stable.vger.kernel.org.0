Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB2A854E47
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 14:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbfFYMFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 08:05:01 -0400
Received: from skedge04.snt-world.com ([91.208.41.69]:46404 "EHLO
        skedge04.snt-world.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbfFYMFA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 08:05:00 -0400
Received: from sntmail11s.snt-is.com (unknown [10.203.32.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by skedge04.snt-world.com (Postfix) with ESMTPS id CA6CD67A062;
        Tue, 25 Jun 2019 14:04:58 +0200 (CEST)
Received: from sntmail12r.snt-is.com (10.203.32.182) by sntmail11s.snt-is.com
 (10.203.32.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Tue, 25 Jun
 2019 14:04:58 +0200
Received: from sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305]) by
 sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305%3]) with mapi id
 15.01.1713.004; Tue, 25 Jun 2019 14:04:58 +0200
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
To:     liaoweixiong <liaoweixiong@allwinnertech.com>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        "Richard Weinberger" <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuanhong Guo <gch981213@gmail.com>,
        "Marek Vasut" <marek.vasut@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RESEND PATCH v2] mtd: spinand: read return badly if the last
 page has bitflips
Thread-Topic: [RESEND PATCH v2] mtd: spinand: read return badly if the last
 page has bitflips
Thread-Index: AQHVKvG5vIRdXk03g0+SrXGJtaID9aarjwGAgABB7wCAAFGaAIAAAnWA
Date:   Tue, 25 Jun 2019 12:04:58 +0000
Message-ID: <3c019394-04a1-ff85-867f-29928a996931@kontron.de>
References: <1561424549-784-1-git-send-email-liaoweixiong@allwinnertech.com>
 <20190625030807.GA11074@kroah.com>
 <97adf58f-4771-90f1-bdaf-5a9d00eef768@kontron.de>
 <814a343e-e4c4-3ef2-29e2-d6c56f3d5bbb@allwinnertech.com>
In-Reply-To: <814a343e-e4c4-3ef2-29e2-d6c56f3d5bbb@allwinnertech.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.25.9.193]
x-c2processedorg: 51b406b7-48a2-4d03-b652-521f56ac89f3
Content-Type: text/plain; charset="utf-8"
Content-ID: <9EC415AB919DFC40958CBB43C7495004@snt-world.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SnT-MailScanner-Information: Please contact the ISP for more information
X-SnT-MailScanner-ID: CA6CD67A062.A1039
X-SnT-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-SnT-MailScanner-SpamCheck: 
X-SnT-MailScanner-From: frieder.schrempf@kontron.de
X-SnT-MailScanner-To: bbrezillon@kernel.org, computersforpeace@gmail.com,
        dwmw2@infradead.org, gch981213@gmail.com, gregkh@linuxfoundation.org,
        liaoweixiong@allwinnertech.com, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, marek.vasut@gmail.com,
        miquel.raynal@bootlin.com, richard@nod.at, stable@vger.kernel.org,
        vigneshr@ti.com
X-Spam-Status: No
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMjUuMDYuMTkgMTM6NTYsIGxpYW93ZWl4aW9uZyB3cm90ZToNCj4gT2gsIGkgYW0gc29ycnkg
dGhhdCBpIGhhZCBtaXN1bmRlcnN0YW5kZWQgeW91ciBsZXR0ZXIuDQoNCk5vIHByb2JsZW0gOykN
Cg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgZG9jdW1lbnQgYW5kIGd1aWRhbmNlLg0KDQpZb3UncmUg
d2VsY29tZSENCg0KPiBPbiAyMDE5LzYvMjUgUE0gMzowNCwgU2NocmVtcGYgRnJpZWRlciB3cm90
ZToNCj4+IEhpIGxpYW93ZWl4aW9uZywNCj4+DQo+PiBPbiAyNS4wNi4xOSAwNTowOCwgR3JlZyBL
SCB3cm90ZToNCj4+PiBPbiBUdWUsIEp1biAyNSwgMjAxOSBhdCAwOTowMjoyOUFNICswODAwLCBs
aWFvd2VpeGlvbmcgd3JvdGU6DQo+Pj4+IEluIGNhc2Ugb2YgdGhlIGxhc3QgcGFnZSBjb250YWlu
aW5nIGJpdGZsaXBzIChyZXQgPiAwKSwNCj4+Pj4gc3BpbmFuZF9tdGRfcmVhZCgpIHdpbGwgcmV0
dXJuIHRoYXQgbnVtYmVyIG9mIGJpdGZsaXBzIGZvciB0aGUgbGFzdA0KPj4+PiBwYWdlLiBCdXQg
dG8gbWUgaXQgbG9va3MgbGlrZSBpdCBzaG91bGQgaW5zdGVhZCByZXR1cm4gbWF4X2JpdGZsaXBz
IGxpa2UNCj4+Pj4gaXQgZG9lcyB3aGVuIHRoZSBsYXN0IHBhZ2UgcmVhZCByZXR1cm5zIHdpdGgg
MC4NCj4+Pj4NCj4+Pj4gU2lnbmVkLW9mZi1ieTogbGlhb3dlaXhpb25nIDxsaWFvd2VpeGlvbmdA
YWxsd2lubmVydGVjaC5jb20+DQo+Pj4+IFJldmlld2VkLWJ5OiBCb3JpcyBCcmV6aWxsb24gPGJv
cmlzLmJyZXppbGxvbkBjb2xsYWJvcmEuY29tPg0KPj4+PiBSZXZpZXdlZC1ieTogRnJpZWRlciBT
Y2hyZW1wZiA8ZnJpZWRlci5zY2hyZW1wZkBrb250cm9uLmRlPg0KPj4+PiBGaXhlczogNzUyOWRm
NDY1MjQ4ICgibXRkOiBuYW5kOiBBZGQgY29yZSBpbmZyYXN0cnVjdHVyZSB0byBzdXBwb3J0IFNQ
SSBOQU5EcyIpDQo+Pj4+IC0tLQ0KPj4+PiAgICBkcml2ZXJzL210ZC9uYW5kL3NwaS9jb3JlLmMg
fCAyICstDQo+Pj4+ICAgIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlv
bigtKQ0KPj4+DQo+Pj4gPGZvcm1sZXR0ZXI+DQo+Pj4NCj4+PiBUaGlzIGlzIG5vdCB0aGUgY29y
cmVjdCB3YXkgdG8gc3VibWl0IHBhdGNoZXMgZm9yIGluY2x1c2lvbiBpbiB0aGUNCj4+PiBzdGFi
bGUga2VybmVsIHRyZWUuICBQbGVhc2UgcmVhZDoNCj4+PiAgICAgICBodHRwczovL3d3dy5rZXJu
ZWwub3JnL2RvYy9odG1sL2xhdGVzdC9wcm9jZXNzL3N0YWJsZS1rZXJuZWwtcnVsZXMuaHRtbA0K
Pj4+IGZvciBob3cgdG8gZG8gdGhpcyBwcm9wZXJseS4NCj4+Pg0KPj4+IDwvZm9ybWxldHRlcj4N
Cj4+DQo+PiBGWUksIHlvdSBzaG91bGQgbm90IHNlbmQgdGhlIHBhdGNoIHRvIHN0YWJsZUB2Z2Vy
Lmtlcm5lbC5vcmcsIGJ1dA0KPj4gaW5zdGVhZCwgYXMgSSBzYWlkIGluIG15IG90aGVyIHJlcGx5
LCBhZGQgdGhlIHRhZyAiQ2M6DQo+PiBzdGFibGVAdmdlci5rZXJuZWwub3JnIi4gU2VlICJPcHRp
b24gMSIgaW4gdGhlIGRvY3VtZW50IEdyZWcgcmVmZXJyZWQgdG8uDQo+Pg0KPj4gVGhhbmtzLA0K
Pj4gRnJpZWRlcg0KPj4NCj4g
