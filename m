Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7205359AE45
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 15:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346880AbiHTM6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 08:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346699AbiHTM6W (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 08:58:22 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D8FF86720;
        Sat, 20 Aug 2022 05:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661000282; x=1692536282;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ev2WPPFIvbj+0cQefzEEUZk+Km1YgglEk5hmm58HEBA=;
  b=vDUkERESiJ/sB1mF5YBjwWzDdTkjfM2molafN93blWmqrXYqM03lWICe
   t3A4+Lv46w5cxqSSBisgoCebqZFPSkLCLhYwSJuFbeoRR+C4ZqdhbtH3A
   +BCdnmDqt5rConAZ8vzlVX9VdbolJsML4q84D4iTpElI7g+6sNtqfe4NU
   foX8eOqhMX+cvZITMnrPuDHwuSAjLpM9wBxWKyIKS1vgUPohfFOCELynn
   RRw3kI+FtPrrXDSws19BotJ2HBKiddi5FNMhAw/YaNwXdG1HiW6W46Evo
   lAohC53k9Xg44k+Pt+A18dFS45NbjNuurxuxH00qPJJZ/TBlkIKBoNHAK
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,251,1654585200"; 
   d="scan'208";a="177042760"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Aug 2022 05:58:02 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sat, 20 Aug 2022 05:58:00 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sat, 20 Aug 2022 05:57:57 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <vkoul@kernel.org>, <peda@axentia.se>, <du@axentia.se>,
        <regressions@leemhuis.info>
CC:     <ludovic.desroches@microchip.com>, <maciej.sosnowski@intel.com>,
        <tudor.ambarus@microchip.com>, <dan.j.williams@intel.com>,
        <nicolas.ferre@microchip.com>, <mripard@kernel.org>,
        <torfl6749@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <stable@vger.kernel.org>
Subject: [PATCH 11/33] dmaengine: at_hdmac: Do not call the complete callback on device_terminate_all
Date:   Sat, 20 Aug 2022 15:56:55 +0300
Message-ID: <20220820125717.588722-12-tudor.ambarus@microchip.com>
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

The method was wrong because it violated the dmaengine API. For aborted
transfers the complete callback should not be called. Fix the behavior and
do not call the complete callback on device_terminate_all.

Fixes: 808347f6a317 ("dmaengine: at_hdmac: add DMA slave transfers")
Reported-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
---
 drivers/dma/at_hdmac.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index c445575f8646..b3895e5d2ae9 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1879,11 +1879,8 @@ static int atc_terminate_all(struct dma_chan *chan)
 	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
 	struct at_dma		*atdma = to_at_dma(chan->device);
 	int			chan_id = atchan->dma_chan.chan_id;
-	struct at_desc		*desc, *_desc;
 	unsigned long		flags;
 
-	LIST_HEAD(list);
-
 	dev_vdbg(chan2dev(chan), "%s\n", __func__);
 
 	/*
@@ -1902,15 +1899,11 @@ static int atc_terminate_all(struct dma_chan *chan)
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
-- 
2.25.1

