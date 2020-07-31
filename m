Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158462341AE
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 10:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730268AbgGaI6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jul 2020 04:58:15 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:11742 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728437AbgGaI6O (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jul 2020 04:58:14 -0400
X-UUID: 82b739de27a3420592e9259af2d0299e-20200731
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=NjNs/L/PQBspTHCRKxQtG3j74BSnJbhVaOVg+dzczjA=;
        b=uMdRaMlke+fLMUQG2Wr6NqndkWOmlv4NqnzDlpudBAr9LW6gXf/TPIBoytXigENMfaiPgQcdpRKs9C9SCIVXtSwTkbJHVGlXzzTpy3gSsZsPwfz6PzCp26WECpmDQEnABpDZnoYTzAhW7bd8jvM4nWKhGqClsBpG7nfecmB/47w=;
X-UUID: 82b739de27a3420592e9259af2d0299e-20200731
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1549384507; Fri, 31 Jul 2020 16:58:07 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 31 Jul 2020 16:58:03 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 31 Jul 2020 16:58:04 +0800
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Eddie Hung <eddie.hung@mediatek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Macpaul Lin <macpaul.lin@gmail.com>, <stable@vger.kernel.org>
Subject: [PATCH v2] usb: mtu3: fix panic in mtu3_gadget_disconnect()
Date:   Fri, 31 Jul 2020 16:57:58 +0800
Message-ID: <1596185878-24360-1-git-send-email-macpaul.lin@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1596177366-12029-1-git-send-email-macpaul.lin@mediatek.com>
References: <1596177366-12029-1-git-send-email-macpaul.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VGhpcyBwYXRjaCBmaXhlcyBhIHBvc3NpYmxlIGlzc3VlIHdoZW4gbXR1M19nYWRnZXRfc3RvcCgp
DQphbHJlYWR5IGFzc2lnbmVkIE5VTEwgdG8gbXR1LT5nYWRnZXRfZHJpdmVyIGR1cmluZyBtdHVf
Z2FkZ2V0X2Rpc2Nvbm5lY3QoKS4NCg0KWzxmZmZmZmY5MDA4MTYxOTc0Pl0gbm90aWZpZXJfY2Fs
bF9jaGFpbisweGE0LzB4MTI4DQpbPGZmZmZmZjkwMDgxNjFmZDQ+XSBfX2F0b21pY19ub3RpZmll
cl9jYWxsX2NoYWluKzB4ODQvMHgxMzgNCls8ZmZmZmZmOTAwODE2MmVjMD5dIG5vdGlmeV9kaWUr
MHhiMC8weDEyMA0KWzxmZmZmZmY5MDA4MDllMzQwPl0gZGllKzB4MWY4LzB4NWQwDQpbPGZmZmZm
ZjkwMDgwZDAzYjQ+XSBfX2RvX2tlcm5lbF9mYXVsdCsweDE5Yy8weDI4MA0KWzxmZmZmZmY5MDA4
MGQwNGRjPl0gZG9fYmFkX2FyZWErMHg0NC8weDE0MA0KWzxmZmZmZmY5MDA4MGQwZjljPl0gZG9f
dHJhbnNsYXRpb25fZmF1bHQrMHg0Yy8weDkwDQpbPGZmZmZmZjkwMDgwODBhNzg+XSBkb19tZW1f
YWJvcnQrMHhiOC8weDI1OA0KWzxmZmZmZmY5MDA4MDg0OWQwPl0gZWwxX2RhKzB4MjQvMHgzYw0K
WzxmZmZmZmY5MDA5YmRlMDFjPl0gbXR1M19nYWRnZXRfZGlzY29ubmVjdCsweGFjLzB4MTI4DQpb
PGZmZmZmZjkwMDliZDU3NmM+XSBtdHUzX2lycSsweDM0Yy8weGMxOA0KWzxmZmZmZmY5MDA4MmFj
MDNjPl0gX19oYW5kbGVfaXJxX2V2ZW50X3BlcmNwdSsweDJhYy8weGNkMA0KWzxmZmZmZmY5MDA4
MmFjYWUwPl0gaGFuZGxlX2lycV9ldmVudF9wZXJjcHUrMHg4MC8weDEzOA0KWzxmZmZmZmY5MDA4
MmFjYzQ0Pl0gaGFuZGxlX2lycV9ldmVudCsweGFjLzB4MTQ4DQpbPGZmZmZmZjkwMDgyYjcxY2M+
XSBoYW5kbGVfZmFzdGVvaV9pcnErMHgyMzQvMHg1NjgNCls8ZmZmZmZmOTAwODJhODcwOD5dIGdl
bmVyaWNfaGFuZGxlX2lycSsweDQ4LzB4NjgNCls8ZmZmZmZmOTAwODJhOTZhYz5dIF9faGFuZGxl
X2RvbWFpbl9pcnErMHgyNjQvMHgxNzQwDQpbPGZmZmZmZjkwMDgwODE5ZjQ+XSBnaWNfaGFuZGxl
X2lycSsweDE0Yy8weDI1MA0KWzxmZmZmZmY5MDA4MDg0Y2VjPl0gZWwxX2lycSsweGVjLzB4MTk0
DQpbPGZmZmZmZjkwMDg1Yjk4NWM+XSBkbWFfcG9vbF9hbGxvYysweDZlNC8weGFlMA0KWzxmZmZm
ZmY5MDA4ZDdmODkwPl0gY21kcV9tYm94X3Bvb2xfYWxsb2NfaW1wbCsweGIwLzB4MjM4DQpbPGZm
ZmZmZjkwMDhkODA5MDQ+XSBjbWRxX3BrdF9hbGxvY19idWYrMHgyZGMvMHg3YzANCls8ZmZmZmZm
OTAwOGQ4MGY2MD5dIGNtZHFfcGt0X2FkZF9jbWRfYnVmZmVyKzB4MTc4LzB4MjcwDQpbPGZmZmZm
ZjkwMDhkODIzMjA+XSBjbWRxX3BrdF9wZXJmX2JlZ2luKzB4MTA4LzB4MTQ4DQpbPGZmZmZmZjkw
MDhkODI0ZDg+XSBjbWRxX3BrdF9jcmVhdGUrMHgxNzgvMHgxZjANCls8ZmZmZmZmOTAwOGY5NjIz
MD5dIG10a19jcnRjX2NvbmZpZ19kZWZhdWx0X3BhdGgrMHgzMjgvMHg3YTANCls8ZmZmZmZmOTAw
OTAyNDZjYz5dIG10a19kcm1faWRsZW1ncl9raWNrKzB4YTZjLzB4MTQ2MA0KWzxmZmZmZmY5MDA4
ZjliYmI0Pl0gbXRrX2RybV9jcnRjX2F0b21pY19iZWdpbisweDFhNC8weDFhNjgNCls8ZmZmZmZm
OTAwOGU4ZGY5Yz5dIGRybV9hdG9taWNfaGVscGVyX2NvbW1pdF9wbGFuZXMrMHgxNTQvMHg4NzgN
Cls8ZmZmZmZmOTAwOGYyZmI3MD5dIG10a19hdG9taWNfY29tcGxldGUuaXNyYS4xNisweGU4MC8w
eDE5YzgNCls8ZmZmZmZmOTAwOGYzMDkxMD5dIG10a19hdG9taWNfY29tbWl0KzB4MjU4LzB4ODk4
DQpbPGZmZmZmZjkwMDhlZjE0MmM+XSBkcm1fYXRvbWljX2NvbW1pdCsweGNjLzB4MTA4DQpbPGZm
ZmZmZjkwMDhlZjdjZjA+XSBkcm1fbW9kZV9hdG9taWNfaW9jdGwrMHgxYzIwLzB4MjU4MA0KWzxm
ZmZmZmY5MDA4ZWJjNzY4Pl0gZHJtX2lvY3RsX2tlcm5lbCsweDExOC8weDFiMA0KWzxmZmZmZmY5
MDA4ZWJjZGU4Pl0gZHJtX2lvY3RsKzB4NWMwLzB4OTIwDQpbPGZmZmZmZjkwMDg2M2IwMzA+XSBk
b192ZnNfaW9jdGwrMHgxODgvMHgxODIwDQpbPGZmZmZmZjkwMDg2M2M3NTQ+XSBTeVNfaW9jdGwr
MHg4Yy8weGEwDQoNClNpZ25lZC1vZmYtYnk6IE1hY3BhdWwgTGluIDxtYWNwYXVsLmxpbkBtZWRp
YXRlay5jb20+DQpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KLS0tDQpDaGFuZ2VzIGZvciB2
MjoNCiAgLSBDaGVjayBtdHVfZ2FkZ2V0X2RyaXZlciBvdXQgb2Ygc3Bpbl9sb2NrIG1pZ2h0IHN0
aWxsIG5vdCB3b3JrLg0KICAgIFdlIHVzZSBhIHRlbXBvcmFyeSBwb2ludGVyIHRvIGtlZXAgdGhl
IGNhbGxiYWNrIGZ1bmN0aW9uLg0KDQogZHJpdmVycy91c2IvbXR1My9tdHUzX2dhZGdldC5jIHwg
OSArKysrKysrKy0NCiAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9u
KC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9tdHUzL210dTNfZ2FkZ2V0LmMgYi9kcml2
ZXJzL3VzYi9tdHUzL210dTNfZ2FkZ2V0LmMNCmluZGV4IDY4ZWE0Mzk1Zjg3MS4uNDBjYjY2MjZm
NDk2IDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2IvbXR1My9tdHUzX2dhZGdldC5jDQorKysgYi9k
cml2ZXJzL3VzYi9tdHUzL210dTNfZ2FkZ2V0LmMNCkBAIC04NDAsMTAgKzg0MCwxNyBAQCB2b2lk
IG10dTNfZ2FkZ2V0X3N1c3BlbmQoc3RydWN0IG10dTMgKm10dSkNCiAvKiBjYWxsZWQgd2hlbiBW
QlVTIGRyb3BzIGJlbG93IHNlc3Npb24gdGhyZXNob2xkLCBhbmQgaW4gb3RoZXIgY2FzZXMgKi8N
CiB2b2lkIG10dTNfZ2FkZ2V0X2Rpc2Nvbm5lY3Qoc3RydWN0IG10dTMgKm10dSkNCiB7DQorCXN0
cnVjdCB1c2JfZ2FkZ2V0X2RyaXZlciAqZHJpdmVyOw0KKw0KIAlkZXZfZGJnKG10dS0+ZGV2LCAi
Z2FkZ2V0IERJU0NPTk5FQ1RcbiIpOw0KIAlpZiAobXR1LT5nYWRnZXRfZHJpdmVyICYmIG10dS0+
Z2FkZ2V0X2RyaXZlci0+ZGlzY29ubmVjdCkgew0KKwkJZHJpdmVyID0gbXR1LT5nYWRnZXRfZHJp
dmVyOw0KIAkJc3Bpbl91bmxvY2soJm10dS0+bG9jayk7DQotCQltdHUtPmdhZGdldF9kcml2ZXIt
PmRpc2Nvbm5lY3QoJm10dS0+Zyk7DQorCQkvKg0KKwkJICogYXZvaWQga2VybmVsIHBhbmljIGJl
Y2F1c2UgbXR1M19nYWRnZXRfc3RvcCgpIGFzc2lnbmVkIE5VTEwNCisJCSAqIHRvIG10dS0+Z2Fk
Z2V0X2RyaXZlci4NCisJCSAqLw0KKwkJZHJpdmVyLT5kaXNjb25uZWN0KCZtdHUtPmcpOw0KIAkJ
c3Bpbl9sb2NrKCZtdHUtPmxvY2spOw0KIAl9DQogDQotLSANCjIuMTguMA0K

