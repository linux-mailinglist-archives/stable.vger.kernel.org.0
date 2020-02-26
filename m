Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 694C516FE92
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 13:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgBZMCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 07:02:15 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:6851 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726272AbgBZMCP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Feb 2020 07:02:15 -0500
X-UUID: 618771a74bec4bba8d11e5bc7ea6f553-20200226
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=HeqaTDjIL0PTx6tfNZRsJGOB5wSUUqHsQNV/Ncz2fJc=;
        b=ENbT1nfHLPmaa1KnVt+jRf/tknKxc2p2KiK+s6CU1rwJAp+Lk3CSRMzwDpCHeadWl1fqHuy8hhUWvULtNVcLJGPLWkNfldClAau63AQr7JW2Wod7LrFdac8b6i7YmPCYva695mdKqQLe76+fThWjqwBTnhRst8AF2MHGbGBUrjI=;
X-UUID: 618771a74bec4bba8d11e5bc7ea6f553-20200226
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 804146539; Wed, 26 Feb 2020 20:02:07 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 26 Feb 2020 19:57:57 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 26 Feb 2020 20:01:57 +0800
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     Matthias Brugger <matthias.bgg@gmail.com>,
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
        Al Viro <viro@zeniv.linux.org.uk>, <stable@vger.kernel.org>,
        <andreyknvl@google.com>
CC:     Macpaul Lin <macpaul.lin@mediatek.com>,
        Peter Chen <peter.chen@nxp.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Miles Chen <miles.chen@mediatek.com>
