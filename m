Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08D229A1C1
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502390AbgJ0Anw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:43:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409200AbgJZXut (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:50:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7204120882;
        Mon, 26 Oct 2020 23:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756248;
        bh=ETYwD2cv8JKRlgt/657ov7VPvv70+FH1BH4LDE1TE1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=im8RDwmIBRbl7zA2YOJY7iMzFcYM1cD3BKEQO/BI+RwOFDBEzrest1ILtbSgRSWT5
         cH99nWcAwhn/mBbqYsNrH+mkT60pWxpgm4iBN9IS/4n5uS0MMaOWH+tUDPdQOng9+S
         OZFFHjX8HPz63ADvViM46QiQcwMDSerN3/kWIY38=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     farah kassabri <fkassabri@habana.ai>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.9 083/147] habanalabs: remove security from ARB_MST_QUIET register
Date:   Mon, 26 Oct 2020 19:48:01 -0400
Message-Id: <20201026234905.1022767-83-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
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
index 8d5d6ddee6eda..615b547ad2b7d 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi_security.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi_security.c
@@ -831,8 +831,7 @@ static void gaudi_init_mme_protection_bits(struct hl_device *hdev)
 			PROT_BITS_OFFS;
 	word_offset = ((mmMME0_QM_ARB_MST_CHOISE_PUSH_OFST_23 &
 			PROT_BITS_OFFS) >> 7) << 2;
-	mask = 1 << ((mmMME0_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmMME0_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmMME0_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmMME0_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmMME0_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmMME0_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -1311,8 +1310,7 @@ static void gaudi_init_mme_protection_bits(struct hl_device *hdev)
 			PROT_BITS_OFFS;
 	word_offset = ((mmMME2_QM_ARB_MST_CHOISE_PUSH_OFST_23 &
 			PROT_BITS_OFFS) >> 7) << 2;
-	mask = 1 << ((mmMME2_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmMME2_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmMME2_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmMME2_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmMME2_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmMME2_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -1790,8 +1788,7 @@ static void gaudi_init_dma_protection_bits(struct hl_device *hdev)
 	word_offset =
 		((mmDMA0_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS) >> 7)
 		<< 2;
-	mask = 1 << ((mmDMA0_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmDMA0_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmDMA0_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA0_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA0_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA0_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -2186,8 +2183,7 @@ static void gaudi_init_dma_protection_bits(struct hl_device *hdev)
 	word_offset =
 		((mmDMA1_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS) >> 7)
 		<< 2;
-	mask = 1 << ((mmDMA1_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmDMA1_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmDMA1_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA1_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA1_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA1_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -2582,8 +2578,7 @@ static void gaudi_init_dma_protection_bits(struct hl_device *hdev)
 	word_offset =
 		((mmDMA2_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS) >> 7)
 		<< 2;
-	mask = 1 << ((mmDMA2_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmDMA2_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmDMA2_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA2_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA2_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA2_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -2978,8 +2973,7 @@ static void gaudi_init_dma_protection_bits(struct hl_device *hdev)
 	word_offset =
 		((mmDMA3_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS) >> 7)
 		<< 2;
-	mask = 1 << ((mmDMA3_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmDMA3_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmDMA3_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA3_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA3_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA3_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -3374,8 +3368,7 @@ static void gaudi_init_dma_protection_bits(struct hl_device *hdev)
 	word_offset =
 		((mmDMA4_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS) >> 7)
 		<< 2;
-	mask = 1 << ((mmDMA4_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmDMA4_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmDMA4_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA4_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA4_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA4_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -3770,8 +3763,7 @@ static void gaudi_init_dma_protection_bits(struct hl_device *hdev)
 	word_offset =
 		((mmDMA5_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS) >> 7)
 		<< 2;
-	mask = 1 << ((mmDMA5_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmDMA5_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmDMA5_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA5_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA5_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA5_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -4166,8 +4158,8 @@ static void gaudi_init_dma_protection_bits(struct hl_device *hdev)
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
@@ -4562,8 +4554,7 @@ static void gaudi_init_dma_protection_bits(struct hl_device *hdev)
 	word_offset =
 		((mmDMA7_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS) >> 7)
 		<< 2;
-	mask = 1 << ((mmDMA7_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmDMA7_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmDMA7_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA7_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA7_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmDMA7_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -5491,8 +5482,7 @@ static void gaudi_init_tpc_protection_bits(struct hl_device *hdev)
 
 	word_offset = ((mmTPC0_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS)
 								>> 7) << 2;
-	mask = 1 << ((mmTPC0_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmTPC0_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmTPC0_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC0_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC0_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC0_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -5947,8 +5937,7 @@ static void gaudi_init_tpc_protection_bits(struct hl_device *hdev)
 
 	word_offset = ((mmTPC1_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS)
 								>> 7) << 2;
-	mask = 1 << ((mmTPC1_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmTPC1_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmTPC1_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC1_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC1_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC1_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -6402,8 +6391,7 @@ static void gaudi_init_tpc_protection_bits(struct hl_device *hdev)
 								PROT_BITS_OFFS;
 	word_offset = ((mmTPC2_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS)
 								>> 7) << 2;
-	mask = 1 << ((mmTPC2_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmTPC2_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmTPC2_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC2_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC2_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC2_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -6857,8 +6845,7 @@ static void gaudi_init_tpc_protection_bits(struct hl_device *hdev)
 								PROT_BITS_OFFS;
 	word_offset = ((mmTPC3_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS)
 								>> 7) << 2;
-	mask = 1 << ((mmTPC3_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmTPC3_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmTPC3_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC3_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC3_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC3_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -7312,8 +7299,7 @@ static void gaudi_init_tpc_protection_bits(struct hl_device *hdev)
 								PROT_BITS_OFFS;
 	word_offset = ((mmTPC4_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS)
 								>> 7) << 2;
-	mask = 1 << ((mmTPC4_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmTPC4_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmTPC4_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC4_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC4_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC4_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -7767,8 +7753,7 @@ static void gaudi_init_tpc_protection_bits(struct hl_device *hdev)
 								PROT_BITS_OFFS;
 	word_offset = ((mmTPC5_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS)
 								>> 7) << 2;
-	mask = 1 << ((mmTPC5_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmTPC5_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmTPC5_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC5_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC5_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC5_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -8223,8 +8208,7 @@ static void gaudi_init_tpc_protection_bits(struct hl_device *hdev)
 
 	word_offset = ((mmTPC6_QM_ARB_MST_CHOISE_PUSH_OFST_23 & PROT_BITS_OFFS)
 								>> 7) << 2;
-	mask = 1 << ((mmTPC6_QM_ARB_MST_QUIET_PER & 0x7F) >> 2);
-	mask |= 1 << ((mmTPC6_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask = 1 << ((mmTPC6_QM_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC6_QM_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC6_QM_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC6_QM_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
@@ -8681,8 +8665,7 @@ static void gaudi_init_tpc_protection_bits(struct hl_device *hdev)
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

