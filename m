Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E63AE16BF47
	for <lists+stable@lfdr.de>; Tue, 25 Feb 2020 12:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbgBYLHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Feb 2020 06:07:44 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:33669 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729034AbgBYLHn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Feb 2020 06:07:43 -0500
X-UUID: 27556acbd761478096be470492a74c69-20200225
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=NIVA4F3l7yQpEwqBqiJgTY82QKy3hO5czh6wpcjlijk=;
        b=Ipz4bO+D3YZ9Y9KXCCPN+lEr4fmGYyzfYDpyIEMemegZZoCB71iSkjODWd04jRlkz6ssb/WsobqN8qZ3hgvHrs5XRU022KA0ciirYZz68kmqxRd2euDvEGEu7KXMgW+/sYnCraC93eFjoGE8RdDJ92ZekTE1Eu+8gPnXy2j6g+g=;
X-UUID: 27556acbd761478096be470492a74c69-20200225
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <miles.chen@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1274444266; Tue, 25 Feb 2020 19:07:38 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 25 Feb 2020 19:03:29 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 25 Feb 2020 19:07:22 +0800
Message-ID: <1582628855.31160.3.camel@mtkswgap22>
Subject: Re: [PATCH v3] usb: gadget: f_fs: try to fix AIO issue under ARM 64
 bit TAGGED mode
From:   Miles Chen <miles.chen@mediatek.com>
To:     Macpaul Lin <macpaul.lin@mediatek.com>
CC:     Matthias Brugger <matthias.bgg@gmail.com>,
        Shen Jing <jingx.shen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Vincent Pelletier <plr.vincent@gmail.com>,
        Jerry Zhang <zhangjerry@google.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        CC Hwang <cc.hwang@mediatek.com>,
        Loda Chou <loda.chou@mediatek.com>,
        Al Viro <viro@zeniv.linux.org.uk>, <stable@vger.kernel.org>
Date:   Tue, 25 Feb 2020 19:07:35 +0800
In-Reply-To: <1582627315-21123-1-git-send-email-macpaul.lin@mediatek.com>
References: <1582472947-22471-1-git-send-email-macpaul.lin@mediatek.com>
         <1582627315-21123-1-git-send-email-macpaul.lin@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 4C2CF332432AB414CFC0F2323587578A8A6BD2A698FE908B77F606313F3EF5E22000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCAyMDIwLTAyLTI1IGF0IDE4OjQxICswODAwLCBNYWNwYXVsIExpbiB3cm90ZToNCj4g
