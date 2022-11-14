Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B47A627BD3
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 12:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236254AbiKNLOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 06:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236710AbiKNLNr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 06:13:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE53275E9
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 03:09:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB75B6101F
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 11:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F310C433C1;
        Mon, 14 Nov 2022 11:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668424168;
        bh=uhxxn2hrPxHMx1g8ZUeERqVYxG6K6HwNH5/c/aBRIRU=;
        h=Subject:To:Cc:From:Date:From;
        b=Prejb9wU00383wU3VocxvJ9IvyjPBl1NgS8J4SZ7TRlKTTsxWgSHNgIbnHvq988sS
         vWXDKBKjCpW1qDjYCqvT1rUlNjWwzOzHhzRRi2mizplbDCZ/AP5tZOjnucPv8THoxG
         Jpcl2psRRCDQIFC7idOftO4TJ6kxB44gGWfM9wYw=
Subject: FAILED: patch "[PATCH] dmaengine: at_hdmac: Free the memset buf without holding the" failed to apply to 4.19-stable tree
To:     tudor.ambarus@microchip.com, nicolas.ferre@microchip.com,
        vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Nov 2022 12:09:17 +0100
Message-ID: <1668424157252214@kroah.com>
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

6ba826cbb57d ("dmaengine: at_hdmac: Free the memset buf without holding the chan lock")
06988949df8c ("dmaengine: at_hdmac: Fix concurrency over descriptor")
078a6506141a ("dmaengine: at_hdmac: Fix deadlocks")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6ba826cbb57d675f447b59323204d1473bbd5593 Mon Sep 17 00:00:00 2001
From: Tudor Ambarus <tudor.ambarus@microchip.com>
Date: Tue, 25 Oct 2022 12:02:43 +0300
Subject: [PATCH] dmaengine: at_hdmac: Free the memset buf without holding the
 chan lock

There's no need to hold the channel lock when freeing the memset buf, as
the operation has already completed. Free the memset buf without holding
the channel lock.

Fixes: 4d112426c344 ("dmaengine: hdmac: Add memset capabilities")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20221025090306.297886-1-tudor.ambarus@microchip.com
Link: https://lore.kernel.org/r/20221025090306.297886-10-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 2012ecc57826..0fb44f622d35 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -462,13 +462,6 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
 	if (!atc_chan_is_cyclic(atchan))
 		dma_cookie_complete(txd);
 
-	/* If the transfer was a memset, free our temporary buffer */
-	if (desc->memset_buffer) {
-		dma_pool_free(atdma->memset_pool, desc->memset_vaddr,
-			      desc->memset_paddr);
-		desc->memset_buffer = false;
-	}
-
 	/* Remove transfer node from the active list. */
 	list_del_init(&desc->desc_node);
 	spin_unlock_irqrestore(&atchan->lock, flags);
@@ -487,6 +480,13 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
 	/* add myself to free_list */
 	list_add(&desc->desc_node, &atchan->free_list);
 	spin_unlock_irqrestore(&atchan->lock, flags);
+
+	/* If the transfer was a memset, free our temporary buffer */
+	if (desc->memset_buffer) {
+		dma_pool_free(atdma->memset_pool, desc->memset_vaddr,
+			      desc->memset_paddr);
+		desc->memset_buffer = false;
+	}
 }
 
 /**

