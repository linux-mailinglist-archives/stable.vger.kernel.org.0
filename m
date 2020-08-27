Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B302541FE
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 11:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgH0JXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 05:23:35 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:60447 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728401AbgH0JXd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 05:23:33 -0400
X-UUID: c6ec64b1d9cd4f118c4f7a3070a9774b-20200827
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=S4CfLutE8hUT3EWA7X8xikOPUUz72YCt0QmrL0S0o10=;
        b=RuipkW0mMnh8/+7ZcKhlpn2NZL+srPzHlp3S1Rjj0PlVd1QR+QPuofPFxemm55YaPAahwCqB1uGaTZGA18yH6isTzj4VHXqprGQXVsNvZL40m1s6XpmAD4JGu0fK985Z6wZSy3IHRAFzb2D5RndSNlCvNe1UTctnuAf3wX9/2UM=;
X-UUID: c6ec64b1d9cd4f118c4f7a3070a9774b-20200827
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1025482517; Thu, 27 Aug 2020 17:23:29 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 27 Aug 2020 17:23:26 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 27 Aug 2020 17:23:26 +0800
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
CC:     Ainge Hsu <ainge.hsu@mediatek.com>,
        Eddie Hung <eddie.hung@mediatek.com>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Macpaul Lin <macpaul.lin@gmail.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v3] usb: mtu3: fix panic in mtu3_gadget_stop()
Date:   Thu, 27 Aug 2020 17:22:58 +0800
Message-ID: <1598520178-17301-1-git-send-email-macpaul.lin@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1596185878-24360-1-git-send-email-macpaul.lin@mediatek.com>
References: <1596185878-24360-1-git-send-email-macpaul.lin@mediatek.com>
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
MzoNCiAgLSBDYWxsIHN5bmNocm9uaXplX2lycSgpIGluIG10dTNfZ2FkZ2V0X3N0b3AoKSBpbnN0
ZWFkIG9mIHJlbWVtYmVyaW5nDQogICAgY2FsbGJhY2sgZnVuY3Rpb24gaW4gbXR1M19nYWRnZXRf
ZGlzY29ubmVjdCgpLg0KICAgIFRoYW5rcyBmb3IgQWxhbidzIHN1Z2dlc3Rpb24uDQoNCkNoYW5n
ZXMgZm9yIHYyOg0KICAtIENoZWNrIG10dV9nYWRnZXRfZHJpdmVyIG91dCBvZiBzcGluX2xvY2sg
bWlnaHQgc3RpbGwgbm90IHdvcmsuDQogICAgV2UgdXNlIGEgdGVtcG9yYXJ5IHBvaW50ZXIgdG8g
cmVtZW1iZXIgdGhlIGNhbGxiYWNrIGZ1bmN0aW9uLg0KDQogZHJpdmVycy91c2IvbXR1My9tdHUz
X2dhZGdldC5jIHwgICAgMSArDQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9ucygrKQ0KDQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvbXR1My9tdHUzX2dhZGdldC5jIGIvZHJpdmVycy91c2Iv
bXR1My9tdHUzX2dhZGdldC5jDQppbmRleCAxZGU1YzlhLi4xYWIzZDNhIDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy91c2IvbXR1My9tdHUzX2dhZGdldC5jDQorKysgYi9kcml2ZXJzL3VzYi9tdHUzL210
dTNfZ2FkZ2V0LmMNCkBAIC01NjQsNiArNTY0LDcgQEAgc3RhdGljIGludCBtdHUzX2dhZGdldF9z
dG9wKHN0cnVjdCB1c2JfZ2FkZ2V0ICpnKQ0KIA0KIAlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZt
dHUtPmxvY2ssIGZsYWdzKTsNCiANCisJc3luY2hyb25pemVfaXJxKG10dS0+aXJxKTsNCiAJcmV0
dXJuIDA7DQogfQ0KIA0KLS0gDQoxLjcuOS41DQo=