VGhpcyBpc3N1ZSB3YXMgZm91bmQgd2hlbiBhZGJkIHRyeWluZyB0byBvcGVuIGZ1bmN0aW9uZnMg
d2l0aCBBSU8gbW9kZS4NCj4gVXN1YWxseSwgd2UgbmVlZCB0byBzZXQgInNldHByb3Agc3lzLnVz
Yi5mZnMuYWlvX2NvbXBhdCAwIiB0byBlbmFibGUNCj4gYWRiZCB3aXRoIEFJTyBtb2RlIG9uIEFu
ZHJvaWQuDQo+IA0KPiBXaGVuIGFkYmQgaXMgb3BlbmluZyBmdW5jdGlvbmZzLCBpdCB3aWxsIHRy
eSB0byByZWFkIDI0IGJ5dGVzIGF0IHRoZQ0KPiBmaXJzdCByZWFkIEkvTyBjb250cm9sLiBJZiB0
aGlzIHJlYWRpbmcgaGFzIGJlZW4gZmFpbGVkLCBhZGJkIHdpbGwNCj4gdHJ5IHRvIHNlbmQgRlVO
Q1RJT05GU19DTEVBUl9IQUxUIHRvIGZ1bmN0aW9uZnMuIFdoZW4gYWRiZCBpcyBpbiBBSU8NCj4g
bW9kZSwgZnVuY3Rpb25mcyB3aWxsIGJlIGFjdGVkIHdpdGggYXN5bmNyb25pemVkIEkvTyBwYXRo
LiBBZnRlciB0aGUNCj4gc3VjY2Vzc2Z1bCByZWFkIHRyYW5zZmVyIGhhcyBiZWVuIGNvbXBsZXRl
ZCBieSBnYWRnZXQgaGFyZHdhcmUsIHRoZQ0KPiBmb2xsb3dpbmcgc2VyaWVzIG9mIGZ1bmN0aW9u
cyB3aWxsIGJlIGNhbGxlZC4NCj4gICBmZnNfZXBmaWxlX2FzeW5jX2lvX2NvbXBsZXRlKCkgLT4g
ZmZzX3VzZXJfY29weV93b3JrZXIoKSAtPg0KPiAgICAgY29weV90b19pdGVyKCkgLT4gX2NvcHlf
dG9faXRlcigpIC0+IGNvcHlvdXQoKSAtPg0KPiAgICAgaXRlcmF0ZV9hbmRfYWR2YW5jZSgpIC0+
IGl0ZXJhdGVfaW92ZWMoKQ0KPiANCj4gQWRkaW5nIGRlYnVnIHRyYWNlIHRvIHRoZXNlIGZ1bmN0
aW9ucywgaXQgaGFzIGJlZW4gZm91bmQgdGhhdCBpbg0KPiBjb3B5b3V0KCksIGFjY2Vzc19vaygp
IHdpbGwgY2hlY2sgaWYgdGhlIHVzZXIgc3BhY2UgYWRkcmVzcyBpcyB2YWxpZA0KPiB0byB3cml0
ZS4gSG93ZXZlciBpZiBDT05GSUdfQVJNNjRfVEFHR0VEX0FERFJfQUJJIGlzIGVuYWJsZWQsIGFk
YmQNCj4gYWx3YXlzIHBhc3NlcyB1c2VyIHNwYWNlIGFkZHJlc3Mgc3RhcnQgd2l0aCAiMHgzQyIg
dG8gZ2FkZ2V0J3MgQUlPDQo+IGJsb2Nrcy4gVGhpcyB0YWdnZWQgYWRkcmVzcyB3aWxsIGNhdXNl
IGFjY2Vzc19vaygpIGNoZWNrIGFsd2F5cyBmYWlsLg0KPiBXaGljaCBjYXVzZXMgbGF0ZXIgY2Fs
Y3VsYXRpb24gaW4gaXRlcmF0ZV9pb3ZlYygpIHR1cm4gemVyby4NCj4gQ29weW91dCgpIHdvbid0
IGNvcHkgZGF0YSB0byB1c2Vyc3BhY2Ugc2luY2UgdGhlIGxlbmd0aCB0byBiZSBjb3BpZWQNCj4g
InYuaW92X2xlbiIgd2lsbCBiZSB6ZXJvLiBGaW5hbGx5IGxlYWRzIGZmc19jb3B5X3RvX2l0ZXIo
KSBhbHdheXMgcmV0dXJuDQo+IC1FRkFVTFQsIGNhdXNlcyBhZGJkIGNhbm5vdCBvcGVuIGZ1bmN0
aW9uZnMgYW5kIHNlbmQNCj4gRlVOQ1RJT05GU19DTEVBUl9IQUxULg0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogTWFjcGF1bCBMaW4gPG1hY3BhdWwubGluQG1lZGlhdGVrLmNvbT4NCj4gLS0tDQo+IENo
YW5nZXMgZm9yIHYzOg0KPiAgIC0gRml4IG1pc3NwZWxsaW5nIGluIGNvbW1pdCBtZXNzYWdlLg0K
DQpDb3VsZCB5b3Ugc2F5ICJ0aGFuayB5b3UiIHRvIFBldGVyIGZvciBoaXMgY29tbWVudCBhbmQg
YWRkIA0KIkNjOiBQZXRlciBDaGVuIDxwZXRlci5jaGVuQG54cC5jb20+IiB0byB0aGlzIHBhdGNo
LCBwbGVhc2U/DQoNCj4gDQo+IENoYW5nZXMgZm9yIHYyOg0KPiAgIC0gRml4IGJ1aWxkIGVycm9y
IGZvciAzMi1iaXQgbG9hZC4gQW4gI2lmIGRlZmluZWQoQ09ORklHX0FSTTY0KSBzdGlsbCBuZWVk
DQo+ICAgICBmb3IgYXZvaWRpbmcgdW5kZWNsYXJlZCBkZWZpbmVzLg0KPiANCj4gIGRyaXZlcnMv
dXNiL2dhZGdldC9mdW5jdGlvbi9mX2ZzLmMgfCAgICA1ICsrKysrDQo+ICAxIGZpbGUgY2hhbmdl
ZCwgNSBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvZ2FkZ2V0
L2Z1bmN0aW9uL2ZfZnMuYyBiL2RyaXZlcnMvdXNiL2dhZGdldC9mdW5jdGlvbi9mX2ZzLmMNCj4g
aW5kZXggY2UxZDAyMy4uNzI4YzI2MCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy91c2IvZ2FkZ2V0
L2Z1bmN0aW9uL2ZfZnMuYw0KPiArKysgYi9kcml2ZXJzL3VzYi9nYWRnZXQvZnVuY3Rpb24vZl9m
cy5jDQo+IEBAIC0zNSw2ICszNSw3IEBADQo+ICAjaW5jbHVkZSA8bGludXgvbW11X2NvbnRleHQu
aD4NCj4gICNpbmNsdWRlIDxsaW51eC9wb2xsLmg+DQo+ICAjaW5jbHVkZSA8bGludXgvZXZlbnRm
ZC5oPg0KPiArI2luY2x1ZGUgPGxpbnV4L3RocmVhZF9pbmZvLmg+DQo+ICANCj4gICNpbmNsdWRl
ICJ1X2ZzLmgiDQo+ICAjaW5jbHVkZSAidV9mLmgiDQo+IEBAIC04MjYsNiArODI3LDEwIEBAIHN0
YXRpYyB2b2lkIGZmc191c2VyX2NvcHlfd29ya2VyKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykN
Cj4gIAlpZiAoaW9fZGF0YS0+cmVhZCAmJiByZXQgPiAwKSB7DQo+ICAJCW1tX3NlZ21lbnRfdCBv
bGRmcyA9IGdldF9mcygpOw0KPiAgDQo+ICsjaWYgZGVmaW5lZChDT05GSUdfQVJNNjQpDQo+ICsJ
CWlmIChJU19FTkFCTEVEKENPTkZJR19BUk02NF9UQUdHRURfQUREUl9BQkkpKQ0KPiArCQkJc2V0
X3RocmVhZF9mbGFnKFRJRl9UQUdHRURfQUREUik7DQo+ICsjZW5kaWYNCj4gIAkJc2V0X2ZzKFVT
RVJfRFMpOw0KPiAgCQl1c2VfbW0oaW9fZGF0YS0+bW0pOw0KPiAgCQlyZXQgPSBmZnNfY29weV90
b19pdGVyKGlvX2RhdGEtPmJ1ZiwgcmV0LCAmaW9fZGF0YS0+ZGF0YSk7DQoNCg==

