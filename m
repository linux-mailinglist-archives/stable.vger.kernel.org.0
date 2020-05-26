Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8481C164C
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731667AbgEANnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:43:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731202AbgEANnn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:43:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3030220757;
        Fri,  1 May 2020 13:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340622;
        bh=7g/jw1lz9nBCPnJxSDyrXpuKePqfwHY6vdhVTsfL3Bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eQMEYlnJ0cOFVZ+xg1lb47EO2+KgpFgf6T6+e3Pc7jjyHUli9aaLoMVqhjuG7erML
         /Z9ysOM0gt6Wnq3Mcjbii8zPY7zoBm2WA9s0K+mbWkLga3AnY04dPKSIT4JgX4KgVm
         cLWt6M0t55Qu5RRxYZefwJG++6/6/aqUqQrvzxUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 069/106] net: fec: set GPR bit on suspend by DT configuration.
Date:   Fri,  1 May 2020 15:23:42 +0200
Message-Id: <20200501131552.533350984@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Fuzzey <martin.fuzzey@flowbird.group>

[ Upstream commit da722186f6549d752ea5b5fbc18111833c81a133 ]

On some SoCs, such as the i.MX6, it is necessary to set a bit
in the SoC level GPR register before suspending for wake on lan
to work.

The fec platform callback sleep_mode_enable was intended to allow this
but the platform implementation was NAK'd back in 2015 [1]

This means that, currently, wake on lan is broken on mainline for
the i.MX6 at least.

So implement the required bit setting in the fec driver by itself
by adding a new optional DT property indicating the GPR register
and adding the offset and bit information to the driver.

[1] https://www.spinics.net/lists/netdev/msg310922.html

Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec.h      |   7 +
 drivers/net/ethernet/freescale/fec_main.c | 149 +++++++++++++++++-----
 2 files changed, 127 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index f79e57f735b39..d89568f810bc4 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -488,6 +488,12 @@ struct fec_enet_priv_rx_q {
 	struct  sk_buff *rx_skbuff[RX_RING_SIZE];
 };
 
+struct fec_stop_mode_gpr {
+	struct regmap *gpr;
+	u8 reg;
+	u8 bit;
+};
+
 /* The FEC buffer descriptors track the ring buffers.  The rx_bd_base and
  * tx_bd_base always point to the base of the buffer descriptors.  The
  * cur_rx and cur_tx point to the currently available buffer.
@@ -562,6 +568,7 @@ struct fec_enet_private {
 	int hwts_tx_en;
 	struct delayed_work time_keep;
 	struct regulator *reg_phy;
+	struct fec_stop_mode_gpr stop_gpr;
 
 	unsigned int tx_align;
 	unsigned int rx_align;
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 23c5fef2f1ad1..869efbb6c4d0b 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -62,6 +62,8 @@
 #include <linux/if_vlan.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/prefetch.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
 #include <soc/imx/cpuidle.h>
 
 #include <asm/cacheflush.h>
@@ -84,6 +86,56 @@ static void fec_enet_itr_coal_init(struct net_device *ndev);
 #define FEC_ENET_OPD_V	0xFFF0
 #define FEC_MDIO_PM_TIMEOUT  100 /* ms */
 
