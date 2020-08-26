Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF622525F0
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 06:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725294AbgHZEAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 00:00:15 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:23678 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725267AbgHZEAO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 00:00:14 -0400
X-UUID: 2128476f42c14117bbdba1fb17b194aa-20200826
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=RBEX1ExJEO1XdJLmf9rWy6KHd2buj+9SjY2A9V9tzWs=;
        b=dfoiU5roNF+25w0/NUxV9IQ5G1jz4TyrCy6pPAfvGFsXRj8IBDKfi9maXnJuqzrtsE9z15vDDO0h3s8lnFEu7EP6owu5crHnvFWB6Kd5d/1wPaDPBhzwSW25Tpp6KQH5Nz1SpOUJhJhyIkeESvoMUTQRBkSnexTJYKdQ7tTqEFc=;
X-UUID: 2128476f42c14117bbdba1fb17b194aa-20200826
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1255619686; Wed, 26 Aug 2020 12:00:08 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs06n2.mediatek.inc (172.21.101.130) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 26 Aug 2020 12:00:07 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 Aug 2020 12:00:06 +0800
Message-ID: <1598414407.10649.19.camel@mtkswgap22>
Subject: Re: [PATCH] block: Fix a race in the runtime power management code
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Jens Axboe <axboe@kernel.dk>, <linux-block@vger.kernel.org>,
        "Christoph Hellwig" <hch@lst.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ming Lei <ming.lei@redhat.com>,
        stable <stable@vger.kernel.org>, Can Guo <cang@codeaurora.org>
Date:   Wed, 26 Aug 2020 12:00:07 +0800
In-Reply-To: <ee6b4ab1-d118-ef5d-a075-e13dfdb678a7@acm.org>
References: <20200824030607.19357-1-bvanassche@acm.org>
         <1598346681.10649.8.camel@mtkswgap22>
         <ee6b4ab1-d118-ef5d-a075-e13dfdb678a7@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: E4EE1D1EAAA63A3BDDCA5D4EE31564099D04AA995584F311E8BB4F1DEA09422A2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgQmFydCwNCg0KT24gVHVlLCAyMDIwLTA4LTI1IGF0IDE5OjU4IC0wNzAwLCBCYXJ0IFZhbiBB
