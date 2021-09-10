Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2473540677B
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 09:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbhIJHJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 03:09:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231223AbhIJHJz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 03:09:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A311610A3;
        Fri, 10 Sep 2021 07:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631257725;
        bh=ggmRSlHkCf7unR5afcCIn9DYAQ6rtApOYK1/Rrn5Iow=;
        h=Subject:To:Cc:From:Date:From;
        b=DcyuoHtZ94ax4YsqG+p9Nk4nlJrmLwAkzHlwli+a5M4rM/udXgRgvBNkf4n+L6TS2
         V7HCRMXZrfVTJM/xxmDA0/ZZG+ixiLWLFPp8FUpgTlH18OWbJOIH6uzzWeS+7yoOU5
         9oh/TnKkUerhCOOwDzoxzJfIX+TaBg5jzvF3oUGE=
Subject: FAILED: patch "[PATCH] usb: mtu3: fix random remote wakeup" failed to apply to 5.14-stable tree
To:     chunfeng.yun@mediatek.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Sep 2021 09:08:34 +0200
Message-ID: <1631257714220236@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d98a30ccdc839947c9233369744341d1fa54439c Mon Sep 17 00:00:00 2001
From: Chunfeng Yun <chunfeng.yun@mediatek.com>
Date: Thu, 26 Aug 2021 16:36:37 +0800
Subject: [PATCH] usb: mtu3: fix random remote wakeup

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
Link: https://lore.kernel.org/r/20210826083637.33237-2-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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

