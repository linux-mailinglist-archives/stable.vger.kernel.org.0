Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0032161596E
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbiKBDLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiKBDK6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:10:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC0823BE1
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:10:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4C1F0CE1EB9
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC150C433D6;
        Wed,  2 Nov 2022 03:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358654;
        bh=qyBFwOLYvKJWi3/VpAU0vTqrt1/YWTWw3GD5M0cdHt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tjSfr/VgzwEEUgj4j4csVHCVStQnzS74I8gKM8yyQRWFZRKfuQvl7hf9hwcR1SLO1
         KTenOz/qUQtQSa+G+F8AD0c3ULwQxZ/mqpe7+NdZzJ8MsVknYuWSBRPHg3knnbFLfF
         6sAdOArQBTCrynMudTGRtAmAQzaCZAHkpMt/Qw/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Biju Das <biju.das.jz@bp.renesas.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 128/132] can: rcar_canfd: fix channel specific IRQ handling for RZ/G2L
Date:   Wed,  2 Nov 2022 03:33:54 +0100
Message-Id: <20221102022103.034769058@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

commit d887087c896881715c1a82f1d4f71fbfe5344ffd upstream.

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
[biju: fixed the conflicts manually]
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/rcar/rcar_canfd.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1195,11 +1195,9 @@ static void rcar_canfd_handle_channel_tx
 
 static irqreturn_t rcar_canfd_channel_tx_interrupt(int irq, void *dev_id)
 {
-	struct rcar_canfd_global *gpriv = dev_id;
-	u32 ch;
+	struct rcar_canfd_channel *priv = dev_id;
 
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS)
-		rcar_canfd_handle_channel_tx(gpriv, ch);
+	rcar_canfd_handle_channel_tx(priv->gpriv, priv->channel);
 
 	return IRQ_HANDLED;
 }
@@ -1227,11 +1225,9 @@ static void rcar_canfd_handle_channel_er
 
 static irqreturn_t rcar_canfd_channel_err_interrupt(int irq, void *dev_id)
 {
-	struct rcar_canfd_global *gpriv = dev_id;
-	u32 ch;
+	struct rcar_canfd_channel *priv = dev_id;
 
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS)
-		rcar_canfd_handle_channel_err(gpriv, ch);
+	rcar_canfd_handle_channel_err(priv->gpriv, priv->channel);
 
 	return IRQ_HANDLED;
 }
@@ -1649,6 +1645,7 @@ static int rcar_canfd_channel_probe(stru
 	priv->ndev = ndev;
 	priv->base = gpriv->base;
 	priv->channel = ch;
+	priv->gpriv = gpriv;
 	priv->can.clock.freq = fcan_freq;
 	dev_info(&pdev->dev, "can_clk rate is %u\n", priv->can.clock.freq);
 
@@ -1677,7 +1674,7 @@ static int rcar_canfd_channel_probe(stru
 		}
 		err = devm_request_irq(&pdev->dev, err_irq,
 				       rcar_canfd_channel_err_interrupt, 0,
-				       irq_name, gpriv);
+				       irq_name, priv);
 		if (err) {
 			dev_err(&pdev->dev, "devm_request_irq CH Err(%d) failed, error %d\n",
 				err_irq, err);
@@ -1691,7 +1688,7 @@ static int rcar_canfd_channel_probe(stru
 		}
 		err = devm_request_irq(&pdev->dev, tx_irq,
 				       rcar_canfd_channel_tx_interrupt, 0,
-				       irq_name, gpriv);
+				       irq_name, priv);
 		if (err) {
 			dev_err(&pdev->dev, "devm_request_irq Tx (%d) failed, error %d\n",
 				tx_irq, err);
@@ -1715,7 +1712,6 @@ static int rcar_canfd_channel_probe(stru
 
 	priv->can.do_set_mode = rcar_canfd_do_set_mode;
 	priv->can.do_get_berr_counter = rcar_canfd_get_berr_counter;
-	priv->gpriv = gpriv;
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 
 	netif_napi_add(ndev, &priv->napi, rcar_canfd_rx_poll,


