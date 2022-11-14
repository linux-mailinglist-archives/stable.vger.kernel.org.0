Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD1B8627BD0
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 12:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236253AbiKNLNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 06:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235785AbiKNLNV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 06:13:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F7227140
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 03:09:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8BB76CE0EEA
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 11:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F153C433C1;
        Mon, 14 Nov 2022 11:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668424154;
        bh=zLX0GFW0PP0zRQVKrvqOUKGjNaGrT03h/C9DYaEppE4=;
        h=Subject:To:Cc:From:Date:From;
        b=IR/NsU/0Po4nCNC5OZxQ/krlEDOojZvoO0TVRly8YPoYsJnlonwXi9F+0usimf0oT
         CXKXOdn4p1eQJWIHCU/ac4CTokGVM+LGlzabAQrpT7SzJIdjZCSJPeLQ9bPR/AkuAc
         Mym3h+HMbfKxYYkNdlZt0xY1zqm2m61IOOiBmZAA=
Subject: FAILED: patch "[PATCH] dmaengine: at_hdmac: Fix concurrency over descriptor" failed to apply to 4.9-stable tree
To:     tudor.ambarus@microchip.com, nicolas.ferre@microchip.com,
        peda@axentia.se, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Nov 2022 12:08:57 +0100
Message-ID: <1668424137135168@kroah.com>
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

06988949df8c ("dmaengine: at_hdmac: Fix concurrency over descriptor")
078a6506141a ("dmaengine: at_hdmac: Fix deadlocks")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 06988949df8c3007ad82036d3606d8ae72ed9000 Mon Sep 17 00:00:00 2001
From: Tudor Ambarus <tudor.ambarus@microchip.com>
Date: Tue, 25 Oct 2022 12:02:42 +0300
Subject: [PATCH] dmaengine: at_hdmac: Fix concurrency over descriptor

The descriptor was added to the free_list before calling the callback,
which could result in reissuing of the same descriptor and calling of a
single callback for both. Move the decriptor to the free list after the
callback is invoked.

Fixes: dc78baa2b90b ("dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller")
Reported-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20221025090306.297886-1-tudor.ambarus@microchip.com
Link: https://lore.kernel.org/r/20221025090306.297886-9-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index f1e6fa6af6c2..2012ecc57826 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -469,11 +469,8 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
 		desc->memset_buffer = false;
 	}
 
-	/* move children to free_list */
-	list_splice_init(&desc->tx_list, &atchan->free_list);
-	/* move myself to free_list */
-	list_move(&desc->desc_node, &atchan->free_list);
-
+	/* Remove transfer node from the active list. */
+	list_del_init(&desc->desc_node);
 	spin_unlock_irqrestore(&atchan->lock, flags);
 
 	dma_descriptor_unmap(txd);
@@ -483,6 +480,13 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
 		dmaengine_desc_get_callback_invoke(txd, NULL);
 
 	dma_run_dependencies(txd);
+
+	spin_lock_irqsave(&atchan->lock, flags);
+	/* move children to free_list */
+	list_splice_init(&desc->tx_list, &atchan->free_list);
+	/* add myself to free_list */
+	list_add(&desc->desc_node, &atchan->free_list);
+	spin_unlock_irqrestore(&atchan->lock, flags);
 }
 
 /**

