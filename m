Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 172B5174AE1
	for <lists+stable@lfdr.de>; Sun,  1 Mar 2020 04:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbgCADUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 22:20:55 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:32827 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727242AbgCADUz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Feb 2020 22:20:55 -0500
X-UUID: 7b3ded5a30884d9988efa18b6d36d784-20200301
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=gEuqpc3FvuW2EqLSsfehY0NEfaRH3CHq60ZO1Tz8Ll0=;
        b=STzk469ZSYIlP+pyoY3x8u2RtXO3oALFryqCMlRvwlrneR+vRfK8B8+UM8WWTP31kB8WpTx/lgqqJgNm/GBDiJvFyxzO7d+SYYz/tjoIbUQ0DC8D4WSgLGdsaKJ2LWnUUHf07/O/IyQyVbBodXs7HS+FXVyaRXxYgyHx5Ww7aeI=;
X-UUID: 7b3ded5a30884d9988efa18b6d36d784-20200301
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 725150250; Sun, 01 Mar 2020 11:20:45 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sun, 1 Mar 2020 11:22:18 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sun, 1 Mar 2020 11:20:18 +0800
Message-ID: <1583032843.12083.24.camel@mtkswgap22>
Subject: Re: [PATCH v4] usb: gadget: f_fs: try to fix AIO issue under ARM 64
 bit TAGGED mode
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     Catalin Marinas <catalin.marinas@arm.com>
CC:     Sasha Levin <sashal@kernel.org>, Shen Jing <jingx.shen@intel.com>,
        "CC Hwang" <cc.hwang@mediatek.com>,
        Peter Chen <peter.chen@nxp.com>,
        "Mediatek WSD Upstream" <wsd_upstream@mediatek.com>,
        Jerry Zhang <zhangjerry@google.com>, <andreyknvl@google.com>,
        <linux-usb@vger.kernel.org>, Loda Chou <loda.chou@mediatek.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Miles Chen <miles.chen@mediatek.com>, <eugenis@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Vincent Pelletier" <plr.vincent@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>
Date:   Sun, 1 Mar 2020 11:20:43 +0800
In-Reply-To: <20200228164848.GH4019108@arrakis.emea.arm.com>
References: <1582627315-21123-1-git-send-email-macpaul.lin@mediatek.com>
         <1582718512-28923-1-git-send-email-macpaul.lin@mediatek.com>
         <20200228164848.GH4019108@arrakis.emea.arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gRnJpLCAyMDIwLTAyLTI4IGF0IDE2OjQ4ICswMDAwLCBDYXRhbGluIE1hcmluYXMgd3JvdGU6
