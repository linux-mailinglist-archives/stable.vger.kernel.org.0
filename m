Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043DD22662E
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732471AbgGTQBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:01:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729341AbgGTQBE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:01:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6936322CF7;
        Mon, 20 Jul 2020 16:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260862;
        bh=uBsx4xn2wB3TkogGj6gfY1bvCpljOdc8F6CiyzGvaNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i87h/h00ZmbVBRAJM0/vb0cj+U9McuUCKqqv14oyvbY9fVyq6BfHiqcBnOgw5Kyxh
         wnTntfqXhSxnIbsz6jc/P274aYIJ2BxZcUyHPD351ZtA/T8oJ+Z9wSyk2HMHqczBJB
         4e/01ajlkCS58zNqr2tpdurKHEGWeN3AMDnmJR64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomer Tayar <ttayar@habana.ai>,
        Oded Gabbay <oded.gabbay@gmail.com>
Subject: [PATCH 5.4 123/215] habanalabs: Align protection bits configuration of all TPCs
Date:   Mon, 20 Jul 2020 17:36:45 +0200
Message-Id: <20200720152826.051911955@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomer Tayar <ttayar@habana.ai>

commit 79c823c57e69d9e584a5ee4ee6406eb3854393ae upstream.

Align the protection bits configuration of all TPC cores to be as of TPC
core 0.

Fixes: a513f9a7eca5 ("habanalabs: make tpc registers secured")

Signed-off-by: Tomer Tayar <ttayar@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/habanalabs/goya/goya_security.c |   99 ++++++++++++++++++++++++++-
 1 file changed, 98 insertions(+), 1 deletion(-)

--- a/drivers/misc/habanalabs/goya/goya_security.c
+++ b/drivers/misc/habanalabs/goya/goya_security.c
@@ -695,7 +695,6 @@ static void goya_init_tpc_protection_bit
 	mask |= 1 << ((mmTPC0_CFG_CFG_SUBTRACT_VALUE & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC0_CFG_SM_BASE_ADDRESS_LOW & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC0_CFG_SM_BASE_ADDRESS_HIGH & 0x7F) >> 2);
-	mask |= 1 << ((mmTPC0_CFG_CFG_SUBTRACT_VALUE & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC0_CFG_TPC_STALL & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC0_CFG_MSS_CONFIG & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC0_CFG_TPC_INTR_CAUSE & 0x7F) >> 2);
@@ -875,6 +874,16 @@ static void goya_init_tpc_protection_bit
 	goya_pb_set_block(hdev, mmTPC1_RD_REGULATOR_BASE);
 	goya_pb_set_block(hdev, mmTPC1_WR_REGULATOR_BASE);
 
