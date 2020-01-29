Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFEC14C903
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 11:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgA2Kw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 05:52:59 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:41405 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726339AbgA2Kw7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 05:52:59 -0500
X-UUID: 1ae9ea4e460e488bb68a93205392e4df-20200129
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=On3ymt2nIzso/VupG3uq3vXt9HiMtRzJKLdz08bIXPs=;
        b=d4uPOyytD6ZfR4ey2Yg5Mrq5s05ZrIkpNH3wuXaPINdSpi+V4p36y8OdS1SNVSi6/l/xssfbcK4nRpBIz6prwYGCxzWZ0rFhz8AUtXUOSmNpuMfv1/XFWHG7cqjIru2rJ6qVcYokP85DEifotSInvw9nnE526mWH6xNdt+exzOA=;
X-UUID: 1ae9ea4e460e488bb68a93205392e4df-20200129
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 2016043192; Wed, 29 Jan 2020 18:52:54 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 29 Jan 2020 18:53:16 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 29 Jan 2020 18:52:59 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>
CC:     <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>,
        <stable@vger.kernel.org>
Subject: [PATCH RESEND v3 3/4] scsi: ufs: fix Auto-Hibern8 error detection
Date:   Wed, 29 Jan 2020 18:52:50 +0800
Message-ID: <20200129105251.12466-4-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200129105251.12466-1-stanley.chu@mediatek.com>
References: <20200129105251.12466-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

QXV0by1IaWJlcm44IG1heSBiZSBkaXNhYmxlZCBieSBzb21lIHZlbmRvcnMgb3Igc3lzZnMNCmlu
IHJ1bnRpbWUgZXZlbiBpZiBBdXRvLUhpYmVybjggY2FwYWJpbGl0eSBpcyBzdXBwb3J0ZWQNCmJ5
IGhvc3QuIElmIEF1dG8tSGliZXJuOCBjYXBhYmlsaXR5IGlzIHN1cHBvcnRlZCBieSBob3N0DQpi
dXQgbm90IGFjdHVhbGx5IGVuYWJsZWQsIEF1dG8tSGliZXJuOCBlcnJvciBzaGFsbCBub3QgaGFw
cGVuLg0KDQpUbyBmaXggdGhpcywgcHJvdmlkZSBhIHdheSB0byBkZXRlY3QgaWYgQXV0by1IaWJl
cm44IGlzDQphY3R1YWxseSBlbmFibGVkIGZpcnN0LCBhbmQgYnlwYXNzIEF1dG8tSGliZXJuOCBk
aXNhYmxpbmcNCmNhc2UgaW4gdWZzaGNkX2lzX2F1dG9faGliZXJuOF9lcnJvcigpLg0KDQpGaXhl
czogODIxNzQ0NDAzOTEzICgic2NzaTogdWZzOiBBZGQgZXJyb3ItaGFuZGxpbmcgb2YgQXV0by1I
aWJlcm5hdGUiKQ0KQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNClNpZ25lZC1vZmYtYnk6IFN0
YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQpSZXZpZXdlZC1ieTogQmVhbiBI
dW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMg
fCAzICsrLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggfCA2ICsrKysrKw0KIDIgZmlsZXMg
Y2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9k
cml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KaW5k
ZXggYWJkMGU2YjA1Zjc5Li4yMTRhM2YzNzNkZDggMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kv
dWZzL3Vmc2hjZC5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQpAQCAtNTQ3OSw3
ICs1NDc5LDggQEAgc3RhdGljIGlycXJldHVybl90IHVmc2hjZF91cGRhdGVfdWljX2Vycm9yKHN0
cnVjdCB1ZnNfaGJhICpoYmEpDQogc3RhdGljIGJvb2wgdWZzaGNkX2lzX2F1dG9faGliZXJuOF9l
cnJvcihzdHJ1Y3QgdWZzX2hiYSAqaGJhLA0KIAkJCQkJIHUzMiBpbnRyX21hc2spDQogew0KLQlp
ZiAoIXVmc2hjZF9pc19hdXRvX2hpYmVybjhfc3VwcG9ydGVkKGhiYSkpDQorCWlmICghdWZzaGNk
X2lzX2F1dG9faGliZXJuOF9zdXBwb3J0ZWQoaGJhKSB8fA0KKwkgICAgIXVmc2hjZF9pc19hdXRv
X2hpYmVybjhfZW5hYmxlZChoYmEpKQ0KIAkJcmV0dXJuIGZhbHNlOw0KIA0KIAlpZiAoIShpbnRy
X21hc2sgJiBVRlNIQ0RfVUlDX0hJQkVSTjhfTUFTSykpDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
Y3NpL3Vmcy91ZnNoY2QuaCBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCmluZGV4IDJhZTZj
N2M4NTI4Yy4uODFjNzFhM2UzNDc0IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNo
Y2QuaA0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KQEAgLTU1LDYgKzU1LDcgQEAN
CiAjaW5jbHVkZSA8bGludXgvY2xrLmg+DQogI2luY2x1ZGUgPGxpbnV4L2NvbXBsZXRpb24uaD4N
CiAjaW5jbHVkZSA8bGludXgvcmVndWxhdG9yL2NvbnN1bWVyLmg+DQorI2luY2x1ZGUgPGxpbnV4
L2JpdGZpZWxkLmg+DQogI2luY2x1ZGUgInVuaXByby5oIg0KIA0KICNpbmNsdWRlIDxhc20vaXJx
Lmg+DQpAQCAtNzczLDYgKzc3NCwxMSBAQCBzdGF0aWMgaW5saW5lIGJvb2wgdWZzaGNkX2lzX2F1
dG9faGliZXJuOF9zdXBwb3J0ZWQoc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJcmV0dXJuIChoYmEt
PmNhcGFiaWxpdGllcyAmIE1BU0tfQVVUT19ISUJFUk44X1NVUFBPUlQpOw0KIH0NCiANCitzdGF0
aWMgaW5saW5lIGJvb2wgdWZzaGNkX2lzX2F1dG9faGliZXJuOF9lbmFibGVkKHN0cnVjdCB1ZnNf
aGJhICpoYmEpDQorew0KKwlyZXR1cm4gRklFTERfR0VUKFVGU0hDSV9BSElCRVJOOF9USU1FUl9N
QVNLLCBoYmEtPmFoaXQpID8gdHJ1ZSA6IGZhbHNlOw0KK30NCisNCiAjZGVmaW5lIHVmc2hjZF93
cml0ZWwoaGJhLCB2YWwsIHJlZykJXA0KIAl3cml0ZWwoKHZhbCksIChoYmEpLT5tbWlvX2Jhc2Ug
KyAocmVnKSkNCiAjZGVmaW5lIHVmc2hjZF9yZWFkbChoYmEsIHJlZykJXA0KLS0gDQoyLjE4LjAN
Cg==

