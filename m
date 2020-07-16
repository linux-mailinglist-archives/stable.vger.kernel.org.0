Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79567221CB8
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 08:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgGPGle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 02:41:34 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:4367 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727943AbgGPGle (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jul 2020 02:41:34 -0400
X-UUID: 23d064985d8c44cb8eb27405b3e6b9e4-20200716
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=Ho71eZkBMon4Vz3VLsPtyCt1CUgMlDiLHMKnef2ILSA=;
        b=XRXOcdeTwdFN5d5s8jX8hdz6O50rKSfYqC/FF81iO2+b53MPXL5/oC0kr7EVgPUpRORpRoYW96U7jERsz9vZ9HnAyr9cI8T9YQHHcldb5pesSvSRotu9pyGF/T3RirNz9Y82YCsHptjKZZ/PHrJZIhY7f3bsF0ReHtLCijHTROo=;
X-UUID: 23d064985d8c44cb8eb27405b3e6b9e4-20200716
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 982203569; Thu, 16 Jul 2020 14:41:28 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 16 Jul 2020 14:41:20 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 16 Jul 2020 14:41:20 +0800
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
CC:     Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Macpaul Lin <macpaul.lin@gmail.com>,
        Eddie Hung <eddie.hung@mediatek.com>, <stable@vger.kernel.org>
Subject: [PATCH] usb: gadget: configfs: Fix use-after-free issue with udc_name
Date:   Thu, 16 Jul 2020 14:41:06 +0800
Message-ID: <1594881666-8843-1-git-send-email-macpaul.lin@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VGhlcmUgaXMgYSB1c2UtYWZ0ZXItZnJlZSBpc3N1ZSwgaWYgYWNjZXNzIHVkY19uYW1lDQppbiBm
dW5jdGlvbiBnYWRnZXRfZGV2X2Rlc2NfVURDX3N0b3JlIGFmdGVyIGFub3RoZXIgY29udGV4dA0K
ZnJlZSB1ZGNfbmFtZSBpbiBmdW5jdGlvbiB1bnJlZ2lzdGVyX2dhZGdldC4NCg0KQ29udGV4IDE6
DQpnYWRnZXRfZGV2X2Rlc2NfVURDX3N0b3JlKCktPnVucmVnaXN0ZXJfZ2FkZ2V0KCktPg0KZnJl
ZSB1ZGNfbmFtZS0+c2V0IHVkY19uYW1lIHRvIE5VTEwNCg0KQ29udGV4IDI6DQpnYWRnZXRfZGV2
X2Rlc2NfVURDX3Nob3coKS0+IGFjY2VzcyB1ZGNfbmFtZQ0KDQpDYWxsIHRyYWNlOg0KZHVtcF9i
YWNrdHJhY2UrMHgwLzB4MzQwDQpzaG93X3N0YWNrKzB4MTQvMHgxYw0KZHVtcF9zdGFjaysweGU0
LzB4MTM0DQpwcmludF9hZGRyZXNzX2Rlc2NyaXB0aW9uKzB4NzgvMHg0NzgNCl9fa2FzYW5fcmVw
b3J0KzB4MjcwLzB4MmVjDQprYXNhbl9yZXBvcnQrMHgxMC8weDE4DQpfX2FzYW5fcmVwb3J0X2xv
YWQxX25vYWJvcnQrMHgxOC8weDIwDQpzdHJpbmcrMHhmNC8weDEzOA0KdnNucHJpbnRmKzB4NDI4
LzB4MTRkMA0Kc3ByaW50ZisweGU0LzB4MTJjDQpnYWRnZXRfZGV2X2Rlc2NfVURDX3Nob3crMHg1
NC8weDY0DQpjb25maWdmc19yZWFkX2ZpbGUrMHgyMTAvMHgzYTANCl9fdmZzX3JlYWQrMHhmMC8w
eDQ5Yw0KdmZzX3JlYWQrMHgxMzAvMHgyYjQNClN5U19yZWFkKzB4MTE0LzB4MjA4DQplbDBfc3Zj
X25ha2VkKzB4MzQvMHgzOA0KDQpBZGQgbXV0ZXhfbG9jayB0byBwcm90ZWN0IHRoaXMga2luZCBv
ZiBzY2VuYXJpby4NCg0KU2lnbmVkLW9mZi1ieTogRWRkaWUgSHVuZyA8ZWRkaWUuaHVuZ0BtZWRp
YXRlay5jb20+DQpTaWduZWQtb2ZmLWJ5OiBNYWNwYXVsIExpbiA8bWFjcGF1bC5saW5AbWVkaWF0
ZWsuY29tPg0KQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCi0tLQ0KIGRyaXZlcnMvdXNiL2dh
ZGdldC9jb25maWdmcy5jIHwgMTEgKysrKysrKysrLS0NCiAxIGZpbGUgY2hhbmdlZCwgOSBpbnNl
cnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvZ2Fk
Z2V0L2NvbmZpZ2ZzLmMgYi9kcml2ZXJzL3VzYi9nYWRnZXQvY29uZmlnZnMuYw0KaW5kZXggOWRj
MDZhNGUxYjMwLi4yMTExMGIyODY1YjkgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9nYWRnZXQv
Y29uZmlnZnMuYw0KKysrIGIvZHJpdmVycy91c2IvZ2FkZ2V0L2NvbmZpZ2ZzLmMNCkBAIC0yMjEs
OSArMjIxLDE2IEBAIHN0YXRpYyBzc2l6ZV90IGdhZGdldF9kZXZfZGVzY19iY2RVU0Jfc3RvcmUo
c3RydWN0IGNvbmZpZ19pdGVtICppdGVtLA0KIA0KIHN0YXRpYyBzc2l6ZV90IGdhZGdldF9kZXZf
ZGVzY19VRENfc2hvdyhzdHJ1Y3QgY29uZmlnX2l0ZW0gKml0ZW0sIGNoYXIgKnBhZ2UpDQogew0K
LQljaGFyICp1ZGNfbmFtZSA9IHRvX2dhZGdldF9pbmZvKGl0ZW0pLT5jb21wb3NpdGUuZ2FkZ2V0
X2RyaXZlci51ZGNfbmFtZTsNCisJc3RydWN0IGdhZGdldF9pbmZvICpnaSA9IHRvX2dhZGdldF9p
bmZvKGl0ZW0pOw0KKwljaGFyICp1ZGNfbmFtZTsNCisJaW50IHJldDsNCisNCisJbXV0ZXhfbG9j
aygmZ2ktPmxvY2spOw0KKwl1ZGNfbmFtZSA9IGdpLT5jb21wb3NpdGUuZ2FkZ2V0X2RyaXZlci51
ZGNfbmFtZTsNCisJcmV0ID0gc3ByaW50ZihwYWdlLCAiJXNcbiIsIHVkY19uYW1lID86ICIiKTsN
CisJbXV0ZXhfdW5sb2NrKCZnaS0+bG9jayk7DQogDQotCXJldHVybiBzcHJpbnRmKHBhZ2UsICIl
c1xuIiwgdWRjX25hbWUgPzogIiIpOw0KKwlyZXR1cm4gcmV0Ow0KIH0NCiANCiBzdGF0aWMgaW50
IHVucmVnaXN0ZXJfZ2FkZ2V0KHN0cnVjdCBnYWRnZXRfaW5mbyAqZ2kpDQotLSANCjIuMTguMA0K

