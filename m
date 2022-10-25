Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5937460C72B
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 11:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbiJYJDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 05:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbiJYJDS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 05:03:18 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35E2158D41;
        Tue, 25 Oct 2022 02:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666688596; x=1698224596;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TgbQH3tyBDckuaVcBkNtbcrgwRusROVAuC+sPJxgh9A=;
  b=afZbwHCihAksfn8P65LQg1xnS6LX+DqpOViSCeNpQu58JL44Q5wUM7ER
   mAN1cKg1EqcCmCuRvr0K365bbnMqRoQRlTBHbK2Y3fZFGy/ccNb+orUxv
   nq/YATXYSr1rm/0mkwvbBU2g1ilpUJplcq1JfTEscAdCAOD9I7KtP/PEs
   tkHiOhTGTAID4sgE1sqr4fYTOhJLz39RMdZ1oP/1GExPu2LKEajqIISV/
   EiX7/4LKe+QaULnsr2pUpfYfdHfsB3qQ8kVZiYPQLiUSn8oWRYXaD3Oib
   eMAciOV99/8A6l/Gof6a/3LH6eDds3gY67G43enLY/f2XIcXJGZGqwpq2
   A==;
X-IronPort-AV: E=Sophos;i="5.95,211,1661842800"; 
   d="scan'208";a="186273025"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Oct 2022 02:03:15 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 25 Oct 2022 02:03:15 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 25 Oct 2022 02:03:12 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <vkoul@kernel.org>, <peda@axentia.se>, <du@axentia.se>
CC:     <maciej.sosnowski@intel.com>, <nicolas.ferre@microchip.com>,
        <mripard@kernel.org>, <torfl6749@gmail.com>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Tudor Ambarus" <tudor.ambarus@microchip.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 01/32] dmaengine: at_hdmac: Fix at_lli struct definition
Date:   Tue, 25 Oct 2022 12:02:35 +0300
Message-ID: <20221025090306.297886-2-tudor.ambarus@microchip.com>
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

Those hardware registers are all of 32 bits, while dma_addr_t ca be of
type u64 or u32 depending on CONFIG_ARCH_DMA_ADDR_T_64BIT. Force u32 to
comply with what the hardware expects.

Fixes: dc78baa2b90b ("dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
---
 drivers/dma/at_hdmac_regs.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/at_hdmac_regs.h b/drivers/dma/at_hdmac_regs.h
index 4d1ebc040031..d4d382d74607 100644
--- a/drivers/dma/at_hdmac_regs.h
+++ b/drivers/dma/at_hdmac_regs.h
@@ -186,13 +186,13 @@
 /* LLI == Linked List Item; aka DMA buffer descriptor */
 struct at_lli {
 	/* values that are not changed by hardware */
-	dma_addr_t	saddr;
-	dma_addr_t	daddr;
+	u32 saddr;
+	u32 daddr;
 	/* value that may get written back: */
-	u32		ctrla;
+	u32 ctrla;
 	/* more values that are not changed by hardware */
-	u32		ctrlb;
-	dma_addr_t	dscr;	/* chain to next lli */
+	u32 ctrlb;
+	u32 dscr;	/* chain to next lli */
 };
 
 /**
-- 
2.25.1

