Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8912AB3B6
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 10:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbgKIJhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 04:37:13 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:40484 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727959AbgKIJhN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 04:37:13 -0500
X-UUID: eea5f82a0ec046a1bfee65d48b211755-20201109
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=y18PdOi4AAYhrSttdKfUyYbFn/VzBQNwj5oUxyKSku8=;
        b=aUSm5LzEOcmmlkpLQNc3aUnoBvMulocdAIaCV6qXRPWFOaiD1APDYmIwUDzdxLoIr6HIlAJbcuR40ER2mHZRD64sBaxIM0Wad721m/aL50nJO0k6w1nK0KtVZRt75d5/w9/hP0PbxkbiaInoyqsBvyxVozz8vIC4JGd5JGCE7Bg=;
X-UUID: eea5f82a0ec046a1bfee65d48b211755-20201109
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <weiyi.lu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1914843392; Mon, 09 Nov 2020 17:37:10 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 9 Nov 2020 17:37:08 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 9 Nov 2020 17:37:08 +0800
From:   Weiyi Lu <weiyi.lu@mediatek.com>
To:     Matthias Brugger <matthias.bgg@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <linux-clk@vger.kernel.org>,
        <srv_heupstream@mediatek.com>, <stable@vger.kernel.org>,
        Weiyi Lu <weiyi.lu@mediatek.com>,
        Owen Chen <owen.chen@mediatek.com>
Subject: [PATCH] clk: mediatek: fix mtk_clk_register_mux() as static function
Date:   Mon, 9 Nov 2020 17:37:07 +0800
Message-ID: <1604914627-9203-1-git-send-email-weiyi.lu@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

bXRrX2Nsa19yZWdpc3Rlcl9tdXgoKSBzaG91bGQgYmUgYSBzdGF0aWMgZnVuY3Rpb24NCg0KRml4
ZXM6IGEzYWU1NDk5MTdmMTYgKCJjbGs6IG1lZGlhdGVrOiBBZGQgbmV3IGNsa211eCByZWdpc3Rl
ciBBUEkiKQ0KQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KU2lnbmVkLW9mZi1ieTogV2Vp
eWkgTHUgPHdlaXlpLmx1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvY2xrL21lZGlhdGVr
L2Nsay1tdXguYyB8IDIgKy0NCiBkcml2ZXJzL2Nsay9tZWRpYXRlay9jbGstbXV4LmggfCA0IC0t
LS0NCiAyIGZpbGVzIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCA1IGRlbGV0aW9ucygtKQ0KDQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9jbGsvbWVkaWF0ZWsvY2xrLW11eC5jIGIvZHJpdmVycy9jbGsv
bWVkaWF0ZWsvY2xrLW11eC5jDQppbmRleCAxNGUxMjdlLi5kY2MxMzUyIDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy9jbGsvbWVkaWF0ZWsvY2xrLW11eC5jDQorKysgYi9kcml2ZXJzL2Nsay9tZWRpYXRl
ay9jbGstbXV4LmMNCkBAIC0xNTUsNyArMTU1LDcgQEAgc3RhdGljIGludCBtdGtfY2xrX211eF9z
ZXRfcGFyZW50X3NldGNscl9sb2NrKHN0cnVjdCBjbGtfaHcgKmh3LCB1OCBpbmRleCkNCiAJLnNl
dF9wYXJlbnQgPSBtdGtfY2xrX211eF9zZXRfcGFyZW50X3NldGNscl9sb2NrLA0KIH07DQogDQot
c3RydWN0IGNsayAqbXRrX2Nsa19yZWdpc3Rlcl9tdXgoY29uc3Qgc3RydWN0IG10a19tdXggKm11
eCwNCitzdGF0aWMgc3RydWN0IGNsayAqbXRrX2Nsa19yZWdpc3Rlcl9tdXgoY29uc3Qgc3RydWN0
IG10a19tdXggKm11eCwNCiAJCQkJIHN0cnVjdCByZWdtYXAgKnJlZ21hcCwNCiAJCQkJIHNwaW5s
b2NrX3QgKmxvY2spDQogew0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2xrL21lZGlhdGVrL2Nsay1t
dXguaCBiL2RyaXZlcnMvY2xrL21lZGlhdGVrL2Nsay1tdXguaA0KaW5kZXggZjU2MjVmNC4uOGUy
ZjkyNyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvY2xrL21lZGlhdGVrL2Nsay1tdXguaA0KKysrIGIv
ZHJpdmVycy9jbGsvbWVkaWF0ZWsvY2xrLW11eC5oDQpAQCAtNzcsMTAgKzc3LDYgQEAgc3RydWN0
IG10a19tdXggew0KIAkJCV93aWR0aCwgX2dhdGUsIF91cGRfb2ZzLCBfdXBkLAkJCVwNCiAJCQlD
TEtfU0VUX1JBVEVfUEFSRU5UKQ0KIA0KLXN0cnVjdCBjbGsgKm10a19jbGtfcmVnaXN0ZXJfbXV4
KGNvbnN0IHN0cnVjdCBtdGtfbXV4ICptdXgsDQotCQkJCSBzdHJ1Y3QgcmVnbWFwICpyZWdtYXAs
DQotCQkJCSBzcGlubG9ja190ICpsb2NrKTsNCi0NCiBpbnQgbXRrX2Nsa19yZWdpc3Rlcl9tdXhl
cyhjb25zdCBzdHJ1Y3QgbXRrX211eCAqbXV4ZXMsDQogCQkJICAgaW50IG51bSwgc3RydWN0IGRl
dmljZV9ub2RlICpub2RlLA0KIAkJCSAgIHNwaW5sb2NrX3QgKmxvY2ssDQotLSANCjEuOC4xLjEu
ZGlydHkNCg==

