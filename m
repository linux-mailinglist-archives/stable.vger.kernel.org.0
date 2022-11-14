Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4E76627EE1
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237402AbiKNMwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236203AbiKNMwm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:52:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C2D252A5
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:52:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4D146116A
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1AE7C433D6;
        Mon, 14 Nov 2022 12:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430361;
        bh=ccknNszJM6gbX1ZeY1GhBSIPeKP4uEe0PqeD9BsJWuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M4dBAMEwjKTEe8vQzUJ0hzZadFprm0P2LgA7MfYyUNtL41zyNYIBvxmhR69WWyHfz
         samt/6LPmOer3VdeT0PHusU3Mhu42fWPJemFOsYKoflrUhjALXZMDTTOPoQ/GXcJCS
         l3wBpyClRWLx38pIj/1vo7N7aDPcLZebSkdBHY+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Rosin <peda@axentia.se>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 83/95] dmaengine: at_hdmac: Do not call the complete callback on device_terminate_all
Date:   Mon, 14 Nov 2022 13:46:17 +0100
Message-Id: <20221114124445.984896503@linuxfoundation.org>
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

commit f645f85ae1104f8bd882f962ac0a69a1070076dd upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_hdmac.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1410,11 +1410,8 @@ static int atc_terminate_all(struct dma_
 	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
 	struct at_dma		*atdma = to_at_dma(chan->device);
 	int			chan_id = atchan->chan_common.chan_id;
-	struct at_desc		*desc, *_desc;
 	unsigned long		flags;
 
-	LIST_HEAD(list);
-
 	dev_vdbg(chan2dev(chan), "%s\n", __func__);
 
 	/*
@@ -1433,15 +1430,11 @@ static int atc_terminate_all(struct dma_
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


