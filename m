Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18865627F78
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237631AbiKNM7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:59:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237630AbiKNM7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:59:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E939E26105
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:59:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99235B80EBD
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD65C433C1;
        Mon, 14 Nov 2022 12:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430778;
        bh=Em/KO0R9t1ngroJpDWPjJd7vc4dnphpRb6Qgepzu0qE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vuEJQm9YsgT8J3aAnnWIdes9nqJErET7b80To+Ne/UpSBqq3hzXaJ/TB6Y1wvuvda
         cNJXR0jQNg/sv5UNZ1sBZs32Oal/WUr10fAJiMhMjiQl3XhIH5gEygnwnRFGL3YotN
         RItEHf/ksUyJLuFm0CMBYWxYsPI3dn/jIw1u8sOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Rosin <peda@axentia.se>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 124/131] dmaengine: at_hdmac: Fix descriptor handling when issuing it to hardware
Date:   Mon, 14 Nov 2022 13:46:33 +0100
Message-Id: <20221114124453.962387624@linuxfoundation.org>
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

commit ba2423633ba646e1df20e30cb3cf35495c16f173 upstream.

As it was before, the descriptor was issued to the hardware without adding
it to the active (issued) list. This could result in a completion of other
descriptor, or/and in the descriptor never being completed.

Fixes: dc78baa2b90b ("dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller")
Reported-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20221025090306.297886-1-tudor.ambarus@microchip.com
Link: https://lore.kernel.org/r/20221025090306.297886-12-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_hdmac.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -510,8 +510,11 @@ static void atc_advance_work(struct at_d
 
 	/* advance work */
 	spin_lock_irqsave(&atchan->lock, flags);
-	if (!list_empty(&atchan->active_list))
-		atc_dostart(atchan, atc_first_active(atchan));
+	if (!list_empty(&atchan->active_list)) {
+		desc = atc_first_queued(atchan);
+		list_move_tail(&desc->desc_node, &atchan->active_list);
+		atc_dostart(atchan, desc);
+	}
 	spin_unlock_irqrestore(&atchan->lock, flags);
 }
 
@@ -523,6 +526,7 @@ static void atc_advance_work(struct at_d
 static void atc_handle_error(struct at_dma_chan *atchan)
 {
 	struct at_desc *bad_desc;
+	struct at_desc *desc;
 	struct at_desc *child;
 	unsigned long flags;
 
@@ -540,8 +544,11 @@ static void atc_handle_error(struct at_d
 	list_splice_init(&atchan->queue, atchan->active_list.prev);
 
 	/* Try to restart the controller */
-	if (!list_empty(&atchan->active_list))
-		atc_dostart(atchan, atc_first_active(atchan));
+	if (!list_empty(&atchan->active_list)) {
+		desc = atc_first_queued(atchan);
+		list_move_tail(&desc->desc_node, &atchan->active_list);
+		atc_dostart(atchan, desc);
+	}
 
 	/*
 	 * KERN_CRITICAL may seem harsh, but since this only happens


