Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8AE627F6E
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237610AbiKNM7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:59:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237611AbiKNM7L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:59:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B5011A3D
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:59:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D11B9CE0FFA
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF2FC433D6;
        Mon, 14 Nov 2022 12:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430746;
        bh=S+OwcXwkbmvk5sG4t2CESIBuz3Rb2maCPCAuozB2anI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OFWbEseTrlMNEsQ9YVliMIllw9fQ2cv06U689huirAV4T2NlSSR1tmrSiSYheMX0Y
         v6bahLgVd6YC9C5Y8NI6Tp3lCs5sE6eIXppxuYWD+4VvGiLjjwtwEsx99gCmvMxwuu
         eS73jA49xoVFqOCG986QK22dBkjyRRBdA6NsGogw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Rosin <peda@axentia.se>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 117/131] dmaengine: at_hdmac: Fix premature completion of desc in issue_pending
Date:   Mon, 14 Nov 2022 13:46:26 +0100
Message-Id: <20221114124453.661942638@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit fcd37565efdaffeac179d0f0ce980ac79bfdf569 upstream.

Multiple calls to atc_issue_pending() could result in a premature
completion of a descriptor from the atchan->active list, as the method
always completed the first active descriptor from the list. Instead,
issue_pending() should just take the first transaction descriptor from the
pending queue, move it to active_list and start the transfer.

Fixes: dc78baa2b90b ("dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller")
Reported-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20221025090306.297886-1-tudor.ambarus@microchip.com
Link: https://lore.kernel.org/r/20221025090306.297886-5-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_hdmac.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1519,16 +1519,26 @@ atc_tx_status(struct dma_chan *chan,
 }
 
 /**
- * atc_issue_pending - try to finish work
+ * atc_issue_pending - takes the first transaction descriptor in the pending
+ * queue and starts the transfer.
  * @chan: target DMA channel
  */
 static void atc_issue_pending(struct dma_chan *chan)
 {
-	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
+	struct at_dma_chan *atchan = to_at_dma_chan(chan);
+	struct at_desc *desc;
+	unsigned long flags;
 
 	dev_vdbg(chan2dev(chan), "issue_pending\n");
 
-	atc_advance_work(atchan);
+	spin_lock_irqsave(&atchan->lock, flags);
+	if (atc_chan_is_enabled(atchan) || list_empty(&atchan->queue))
+		return spin_unlock_irqrestore(&atchan->lock, flags);
+
+	desc = atc_first_queued(atchan);
+	list_move_tail(&desc->desc_node, &atchan->active_list);
+	atc_dostart(atchan, desc);
+	spin_unlock_irqrestore(&atchan->lock, flags);
 }
 
 /**


