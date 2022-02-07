Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 522684ABB61
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384513AbiBGL2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:28:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382516AbiBGLTb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:19:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E48C043188;
        Mon,  7 Feb 2022 03:19:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8590FB81028;
        Mon,  7 Feb 2022 11:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD023C340F0;
        Mon,  7 Feb 2022 11:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232766;
        bh=zUTpoFLaZ3eaEf+qauQwhazTGlijho5FZ9qE+bjZlXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YchNopT5F3++XlrIri5kypAJEfUOKlkd3OgEZjqrc9u0xvCq16hQNV4KTSO6OaaC9
         vmEENLyoMnQOdft8Wrxv3Z0nxfuZervmkKmYiExwsbDB5jV9i4I3zCp/5y1KQ/R7LC
         xPRMnkh1oIumQ4no8DwjeCHC0ahu9Tkw3XQ4QjLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Camel Guo <camelg@axis.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 29/44] net: stmmac: dump gmac4 DMA registers correctly
Date:   Mon,  7 Feb 2022 12:06:45 +0100
Message-Id: <20220207103754.105149234@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103753.155627314@linuxfoundation.org>
References: <20220207103753.155627314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Camel Guo <camelg@axis.com>

commit 7af037c39b600bac2c716dd1228e8ddbe149573f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h      |    1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c |   19 +++++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h
@@ -128,6 +128,7 @@
 
 #define NUM_DWMAC100_DMA_REGS	9
 #define NUM_DWMAC1000_DMA_REGS	23
+#define NUM_DWMAC4_DMA_REGS	27
 
 void dwmac_enable_dma_transmission(void __iomem *ioaddr);
 void dwmac_enable_dma_irq(void __iomem *ioaddr, u32 chan);
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
@@ -413,6 +421,8 @@ static int stmmac_ethtool_get_regs_len(s
 
 	if (priv->plat->has_xgmac)
 		return XGMAC_REGSIZE * 4;
+	else if (priv->plat->has_gmac4)
+		return GMAC4_REG_SPACE_SIZE;
 	return REG_SPACE_SIZE;
 }
 
@@ -425,8 +435,13 @@ static void stmmac_ethtool_gregs(struct
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


