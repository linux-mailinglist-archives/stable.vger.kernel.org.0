Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF46233F2C
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 08:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731269AbgGaGgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jul 2020 02:36:16 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:20427 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731224AbgGaGgO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jul 2020 02:36:14 -0400
X-UUID: 80600fca466b4b81b487657ab0f366de-20200731
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=oCSPBwm1OG9nHt5f6BWa2OtMBUQFOcwvvqmT2nA/E1U=;
        b=PPxTCoxddKLPAf5YDbExSlINVAHT8uY8vmO6u74ebqTU0XOC6q9JKSMh/lni/oYeWvnhh7MjB5ugDJmqgG4+NQVjaTyjkJuDBAQ10ikdlOJ8f9/QVw6ny3Ie+AWIcQ5nt2cHzMbaigIV9bwROQ41LD2u8icaZ0P1/yKMmfqBHw4=;
X-UUID: 80600fca466b4b81b487657ab0f366de-20200731
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1770294931; Fri, 31 Jul 2020 14:36:09 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 31 Jul 2020 14:36:06 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 31 Jul 2020 14:36:06 +0800
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
Subject: [PATCH] usb: mtu3: fix panic in mtu3_gadget_disconnect()
Date:   Fri, 31 Jul 2020 14:36:06 +0800
Message-ID: <1596177366-12029-1-git-send-email-macpaul.lin@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
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
Z2FkZ2V0X2Rpc2Nvbm5lY3QoKS4NCg0KQmFja3RyYWNlOg0KWzxmZmZmZmY5MDA4MTYxOTc0Pl0g
bm90aWZpZXJfY2FsbF9jaGFpbisweGE0LzB4MTI4DQpbPGZmZmZmZjkwMDgxNjFmZDQ+XSBfX2F0
b21pY19ub3RpZmllcl9jYWxsX2NoYWluKzB4ODQvMHgxMzgNCls8ZmZmZmZmOTAwODE2MmVjMD5d
IG5vdGlmeV9kaWUrMHhiMC8weDEyMA0KWzxmZmZmZmY5MDA4MDllMzQwPl0gZGllKzB4MWY4LzB4
NWQwDQpbPGZmZmZmZjkwMDgwZDAzYjQ+XSBfX2RvX2tlcm5lbF9mYXVsdCsweDE5Yy8weDI4MA0K
WzxmZmZmZmY5MDA4MGQwNGRjPl0gZG9fYmFkX2FyZWErMHg0NC8weDE0MA0KWzxmZmZmZmY5MDA4
MGQwZjljPl0gZG9fdHJhbnNsYXRpb25fZmF1bHQrMHg0Yy8weDkwDQpbPGZmZmZmZjkwMDgwODBh
Nzg+XSBkb19tZW1fYWJvcnQrMHhiOC8weDI1OA0KWzxmZmZmZmY5MDA4MDg0OWQwPl0gZWwxX2Rh
KzB4MjQvMHgzYw0KWzxmZmZmZmY5MDA5YmRlMDFjPl0gbXR1M19nYWRnZXRfZGlzY29ubmVjdCsw
eGFjLzB4MTI4DQpbPGZmZmZmZjkwMDliZDU3NmM+XSBtdHUzX2lycSsweDM0Yy8weGMxOA0KWzxm
ZmZmZmY5MDA4MmFjMDNjPl0gX19oYW5kbGVfaXJxX2V2ZW50X3BlcmNwdSsweDJhYy8weGNkMA0K
WzxmZmZmZmY5MDA4MmFjYWUwPl0gaGFuZGxlX2lycV9ldmVudF9wZXJjcHUrMHg4MC8weDEzOA0K
WzxmZmZmZmY5MDA4MmFjYzQ0Pl0gaGFuZGxlX2lycV9ldmVudCsweGFjLzB4MTQ4DQpbPGZmZmZm
ZjkwMDgyYjcxY2M+XSBoYW5kbGVfZmFzdGVvaV9pcnErMHgyMzQvMHg1NjgNCls8ZmZmZmZmOTAw
ODJhODcwOD5dIGdlbmVyaWNfaGFuZGxlX2lycSsweDQ4LzB4NjgNCls8ZmZmZmZmOTAwODJhOTZh
Yz5dIF9faGFuZGxlX2RvbWFpbl9pcnErMHgyNjQvMHgxNzQwDQpbPGZmZmZmZjkwMDgwODE5ZjQ+
XSBnaWNfaGFuZGxlX2lycSsweDE0Yy8weDI1MA0KWzxmZmZmZmY5MDA4MDg0Y2VjPl0gZWwxX2ly
cSsweGVjLzB4MTk0DQpbPGZmZmZmZjkwMDg1Yjk4NWM+XSBkbWFfcG9vbF9hbGxvYysweDZlNC8w
eGFlMA0KWzxmZmZmZmY5MDA4ZDdmODkwPl0gY21kcV9tYm94X3Bvb2xfYWxsb2NfaW1wbCsweGIw
LzB4MjM4DQpbPGZmZmZmZjkwMDhkODA5MDQ+XSBjbWRxX3BrdF9hbGxvY19idWYrMHgyZGMvMHg3
YzANCls8ZmZmZmZmOTAwOGQ4MGY2MD5dIGNtZHFfcGt0X2FkZF9jbWRfYnVmZmVyKzB4MTc4LzB4
MjcwDQpbPGZmZmZmZjkwMDhkODIzMjA+XSBjbWRxX3BrdF9wZXJmX2JlZ2luKzB4MTA4LzB4MTQ4
DQpbPGZmZmZmZjkwMDhkODI0ZDg+XSBjbWRxX3BrdF9jcmVhdGUrMHgxNzgvMHgxZjANCls8ZmZm
ZmZmOTAwOGY5NjIzMD5dIG10a19jcnRjX2NvbmZpZ19kZWZhdWx0X3BhdGgrMHgzMjgvMHg3YTAN
Cls8ZmZmZmZmOTAwOTAyNDZjYz5dIG10a19kcm1faWRsZW1ncl9raWNrKzB4YTZjLzB4MTQ2MA0K
WzxmZmZmZmY5MDA4ZjliYmI0Pl0gbXRrX2RybV9jcnRjX2F0b21pY19iZWdpbisweDFhNC8weDFh
NjgNCls8ZmZmZmZmOTAwOGU4ZGY5Yz5dIGRybV9hdG9taWNfaGVscGVyX2NvbW1pdF9wbGFuZXMr
MHgxNTQvMHg4NzgNCls8ZmZmZmZmOTAwOGYyZmI3MD5dIG10a19hdG9taWNfY29tcGxldGUuaXNy
YS4xNisweGU4MC8weDE5YzgNCls8ZmZmZmZmOTAwOGYzMDkxMD5dIG10a19hdG9taWNfY29tbWl0
KzB4MjU4LzB4ODk4DQpbPGZmZmZmZjkwMDhlZjE0MmM+XSBkcm1fYXRvbWljX2NvbW1pdCsweGNj
LzB4MTA4DQpbPGZmZmZmZjkwMDhlZjdjZjA+XSBkcm1fbW9kZV9hdG9taWNfaW9jdGwrMHgxYzIw
LzB4MjU4MA0KWzxmZmZmZmY5MDA4ZWJjNzY4Pl0gZHJtX2lvY3RsX2tlcm5lbCsweDExOC8weDFi
MA0KWzxmZmZmZmY5MDA4ZWJjZGU4Pl0gZHJtX2lvY3RsKzB4NWMwLzB4OTIwDQpbPGZmZmZmZjkw
MDg2M2IwMzA+XSBkb192ZnNfaW9jdGwrMHgxODgvMHgxODIwDQpbPGZmZmZmZjkwMDg2M2M3NTQ+
XSBTeVNfaW9jdGwrMHg4Yy8weGEwDQoNClNpZ25lZC1vZmYtYnk6IE1hY3BhdWwgTGluIDxtYWNw
YXVsLmxpbkBtZWRpYXRlay5jb20+DQpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KLS0tDQog
ZHJpdmVycy91c2IvbXR1My9tdHUzX2dhZGdldC5jIHwgNyArKysrKystDQogMSBmaWxlIGNoYW5n
ZWQsIDYgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy91c2IvbXR1My9tdHUzX2dhZGdldC5jIGIvZHJpdmVycy91c2IvbXR1My9tdHUzX2dhZGdldC5j
DQppbmRleCA2OGVhNDM5NWY4NzEuLmYyMGZiODNiMzIzOSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMv
dXNiL210dTMvbXR1M19nYWRnZXQuYw0KKysrIGIvZHJpdmVycy91c2IvbXR1My9tdHUzX2dhZGdl
dC5jDQpAQCAtODQzLDcgKzg0MywxMiBAQCB2b2lkIG10dTNfZ2FkZ2V0X2Rpc2Nvbm5lY3Qoc3Ry
dWN0IG10dTMgKm10dSkNCiAJZGV2X2RiZyhtdHUtPmRldiwgImdhZGdldCBESVNDT05ORUNUXG4i
KTsNCiAJaWYgKG10dS0+Z2FkZ2V0X2RyaXZlciAmJiBtdHUtPmdhZGdldF9kcml2ZXItPmRpc2Nv
bm5lY3QpIHsNCiAJCXNwaW5fdW5sb2NrKCZtdHUtPmxvY2spOw0KLQkJbXR1LT5nYWRnZXRfZHJp
dmVyLT5kaXNjb25uZWN0KCZtdHUtPmcpOw0KKwkJLyoNCisJCSAqIGF2b2lkIGtlcm5lbCBwYW5p
YyBiZWNhdXNlIG10dTNfZ2FkZ2V0X3N0b3AoKSBhc3NpZ25lZCBOVUxMDQorCQkgKiB0byBtdHUt
PmdhZGdldF9kcml2ZXIuDQorCQkgKi8NCisJCWlmIChtdHUtPmdhZGdldF9kcml2ZXIgJiYgbXR1
LT5nYWRnZXRfZHJpdmVyLT5kaXNjb25uZWN0KQ0KKwkJCW10dS0+Z2FkZ2V0X2RyaXZlci0+ZGlz
Y29ubmVjdCgmbXR1LT5nKTsNCiAJCXNwaW5fbG9jaygmbXR1LT5sb2NrKTsNCiAJfQ0KIA0KLS0g
DQoyLjE4LjANCg==

