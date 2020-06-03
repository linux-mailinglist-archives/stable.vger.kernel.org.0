Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D4F1ED087
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 15:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgFCNKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 09:10:10 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:57799 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725854AbgFCNKK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 09:10:10 -0400
X-UUID: 0657ba4250544b7d8ce827bf6bd21513-20200603
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=2OS1Oc6QKgyNEMcqfsLs5jUWJHdxON7zK6mWXvLCPnM=;
        b=qMOL6MSHSaTVwFjjhcJ+NW3YbFUjF2jBfQIQi/CZyflUFw5Mh0VO3T761w4WOEKrbLUtG7NYWM0aaWXi2wd37T+/92xYm74Pi3aJUJOGhGar3bZFTcJ8VnRW9WuOPMMsY65Vnf1vX82SxmLx/38gVgthPIuJXrDYFj9WaX1CQfQ=;
X-UUID: 0657ba4250544b7d8ce827bf6bd21513-20200603
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 110805781; Wed, 03 Jun 2020 21:10:04 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 3 Jun 2020 21:09:59 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 3 Jun 2020 21:10:01 +0800
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <stable@vger.kernel.org>
CC:     Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Macpaul Lin <macpaul.lin@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-mediatek@lists.infradead.org>
Subject: [PATCH v3] usb: host: xhci-mtk: avoid runtime suspend when removing hcd
Date:   Wed, 3 Jun 2020 21:09:27 +0800
Message-ID: <1591189767-21988-1-git-send-email-macpaul.lin@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <ebd32a2b-c4ba-8891-b13e-f6c641a94276@linux.intel.com>
References: <ebd32a2b-c4ba-8891-b13e-f6c641a94276@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 891385B6AA430B1B9CAB903AC4DA341DF9FFE4F9D9796E2CF48A9C88B1AE21CC2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

V2hlbiBydW50aW1lIHN1c3BlbmQgd2FzIGVuYWJsZWQsIHJ1bnRpbWUgc3VzcGVuZCBtaWdodCBo
YXBwZW5lZA0Kd2hlbiB4aGNpIGlzIHJlbW92aW5nIGhjZC4gVGhpcyBtaWdodCBjYXVzZSBrZXJu
ZWwgcGFuaWMgd2hlbiBoY2QNCmhhcyBiZWVuIGZyZWVkIGJ1dCBydW50aW1lIHBtIHN1c3BlbmQg
cmVsYXRlZCBoYW5kbGUgbmVlZCB0bw0KcmVmZXJlbmNlIGl0Lg0KDQpTaWduZWQtb2ZmLWJ5OiBN
YWNwYXVsIExpbiA8bWFjcGF1bC5saW5AbWVkaWF0ZWsuY29tPg0KUmV2aWV3ZWQtYnk6IENodW5m
ZW5nIFl1biA8Y2h1bmZlbmcueXVuQG1lZGlhdGVrLmNvbT4NCi0tLQ0KQ2hhbmdlcyBmb3IgdjM6
DQogIC0gUmVwbGFjZSBiZXR0ZXIgc2VxdWVuY2UgZm9yIGRpc2FibGluZyB0aGUgcG1fcnVudGlt
ZSBzdXNwZW5kLg0KDQogZHJpdmVycy91c2IvaG9zdC94aGNpLW10ay5jIHwgICAgNSArKystLQ0K
IDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQoNCmRpZmYg
LS1naXQgYS9kcml2ZXJzL3VzYi9ob3N0L3hoY2ktbXRrLmMgYi9kcml2ZXJzL3VzYi9ob3N0L3ho
Y2ktbXRrLmMNCmluZGV4IGJmYmRiM2MuLjY0MWQyNGUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Vz
Yi9ob3N0L3hoY2ktbXRrLmMNCisrKyBiL2RyaXZlcnMvdXNiL2hvc3QveGhjaS1tdGsuYw0KQEAg
LTU4Nyw2ICs1ODcsOSBAQCBzdGF0aWMgaW50IHhoY2lfbXRrX3JlbW92ZShzdHJ1Y3QgcGxhdGZv
cm1fZGV2aWNlICpkZXYpDQogCXN0cnVjdCB4aGNpX2hjZAkqeGhjaSA9IGhjZF90b194aGNpKGhj
ZCk7DQogCXN0cnVjdCB1c2JfaGNkICAqc2hhcmVkX2hjZCA9IHhoY2ktPnNoYXJlZF9oY2Q7DQog
DQorCXBtX3J1bnRpbWVfcHV0X25vaWRsZSgmZGV2LT5kZXYpOw0KKwlwbV9ydW50aW1lX2Rpc2Fi
bGUoJmRldi0+ZGV2KTsNCisNCiAJdXNiX3JlbW92ZV9oY2Qoc2hhcmVkX2hjZCk7DQogCXhoY2kt
PnNoYXJlZF9oY2QgPSBOVUxMOw0KIAlkZXZpY2VfaW5pdF93YWtldXAoJmRldi0+ZGV2LCBmYWxz
ZSk7DQpAQCAtNTk3LDggKzYwMCw2IEBAIHN0YXRpYyBpbnQgeGhjaV9tdGtfcmVtb3ZlKHN0cnVj
dCBwbGF0Zm9ybV9kZXZpY2UgKmRldikNCiAJeGhjaV9tdGtfc2NoX2V4aXQobXRrKTsNCiAJeGhj
aV9tdGtfY2xrc19kaXNhYmxlKG10ayk7DQogCXhoY2lfbXRrX2xkb3NfZGlzYWJsZShtdGspOw0K
LQlwbV9ydW50aW1lX3B1dF9zeW5jKCZkZXYtPmRldik7DQotCXBtX3J1bnRpbWVfZGlzYWJsZSgm
ZGV2LT5kZXYpOw0KIA0KIAlyZXR1cm4gMDsNCiB9DQotLSANCjEuNy45LjUNCg==

