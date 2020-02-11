Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE49C1598CB
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 19:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729419AbgBKSfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Feb 2020 13:35:41 -0500
Received: from skedge03.snt-world.com ([91.208.41.68]:37052 "EHLO
        skedge03.snt-world.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728301AbgBKSfl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Feb 2020 13:35:41 -0500
Received: from sntmail14r.snt-is.com (unknown [10.203.32.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by skedge03.snt-world.com (Postfix) with ESMTPS id A124367A878;
        Tue, 11 Feb 2020 19:35:39 +0100 (CET)
Received: from sntmail12r.snt-is.com (10.203.32.182) by sntmail14r.snt-is.com
 (10.203.32.184) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 11 Feb
 2020 19:35:39 +0100
Received: from sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305]) by
 sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305%3]) with mapi id
 15.01.1913.005; Tue, 11 Feb 2020 19:35:39 +0100
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
To:     Boris Brezillon <bbrezillon@kernel.org>,
        Jeff Kletsky <git-commits@allycomm.com>,
        liaoweixiong <liaoweixiong@allwinnertech.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Peter Pan <peterpandong@micron.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Richard Weinberger" <richard@nod.at>
Subject: Re: [PATCH 1/3] mtd: spinand: Stop using spinand->oobbuf for
 buffering bad block markers
Thread-Topic: [PATCH 1/3] mtd: spinand: Stop using spinand->oobbuf for
 buffering bad block markers
Thread-Index: AQHV4PlH+VPeFWBm8k+U84JJEiFI46gWQWYA
Date:   Tue, 11 Feb 2020 18:35:39 +0000
Message-ID: <0f4f2b38-3a5c-fff8-6cd8-e24c94504d9d@kontron.de>
References: <20200211163452.25442-1-frieder.schrempf@kontron.de>
 <20200211163452.25442-2-frieder.schrempf@kontron.de>
In-Reply-To: <20200211163452.25442-2-frieder.schrempf@kontron.de>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.25.9.193]
x-c2processedorg: 51b406b7-48a2-4d03-b652-521f56ac89f3
Content-Type: text/plain; charset="utf-8"
Content-ID: <94A9D4CBC757454C994556A5FDC6A6D5@snt-world.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SnT-MailScanner-Information: Please contact the ISP for more information
X-SnT-MailScanner-ID: A124367A878.AD9A6
X-SnT-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-SnT-MailScanner-SpamCheck: 
X-SnT-MailScanner-From: frieder.schrempf@kontron.de
X-SnT-MailScanner-To: bbrezillon@kernel.org, git-commits@allycomm.com,
        liaoweixiong@allwinnertech.com, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, miquel.raynal@bootlin.com,
        peterpandong@micron.com, richard@nod.at, stable@vger.kernel.org
