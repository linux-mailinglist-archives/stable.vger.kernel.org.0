Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E46C59AE1B
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 15:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347166AbiHTM7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 08:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346868AbiHTM7F (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 08:59:05 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C71C4A803;
        Sat, 20 Aug 2022 05:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661000313; x=1692536313;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CsIGeoVKwQn0byz2dnPhGjooS8B42B8WTMB5lbZlMOw=;
  b=szd1yQ3XL5KfHaeKGnHqBUcCeve728FYt150QNKFmGl1or0EVh4v4KDm
   4PfDSukDuqKtg+UHKfVpRYzqIenMK05t5EFp7yr9vmgNWrLK9ER1XNFZ4
   NqX46wzWVJD9Rr5o5FRYPpl47S/RR3/GvnVgi0X4cUDNrFkSvykjvU+Fg
   npIm49Y6YpNft1zPF2n/YQ/AYXl4VV6i5Z+8+WkQ6jf0ZiFOADBmYqn14
   yCy07KdGHm3SECbxO2YTRuHy5kz0t/3QiJ7XcrFX4UkbKaGrQjXFDUzPN
   ewbWCi81flAESb3O5k7Z2HR1RGdOUpLhdTKV5nH4PcGdPJLN82wartA+X
   g==;
X-IronPort-AV: E=Sophos;i="5.93,251,1654585200"; 
   d="scan'208";a="177042815"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Aug 2022 05:58:27 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sat, 20 Aug 2022 05:58:25 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sat, 20 Aug 2022 05:58:22 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <vkoul@kernel.org>, <peda@axentia.se>, <du@axentia.se>,
        <regressions@leemhuis.info>
CC:     <ludovic.desroches@microchip.com>, <maciej.sosnowski@intel.com>,
        <tudor.ambarus@microchip.com>, <dan.j.williams@intel.com>,
        <nicolas.ferre@microchip.com>, <mripard@kernel.org>,
        <torfl6749@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <stable@vger.kernel.org>
Subject: [PATCH 18/33] dmaengine: at_hdmac: Fix completion of unissued descriptor in case of errors
Date:   Sat, 20 Aug 2022 15:57:02 +0300
Message-ID: <20220820125717.588722-19-tudor.ambarus@microchip.com>
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

In case the controller detected an error, the code took the chance to move
all the queued (submitted) descriptors to the active (issued) list. This
was wrong as if there were any descriptors in the submitted list they were
moved to the issued list without actually issuing them to the controller,
thus a completion could be raised without even fireing the descriptor.

Fixes: dc78baa2b90b ("dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller")
Reported-by: Peter Rosin <peda@axentia.se>
Cc: stable@vger.kernel.org
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
---
 drivers/dma/at_hdmac.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index e5ac73768d13..825a29ede35e 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -974,10 +974,6 @@ static void atc_handle_error(struct at_dma_chan *atchan)
 	bad_desc = atc_first_active(atchan);
 	list_del_init(&bad_desc->desc_node);
 
-	/* As we are stopped, take advantage to push queued descriptors
-	 * in active_list */
-	list_splice_init(&atchan->queue, atchan->active_list.prev);
-
 	/* Try to restart the controller */
 	if (!list_empty(&atchan->active_list)) {
 		desc = atc_first_queued(atchan);
-- 
2.25.1

