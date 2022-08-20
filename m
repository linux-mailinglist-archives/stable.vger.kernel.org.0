Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B9059AE02
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 15:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346491AbiHTM6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 08:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346657AbiHTM6V (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 08:58:21 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B948670F;
        Sat, 20 Aug 2022 05:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661000279; x=1692536279;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x8AZUEEXp2aHpZGcwDmioSQ2fEKe+n6TrnEWupdslZs=;
  b=nHgniFR+7ZpGxZtwlj2Ai/PISZLNDV8rPHTPNQtKQcuyP2YgzQ2VeqQC
   Nb76JN9Pa1vz2p4ZqKQTq2R+ATatB6JKbUnYJRH1g19j4ZoK8VKjf7sEg
   e9W7n5cjtUFAMVc5UU/gk1pUpId9+0EV2n4o0zymToZ6s7NK2q9Pz8t64
   GuzgE3oA9/a/ujnF0H3GC6ibOnDEAYAijmm1O/cVQHL70n9wR1TxvzTol
   Tbrx/A60HcCK0x9DcAJVbS1ooUE1eBh08mgUi+IKFbaNRK1b2UJKO9910
   jjcrjJuPYAPOmKBmZvgP0K/4k96SAsOZ5dXTbYAbecH+pyzK4p7ejKIQp
   A==;
X-IronPort-AV: E=Sophos;i="5.93,251,1654585200"; 
   d="scan'208";a="109911348"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Aug 2022 05:57:58 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sat, 20 Aug 2022 05:57:57 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sat, 20 Aug 2022 05:57:53 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <vkoul@kernel.org>, <peda@axentia.se>, <du@axentia.se>,
        <regressions@leemhuis.info>
CC:     <ludovic.desroches@microchip.com>, <maciej.sosnowski@intel.com>,
        <tudor.ambarus@microchip.com>, <dan.j.williams@intel.com>,
        <nicolas.ferre@microchip.com>, <mripard@kernel.org>,
        <torfl6749@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <stable@vger.kernel.org>
Subject: [PATCH 10/33] dmaengine: at_hdmac: Fix premature completion of desc in issue_pending
Date:   Sat, 20 Aug 2022 15:56:54 +0300
Message-ID: <20220820125717.588722-11-tudor.ambarus@microchip.com>
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
---
 drivers/dma/at_hdmac.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index d9f492081e76..c445575f8646 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1963,16 +1963,26 @@ atc_tx_status(struct dma_chan *chan,
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
-- 
2.25.1

