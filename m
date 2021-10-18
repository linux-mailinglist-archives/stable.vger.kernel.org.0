Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09F8431C30
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbhJRNjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:39:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233168AbhJRNho (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:37:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFA7461350;
        Mon, 18 Oct 2021 13:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563897;
        bh=U5EPDvDxRwuwGLAyLFC9t8K9bDCR/g4m+1dzIVed0L8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ski7QIoyWrnXSZSv9EeNCI2GchnQkHSn3dGn7TZ1eHfhF5AcK4MUOD1qwmKAxUAX5
         chyWawq/BhgKwH4qufbqvpyktom8nvTG3Qot37Od8VaveS1INnNERQu6NmY+v7fM9J
         86jn7zy74ToRCDeDSR2VZOhJEUMrjbccMH+J0CKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herve Codina <herve.codina@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 50/69] net: stmmac: fix get_hw_feature() on old hardware
Date:   Mon, 18 Oct 2021 15:24:48 +0200
Message-Id: <20211018132331.145499722@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132329.453964125@linuxfoundation.org>
References: <20211018132329.453964125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herve Codina <herve.codina@bootlin.com>

commit 075da584bae2da6a37428d59a477b6bdad430ac3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c |   13 +++++++++++--
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c    |    6 ++++--
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c  |    6 ++++--
 drivers/net/ethernet/stmicro/stmmac/hwif.h          |    6 +++---
 4 files changed, 22 insertions(+), 9 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c
@@ -218,11 +218,18 @@ static void dwmac1000_dump_dma_regs(void
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
@@ -252,6 +259,8 @@ static void dwmac1000_get_hw_feature(voi
 	dma_cap->number_tx_channel = (hw_cap & DMA_HW_FEAT_TXCHCNT) >> 22;
 	/* Alternate (enhanced) DESC mode */
 	dma_cap->enh_desc = (hw_cap & DMA_HW_FEAT_ENHDESSEL) >> 24;
+
+	return 0;
 }
 
 static void dwmac1000_rx_watchdog(void __iomem *ioaddr, u32 riwt,
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -336,8 +336,8 @@ static void dwmac4_dma_tx_chan_op_mode(v
 	writel(mtl_tx_op, ioaddr +  MTL_CHAN_TX_OP_MODE(channel));
 }
 
-static void dwmac4_get_hw_feature(void __iomem *ioaddr,
-				  struct dma_features *dma_cap)
+static int dwmac4_get_hw_feature(void __iomem *ioaddr,
+				 struct dma_features *dma_cap)
 {
 	u32 hw_cap = readl(ioaddr + GMAC_HW_FEATURE0);
 
@@ -400,6 +400,8 @@ static void dwmac4_get_hw_feature(void _
 	dma_cap->frpbs = (hw_cap & GMAC_HW_FEAT_FRPBS) >> 11;
 	dma_cap->frpsel = (hw_cap & GMAC_HW_FEAT_FRPSEL) >> 10;
 	dma_cap->dvlan = (hw_cap & GMAC_HW_FEAT_DVLAN) >> 5;
+
+	return 0;
 }
 
 /* Enable/disable TSO feature and set MSS */
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -356,8 +356,8 @@ static int dwxgmac2_dma_interrupt(void _
 	return ret;
 }
 
-static void dwxgmac2_get_hw_feature(void __iomem *ioaddr,
-				    struct dma_features *dma_cap)
+static int dwxgmac2_get_hw_feature(void __iomem *ioaddr,
+				   struct dma_features *dma_cap)
 {
 	u32 hw_cap;
 
@@ -425,6 +425,8 @@ static void dwxgmac2_get_hw_feature(void
 	dma_cap->frpes = (hw_cap & XGMAC_HWFEAT_FRPES) >> 11;
 	dma_cap->frpbs = (hw_cap & XGMAC_HWFEAT_FRPPB) >> 9;
 	dma_cap->frpsel = (hw_cap & XGMAC_HWFEAT_FRPSEL) >> 3;
+
+	return 0;
 }
 
 static void dwxgmac2_rx_watchdog(void __iomem *ioaddr, u32 riwt, u32 nchan)
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -196,8 +196,8 @@ struct stmmac_dma_ops {
 	int (*dma_interrupt) (void __iomem *ioaddr,
 			      struct stmmac_extra_stats *x, u32 chan);
 	/* If supported then get the optional core features */
-	void (*get_hw_feature)(void __iomem *ioaddr,
-			       struct dma_features *dma_cap);
+	int (*get_hw_feature)(void __iomem *ioaddr,
+			      struct dma_features *dma_cap);
 	/* Program the HW RX Watchdog */
 	void (*rx_watchdog)(void __iomem *ioaddr, u32 riwt, u32 number_chan);
 	void (*set_tx_ring_len)(void __iomem *ioaddr, u32 len, u32 chan);
@@ -247,7 +247,7 @@ struct stmmac_dma_ops {
 #define stmmac_dma_interrupt_status(__priv, __args...) \
 	stmmac_do_callback(__priv, dma, dma_interrupt, __args)
 #define stmmac_get_hw_feature(__priv, __args...) \
-	stmmac_do_void_callback(__priv, dma, get_hw_feature, __args)
+	stmmac_do_callback(__priv, dma, get_hw_feature, __args)
 #define stmmac_rx_watchdog(__priv, __args...) \
 	stmmac_do_void_callback(__priv, dma, rx_watchdog, __args)
 #define stmmac_set_tx_ring_len(__priv, __args...) \


