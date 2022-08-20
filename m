Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D11E759AE2C
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 15:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346920AbiHTM6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 08:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346775AbiHTM6b (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 08:58:31 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05C486C02;
        Sat, 20 Aug 2022 05:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661000285; x=1692536285;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HC98+2Q3J7wqLV6loiePisXOhcp5INxBFqCWpy13QbI=;
  b=t0wg/mFof51+s38D7c2SoI5bU3q5pWDd5ATcNe3S9vsgV99TI+vxn8nS
   jLSUt0HTW+dqJj49pcJkj2+Q4EdHXcYZT1RFA3CBWsT0ZqGYfU/LbT+CG
   c3Sl/4uuNEBlKYqWjI4xfg4lVjVx09ZAqtZXxFcV7JECaBHu3tEtaySLe
   d3JLDsa8Z094depIph8O8ShJJcRHzyTo9qfWRlTeqQ8BruU3nORDW7a6x
   XFcNN0ddbwGmB538FNAdMcRgN1gpzq0ICDqX7+yvgPca+/Ag7u9HOH+kQ
   1iqlFMuCSGzU4MHUIUj8otYyXF7dRgtP1TV5szOmk8iirRpjr8wTD3KX0
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,251,1654585200"; 
   d="scan'208";a="109911419"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Aug 2022 05:58:05 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sat, 20 Aug 2022 05:58:04 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sat, 20 Aug 2022 05:58:01 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <vkoul@kernel.org>, <peda@axentia.se>, <du@axentia.se>,
        <regressions@leemhuis.info>
CC:     <ludovic.desroches@microchip.com>, <maciej.sosnowski@intel.com>,
        <tudor.ambarus@microchip.com>, <dan.j.williams@intel.com>,
        <nicolas.ferre@microchip.com>, <mripard@kernel.org>,
        <torfl6749@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <stable@vger.kernel.org>
Subject: [PATCH 12/33] dmaengine: at_hdmac: Protect atchan->status with the channel lock
Date:   Sat, 20 Aug 2022 15:56:56 +0300
Message-ID: <20220820125717.588722-13-tudor.ambarus@microchip.com>
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

Now that the complete callback call was removed from
device_terminate_all(), we can protect the atchan->status with the channel
lock. The atomic bitops on atchan->status do not substitute proper locking
on the status, as one could still modify the status after the lock was
dropped in atc_terminate_all() but before the atomic bitops were executed.

Fixes: 078a6506141a ("dmaengine: at_hdmac: Fix deadlocks")
Reported-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
---
 drivers/dma/at_hdmac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index b3895e5d2ae9..aeb241832c52 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1902,12 +1902,12 @@ static int atc_terminate_all(struct dma_chan *chan)
 	list_splice_tail_init(&atchan->queue, &atchan->free_list);
 	list_splice_tail_init(&atchan->active_list, &atchan->free_list);
 
-	spin_unlock_irqrestore(&atchan->lock, flags);
-
 	clear_bit(ATC_IS_PAUSED, &atchan->status);
 	/* if channel dedicated to cyclic operations, free it */
 	clear_bit(ATC_IS_CYCLIC, &atchan->status);
 
+	spin_unlock_irqrestore(&atchan->lock, flags);
+
 	return 0;
 }
 
-- 
2.25.1