X-Spam-Status: No
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMTEuMDIuMjAgMTc6MzUsIFNjaHJlbXBmIEZyaWVkZXIgd3JvdGU6DQo+IEZyb206IEZyaWVk
ZXIgU2NocmVtcGYgPGZyaWVkZXIuc2NocmVtcGZAa29udHJvbi5kZT4NCj4gDQo+IEZvciByZWFk
aW5nIGFuZCB3cml0aW5nIHRoZSBiYWQgYmxvY2sgbWFya2Vycywgc3BpbmFuZC0+b29iYnVmIGlz
DQo+IGN1cnJlbnRseSB1c2VkIGFzIGEgYnVmZmVyIGZvciB0aGUgbWFya2VyIGJ5dGVzLiBEdXJp
bmcgdGhlDQo+IHVuZGVybHlpbmcgcmVhZCBhbmQgd3JpdGUgb3BlcmF0aW9ucyB0byBhY3R1YWxs
eSBnZXQvc2V0IHRoZSBjb250ZW50DQo+IG9mIHRoZSBPT0IgYXJlYSwgdGhlIGNvbnRlbnQgb2Yg
c3BpbmFuZC0+b29iYnVmIGlzIHJldXNlZCBhbmQgY2hhbmdlZA0KPiBieSBhY2Nlc3NpbmcgaXQg
dGhyb3VnaCBzcGluYW5kLT5vb2JidWYgYW5kL29yIHNwaW5hbmQtPmRhdGFidWYuDQo+IA0KPiBU
aGlzIGlzIGEgZmxhdyBpbiB0aGUgb3JpZ2luYWwgZGVzaWduIG9mIHRoZSBTUEkgTUVNIGNvcmUg
YW5kIGF0IHRoZQ0KDQpUaGlzIHNob3VsZCBiZSBTUEkgTkFORCwgb2YgY291cnNlLiAgICAgICAg
ICAgIF4NCg0KPiBsYXRlc3QgZnJvbSAxM2MxNWUwN2VlZGYgKCJtdGQ6IHNwaW5hbmQ6IEhhbmRs
ZSB0aGUgY2FzZSB3aGVyZQ0KPiBQUk9HUkFNIExPQUQgZG9lcyBub3QgcmVzZXQgdGhlIGNhY2hl
Iikgb24sIGl0IHJlc3VsdHMgaW4gbm90IGhhdmluZw0KPiB0aGUgYmFkIGJsb2NrIG1hcmtlciB3
cml0dGVuIGF0IGFsbCwgYXMgdGhlIHNwaW5hbmQtPm9vYmJ1ZiBpcw0KPiBjbGVhcmVkIHRvIDB4
ZmYgYWZ0ZXIgc2V0dGluZyB0aGUgbWFya2VyIGJ5dGVzIHRvIHplcm8uDQo+IA0KPiBUbyBmaXgg
aXQsIHdlIG5vdyBqdXN0IHN0b3JlIHRoZSB0d28gYnl0ZXMgZm9yIHRoZSBtYXJrZXIgb24gdGhl
DQo+IHN0YWNrIGFuZCBsZXQgdGhlIHJlYWQvd3JpdGUgb3BlcmF0aW9ucyBjb3B5IGl0IGZyb20v
dG8gdGhlIHBhZ2UNCj4gYnVmZmVyIGxhdGVyLg0KPiANCj4gRml4ZXM6IDc1MjlkZjQ2NTI0OCAo
Im10ZDogbmFuZDogQWRkIGNvcmUgaW5mcmFzdHJ1Y3R1cmUgdG8gc3VwcG9ydCBTUEkgTkFORHMi
KQ0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBTaWduZWQtb2ZmLWJ5OiBGcmllZGVy
IFNjaHJlbXBmIDxmcmllZGVyLnNjaHJlbXBmQGtvbnRyb24uZGU+DQo+IC0tLQ0KPiAgIGRyaXZl
cnMvbXRkL25hbmQvc3BpL2NvcmUuYyB8IDEwICsrKysrLS0tLS0NCj4gICAxIGZpbGUgY2hhbmdl
ZCwgNSBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbXRkL25hbmQvc3BpL2NvcmUuYyBiL2RyaXZlcnMvbXRkL25hbmQvc3BpL2NvcmUuYw0K
PiBpbmRleCA4OWY2YmVlZmIwMWMuLjVkMjY3YTY3YTVmNyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVy
cy9tdGQvbmFuZC9zcGkvY29yZS5jDQo+ICsrKyBiL2RyaXZlcnMvbXRkL25hbmQvc3BpL2NvcmUu
Yw0KPiBAQCAtNTY4LDE4ICs1NjgsMTggQEAgc3RhdGljIGludCBzcGluYW5kX210ZF93cml0ZShz
dHJ1Y3QgbXRkX2luZm8gKm10ZCwgbG9mZl90IHRvLA0KPiAgIHN0YXRpYyBib29sIHNwaW5hbmRf
aXNiYWQoc3RydWN0IG5hbmRfZGV2aWNlICpuYW5kLCBjb25zdCBzdHJ1Y3QgbmFuZF9wb3MgKnBv
cykNCj4gICB7DQo+ICAgCXN0cnVjdCBzcGluYW5kX2RldmljZSAqc3BpbmFuZCA9IG5hbmRfdG9f
c3BpbmFuZChuYW5kKTsNCj4gKwl1OCBtYXJrZXJbXSA9IHsgMCwgMCB9Ow0KPiAgIAlzdHJ1Y3Qg
bmFuZF9wYWdlX2lvX3JlcSByZXEgPSB7DQo+ICAgCQkucG9zID0gKnBvcywNCj4gICAJCS5vb2Js
ZW4gPSAyLA0KPiAgIAkJLm9vYm9mZnMgPSAwLA0KPiAtCQkub29iYnVmLmluID0gc3BpbmFuZC0+
b29iYnVmLA0KPiArCQkub29iYnVmLmluID0gbWFya2VyLA0KPiAgIAkJLm1vZGUgPSBNVERfT1BT
X1JBVywNCj4gICAJfTsNCj4gICANCj4gLQltZW1zZXQoc3BpbmFuZC0+b29iYnVmLCAwLCAyKTsN
Cj4gICAJc3BpbmFuZF9zZWxlY3RfdGFyZ2V0KHNwaW5hbmQsIHBvcy0+dGFyZ2V0KTsNCj4gICAJ
c3BpbmFuZF9yZWFkX3BhZ2Uoc3BpbmFuZCwgJnJlcSwgZmFsc2UpOw0KPiAtCWlmIChzcGluYW5k
LT5vb2JidWZbMF0gIT0gMHhmZiB8fCBzcGluYW5kLT5vb2JidWZbMV0gIT0gMHhmZikNCj4gKwlp
ZiAobWFya2VyWzBdICE9IDB4ZmYgfHwgbWFya2VyWzFdICE9IDB4ZmYpDQo+ICAgCQlyZXR1cm4g
dHJ1ZTsNCj4gICANCj4gICAJcmV0dXJuIGZhbHNlOw0KPiBAQCAtNjAzLDExICs2MDMsMTIgQEAg
c3RhdGljIGludCBzcGluYW5kX210ZF9ibG9ja19pc2JhZChzdHJ1Y3QgbXRkX2luZm8gKm10ZCwg
bG9mZl90IG9mZnMpDQo+ICAgc3RhdGljIGludCBzcGluYW5kX21hcmtiYWQoc3RydWN0IG5hbmRf
ZGV2aWNlICpuYW5kLCBjb25zdCBzdHJ1Y3QgbmFuZF9wb3MgKnBvcykNCj4gICB7DQo+ICAgCXN0
cnVjdCBzcGluYW5kX2RldmljZSAqc3BpbmFuZCA9IG5hbmRfdG9fc3BpbmFuZChuYW5kKTsNCj4g
Kwl1OCBtYXJrZXJbXSA9IHsgMCwgMCB9Ow0KPiAgIAlzdHJ1Y3QgbmFuZF9wYWdlX2lvX3JlcSBy
ZXEgPSB7DQo+ICAgCQkucG9zID0gKnBvcywNCj4gICAJCS5vb2JvZmZzID0gMCwNCj4gICAJCS5v
b2JsZW4gPSAyLA0KPiAtCQkub29iYnVmLm91dCA9IHNwaW5hbmQtPm9vYmJ1ZiwNCj4gKwkJLm9v
YmJ1Zi5vdXQgPSBtYXJrZXIsDQo+ICAgCX07DQo+ICAgCWludCByZXQ7DQo+ICAgDQo+IEBAIC02
MjIsNyArNjIzLDYgQEAgc3RhdGljIGludCBzcGluYW5kX21hcmtiYWQoc3RydWN0IG5hbmRfZGV2
aWNlICpuYW5kLCBjb25zdCBzdHJ1Y3QgbmFuZF9wb3MgKnBvcykNCj4gICANCj4gICAJc3BpbmFu
ZF9lcmFzZV9vcChzcGluYW5kLCBwb3MpOw0KPiAgIA0KPiAtCW1lbXNldChzcGluYW5kLT5vb2Ji
dWYsIDAsIDIpOw0KPiAgIAlyZXR1cm4gc3BpbmFuZF93cml0ZV9wYWdlKHNwaW5hbmQsICZyZXEp
Ow0KPiAgIH0NCj4gICANCj4g
