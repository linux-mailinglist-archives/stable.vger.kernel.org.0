Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E86C612FB0
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 06:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiJaF3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 01:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiJaF3U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 01:29:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C119FFC
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 22:29:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C741B81116
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 05:29:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23FBC433C1;
        Mon, 31 Oct 2022 05:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667194157;
        bh=0UREBp8WjgRxeBU3IJHsLbp6N9c9lnwc9qKgiN5ZA5o=;
        h=Subject:To:Cc:From:Date:From;
        b=KNeRcIeximpqEyeKI7cysqLUDS1cplFx9MK370wFwZMTupXAVjhtf4LuvSEOsEM4A
         hPK7IQ5MUwwNfa1hYupKccwMiTQjdIlgEOeEgrwF8uQATMOkZazNwRyGVCE9mHczPt
         ERPm8FP1vQ41fLKZVoT5h73CXWvNwsXPITKw6IJY=
Subject: FAILED: patch "[PATCH] can: rcar_canfd: rcar_canfd_handle_global_receive(): fix IRQ" failed to apply to 4.19-stable tree
To:     biju.das.jz@bp.renesas.com, mkl@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Oct 2022 06:30:07 +0100
Message-ID: <16671942077080@kroah.com>
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

702de2c21eed ("can: rcar_canfd: rcar_canfd_handle_global_receive(): fix IRQ storm on global FIFO receive")
45721c406dcf ("can: rcar_canfd: Add support for r8a779a0 SoC")
76e9353a80e9 ("can: rcar_canfd: Add support for RZ/G2L family")
13dfb3fa4943 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 702de2c21eed04c67cefaaedc248ef16e5f6b293 Mon Sep 17 00:00:00 2001
From: Biju Das <biju.das.jz@bp.renesas.com>
Date: Tue, 25 Oct 2022 16:56:55 +0100
Subject: [PATCH] can: rcar_canfd: rcar_canfd_handle_global_receive(): fix IRQ
 storm on global FIFO receive

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

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 567620d215f8..ea828c1bd3a1 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1157,11 +1157,13 @@ static void rcar_canfd_handle_global_receive(struct rcar_canfd_global *gpriv, u3
 {
 	struct rcar_canfd_channel *priv = gpriv->ch[ch];
 	u32 ridx = ch + RCANFD_RFFIFO_IDX;
-	u32 sts;
+	u32 sts, cc;
 
 	/* Handle Rx interrupts */
 	sts = rcar_canfd_read(priv->base, RCANFD_RFSTS(gpriv, ridx));
-	if (likely(sts & RCANFD_RFSTS_RFIF)) {
+	cc = rcar_canfd_read(priv->base, RCANFD_RFCC(gpriv, ridx));
+	if (likely(sts & RCANFD_RFSTS_RFIF &&
+		   cc & RCANFD_RFCC_RFIE)) {
 		if (napi_schedule_prep(&priv->napi)) {
 			/* Disable Rx FIFO interrupts */
 			rcar_canfd_clear_bit(priv->base,

