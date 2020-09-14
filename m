Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2508E2692AC
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 19:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbgINRMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 13:12:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbgINNEF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 09:04:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38CD021973;
        Mon, 14 Sep 2020 13:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088644;
        bh=0v8WZWlxxIAhtlbwC0j6vXLv1Vr8Xwmc87HtU7isxsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RcF1jOQLaL41bnYvdR5iFydeC8zhsxhvFNkMvCBd0XCOBhEU6VfuQwPYbnOz8WSC5
         u9YfDX1+fTseadh1hsWAX1jgloJQnw8QbOs9f9ieWrerIHJr24T0ShIJOGjmA1/36B
         imyKvtlJNgzfJj4v1sEK4ZjZLLeu1+kEHbTmTuhk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ofir Bitton <obitton@habana.ai>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 05/29] habanalabs: fix report of RAZWI initiator coordinates
Date:   Mon, 14 Sep 2020 09:03:34 -0400
Message-Id: <20200914130358.1804194-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914130358.1804194-1-sashal@kernel.org>
References: <20200914130358.1804194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ofir Bitton <obitton@habana.ai>

[ Upstream commit 69c6e18d0ce9980c8c6708f1fdb4ba843f8df172 ]

All initiator coordinates received upon an 'MMU page fault RAZWI
event' should be the routers coordinates, the only exception is the
DMA initiators for which the reported coordinates correspond to
their actual location.

