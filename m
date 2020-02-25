Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A19B16BEFC
	for <lists+stable@lfdr.de>; Tue, 25 Feb 2020 11:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730269AbgBYKmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Feb 2020 05:42:07 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:10267 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729417AbgBYKmG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Feb 2020 05:42:06 -0500
X-UUID: 1872ab0ccbd84197b00233eb8f8611a7-20200225
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=F/HwmP2nkakeOJe6rb/hTQ+jcOaAno58DR/mM7/DDU0=;
        b=cV2wzTUVO9sdNTTO5c2ZuOmuT47xPenpLJHqKSZz1K0MNz60SZOumoAx3FgC/RMOXFUwIZhrvojGlWTFaH95fdAa9ftmXOKCzHQm6zUGF69CN8jAtm5+NstBASQomDBEF1Pvt7+HZhcAcadma5n2lW0A+/fLunNhSJT3RrsnrkM=;
X-UUID: 1872ab0ccbd84197b00233eb8f8611a7-20200225
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1569439019; Tue, 25 Feb 2020 18:42:01 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 25 Feb 2020 18:37:53 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 25 Feb 2020 18:41:57 +0800
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
        Al Viro <viro@zeniv.linux.org.uk>, <stable@vger.kernel.org>
CC:     Macpaul Lin <macpaul.lin@mediatek.com>
Subject: [PATCH v3] usb: gadget: f_fs: try to fix AIO issue under ARM 64 bit TAGGED mode
Date:   Tue, 25 Feb 2020 18:41:55 +0800
Message-ID: <1582627315-21123-1-git-send-email-macpaul.lin@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1582472947-22471-1-git-send-email-macpaul.lin@mediatek.com>
References: <1582472947-22471-1-git-send-email-macpaul.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 861415B116ECAEBFF54A79652E47A283856E8F4245AD425BB9510418B61F86902000:8
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
DQpDb3B5b3V0KCkgd29uJ3QgY29weSBkYXRhIHRvIHVzZXJzcGFjZSBzaW5jZSB0aGUgbGVuZ3Ro
IHRvIGJlIGNvcGllZA0KInYuaW92X2xlbiIgd2lsbCBiZSB6ZXJvLiBGaW5hbGx5IGxlYWRzIGZm
c19jb3B5X3RvX2l0ZXIoKSBhbHdheXMgcmV0dXJuDQotRUZBVUxULCBjYXVzZXMgYWRiZCBjYW5u
b3Qgb3BlbiBmdW5jdGlvbmZzIGFuZCBzZW5kDQpGVU5DVElPTkZTX0NMRUFSX0hBTFQuDQoNClNp
Z25lZC1vZmYtYnk6IE1hY3BhdWwgTGluIDxtYWNwYXVsLmxpbkBtZWRpYXRlay5jb20+DQotLS0N
CkNoYW5nZXMgZm9yIHYzOg0KICAtIEZpeCBtaXNzcGVsbGluZyBpbiBjb21taXQgbWVzc2FnZS4N
Cg0KQ2hhbmdlcyBmb3IgdjI6DQogIC0gRml4IGJ1aWxkIGVycm9yIGZvciAzMi1iaXQgbG9hZC4g
QW4gI2lmIGRlZmluZWQoQ09ORklHX0FSTTY0KSBzdGlsbCBuZWVkDQogICAgZm9yIGF2b2lkaW5n
IHVuZGVjbGFyZWQgZGVmaW5lcy4NCg0KIGRyaXZlcnMvdXNiL2dhZGdldC9mdW5jdGlvbi9mX2Zz
LmMgfCAgICA1ICsrKysrDQogMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKQ0KDQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy91c2IvZ2FkZ2V0L2Z1bmN0aW9uL2ZfZnMuYyBiL2RyaXZlcnMvdXNi
L2dhZGdldC9mdW5jdGlvbi9mX2ZzLmMNCmluZGV4IGNlMWQwMjMuLjcyOGMyNjAgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL3VzYi9nYWRnZXQvZnVuY3Rpb24vZl9mcy5jDQorKysgYi9kcml2ZXJzL3Vz
Yi9nYWRnZXQvZnVuY3Rpb24vZl9mcy5jDQpAQCAtMzUsNiArMzUsNyBAQA0KICNpbmNsdWRlIDxs
aW51eC9tbXVfY29udGV4dC5oPg0KICNpbmNsdWRlIDxsaW51eC9wb2xsLmg+DQogI2luY2x1ZGUg
PGxpbnV4L2V2ZW50ZmQuaD4NCisjaW5jbHVkZSA8bGludXgvdGhyZWFkX2luZm8uaD4NCiANCiAj
aW5jbHVkZSAidV9mcy5oIg0KICNpbmNsdWRlICJ1X2YuaCINCkBAIC04MjYsNiArODI3LDEwIEBA
IHN0YXRpYyB2b2lkIGZmc191c2VyX2NvcHlfd29ya2VyKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29y
aykNCiAJaWYgKGlvX2RhdGEtPnJlYWQgJiYgcmV0ID4gMCkgew0KIAkJbW1fc2VnbWVudF90IG9s
ZGZzID0gZ2V0X2ZzKCk7DQogDQorI2lmIGRlZmluZWQoQ09ORklHX0FSTTY0KQ0KKwkJaWYgKElT
X0VOQUJMRUQoQ09ORklHX0FSTTY0X1RBR0dFRF9BRERSX0FCSSkpDQorCQkJc2V0X3RocmVhZF9m
bGFnKFRJRl9UQUdHRURfQUREUik7DQorI2VuZGlmDQogCQlzZXRfZnMoVVNFUl9EUyk7DQogCQl1
c2VfbW0oaW9fZGF0YS0+bW0pOw0KIAkJcmV0ID0gZmZzX2NvcHlfdG9faXRlcihpb19kYXRhLT5i
dWYsIHJldCwgJmlvX2RhdGEtPmRhdGEpOw0KLS0gDQoxLjcuOS41DQo=

