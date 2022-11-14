Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E22C627BAA
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 12:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236788AbiKNLI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 06:08:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236702AbiKNLHr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 06:07:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5613A205E3
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 03:07:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ACA8FCE0EEB
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 11:07:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A322C433D7;
        Mon, 14 Nov 2022 11:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668424044;
        bh=Vqokiv9mTVAJ/W2iYwtkYTCFMvqI4BG3zKwApZq0i1Y=;
        h=Subject:To:Cc:From:Date:From;
        b=ioIwo/EaFoqwJQt44stj/ntVvpVePlaoWeif/VkZx+OtEQXCaajMXw9EiX1aRA/JW
         uY0ZfYRXt99BotJh6Y4cdHEg5oAS95N0NUVL2THN6Mv7LQQAFMS8jjBE25oHJVmAUI
         cXEhxfQo7fM0q2krRYvxfEaFaA7we544GXGyobYQ=
Subject: FAILED: patch "[PATCH] dmaengine: at_hdmac: Start transfer for cyclic channels in" failed to apply to 4.9-stable tree
To:     tudor.ambarus@microchip.com, nicolas.ferre@microchip.com,
        peda@axentia.se, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Nov 2022 12:07:07 +0100
Message-ID: <166842402723437@kroah.com>
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

8a47221fc284 ("dmaengine: at_hdmac: Start transfer for cyclic channels in issue_pending")
078a6506141a ("dmaengine: at_hdmac: Fix deadlocks")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8a47221fc28417ff8a32a4f92d4448a56c3cf7e1 Mon Sep 17 00:00:00 2001
From: Tudor Ambarus <tudor.ambarus@microchip.com>
Date: Tue, 25 Oct 2022 12:02:37 +0300
Subject: [PATCH] dmaengine: at_hdmac: Start transfer for cyclic channels in
 issue_pending

Cyclic channels must too call issue_pending in order to start a transfer.
Start the transfer in issue_pending regardless of the type of channel.
This wrongly worked before, because in the past the transfer was started
at tx_submit level when only a desc in the transfer list.

Fixes: 53830cc75974 ("dmaengine: at_hdmac: add cyclic DMA operation support")
Reported-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20221025090306.297886-1-tudor.ambarus@microchip.com
Link: https://lore.kernel.org/r/20221025090306.297886-4-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 3f71f4d2f467..e9d0c3632868 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1536,10 +1536,6 @@ static void atc_issue_pending(struct dma_chan *chan)
 
 	dev_vdbg(chan2dev(chan), "issue_pending\n");
 
-	/* Not needed for cyclic transfers */
-	if (atc_chan_is_cyclic(atchan))
-		return;
-
 	atc_advance_work(atchan);
 }
 

