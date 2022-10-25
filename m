Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E776460C73B
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 11:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbiJYJD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 05:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbiJYJDt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 05:03:49 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0EE15A336;
        Tue, 25 Oct 2022 02:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666688612; x=1698224612;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ul7BWlxhjD0J6EB9rCSizho6eFo0osfoJ9tcx8Tf/VE=;
  b=PAwd3TXi78DZ0Buooa/KLIU9o410IN/966q5h9XmmTwo55c6800VtxHy
   h5c2WDy7wduKDEwxp8VUINAm1yDCPJn3UqnxlBS9iziQlTyQJPynaoOLS
   xRmoUPqNWlxzyb1L5obZqQHcYdGBLqswBSQXawiuM8wD6z2wlEEU5yGgZ
   B5BTqxHMXL5HJtmIpzaGaJnCMnM/80xVD5ur879giiiQBdW5wT7kH/ySa
   gOAHSlab0iwuxV+OZIWjRKRxgtGX+TkhfSd8PpnLBRMHDeyAYAl17reX8
   TlmMgmqYE3tHmkeb4N1ABoDIRZkDnuhQ7271LGSwG1fje64YVYSqjAuNO
   g==;
X-IronPort-AV: E=Sophos;i="5.95,211,1661842800"; 
   d="scan'208";a="120221233"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Oct 2022 02:03:30 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 25 Oct 2022 02:03:27 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 25 Oct 2022 02:03:25 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <vkoul@kernel.org>, <peda@axentia.se>, <du@axentia.se>
CC:     <maciej.sosnowski@intel.com>, <nicolas.ferre@microchip.com>,
        <mripard@kernel.org>, <torfl6749@gmail.com>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Tudor Ambarus" <tudor.ambarus@microchip.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 05/32] dmaengine: at_hdmac: Do not call the complete callback on device_terminate_all
Date:   Tue, 25 Oct 2022 12:02:39 +0300
Message-ID: <20221025090306.297886-6-tudor.ambarus@microchip.com>
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
index cb5522417db6..11816484843e 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1437,11 +1437,8 @@ static int atc_terminate_all(struct dma_chan *chan)
 	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
 	struct at_dma		*atdma = to_at_dma(chan->device);
 	int			chan_id = atchan->chan_common.chan_id;
-	struct at_desc		*desc, *_desc;
 	unsigned long		flags;
 
-	LIST_HEAD(list);
-
 	dev_vdbg(chan2dev(chan), "%s\n", __func__);
 
 	/*
@@ -1460,15 +1457,11 @@ static int atc_terminate_all(struct dma_chan *chan)
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