+struct fec_devinfo {
+	u32 quirks;
+	u8 stop_gpr_reg;
+	u8 stop_gpr_bit;
+};
+
+static const struct fec_devinfo fec_imx25_info = {
+	.quirks = FEC_QUIRK_USE_GASKET | FEC_QUIRK_MIB_CLEAR |
+		  FEC_QUIRK_HAS_FRREG,
+};
+
+static const struct fec_devinfo fec_imx27_info = {
+	.quirks = FEC_QUIRK_MIB_CLEAR | FEC_QUIRK_HAS_FRREG,
+};
+
+static const struct fec_devinfo fec_imx28_info = {
+	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_SWAP_FRAME |
+		  FEC_QUIRK_SINGLE_MDIO | FEC_QUIRK_HAS_RACC |
+		  FEC_QUIRK_HAS_FRREG,
+};
+
+static const struct fec_devinfo fec_imx6q_info = {
+	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
+		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
+		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR006358 |
+		  FEC_QUIRK_HAS_RACC,
+	.stop_gpr_reg = 0x34,
+	.stop_gpr_bit = 27,
+};
+
+static const struct fec_devinfo fec_mvf600_info = {
+	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_RACC,
+};
+
+static const struct fec_devinfo fec_imx6x_info = {
+	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
+		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
+		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
+		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
+		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE,
+};
+
+static const struct fec_devinfo fec_imx6ul_info = {
+	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
+		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
+		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR007885 |
+		  FEC_QUIRK_BUG_CAPTURE | FEC_QUIRK_HAS_RACC |
+		  FEC_QUIRK_HAS_COALESCE,
+};
+
 static struct platform_device_id fec_devtype[] = {
 	{
 		/* keep it for coldfire */
@@ -91,39 +143,25 @@ static struct platform_device_id fec_devtype[] = {
 		.driver_data = 0,
 	}, {
 		.name = "imx25-fec",
-		.driver_data = FEC_QUIRK_USE_GASKET | FEC_QUIRK_MIB_CLEAR |
-			       FEC_QUIRK_HAS_FRREG,
+		.driver_data = (kernel_ulong_t)&fec_imx25_info,
 	}, {
 		.name = "imx27-fec",
-		.driver_data = FEC_QUIRK_MIB_CLEAR | FEC_QUIRK_HAS_FRREG,
+		.driver_data = (kernel_ulong_t)&fec_imx27_info,
 	}, {
 		.name = "imx28-fec",
-		.driver_data = FEC_QUIRK_ENET_MAC | FEC_QUIRK_SWAP_FRAME |
-				FEC_QUIRK_SINGLE_MDIO | FEC_QUIRK_HAS_RACC |
-				FEC_QUIRK_HAS_FRREG,
+		.driver_data = (kernel_ulong_t)&fec_imx28_info,
 	}, {
 		.name = "imx6q-fec",
-		.driver_data = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
-				FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
-				FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR006358 |
-				FEC_QUIRK_HAS_RACC,
+		.driver_data = (kernel_ulong_t)&fec_imx6q_info,
 	}, {
 		.name = "mvf600-fec",
-		.driver_data = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_RACC,
+		.driver_data = (kernel_ulong_t)&fec_mvf600_info,
 	}, {
 		.name = "imx6sx-fec",
-		.driver_data = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
-				FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
-				FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
-				FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
-				FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE,
+		.driver_data = (kernel_ulong_t)&fec_imx6x_info,
 	}, {
 		.name = "imx6ul-fec",
-		.driver_data = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
-				FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
-				FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR007885 |
-				FEC_QUIRK_BUG_CAPTURE | FEC_QUIRK_HAS_RACC |
-				FEC_QUIRK_HAS_COALESCE,
+		.driver_data = (kernel_ulong_t)&fec_imx6ul_info,
 	}, {
 		/* sentinel */
 	}
@@ -1092,11 +1130,28 @@ fec_restart(struct net_device *ndev)
 
 }
 
+static void fec_enet_stop_mode(struct fec_enet_private *fep, bool enabled)
+{
+	struct fec_platform_data *pdata = fep->pdev->dev.platform_data;
+	struct fec_stop_mode_gpr *stop_gpr = &fep->stop_gpr;
+
+	if (stop_gpr->gpr) {
+		if (enabled)
+			regmap_update_bits(stop_gpr->gpr, stop_gpr->reg,
+					   BIT(stop_gpr->bit),
+					   BIT(stop_gpr->bit));
+		else
+			regmap_update_bits(stop_gpr->gpr, stop_gpr->reg,
+					   BIT(stop_gpr->bit), 0);
+	} else if (pdata && pdata->sleep_mode_enable) {
+		pdata->sleep_mode_enable(enabled);
+	}
+}
+
 static void
 fec_stop(struct net_device *ndev)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	struct fec_platform_data *pdata = fep->pdev->dev.platform_data;
 	u32 rmii_mode = readl(fep->hwp + FEC_R_CNTRL) & (1 << 8);
 	u32 val;
 
@@ -1125,9 +1180,7 @@ fec_stop(struct net_device *ndev)
 		val = readl(fep->hwp + FEC_ECNTRL);
 		val |= (FEC_ECR_MAGICEN | FEC_ECR_SLEEP);
 		writel(val, fep->hwp + FEC_ECNTRL);
-
-		if (pdata && pdata->sleep_mode_enable)
-			pdata->sleep_mode_enable(true);
+		fec_enet_stop_mode(fep, true);
 	}
 	writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
 
