Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147C8254739
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 16:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgH0OnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 10:43:13 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:26415 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727955AbgH0Om3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 10:42:29 -0400
X-UUID: 7c28fd5f24d24019aa36eb181ec8afb2-20200827
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=JxbZixmFJh9c+WT3U8OFN0KHuXjwMU2nmEwM8sSXHVA=;
        b=lnJ3q6CHyNUcNdP7kS4JAoOimbkAzmCuZZyAkKKR4L3yWup+DMqb5OkvaRULBGIN+j4h0oY1evQt7EeBfoR+n7Pj8DdcQlBBMASHErdarC81l3G3mr9ucNpzhtkH3/LCa5kmqK9D+AzzcqTy5wIfEYKLnVXv35ohu2OlzI5cNMc=;
X-UUID: 7c28fd5f24d24019aa36eb181ec8afb2-20200827
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 510836240; Thu, 27 Aug 2020 22:42:19 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 27 Aug 2020 22:42:14 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 27 Aug 2020 22:42:14 +0800
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     Alan Stern <stern@rowland.harvard.edu>,
        Felipe Balbi <balbi@kernel.org>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
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
Subject: [PATCH v4] usb: mtu3: fix panic in mtu3_gadget_stop()
Date:   Thu, 27 Aug 2020 22:42:08 +0800
Message-ID: <1598539328-1976-1-git-send-email-macpaul.lin@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1598520178-17301-1-git-send-email-macpaul.lin@mediatek.com>
References: <1598520178-17301-1-git-send-email-macpaul.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: AAD9FDC317E12DCC933D9F09EE1697932188FE17584BD9F57F94349FC182C0932000:8
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
MHg4Yy8weGEwDQoNCkZpeGVzOiBkZjIwNjlhY2IwMDUgKCJ1c2I6IEFkZCBNZWRpYVRlayBVU0Iz
IERSRCBkcml2ZXIiKQ0KU2lnbmVkLW9mZi1ieTogTWFjcGF1bCBMaW4gPG1hY3BhdWwubGluQG1l
ZGlhdGVrLmNvbT4NCkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQotLS0NCkNoYW5nZXMgZm9y
IHY0Og0KICAtIEFkZCBhICJGaXhlczoiIGxpbmUuICBUaGFua3MgRmVsaXBlLg0KQ2hhbmdlcyBm
b3IgdjM6DQogIC0gQ2FsbCBzeW5jaHJvbml6ZV9pcnEoKSBpbiBtdHUzX2dhZGdldF9zdG9wKCkg
aW5zdGVhZCBvZiByZW1lbWJlcmluZw0KICAgIGNhbGxiYWNrIGZ1bmN0aW9uIGluIG10dTNfZ2Fk
Z2V0X2Rpc2Nvbm5lY3QoKS4NCiAgICBUaGFua3MgZm9yIEFsYW4ncyBzdWdnZXN0aW9uLg0KQ2hh
bmdlcyBmb3IgdjI6DQogIC0gQ2hlY2sgbXR1X2dhZGdldF9kcml2ZXIgb3V0IG9mIHNwaW5fbG9j
ayBtaWdodCBzdGlsbCBub3Qgd29yay4NCiAgICBXZSB1c2UgYSB0ZW1wb3JhcnkgcG9pbnRlciB0
byByZW1lbWJlciB0aGUgY2FsbGJhY2sgZnVuY3Rpb24uDQoNCiBkcml2ZXJzL3VzYi9tdHUzL210
dTNfZ2FkZ2V0LmMgfCAgICAxICsNCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb25zKCspDQoN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9tdHUzL210dTNfZ2FkZ2V0LmMgYi9kcml2ZXJzL3Vz
Yi9tdHUzL210dTNfZ2FkZ2V0LmMNCmluZGV4IDFkZTVjOWEuLjFhYjNkM2EgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL3VzYi9tdHUzL210dTNfZ2FkZ2V0LmMNCisrKyBiL2RyaXZlcnMvdXNiL210dTMv
bXR1M19nYWRnZXQuYw0KQEAgLTU2NCw2ICs1NjQsNyBAQCBzdGF0aWMgaW50IG10dTNfZ2FkZ2V0
X3N0b3Aoc3RydWN0IHVzYl9nYWRnZXQgKmcpDQogDQogCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUo
Jm10dS0+bG9jaywgZmxhZ3MpOw0KIA0KKwlzeW5jaHJvbml6ZV9pcnEobXR1LT5pcnEpOw0KIAly
ZXR1cm4gMDsNCiB9DQogDQotLSANCjEuNy45LjUNCg==

