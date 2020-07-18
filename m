Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B14224810
	for <lists+stable@lfdr.de>; Sat, 18 Jul 2020 04:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgGRCpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 22:45:17 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:56016 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726742AbgGRCpR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jul 2020 22:45:17 -0400
X-UUID: f2b1f400fbb7493d8e2f8c85de7bd2f1-20200718
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=JJ5o+WFe3CVKnlVdykIeEjsdjGfkUl9MSJCZgz3eF2c=;
        b=h6JqILvmrVsxfhR1S5A3n9e/L1cwpXlmhF1eG/kO4ynP2Bsx/fIlOHDXdBLAQkOw2EwU0vFwTMHCjmRSr7EwZo3tuVoF+zFb+S9B95qrIj+wFoko8Kk6EBa+XonE2kfVGf852Uz/da6Cp377oyfkC6c+VdPZR4b4UaU0bJoA4OU=;
X-UUID: f2b1f400fbb7493d8e2f8c85de7bd2f1-20200718
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1127202755; Sat, 18 Jul 2020 10:45:12 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 18 Jul 2020 10:45:09 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 18 Jul 2020 10:45:10 +0800
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
Subject: [PATCH v2] usb: gadget: configfs: Fix use-after-free issue with udc_name
Date:   Sat, 18 Jul 2020 10:45:03 +0800
Message-ID: <1595040303-23046-1-git-send-email-macpaul.lin@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1594881666-8843-1-git-send-email-macpaul.lin@mediatek.com>
References: <1594881666-8843-1-git-send-email-macpaul.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 7A91C36DAFF4860455E96955268D0533348A3C2AFE1C668A6C271346DB2534C92000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogRWRkaWUgSHVuZyA8ZWRkaWUuaHVuZ0BtZWRpYXRlay5jb20+DQoNClRoZXJlIGlzIGEg
dXNlLWFmdGVyLWZyZWUgaXNzdWUsIGlmIGFjY2VzcyB1ZGNfbmFtZQ0KaW4gZnVuY3Rpb24gZ2Fk
Z2V0X2Rldl9kZXNjX1VEQ19zdG9yZSBhZnRlciBhbm90aGVyIGNvbnRleHQNCmZyZWUgdWRjX25h
bWUgaW4gZnVuY3Rpb24gdW5yZWdpc3Rlcl9nYWRnZXQuDQoNCkNvbnRleHQgMToNCmdhZGdldF9k
ZXZfZGVzY19VRENfc3RvcmUoKS0+dW5yZWdpc3Rlcl9nYWRnZXQoKS0+DQpmcmVlIHVkY19uYW1l
LT5zZXQgdWRjX25hbWUgdG8gTlVMTA0KDQpDb250ZXh0IDI6DQpnYWRnZXRfZGV2X2Rlc2NfVURD
X3Nob3coKS0+IGFjY2VzcyB1ZGNfbmFtZQ0KDQpDYWxsIHRyYWNlOg0KZHVtcF9iYWNrdHJhY2Ur
MHgwLzB4MzQwDQpzaG93X3N0YWNrKzB4MTQvMHgxYw0KZHVtcF9zdGFjaysweGU0LzB4MTM0DQpw
cmludF9hZGRyZXNzX2Rlc2NyaXB0aW9uKzB4NzgvMHg0NzgNCl9fa2FzYW5fcmVwb3J0KzB4Mjcw
LzB4MmVjDQprYXNhbl9yZXBvcnQrMHgxMC8weDE4DQpfX2FzYW5fcmVwb3J0X2xvYWQxX25vYWJv
cnQrMHgxOC8weDIwDQpzdHJpbmcrMHhmNC8weDEzOA0KdnNucHJpbnRmKzB4NDI4LzB4MTRkMA0K
c3ByaW50ZisweGU0LzB4MTJjDQpnYWRnZXRfZGV2X2Rlc2NfVURDX3Nob3crMHg1NC8weDY0DQpj
b25maWdmc19yZWFkX2ZpbGUrMHgyMTAvMHgzYTANCl9fdmZzX3JlYWQrMHhmMC8weDQ5Yw0KdmZz
X3JlYWQrMHgxMzAvMHgyYjQNClN5U19yZWFkKzB4MTE0LzB4MjA4DQplbDBfc3ZjX25ha2VkKzB4
MzQvMHgzOA0KDQpBZGQgbXV0ZXhfbG9jayB0byBwcm90ZWN0IHRoaXMga2luZCBvZiBzY2VuYXJp
by4NCg0KU2lnbmVkLW9mZi1ieTogRWRkaWUgSHVuZyA8ZWRkaWUuaHVuZ0BtZWRpYXRlay5jb20+
DQpTaWduZWQtb2ZmLWJ5OiBNYWNwYXVsIExpbiA8bWFjcGF1bC5saW5AbWVkaWF0ZWsuY29tPg0K
UmV2aWV3ZWQtYnk6IFBldGVyIENoZW4gPHBldGVyLmNoZW5AbnhwLmNvbT4NCkNjOiBzdGFibGVA
dmdlci5rZXJuZWwub3JnDQotLS0NCkNoYW5nZXMgZm9yIHYyOg0KICAtIEZpeCB0eXBvICVzL2Nv
bnRleC9jb250ZXh0LCBUaGFua3MgUGV0ZXIuDQoNCiBkcml2ZXJzL3VzYi9nYWRnZXQvY29uZmln
ZnMuYyB8IDExICsrKysrKysrKy0tDQogMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwg
MiBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2dhZGdldC9jb25maWdm
cy5jIGIvZHJpdmVycy91c2IvZ2FkZ2V0L2NvbmZpZ2ZzLmMNCmluZGV4IDlkYzA2YTRlMWIzMC4u
MjExMTBiMjg2NWI5IDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2IvZ2FkZ2V0L2NvbmZpZ2ZzLmMN
CisrKyBiL2RyaXZlcnMvdXNiL2dhZGdldC9jb25maWdmcy5jDQpAQCAtMjIxLDkgKzIyMSwxNiBA
QCBzdGF0aWMgc3NpemVfdCBnYWRnZXRfZGV2X2Rlc2NfYmNkVVNCX3N0b3JlKHN0cnVjdCBjb25m
aWdfaXRlbSAqaXRlbSwNCiANCiBzdGF0aWMgc3NpemVfdCBnYWRnZXRfZGV2X2Rlc2NfVURDX3No
b3coc3RydWN0IGNvbmZpZ19pdGVtICppdGVtLCBjaGFyICpwYWdlKQ0KIHsNCi0JY2hhciAqdWRj
X25hbWUgPSB0b19nYWRnZXRfaW5mbyhpdGVtKS0+Y29tcG9zaXRlLmdhZGdldF9kcml2ZXIudWRj
X25hbWU7DQorCXN0cnVjdCBnYWRnZXRfaW5mbyAqZ2kgPSB0b19nYWRnZXRfaW5mbyhpdGVtKTsN
CisJY2hhciAqdWRjX25hbWU7DQorCWludCByZXQ7DQorDQorCW11dGV4X2xvY2soJmdpLT5sb2Nr
KTsNCisJdWRjX25hbWUgPSBnaS0+Y29tcG9zaXRlLmdhZGdldF9kcml2ZXIudWRjX25hbWU7DQor
CXJldCA9IHNwcmludGYocGFnZSwgIiVzXG4iLCB1ZGNfbmFtZSA/OiAiIik7DQorCW11dGV4X3Vu
bG9jaygmZ2ktPmxvY2spOw0KIA0KLQlyZXR1cm4gc3ByaW50ZihwYWdlLCAiJXNcbiIsIHVkY19u
YW1lID86ICIiKTsNCisJcmV0dXJuIHJldDsNCiB9DQogDQogc3RhdGljIGludCB1bnJlZ2lzdGVy
X2dhZGdldChzdHJ1Y3QgZ2FkZ2V0X2luZm8gKmdpKQ0KLS0gDQoyLjE4LjANCg==

