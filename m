Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF09212CD80
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 09:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbfL3IMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 03:12:39 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:61195 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727237AbfL3IMj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 03:12:39 -0500
X-UUID: 904ee707ec974189ae3160414c3faa94-20191230
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=5R6N7XJB2+tt8KF/gBYonmpANV9A07p3yQjPCAKO6yg=;
        b=XBrCAvj1Y7v/dHdJfMKsAXYfnMrqUs6JqpkhGnp/MW3C/mKEw4LvObiMIzhT3rHflsi6uRQiz0g7bf1bTnUB6ISykKtsNjZKaMkUPsuTCcFoocOY75+FbEhuBkzBX/qDPfY8+eqf4RBi12pHXsP6uE5Z7p93AoIXkKsFS6wdptI=;
X-UUID: 904ee707ec974189ae3160414c3faa94-20191230
Received: from mtkmrs01.mediatek.inc [(172.21.131.159)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 900142939; Mon, 30 Dec 2019 16:12:29 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 30 Dec 2019 16:11:42 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 30 Dec 2019 16:12:01 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <subhashj@codeaurora.org>
CC:     <beanhuo@micron.com>, <cang@codeaurora.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v1 1/2] scsi: ufs: set device as default active power mode during initialization only
Date:   Mon, 30 Dec 2019 16:12:25 +0800
Message-ID: <1577693546-7598-2-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1577693546-7598-1-git-send-email-stanley.chu@mediatek.com>
References: <1577693546-7598-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Q3VycmVudGx5IHVmc2hjZF9wcm9iZV9oYmEoKSBhbHdheXMgc2V0cyBkZXZpY2Ugc3RhdHVzIGFz
ICJhY3RpdmUiLg0KVGhpcyBzaGFsbCBiZSBieSBhbiBhc3N1bXB0aW9uIHRoYXQgZGV2aWNlIGlz
IGFscmVhZHkgaW4gYWN0aXZlIHN0YXRlDQpkdXJpbmcgdGhlIGJvb3Qgc3RhZ2UgYmVmb3JlIGtl
cm5lbC4NCg0KSG93ZXZlciwgaWYgbGluayBpcyBjb25maWd1cmVkIGFzICJvZmYiIHN0YXRlIGFu
ZCBkZXZpY2UgaXMgcmVxdWVzdGVkDQp0byBlbnRlciAic2xlZXAiIG9yICJwb3dlcmRvd24iIHBv
d2VyIG1vZGUgZHVyaW5nIHN1c3BlbmQgZmxvdywgZGV2aWNlDQp3aWxsIE5PVCBiZSB3YWtlbiB1
cCB0byAiYWN0aXZlIiBwb3dlciBtb2RlIGR1cmluZyByZXN1bWUgZmxvdyBiZWNhdXNlDQpkZXZp
Y2UgaXMgYWxyZWFkeSBzZXQgYXMgImFjdGl2ZSIgcG93ZXIgbW9kZSBpbiB1ZmhjZF9wcm9iZV9o
YmEoKS4NCg0KRml4IGl0IGJ5IHNldHRpbmcgZGV2aWNlIGFzIGRlZmF1bHQgYWN0aXZlIHBvd2Vy
IG1vZGUgZHVyaW5nDQppbml0aWFsaXphdGlvbiBvbmx5LCBhbmQgc2tpcHBpbmcgY2hhbmdpbmcg
bW9kZSBkdXJpbmcgUE0gZmxvdw0KaW4gdWZzaGNkX3Byb2JlX2hiYSgpLg0KDQpGaXhlczogN2Nh
ZjQ4OWI5OWE0IChzY3NpOiB1ZnM6IGlzc3VlIGxpbmsgc3RhcnVwIDIgdGltZXMgaWYgZGV2aWNl
IGlzbid0IGFjdGl2ZSkNCkNjOiBBbGltIEFraHRhciA8YWxpbS5ha2h0YXJAc2Ftc3VuZy5jb20+
DQpDYzogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQpDYzogQmFydCBWYW4gQXNz
Y2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQpDYzogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNv
bT4NCkNjOiBDYW4gR3VvIDxjYW5nQGNvZGVhdXJvcmEub3JnPg0KQ2M6IE1hdHRoaWFzIEJydWdn
ZXIgPG1hdHRoaWFzLmJnZ0BnbWFpbC5jb20+DQpDYzogU3ViaGFzaCBKYWRhdmFuaSA8c3ViaGFz
aGpAY29kZWF1cm9yYS5vcmc+DQpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KU2lnbmVkLW9m
Zi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZl
cnMvc2NzaS91ZnMvdWZzaGNkLmMgfCAzICsrLQ0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlv
bnMoKyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQppbmRleCBlZDAyYTcwNGMxYzIuLjlh
YmI3MDg1YTVkMCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCisrKyBi
L2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCkBAIC02OTg2LDcgKzY5ODYsOCBAQCBzdGF0aWMg
aW50IHVmc2hjZF9wcm9iZV9oYmEoc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJdWZzaGNkX3R1bmVf
dW5pcHJvX3BhcmFtcyhoYmEpOw0KIA0KIAkvKiBVRlMgZGV2aWNlIGlzIGFsc28gYWN0aXZlIG5v
dyAqLw0KLQl1ZnNoY2Rfc2V0X3Vmc19kZXZfYWN0aXZlKGhiYSk7DQorCWlmICghaGJhLT5wbV9v
cF9pbl9wcm9ncmVzcykNCisJCXVmc2hjZF9zZXRfdWZzX2Rldl9hY3RpdmUoaGJhKTsNCiAJdWZz
aGNkX2ZvcmNlX3Jlc2V0X2F1dG9fYmtvcHMoaGJhKTsNCiAJaGJhLT53bHVuX2Rldl9jbHJfdWEg
PSB0cnVlOw0KIA0KLS0gDQoyLjE4LjANCg==

