Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0637C59AE1A
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 15:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347275AbiHTM7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 08:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347106AbiHTM64 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 08:58:56 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6BD2B1A1;
        Sat, 20 Aug 2022 05:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661000301; x=1692536301;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PCoOcNi4gHsugNwjMnoPFdo3B9vCHVSc5ivgIMrs5J0=;
  b=gyWBDmti1ik4wYqA1PbYL7UpJJjf4UEKzC9XzeXqhbzhPKlEdAiD8qg+
   DLOwQLzOEnZYZzCB6NO6Yfg+pilWtFyAvP9WWN1O3lwvUDOjoNiP0uYXG
   SL6Z03ts8tukCGMkBu2LDffs3nELttVlFr5iAYpymguk4ASkSbVuqkrLC
   S3G4bIjoRpJNOUIapMsuFtIf/LJtbG2G1voeDkk+2JIK7uN51FeBgmAZX
   pO3sL79H66VodVF9H6rM1VGtYDZNP/PsPmcnBkNilOJj1W0jOMONIriuu
   YGXMoM4urKP2wzp352lp1SFzKtJQIbnv0X0xDaOcn0p4BgZ0xKA6umhNF
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,251,1654585200"; 
   d="scan'208";a="109911541"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Aug 2022 05:58:18 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sat, 20 Aug 2022 05:58:18 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sat, 20 Aug 2022 05:58:15 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <vkoul@kernel.org>, <peda@axentia.se>, <du@axentia.se>,
        <regressions@leemhuis.info>
CC:     <ludovic.desroches@microchip.com>, <maciej.sosnowski@intel.com>,
        <tudor.ambarus@microchip.com>, <dan.j.williams@intel.com>,
        <nicolas.ferre@microchip.com>, <mripard@kernel.org>,
        <torfl6749@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <stable@vger.kernel.org>
Subject: [PATCH 16/33] dmaengine: at_hdmac: Fix concurrency over the active list
Date:   Sat, 20 Aug 2022 15:57:00 +0300
Message-ID: <20220820125717.588722-17-tudor.ambarus@microchip.com>
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

The tasklet did not held the channel lock when retrieving the first active
descriptor, causing concurrency problems if issue_pending() was called in
between. If issue_pending() was called exactly after the lock was released
in the tasklet, atc_chain_complete() could complete a descriptor for which
the controller has not yet raised an interrupt.

Fixes: dc78baa2b90b ("dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller")
Reported-by: Peter Rosin <peda@axentia.se>
Cc: stable@vger.kernel.org
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
---
 drivers/dma/at_hdmac.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index c2b3d7b63920..635c3be74399 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -897,8 +897,6 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
 	if (!atc_chan_is_cyclic(atchan))
 		dma_cookie_complete(txd);
 
-	/* Remove transfer node from the active list. */
-	list_del_init(&desc->desc_node);
 	spin_unlock_irqrestore(&atchan->lock, flags);
 
 	dma_descriptor_unmap(txd);
@@ -930,6 +928,7 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
  */
 static void atc_advance_work(struct at_dma_chan *atchan)
 {
+	struct at_desc *desc;
 	unsigned long flags;
 
 	dev_vdbg(chan2dev(&atchan->dma_chan), "advance_work\n");
@@ -937,9 +936,12 @@ static void atc_advance_work(struct at_dma_chan *atchan)
 	spin_lock_irqsave(&atchan->lock, flags);
 	if (atc_chan_is_enabled(atchan) || list_empty(&atchan->active_list))
 		return spin_unlock_irqrestore(&atchan->lock, flags);
-	spin_unlock_irqrestore(&atchan->lock, flags);
 
-	atc_chain_complete(atchan, atc_first_active(atchan));
+	desc = atc_first_active(atchan);
+	/* Remove the transfer node from the active list. */
+	list_del_init(&desc->desc_node);
+	spin_unlock_irqrestore(&atchan->lock, flags);
+	atc_chain_complete(atchan, desc);
 
 	/* advance work */
 	spin_lock_irqsave(&atchan->lock, flags);
-- 
2.25.1

