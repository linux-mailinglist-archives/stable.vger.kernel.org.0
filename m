Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103F64316CC
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 13:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhJRLHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 07:07:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229781AbhJRLHG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 07:07:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F41526103C;
        Mon, 18 Oct 2021 11:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634555095;
        bh=qB4EuNxKfZuNAjOK+UeKZxQL3mA0hlkg+HHA2d9Y/14=;
        h=Subject:To:Cc:From:Date:From;
        b=BRxq8rx7cpCi44+52lpFOt3i4Mts21fP9HxKrcMabBUI52wK0P/MccJhx4otvGUIF
         mE+ec0OUxUhO3BotNoJNSIPF9S0vFKvYAQ2rcSgiTk0Y14KRiRu3X2GHEDUCpWN3xA
         28HP0Gkg+JZsgRYEowgGuDLnDomZj3Nb6R8vyqxs=
Subject: FAILED: patch "[PATCH] net: stmmac: fix get_hw_feature() on old hardware" failed to apply to 4.19-stable tree
To:     herve.codina@bootlin.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 13:04:45 +0200
Message-ID: <163455508537131@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 075da584bae2da6a37428d59a477b6bdad430ac3 Mon Sep 17 00:00:00 2001
From: Herve Codina <herve.codina@bootlin.com>
Date: Fri, 8 Oct 2021 12:34:37 +0200
Subject: [PATCH] net: stmmac: fix get_hw_feature() on old hardware

Some old IPs do not provide the hardware feature register.
On these IPs, this register is read 0x00000000.

In old driver version, this feature was handled but a regression came
with the commit f10a6a3541b4 ("stmmac: rework get_hw_feature function").
Indeed, this commit removes the return value in dma->get_hw_feature().
This return value was used to indicate the validity of retrieved
information and used later on in stmmac_hw_init() to override
priv->plat data if this hardware feature were valid.

This patch restores the return code in ->get_hw_feature() in order
to indicate the hardware feature validity and override priv->plat
data only if this hardware feature is valid.

Fixes: f10a6a3541b4 ("stmmac: rework get_hw_feature function")
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c
index 90383abafa66..f5581db0ba9b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c
@@ -218,11 +218,18 @@ static void dwmac1000_dump_dma_regs(void __iomem *ioaddr, u32 *reg_space)
 				readl(ioaddr + DMA_BUS_MODE + i * 4);
 }
 
-static void dwmac1000_get_hw_feature(void __iomem *ioaddr,
-				     struct dma_features *dma_cap)
+static int dwmac1000_get_hw_feature(void __iomem *ioaddr,
+				    struct dma_features *dma_cap)
 {
 	u32 hw_cap = readl(ioaddr + DMA_HW_FEATURE);
 
+	if (!hw_cap) {
+		/* 0x00000000 is the value read on old hardware that does not
+		 * implement this register
+		 */
+		return -EOPNOTSUPP;
+	}
+
 	dma_cap->mbps_10_100 = (hw_cap & DMA_HW_FEAT_MIISEL);
 	dma_cap->mbps_1000 = (hw_cap & DMA_HW_FEAT_GMIISEL) >> 1;
 	dma_cap->half_duplex = (hw_cap & DMA_HW_FEAT_HDSEL) >> 2;
@@ -252,6 +259,8 @@ static void dwmac1000_get_hw_feature(void __iomem *ioaddr,
 	dma_cap->number_tx_channel = (hw_cap & DMA_HW_FEAT_TXCHCNT) >> 22;
 	/* Alternate (enhanced) DESC mode */
 	dma_cap->enh_desc = (hw_cap & DMA_HW_FEAT_ENHDESSEL) >> 24;
+
+	return 0;
 }
 
 static void dwmac1000_rx_watchdog(void __iomem *ioaddr, u32 riwt,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
index 5be8e6a631d9..d99fa028c646 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -347,8 +347,8 @@ static void dwmac4_dma_tx_chan_op_mode(void __iomem *ioaddr, int mode,
 	writel(mtl_tx_op, ioaddr +  MTL_CHAN_TX_OP_MODE(channel));
 }
 
-static void dwmac4_get_hw_feature(void __iomem *ioaddr,
-				  struct dma_features *dma_cap)
+static int dwmac4_get_hw_feature(void __iomem *ioaddr,
+				 struct dma_features *dma_cap)
 {
 	u32 hw_cap = readl(ioaddr + GMAC_HW_FEATURE0);
 
@@ -437,6 +437,8 @@ static void dwmac4_get_hw_feature(void __iomem *ioaddr,
 	dma_cap->frpbs = (hw_cap & GMAC_HW_FEAT_FRPBS) >> 11;
 	dma_cap->frpsel = (hw_cap & GMAC_HW_FEAT_FRPSEL) >> 10;
 	dma_cap->dvlan = (hw_cap & GMAC_HW_FEAT_DVLAN) >> 5;
+
+	return 0;
 }
 
 /* Enable/disable TSO feature and set MSS */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index 906e985441a9..5e98355f422b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -371,8 +371,8 @@ static int dwxgmac2_dma_interrupt(void __iomem *ioaddr,
 	return ret;
 }
 
-static void dwxgmac2_get_hw_feature(void __iomem *ioaddr,
-				    struct dma_features *dma_cap)
+static int dwxgmac2_get_hw_feature(void __iomem *ioaddr,
+				   struct dma_features *dma_cap)
 {
 	u32 hw_cap;
 
@@ -445,6 +445,8 @@ static void dwxgmac2_get_hw_feature(void __iomem *ioaddr,
 	dma_cap->frpes = (hw_cap & XGMAC_HWFEAT_FRPES) >> 11;
 	dma_cap->frpbs = (hw_cap & XGMAC_HWFEAT_FRPPB) >> 9;
 	dma_cap->frpsel = (hw_cap & XGMAC_HWFEAT_FRPSEL) >> 3;
+
+	return 0;
 }
 
 static void dwxgmac2_rx_watchdog(void __iomem *ioaddr, u32 riwt, u32 queue)
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 6dc1c98ebec8..fe2660d5694d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -203,8 +203,8 @@ struct stmmac_dma_ops {
 	int (*dma_interrupt) (void __iomem *ioaddr,
 			      struct stmmac_extra_stats *x, u32 chan, u32 dir);
 	/* If supported then get the optional core features */
-	void (*get_hw_feature)(void __iomem *ioaddr,
-			       struct dma_features *dma_cap);
+	int (*get_hw_feature)(void __iomem *ioaddr,
+			      struct dma_features *dma_cap);
 	/* Program the HW RX Watchdog */
 	void (*rx_watchdog)(void __iomem *ioaddr, u32 riwt, u32 queue);
 	void (*set_tx_ring_len)(void __iomem *ioaddr, u32 len, u32 chan);
@@ -255,7 +255,7 @@ struct stmmac_dma_ops {
 #define stmmac_dma_interrupt_status(__priv, __args...) \
 	stmmac_do_callback(__priv, dma, dma_interrupt, __args)
 #define stmmac_get_hw_feature(__priv, __args...) \
-	stmmac_do_void_callback(__priv, dma, get_hw_feature, __args)
+	stmmac_do_callback(__priv, dma, get_hw_feature, __args)
 #define stmmac_rx_watchdog(__priv, __args...) \
 	stmmac_do_void_callback(__priv, dma, rx_watchdog, __args)
 #define stmmac_set_tx_ring_len(__priv, __args...) \

