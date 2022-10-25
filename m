Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D215960C753
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 11:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbiJYJFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 05:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbiJYJEN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 05:04:13 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C97160204;
        Tue, 25 Oct 2022 02:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666688625; x=1698224625;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=otOwHLgHLrSuHRXKEz7Xh2PEvd8g6jBAJ0XHPtc1d2I=;
  b=JuWLG/UDp3c2aRHeKbfKiloaVmTvQTrJPHjsETP+RwPRPSZ3X9bG1UCz
   PSI1IlnepsXg7z0uOtFXWWkB7hX3nBOlr4Dl9PcCyOjBsYPRrfCKAAVDU
   hA1zN9GAdJsOqSjTE8N5i/vL5eNN3orzBbbYVL6Tmhx0a7IUUxzUq3BaM
   FZ5Vhhvhz6lENjNQrL9rKPgCYWEHhMZ/LjauKmQJLL/u9VwsWP34qo8TZ
   Yw2o6+pWvbaM/VGL65JOcjFOwJ7hoe+ppq13Dt/BtPbp6hDk/fuamKf19
   EPSMasV6s/rh2+toBPF/X+poqT7RP4QqIjEE/Qw+Y8BOhzfX8lMVZMIm6
   A==;
X-IronPort-AV: E=Sophos;i="5.95,211,1661842800"; 
   d="scan'208";a="180386392"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Oct 2022 02:03:40 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 25 Oct 2022 02:03:39 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 25 Oct 2022 02:03:37 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <vkoul@kernel.org>, <peda@axentia.se>, <du@axentia.se>
CC:     <maciej.sosnowski@intel.com>, <nicolas.ferre@microchip.com>,
        <mripard@kernel.org>, <torfl6749@gmail.com>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Tudor Ambarus" <tudor.ambarus@microchip.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 09/32] dmaengine: at_hdmac: Free the memset buf without holding the chan lock
Date:   Tue, 25 Oct 2022 12:02:43 +0300
Message-ID: <20221025090306.297886-10-tudor.ambarus@microchip.com>
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

There's no need to hold the channel lock when freeing the memset buf, as
the operation has already completed. Free the memset buf without holding
the channel lock.

Fixes: 4d112426c344 ("dmaengine: hdmac: Add memset capabilities")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
---
 drivers/dma/at_hdmac.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 2012ecc57826..0fb44f622d35 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -462,13 +462,6 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
 	if (!atc_chan_is_cyclic(atchan))
 		dma_cookie_complete(txd);
 
-	/* If the transfer was a memset, free our temporary buffer */
-	if (desc->memset_buffer) {
-		dma_pool_free(atdma->memset_pool, desc->memset_vaddr,
-			      desc->memset_paddr);
-		desc->memset_buffer = false;
-	}
-
 	/* Remove transfer node from the active list. */
 	list_del_init(&desc->desc_node);
 	spin_unlock_irqrestore(&atchan->lock, flags);
@@ -487,6 +480,13 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
 	/* add myself to free_list */
 	list_add(&desc->desc_node, &atchan->free_list);
 	spin_unlock_irqrestore(&atchan->lock, flags);
+
+	/* If the transfer was a memset, free our temporary buffer */
+	if (desc->memset_buffer) {
+		dma_pool_free(atdma->memset_pool, desc->memset_vaddr,
+			      desc->memset_paddr);
+		desc->memset_buffer = false;
+	}
 }
 
 /**
-- 
2.25.1

