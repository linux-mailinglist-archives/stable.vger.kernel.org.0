Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5585486C5
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358538AbiFMMG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358269AbiFMMCJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:02:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F594F465;
        Mon, 13 Jun 2022 03:57:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C912B80E93;
        Mon, 13 Jun 2022 10:57:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF284C3411F;
        Mon, 13 Jun 2022 10:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117827;
        bh=tyA0ejAS9z+0uiLzoyWjMGJJNFCiypMG0doZNc98FoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yMm9pUeSCAiwuasDg7yxq/QVixT+LvUN0QdNp8ePkjlguz9IazhRwSz5qLD1F1Vmq
         EPF29yGd+bsnqrjZDWQAaPPOLZlUrISH1cMekfGAcpGJU69aPDikHbzFMgkcBAQq1B
         w4oLdaWya8WUDfgxiFjO/mx2t0U9+xE+T7mSN9ls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 138/287] dmaengine: stm32-mdma: remove GISR1 register
Date:   Mon, 13 Jun 2022 12:09:22 +0200
Message-Id: <20220613094928.062694848@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
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
index 8585fed84e83..3259c450544c 100644
--- a/drivers/dma/stm32-mdma.c
+++ b/drivers/dma/stm32-mdma.c
@@ -50,7 +50,6 @@
 					 STM32_MDMA_SHIFT(mask))
 
 #define STM32_MDMA_GISR0		0x0000 /* MDMA Int Status Reg 1 */
-#define STM32_MDMA_GISR1		0x0004 /* MDMA Int Status Reg 2 */
 
 /* MDMA Channel x interrupt/status register */
 #define STM32_MDMA_CISR(x)		(0x40 + 0x40 * (x)) /* x = 0..62 */
@@ -206,7 +205,7 @@
 
 #define STM32_MDMA_MAX_BUF_LEN		128
 #define STM32_MDMA_MAX_BLOCK_LEN	65536
-#define STM32_MDMA_MAX_CHANNELS		63
+#define STM32_MDMA_MAX_CHANNELS		32
 #define STM32_MDMA_MAX_REQUESTS		256
 #define STM32_MDMA_MAX_BURST		128
 #define STM32_MDMA_VERY_HIGH_PRIORITY	0x11
@@ -1361,21 +1360,11 @@ static irqreturn_t stm32_mdma_irq_handler(int irq, void *devid)
 
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



