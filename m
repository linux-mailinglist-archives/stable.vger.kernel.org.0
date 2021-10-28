Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF0E43DAE4
	for <lists+stable@lfdr.de>; Thu, 28 Oct 2021 07:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbhJ1F4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Oct 2021 01:56:44 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:34426 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229586AbhJ1F4n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Oct 2021 01:56:43 -0400
X-UUID: 239480cb99e147c4b7009459a10e5637-20211028
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=Nr8c5aHXlwibVnUmW5WuIOgCi8SwSdCWVI3tM+6NXBo=;
        b=i3RgqrlnGo13bJizqF/Vxt+fpiid41r9ZRpPd9N481LpjQlc5LppxpWGdmNqku/PbhBUkWTdty5Oe+MGABO1I2f51ux4rndXnZHzdTalWHjQjWgRJ2bIjy59XXLSX9eR5W7AqreMpq5nYE6ASXQpBQv5vMJ4cJabPXxzEP6QWvI=;
X-UUID: 239480cb99e147c4b7009459a10e5637-20211028
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <chaotian.jing@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1214121677; Thu, 28 Oct 2021 13:54:14 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Thu, 28 Oct 2021 13:54:13 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkmbs10n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Thu, 28 Oct 2021 13:54:12 +0800
Message-ID: <facef42345435d82600aca87d9b020fa073506ce.camel@mediatek.com>
Subject: Re: [PATCH] mmc: mediatek: move cqhci init behind ungate clock
From:   Chaotian Jing <chaotian.jing@mediatek.com>
To:     Wenbin Mei <wenbin.mei@mediatek.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
CC:     Matthias Brugger <matthias.bgg@gmail.com>,
        Chun-Hung Wu <chun-hung.wu@mediatek.com>,
        Yong Mao <yong.mao@mediatek.com>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <srv_heupstream@mediatek.com>, <stable@vger.kernel.org>
