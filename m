Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9572233B696
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbhCON6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232022AbhCON5f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2F2D64EEC;
        Mon, 15 Mar 2021 13:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816655;
        bh=VsRhpx73SLuFDzj2JVba5V4pgJr3pzqJsmdSYxGztfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zKqAA9kHjB4sCGfbf+2vv4tsOGFuT10SuJ/XM9SIePMSq4QoYyKo3wR9LWPxv1Jla
         9SlI2vKL6+JKIjJe9Ahk/GKg5o5INP7HHpG5vEf48jH1YDn8l1dOX7TcwRdjDyXo36
         swvcc7R6MFFG9xDeXn5V3Zd7zcWMB5cjX7pDHOcw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>,
        Ramesh Babu B <ramesh.babu.b@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 028/168] net: stmmac: fix incorrect DMA channel intr enable setting of EQoS v4.10
Date:   Mon, 15 Mar 2021 14:54:20 +0100
Message-Id: <20210315135551.273688670@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Ong Boon Leong <boon.leong.ong@intel.com>

commit 879c348c35bb5fb758dd881d8a97409c1862dae8 upstream.

We introduce dwmac410_dma_init_channel() here for both EQoS v4.10 and
above which use different DMA_CH(n)_Interrupt_Enable bit definitions for
NIE and AIE.

Fixes: 48863ce5940f ("stmmac: add DMA support for GMAC 4.xx")
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Ramesh Babu B <ramesh.babu.b@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -116,6 +116,23 @@ static void dwmac4_dma_init_channel(void
 	       ioaddr + DMA_CHAN_INTR_ENA(chan));
 }
 
+static void dwmac410_dma_init_channel(void __iomem *ioaddr,
+				      struct stmmac_dma_cfg *dma_cfg, u32 chan)
+{
+	u32 value;
+
+	/* common channel control register config */
+	value = readl(ioaddr + DMA_CHAN_CONTROL(chan));
+	if (dma_cfg->pblx8)
+		value = value | DMA_BUS_MODE_PBL;
+
+	writel(value, ioaddr + DMA_CHAN_CONTROL(chan));
+
+	/* Mask interrupts by writing to CSR7 */
+	writel(DMA_CHAN_INTR_DEFAULT_MASK_4_10,
+	       ioaddr + DMA_CHAN_INTR_ENA(chan));
+}
+
 static void dwmac4_dma_init(void __iomem *ioaddr,
 			    struct stmmac_dma_cfg *dma_cfg, int atds)
 {
@@ -462,7 +479,7 @@ const struct stmmac_dma_ops dwmac4_dma_o
 const struct stmmac_dma_ops dwmac410_dma_ops = {
 	.reset = dwmac4_dma_reset,
 	.init = dwmac4_dma_init,
-	.init_chan = dwmac4_dma_init_channel,
+	.init_chan = dwmac410_dma_init_channel,
 	.init_rx_chan = dwmac4_dma_init_rx_chan,
 	.init_tx_chan = dwmac4_dma_init_tx_chan,
 	.axi = dwmac4_dma_axi,


