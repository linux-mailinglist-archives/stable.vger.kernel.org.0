Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9481B615A30
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbiKBD0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbiKBD0b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:26:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC6425E95
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:26:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13004B8205C
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7333C433C1;
        Wed,  2 Nov 2022 03:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359586;
        bh=aSc4AwdUZEsX8bRKJnIl4GKSd9tHAGfStVbM1pY2QHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V1VU75kNNhwPvmWtiMTNkd189hieOV/8239glZ4jO1IHXw9aSgoc83srBS5X0R4jt
         QUbORAzGfk91JNxV241e0QaP7imQQF8maHJkhfdbcVtHYyxOYoChPUQqpT9sha9xpw
         mBlQGBcuABdA2/vWAdWn9lwiEdG3Xyhgwu5/7EeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marc Kleine-Budde <mkl@pengutronix.de>,
        Biju Das <biju.das.jz@bp.renesas.com>
Subject: [PATCH 5.4 64/64] can: rcar_canfd: rcar_canfd_handle_global_receive(): fix IRQ storm on global FIFO receive
Date:   Wed,  2 Nov 2022 03:34:30 +0100
Message-Id: <20221102022053.887210745@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.821538553@linuxfoundation.org>
References: <20221102022051.821538553@linuxfoundation.org>
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

commit 702de2c21eed04c67cefaaedc248ef16e5f6b293 upstream.

We are seeing an IRQ storm on the global receive IRQ line under heavy
CAN bus load conditions with both CAN channels enabled.

Conditions:

The global receive IRQ line is shared between can0 and can1, either of
the channels can trigger interrupt while the other channel's IRQ line
is disabled (RFIE).

When global a receive IRQ interrupt occurs, we mask the interrupt in
the IRQ handler. Clearing and unmasking of the interrupt is happening
in rx_poll(). There is a race condition where rx_poll() unmasks the
interrupt, but the next IRQ handler does not mask the IRQ due to
NAPIF_STATE_MISSED flag (e.g.: can0 RX FIFO interrupt is disabled and
can1 is triggering RX interrupt, the delay in rx_poll() processing
results in setting NAPIF_STATE_MISSED flag) leading to an IRQ storm.

This patch fixes the issue by checking IRQ active and enabled before
handling the IRQ on a particular channel.

Fixes: dd3bd23eb438 ("can: rcar_canfd: Add Renesas R-Car CAN FD driver")
Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/all/20221025155657.1426948-2-biju.das.jz@bp.renesas.com
Cc: stable@vger.kernel.org
[mkl: adjust commit message]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
[biju: removed gpriv from RCANFD_RFCC_RFIE macro]
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/rcar/rcar_canfd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 67f0f14e2bf4..c61534a2a2d3 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1075,7 +1075,7 @@ static irqreturn_t rcar_canfd_global_interrupt(int irq, void *dev_id)
 	struct rcar_canfd_global *gpriv = dev_id;
 	struct net_device *ndev;
 	struct rcar_canfd_channel *priv;
-	u32 sts, gerfl;
+	u32 sts, cc, gerfl;
 	u32 ch, ridx;
 
 	/* Global error interrupts still indicate a condition specific
@@ -1093,7 +1093,9 @@ static irqreturn_t rcar_canfd_global_interrupt(int irq, void *dev_id)
 
 		/* Handle Rx interrupts */
 		sts = rcar_canfd_read(priv->base, RCANFD_RFSTS(ridx));
-		if (likely(sts & RCANFD_RFSTS_RFIF)) {
+		cc = rcar_canfd_read(priv->base, RCANFD_RFCC(ridx));
+		if (likely(sts & RCANFD_RFSTS_RFIF &&
+			   cc & RCANFD_RFCC_RFIE)) {
 			if (napi_schedule_prep(&priv->napi)) {
 				/* Disable Rx FIFO interrupts */
 				rcar_canfd_clear_bit(priv->base,
-- 
2.25.1



