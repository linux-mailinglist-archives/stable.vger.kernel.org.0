Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03626280B8
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237820AbiKNNIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:08:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237871AbiKNNIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:08:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758769FDB
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:08:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CC856109A
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169C0C433D7;
        Mon, 14 Nov 2022 13:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431307;
        bh=O0w+ja5dVo0k3u/6+xpEqr6MXaH8Eu9GPid7H3eiZx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HAnuhr8Uzb2AOExdCNh3M7wqUajo+FSqnCsGpnmTY8uUkbMW3Wa7kl/Oe9JsiRENa
         i02bozWV4w83rCjY6B4wMENbwBjE48ns7tFRoisDWebFbA+1U9YsAJQFHfBvh6RMxA
         +lKBLq6p2UrRpbgC/ndkbpYhMRXSNr0XUsUIP0uc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Rosin <peda@axentia.se>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.0 178/190] dmaengine: at_hdmac: Do not call the complete callback on device_terminate_all
Date:   Mon, 14 Nov 2022 13:46:42 +0100
Message-Id: <20221114124506.666926422@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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
@@ -1437,11 +1437,8 @@ static int atc_terminate_all(struct dma_
 	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
 	struct at_dma		*atdma = to_at_dma(chan->device);
 	int			chan_id = atchan->chan_common.chan_id;
-	struct at_desc		*desc, *_desc;
 	unsigned long		flags;
 
-	LIST_HEAD(list);
-
 	dev_vdbg(chan2dev(chan), "%s\n", __func__);
 
 	/*
@@ -1460,15 +1457,11 @@ static int atc_terminate_all(struct dma_
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


