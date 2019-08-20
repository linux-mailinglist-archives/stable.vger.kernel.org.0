Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F26C79608A
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730455AbfHTNlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:41:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730450AbfHTNlo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:41:44 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0460722DA7;
        Tue, 20 Aug 2019 13:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308503;
        bh=E6GRUZx3EGeIzIFRsxVuHCrahG/QCZLegWBUbg3WxDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I97U3EZvx6AtL5pioQ9VXuvCjZ5cqNBMBkn77gGE+iBWH6hj991qnZHffNP4RqnQ1
         1Y766XbI/4Pmkf7TT0KOAT3a1mH0g3XsnrMJ8mQx7OyXuRTm7ErR7laghUcMBS4Ftq
         RD2lyv+drOjKIsyqvxTdPHzwoP2Aum74HB59vDDU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Segal <bpsegal20@gmail.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 34/44] habanalabs: fix device IRQ unmasking for BE host
Date:   Tue, 20 Aug 2019 09:40:18 -0400
Message-Id: <20190820134028.10829-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134028.10829-1-sashal@kernel.org>
References: <20190820134028.10829-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Segal <bpsegal20@gmail.com>

[ Upstream commit b421d83a3947369fd5718824aecfaebe1efbf7ed ]

When unmasking IRQs inside the ASIC, the driver passes an array of all the
IRQ to unmask. The ASIC's CPU is working in LE so when running in a BE
host, the driver needs to do the proper endianness swapping when preparing
this array.

In addition, this patch also fixes the endianness of a couple of kernel log
debug messages that print values of packets

Signed-off-by: Ben Segal <bpsegal20@gmail.com>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/goya/goya.c | 33 +++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/habanalabs/goya/goya.c b/drivers/misc/habanalabs/goya/goya.c
index 9216cc3599178..ac6b252a1ddcb 100644
--- a/drivers/misc/habanalabs/goya/goya.c
+++ b/drivers/misc/habanalabs/goya/goya.c
@@ -3311,9 +3311,11 @@ static int goya_validate_dma_pkt_no_mmu(struct hl_device *hdev,
 	int rc;
 
 	dev_dbg(hdev->dev, "DMA packet details:\n");
-	dev_dbg(hdev->dev, "source == 0x%llx\n", user_dma_pkt->src_addr);
-	dev_dbg(hdev->dev, "destination == 0x%llx\n", user_dma_pkt->dst_addr);
-	dev_dbg(hdev->dev, "size == %u\n", user_dma_pkt->tsize);
+	dev_dbg(hdev->dev, "source == 0x%llx\n",
+		le64_to_cpu(user_dma_pkt->src_addr));
+	dev_dbg(hdev->dev, "destination == 0x%llx\n",
+		le64_to_cpu(user_dma_pkt->dst_addr));
+	dev_dbg(hdev->dev, "size == %u\n", le32_to_cpu(user_dma_pkt->tsize));
 
 	ctl = le32_to_cpu(user_dma_pkt->ctl);
 	user_dir = (ctl & GOYA_PKT_LIN_DMA_CTL_DMA_DIR_MASK) >>
@@ -3342,9 +3344,11 @@ static int goya_validate_dma_pkt_mmu(struct hl_device *hdev,
 				struct packet_lin_dma *user_dma_pkt)
 {
 	dev_dbg(hdev->dev, "DMA packet details:\n");
-	dev_dbg(hdev->dev, "source == 0x%llx\n", user_dma_pkt->src_addr);
-	dev_dbg(hdev->dev, "destination == 0x%llx\n", user_dma_pkt->dst_addr);
-	dev_dbg(hdev->dev, "size == %u\n", user_dma_pkt->tsize);
+	dev_dbg(hdev->dev, "source == 0x%llx\n",
+		le64_to_cpu(user_dma_pkt->src_addr));
+	dev_dbg(hdev->dev, "destination == 0x%llx\n",
+		le64_to_cpu(user_dma_pkt->dst_addr));
+	dev_dbg(hdev->dev, "size == %u\n", le32_to_cpu(user_dma_pkt->tsize));
 
 	/*
 	 * WA for HW-23.
@@ -3384,7 +3388,8 @@ static int goya_validate_wreg32(struct hl_device *hdev,
 
 	dev_dbg(hdev->dev, "WREG32 packet details:\n");
 	dev_dbg(hdev->dev, "reg_offset == 0x%x\n", reg_offset);
-	dev_dbg(hdev->dev, "value      == 0x%x\n", wreg_pkt->value);
+	dev_dbg(hdev->dev, "value      == 0x%x\n",
+		le32_to_cpu(wreg_pkt->value));
 
 	if (reg_offset != (mmDMA_CH_0_WR_COMP_ADDR_LO & 0x1FFF)) {
 		dev_err(hdev->dev, "WREG32 packet with illegal address 0x%x\n",
@@ -4252,6 +4257,8 @@ static int goya_unmask_irq_arr(struct hl_device *hdev, u32 *irq_arr,
 	size_t total_pkt_size;
 	long result;
 	int rc;
+	int irq_num_entries, irq_arr_index;
+	__le32 *goya_irq_arr;
 
 	total_pkt_size = sizeof(struct armcp_unmask_irq_arr_packet) +
 			irq_arr_size;
@@ -4269,8 +4276,16 @@ static int goya_unmask_irq_arr(struct hl_device *hdev, u32 *irq_arr,
 	if (!pkt)
 		return -ENOMEM;
 
-	pkt->length = cpu_to_le32(irq_arr_size / sizeof(irq_arr[0]));
-	memcpy(&pkt->irqs, irq_arr, irq_arr_size);
+	irq_num_entries = irq_arr_size / sizeof(irq_arr[0]);
+	pkt->length = cpu_to_le32(irq_num_entries);
+
+	/* We must perform any necessary endianness conversation on the irq
+	 * array being passed to the goya hardware
+	 */
+	for (irq_arr_index = 0, goya_irq_arr = (__le32 *) &pkt->irqs;
+			irq_arr_index < irq_num_entries ; irq_arr_index++)
+		goya_irq_arr[irq_arr_index] =
+				cpu_to_le32(irq_arr[irq_arr_index]);
 
 	pkt->armcp_pkt.ctl = cpu_to_le32(ARMCP_PACKET_UNMASK_RAZWI_IRQ_ARRAY <<
 						ARMCP_PKT_CTL_OPCODE_SHIFT);
-- 
2.20.1

