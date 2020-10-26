Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB3A5299FDC
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438201AbgJ0AZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:25:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410139AbgJZXxj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:53:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12BC520882;
        Mon, 26 Oct 2020 23:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756418;
        bh=PzBe7WcfR6hDdFwPdvfhfW1Oxz6UCQSr2VB93ViDne8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PBpePRO5lBlHCSYaVm+CnIwbw3hBMx71kTRWQJ2gPIP6JD4tX5i0uURTA6/7A7GEQ
         0Tvi7Q+4Qj6v28aHL4m4UvfndxSqNuWuxmOLjHPPlODvGDKHhDd1kZs0GfGRzNrb4a
         5Cel3V1JA6vj99stAIKu3RWAeuwFJ3VSh/t+PdwE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     farah kassabri <fkassabri@habana.ai>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 075/132] habanalabs: remove security from ARB_MST_QUIET register
Date:   Mon, 26 Oct 2020 19:51:07 -0400
Message-Id: <20201026235205.1023962-75-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: farah kassabri <fkassabri@habana.ai>

[ Upstream commit acd330c141b4c49f468f00719ebc944656061eac ]

Allow user application to write to this register in order
to be able to configure the quiet period of the QMAN between grants.

Signed-off-by: farah kassabri <fkassabri@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../misc/habanalabs/gaudi/gaudi_security.c    | 55 +++++++------------
 1 file changed, 19 insertions(+), 36 deletions(-)

diff --git a/drivers/misc/habanalabs/gaudi/gaudi_security.c b/drivers/misc/habanalabs/gaudi/gaudi_security.c
index 6a351e31fa6af..efec4b7057048 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi_security.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi_security.c
@@ -832,8 +832,7 @@ static void gaudi_init_mme_protection_bits(struct hl_device *hdev)
 			PROT_BITS_OFFS;
 	word_offset = ((mmMME0_QM_ARB_MST_CHOISE_PUSH_OFST_23 &
 			PROT_BITS_OFFS) >> 7) << 2;
