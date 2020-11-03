Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A482A5932
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729870AbgKCWFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 17:05:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:54738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730474AbgKCUm2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:42:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29B8A223AC;
        Tue,  3 Nov 2020 20:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436147;
        bh=T+r+X2nmQjLJPghDqoWFD7MwfQ8XrtzxFcRXHkVV63Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j+prSvzSe3tZxkB3bwY9y+UN4cZFiLor0cKozvsjbdwbBTe5CRf8V12jgNQw4Y9Yl
         /Em43166PhYdHI5Cjloqg8uNs1/vzJoEN2nU9qIh5XNiNQrm+rdOJHFbvny5aKKa0z
         yvQKSbkUZCePrZmvU7d6KFYnmaMpVU6olF0IIJxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, farah kassabri <fkassabri@habana.ai>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 123/391] habanalabs: remove security from ARB_MST_QUIET register
Date:   Tue,  3 Nov 2020 21:32:54 +0100
Message-Id: <20201103203355.124778809@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.27.0



