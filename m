Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F71A243B4C
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 16:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgHMOOA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 10:14:00 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:36522 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726564AbgHMON7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Aug 2020 10:13:59 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 217C1C0780;
        Thu, 13 Aug 2020 14:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1597328039; bh=yzjZZtMtuF3mfdo4BcXeAnAhpbUKkg7eDAotsYFaYds=;
        h=From:To:Cc:Subject:Date:From;
        b=Z2Pg7Xw1FxhAhZLM9tMD8dZk4ay7EV3+oZowfNa3X1TEMa38sVTO/txYmEGm2Vwa9
         cSHcBAWpzN7NB8NRHXOTFsCdm3jYhosnCB7z/2vGBnrylYeKzHIgaYsNsSSqgPi8Bn
         ns/ZSo7ZuOoSlaPnBWftYo7yVGHWb8E5SYOOKrKgySKz65jNWsewLpu0frIhbeSGbW
         0mNfxhTaFsTozWBySFGiTDF7/nlQl0XMW2BxFTOo1pr1KoOCvKbDXMdEaL9oBwbEqz
         VWT9uc18vc4LvWFmzZ0x4bHoW1uB67nLKCF2ICLrTXAWgIOyF4jHn1b8g0+HkhOqvA
         80RJwwoibeT2g==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 831D4A005A;
        Thu, 13 Aug 2020 14:13:57 +0000 (UTC)
X-SNPS-Relay: synopsys.com
From:   Gustavo Pimentel <Gustavo.Pimentel@synopsys.com>
To:     vkoul@kernel.org, dmaengine@vger.kernel.org
Cc:     Gustavo Pimentel <Gustavo.Pimentel@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>, stable@vger.kernel.org
Subject: [PATCH] dmaengine: dw-edma: Fix linked list physical address calculation on non-64 bits architectures
Date:   Thu, 13 Aug 2020 16:13:54 +0200
Message-Id: <9d92b3c0f9304e3f2892833a70c726b911b29fd8.1597327637.git.gustavo.pimentel@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix linked list physical address calculation on non-64 bits architectures.

The paddr variable is phys_addr_t type, which can assume a different
type (u64 or u32) depending on the conditional compilation flag
CONFIG_PHYS_ADDR_T_64BIT.

Since this variable is used in with upper_32 bits() macro to get the
value from 32 to 63 bits, on a non-64 bits architecture this variable
will assume a u32 type, it can cause a compilation warning.

This issue was reported by a Coverity analysis.

Fixes: 7e4b8a4fbe2c ("dmaengine: Add Synopsys eDMA IP version 0 support")

Cc: Joao Pinto <jpinto@synopsys.com>
Cc: stable@vger.kernel.org
Signed-off-by: Gustavo Pimentel <gustavo.pimentel@synopsys.com>
---
 drivers/dma/dw-edma/dw-edma-v0-core.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/dw-edma/dw-edma-v0-core.c b/drivers/dma/dw-edma/dw-edma-v0-core.c
index 692de47..cfabbf5 100644
--- a/drivers/dma/dw-edma/dw-edma-v0-core.c
+++ b/drivers/dma/dw-edma/dw-edma-v0-core.c
@@ -229,8 +229,13 @@ static void dw_edma_v0_core_write_chunk(struct dw_edma_chunk *chunk)
 	/* Channel control */
 	SET_LL(&llp->control, control);
 	/* Linked list  - low, high */
-	SET_LL(&llp->llp_low, lower_32_bits(chunk->ll_region.paddr));
-	SET_LL(&llp->llp_high, upper_32_bits(chunk->ll_region.paddr));
+	#ifdef CONFIG_PHYS_ADDR_T_64BIT
+		SET_LL(&llp->llp_low, lower_32_bits(chunk->ll_region.paddr));
+		SET_LL(&llp->llp_high, upper_32_bits(chunk->ll_region.paddr));
+	#else /* CONFIG_PHYS_ADDR_T_64BIT */
+		SET_LL(&llp->llp_low, chunk->ll_region.paddr);
+		SET_LL(&llp->llp_high, 0x0);
+	#endif /* CONFIG_PHYS_ADDR_T_64BIT */
 }
 
 void dw_edma_v0_core_start(struct dw_edma_chunk *chunk, bool first)
@@ -257,10 +262,16 @@ void dw_edma_v0_core_start(struct dw_edma_chunk *chunk, bool first)
 		SET_CH(dw, chan->dir, chan->id, ch_control1,
 		       (DW_EDMA_V0_CCS | DW_EDMA_V0_LLE));
 		/* Linked list - low, high */
-		SET_CH(dw, chan->dir, chan->id, llp_low,
-		       lower_32_bits(chunk->ll_region.paddr));
-		SET_CH(dw, chan->dir, chan->id, llp_high,
-		       upper_32_bits(chunk->ll_region.paddr));
+		#ifdef CONFIG_PHYS_ADDR_T_64BIT
+			SET_CH(dw, chan->dir, chan->id, llp_low,
+			       lower_32_bits(chunk->ll_region.paddr));
+			SET_CH(dw, chan->dir, chan->id, llp_high,
+			       upper_32_bits(chunk->ll_region.paddr));
+		#else /* CONFIG_PHYS_ADDR_T_64BIT */
+			SET_CH(dw, chan->dir, chan->id, llp_low,
+			       chunk->ll_region.paddr);
+			SET_CH(dw, chan->dir, chan->id, llp_high, 0x0);
+		#endif /* CONFIG_PHYS_ADDR_T_64BIT*/
 	}
 	/* Doorbell */
 	SET_RW(dw, chan->dir, doorbell,
-- 
2.7.4