-	mask = 1 << ((mmMME0_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmMME0_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmMME0_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmMME0_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmMME0_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmMME0_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -1312,8 +1311,7 @@ static void gaudi_init_mme_protection_bits(struct hl_device *hdev)
 			PROT_BITS_OFFS;
 	word_offset = ((mmMME2_QM_ARB_MST_CHOISE_PUSH_OFST_23 &
 			PROT_BITS_OFFS) >> 7) << 2;
-	mask = 1 << ((mmMME2_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmMME2_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmMME2_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmMME2_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmMME2_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmMME2_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -1791,8 +1789,7 @@ static void gaudi_init_dma_protection_bits(struct hl_device *hdev)
 	word_offset =
 		((mmDMA0_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS) >> 7)
 		<< 2;
-	mask = 1 << ((mmDMA0_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmDMA0_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmDMA0_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA0_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA0_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA0_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -2187,8 +2184,7 @@ static void gaudi_init_dma_protection_bits(struct hl_device *hdev)
 	word_offset =
 		((mmDMA1_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS) >> 7)
 		<< 2;
-	mask = 1 << ((mmDMA1_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmDMA1_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmDMA1_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA1_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA1_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA1_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -2583,8 +2579,7 @@ static void gaudi_init_dma_protection_bits(struct hl_device *hdev)
 	word_offset =
 		((mmDMA2_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS) >> 7)
 		<< 2;
-	mask = 1 << ((mmDMA2_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmDMA2_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmDMA2_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA2_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA2_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA2_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -2979,8 +2974,7 @@ static void gaudi_init_dma_protection_bits(struct hl_device *hdev)
 	word_offset =
 		((mmDMA3_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS) >> 7)
 		<< 2;
-	mask = 1 << ((mmDMA3_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmDMA3_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmDMA3_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA3_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA3_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA3_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -3375,8 +3369,7 @@ static void gaudi_init_dma_protection_bits(struct hl_device *hdev)
 	word_offset =
 		((mmDMA4_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS) >> 7)
 		<< 2;
-	mask = 1 << ((mmDMA4_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmDMA4_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmDMA4_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA4_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA4_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA4_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -3771,8 +3764,7 @@ static void gaudi_init_dma_protection_bits(struct hl_device *hdev)
 	word_offset =
 		((mmDMA5_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS) >> 7)
 		<< 2;
-	mask = 1 << ((mmDMA5_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmDMA5_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmDMA5_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA5_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA5_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA5_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -4167,8 +4159,8 @@ static void gaudi_init_dma_protection_bits(struct hl_device *hdev)
 	word_offset =
 		((mmDMA6_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS) >> 7)
 		<< 2;
-	mask = 1 << ((mmDMA6_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmDMA6_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+
+	mask = 1 << ((mmDMA6_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA6_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA6_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA6_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -4563,8 +4555,7 @@ static void gaudi_init_dma_protection_bits(struct hl_device *hdev)
 	word_offset =
 		((mmDMA7_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS) >> 7)
 		<< 2;
-	mask = 1 << ((mmDMA7_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmDMA7_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmDMA7_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA7_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA7_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA7_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -5492,8 +5483,7 @@ static void gaudi_init_tpc_protection_bits(struct hl_device *hdev)
 
 	word_offset = ((mmTPC0_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS)
 								>> 7) << 2;
-	mask = 1 << ((mmTPC0_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmTPC0_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmTPC0_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC0_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC0_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC0_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -5948,8 +5938,7 @@ static void gaudi_init_tpc_protection_bits(struct hl_device *hdev)
 
 	word_offset = ((mmTPC1_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS)
 								>> 7) << 2;
-	mask = 1 << ((mmTPC1_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmTPC1_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmTPC1_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC1_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC1_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC1_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -6403,8 +6392,7 @@ static void gaudi_init_tpc_protection_bits(struct hl_device *hdev)
 								PROT_BITS_OFFS;
 	word_offset = ((mmTPC2_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS)
 								>> 7) << 2;
-	mask = 1 << ((mmTPC2_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmTPC2_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmTPC2_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC2_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC2_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC2_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -6858,8 +6846,7 @@ static void gaudi_init_tpc_protection_bits(struct hl_device *hdev)
 								PROT_BITS_OFFS;
 	word_offset = ((mmTPC3_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS)
 								>> 7) << 2;
-	mask = 1 << ((mmTPC3_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmTPC3_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmTPC3_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC3_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC3_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC3_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -7313,8 +7300,7 @@ static void gaudi_init_tpc_protection_bits(struct hl_device *hdev)
 								PROT_BITS_OFFS;
 	word_offset = ((mmTPC4_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS)
 								>> 7) << 2;
-	mask = 1 << ((mmTPC4_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmTPC4_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmTPC4_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC4_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC4_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC4_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -7768,8 +7754,7 @@ static void gaudi_init_tpc_protection_bits(struct hl_device *hdev)
 								PROT_BITS_OFFS;
 	word_offset = ((mmTPC5_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS)
 								>> 7) << 2;
-	mask = 1 << ((mmTPC5_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmTPC5_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmTPC5_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC5_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC5_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC5_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -8224,8 +8209,7 @@ static void gaudi_init_tpc_protection_bits(struct hl_device *hdev)
 
 	word_offset = ((mmTPC6_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS)
 								>> 7) << 2;
-	mask = 1 << ((mmTPC6_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmTPC6_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmTPC6_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC6_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC6_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC6_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -8682,8 +8666,7 @@ static void gaudi_init_tpc_protection_bits(struct hl_device *hdev)
 			PROT_BITS_OFFS;
 	word_offset = ((mmTPC7_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS)
 								>> 7) << 2;
-	mask = 1 << ((mmTPC7_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmTPC7_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmTPC7_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC7_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC7_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC7_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
-- 
2.25.1

