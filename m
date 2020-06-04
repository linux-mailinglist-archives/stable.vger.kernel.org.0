Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECDE1EDB82
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 05:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgFDDCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 23:02:07 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:16223 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725992AbgFDDCH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 23:02:07 -0400
X-UUID: be76835fb3214aa3b7f98be91c9e5e1e-20200604
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=UrOXbDNOnHiFKXtwaHVgzKiUKHi9PYwsXdkt9BWMTQ0=;
        b=l4b8g311ij1osd5rrSxatQoejISeR2FIM9I2BLjH5Z/lF5w8CdMBFRPcBp84q2OS4CxL9M56MOPd2wPBOp9D/552vfvJTfOKfHr0KlZa+rg9vZY3kxhFE+KCSJJutYqimi5pgAKHP6lUDwhjwveUlVkudm8n9bE0Ve4NyvBLQJA=;
X-UUID: be76835fb3214aa3b7f98be91c9e5e1e-20200604
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 493531536; Thu, 04 Jun 2020 11:02:05 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 4 Jun 2020 11:02:03 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 4 Jun 2020 11:02:03 +0800
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Macpaul Lin <macpaul.lin@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <stable@vger.kernel.org>
Subject: [PATCH v4] usb: host: xhci-mtk: avoid runtime suspend when removing hcd
Date:   Thu, 4 Jun 2020 11:01:53 +0800
Message-ID: <1591239713-5081-1-git-send-email-macpaul.lin@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1591189767-21988-1-git-send-email-macpaul.lin@mediatek.com>
References: <1591189767-21988-1-git-send-email-macpaul.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: B6818B62397C1B7303376C105A3A0368FFDDA6D0DA11CA08A9A0942B6D3722342000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

V2hlbiBydW50aW1lIHN1c3BlbmQgd2FzIGVuYWJsZWQsIHJ1bnRpbWUgc3VzcGVuZCBtaWdodCBo
YXBwZW4NCndoZW4geGhjaSBpcyByZW1vdmluZyBoY2QuIFRoaXMgbWlnaHQgY2F1c2Uga2VybmVs
IHBhbmljIHdoZW4gaGNkDQpoYXMgYmVlbiBmcmVlZCBidXQgcnVudGltZSBwbSBzdXNwZW5kIHJl
bGF0ZWQgaGFuZGxlIG5lZWQgdG8NCnJlZmVyZW5jZSBpdC4NCg0KU2lnbmVkLW9mZi1ieTogTWFj
cGF1bCBMaW4gPG1hY3BhdWwubGluQG1lZGlhdGVrLmNvbT4NClJldmlld2VkLWJ5OiBDaHVuZmVu
ZyBZdW4gPGNodW5mZW5nLnl1bkBtZWRpYXRlay5jb20+DQpDYzogc3RhYmxlQHZnZXIua2VybmVs
Lm9yZw0KLS0tDQpDaGFuZ2VzIGZvciB2MzoNCiAgLSBSZXBsYWNlIGJldHRlciBzZXF1ZW5jZSBm
b3IgZGlzYWJsaW5nIHRoZSBwbV9ydW50aW1lIHN1c3BlbmQuDQpDaGFuZ2VzIGZvciB2NDoNCiAg
LSBUaGFua3MgZm9yIFNlcmdlaSdzIHJldmlldywgdHlwbyBpbiBjb21taXQgZGVzY3JpcHRpb24g
aGFzIGJlZW4gY29ycmVjdGVkLg0KDQogZHJpdmVycy91c2IvaG9zdC94aGNpLW10ay5jIHwgICAg
NSArKystLQ0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0p
DQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9ob3N0L3hoY2ktbXRrLmMgYi9kcml2ZXJzL3Vz
Yi9ob3N0L3hoY2ktbXRrLmMNCmluZGV4IGJmYmRiM2MuLjY0MWQyNGUgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL3VzYi9ob3N0L3hoY2ktbXRrLmMNCisrKyBiL2RyaXZlcnMvdXNiL2hvc3QveGhjaS1t
dGsuYw0KQEAgLTU4Nyw2ICs1ODcsOSBAQCBzdGF0aWMgaW50IHhoY2lfbXRrX3JlbW92ZShzdHJ1
Y3QgcGxhdGZvcm1fZGV2aWNlICpkZXYpDQogCXN0cnVjdCB4aGNpX2hjZAkqeGhjaSA9IGhjZF90
b194aGNpKGhjZCk7DQogCXN0cnVjdCB1c2JfaGNkICAqc2hhcmVkX2hjZCA9IHhoY2ktPnNoYXJl
ZF9oY2Q7DQogDQorCXBtX3J1bnRpbWVfcHV0X25vaWRsZSgmZGV2LT5kZXYpOw0KKwlwbV9ydW50
aW1lX2Rpc2FibGUoJmRldi0+ZGV2KTsNCisNCiAJdXNiX3JlbW92ZV9oY2Qoc2hhcmVkX2hjZCk7
DQogCXhoY2ktPnNoYXJlZF9oY2QgPSBOVUxMOw0KIAlkZXZpY2VfaW5pdF93YWtldXAoJmRldi0+
ZGV2LCBmYWxzZSk7DQpAQCAtNTk3LDggKzYwMCw2IEBAIHN0YXRpYyBpbnQgeGhjaV9tdGtfcmVt
b3ZlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKmRldikNCiAJeGhjaV9tdGtfc2NoX2V4aXQobXRr
KTsNCiAJeGhjaV9tdGtfY2xrc19kaXNhYmxlKG10ayk7DQogCXhoY2lfbXRrX2xkb3NfZGlzYWJs
ZShtdGspOw0KLQlwbV9ydW50aW1lX3B1dF9zeW5jKCZkZXYtPmRldik7DQotCXBtX3J1bnRpbWVf
ZGlzYWJsZSgmZGV2LT5kZXYpOw0KIA0KIAlyZXR1cm4gMDsNCiB9DQotLSANCjEuNy45LjUNCg==

