Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E938F7979A
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390730AbfG2TvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:51:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390468AbfG2TvE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:51:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92C5F217D7;
        Mon, 29 Jul 2019 19:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429863;
        bh=xOnV7f5ym/exTxlja/kuIQvzOZ45BlGKnjTMMzCfWHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=miGxDseOVteeespgNvP8EdbPN3HUVKBWtQoYeoj8KDyBlKltPH7tiAY/OzjL9IZYb
         K94tgky8neSbOyqS+3pRsh0yD5G9Wj+XQ2ff2Fif4xz3MzWzTjeMr34scvdNmHu5Tu
         FaveKkDfcFSNFTuMbBsMUC8xjVQkSxSjumlJZvuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 080/215] phy: renesas: rcar-gen3-usb2: fix imbalance powered flag
Date:   Mon, 29 Jul 2019 21:21:16 +0200
Message-Id: <20190729190753.662264113@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5c9dc6379f539c68a0fdd39e39a9d359545649e9 ]

The powered flag should be set for any other phys anyway. Also
the flag should be locked by the channel. Otherwise, after we have
revised the device tree for the usb phy, the following warning
happened during a second system suspend. And if the driver doesn't
lock the flag, an imbalance is possible when enabling the regulator
during system resume. So, this patch fixes the issues.

