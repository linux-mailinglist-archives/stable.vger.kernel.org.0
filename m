Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D502F60C736
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 11:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbiJYJD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 05:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbiJYJD0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 05:03:26 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D05159A1F;
        Tue, 25 Oct 2022 02:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666688605; x=1698224605;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l7OewSpbHJXGmYf7pMLsslFC7RsyklewLjVzhb94scc=;
  b=DilI6tNfwHYVhBs6vw5VKo5veGYy+6HdRKgSEz8HIdYIro2zmmxrZXeu
   jJniAliOxF4QqDyZDOrdyyfeKUjJt4OtSeYKWwlC7pf5vYETlDFbqYsMW
   ZT/NfRqsEIQV4/5dT/kCmCpRVzno/Au0d6UxzOsUMK9vG/I9i2J4Nap9j
   xIjLry2LrOnXv7wubTWrZoi7OIbUMlaKjdxUUKXw7bW+y9orCJeEr70RR
   n+3eXRcx4HcHBkcVQ7MtPN/G/JOzGAHPkjkvSR9pjq53DQJ6DLX3YDNyx
   HuE8a+RGGxoABvDtQXpZ/cvVtT59E+olYfGoTJRp7IXN7gEH3FVHrbpTy
   A==;
X-IronPort-AV: E=Sophos;i="5.95,211,1661842800"; 
   d="scan'208";a="186273050"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Oct 2022 02:03:25 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 25 Oct 2022 02:03:24 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 25 Oct 2022 02:03:21 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <vkoul@kernel.org>, <peda@axentia.se>, <du@axentia.se>
CC:     <maciej.sosnowski@intel.com>, <nicolas.ferre@microchip.com>,
        <mripard@kernel.org>, <torfl6749@gmail.com>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Tudor Ambarus" <tudor.ambarus@microchip.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 04/32] dmaengine: at_hdmac: Fix premature completion of desc in issue_pending
Date:   Tue, 25 Oct 2022 12:02:38 +0300
Message-ID: <20221025090306.297886-5-tudor.ambarus@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221025090306.297886-1-tudor.ambarus@microchip.com>
References: <20221025090306.297886-1-tudor.ambarus@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
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
index e9d0c3632868..cb5522417db6 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1527,16 +1527,26 @@ atc_tx_status(struct dma_chan *chan,
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

