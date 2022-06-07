Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6DAA540734
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347563AbiFGRoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347903AbiFGRnJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:43:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7FB12E31B;
        Tue,  7 Jun 2022 10:35:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CDC9B822B3;
        Tue,  7 Jun 2022 17:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5AE5C36B00;
        Tue,  7 Jun 2022 17:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623283;
        bh=TfGOvyIwaEoLDHC69Z6PPXCHD8kR3jJhdj6r89QSPQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R/16cZ3v9oE6plmsFVD0EFyzGOBm28lbWfhiKETB0coVcydTLBB57FrC1cNgg+15J
         uVq5DCRiajC3YumDc+FD2Il95uEXj8sTRJj/RNUy3ouRJxg3uQry4PHGb/BQ891e4G
         kqNmeUJ9l2c5K22yhYBPbY/KO6gXZ6+bgBf4dVdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 334/452] dmaengine: stm32-mdma: remove GISR1 register
Date:   Tue,  7 Jun 2022 19:03:11 +0200
Message-Id: <20220607164918.512235259@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

[ Upstream commit 9d6a2d92e450926c483e45eaf426080a19219f4e ]

GISR1 was described in a not up-to-date documentation when the stm32-mdma
driver has been developed. This register has not been added in reference
manual of STM32 SoC with MDMA, which have only 32 MDMA channels.
So remove it from stm32-mdma driver.

Fixes: a4ffb13c8946 ("dmaengine: Add STM32 MDMA driver")
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://lore.kernel.org/r/20220504155322.121431-2-amelie.delaunay@foss.st.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/stm32-mdma.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/dma/stm32-mdma.c b/drivers/dma/stm32-mdma.c
index fe36738f2dd7..cd394624085a 100644
--- a/drivers/dma/stm32-mdma.c
+++ b/drivers/dma/stm32-mdma.c
@@ -40,7 +40,6 @@
 					 STM32_MDMA_SHIFT(mask))
 
 #define STM32_MDMA_GISR0		0x0000 /* MDMA Int Status Reg 1 */
-#define STM32_MDMA_GISR1		0x0004 /* MDMA Int Status Reg 2 */
 
 /* MDMA Channel x interrupt/status register */
 #define STM32_MDMA_CISR(x)		(0x40 + 0x40 * (x)) /* x = 0..62 */
@@ -196,7 +195,7 @@
 
 #define STM32_MDMA_MAX_BUF_LEN		128
 #define STM32_MDMA_MAX_BLOCK_LEN	65536
-#define STM32_MDMA_MAX_CHANNELS		63
+#define STM32_MDMA_MAX_CHANNELS		32
 #define STM32_MDMA_MAX_REQUESTS		256
 #define STM32_MDMA_MAX_BURST		128
 #define STM32_MDMA_VERY_HIGH_PRIORITY	0x11
@@ -1350,21 +1349,11 @@ static irqreturn_t stm32_mdma_irq_handler(int irq, void *devid)
 
 	/* Find out which channel generates the interrupt */
 	status = readl_relaxed(dmadev->base + STM32_MDMA_GISR0);
-	if (status) {
-		id = __ffs(status);
-	} else {
-		status = readl_relaxed(dmadev->base + STM32_MDMA_GISR1);
-		if (!status) {
-			dev_dbg(mdma2dev(dmadev), "spurious it\n");
-			return IRQ_NONE;
-		}
-		id = __ffs(status);
-		/*
-		 * As GISR0 provides status for channel id from 0 to 31,
-		 * so GISR1 provides status for channel id from 32 to 62
-		 */
-		id += 32;
+	if (!status) {
+		dev_dbg(mdma2dev(dmadev), "spurious it\n");
+		return IRQ_NONE;
 	}
+	id = __ffs(status);
 
 	chan = &dmadev->chan[id];
 	if (!chan) {
-- 
2.35.1



