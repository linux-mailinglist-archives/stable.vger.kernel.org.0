Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 938F3176D6C
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 04:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgCCDDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 22:03:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:40696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727456AbgCCCq1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 21:46:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3473E2467B;
        Tue,  3 Mar 2020 02:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203586;
        bh=3Bx8udfb9FnxnWAt+F7PsFFjq1j/IIjT9fNxerbjN54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hUZIsnW/IJmcnPuF+Bn3dMiSE4cqtnwYegbuk+j4NeRTVxE/nlMbRqVwqyij66Rlk
         bsH42Z+LoLFasd/44Igy4wpiwtBtO4/hmyrgsKzOOcrhpXG89X9EH/vTZs9NsNsxb3
         /1AsPzhH/pm6VOGcLumiqUKnSV0nBDY+wi6VvioQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oded Gabbay <oded.gabbay@gmail.com>,
        Tomer Tayar <ttayar@habana.ai>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 09/66] habanalabs: halt the engines before hard-reset
Date:   Mon,  2 Mar 2020 21:45:18 -0500
Message-Id: <20200303024615.8889-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024615.8889-1-sashal@kernel.org>
References: <20200303024615.8889-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oded Gabbay <oded.gabbay@gmail.com>

[ Upstream commit 908087ffbe896c100ed73d5f0ce11a5b7264af4a ]

The driver must halt the engines before doing hard-reset, otherwise the
device can go into undefined state. There is a place where the driver
didn't do that and this patch fixes it.

Reviewed-by: Tomer Tayar <ttayar@habana.ai>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/device.c    |  1 +
 drivers/misc/habanalabs/goya/goya.c | 42 +++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/misc/habanalabs/device.c b/drivers/misc/habanalabs/device.c
index b155e95490761..166883b647252 100644
--- a/drivers/misc/habanalabs/device.c
+++ b/drivers/misc/habanalabs/device.c
@@ -1189,6 +1189,7 @@ int hl_device_init(struct hl_device *hdev, struct class *hclass)
 	if (hdev->asic_funcs->get_hw_state(hdev) == HL_DEVICE_HW_STATE_DIRTY) {
 		dev_info(hdev->dev,
 			"H/W state is dirty, must reset before initializing\n");
+		hdev->asic_funcs->halt_engines(hdev, true);
 		hdev->asic_funcs->hw_fini(hdev, true);
 	}
 
diff --git a/drivers/misc/habanalabs/goya/goya.c b/drivers/misc/habanalabs/goya/goya.c
index 7344e8a222ae5..f24fe909b88d8 100644
--- a/drivers/misc/habanalabs/goya/goya.c
+++ b/drivers/misc/habanalabs/goya/goya.c
@@ -895,6 +895,11 @@ void goya_init_dma_qmans(struct hl_device *hdev)
  */
 static void goya_disable_external_queues(struct hl_device *hdev)
 {
+	struct goya_device *goya = hdev->asic_specific;
+
+	if (!(goya->hw_cap_initialized & HW_CAP_DMA))
+		return;
+
 	WREG32(mmDMA_QM_0_GLBL_CFG0, 0);
 	WREG32(mmDMA_QM_1_GLBL_CFG0, 0);
 	WREG32(mmDMA_QM_2_GLBL_CFG0, 0);
@@ -956,6 +961,11 @@ static int goya_stop_external_queues(struct hl_device *hdev)
 {
 	int rc, retval = 0;
 
+	struct goya_device *goya = hdev->asic_specific;
+
+	if (!(goya->hw_cap_initialized & HW_CAP_DMA))
+		return retval;
+
 	rc = goya_stop_queue(hdev,
 			mmDMA_QM_0_GLBL_CFG1,
 			mmDMA_QM_0_CP_STS,
@@ -1744,9 +1754,18 @@ void goya_init_tpc_qmans(struct hl_device *hdev)
  */
 static void goya_disable_internal_queues(struct hl_device *hdev)
 {
+	struct goya_device *goya = hdev->asic_specific;
+
+	if (!(goya->hw_cap_initialized & HW_CAP_MME))
+		goto disable_tpc;
+
 	WREG32(mmMME_QM_GLBL_CFG0, 0);
 	WREG32(mmMME_CMDQ_GLBL_CFG0, 0);
 
+disable_tpc:
+	if (!(goya->hw_cap_initialized & HW_CAP_TPC))
+		return;
+
 	WREG32(mmTPC0_QM_GLBL_CFG0, 0);
 	WREG32(mmTPC0_CMDQ_GLBL_CFG0, 0);
 
@@ -1782,8 +1801,12 @@ static void goya_disable_internal_queues(struct hl_device *hdev)
  */
 static int goya_stop_internal_queues(struct hl_device *hdev)
 {
+	struct goya_device *goya = hdev->asic_specific;
 	int rc, retval = 0;
 
+	if (!(goya->hw_cap_initialized & HW_CAP_MME))
+		goto stop_tpc;
+
 	/*
 	 * Each queue (QMAN) is a separate H/W logic. That means that each
 	 * QMAN can be stopped independently and failure to stop one does NOT
@@ -1810,6 +1833,10 @@ static int goya_stop_internal_queues(struct hl_device *hdev)
 		retval = -EIO;
 	}
 
+stop_tpc:
+	if (!(goya->hw_cap_initialized & HW_CAP_TPC))
+		return retval;
+
 	rc = goya_stop_queue(hdev,
 			mmTPC0_QM_GLBL_CFG1,
 			mmTPC0_QM_CP_STS,
@@ -1975,6 +2002,11 @@ static int goya_stop_internal_queues(struct hl_device *hdev)
 
 static void goya_dma_stall(struct hl_device *hdev)
 {
+	struct goya_device *goya = hdev->asic_specific;
+
+	if (!(goya->hw_cap_initialized & HW_CAP_DMA))
+		return;
+
 	WREG32(mmDMA_QM_0_GLBL_CFG1, 1 << DMA_QM_0_GLBL_CFG1_DMA_STOP_SHIFT);
 	WREG32(mmDMA_QM_1_GLBL_CFG1, 1 << DMA_QM_1_GLBL_CFG1_DMA_STOP_SHIFT);
 	WREG32(mmDMA_QM_2_GLBL_CFG1, 1 << DMA_QM_2_GLBL_CFG1_DMA_STOP_SHIFT);
@@ -1984,6 +2016,11 @@ static void goya_dma_stall(struct hl_device *hdev)
 
 static void goya_tpc_stall(struct hl_device *hdev)
 {
+	struct goya_device *goya = hdev->asic_specific;
+
+	if (!(goya->hw_cap_initialized & HW_CAP_TPC))
+		return;
+
 	WREG32(mmTPC0_CFG_TPC_STALL, 1 << TPC0_CFG_TPC_STALL_V_SHIFT);
 	WREG32(mmTPC1_CFG_TPC_STALL, 1 << TPC1_CFG_TPC_STALL_V_SHIFT);
 	WREG32(mmTPC2_CFG_TPC_STALL, 1 << TPC2_CFG_TPC_STALL_V_SHIFT);
@@ -1996,6 +2033,11 @@ static void goya_tpc_stall(struct hl_device *hdev)
 
 static void goya_mme_stall(struct hl_device *hdev)
 {
+	struct goya_device *goya = hdev->asic_specific;
+
+	if (!(goya->hw_cap_initialized & HW_CAP_MME))
+		return;
+
 	WREG32(mmMME_STALL, 0xFFFFFFFF);
 }
 
-- 
2.20.1