DQo+IE9uIFdlZCwgRmViIDI2LCAyMDIwIGF0IDA4OjAxOjUyUE0gKzA4MDAsIE1hY3BhdWwgTGlu
IHdyb3RlOg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9nYWRnZXQvZnVuY3Rpb24vZl9m
cy5jIGIvZHJpdmVycy91c2IvZ2FkZ2V0L2Z1bmN0aW9uL2ZfZnMuYw0KPiA+IGluZGV4IGNlMWQw
MjMuLjE5MjkzNWYgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy91c2IvZ2FkZ2V0L2Z1bmN0aW9u
L2ZfZnMuYw0KPiA+ICsrKyBiL2RyaXZlcnMvdXNiL2dhZGdldC9mdW5jdGlvbi9mX2ZzLmMNCj4g
PiBAQCAtNzE1LDcgKzcxNSwyMCBAQCBzdGF0aWMgdm9pZCBmZnNfZXBmaWxlX2lvX2NvbXBsZXRl
KHN0cnVjdCB1c2JfZXAgKl9lcCwgc3RydWN0IHVzYl9yZXF1ZXN0ICpyZXEpDQo+ID4gIA0KPiA+
ICBzdGF0aWMgc3NpemVfdCBmZnNfY29weV90b19pdGVyKHZvaWQgKmRhdGEsIGludCBkYXRhX2xl
biwgc3RydWN0IGlvdl9pdGVyICppdGVyKQ0KPiA+ICB7DQo+ID4gLQlzc2l6ZV90IHJldCA9IGNv
cHlfdG9faXRlcihkYXRhLCBkYXRhX2xlbiwgaXRlcik7DQo+ID4gKwlzc2l6ZV90IHJldDsNCj4g
PiArDQo+ID4gKyNpZiBkZWZpbmVkKENPTkZJR19BUk02NCkNCj4gPiArCS8qDQo+ID4gKwkgKiBS
ZXBsYWNlIHRhZ2dlZCBhZGRyZXNzIHBhc3NlZCBieSB1c2VyIHNwYWNlIGFwcGxpY2F0aW9uIGJl
Zm9yZQ0KPiA+ICsJICogY29weWluZy4NCj4gPiArCSAqLw0KPiA+ICsJaWYgKElTX0VOQUJMRUQo
Q09ORklHX0FSTTY0X1RBR0dFRF9BRERSX0FCSSkgJiYNCj4gPiArCQkoaXRlci0+dHlwZSA9PSBJ
VEVSX0lPVkVDKSkgew0KPiA+ICsJCSoodW5zaWduZWQgbG9uZyAqKSZpdGVyLT5pb3YtPmlvdl9i
YXNlID0NCj4gPiArCQkJKHVuc2lnbmVkIGxvbmcpdW50YWdnZWRfYWRkcihpdGVyLT5pb3YtPmlv
dl9iYXNlKTsNCj4gPiArCX0NCj4gPiArI2VuZGlmDQo+ID4gKwlyZXQgPSBjb3B5X3RvX2l0ZXIo
ZGF0YSwgZGF0YV9sZW4sIGl0ZXIpOw0KPiA+ICAJaWYgKGxpa2VseShyZXQgPT0gZGF0YV9sZW4p
KQ0KPiA+ICAJCXJldHVybiByZXQ7DQo+IA0KPiBJIGhhZCBmb3Jnb3R0ZW4gdGhhdCB3ZSBkaXNj
dXNzZWQgYSBzaW1pbGFyIGNhc2UgYWxyZWFkeSBhIGZldyBtb250aHMNCj4gYWdvICh0aGFua3Mg
dG8gRXZnZW5paSBmb3IgcG9pbnRpbmcgb3V0KS4gRG8geW91IGhhdmUgdGhpcyBjb21taXQNCj4g
YXBwbGllZCB0byB5b3VyIHRyZWU6IGRmMzI1ZTA1YTY4MiAoImFybTY0OiBWYWxpZGF0ZSB0YWdn
ZWQgYWRkcmVzc2VzIGluDQo+IGFjY2Vzc19vaygpIGNhbGxlZCBmcm9tIGtlcm5lbCB0aHJlYWRz
Iik/DQo+IA0KDQpZZXMhIFdlIGhhdmUgdGhhdCBwYXRjaC4gSSd2ZSBhbHNvIGdvdCBHb29nbGUn
cyByZXBseSBhYm91dCByZWZlcmVuY2luZw0KdGhpcyBwYXRjaCBpbiBhbmRyb2lkIGtlcm5lbCB0
cmVlLg0KaHR0cHM6Ly9hbmRyb2lkLXJldmlldy5nb29nbGVzb3VyY2UuY29tL2Mva2VybmVsL2Nv
bW1vbi8rLzExODY2MTUNCg0KSG93ZXZlciwgZHVyaW5nIG15IGRlYnVnZ2luZyBwcm9jZXNzLCBJ
J3ZlIGR1bXBlZCBzcGVjaWZpYyBsZW5ndGggKGUuZy4sDQoyNCBieXRlcyBmb3IgdGhlIGZpcnN0
IHJlcXVlc3QpIEFJTyByZXF1ZXN0IGJ1ZmZlciBhZGRyZXNzIGJvdGggaW4gYWRiZA0KYW5kIGlu
IF9fcmFuZ2Vfb2soKS4gVGhlbiBJJ3ZlIGZvdW5kIF9fcmFuZ2Vfb2soKSBzdGlsbCBhbHdheXMg
cmV0dXJuDQpmYWxzZSBvbiBhZGRyZXNzIGJlZ2luIHdpdGggIjB4M2MiLiBTaW5jZSB1bnRhZ2dl
ZF9hZGRyKCkgYWxyZWFkeSBjYWxsZWQNCmluIF9fcmFuZ2Vfb2soKSwgdG8gc2V0ICJUSUZfVEFH
R0VEX0FERFIiIHdpdGggYWRiZCdzIHVzZXIgc3BhY2UgYnVmZmVyDQpzaG91bGQgYmUgdGhlIHBv
c3NpYmxlIHNvbHV0aW9uLiBIZW5jZSBJJ3ZlIHNlbmQgdGhlIHYzIHBhdGNoLg0KDQpBbnl3YXks
IEkndmUgZm91bmQgdGhhdCB0byBkaXNhYmxlIFRBR0dFRCBhZGRyZXNzIGluIGFkYmQgaXMgcG9z
c2libGUgYnkNCnRoaXMgd2F5IGFuZCB3aWxsIHJlcG9ydCB0byBHb29nbGUgYW5kIHNlZSBob3cg
dGhleSB0aGluay4NCg0KZGlmZiAtLWdpdCBhL2FkYi9kYWVtb24vbWFpbi5jcHAgYi9hZGIvZGFl
bW9uL21haW4uY3BwDQppbmRleCA5ZTAyZTg5YWIuLmIyZjZmOGUzZiAxMDA2NDQNCi0tLSBhL2Fk
Yi9kYWVtb24vbWFpbi5jcHANCisrKyBiL2FkYi9kYWVtb24vbWFpbi5jcHANCkBAIC0zMTcsNiAr
MzE3LDggQEAgaW50IG1haW4oaW50IGFyZ2MsIGNoYXIqKiBhcmd2KSB7DQogICAgIG1hbGxvcHQo
TV9ERUNBWV9USU1FLCAxKTsNCiAjZW5kaWYNCg0KKyAgICBwcmN0bChQUl9TRVRfVEFHR0VEX0FE
RFJfQ1RSTCwgflBSX1RBR0dFRF9BRERSX0VOQUJMRSwgMCwgMCwgMCk7DQorDQogICAgIHdoaWxl
ICh0cnVlKSB7DQogICAgICAgICBzdGF0aWMgc3RydWN0IG9wdGlvbiBvcHRzW10gPSB7DQogICAg
ICAgICAgICAgICAgIHsicm9vdF9zZWNsYWJlbCIsIHJlcXVpcmVkX2FyZ3VtZW50LCBudWxscHRy
LCAncyd9LA0KDQpNYW55IHRoYW5rcyENCk1hY3BhdWwgTGluDQo=

