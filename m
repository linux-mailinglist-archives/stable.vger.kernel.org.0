Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D580A60C73F
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 11:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbiJYJEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 05:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbiJYJDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 05:03:51 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779C915A8F6;
        Tue, 25 Oct 2022 02:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666688613; x=1698224613;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d1t0ow6YIdu9Rv1rkKmxVrPNsexG/0cDcLPtXg9M8P0=;
  b=fbI44eC+HEcCvmNe+U6FGf+28WIeYrckJcNXrP7eMaC+7/tdGbnC4Cs/
   4wlo9zcE8+8czfWX1ErMJ81Uzo0EbXCAo2Ng9alGy0tXCcfJdsAea+sFM
   m/Hf47iVdXrgKjREYInOOTd3wvYqQfesjxaPhZnzyAah6G4Rtp+0ozQ/x
   GDyGoab82KIl4ORr1HS1XgmkKVnsq43KYpz3uTzQ5c5oGEF2bmg4epOFh
   WPYaREwZOLEThOK5SVvb7iGf6a1yNKTigT3KkT2aAAAiUwIA0r7Dqse2j
   venIANILdUZILoe+NfqJv7b/8FBPj6+zW4RyNPPdB6OkpQ6By1tZ2XyfH
   g==;
X-IronPort-AV: E=Sophos;i="5.95,211,1661842800"; 
   d="scan'208";a="120221243"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Oct 2022 02:03:32 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 25 Oct 2022 02:03:30 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 25 Oct 2022 02:03:28 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <vkoul@kernel.org>, <peda@axentia.se>, <du@axentia.se>
CC:     <maciej.sosnowski@intel.com>, <nicolas.ferre@microchip.com>,
        <mripard@kernel.org>, <torfl6749@gmail.com>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Tudor Ambarus" <tudor.ambarus@microchip.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 06/32] dmaengine: at_hdmac: Protect atchan->status with the channel lock
Date:   Tue, 25 Oct 2022 12:02:40 +0300
Message-ID: <20221025090306.297886-7-tudor.ambarus@microchip.com>
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
index 11816484843e..deb4c6027436 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1460,12 +1460,12 @@ static int atc_terminate_all(struct dma_chan *chan)
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