Subject: [PATCH v4] usb: gadget: f_fs: try to fix AIO issue under ARM 64 bit TAGGED mode
Date:   Wed, 26 Feb 2020 20:01:52 +0800
Message-ID: <1582718512-28923-1-git-send-email-macpaul.lin@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1582627315-21123-1-git-send-email-macpaul.lin@mediatek.com>
References: <1582627315-21123-1-git-send-email-macpaul.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 272F8CE54AD6E67D73DACACA69671537612B9D56AD5648D8354972DCC44EFC2F2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VGhpcyBpc3N1ZSB3YXMgZm91bmQgd2hlbiBhZGJkIHRyeWluZyB0byBvcGVuIGZ1bmN0aW9uZnMg
d2l0aCBBSU8gbW9kZS4NClVzdWFsbHksIHdlIG5lZWQgdG8gc2V0ICJzZXRwcm9wIHN5cy51c2Iu
ZmZzLmFpb19jb21wYXQgMCIgdG8gZW5hYmxlDQphZGJkIHdpdGggQUlPIG1vZGUgb24gQW5kcm9p
ZC4NCg0KV2hlbiBhZGJkIGlzIG9wZW5pbmcgZnVuY3Rpb25mcywgaXQgd2lsbCB0cnkgdG8gcmVh
ZCAyNCBieXRlcyBhdCB0aGUNCmZpcnN0IHJlYWQgSS9PIGNvbnRyb2wuIElmIHRoaXMgcmVhZGlu
ZyBoYXMgYmVlbiBmYWlsZWQsIGFkYmQgd2lsbA0KdHJ5IHRvIHNlbmQgRlVOQ1RJT05GU19DTEVB
Ul9IQUxUIHRvIGZ1bmN0aW9uZnMuIFdoZW4gYWRiZCBpcyBpbiBBSU8NCm1vZGUsIGZ1bmN0aW9u
ZnMgd2lsbCBiZSBhY3RlZCB3aXRoIGFzeW5jcm9uaXplZCBJL08gcGF0aC4gQWZ0ZXIgdGhlDQpz
dWNjZXNzZnVsIHJlYWQgdHJhbnNmZXIgaGFzIGJlZW4gY29tcGxldGVkIGJ5IGdhZGdldCBoYXJk
d2FyZSwgdGhlDQpmb2xsb3dpbmcgc2VyaWVzIG9mIGZ1bmN0aW9ucyB3aWxsIGJlIGNhbGxlZC4N
CiAgZmZzX2VwZmlsZV9hc3luY19pb19jb21wbGV0ZSgpIC0+IGZmc191c2VyX2NvcHlfd29ya2Vy
KCkgLT4NCiAgICBjb3B5X3RvX2l0ZXIoKSAtPiBfY29weV90b19pdGVyKCkgLT4gY29weW91dCgp
IC0+DQogICAgaXRlcmF0ZV9hbmRfYWR2YW5jZSgpIC0+IGl0ZXJhdGVfaW92ZWMoKQ0KDQpBZGRp
bmcgZGVidWcgdHJhY2UgdG8gdGhlc2UgZnVuY3Rpb25zLCBpdCBoYXMgYmVlbiBmb3VuZCB0aGF0
IGluDQpjb3B5b3V0KCksIGFjY2Vzc19vaygpIHdpbGwgY2hlY2sgaWYgdGhlIHVzZXIgc3BhY2Ug
YWRkcmVzcyBpcyB2YWxpZA0KdG8gd3JpdGUuIEhvd2V2ZXIgaWYgQ09ORklHX0FSTTY0X1RBR0dF
RF9BRERSX0FCSSBpcyBlbmFibGVkLCBhZGJkDQphbHdheXMgcGFzc2VzIHVzZXIgc3BhY2UgYWRk
cmVzcyBzdGFydCB3aXRoICIweDNDIiB0byBnYWRnZXQncyBBSU8NCmJsb2Nrcy4gVGhpcyB0YWdn
ZWQgYWRkcmVzcyB3aWxsIGNhdXNlIGFjY2Vzc19vaygpIGNoZWNrIGFsd2F5cyBmYWlsLg0KV2hp
Y2ggY2F1c2VzIGxhdGVyIGNhbGN1bGF0aW9uIGluIGl0ZXJhdGVfaW92ZWMoKSB0dXJuIHplcm8u
DQpDb3B5b3V0KCkgd29uJ3QgY29weSBkYXRhIHRvIHVzZXIgc3BhY2Ugc2luY2UgdGhlIGxlbmd0
aCB0byBiZSBjb3BpZWQNCiJ2Lmlvdl9sZW4iIHdpbGwgYmUgemVyby4gRmluYWxseSBsZWFkcyBm
ZnNfY29weV90b19pdGVyKCkgYWx3YXlzIHJldHVybg0KLUVGQVVMVCwgY2F1c2VzIGFkYmQgY2Fu
bm90IG9wZW4gZnVuY3Rpb25mcyBhbmQgc2VuZA0KRlVOQ1RJT05GU19DTEVBUl9IQUxULg0KDQpT
aWduZWQtb2ZmLWJ5OiBNYWNwYXVsIExpbiA8bWFjcGF1bC5saW5AbWVkaWF0ZWsuY29tPg0KQ2M6
IFBldGVyIENoZW4gPHBldGVyLmNoZW5AbnhwLmNvbT4NCkNjOiBDYXRhbGluIE1hcmluYXMgPGNh
dGFsaW4ubWFyaW5hc0Bhcm0uY29tPg0KQ2M6IE1pbGVzIENoZW4gPG1pbGVzLmNoZW5AbWVkaWF0
ZWsuY29tPg0KLS0tDQpDaGFuZ2VzIGZvciB2NDoNCiAgLSBBYmFuZG9uIHNvbHV0aW9uIHYzIGJ5
IGFkZGluZyAiVElGX1RBR0dFRF9BRERSIiBmbGFnIHRvIGdhZGdldCBkcml2ZXIuDQogICAgQWNj
b3JkaW5nIHRvIENhdGFsaW4ncyBzdWdnZXN0aW9uLCBjaGFuZ2UgdGhlIHNvbHV0aW9uIGJ5IHVu
dGFnZ2luZyANCiAgICB1c2VyIHNwYWNlIGFkZHJlc3MgcGFzc2VkIGJ5IEFJTyBpbiBnYWRnZXQg
ZHJpdmVyLg0KDQpDaGFuZ2VzIGZvciB2MzoNCiAgLSBGaXggbWlzc3BlbGxpbmcgaW4gY29tbWl0
IG1lc3NhZ2UuDQogICAgVGhhbmtzIGZvciBQZXRlcidzIHJldmlldy4NCg0KQ2hhbmdlcyBmb3Ig
djI6DQogIC0gRml4IGJ1aWxkIGVycm9yIGZvciAzMi1iaXQgbG9hZC4gQW4gI2lmIGRlZmluZWQo
Q09ORklHX0FSTTY0KSBzdGlsbCBuZWVkDQogICAgZm9yIGF2b2lkaW5nIHVuZGVjbGFyZWQgZGVm
aW5lcy4NCg0KIGRyaXZlcnMvdXNiL2dhZGdldC9mdW5jdGlvbi9mX2ZzLmMgfCAgIDE1ICsrKysr
KysrKysrKysrLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9u
KC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9nYWRnZXQvZnVuY3Rpb24vZl9mcy5jIGIv
ZHJpdmVycy91c2IvZ2FkZ2V0L2Z1bmN0aW9uL2ZfZnMuYw0KaW5kZXggY2UxZDAyMy4uMTkyOTM1
ZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL2dhZGdldC9mdW5jdGlvbi9mX2ZzLmMNCisrKyBi
L2RyaXZlcnMvdXNiL2dhZGdldC9mdW5jdGlvbi9mX2ZzLmMNCkBAIC03MTUsNyArNzE1LDIwIEBA
IHN0YXRpYyB2b2lkIGZmc19lcGZpbGVfaW9fY29tcGxldGUoc3RydWN0IHVzYl9lcCAqX2VwLCBz
dHJ1Y3QgdXNiX3JlcXVlc3QgKnJlcSkNCiANCiBzdGF0aWMgc3NpemVfdCBmZnNfY29weV90b19p
dGVyKHZvaWQgKmRhdGEsIGludCBkYXRhX2xlbiwgc3RydWN0IGlvdl9pdGVyICppdGVyKQ0KIHsN
Ci0Jc3NpemVfdCByZXQgPSBjb3B5X3RvX2l0ZXIoZGF0YSwgZGF0YV9sZW4sIGl0ZXIpOw0KKwlz
c2l6ZV90IHJldDsNCisNCisjaWYgZGVmaW5lZChDT05GSUdfQVJNNjQpDQorCS8qDQorCSAqIFJl
cGxhY2UgdGFnZ2VkIGFkZHJlc3MgcGFzc2VkIGJ5IHVzZXIgc3BhY2UgYXBwbGljYXRpb24gYmVm
b3JlDQorCSAqIGNvcHlpbmcuDQorCSAqLw0KKwlpZiAoSVNfRU5BQkxFRChDT05GSUdfQVJNNjRf
VEFHR0VEX0FERFJfQUJJKSAmJg0KKwkJKGl0ZXItPnR5cGUgPT0gSVRFUl9JT1ZFQykpIHsNCisJ
CSoodW5zaWduZWQgbG9uZyAqKSZpdGVyLT5pb3YtPmlvdl9iYXNlID0NCisJCQkodW5zaWduZWQg
bG9uZyl1bnRhZ2dlZF9hZGRyKGl0ZXItPmlvdi0+aW92X2Jhc2UpOw0KKwl9DQorI2VuZGlmDQor
CXJldCA9IGNvcHlfdG9faXRlcihkYXRhLCBkYXRhX2xlbiwgaXRlcik7DQogCWlmIChsaWtlbHko
cmV0ID09IGRhdGFfbGVuKSkNCiAJCXJldHVybiByZXQ7DQogDQotLSANCjEuNy45LjUNCg==