Signed-off-by: Ofir Bitton <obitton@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../habanalabs/include/gaudi/gaudi_masks.h    | 32 +++++++++----------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/misc/habanalabs/include/gaudi/gaudi_masks.h b/drivers/misc/habanalabs/include/gaudi/gaudi_masks.h
index 96f08050ef0fb..6c50f015eda47 100644
--- a/drivers/misc/habanalabs/include/gaudi/gaudi_masks.h
+++ b/drivers/misc/habanalabs/include/gaudi/gaudi_masks.h
@@ -378,15 +378,15 @@ enum axi_id {
 	((((y) & RAZWI_INITIATOR_Y_MASK) << RAZWI_INITIATOR_Y_SHIFT) | \
 		(((x) & RAZWI_INITIATOR_X_MASK) << RAZWI_INITIATOR_X_SHIFT))
 
-#define RAZWI_INITIATOR_ID_X_Y_TPC0_NIC0	RAZWI_INITIATOR_ID_X_Y(1, 0)
-#define RAZWI_INITIATOR_ID_X_Y_TPC1		RAZWI_INITIATOR_ID_X_Y(2, 0)
-#define RAZWI_INITIATOR_ID_X_Y_MME0_0		RAZWI_INITIATOR_ID_X_Y(3, 0)
-#define RAZWI_INITIATOR_ID_X_Y_MME0_1		RAZWI_INITIATOR_ID_X_Y(4, 0)
-#define RAZWI_INITIATOR_ID_X_Y_MME1_0		RAZWI_INITIATOR_ID_X_Y(5, 0)
-#define RAZWI_INITIATOR_ID_X_Y_MME1_1		RAZWI_INITIATOR_ID_X_Y(6, 0)
-#define RAZWI_INITIATOR_ID_X_Y_TPC2		RAZWI_INITIATOR_ID_X_Y(7, 0)
+#define RAZWI_INITIATOR_ID_X_Y_TPC0_NIC0	RAZWI_INITIATOR_ID_X_Y(1, 1)
+#define RAZWI_INITIATOR_ID_X_Y_TPC1		RAZWI_INITIATOR_ID_X_Y(2, 1)
+#define RAZWI_INITIATOR_ID_X_Y_MME0_0		RAZWI_INITIATOR_ID_X_Y(3, 1)
+#define RAZWI_INITIATOR_ID_X_Y_MME0_1		RAZWI_INITIATOR_ID_X_Y(4, 1)
+#define RAZWI_INITIATOR_ID_X_Y_MME1_0		RAZWI_INITIATOR_ID_X_Y(5, 1)
+#define RAZWI_INITIATOR_ID_X_Y_MME1_1		RAZWI_INITIATOR_ID_X_Y(6, 1)
+#define RAZWI_INITIATOR_ID_X_Y_TPC2		RAZWI_INITIATOR_ID_X_Y(7, 1)
 #define RAZWI_INITIATOR_ID_X_Y_TPC3_PCI_CPU_PSOC \
-						RAZWI_INITIATOR_ID_X_Y(8, 0)
+						RAZWI_INITIATOR_ID_X_Y(8, 1)
 #define RAZWI_INITIATOR_ID_X_Y_DMA_IF_W_S_0	RAZWI_INITIATOR_ID_X_Y(0, 1)
 #define RAZWI_INITIATOR_ID_X_Y_DMA_IF_E_S_0	RAZWI_INITIATOR_ID_X_Y(9, 1)
 #define RAZWI_INITIATOR_ID_X_Y_DMA_IF_W_S_1	RAZWI_INITIATOR_ID_X_Y(0, 2)
@@ -395,14 +395,14 @@ enum axi_id {
 #define RAZWI_INITIATOR_ID_X_Y_DMA_IF_E_N_0	RAZWI_INITIATOR_ID_X_Y(9, 3)
 #define RAZWI_INITIATOR_ID_X_Y_DMA_IF_W_N_1	RAZWI_INITIATOR_ID_X_Y(0, 4)
 #define RAZWI_INITIATOR_ID_X_Y_DMA_IF_E_N_1	RAZWI_INITIATOR_ID_X_Y(9, 4)
-#define RAZWI_INITIATOR_ID_X_Y_TPC4_NIC1_NIC2	RAZWI_INITIATOR_ID_X_Y(1, 5)
-#define RAZWI_INITIATOR_ID_X_Y_TPC5		RAZWI_INITIATOR_ID_X_Y(2, 5)
-#define RAZWI_INITIATOR_ID_X_Y_MME2_0		RAZWI_INITIATOR_ID_X_Y(3, 5)
-#define RAZWI_INITIATOR_ID_X_Y_MME2_1		RAZWI_INITIATOR_ID_X_Y(4, 5)
-#define RAZWI_INITIATOR_ID_X_Y_MME3_0		RAZWI_INITIATOR_ID_X_Y(5, 5)
-#define RAZWI_INITIATOR_ID_X_Y_MME3_1		RAZWI_INITIATOR_ID_X_Y(6, 5)
-#define RAZWI_INITIATOR_ID_X_Y_TPC6		RAZWI_INITIATOR_ID_X_Y(7, 5)
-#define RAZWI_INITIATOR_ID_X_Y_TPC7_NIC4_NIC5	RAZWI_INITIATOR_ID_X_Y(8, 5)
+#define RAZWI_INITIATOR_ID_X_Y_TPC4_NIC1_NIC2	RAZWI_INITIATOR_ID_X_Y(1, 6)
+#define RAZWI_INITIATOR_ID_X_Y_TPC5		RAZWI_INITIATOR_ID_X_Y(2, 6)
+#define RAZWI_INITIATOR_ID_X_Y_MME2_0		RAZWI_INITIATOR_ID_X_Y(3, 6)
+#define RAZWI_INITIATOR_ID_X_Y_MME2_1		RAZWI_INITIATOR_ID_X_Y(4, 6)
+#define RAZWI_INITIATOR_ID_X_Y_MME3_0		RAZWI_INITIATOR_ID_X_Y(5, 6)
+#define RAZWI_INITIATOR_ID_X_Y_MME3_1		RAZWI_INITIATOR_ID_X_Y(6, 6)
+#define RAZWI_INITIATOR_ID_X_Y_TPC6		RAZWI_INITIATOR_ID_X_Y(7, 6)
+#define RAZWI_INITIATOR_ID_X_Y_TPC7_NIC4_NIC5	RAZWI_INITIATOR_ID_X_Y(8, 6)
 
 #define PSOC_ETR_AXICTL_PROTCTRLBIT1_SHIFT                           1
 
-- 
2.25.1

