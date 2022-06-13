Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 147135492DC
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352588AbiFMLUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352886AbiFMLTB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:19:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A0F289A5;
        Mon, 13 Jun 2022 03:40:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22347611E6;
        Mon, 13 Jun 2022 10:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDE2C34114;
        Mon, 13 Jun 2022 10:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116843;
        bh=jfe85s2VWaB63elD4lJMi0XDEoLbF+zQNm8u1KsBBFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iiuz7m3Z6MR8dhxm6EUa80+j6OwKwNjzphMuL3K5yY6KjgLE21MFxcJDLSezT21xc
         cicGUjKAGf3SlCZ8QWLzTOH6qV7m4VIpfeqgptNXJVpLtanGoZPXgxPPp0X2VZvsP7
         wQJkvg1vCVVzs4oS3As/7uBFnfcFGOhRyIM+8BKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 205/411] dmaengine: stm32-mdma: remove GISR1 register
Date:   Mon, 13 Jun 2022 12:07:58 +0200
Message-Id: <20220613094934.805145200@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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
index a05355d1292e..c902c2480640 100644
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
@@ -1351,21 +1350,11 @@ static irqreturn_t stm32_mdma_irq_handler(int irq, void *devid)
 
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



