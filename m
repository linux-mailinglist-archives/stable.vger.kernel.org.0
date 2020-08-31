Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4BA02571AC
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 03:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgHaBwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Aug 2020 21:52:39 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:16438 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726454AbgHaBwi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Aug 2020 21:52:38 -0400
X-UUID: 11d7f1acc5b24e608d751e86be8500cd-20200831
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=CKPJOw9Pxq9nUroeTbwTwZKLGO0Crpt83e3+Rzmhnfc=;
        b=rckeqeT9blEUI8eczTUNnmz0uwebwQSnwayquCCYbLbjNdLo6sYcKCRR2T8yDXgkCNnLRDR0q/GXYstyk4s870/xRSPEYl8UYmKhQ3/GOSlmIZb6aW3PxW5bOTbUsWjHrYQudzfJvWFyhN/GyPgliS1UjS5xlQ22crvSCLrpLhs=;
X-UUID: 11d7f1acc5b24e608d751e86be8500cd-20200831
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1758976509; Mon, 31 Aug 2020 09:52:31 +0800
Received: from MTKCAS32.mediatek.inc (172.27.4.184) by mtkmbs08n2.mediatek.inc
 (172.21.101.56) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 31 Aug
 2020 09:52:29 +0800
Received: from [10.17.3.153] (10.17.3.153) by MTKCAS32.mediatek.inc
 (172.27.4.170) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 31 Aug 2020 09:52:29 +0800
Message-ID: <1598838655.7054.11.camel@mhfsdcap03>
Subject: Re: [PATCH v4] usb: mtu3: fix panic in mtu3_gadget_stop()
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Macpaul Lin <macpaul.lin@mediatek.com>
CC:     Alan Stern <stern@rowland.harvard.edu>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Ainge Hsu <ainge.hsu@mediatek.com>,
        Eddie Hung <eddie.hung@mediatek.com>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@gmail.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Date:   Mon, 31 Aug 2020 09:50:55 +0800
In-Reply-To: <1598539328-1976-1-git-send-email-macpaul.lin@mediatek.com>
References: <1598520178-17301-1-git-send-email-macpaul.lin@mediatek.com>
         <1598539328-1976-1-git-send-email-macpaul.lin@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 77E100386F2C0ABE68A90833F81AA8EAAAE55A04FA2870F70C909006F70608A82000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDIwLTA4LTI3IGF0IDIyOjQyICswODAwLCBNYWNwYXVsIExpbiB3cm90ZToNCj4g
