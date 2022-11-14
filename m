Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 888D8627ECE
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237433AbiKNMvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:51:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237366AbiKNMvq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:51:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE5124BF1
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:51:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F23B76117B
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A054C433C1;
        Mon, 14 Nov 2022 12:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430305;
        bh=oyXVF/JUCZ5cMOtmonaoVxP/YybNEDxETh9RBRjO4oQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UuG2E6qO3qg0245uSq7K+4Ftgu56BWkeYER9676fg0MIuuornB9jkqoykaunyp6Dy
         jBEJwoSvKBweihHMIkqg+bjlMBFaf4LuXPM/jA67xXdCZ+wSL6MTNV5EDgEVr61SIx
         BhRSrFh6Pr44M9cwI41M5L0nC0Bvqb0yg4cLeqMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Rosin <peda@axentia.se>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 86/95] dmaengine: at_hdmac: Fix concurrency over descriptor
Date:   Mon, 14 Nov 2022 13:46:20 +0100
Message-Id: <20221114124446.093216587@linuxfoundation.org>
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

commit 06988949df8c3007ad82036d3606d8ae72ed9000 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_hdmac.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -450,11 +450,8 @@ atc_chain_complete(struct at_dma_chan *a
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
@@ -464,6 +461,13 @@ atc_chain_complete(struct at_dma_chan *a
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


