Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856A5627BBD
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 12:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbiKNLKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 06:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236770AbiKNLKA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 06:10:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E954722B28
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 03:08:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B683F60FBF
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 11:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA13DC433B5;
        Mon, 14 Nov 2022 11:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668424080;
        bh=eIeVAo/YFC8zP71oiC0nw+jxzDcnUVqiZZ35sxDoilI=;
        h=Subject:To:Cc:From:Date:From;
        b=BBPnwfyVk0wg7NnNhT9t3NBeDiwHYc+Pk/TmbngRY/3SbQ/gZ3tQRkoi6/Lq9GDs8
         9vKyJ4eXVvo7KTfAzcFpDX1dUfwEZbuUbi7L1I+0aNvI7JGtVXgRGWmscAnCVT6tqj
         wMHGkKXWCmEdk6Q+2EowWLjygU71KrUF2FmoxJlA=
Subject: FAILED: patch "[PATCH] dmaengine: at_hdmac: Do not call the complete callback on" failed to apply to 4.14-stable tree
To:     tudor.ambarus@microchip.com, nicolas.ferre@microchip.com,
        peda@axentia.se, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Nov 2022 12:07:46 +0100
Message-ID: <166842406619117@kroah.com>
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

f645f85ae110 ("dmaengine: at_hdmac: Do not call the complete callback on device_terminate_all")
078a6506141a ("dmaengine: at_hdmac: Fix deadlocks")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f645f85ae1104f8bd882f962ac0a69a1070076dd Mon Sep 17 00:00:00 2001
From: Tudor Ambarus <tudor.ambarus@microchip.com>
Date: Tue, 25 Oct 2022 12:02:39 +0300
Subject: [PATCH] dmaengine: at_hdmac: Do not call the complete callback on
 device_terminate_all

The method was wrong because it violated the dmaengine API. For aborted
transfers the complete callback should not be called. Fix the behavior and
do not call the complete callback on device_terminate_all.

Fixes: 808347f6a317 ("dmaengine: at_hdmac: add DMA slave transfers")
Reported-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20221025090306.297886-1-tudor.ambarus@microchip.com
Link: https://lore.kernel.org/r/20221025090306.297886-6-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index cb5522417db6..11816484843e 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1437,11 +1437,8 @@ static int atc_terminate_all(struct dma_chan *chan)
 	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
 	struct at_dma		*atdma = to_at_dma(chan->device);
 	int			chan_id = atchan->chan_common.chan_id;
-	struct at_desc		*desc, *_desc;
 	unsigned long		flags;
 
-	LIST_HEAD(list);
-
 	dev_vdbg(chan2dev(chan), "%s\n", __func__);
 
 	/*
@@ -1460,15 +1457,11 @@ static int atc_terminate_all(struct dma_chan *chan)
 		cpu_relax();
 
 	/* active_list entries will end up before queued entries */
-	list_splice_init(&atchan->queue, &list);
-	list_splice_init(&atchan->active_list, &list);
+	list_splice_tail_init(&atchan->queue, &atchan->free_list);
+	list_splice_tail_init(&atchan->active_list, &atchan->free_list);
 
 	spin_unlock_irqrestore(&atchan->lock, flags);
 
-	/* Flush all pending and queued descriptors */
-	list_for_each_entry_safe(desc, _desc, &list, desc_node)
-		atc_chain_complete(atchan, desc);
-
 	clear_bit(ATC_IS_PAUSED, &atchan->status);
 	/* if channel dedicated to cyclic operations, free it */
 	clear_bit(ATC_IS_CYCLIC, &atchan->status);

