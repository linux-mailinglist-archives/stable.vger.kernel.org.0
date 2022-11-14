Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDC3627BDA
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 12:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236282AbiKNLPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 06:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236628AbiKNLOa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 06:14:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0708927CC0
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 03:10:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95EB660FC6
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 11:10:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98779C433D6;
        Mon, 14 Nov 2022 11:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668424207;
        bh=eXCwIOgf94+U94j8RJ2Icsbi2H4fnCh+qmi1Oye2zjY=;
        h=Subject:To:Cc:From:Date:From;
        b=gpeW+TXJdF8iDPiGhC8vQrP+g7PhyhCUkeY98mcqXldKc+MYxFsmoVmt+qGjHdzYM
         OlIFKoin0BXQvBigOezaqP972hPGyqUaE6ACNhOg0XQnW+Q1FFblzC7wsYBlODhaqI
         IhD2woD5mLPZuwlWvKTCssSXOevPo1+nyy9j5neY=
Subject: FAILED: patch "[PATCH] dmaengine: at_hdmac: Fix concurrency over the active list" failed to apply to 4.9-stable tree
To:     tudor.ambarus@microchip.com, nicolas.ferre@microchip.com,
        peda@axentia.se, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Nov 2022 12:09:50 +0100
Message-ID: <16684241909142@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

03ed9ba357cc ("dmaengine: at_hdmac: Fix concurrency over the active list")
6ba826cbb57d ("dmaengine: at_hdmac: Free the memset buf without holding the chan lock")
06988949df8c ("dmaengine: at_hdmac: Fix concurrency over descriptor")
c6babed879fb ("dmaengine: at_hdmac: Fix concurrency problems by removing atc_complete_all()")
078a6506141a ("dmaengine: at_hdmac: Fix deadlocks")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 03ed9ba357cc78116164b90b87f45eacab60b561 Mon Sep 17 00:00:00 2001
From: Tudor Ambarus <tudor.ambarus@microchip.com>
Date: Tue, 25 Oct 2022 12:02:44 +0300
Subject: [PATCH] dmaengine: at_hdmac: Fix concurrency over the active list

The tasklet (atc_advance_work()) did not held the channel lock when
retrieving the first active descriptor, causing concurrency problems if
issue_pending() was called in between. If issue_pending() was called
exactly after the lock was released in the tasklet (atc_advance_work()),
atc_chain_complete() could complete a descriptor for which the controller
has not yet raised an interrupt.

Fixes: dc78baa2b90b ("dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller")
Reported-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20221025090306.297886-1-tudor.ambarus@microchip.com
Link: https://lore.kernel.org/r/20221025090306.297886-11-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 0fb44f622d35..b53a9fc15dd9 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -462,8 +462,6 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
 	if (!atc_chan_is_cyclic(atchan))
 		dma_cookie_complete(txd);
 
-	/* Remove transfer node from the active list. */
-	list_del_init(&desc->desc_node);
 	spin_unlock_irqrestore(&atchan->lock, flags);
 
 	dma_descriptor_unmap(txd);
@@ -495,6 +493,7 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
  */
 static void atc_advance_work(struct at_dma_chan *atchan)
 {
+	struct at_desc *desc;
 	unsigned long flags;
 
 	dev_vdbg(chan2dev(&atchan->chan_common), "advance_work\n");
@@ -502,9 +501,12 @@ static void atc_advance_work(struct at_dma_chan *atchan)
 	spin_lock_irqsave(&atchan->lock, flags);
 	if (atc_chan_is_enabled(atchan) || list_empty(&atchan->active_list))
 		return spin_unlock_irqrestore(&atchan->lock, flags);
-	spin_unlock_irqrestore(&atchan->lock, flags);
 
-	atc_chain_complete(atchan, atc_first_active(atchan));
+	desc = atc_first_active(atchan);
+	/* Remove the transfer node from the active list. */
+	list_del_init(&desc->desc_node);
+	spin_unlock_irqrestore(&atchan->lock, flags);
+	atc_chain_complete(atchan, desc);
 
 	/* advance work */
 	spin_lock_irqsave(&atchan->lock, flags);