+	pb_addr = (mmTPC1_CFG_SEMAPHORE & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmTPC1_CFG_SEMAPHORE & PROT_BITS_OFFS) >> 7) << 2;
+
+	mask = 1 << ((mmTPC1_CFG_SEMAPHORE & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC1_CFG_VFLAGS & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC1_CFG_SFLAGS & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC1_CFG_STATUS & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
 	pb_addr = (mmTPC1_CFG_CFG_BASE_ADDRESS_HIGH & ~0xFFF) + PROT_BITS_OFFS;
 	word_offset = ((mmTPC1_CFG_CFG_BASE_ADDRESS_HIGH &
 			PROT_BITS_OFFS) >> 7) << 2;
@@ -882,6 +891,10 @@ static void goya_init_tpc_protection_bit
 	mask |= 1 << ((mmTPC1_CFG_CFG_SUBTRACT_VALUE & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC1_CFG_SM_BASE_ADDRESS_LOW & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC1_CFG_SM_BASE_ADDRESS_HIGH & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC1_CFG_TPC_STALL & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC1_CFG_MSS_CONFIG & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC1_CFG_TPC_INTR_CAUSE & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC1_CFG_TPC_INTR_MASK & 0x7F) >> 2);
 
 	WREG32(pb_addr + word_offset, ~mask);
 
@@ -1057,6 +1070,16 @@ static void goya_init_tpc_protection_bit
 	goya_pb_set_block(hdev, mmTPC2_RD_REGULATOR_BASE);
 	goya_pb_set_block(hdev, mmTPC2_WR_REGULATOR_BASE);
 
+	pb_addr = (mmTPC2_CFG_SEMAPHORE & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmTPC2_CFG_SEMAPHORE & PROT_BITS_OFFS) >> 7) << 2;
+
+	mask = 1 << ((mmTPC2_CFG_SEMAPHORE & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC2_CFG_VFLAGS & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC2_CFG_SFLAGS & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC2_CFG_STATUS & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
 	pb_addr = (mmTPC2_CFG_CFG_BASE_ADDRESS_HIGH & ~0xFFF) + PROT_BITS_OFFS;
 	word_offset = ((mmTPC2_CFG_CFG_BASE_ADDRESS_HIGH &
 			PROT_BITS_OFFS) >> 7) << 2;
@@ -1064,6 +1087,10 @@ static void goya_init_tpc_protection_bit
 	mask |= 1 << ((mmTPC2_CFG_CFG_SUBTRACT_VALUE & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC2_CFG_SM_BASE_ADDRESS_LOW & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC2_CFG_SM_BASE_ADDRESS_HIGH & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC2_CFG_TPC_STALL & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC2_CFG_MSS_CONFIG & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC2_CFG_TPC_INTR_CAUSE & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC2_CFG_TPC_INTR_MASK & 0x7F) >> 2);
 
 	WREG32(pb_addr + word_offset, ~mask);
 
@@ -1239,6 +1266,16 @@ static void goya_init_tpc_protection_bit
 	goya_pb_set_block(hdev, mmTPC3_RD_REGULATOR_BASE);
 	goya_pb_set_block(hdev, mmTPC3_WR_REGULATOR_BASE);
 
+	pb_addr = (mmTPC3_CFG_SEMAPHORE & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmTPC3_CFG_SEMAPHORE & PROT_BITS_OFFS) >> 7) << 2;
+
+	mask = 1 << ((mmTPC3_CFG_SEMAPHORE & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC3_CFG_VFLAGS & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC3_CFG_SFLAGS & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC3_CFG_STATUS & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
 	pb_addr = (mmTPC3_CFG_CFG_BASE_ADDRESS_HIGH & ~0xFFF) + PROT_BITS_OFFS;
 	word_offset = ((mmTPC3_CFG_CFG_BASE_ADDRESS_HIGH
 			& PROT_BITS_OFFS) >> 7) << 2;
@@ -1246,6 +1283,10 @@ static void goya_init_tpc_protection_bit
 	mask |= 1 << ((mmTPC3_CFG_CFG_SUBTRACT_VALUE & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC3_CFG_SM_BASE_ADDRESS_LOW & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC3_CFG_SM_BASE_ADDRESS_HIGH & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC3_CFG_TPC_STALL & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC3_CFG_MSS_CONFIG & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC3_CFG_TPC_INTR_CAUSE & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC3_CFG_TPC_INTR_MASK & 0x7F) >> 2);
 
 	WREG32(pb_addr + word_offset, ~mask);
 
@@ -1421,6 +1462,16 @@ static void goya_init_tpc_protection_bit
 	goya_pb_set_block(hdev, mmTPC4_RD_REGULATOR_BASE);
 	goya_pb_set_block(hdev, mmTPC4_WR_REGULATOR_BASE);
 
+	pb_addr = (mmTPC4_CFG_SEMAPHORE & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmTPC4_CFG_SEMAPHORE & PROT_BITS_OFFS) >> 7) << 2;
+
+	mask = 1 << ((mmTPC4_CFG_SEMAPHORE & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC4_CFG_VFLAGS & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC4_CFG_SFLAGS & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC4_CFG_STATUS & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
 	pb_addr = (mmTPC4_CFG_CFG_BASE_ADDRESS_HIGH & ~0xFFF) + PROT_BITS_OFFS;
 	word_offset = ((mmTPC4_CFG_CFG_BASE_ADDRESS_HIGH &
 			PROT_BITS_OFFS) >> 7) << 2;
@@ -1428,6 +1479,10 @@ static void goya_init_tpc_protection_bit
 	mask |= 1 << ((mmTPC4_CFG_CFG_SUBTRACT_VALUE & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC4_CFG_SM_BASE_ADDRESS_LOW & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC4_CFG_SM_BASE_ADDRESS_HIGH & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC4_CFG_TPC_STALL & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC4_CFG_MSS_CONFIG & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC4_CFG_TPC_INTR_CAUSE & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC4_CFG_TPC_INTR_MASK & 0x7F) >> 2);
 
 	WREG32(pb_addr + word_offset, ~mask);
 
@@ -1603,6 +1658,16 @@ static void goya_init_tpc_protection_bit
 	goya_pb_set_block(hdev, mmTPC5_RD_REGULATOR_BASE);
 	goya_pb_set_block(hdev, mmTPC5_WR_REGULATOR_BASE);
 
+	pb_addr = (mmTPC5_CFG_SEMAPHORE & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmTPC5_CFG_SEMAPHORE & PROT_BITS_OFFS) >> 7) << 2;
+
+	mask = 1 << ((mmTPC5_CFG_SEMAPHORE & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC5_CFG_VFLAGS & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC5_CFG_SFLAGS & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC5_CFG_STATUS & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
 	pb_addr = (mmTPC5_CFG_CFG_BASE_ADDRESS_HIGH & ~0xFFF) + PROT_BITS_OFFS;
 	word_offset = ((mmTPC5_CFG_CFG_BASE_ADDRESS_HIGH &
 			PROT_BITS_OFFS) >> 7) << 2;
@@ -1610,6 +1675,10 @@ static void goya_init_tpc_protection_bit
 	mask |= 1 << ((mmTPC5_CFG_CFG_SUBTRACT_VALUE & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC5_CFG_SM_BASE_ADDRESS_LOW & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC5_CFG_SM_BASE_ADDRESS_HIGH & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC5_CFG_TPC_STALL & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC5_CFG_MSS_CONFIG & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC5_CFG_TPC_INTR_CAUSE & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC5_CFG_TPC_INTR_MASK & 0x7F) >> 2);
 
 	WREG32(pb_addr + word_offset, ~mask);
 
@@ -1785,6 +1854,16 @@ static void goya_init_tpc_protection_bit
 	goya_pb_set_block(hdev, mmTPC6_RD_REGULATOR_BASE);
 	goya_pb_set_block(hdev, mmTPC6_WR_REGULATOR_BASE);
 
+	pb_addr = (mmTPC6_CFG_SEMAPHORE & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmTPC6_CFG_SEMAPHORE & PROT_BITS_OFFS) >> 7) << 2;
+
+	mask = 1 << ((mmTPC6_CFG_SEMAPHORE & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC6_CFG_VFLAGS & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC6_CFG_SFLAGS & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC6_CFG_STATUS & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
 	pb_addr = (mmTPC6_CFG_CFG_BASE_ADDRESS_HIGH & ~0xFFF) + PROT_BITS_OFFS;
 	word_offset = ((mmTPC6_CFG_CFG_BASE_ADDRESS_HIGH &
 			PROT_BITS_OFFS) >> 7) << 2;
@@ -1792,6 +1871,10 @@ static void goya_init_tpc_protection_bit
 	mask |= 1 << ((mmTPC6_CFG_CFG_SUBTRACT_VALUE & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC6_CFG_SM_BASE_ADDRESS_LOW & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC6_CFG_SM_BASE_ADDRESS_HIGH & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC6_CFG_TPC_STALL & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC6_CFG_MSS_CONFIG & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC6_CFG_TPC_INTR_CAUSE & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC6_CFG_TPC_INTR_MASK & 0x7F) >> 2);
 
 	WREG32(pb_addr + word_offset, ~mask);
 
@@ -1967,6 +2050,16 @@ static void goya_init_tpc_protection_bit
 	goya_pb_set_block(hdev, mmTPC7_RD_REGULATOR_BASE);
 	goya_pb_set_block(hdev, mmTPC7_WR_REGULATOR_BASE);
 
+	pb_addr = (mmTPC7_CFG_SEMAPHORE & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmTPC7_CFG_SEMAPHORE & PROT_BITS_OFFS) >> 7) << 2;
+
+	mask = 1 << ((mmTPC7_CFG_SEMAPHORE & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC7_CFG_VFLAGS & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC7_CFG_SFLAGS & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC7_CFG_STATUS & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
 	pb_addr = (mmTPC7_CFG_CFG_BASE_ADDRESS_HIGH & ~0xFFF) +	PROT_BITS_OFFS;
 	word_offset = ((mmTPC7_CFG_CFG_BASE_ADDRESS_HIGH &
 			PROT_BITS_OFFS) >> 7) << 2;
@@ -1974,6 +2067,10 @@ static void goya_init_tpc_protection_bit
 	mask |= 1 << ((mmTPC7_CFG_CFG_SUBTRACT_VALUE & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC7_CFG_SM_BASE_ADDRESS_LOW & 0x7F) >> 2);
 	mask |= 1 << ((mmTPC7_CFG_SM_BASE_ADDRESS_HIGH & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC7_CFG_TPC_STALL & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC7_CFG_MSS_CONFIG & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC7_CFG_TPC_INTR_CAUSE & 0x7F) >> 2);
+	mask |= 1 << ((mmTPC7_CFG_TPC_INTR_MASK & 0x7F) >> 2);
 
 	WREG32(pb_addr + word_offset, ~mask);
 