Date:   Thu, 28 Oct 2021 13:54:12 +0800
In-Reply-To: <20211028022049.22129-1-wenbin.mei@mediatek.com>
References: <20211028022049.22129-1-wenbin.mei@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDIxLTEwLTI4IGF0IDEwOjIwICswODAwLCBXZW5iaW4gTWVpIHdyb3RlOg0KPiBX
ZSBtdXN0IGVuYWJsZSBjbG9jayBiZWZvcmUgY3FoY2kgaW5pdCwgYmVjYXVzZSBjcnlwdG8gbmVl
ZHMNCj4gcmVhZCBpbmZvcm1hdGlvbiBmcm9tIENRSENJIHJlZ2lzdGVycywgb3RoZXJ3aXNlLCBp
dCB3aWxsIGhhbmcNCj4gaW4gTWVkaWFUZWsgbW1jIGhvc3QgY29udHJvbGxlci4NCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IFdlbmJpbiBNZWkgPHdlbmJpbi5tZWlAbWVkaWF0ZWsuY29tPg0KICBBY2tl
ZC1ieTogQ2hhb3RpYW4gSmluZyA8Y2hhb3RpYW4uamluZ0BtZWRpYXRlay5jb20+DQo+IEZpeGVz
OiA4OGJkNjUyYjNjNzQgKCJtbWM6IG1lZGlhdGVrOiBjb21tYW5kIHF1ZXVlIHN1cHBvcnQiKQ0K
PiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiAtLS0NCj4gIGRyaXZlcnMvbW1jL2hvc3Qv
bXRrLXNkLmMgfCAzOCArKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLQ0KPiAtLS0N
Cj4gIDEgZmlsZSBjaGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspLCAxOSBkZWxldGlvbnMoLSkNCj4g
DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21tYy9ob3N0L210ay1zZC5jIGIvZHJpdmVycy9tbWMv
aG9zdC9tdGstc2QuYw0KPiBpbmRleCBiMTI0Y2ZlZTA1YTEuLjk0Mzk0MGI0NGU4MyAxMDA2NDQN
Cj4gLS0tIGEvZHJpdmVycy9tbWMvaG9zdC9tdGstc2QuYw0KPiArKysgYi9kcml2ZXJzL21tYy9o
b3N0L210ay1zZC5jDQo+IEBAIC0yNjU2LDYgKzI2NTYsMjUgQEAgc3RhdGljIGludCBtc2RjX2Ry
dl9wcm9iZShzdHJ1Y3QNCj4gcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPiAgCQlob3N0LT5kbWFf
bWFzayA9IERNQV9CSVRfTUFTSygzMik7DQo+ICAJbW1jX2RldihtbWMpLT5kbWFfbWFzayA9ICZo
b3N0LT5kbWFfbWFzazsNCj4gIA0KPiArCWhvc3QtPnRpbWVvdXRfY2xrcyA9IDMgKiAxMDQ4NTc2
Ow0KPiArCWhvc3QtPmRtYS5ncGQgPSBkbWFfYWxsb2NfY29oZXJlbnQoJnBkZXYtPmRldiwNCj4g
KwkJCQkyICogc2l6ZW9mKHN0cnVjdCBtdF9ncGRtYV9kZXNjKSwNCj4gKwkJCQkmaG9zdC0+ZG1h
LmdwZF9hZGRyLCBHRlBfS0VSTkVMKTsNCj4gKwlob3N0LT5kbWEuYmQgPSBkbWFfYWxsb2NfY29o
ZXJlbnQoJnBkZXYtPmRldiwNCj4gKwkJCQlNQVhfQkRfTlVNICogc2l6ZW9mKHN0cnVjdA0KPiBt
dF9iZG1hX2Rlc2MpLA0KPiArCQkJCSZob3N0LT5kbWEuYmRfYWRkciwgR0ZQX0tFUk5FTCk7DQo+
ICsJaWYgKCFob3N0LT5kbWEuZ3BkIHx8ICFob3N0LT5kbWEuYmQpIHsNCj4gKwkJcmV0ID0gLUVO
T01FTTsNCj4gKwkJZ290byByZWxlYXNlX21lbTsNCj4gKwl9DQo+ICsJbXNkY19pbml0X2dwZF9i
ZChob3N0LCAmaG9zdC0+ZG1hKTsNCj4gKwlJTklUX0RFTEFZRURfV09SSygmaG9zdC0+cmVxX3Rp
bWVvdXQsIG1zZGNfcmVxdWVzdF90aW1lb3V0KTsNCj4gKwlzcGluX2xvY2tfaW5pdCgmaG9zdC0+
bG9jayk7DQo+ICsNCj4gKwlwbGF0Zm9ybV9zZXRfZHJ2ZGF0YShwZGV2LCBtbWMpOw0KPiArCW1z
ZGNfdW5nYXRlX2Nsb2NrKGhvc3QpOw0KPiArCW1zZGNfaW5pdF9odyhob3N0KTsNCj4gKw0KPiAg
CWlmIChtbWMtPmNhcHMyICYgTU1DX0NBUDJfQ1FFKSB7DQo+ICAJCWhvc3QtPmNxX2hvc3QgPSBk
ZXZtX2t6YWxsb2MobW1jLT5wYXJlbnQsDQo+ICAJCQkJCSAgICAgc2l6ZW9mKCpob3N0LT5jcV9o
b3N0KSwNCj4gQEAgLTI2NzYsMjUgKzI2OTUsNiBAQCBzdGF0aWMgaW50IG1zZGNfZHJ2X3Byb2Jl
KHN0cnVjdA0KPiBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ICAJCW1tYy0+bWF4X3NlZ19zaXpl
ID0gNjQgKiAxMDI0Ow0KPiAgCX0NCj4gIA0KPiAtCWhvc3QtPnRpbWVvdXRfY2xrcyA9IDMgKiAx
MDQ4NTc2Ow0KPiAtCWhvc3QtPmRtYS5ncGQgPSBkbWFfYWxsb2NfY29oZXJlbnQoJnBkZXYtPmRl
diwNCj4gLQkJCQkyICogc2l6ZW9mKHN0cnVjdCBtdF9ncGRtYV9kZXNjKSwNCj4gLQkJCQkmaG9z
dC0+ZG1hLmdwZF9hZGRyLCBHRlBfS0VSTkVMKTsNCj4gLQlob3N0LT5kbWEuYmQgPSBkbWFfYWxs
b2NfY29oZXJlbnQoJnBkZXYtPmRldiwNCj4gLQkJCQlNQVhfQkRfTlVNICogc2l6ZW9mKHN0cnVj
dA0KPiBtdF9iZG1hX2Rlc2MpLA0KPiAtCQkJCSZob3N0LT5kbWEuYmRfYWRkciwgR0ZQX0tFUk5F
TCk7DQo+IC0JaWYgKCFob3N0LT5kbWEuZ3BkIHx8ICFob3N0LT5kbWEuYmQpIHsNCj4gLQkJcmV0
ID0gLUVOT01FTTsNCj4gLQkJZ290byByZWxlYXNlX21lbTsNCj4gLQl9DQo+IC0JbXNkY19pbml0
X2dwZF9iZChob3N0LCAmaG9zdC0+ZG1hKTsNCj4gLQlJTklUX0RFTEFZRURfV09SSygmaG9zdC0+
cmVxX3RpbWVvdXQsIG1zZGNfcmVxdWVzdF90aW1lb3V0KTsNCj4gLQlzcGluX2xvY2tfaW5pdCgm
aG9zdC0+bG9jayk7DQo+IC0NCj4gLQlwbGF0Zm9ybV9zZXRfZHJ2ZGF0YShwZGV2LCBtbWMpOw0K
PiAtCW1zZGNfdW5nYXRlX2Nsb2NrKGhvc3QpOw0KPiAtCW1zZGNfaW5pdF9odyhob3N0KTsNCj4g
LQ0KPiAgCXJldCA9IGRldm1fcmVxdWVzdF9pcnEoJnBkZXYtPmRldiwgaG9zdC0+aXJxLCBtc2Rj
X2lycSwNCj4gIAkJCSAgICAgICBJUlFGX1RSSUdHRVJfTk9ORSwgcGRldi0+bmFtZSwgaG9zdCk7
DQo+ICAJaWYgKHJldCkNCg==

