Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE185257DB7
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728867AbgHaPjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:39:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728521AbgHaPaB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:30:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E72720767;
        Mon, 31 Aug 2020 15:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887800;
        bh=2S3ivuzEZGfnY77yUs2AAU8aYTRtxOGZowmybDPmTt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0HD1eT5TwPXxdSLB3Q9rr6nmdnYp6+H7xzTlH0ESfIiICYAdMmfOPBl7DdEkiJXZD
         3grQ0DsqPtxGi1KLjEgE4IMOu1Zy8v8DrjXWC11zJ++8wUEuUOcSjBwApnd59Yiywi
         7BNz75E9XNDzUKSawkrl0RXvsTubYdc0lK9RBmJE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ofir Bitton <obitton@habana.ai>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 16/42] habanalabs: set clock gating according to mask
Date:   Mon, 31 Aug 2020 11:29:08 -0400
Message-Id: <20200831152934.1023912-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831152934.1023912-1-sashal@kernel.org>
References: <20200831152934.1023912-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ofir Bitton <obitton@habana.ai>

[ Upstream commit f44d23b9095abd91dad9f5f3add2a3149833ec83 ]

Once clock gating is set we enable clock gating according to mask,
we should also disable clock gating according to relevant bits.

Signed-off-by: Ofir Bitton <obitton@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/gaudi/gaudi.c | 44 +++++++++++++--------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index 0261f60df5633..8b6cf722ddf8e 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -2564,6 +2564,7 @@ static void gaudi_set_clock_gating(struct hl_device *hdev)
 {
 	struct gaudi_device *gaudi = hdev->asic_specific;
 	u32 qman_offset;
+	bool enable;
 	int i;
 
 	/* In case we are during debug session, don't enable the clock gate
@@ -2573,46 +2574,43 @@ static void gaudi_set_clock_gating(struct hl_device *hdev)
 		return;
 
 	for (i = GAUDI_PCI_DMA_1, qman_offset = 0 ; i < GAUDI_HBM_DMA_1 ; i++) {
-		if (!(hdev->clock_gating_mask &
-					(BIT_ULL(gaudi_dma_assignment[i]))))
-			continue;
+		enable = !!(hdev->clock_gating_mask &
+				(BIT_ULL(gaudi_dma_assignment[i])));
 
 		qman_offset = gaudi_dma_assignment[i] * DMA_QMAN_OFFSET;
-		WREG32(mmDMA0_QM_CGM_CFG1 + qman_offset, QMAN_CGM1_PWR_GATE_EN);
+		WREG32(mmDMA0_QM_CGM_CFG1 + qman_offset,
+				enable ? QMAN_CGM1_PWR_GATE_EN : 0);
 		WREG32(mmDMA0_QM_CGM_CFG + qman_offset,
-				QMAN_UPPER_CP_CGM_PWR_GATE_EN);
+				enable ? QMAN_UPPER_CP_CGM_PWR_GATE_EN : 0);
 	}
 
 	for (i = GAUDI_HBM_DMA_1 ; i < GAUDI_DMA_MAX ; i++) {
-		if (!(hdev->clock_gating_mask &
-					(BIT_ULL(gaudi_dma_assignment[i]))))
-			continue;
+		enable = !!(hdev->clock_gating_mask &
+				(BIT_ULL(gaudi_dma_assignment[i])));
 
 		qman_offset = gaudi_dma_assignment[i] * DMA_QMAN_OFFSET;
-		WREG32(mmDMA0_QM_CGM_CFG1 + qman_offset, QMAN_CGM1_PWR_GATE_EN);
+		WREG32(mmDMA0_QM_CGM_CFG1 + qman_offset,
+				enable ? QMAN_CGM1_PWR_GATE_EN : 0);
 		WREG32(mmDMA0_QM_CGM_CFG + qman_offset,
-				QMAN_COMMON_CP_CGM_PWR_GATE_EN);
+				enable ? QMAN_COMMON_CP_CGM_PWR_GATE_EN : 0);
 	}
 
-	if (hdev->clock_gating_mask & (BIT_ULL(GAUDI_ENGINE_ID_MME_0))) {
-		WREG32(mmMME0_QM_CGM_CFG1, QMAN_CGM1_PWR_GATE_EN);
-		WREG32(mmMME0_QM_CGM_CFG, QMAN_COMMON_CP_CGM_PWR_GATE_EN);
-	}
+	enable = !!(hdev->clock_gating_mask & (BIT_ULL(GAUDI_ENGINE_ID_MME_0)));
+	WREG32(mmMME0_QM_CGM_CFG1, enable ? QMAN_CGM1_PWR_GATE_EN : 0);
+	WREG32(mmMME0_QM_CGM_CFG, enable ? QMAN_COMMON_CP_CGM_PWR_GATE_EN : 0);
 
-	if (hdev->clock_gating_mask & (BIT_ULL(GAUDI_ENGINE_ID_MME_2))) {
-		WREG32(mmMME2_QM_CGM_CFG1, QMAN_CGM1_PWR_GATE_EN);
-		WREG32(mmMME2_QM_CGM_CFG, QMAN_COMMON_CP_CGM_PWR_GATE_EN);
-	}
+	enable = !!(hdev->clock_gating_mask & (BIT_ULL(GAUDI_ENGINE_ID_MME_2)));
+	WREG32(mmMME2_QM_CGM_CFG1, enable ? QMAN_CGM1_PWR_GATE_EN : 0);
+	WREG32(mmMME2_QM_CGM_CFG, enable ? QMAN_COMMON_CP_CGM_PWR_GATE_EN : 0);
 
 	for (i = 0, qman_offset = 0 ; i < TPC_NUMBER_OF_ENGINES ; i++) {
-		if (!(hdev->clock_gating_mask &
-					(BIT_ULL(GAUDI_ENGINE_ID_TPC_0 + i))))
-			continue;
+		enable = !!(hdev->clock_gating_mask &
+				(BIT_ULL(GAUDI_ENGINE_ID_TPC_0 + i)));
 
 		WREG32(mmTPC0_QM_CGM_CFG1 + qman_offset,
-				QMAN_CGM1_PWR_GATE_EN);
+				enable ? QMAN_CGM1_PWR_GATE_EN : 0);
 		WREG32(mmTPC0_QM_CGM_CFG + qman_offset,
-				QMAN_COMMON_CP_CGM_PWR_GATE_EN);
+				enable ? QMAN_COMMON_CP_CGM_PWR_GATE_EN : 0);
 
 		qman_offset += TPC_QMAN_OFFSET;
 	}
-- 
2.25.1

