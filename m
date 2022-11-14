Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E906B627BDF
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 12:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbiKNLPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 06:15:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236312AbiKNLOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 06:14:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD3E20F54
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 03:10:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27F6D60FCB
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 11:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B76C433C1;
        Mon, 14 Nov 2022 11:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668424213;
        bh=phSYhAR2/CDKbTdEm8DDLm4nRKo1vHn+wujrHoeeOKs=;
        h=Subject:To:Cc:From:Date:From;
        b=GJY/JHXOJ8k2nf3iIqmh0nb70DkhPc5fOcm+XufySrK9SRfRhzPivkiIerQBkc9tf
         FWFxllIYgHPjOMzvD3k3kvq4k3blISzPX7eJcJ6M0BLnF0mqLXRGUrkUpZKFXpku7s
         tRcU8lkOCzhGmUHfXCr4WUGhoqm1VNVQlgnjU+Sw=
Subject: FAILED: patch "[PATCH] dmaengine: at_hdmac: Fix descriptor handling when issuing it" failed to apply to 4.19-stable tree
To:     tudor.ambarus@microchip.com, nicolas.ferre@microchip.com,
        peda@axentia.se, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Nov 2022 12:10:05 +0100
Message-ID: <16684242051190@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

ba2423633ba6 ("dmaengine: at_hdmac: Fix descriptor handling when issuing it to hardware")
c6babed879fb ("dmaengine: at_hdmac: Fix concurrency problems by removing atc_complete_all()")
078a6506141a ("dmaengine: at_hdmac: Fix deadlocks")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ba2423633ba646e1df20e30cb3cf35495c16f173 Mon Sep 17 00:00:00 2001
From: Tudor Ambarus <tudor.ambarus@microchip.com>
Date: Tue, 25 Oct 2022 12:02:45 +0300
Subject: [PATCH] dmaengine: at_hdmac: Fix descriptor handling when issuing it
 to hardware

As it was before, the descriptor was issued to the hardware without adding
it to the active (issued) list. This could result in a completion of other
descriptor, or/and in the descriptor never being completed.

Fixes: dc78baa2b90b ("dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller")
Reported-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20221025090306.297886-1-tudor.ambarus@microchip.com
Link: https://lore.kernel.org/r/20221025090306.297886-12-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index b53a9fc15dd9..9e5a30396c1c 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -510,8 +510,11 @@ static void atc_advance_work(struct at_dma_chan *atchan)
 
 	/* advance work */
 	spin_lock_irqsave(&atchan->lock, flags);
-	if (!list_empty(&atchan->active_list))
-		atc_dostart(atchan, atc_first_active(atchan));
+	if (!list_empty(&atchan->active_list)) {
+		desc = atc_first_queued(atchan);
+		list_move_tail(&desc->desc_node, &atchan->active_list);
+		atc_dostart(atchan, desc);
+	}
 	spin_unlock_irqrestore(&atchan->lock, flags);
 }
 
@@ -523,6 +526,7 @@ static void atc_advance_work(struct at_dma_chan *atchan)
 static void atc_handle_error(struct at_dma_chan *atchan)
 {
 	struct at_desc *bad_desc;
+	struct at_desc *desc;
 	struct at_desc *child;
 	unsigned long flags;
 
@@ -540,8 +544,11 @@ static void atc_handle_error(struct at_dma_chan *atchan)
 	list_splice_init(&atchan->queue, atchan->active_list.prev);
 
 	/* Try to restart the controller */
-	if (!list_empty(&atchan->active_list))
-		atc_dostart(atchan, atc_first_active(atchan));
+	if (!list_empty(&atchan->active_list)) {
+		desc = atc_first_queued(atchan);
+		list_move_tail(&desc->desc_node, &atchan->active_list);
+		atc_dostart(atchan, desc);
+	}
 
 	/*
 	 * KERN_CRITICAL may seem harsh, but since this only happens

