Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C031627ED3
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237366AbiKNMwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237447AbiKNMv5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:51:57 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB2A24F01
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:51:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BAA19CE0FF1
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E190C433C1;
        Mon, 14 Nov 2022 12:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430312;
        bh=R6qke8QktIDn/JeI1k00Ojjm+LwJpTstlbczEHNKeXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KOeY39nSepU3Da2X3ic71d5PX4Z7dIqfLwJEJP9kTilbGLW4CWRqcKU5leFzyUvrO
         u6MXQ2ypaWY6cT17LabQ1jEgjwGm4roesSlU3MPD1PLM/GUSkZiERuvCpFiHhUtsJO
         xNNOugXHqJa/1LSsxC2F3YYaAZjvPP/BNo4CoDCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Rosin <peda@axentia.se>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 88/95] dmaengine: at_hdmac: Fix concurrency over the active list
Date:   Mon, 14 Nov 2022 13:46:22 +0100
Message-Id: <20221114124446.172266022@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
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

commit 03ed9ba357cc78116164b90b87f45eacab60b561 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_hdmac.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -443,8 +443,6 @@ atc_chain_complete(struct at_dma_chan *a
 	if (!atc_chan_is_cyclic(atchan))
 		dma_cookie_complete(txd);
 
-	/* Remove transfer node from the active list. */
-	list_del_init(&desc->desc_node);
 	spin_unlock_irqrestore(&atchan->lock, flags);
 
 	dma_descriptor_unmap(txd);
@@ -476,6 +474,7 @@ atc_chain_complete(struct at_dma_chan *a
  */
 static void atc_advance_work(struct at_dma_chan *atchan)
 {
+	struct at_desc *desc;
 	unsigned long flags;
 
 	dev_vdbg(chan2dev(&atchan->chan_common), "advance_work\n");
@@ -483,9 +482,12 @@ static void atc_advance_work(struct at_d
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