< The warning >
[   56.026531] unbalanced disables for USB20_VBUS0
[   56.031108] WARNING: CPU: 3 PID: 513 at drivers/regulator/core.c:2593 _regula
tor_disable+0xe0/0x1c0
[   56.040146] Modules linked in: rcar_du_drm rcar_lvds drm_kms_helper drm drm_p
anel_orientation_quirks vsp1 videobuf2_vmalloc videobuf2_dma_contig videobuf2_me
mops videobuf2_v4l2 videobuf2_common videodev snd_soc_rcar renesas_usbhs snd_soc
_audio_graph_card media snd_soc_simple_card_utils crct10dif_ce renesas_usb3 snd_
soc_ak4613 rcar_fcp pwm_rcar usb_dmac phy_rcar_gen3_usb3 pwm_bl ipv6
[   56.074047] CPU: 3 PID: 513 Comm: kworker/u16:19 Not tainted 5.2.0-rc3-00001-
g5f20a19 #6
[   56.082129] Hardware name: Renesas Salvator-X board based on r8a7795 ES2.0+ (
DT)
[   56.089524] Workqueue: events_unbound async_run_entry_fn
[   56.094832] pstate: 40000005 (nZcv daif -PAN -UAO)
[   56.099617] pc : _regulator_disable+0xe0/0x1c0
[   56.104054] lr : _regulator_disable+0xe0/0x1c0
[   56.108489] sp : ffff0000121c3ae0
[   56.111796] x29: ffff0000121c3ae0 x28: 0000000000000000
[   56.117102] x27: 0000000000000000 x26: ffff000010fe0e60
[   56.122407] x25: 0000000000000002 x24: 0000000000000001
[   56.127712] x23: 0000000000000002 x22: ffff8006f99d4000
[   56.133017] x21: ffff8006f99cc000 x20: ffff8006f9846800
[   56.138322] x19: ffff8006f9846800 x18: ffffffffffffffff
[   56.143626] x17: 0000000000000000 x16: 0000000000000000
[   56.148931] x15: ffff0000112f96c8 x14: ffff0000921c37f7
[   56.154235] x13: ffff0000121c3805 x12: ffff000011312000
[   56.159540] x11: 0000000005f5e0ff x10: ffff0000112f9f20
[   56.164844] x9 : ffff0000112d3018 x8 : 00000000000001ad
[   56.170149] x7 : 00000000ffffffcc x6 : ffff8006ff768180
[   56.175453] x5 : ffff8006ff768180 x4 : 0000000000000000
[   56.180758] x3 : ffff8006ff76ef10 x2 : ffff8006ff768180
[   56.186062] x1 : 3d2eccbaead8fb00 x0 : 0000000000000000
[   56.191367] Call trace:
[   56.193808]  _regulator_disable+0xe0/0x1c0
[   56.197899]  regulator_disable+0x40/0x78
[   56.201820]  rcar_gen3_phy_usb2_power_off+0x3c/0x50
[   56.206692]  phy_power_off+0x48/0xd8
[   56.210263]  usb_phy_roothub_power_off+0x30/0x50
[   56.214873]  usb_phy_roothub_suspend+0x1c/0x50
[   56.219311]  hcd_bus_suspend+0x13c/0x168
[   56.223226]  generic_suspend+0x4c/0x58
[   56.226969]  usb_suspend_both+0x1ac/0x238
[   56.230972]  usb_suspend+0xcc/0x170
[   56.234455]  usb_dev_suspend+0x10/0x18
[   56.238199]  dpm_run_callback.isra.6+0x20/0x68
[   56.242635]  __device_suspend+0x110/0x308
[   56.246637]  async_suspend+0x24/0xa8
[   56.250205]  async_run_entry_fn+0x40/0xf8
[   56.254210]  process_one_work+0x1e0/0x320
[   56.258211]  worker_thread+0x40/0x450
[   56.261867]  kthread+0x124/0x128
[   56.265094]  ret_from_fork+0x10/0x18
[   56.268661] ---[ end trace 86d7ec5de5c517af ]---
[   56.273290] phy phy-ee080200.usb-phy.10: phy poweroff failed --> -5

Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Fixes: 549b6b55b005 ("phy: renesas: rcar-gen3-usb2: enable/disable independent irqs")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/renesas/phy-rcar-gen3-usb2.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/phy/renesas/phy-rcar-gen3-usb2.c b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
index 1322185a00a2..8ffba67568ec 100644
--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -13,6 +13,7 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_device.h>
@@ -106,6 +107,7 @@ struct rcar_gen3_chan {
 	struct rcar_gen3_phy rphys[NUM_OF_PHYS];
 	struct regulator *vbus;
 	struct work_struct work;
+	struct mutex lock;	/* protects rphys[...].powered */
 	enum usb_dr_mode dr_mode;
 	bool extcon_host;
 	bool is_otg_channel;
@@ -437,15 +439,16 @@ static int rcar_gen3_phy_usb2_power_on(struct phy *p)
 	struct rcar_gen3_chan *channel = rphy->ch;
 	void __iomem *usb2_base = channel->base;
 	u32 val;
-	int ret;
+	int ret = 0;
 
+	mutex_lock(&channel->lock);
 	if (!rcar_gen3_are_all_rphys_power_off(channel))
-		return 0;
+		goto out;
 
 	if (channel->vbus) {
 		ret = regulator_enable(channel->vbus);
 		if (ret)
-			return ret;
+			goto out;
 	}
 
 	val = readl(usb2_base + USB2_USBCTR);
@@ -454,7 +457,10 @@ static int rcar_gen3_phy_usb2_power_on(struct phy *p)
 	val &= ~USB2_USBCTR_PLL_RST;
 	writel(val, usb2_base + USB2_USBCTR);
 
+out:
+	/* The powered flag should be set for any other phys anyway */
 	rphy->powered = true;
+	mutex_unlock(&channel->lock);
 
 	return 0;
 }
@@ -465,14 +471,18 @@ static int rcar_gen3_phy_usb2_power_off(struct phy *p)
 	struct rcar_gen3_chan *channel = rphy->ch;
 	int ret = 0;
 
+	mutex_lock(&channel->lock);
 	rphy->powered = false;
 
 	if (!rcar_gen3_are_all_rphys_power_off(channel))
-		return 0;
+		goto out;
 
 	if (channel->vbus)
 		ret = regulator_disable(channel->vbus);
 
+out:
+	mutex_unlock(&channel->lock);
+
 	return ret;
 }
 
@@ -639,6 +649,7 @@ static int rcar_gen3_phy_usb2_probe(struct platform_device *pdev)
 	if (!phy_usb2_ops)
 		return -EINVAL;
 
+	mutex_init(&channel->lock);
 	for (i = 0; i < NUM_OF_PHYS; i++) {
 		channel->rphys[i].phy = devm_phy_create(dev, NULL,
 							phy_usb2_ops);
-- 
2.20.1



