Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50C44AAF36
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 13:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235768AbiBFMp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Feb 2022 07:45:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiBFMp0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Feb 2022 07:45:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8AE8C06173B
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 04:45:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5815960F6A
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 12:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3C6C340E9;
        Sun,  6 Feb 2022 12:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644151524;
        bh=Nh6HZS4RcYb+NbNuUfQ4cNJ25fnt7dgOVd66P5g0SYo=;
        h=Subject:To:Cc:From:Date:From;
        b=qCEBDfd/9yic5BmyQQ2IEXEZ7aOoM6VPVW/o/YmqvF1T3Uda9xp4LdtO/xEGVn/Cd
         SYOfA+/JfSQXKLASeNcmatfe95tuGUAzr8/scGPRv4qHCSPVtcccRGxRG9js9pHDDA
         NTG9Ogv9shqgtY8GzCXpcLrFEHGUmG0FrbkXoacQ=
Subject: FAILED: patch "[PATCH] net: stmmac: dump gmac4 DMA registers correctly" failed to apply to 4.14-stable tree
To:     camelg@axis.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 06 Feb 2022 13:45:21 +0100
Message-ID: <1644151521150122@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7af037c39b600bac2c716dd1228e8ddbe149573f Mon Sep 17 00:00:00 2001
From: Camel Guo <camelg@axis.com>
Date: Mon, 31 Jan 2022 09:38:40 +0100
Subject: [PATCH] net: stmmac: dump gmac4 DMA registers correctly

Unlike gmac100, gmac1000, gmac4 has 27 DMA registers and they are
located at DMA_CHAN_BASE_ADDR (0x1100). In order for ethtool to dump
gmac4 DMA registers correctly, this commit checks if a net_device has
gmac4 and uses different logic to dump its DMA registers.

This fixes the following KASAN warning, which can normally be triggered
by a command similar like "ethtool -d eth0":

BUG: KASAN: vmalloc-out-of-bounds in dwmac4_dump_dma_regs+0x6d4/0xb30
Write of size 4 at addr ffffffc010177100 by task ethtool/1839
 kasan_report+0x200/0x21c
 __asan_report_store4_noabort+0x34/0x60
 dwmac4_dump_dma_regs+0x6d4/0xb30
 stmmac_ethtool_gregs+0x110/0x204
 ethtool_get_regs+0x200/0x4b0
 dev_ethtool+0x1dac/0x3800
 dev_ioctl+0x7c0/0xb50
 sock_ioctl+0x298/0x6c4
 ...

Fixes: fbf68229ffe7 ("net: stmmac: unify registers dumps methods")
Signed-off-by: Camel Guo <camelg@axis.com>
Link: https://lore.kernel.org/r/20220131083841.3346801-1-camel.guo@axis.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h b/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h
index 1914ad698cab..acd70b9a3173 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h
@@ -150,6 +150,7 @@
 
 #define NUM_DWMAC100_DMA_REGS	9
 #define NUM_DWMAC1000_DMA_REGS	23
+#define NUM_DWMAC4_DMA_REGS	27
 
 void dwmac_enable_dma_transmission(void __iomem *ioaddr);
 void dwmac_enable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 164dff5ec32e..abfb3cd5958d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -21,10 +21,18 @@
 #include "dwxgmac2.h"
 
 #define REG_SPACE_SIZE	0x1060
+#define GMAC4_REG_SPACE_SIZE	0x116C
 #define MAC100_ETHTOOL_NAME	"st_mac100"
 #define GMAC_ETHTOOL_NAME	"st_gmac"
 #define XGMAC_ETHTOOL_NAME	"st_xgmac"
 
+/* Same as DMA_CHAN_BASE_ADDR defined in dwmac4_dma.h
+ *
+ * It is here because dwmac_dma.h and dwmac4_dam.h can not be included at the
+ * same time due to the conflicting macro names.
+ */
+#define GMAC4_DMA_CHAN_BASE_ADDR  0x00001100
+
 #define ETHTOOL_DMA_OFFSET	55
 
 struct stmmac_stats {
@@ -434,6 +442,8 @@ static int stmmac_ethtool_get_regs_len(struct net_device *dev)
 
 	if (priv->plat->has_xgmac)
 		return XGMAC_REGSIZE * 4;
+	else if (priv->plat->has_gmac4)
+		return GMAC4_REG_SPACE_SIZE;
 	return REG_SPACE_SIZE;
 }
 
@@ -446,8 +456,13 @@ static void stmmac_ethtool_gregs(struct net_device *dev,
 	stmmac_dump_mac_regs(priv, priv->hw, reg_space);
 	stmmac_dump_dma_regs(priv, priv->ioaddr, reg_space);
 
-	if (!priv->plat->has_xgmac) {
-		/* Copy DMA registers to where ethtool expects them */
+	/* Copy DMA registers to where ethtool expects them */
+	if (priv->plat->has_gmac4) {
+		/* GMAC4 dumps its DMA registers at its DMA_CHAN_BASE_ADDR */
+		memcpy(&reg_space[ETHTOOL_DMA_OFFSET],
+		       &reg_space[GMAC4_DMA_CHAN_BASE_ADDR / 4],
+		       NUM_DWMAC4_DMA_REGS * 4);
+	} else if (!priv->plat->has_xgmac) {
 		memcpy(&reg_space[ETHTOOL_DMA_OFFSET],
 		       &reg_space[DMA_BUS_MODE / 4],
 		       NUM_DWMAC1000_DMA_REGS * 4);

