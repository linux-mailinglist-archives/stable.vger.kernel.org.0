Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC8B59AE50
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 15:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347202AbiHTM7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 08:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347207AbiHTM7G (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 08:59:06 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE04C4623C;
        Sat, 20 Aug 2022 05:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661000319; x=1692536319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6UA1aa/oWk/6oPhl8ZVj0tQ1hambVkEEzG+xOSJpK/w=;
  b=qWc72wl7/hyMIosqjFo3bLiGFV2SEIiaCu/JdmrKqjN+Knwvp7LHnIAu
   nPc+H1lkyquq5iQVJZhvFRFu3jnoQMYDvcpiuzvxSLPKFLTylMI6IpDYH
   ExDEDM1SDss8UvkUqsJTFtmanifIBJ8jLlwpe9uxxjaZlBveOl7W1yA1S
   z91K2Xf2W/opToKmKypHeWIv0V/6nJurNTK0Ph4rksShwQ1fY4PDW24nC
   mjA1ewcU34dZ7YY+ECnyDju1L3SI0Q0cLpUeKTvESC9xPY+LPciFZx2Bv
   DYD0DaUucL78B4e5P0v+g5c5G4ir0DGCCHQ6Gn3BUz84NT2btKRFLQNpa
   w==;
X-IronPort-AV: E=Sophos;i="5.93,251,1654585200"; 
   d="scan'208";a="187325744"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Aug 2022 05:58:39 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sat, 20 Aug 2022 05:58:35 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sat, 20 Aug 2022 05:58:32 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <vkoul@kernel.org>, <peda@axentia.se>, <du@axentia.se>,
        <regressions@leemhuis.info>
CC:     <ludovic.desroches@microchip.com>, <maciej.sosnowski@intel.com>,
        <tudor.ambarus@microchip.com>, <dan.j.williams@intel.com>,
        <nicolas.ferre@microchip.com>, <mripard@kernel.org>,
        <torfl6749@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <stable@vger.kernel.org>
Subject: [PATCH 21/33] dmaengine: at_hdmac: Fix impossible condition
Date:   Sat, 20 Aug 2022 15:57:05 +0300
Message-ID: <20220820125717.588722-22-tudor.ambarus@microchip.com>
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

The iterator can not be greater than ATC_MAX_DSCR_TRIALS, as the for loop
will stop when i == ATC_MAX_DSCR_TRIALS. While here, use the common "i"
name for the iterator.

Fixes: 93dce3a6434f ("dmaengine: at_hdmac: fix residue computation")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
---
 drivers/dma/at_hdmac.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 16cea65a708d..c72c796d58bc 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -753,7 +753,8 @@ static int atc_get_bytes_left(struct dma_chan *chan, dma_cookie_t cookie)
 	struct at_desc *desc_first = atc_first_active(atchan);
 	struct at_desc *desc;
 	int ret;
-	u32 ctrla, dscr, trials;
+	u32 ctrla, dscr;
+	unsigned int i;
 
 	/*
 	 * If the cookie doesn't match to the currently running transfer then
@@ -823,7 +824,7 @@ static int atc_get_bytes_left(struct dma_chan *chan, dma_cookie_t cookie)
 		dscr = channel_readl(atchan, DSCR);
 		rmb(); /* ensure DSCR is read before CTRLA */
 		ctrla = channel_readl(atchan, CTRLA);
-		for (trials = 0; trials < ATC_MAX_DSCR_TRIALS; ++trials) {
+		for (i = 0; i < ATC_MAX_DSCR_TRIALS; ++i) {
 			u32 new_dscr;
 
 			rmb(); /* ensure DSCR is read after CTRLA */
@@ -849,7 +850,7 @@ static int atc_get_bytes_left(struct dma_chan *chan, dma_cookie_t cookie)
 			rmb(); /* ensure DSCR is read before CTRLA */
 			ctrla = channel_readl(atchan, CTRLA);
 		}
-		if (unlikely(trials >= ATC_MAX_DSCR_TRIALS))
+		if (unlikely(i == ATC_MAX_DSCR_TRIALS))
 			return -ETIMEDOUT;
 
 		/* for the first descriptor we can be more accurate */
-- 
2.25.1