@@ -3397,6 +3450,37 @@ static int fec_enet_get_irq_cnt(struct platform_device *pdev)
 	return irq_cnt;
 }
 
+static int fec_enet_init_stop_mode(struct fec_enet_private *fep,
+				   struct fec_devinfo *dev_info,
+				   struct device_node *np)
+{
+	struct device_node *gpr_np;
+	int ret = 0;
+
+	if (!dev_info)
+		return 0;
+
+	gpr_np = of_parse_phandle(np, "gpr", 0);
+	if (!gpr_np)
+		return 0;
+
+	fep->stop_gpr.gpr = syscon_node_to_regmap(gpr_np);
+	if (IS_ERR(fep->stop_gpr.gpr)) {
+		dev_err(&fep->pdev->dev, "could not find gpr regmap\n");
+		ret = PTR_ERR(fep->stop_gpr.gpr);
+		fep->stop_gpr.gpr = NULL;
+		goto out;
+	}
+
+	fep->stop_gpr.reg = dev_info->stop_gpr_reg;
+	fep->stop_gpr.bit = dev_info->stop_gpr_bit;
+
+out:
+	of_node_put(gpr_np);
+
+	return ret;
+}
+
 static int
 fec_probe(struct platform_device *pdev)
 {
@@ -3412,6 +3496,7 @@ fec_probe(struct platform_device *pdev)
 	int num_rx_qs;
 	char irq_name[8];
 	int irq_cnt;
+	struct fec_devinfo *dev_info;
 
 	fec_enet_get_queue_num(pdev, &num_tx_qs, &num_rx_qs);
 
@@ -3429,7 +3514,9 @@ fec_probe(struct platform_device *pdev)
 	of_id = of_match_device(fec_dt_ids, &pdev->dev);
 	if (of_id)
 		pdev->id_entry = of_id->data;
-	fep->quirks = pdev->id_entry->driver_data;
+	dev_info = (struct fec_devinfo *)pdev->id_entry->driver_data;
+	if (dev_info)
+		fep->quirks = dev_info->quirks;
 
 	fep->netdev = ndev;
 	fep->num_rx_queues = num_rx_qs;
@@ -3463,6 +3550,10 @@ fec_probe(struct platform_device *pdev)
 	if (of_get_property(np, "fsl,magic-packet", NULL))
 		fep->wol_flag |= FEC_WOL_HAS_MAGIC_PACKET;
 
+	ret = fec_enet_init_stop_mode(fep, dev_info, np);
+	if (ret)
+		goto failed_stop_mode;
+
 	phy_node = of_parse_phandle(np, "phy-handle", 0);
 	if (!phy_node && of_phy_is_fixed_link(np)) {
 		ret = of_phy_register_fixed_link(np);
@@ -3631,6 +3722,7 @@ failed_clk:
 	if (of_phy_is_fixed_link(np))
 		of_phy_deregister_fixed_link(np);
 	of_node_put(phy_node);
+failed_stop_mode:
 failed_phy:
 	dev_id--;
 failed_ioremap:
@@ -3708,7 +3800,6 @@ static int __maybe_unused fec_resume(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	struct fec_platform_data *pdata = fep->pdev->dev.platform_data;
 	int ret;
 	int val;
 
@@ -3726,8 +3817,8 @@ static int __maybe_unused fec_resume(struct device *dev)
 			goto failed_clk;
 		}
 		if (fep->wol_flag & FEC_WOL_FLAG_ENABLE) {
-			if (pdata && pdata->sleep_mode_enable)
-				pdata->sleep_mode_enable(false);
+			fec_enet_stop_mode(fep, false);
+
 			val = readl(fep->hwp + FEC_ECNTRL);
 			val &= ~(FEC_ECR_MAGICEN | FEC_ECR_SLEEP);
 			writel(val, fep->hwp + FEC_ECNTRL);
-- 
2.20.1



