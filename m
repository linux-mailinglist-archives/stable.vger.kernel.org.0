Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F2829E23C
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 03:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387528AbgJ2CL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 22:11:58 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:60972 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726823AbgJ1Vgc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 17:36:32 -0400
X-UUID: 8a47760e811a42968c2e7d60a0a6ab76-20201029
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=RYETYlae4iO6GU8GFOfcOxXXaKOlfrIac/CifbWh6Vw=;
        b=BjHkX+IvZPgDq+7JzGY+nHP0lymaLmxvm7712hpivokjnbcG9pXavwuBJY2EHf4kRStgk6gt9oYkIkvOrwlB2Ov3avlTvb605Pgcn4pq9oJIUSaWRNXF0rJ3DMvfeRyTM4L6FN+TcB3LBa91I1V3baaZgCNVr6Fzy0veKzoIiB8=;
X-UUID: 8a47760e811a42968c2e7d60a0a6ab76-20201029
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 496800390; Thu, 29 Oct 2020 01:55:36 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 29 Oct 2020 01:55:27 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 29 Oct 2020 01:55:27 +0800
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     <macpaul@gmail.com>, <chunfeng.yun@mediatek.com>,
        <eddie.hung@mediatek.com>
CC:     Ainge Hsu <ainge.hsu@mediatek.com>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Macpaul Lin <macpaul.lin@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <stable@vger.kernel.org>
Subject: [PATCH v2] usb: gadget: configfs: Fix use-after-free issue with udc_name
Date:   Thu, 29 Oct 2020 01:55:23 +0800
Message-ID: <1603907723-19499-1-git-send-email-macpaul.lin@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 8BA88157233FE31D320A44BF339572E794FB14D30A408FA9247CAD67040C28E02000:8
X-MTK:  N
Content-Transfer-Encoding: base64
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
ZnMuYyB8ICAgMTEgKysrKysrKysrLS0NCiAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCsp
LCAyIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvZ2FkZ2V0L2NvbmZp
Z2ZzLmMgYi9kcml2ZXJzL3VzYi9nYWRnZXQvY29uZmlnZnMuYw0KaW5kZXggNTYwNTFiYi4uZDk3
NDNmNCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL2dhZGdldC9jb25maWdmcy5jDQorKysgYi9k
cml2ZXJzL3VzYi9nYWRnZXQvY29uZmlnZnMuYw0KQEAgLTIyMSw5ICsyMjEsMTYgQEAgc3RhdGlj
IHNzaXplX3QgZ2FkZ2V0X2Rldl9kZXNjX2JjZFVTQl9zdG9yZShzdHJ1Y3QgY29uZmlnX2l0ZW0g
Kml0ZW0sDQogDQogc3RhdGljIHNzaXplX3QgZ2FkZ2V0X2Rldl9kZXNjX1VEQ19zaG93KHN0cnVj
dCBjb25maWdfaXRlbSAqaXRlbSwgY2hhciAqcGFnZSkNCiB7DQotCWNoYXIgKnVkY19uYW1lID0g
dG9fZ2FkZ2V0X2luZm8oaXRlbSktPmNvbXBvc2l0ZS5nYWRnZXRfZHJpdmVyLnVkY19uYW1lOw0K
KwlzdHJ1Y3QgZ2FkZ2V0X2luZm8gKmdpID0gdG9fZ2FkZ2V0X2luZm8oaXRlbSk7DQorCWNoYXIg
KnVkY19uYW1lOw0KKwlpbnQgcmV0Ow0KKw0KKwltdXRleF9sb2NrKCZnaS0+bG9jayk7DQorCXVk
Y19uYW1lID0gZ2ktPmNvbXBvc2l0ZS5nYWRnZXRfZHJpdmVyLnVkY19uYW1lOw0KKwlyZXQgPSBz
cHJpbnRmKHBhZ2UsICIlc1xuIiwgdWRjX25hbWUgPzogIiIpOw0KKwltdXRleF91bmxvY2soJmdp
LT5sb2NrKTsNCiANCi0JcmV0dXJuIHNwcmludGYocGFnZSwgIiVzXG4iLCB1ZGNfbmFtZSA/OiAi
Iik7DQorCXJldHVybiByZXQ7DQogfQ0KIA0KIHN0YXRpYyBpbnQgdW5yZWdpc3Rlcl9nYWRnZXQo
c3RydWN0IGdhZGdldF9pbmZvICpnaSkNCi0tIA0KMS43LjkuNQ0K

