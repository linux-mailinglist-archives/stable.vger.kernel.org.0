Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952414CE69F
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 20:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbiCETzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 14:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbiCETzr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 14:55:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C1980235
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 11:54:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7545AB80C75
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 19:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D37A7C004E1;
        Sat,  5 Mar 2022 19:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646510094;
        bh=UYDBnPZVyRmKn4+Wyq/hFTUu6THAGEOrF+SCK481lVg=;
        h=Subject:To:Cc:From:Date:From;
        b=DLFFLiWvVBuyRQV2+iKs+YmeoS25KqH5ElNGM3DdF3QODXpuJvmrqab+Tl1FobGqD
         uGDKFzUz8mep8cgSDgz1yjBZivQzG8ogcPVCfHxRhbdtH8E0+JNz6kexc58njSJehV
         ujgK3YoFYRFvFWATOgdW9VlMi89iuTtQuD3857cE=
Subject: FAILED: patch "[PATCH] net: stmmac: only enable DMA interrupts when ready" failed to apply to 5.16-stable tree
To:     vincent.whitchurch@axis.com, davem@davemloft.net, larper@axis.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Mar 2022 20:54:51 +0100
Message-ID: <164651009143145@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 087a7b944c5db409f7c1a68bf4896c56ba54eaff Mon Sep 17 00:00:00 2001
From: Vincent Whitchurch <vincent.whitchurch@axis.com>
Date: Thu, 24 Feb 2022 12:38:29 +0100
Subject: [PATCH] net: stmmac: only enable DMA interrupts when ready

In this driver's ->ndo_open() callback, it enables DMA interrupts,
starts the DMA channels, then requests interrupts with request_irq(),
and then finally enables napi.

If RX DMA interrupts are received before napi is enabled, no processing
is done because napi_schedule_prep() will return false.  If the network
has a lot of broadcast/multicast traffic, then the RX ring could fill up
completely before napi is enabled.  When this happens, no further RX
interrupts will be delivered, and the driver will fail to receive any
packets.

Fix this by only enabling DMA interrupts after all other initialization
is complete.

Fixes: 523f11b5d4fd72efb ("net: stmmac: move hardware setup for stmmac_open to new function")
Reported-by: Lars Persson <larper@axis.com>
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index bde76ea2deec..cb9b6e08780c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2262,6 +2262,23 @@ static void stmmac_stop_tx_dma(struct stmmac_priv *priv, u32 chan)
 	stmmac_stop_tx(priv, priv->ioaddr, chan);
 }
 
+static void stmmac_enable_all_dma_irq(struct stmmac_priv *priv)
+{
+	u32 rx_channels_count = priv->plat->rx_queues_to_use;
+	u32 tx_channels_count = priv->plat->tx_queues_to_use;
+	u32 dma_csr_ch = max(rx_channels_count, tx_channels_count);
+	u32 chan;
+
+	for (chan = 0; chan < dma_csr_ch; chan++) {
+		struct stmmac_channel *ch = &priv->channel[chan];
+		unsigned long flags;
+
+		spin_lock_irqsave(&ch->lock, flags);
+		stmmac_enable_dma_irq(priv, priv->ioaddr, chan, 1, 1);
+		spin_unlock_irqrestore(&ch->lock, flags);
+	}
+}
+
 /**
  * stmmac_start_all_dma - start all RX and TX DMA channels
  * @priv: driver private structure
@@ -2904,8 +2921,10 @@ static int stmmac_init_dma_engine(struct stmmac_priv *priv)
 		stmmac_axi(priv, priv->ioaddr, priv->plat->axi);
 
 	/* DMA CSR Channel configuration */
-	for (chan = 0; chan < dma_csr_ch; chan++)
+	for (chan = 0; chan < dma_csr_ch; chan++) {
 		stmmac_init_chan(priv, priv->ioaddr, priv->plat->dma_cfg, chan);
+		stmmac_disable_dma_irq(priv, priv->ioaddr, chan, 1, 1);
+	}
 
 	/* DMA RX Channel Configuration */
 	for (chan = 0; chan < rx_channels_count; chan++) {
@@ -3761,6 +3780,7 @@ static int stmmac_open(struct net_device *dev)
 
 	stmmac_enable_all_queues(priv);
 	netif_tx_start_all_queues(priv->dev);
+	stmmac_enable_all_dma_irq(priv);
 
 	return 0;
 
@@ -6510,8 +6530,10 @@ int stmmac_xdp_open(struct net_device *dev)
 	}
 
 	/* DMA CSR Channel configuration */
-	for (chan = 0; chan < dma_csr_ch; chan++)
+	for (chan = 0; chan < dma_csr_ch; chan++) {
 		stmmac_init_chan(priv, priv->ioaddr, priv->plat->dma_cfg, chan);
+		stmmac_disable_dma_irq(priv, priv->ioaddr, chan, 1, 1);
+	}
 
 	/* Adjust Split header */
 	sph_en = (priv->hw->rx_csum > 0) && priv->sph;
@@ -6572,6 +6594,7 @@ int stmmac_xdp_open(struct net_device *dev)
 	stmmac_enable_all_queues(priv);
 	netif_carrier_on(dev);
 	netif_tx_start_all_queues(dev);
+	stmmac_enable_all_dma_irq(priv);
 
 	return 0;
 
@@ -7451,6 +7474,7 @@ int stmmac_resume(struct device *dev)
 	stmmac_restore_hw_vlan_rx_fltr(priv, ndev, priv->hw);
 
 	stmmac_enable_all_queues(priv);
+	stmmac_enable_all_dma_irq(priv);
 
 	mutex_unlock(&priv->lock);
 	rtnl_unlock();

