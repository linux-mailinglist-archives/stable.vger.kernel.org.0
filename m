Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2626E59AE0C
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 15:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347117AbiHTM7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 08:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347097AbiHTM64 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 08:58:56 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6712333401;
        Sat, 20 Aug 2022 05:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661000303; x=1692536303;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vIgVkkfz/b3mQLLZ3zILp+PgayQARWMRUG+RmaFC4oA=;
  b=XL/hbbsHFgT75mzodtixFrKaQnkHjDrZ1Jx6nzeKOIWcygy0vVB0vaUJ
   ZsvybmJuH2wFgtxqNyIrD4NAin0qxtzM9eviFa7AIKKNfjilXpnokqsw2
   jIIXyYVbUAXjNPZjdEC+12K+/isu0V40WuVTlMPfvCbcZgj1DPDeGX0WR
   g4TzAVf1ihI/4BFF2IkKjGoLl9BDnH5DNZ3VETozaXU76CeR0Ra6yfDw9
   +CKjNTnrnqDnUCH/OQZYCKGCne0znSQQg/9cgY6n+hwven7bnmGSUDbO6
   pR5NW7Lm7stmbCuGvmNxMB3oi0PJ+6fASDdrhTKzUUgkhtoDHxEi7m6Wj
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,251,1654585200"; 
   d="scan'208";a="109911571"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Aug 2022 05:58:22 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sat, 20 Aug 2022 05:58:21 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sat, 20 Aug 2022 05:58:18 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <vkoul@kernel.org>, <peda@axentia.se>, <du@axentia.se>,
        <regressions@leemhuis.info>
CC:     <ludovic.desroches@microchip.com>, <maciej.sosnowski@intel.com>,
        <tudor.ambarus@microchip.com>, <dan.j.williams@intel.com>,
        <nicolas.ferre@microchip.com>, <mripard@kernel.org>,
        <torfl6749@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <stable@vger.kernel.org>
Subject: [PATCH 17/33] dmaengine: at_hdmac: Fix descriptor handling when issuing it to hardware
Date:   Sat, 20 Aug 2022 15:57:01 +0300
Message-ID: <20220820125717.588722-18-tudor.ambarus@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220820125717.588722-1-tudor.ambarus@microchip.com>
References: <20220820125717.588722-1-tudor.ambarus@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As it was before, the descriptor was issued to the hardware without adding
it to the active (issued) list. This could result in a completion of other
descriptor, or/and in the descriptor never being completed.

Fixes: dc78baa2b90b ("dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller")
Reported-by: Peter Rosin <peda@axentia.se>
Cc: stable@vger.kernel.org
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
---
 drivers/dma/at_hdmac.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 635c3be74399..e5ac73768d13 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -945,8 +945,11 @@ static void atc_advance_work(struct at_dma_chan *atchan)
 
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
 
@@ -958,6 +961,7 @@ static void atc_advance_work(struct at_dma_chan *atchan)
 static void atc_handle_error(struct at_dma_chan *atchan)
 {
 	struct at_desc *bad_desc;
+	struct at_desc *desc;
 	struct at_desc *child;
 	unsigned long flags;
 
@@ -975,8 +979,11 @@ static void atc_handle_error(struct at_dma_chan *atchan)
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
-- 
2.25.1