c3NjaGUgd3JvdGU6DQo+IE9uIDIwMjAtMDgtMjUgMDI6MTEsIFN0YW5sZXkgQ2h1IHdyb3RlOg0K
PiA+PiBkaWZmIC0tZ2l0IGEvYmxvY2svYmxrLXBtLmMgYi9ibG9jay9ibGstcG0uYw0KPiA+PiBp
bmRleCBiODUyMzRkNzU4ZjcuLjE3YmQwMjAyNjhkNCAxMDA2NDQNCj4gPj4gLS0tIGEvYmxvY2sv
YmxrLXBtLmMNCj4gPj4gKysrIGIvYmxvY2svYmxrLXBtLmMNCj4gPj4gQEAgLTY3LDYgKzY3LDEw
IEBAIGludCBibGtfcHJlX3J1bnRpbWVfc3VzcGVuZChzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSkN
Cj4gPj4gIA0KPiA+PiAgCVdBUk5fT05fT05DRShxLT5ycG1fc3RhdHVzICE9IFJQTV9BQ1RJVkUp
Ow0KPiA+PiAgDQo+ID4+ICsJc3Bpbl9sb2NrX2lycSgmcS0+cXVldWVfbG9jayk7DQo+ID4+ICsJ
cS0+cnBtX3N0YXR1cyA9IFJQTV9TVVNQRU5ESU5HOw0KPiA+PiArCXNwaW5fdW5sb2NrX2lycSgm
cS0+cXVldWVfbG9jayk7DQo+ID4+ICsNCj4gPiANCj4gPiBIYXMgYmVsb3cgYWx0ZXJuYXRpdmUg
d2F5IGJlZW4gY29uc2lkZXJlZCB0aGF0IFJQTV9TVVNQRU5ESU5HIGlzIHNldA0KPiA+IGFmdGVy
IGJsa19mcmVlemVfcXVldWVfc3RhcnQoKT8NCj4gPiANCj4gPiAJYmxrX2ZyZWV6ZV9xdWV1ZV9z
dGFydChxKTsNCj4gPiANCj4gPiArCXNwaW5fbG9ja19pcnEoJnEtPnF1ZXVlX2xvY2spOw0KPiA+
ICsJcS0+cnBtX3N0YXR1cyA9IFJQTV9TVVNQRU5ESU5HOw0KPiA+ICsJc3Bpbl91bmxvY2tfaXJx
KCZxLT5xdWV1ZV9sb2NrKTsNCj4gPiANCj4gPiANCj4gPiBPdGhlcndpc2UgcmVxdWVzdHMgY2Fu
IGVudGVyIHF1ZXVlIHdoaWxlIHJwbV9zdGF0dXMgaXMgUlBNX1NVU1BFTkRJTkcNCj4gPiBkdXJp
bmcgYSBzbWFsbCB3aW5kb3csIGkuZS4sIGJlZm9yZSBibGtfc2V0X3BtX29ubHkoKSBpcyBpbnZv
a2VkLiBUaGlzDQo+ID4gd291bGQgbWFrZSB0aGUgZGVmaW5pdGlvbiBvZiBycG1fc3RhdHVzIGFt
YmlndW91cy4NCj4gPiANCj4gPiBJbiB0aGlzIHdheSwgdGhlIHJhY2luZyBjb3VsZCBiZSBhbHNv
IHNvbHZlZDoNCj4gPiANCj4gPiAtIEJlZm9yZSBibGtfZnJlZXplX3F1ZXVlX3N0YXJ0KCksIGFu
eSByZXF1ZXN0cyBzaGFsbCBiZSBhbGxvd2VkIHRvDQo+ID4gZW50ZXIgcXVldWUNCj4gPiAtIGJs
a19mcmVlemVfcXVldWVfc3RhcnQoKSBmcmVlemVzIHRoZSBxdWV1ZSBhbmQgYmxvY2tzIGFsbCB1
cGNvbWluZw0KPiA+IHJlcXVlc3RzIChtYWtlIHRoZW0gd2FpdF9ldmVudChxLT5tcV9mcmVlemVf
d3EpKQ0KPiA+IC0gcnBtX3N0YXR1cyBpcyBzZXQgYXMgUlBNX1NVU1BFTkRJTkcNCj4gPiAtIGJs
a19tcV91bmZyZWV6ZV9xdWV1ZSgpIHdha2VzIHVwIHEtPm1xX2ZyZWV6ZV93cSBhbmQgdGhlbg0K
PiA+IGJsa19wbV9yZXF1ZXN0X3Jlc3VtZSgpIGNhbiBiZSBleGVjdXRlZA0KPiANCj4gSGkgU3Rh
bmxleSwNCj4gDQo+IEkgcHJlZmVyIHRoZSBvcmRlciBmcm9tIHRoZSBwYXRjaC4gSSB0aGluayBp
dCBpcyBpbXBvcnRhbnQgdG8gY2hhbmdlDQo+IHEtPnJwbV9zdGF0dXMgaW50byBSUE1fU1VTUEVO
RElORyBiZWZvcmUgYmxrX3F1ZXVlX2VudGVyKCkgY2FsbHMNCj4gYmxrX3F1ZXVlX3BtX29ubHko
KS4gT3RoZXJ3aXNlIGl0IGNvdWxkIGhhcHBlbiB0aGF0IGJsa19xdWV1ZV9lbnRlcigpDQo+IGNh
bGxzIGJsa19wbV9yZXF1ZXN0X3Jlc3VtZSgpIHdoaWxlIHEtPnJwbV9zdGF0dXMgPT0gUlBNX0FD
VElWRSwgcmVzdWx0aW5nDQo+IGluIGJsa19xdWV1ZV9lbnRlcigpIG5vdCByZXN1bWluZyBhIHF1
ZXVlIGFsdGhvdWdoIHRoYXQgcXVldWUgc2hvdWxkIGJlDQo+IHJlc3VtZWQuDQoNCkkgc2VlLiBU
aGFua3MgZm9yIHRoZSBleHBsYW5hdGlvbi4NCg0KQnkgdGhlIG9yZGVyIGZyb20gdGhlIHBhdGNo
LCBpdCBpcyBndWFyYW50ZWVkIHRoYXQNCmJsa19wbV9yZXF1ZXN0X3Jlc3VtZSgpIHdpbGwgYWx3
YXlzIHRyaWdnZXIgcnVudGltZSByZXN1bWUgZmxvdyBkdXJpbmcNCmJsa19xdWV1ZV9lbnRlcigp
IGFmdGVyIGJsa19zZXRfcG1fb25seSgpIGlzIGNhbGxlZCBieSBjb25jdXJyZW50DQpzdXNwZW5k
IGZsb3csIGkuZS4sIGJsa19wcmVfcnVudGltZV9zdXNwZW5kKCkuDQoNCkhvd2V2ZXIgaXQgd291
bGQgaGF2ZSBhbiBhbWJpZ3VvdXMgUlBNX1NVU1BFTkRJTkcgcnBtX3N0YXR1cyBldmVuIHRob3Vn
aA0KaXQgbWF5IG5vdCBjYXVzZSBpc3N1ZXMgb2J2aW91c2x5Lg0KDQpBY2tlZC1CeTogU3Rhbmxl
eSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCg0KDQo=

