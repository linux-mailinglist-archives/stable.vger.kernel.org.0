Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A238A612FB4
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 06:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiJaF3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 01:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiJaF3j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 01:29:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251F5B4AC
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 22:29:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91BEBB81117
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 05:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB2EC433C1;
        Mon, 31 Oct 2022 05:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667194173;
        bh=0+y9m3zHjS9zAzTAC8dHG5WaBVIbg27XdpbfNWoxT4A=;
        h=Subject:To:Cc:From:Date:From;
        b=lIkiTyEfR9O+H5wK5py8dS+/DU0Wwo8k8Pw2ghWgz5crxyAVcz36/kq01GTItasnN
         JkcIlTNW0ZH99guCLnSkm2srOo1T72fPQ3MzyVE5hmkXRWPlXPrnI9KoPNRyT7XW5Z
         3kTFf5bUSG9dphLY5FafgraiAcHC1DHqVvhSpjPs=
Subject: FAILED: patch "[PATCH] can: rcar_canfd: fix channel specific IRQ handling for RZ/G2L" failed to apply to 5.15-stable tree
To:     biju.das.jz@bp.renesas.com, mkl@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Oct 2022 06:30:17 +0100
Message-ID: <1667194217249235@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

d887087c8968 ("can: rcar_canfd: fix channel specific IRQ handling for RZ/G2L")
45721c406dcf ("can: rcar_canfd: Add support for r8a779a0 SoC")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d887087c896881715c1a82f1d4f71fbfe5344ffd Mon Sep 17 00:00:00 2001
From: Biju Das <biju.das.jz@bp.renesas.com>
Date: Tue, 25 Oct 2022 16:56:56 +0100
Subject: [PATCH] can: rcar_canfd: fix channel specific IRQ handling for RZ/G2L

RZ/G2L has separate channel specific IRQs for transmit and error
interrupts. But the IRQ handler processes both channels, even if there
no interrupt occurred on one of the channels.

This patch fixes the issue by passing a channel specific context
parameter instead of global one for the IRQ register and the IRQ
handler, it just handles the channel which is triggered the interrupt.

Fixes: 76e9353a80e9 ("can: rcar_canfd: Add support for RZ/G2L family")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/all/20221025155657.1426948-3-biju.das.jz@bp.renesas.com
Cc: stable@vger.kernel.org
[mkl: adjust commit message]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index ea828c1bd3a1..198da643ee6d 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1246,11 +1246,9 @@ static void rcar_canfd_handle_channel_tx(struct rcar_canfd_global *gpriv, u32 ch
 
 static irqreturn_t rcar_canfd_channel_tx_interrupt(int irq, void *dev_id)
 {
-	struct rcar_canfd_global *gpriv = dev_id;
-	u32 ch;
+	struct rcar_canfd_channel *priv = dev_id;
 
-	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels)
-		rcar_canfd_handle_channel_tx(gpriv, ch);
+	rcar_canfd_handle_channel_tx(priv->gpriv, priv->channel);
 
 	return IRQ_HANDLED;
 }
@@ -1278,11 +1276,9 @@ static void rcar_canfd_handle_channel_err(struct rcar_canfd_global *gpriv, u32 c
 
 static irqreturn_t rcar_canfd_channel_err_interrupt(int irq, void *dev_id)
 {
-	struct rcar_canfd_global *gpriv = dev_id;
-	u32 ch;
+	struct rcar_canfd_channel *priv = dev_id;
 
-	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels)
-		rcar_canfd_handle_channel_err(gpriv, ch);
+	rcar_canfd_handle_channel_err(priv->gpriv, priv->channel);
 
 	return IRQ_HANDLED;
 }
@@ -1723,6 +1719,7 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 	priv->ndev = ndev;
 	priv->base = gpriv->base;
 	priv->channel = ch;
+	priv->gpriv = gpriv;
 	priv->can.clock.freq = fcan_freq;
 	dev_info(&pdev->dev, "can_clk rate is %u\n", priv->can.clock.freq);
 
@@ -1751,7 +1748,7 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 		}
 		err = devm_request_irq(&pdev->dev, err_irq,
 				       rcar_canfd_channel_err_interrupt, 0,
-				       irq_name, gpriv);
+				       irq_name, priv);
 		if (err) {
 			dev_err(&pdev->dev, "devm_request_irq CH Err(%d) failed, error %d\n",
 				err_irq, err);
@@ -1765,7 +1762,7 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 		}
 		err = devm_request_irq(&pdev->dev, tx_irq,
 				       rcar_canfd_channel_tx_interrupt, 0,
-				       irq_name, gpriv);
+				       irq_name, priv);
 		if (err) {
 			dev_err(&pdev->dev, "devm_request_irq Tx (%d) failed, error %d\n",
 				tx_irq, err);
@@ -1791,7 +1788,6 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 
 	priv->can.do_set_mode = rcar_canfd_do_set_mode;
 	priv->can.do_get_berr_counter = rcar_canfd_get_berr_counter;
-	priv->gpriv = gpriv;
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 
 	netif_napi_add_weight(ndev, &priv->napi, rcar_canfd_rx_poll,

