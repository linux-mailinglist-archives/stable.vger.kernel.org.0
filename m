Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 813A659AE28
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 15:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346879AbiHTM7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 08:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346876AbiHTM6k (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 08:58:40 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88201116C;
        Sat, 20 Aug 2022 05:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661000292; x=1692536292;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mfEKfR/kDEqwduBCnKSuG0rzopsfF4jcYU/YfzU0LvY=;
  b=Xk2iP0lcUoJlEilOgB41Najlc06jCRD/9Ys3urrhlzvSrNRLqLIfU/3t
   uRbnIOOvFLOUBTEFmwCny7RzwqkGzSBFm4t0JURWaDYJPHOBDQ3p4PYNe
   JL+ZjM7aJ5aPwLoHiZebs0SsFVCEGXg1tkFYOx2SDBqbw4/FI/s/jwkPm
   e3RlSiAQunHvmjlDX1eVfffHQMd0d+8yof4Z63itQxUwGaId1myEp/raP
   gVBxMFfrzEh+qHluen2G7XlNdZJsPgaxy4e76xPRacAGpX5ExHyvfThMr
   S/LteGb7LGLeN4GOiMwK49z/Ybl7fhYfF/t53GAqMqiPn9Aj6knIC9nHe
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,251,1654585200"; 
   d="scan'208";a="109911489"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Aug 2022 05:58:11 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sat, 20 Aug 2022 05:58:11 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sat, 20 Aug 2022 05:58:08 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <vkoul@kernel.org>, <peda@axentia.se>, <du@axentia.se>,
        <regressions@leemhuis.info>
CC:     <ludovic.desroches@microchip.com>, <maciej.sosnowski@intel.com>,
        <tudor.ambarus@microchip.com>, <dan.j.williams@intel.com>,
        <nicolas.ferre@microchip.com>, <mripard@kernel.org>,
        <torfl6749@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <stable@vger.kernel.org>
Subject: [PATCH 14/33] dmaengine: at_hdmac: Fix concurrency over descriptor
Date:   Sat, 20 Aug 2022 15:56:58 +0300
Message-ID: <20220820125717.588722-15-tudor.ambarus@microchip.com>
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

The descriptor was added to the free_list before calling the callback,
which could result in reissuing of the same descriptor and calling of a
single callback for both. Move the decriptor to the free list after the
callback is invoked.

Fixes: dc78baa2b90b ("dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller")
Reported-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
---
 drivers/dma/at_hdmac.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 10424a6fcbbf..b3184da7ced4 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -904,11 +904,8 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
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
@@ -918,6 +915,13 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
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
-- 
2.25.1

