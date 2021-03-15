Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDEF33B6AB
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbhCON62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232206AbhCON5z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5343764EF3;
        Mon, 15 Mar 2021 13:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816675;
        bh=ywmH/FuJgV0z5wgRWqx9jwCb0RCD3L65oqObmzsVKOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m/186hsFnnJ8Id+Bq1eMxPvzmfiOV4YGS9866NECSJwM+pq/cAEDJ+PNzPkCbHexO
         PYB3ikPzJUmz8ALLLp79Ke7QMGcCZLl/H0d/31WlM/azW2uMeS5r7B/yfrkw4dvJwj
         fTOAmOotOL1a1LX/QtggosVTVs54WYGAJ6h2GBII=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>,
        Ramesh Babu B <ramesh.babu.b@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 057/306] net: stmmac: fix incorrect DMA channel intr enable setting of EQoS v4.10
Date:   Mon, 15 Mar 2021 14:52:00 +0100
Message-Id: <20210315135509.577263897@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
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
@@ -124,6 +124,23 @@ static void dwmac4_dma_init_channel(void
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
@@ -523,7 +540,7 @@ const struct stmmac_dma_ops dwmac4_dma_o
 const struct stmmac_dma_ops dwmac410_dma_ops = {
 	.reset = dwmac4_dma_reset,
 	.init = dwmac4_dma_init,
-	.init_chan = dwmac4_dma_init_channel,
+	.init_chan = dwmac410_dma_init_channel,
 	.init_rx_chan = dwmac4_dma_init_rx_chan,
 	.init_tx_chan = dwmac4_dma_init_tx_chan,
 	.axi = dwmac4_dma_axi,


