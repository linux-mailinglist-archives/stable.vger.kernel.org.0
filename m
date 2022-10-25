Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D969260C740
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 11:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbiJYJEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 05:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231985AbiJYJDx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 05:03:53 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB14715A958;
        Tue, 25 Oct 2022 02:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666688616; x=1698224616;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vzbP7zNV4WWjKYut34MMlg3SmrYxTKJy5nmzawe3BVg=;
  b=TIBXgt5cbTIXZZzFlRERFRiDVwV1+aSXBB9c15KvDWOG8jmWLeT7jjL9
   wuDqncquHYlLdukwAonG/PQxVzaYd0MBjULichILn8ikuZnxmhMPT01ly
   xzH/NoQlU+tKBFC8abxjBHbNydde+FVPya9og/MuVFKz233QBaZTtTVsA
   Zy9RmLF5SGw6CSUwTqfEfejLtPHxei2FTS12lYl6L6RGYevhwe4GAx+X6
   49aoKynDi2XzI9Cq4iOnlsSFzkKT5e4UrRTwhEaew4qB2vKvn9fQowzQa
   XF0MrXvJBP6/Rm9JRX8QsG81GPOn2KkmJ7DPiVlDuJeNoLqybRGVYPwGG
   A==;
X-IronPort-AV: E=Sophos;i="5.95,211,1661842800"; 
   d="scan'208";a="120221261"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Oct 2022 02:03:33 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 25 Oct 2022 02:03:33 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 25 Oct 2022 02:03:31 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <vkoul@kernel.org>, <peda@axentia.se>, <du@axentia.se>
CC:     <maciej.sosnowski@intel.com>, <nicolas.ferre@microchip.com>,
        <mripard@kernel.org>, <torfl6749@gmail.com>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Tudor Ambarus" <tudor.ambarus@microchip.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 07/32] dmaengine: at_hdmac: Fix concurrency problems by removing atc_complete_all()
Date:   Tue, 25 Oct 2022 12:02:41 +0300
Message-ID: <20221025090306.297886-8-tudor.ambarus@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221025090306.297886-1-tudor.ambarus@microchip.com>
References: <20221025090306.297886-1-tudor.ambarus@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

atc_complete_all() had concurrency bugs, thus remove it:
1/ atc_complete_all() in its entirety was buggy, as when the atchan->queue
list (the one that contains descriptors that are not yet issued to the
hardware) contained descriptors, it fired just the first from the
atchan->queue, but moved all the desc from atchan->queue to
atchan->active_list and considered them all as fired. This could result in
calling the completion of a descriptor that was not yet issued to the
hardware.
2/ when in tasklet at atc_advance_work() time, atchan->active_list was
queried without holding the lock of the chan. This can result in
atchan->active_list concurrency problems between the tasklet and
issue_pending().

Fixes: dc78baa2b90b ("dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller")
Reported-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
---
 drivers/dma/at_hdmac.c | 49 ++++--------------------------------------
 1 file changed, 4 insertions(+), 45 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index deb4c6027436..f1e6fa6af6c2 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -485,42 +485,6 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
 	dma_run_dependencies(txd);
 }
 
-/**
- * atc_complete_all - finish work for all transactions
- * @atchan: channel to complete transactions for
- *
- * Eventually submit queued descriptors if any
- *
- * Assume channel is idle while calling this function
- * Called with atchan->lock held and bh disabled
- */
-static void atc_complete_all(struct at_dma_chan *atchan)
-{
-	struct at_desc *desc, *_desc;
-	LIST_HEAD(list);
-	unsigned long flags;
-
-	dev_vdbg(chan2dev(&atchan->chan_common), "complete all\n");
-
-	spin_lock_irqsave(&atchan->lock, flags);
-
-	/*
-	 * Submit queued descriptors ASAP, i.e. before we go through
-	 * the completed ones.
-	 */
-	if (!list_empty(&atchan->queue))
-		atc_dostart(atchan, atc_first_queued(atchan));
-	/* empty active_list now it is completed */
-	list_splice_init(&atchan->active_list, &list);
-	/* empty queue list by moving descriptors (if any) to active_list */
-	list_splice_init(&atchan->queue, &atchan->active_list);
-
-	spin_unlock_irqrestore(&atchan->lock, flags);
-
-	list_for_each_entry_safe(desc, _desc, &list, desc_node)
-		atc_chain_complete(atchan, desc);
-}
-
 /**
  * atc_advance_work - at the end of a transaction, move forward
  * @atchan: channel where the transaction ended
@@ -528,25 +492,20 @@ static void atc_complete_all(struct at_dma_chan *atchan)
 static void atc_advance_work(struct at_dma_chan *atchan)
 {
 	unsigned long flags;
-	int ret;
 
 	dev_vdbg(chan2dev(&atchan->chan_common), "advance_work\n");
 
 	spin_lock_irqsave(&atchan->lock, flags);
-	ret = atc_chan_is_enabled(atchan);
+	if (atc_chan_is_enabled(atchan) || list_empty(&atchan->active_list))
+		return spin_unlock_irqrestore(&atchan->lock, flags);
 	spin_unlock_irqrestore(&atchan->lock, flags);
-	if (ret)
-		return;
-
-	if (list_empty(&atchan->active_list) ||
-	    list_is_singular(&atchan->active_list))
-		return atc_complete_all(atchan);
 
 	atc_chain_complete(atchan, atc_first_active(atchan));
 
 	/* advance work */
 	spin_lock_irqsave(&atchan->lock, flags);
-	atc_dostart(atchan, atc_first_active(atchan));
+	if (!list_empty(&atchan->active_list))
+		atc_dostart(atchan, atc_first_active(atchan));
 	spin_unlock_irqrestore(&atchan->lock, flags);
 }
 
-- 
2.25.1

