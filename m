Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6365F3F83D1
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 10:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240599AbhHZIhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 04:37:32 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:38492 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S240553AbhHZIhb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 04:37:31 -0400
X-UUID: bcf457f132894c0184f84c3462320614-20210826
X-UUID: bcf457f132894c0184f84c3462320614-20210826
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1107208688; Thu, 26 Aug 2021 16:36:40 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 26 Aug 2021 16:36:38 +0800
Received: from mtkslt301.mediatek.inc (10.21.14.114) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 26 Aug 2021 16:36:38 +0800
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Eddie Hung <eddie.hung@mediatek.com>, <stable@vger.kernel.org>
Subject: [PATCH next 2/2] usb: mtu3: fix random remote wakeup
Date:   Thu, 26 Aug 2021 16:36:37 +0800
Message-ID: <20210826083637.33237-2-chunfeng.yun@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20210826083637.33237-1-chunfeng.yun@mediatek.com>
References: <20210826083637.33237-1-chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some platforms, e.g. 8183/8192, use low level latch way to keep
wakeup signal, it may latch a wrong signal if debounce more time,
and enable wakeup earlier.
                   ____________________
ip_sleep      ____/                    \__________
                           ___________________
wakeup_signal ____________/                   \______
                      _______________________________
wakeup_en     _______/
                      ^     ^
                      |(1)  |(2)
latch wakeup_signal mistakenly at (1), should latch it at (2);

Workaround: delay about 100us to enable wakeup, meanwhile decrease
debounce time.

Fixes: b1a344589eea ("usb: mtu3: support ip-sleep wakeup for MT8183")
Cc: stable@vger.kernel.org
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
---
 drivers/usb/mtu3/mtu3_host.c | 2 +-
 drivers/usb/mtu3/mtu3_plat.c | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/mtu3/mtu3_host.c b/drivers/usb/mtu3/mtu3_host.c
index 7d528f3c2482..f3903367a6a0 100644
--- a/drivers/usb/mtu3/mtu3_host.c
+++ b/drivers/usb/mtu3/mtu3_host.c
@@ -62,7 +62,7 @@ static void ssusb_wakeup_ip_sleep_set(struct ssusb_mtk *ssusb, bool enable)
 	case SSUSB_UWK_V1_1:
 		reg = ssusb->uwk_reg_base + PERI_WK_CTRL0;
 		msk = WC0_IS_EN | WC0_IS_C(0xf) | WC0_IS_P;
-		val = enable ? (WC0_IS_EN | WC0_IS_C(0x8)) : 0;
+		val = enable ? (WC0_IS_EN | WC0_IS_C(0x1)) : 0;
 		break;
 	case SSUSB_UWK_V1_2:
 		reg = ssusb->uwk_reg_base + PERI_WK_CTRL0;
diff --git a/drivers/usb/mtu3/mtu3_plat.c b/drivers/usb/mtu3/mtu3_plat.c
index 5b3f7f73cb40..f13531022f4a 100644
--- a/drivers/usb/mtu3/mtu3_plat.c
+++ b/drivers/usb/mtu3/mtu3_plat.c
@@ -63,6 +63,9 @@ static int wait_for_ip_sleep(struct ssusb_mtk *ssusb)
 	if (ret) {
 		dev_err(ssusb->dev, "ip sleep failed!!!\n");
 		ret = -EBUSY;
+	} else {
+		/* workaround: avoid wrong wakeup signal latch for some soc */
+		usleep_range(100, 200);
 	}
 
 	return ret;
-- 
2.18.0

