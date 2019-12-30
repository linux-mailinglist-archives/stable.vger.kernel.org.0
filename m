Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 627F812CD83
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 09:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbfL3IMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 03:12:43 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:13156 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727273AbfL3IMm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 03:12:42 -0500
X-UUID: 343b846368e741b9832269576d6311ce-20191230
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=0KIHktbzT0WK8dPIhtZ0AEWFT4vEf5OuB0GSMuDxVIM=;
        b=sZXTbpNVSdNkJTgsrm3MuOLqChFWjl9HhNtgt/ON3EMwF+WKgfqlAZRFZzpB3gZvUrt07w0vSw1MZ8NivFWWcwkp0bhpms2CKD2S6LhMaDuRRc8ay1ZyU35k/6IViuCb6yEA79HoE3U9dK+mbqvAhG3L3CWnm/qHGrWt01r9qPA=;
X-UUID: 343b846368e741b9832269576d6311ce-20191230
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 901626152; Mon, 30 Dec 2019 16:12:35 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 30 Dec 2019 16:13:02 +0800
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
Subject: [PATCH v1 2/2] scsi: ufs: remove link_startup_again flow in ufshcd_link_startup
Date:   Mon, 30 Dec 2019 16:12:26 +0800
Message-ID: <1577693546-7598-3-git-send-email-stanley.chu@mediatek.com>
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

bGlua19zdGFydHVwX2FnYWluIGZsb3cgaW4gdWZzaGNkX2xpbmtfc3RhcnR1cCgpIGlzIG5vdCBu
ZWNlc3NhcnkNCnNpbmNlIGN1cnJlbnRseSBkZXZpY2UgY2FuIGJlIG1vdmVkIHRvICJhY3RpdmUi
IHBvd2VyIG1vZGUgZHVyaW5nDQpyZXN1bWUgZmxvdyBieSBjb21taXQgYXMgYmVsb3csDQoNCiJz
Y3NpOiB1ZnM6IHNldCBkZXZpY2UgYXMgZGVmYXVsdCBhY3RpdmUgcG93ZXIgbW9kZSBkdXJpbmcN
CmluaXRpYWxpemF0aW9uIG9ubHkiDQoNCkZpeGVzOiA3Y2FmNDg5Yjk5YTQgKHNjc2k6IHVmczog
aXNzdWUgbGluayBzdGFydXAgMiB0aW1lcyBpZiBkZXZpY2UgaXNuJ3QgYWN0aXZlKQ0KQ2M6IEFs
aW0gQWtodGFyIDxhbGltLmFraHRhckBzYW1zdW5nLmNvbT4NCkNjOiBBdnJpIEFsdG1hbiA8YXZy
aS5hbHRtYW5Ad2RjLmNvbT4NCkNjOiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9y
Zz4NCkNjOiBCZWFuIEh1byA8YmVhbmh1b0BtaWNyb24uY29tPg0KQ2M6IENhbiBHdW8gPGNhbmdA
Y29kZWF1cm9yYS5vcmc+DQpDYzogTWF0dGhpYXMgQnJ1Z2dlciA8bWF0dGhpYXMuYmdnQGdtYWls
LmNvbT4NCkNjOiBTdWJoYXNoIEphZGF2YW5pIDxzdWJoYXNoakBjb2RlYXVyb3JhLm9yZz4NCkNj
OiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3Rh
bmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyB8
IDE1IC0tLS0tLS0tLS0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxNSBkZWxldGlvbnMoLSkNCg0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZz
L3Vmc2hjZC5jDQppbmRleCA5YWJiNzA4NWE1ZDAuLjE5MDBmODExMzk0YSAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNk
LmMNCkBAIC00MzY1LDE2ICs0MzY1LDcgQEAgc3RhdGljIGludCB1ZnNoY2RfbGlua19zdGFydHVw
KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogew0KIAlpbnQgcmV0Ow0KIAlpbnQgcmV0cmllcyA9IERN
RV9MSU5LU1RBUlRVUF9SRVRSSUVTOw0KLQlib29sIGxpbmtfc3RhcnR1cF9hZ2FpbiA9IGZhbHNl
Ow0KIA0KLQkvKg0KLQkgKiBJZiBVRlMgZGV2aWNlIGlzbid0IGFjdGl2ZSB0aGVuIHdlIHdpbGwg
aGF2ZSB0byBpc3N1ZSBsaW5rIHN0YXJ0dXANCi0JICogMiB0aW1lcyB0byBtYWtlIHN1cmUgdGhl
IGRldmljZSBzdGF0ZSBtb3ZlIHRvIGFjdGl2ZS4NCi0JICovDQotCWlmICghdWZzaGNkX2lzX3Vm
c19kZXZfYWN0aXZlKGhiYSkpDQotCQlsaW5rX3N0YXJ0dXBfYWdhaW4gPSB0cnVlOw0KLQ0KLWxp
bmtfc3RhcnR1cDoNCiAJZG8gew0KIAkJdWZzaGNkX3ZvcHNfbGlua19zdGFydHVwX25vdGlmeSho
YmEsIFBSRV9DSEFOR0UpOw0KIA0KQEAgLTQ0MDgsMTIgKzQzOTksNiBAQCBzdGF0aWMgaW50IHVm
c2hjZF9saW5rX3N0YXJ0dXAoc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJCWdvdG8gb3V0Ow0KIAl9
DQogDQotCWlmIChsaW5rX3N0YXJ0dXBfYWdhaW4pIHsNCi0JCWxpbmtfc3RhcnR1cF9hZ2FpbiA9
IGZhbHNlOw0KLQkJcmV0cmllcyA9IERNRV9MSU5LU1RBUlRVUF9SRVRSSUVTOw0KLQkJZ290byBs
aW5rX3N0YXJ0dXA7DQotCX0NCi0NCiAJLyogTWFyayB0aGF0IGxpbmsgaXMgdXAgaW4gUFdNLUcx
LCAxLWxhbmUsIFNMT1ctQVVUTyBtb2RlICovDQogCXVmc2hjZF9pbml0X3B3cl9pbmZvKGhiYSk7
DQogCXVmc2hjZF9wcmludF9wd3JfaW5mbyhoYmEpOw0KLS0gDQoyLjE4LjANCg==

