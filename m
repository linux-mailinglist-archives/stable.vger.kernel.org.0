Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D69615AA2
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiKBDhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiKBDhi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:37:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4060A26560
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:37:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D28AF6172F
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:37:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4DFC433C1;
        Wed,  2 Nov 2022 03:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667360257;
        bh=IAuN8HgsS8djbMM1EszhX61MUlFv8xCXtDc38DKOo6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aIoTLYnm/o3O/AwD8ObL+ALPQmKxfyd5Tn1u9lnIshM86iBTF1pEnUyf7yp7JTX7j
         X96wypAzua3wX68fHkh2xcHVkwPDXutIT8biAmnx1s0M3cS1tDrTWqqHRuzm9hRG3w
         HWAXScJAlvrBb7QcH9Wydu+Fyf6cTwTriyz2Ln1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marc Kleine-Budde <mkl@pengutronix.de>,
        Biju Das <biju.das.jz@bp.renesas.com>
Subject: [PATCH 4.19 78/78] can: rcar_canfd: rcar_canfd_handle_global_receive(): fix IRQ storm on global FIFO receive
Date:   Wed,  2 Nov 2022 03:35:03 +0100
Message-Id: <20221102022055.220331870@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
References: <20221102022052.895556444@linuxfoundation.org>
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
 drivers/net/can/rcar/rcar_canfd.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1079,7 +1079,7 @@ static irqreturn_t rcar_canfd_global_int
 	struct rcar_canfd_global *gpriv = dev_id;
 	struct net_device *ndev;
 	struct rcar_canfd_channel *priv;
-	u32 sts, gerfl;
+	u32 sts, cc, gerfl;
 	u32 ch, ridx;
 
 	/* Global error interrupts still indicate a condition specific
@@ -1097,7 +1097,9 @@ static irqreturn_t rcar_canfd_global_int
 
 		/* Handle Rx interrupts */
 		sts = rcar_canfd_read(priv->base, RCANFD_RFSTS(ridx));
-		if (likely(sts & RCANFD_RFSTS_RFIF)) {
+		cc = rcar_canfd_read(priv->base, RCANFD_RFCC(ridx));
+		if (likely(sts & RCANFD_RFSTS_RFIF &&
+			   cc & RCANFD_RFCC_RFIE)) {
 			if (napi_schedule_prep(&priv->napi)) {
 				/* Disable Rx FIFO interrupts */
 				rcar_canfd_clear_bit(priv->base,


