Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B33F14C6F7
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 08:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgA2HjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 02:39:24 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:15399 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726076AbgA2HjN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 02:39:13 -0500
X-UUID: 550fdfe733e94e9a88c29a40adb14693-20200129
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=RNlRrAtsmyEK+6KafSQgfCKsq/mGqkOCE3TvsRLFgBo=;
        b=ZZvV9eMeMrNcjFbw6eg2s3+DPozptVyXWsm136eS41dmRVlHMmmfwq9izyblMjfidwkOXxiitVQmwfor7CjRstsHak+B/jvdZJWeaGdPPHHGCBXRz3E0CkZDQkQrYvCNZJLOhHdLQCxbuAk8G3yoB7WDE0D9yRYMrSrA55DydKc=;
X-UUID: 550fdfe733e94e9a88c29a40adb14693-20200129
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 116438089; Wed, 29 Jan 2020 15:39:06 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 29 Jan 2020 15:37:44 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 29 Jan 2020 15:39:12 +0800
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
Subject: [PATCH v3 3/4] scsi: ufs: fix Auto-Hibern8 error detection
Date:   Wed, 29 Jan 2020 15:39:01 +0800
Message-ID: <20200129073902.5786-4-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200129073902.5786-1-stanley.chu@mediatek.com>
References: <20200129073902.5786-1-stanley.chu@mediatek.com>
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
czogODIxNzQ0NCAoInNjc2k6IHVmczogQWRkIGVycm9yLWhhbmRsaW5nIG9mIEF1dG8tSGliZXJu
YXRlIikNCkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5
IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KUmV2aWV3ZWQtYnk6IEJlYW4gSHVvIDxi
ZWFuaHVvQG1pY3Jvbi5jb20+DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgMyAr
Ky0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oIHwgNiArKysrKysNCiAyIGZpbGVzIGNoYW5n
ZWQsIDggaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCmluZGV4IGFi
ZDBlNmIwNWY3OS4uMjE0YTNmMzczZGQ4IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91
ZnNoY2QuYw0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KQEAgLTU0NzksNyArNTQ3
OSw4IEBAIHN0YXRpYyBpcnFyZXR1cm5fdCB1ZnNoY2RfdXBkYXRlX3VpY19lcnJvcihzdHJ1Y3Qg
dWZzX2hiYSAqaGJhKQ0KIHN0YXRpYyBib29sIHVmc2hjZF9pc19hdXRvX2hpYmVybjhfZXJyb3Io
c3RydWN0IHVmc19oYmEgKmhiYSwNCiAJCQkJCSB1MzIgaW50cl9tYXNrKQ0KIHsNCi0JaWYgKCF1
ZnNoY2RfaXNfYXV0b19oaWJlcm44X3N1cHBvcnRlZChoYmEpKQ0KKwlpZiAoIXVmc2hjZF9pc19h
dXRvX2hpYmVybjhfc3VwcG9ydGVkKGhiYSkgfHwNCisJICAgICF1ZnNoY2RfaXNfYXV0b19oaWJl
cm44X2VuYWJsZWQoaGJhKSkNCiAJCXJldHVybiBmYWxzZTsNCiANCiAJaWYgKCEoaW50cl9tYXNr
ICYgVUZTSENEX1VJQ19ISUJFUk44X01BU0spKQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91
ZnMvdWZzaGNkLmggYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQppbmRleCAyYWU2YzdjODUy
OGMuLjgxYzcxYTNlMzQ3NCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgN
CisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCkBAIC01NSw2ICs1NSw3IEBADQogI2lu
Y2x1ZGUgPGxpbnV4L2Nsay5oPg0KICNpbmNsdWRlIDxsaW51eC9jb21wbGV0aW9uLmg+DQogI2lu
Y2x1ZGUgPGxpbnV4L3JlZ3VsYXRvci9jb25zdW1lci5oPg0KKyNpbmNsdWRlIDxsaW51eC9iaXRm
aWVsZC5oPg0KICNpbmNsdWRlICJ1bmlwcm8uaCINCiANCiAjaW5jbHVkZSA8YXNtL2lycS5oPg0K
QEAgLTc3Myw2ICs3NzQsMTEgQEAgc3RhdGljIGlubGluZSBib29sIHVmc2hjZF9pc19hdXRvX2hp
YmVybjhfc3VwcG9ydGVkKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCXJldHVybiAoaGJhLT5jYXBh
YmlsaXRpZXMgJiBNQVNLX0FVVE9fSElCRVJOOF9TVVBQT1JUKTsNCiB9DQogDQorc3RhdGljIGlu
bGluZSBib29sIHVmc2hjZF9pc19hdXRvX2hpYmVybjhfZW5hYmxlZChzdHJ1Y3QgdWZzX2hiYSAq
aGJhKQ0KK3sNCisJcmV0dXJuIEZJRUxEX0dFVChVRlNIQ0lfQUhJQkVSTjhfVElNRVJfTUFTSywg
aGJhLT5haGl0KSA/IHRydWUgOiBmYWxzZTsNCit9DQorDQogI2RlZmluZSB1ZnNoY2Rfd3JpdGVs
KGhiYSwgdmFsLCByZWcpCVwNCiAJd3JpdGVsKCh2YWwpLCAoaGJhKS0+bW1pb19iYXNlICsgKHJl
ZykpDQogI2RlZmluZSB1ZnNoY2RfcmVhZGwoaGJhLCByZWcpCVwNCi0tIA0KMi4xOC4wDQo=