VGhpcyBwYXRjaCBmaXhlcyBhIHBvc3NpYmxlIGlzc3VlIHdoZW4gbXR1M19nYWRnZXRfc3RvcCgp
DQo+IGFscmVhZHkgYXNzaWduZWQgTlVMTCB0byBtdHUtPmdhZGdldF9kcml2ZXIgZHVyaW5nIG10
dV9nYWRnZXRfZGlzY29ubmVjdCgpLg0KPiANCj4gWzxmZmZmZmY5MDA4MTYxOTc0Pl0gbm90aWZp
ZXJfY2FsbF9jaGFpbisweGE0LzB4MTI4DQo+IFs8ZmZmZmZmOTAwODE2MWZkND5dIF9fYXRvbWlj
X25vdGlmaWVyX2NhbGxfY2hhaW4rMHg4NC8weDEzOA0KPiBbPGZmZmZmZjkwMDgxNjJlYzA+XSBu
b3RpZnlfZGllKzB4YjAvMHgxMjANCj4gWzxmZmZmZmY5MDA4MDllMzQwPl0gZGllKzB4MWY4LzB4
NWQwDQo+IFs8ZmZmZmZmOTAwODBkMDNiND5dIF9fZG9fa2VybmVsX2ZhdWx0KzB4MTljLzB4Mjgw
DQo+IFs8ZmZmZmZmOTAwODBkMDRkYz5dIGRvX2JhZF9hcmVhKzB4NDQvMHgxNDANCj4gWzxmZmZm
ZmY5MDA4MGQwZjljPl0gZG9fdHJhbnNsYXRpb25fZmF1bHQrMHg0Yy8weDkwDQo+IFs8ZmZmZmZm
OTAwODA4MGE3OD5dIGRvX21lbV9hYm9ydCsweGI4LzB4MjU4DQo+IFs8ZmZmZmZmOTAwODA4NDlk
MD5dIGVsMV9kYSsweDI0LzB4M2MNCj4gWzxmZmZmZmY5MDA5YmRlMDFjPl0gbXR1M19nYWRnZXRf
ZGlzY29ubmVjdCsweGFjLzB4MTI4DQo+IFs8ZmZmZmZmOTAwOWJkNTc2Yz5dIG10dTNfaXJxKzB4
MzRjLzB4YzE4DQo+IFs8ZmZmZmZmOTAwODJhYzAzYz5dIF9faGFuZGxlX2lycV9ldmVudF9wZXJj
cHUrMHgyYWMvMHhjZDANCj4gWzxmZmZmZmY5MDA4MmFjYWUwPl0gaGFuZGxlX2lycV9ldmVudF9w
ZXJjcHUrMHg4MC8weDEzOA0KPiBbPGZmZmZmZjkwMDgyYWNjNDQ+XSBoYW5kbGVfaXJxX2V2ZW50
KzB4YWMvMHgxNDgNCj4gWzxmZmZmZmY5MDA4MmI3MWNjPl0gaGFuZGxlX2Zhc3Rlb2lfaXJxKzB4
MjM0LzB4NTY4DQo+IFs8ZmZmZmZmOTAwODJhODcwOD5dIGdlbmVyaWNfaGFuZGxlX2lycSsweDQ4
LzB4NjgNCj4gWzxmZmZmZmY5MDA4MmE5NmFjPl0gX19oYW5kbGVfZG9tYWluX2lycSsweDI2NC8w
eDE3NDANCj4gWzxmZmZmZmY5MDA4MDgxOWY0Pl0gZ2ljX2hhbmRsZV9pcnErMHgxNGMvMHgyNTAN
Cj4gWzxmZmZmZmY5MDA4MDg0Y2VjPl0gZWwxX2lycSsweGVjLzB4MTk0DQo+IFs8ZmZmZmZmOTAw
ODViOTg1Yz5dIGRtYV9wb29sX2FsbG9jKzB4NmU0LzB4YWUwDQo+IFs8ZmZmZmZmOTAwOGQ3Zjg5
MD5dIGNtZHFfbWJveF9wb29sX2FsbG9jX2ltcGwrMHhiMC8weDIzOA0KPiBbPGZmZmZmZjkwMDhk
ODA5MDQ+XSBjbWRxX3BrdF9hbGxvY19idWYrMHgyZGMvMHg3YzANCj4gWzxmZmZmZmY5MDA4ZDgw
ZjYwPl0gY21kcV9wa3RfYWRkX2NtZF9idWZmZXIrMHgxNzgvMHgyNzANCj4gWzxmZmZmZmY5MDA4
ZDgyMzIwPl0gY21kcV9wa3RfcGVyZl9iZWdpbisweDEwOC8weDE0OA0KPiBbPGZmZmZmZjkwMDhk
ODI0ZDg+XSBjbWRxX3BrdF9jcmVhdGUrMHgxNzgvMHgxZjANCj4gWzxmZmZmZmY5MDA4Zjk2MjMw
Pl0gbXRrX2NydGNfY29uZmlnX2RlZmF1bHRfcGF0aCsweDMyOC8weDdhMA0KPiBbPGZmZmZmZjkw
MDkwMjQ2Y2M+XSBtdGtfZHJtX2lkbGVtZ3Jfa2ljaysweGE2Yy8weDE0NjANCj4gWzxmZmZmZmY5
MDA4ZjliYmI0Pl0gbXRrX2RybV9jcnRjX2F0b21pY19iZWdpbisweDFhNC8weDFhNjgNCj4gWzxm
ZmZmZmY5MDA4ZThkZjljPl0gZHJtX2F0b21pY19oZWxwZXJfY29tbWl0X3BsYW5lcysweDE1NC8w
eDg3OA0KPiBbPGZmZmZmZjkwMDhmMmZiNzA+XSBtdGtfYXRvbWljX2NvbXBsZXRlLmlzcmEuMTYr
MHhlODAvMHgxOWM4DQo+IFs8ZmZmZmZmOTAwOGYzMDkxMD5dIG10a19hdG9taWNfY29tbWl0KzB4
MjU4LzB4ODk4DQo+IFs8ZmZmZmZmOTAwOGVmMTQyYz5dIGRybV9hdG9taWNfY29tbWl0KzB4Y2Mv
MHgxMDgNCj4gWzxmZmZmZmY5MDA4ZWY3Y2YwPl0gZHJtX21vZGVfYXRvbWljX2lvY3RsKzB4MWMy
MC8weDI1ODANCj4gWzxmZmZmZmY5MDA4ZWJjNzY4Pl0gZHJtX2lvY3RsX2tlcm5lbCsweDExOC8w
eDFiMA0KPiBbPGZmZmZmZjkwMDhlYmNkZTg+XSBkcm1faW9jdGwrMHg1YzAvMHg5MjANCj4gWzxm
ZmZmZmY5MDA4NjNiMDMwPl0gZG9fdmZzX2lvY3RsKzB4MTg4LzB4MTgyMA0KPiBbPGZmZmZmZjkw
MDg2M2M3NTQ+XSBTeVNfaW9jdGwrMHg4Yy8weGEwDQo+IA0KPiBGaXhlczogZGYyMDY5YWNiMDA1
ICgidXNiOiBBZGQgTWVkaWFUZWsgVVNCMyBEUkQgZHJpdmVyIikNCj4gU2lnbmVkLW9mZi1ieTog
TWFjcGF1bCBMaW4gPG1hY3BhdWwubGluQG1lZGlhdGVrLmNvbT4NCj4gQ2M6IHN0YWJsZUB2Z2Vy
Lmtlcm5lbC5vcmcNCj4gLS0tDQo+IENoYW5nZXMgZm9yIHY0Og0KPiAgIC0gQWRkIGEgIkZpeGVz
OiIgbGluZS4gIFRoYW5rcyBGZWxpcGUuDQo+IENoYW5nZXMgZm9yIHYzOg0KPiAgIC0gQ2FsbCBz
eW5jaHJvbml6ZV9pcnEoKSBpbiBtdHUzX2dhZGdldF9zdG9wKCkgaW5zdGVhZCBvZiByZW1lbWJl
cmluZw0KPiAgICAgY2FsbGJhY2sgZnVuY3Rpb24gaW4gbXR1M19nYWRnZXRfZGlzY29ubmVjdCgp
Lg0KPiAgICAgVGhhbmtzIGZvciBBbGFuJ3Mgc3VnZ2VzdGlvbi4NCj4gQ2hhbmdlcyBmb3IgdjI6
DQo+ICAgLSBDaGVjayBtdHVfZ2FkZ2V0X2RyaXZlciBvdXQgb2Ygc3Bpbl9sb2NrIG1pZ2h0IHN0
aWxsIG5vdCB3b3JrLg0KPiAgICAgV2UgdXNlIGEgdGVtcG9yYXJ5IHBvaW50ZXIgdG8gcmVtZW1i
ZXIgdGhlIGNhbGxiYWNrIGZ1bmN0aW9uLg0KPiANCj4gIGRyaXZlcnMvdXNiL210dTMvbXR1M19n
YWRnZXQuYyB8ICAgIDEgKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9ucygrKQ0KPiAN
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL210dTMvbXR1M19nYWRnZXQuYyBiL2RyaXZlcnMv
dXNiL210dTMvbXR1M19nYWRnZXQuYw0KPiBpbmRleCAxZGU1YzlhLi4xYWIzZDNhIDEwMDY0NA0K
PiAtLS0gYS9kcml2ZXJzL3VzYi9tdHUzL210dTNfZ2FkZ2V0LmMNCj4gKysrIGIvZHJpdmVycy91
c2IvbXR1My9tdHUzX2dhZGdldC5jDQo+IEBAIC01NjQsNiArNTY0LDcgQEAgc3RhdGljIGludCBt
dHUzX2dhZGdldF9zdG9wKHN0cnVjdCB1c2JfZ2FkZ2V0ICpnKQ0KPiAgDQo+ICAJc3Bpbl91bmxv
Y2tfaXJxcmVzdG9yZSgmbXR1LT5sb2NrLCBmbGFncyk7DQo+ICANCj4gKwlzeW5jaHJvbml6ZV9p
cnEobXR1LT5pcnEpOw0KPiAgCXJldHVybiAwOw0KPiAgfQ0KPiAgDQpBY2tlZC1ieTogQ2h1bmZl
bmcgWXVuIDxjaHVuZmVuZy55dW5AbWVkaWF0ZWsuY29tPg0KDQpUaGFua3MgYSBsb3QNCg0KDQoN
Cg==

