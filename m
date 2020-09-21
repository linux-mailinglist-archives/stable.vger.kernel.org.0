Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2EE272DC7
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbgIUQnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:43:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729169AbgIUQnI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:43:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACA502399A;
        Mon, 21 Sep 2020 16:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706587;
        bh=0v8WZWlxxIAhtlbwC0j6vXLv1Vr8Xwmc87HtU7isxsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=daICFYFPOKBH6MI3fH8pFoh4jfzibMxvSr0Ck2FT5HBpvrllBKlELB+mvq0TXqD0P
         uvltX4v5k+UKteYf9M2uz+RVg/bRX1j5097/990B0gQXxC/qHgSyXhdoPE7BlQhMug
         61RSBlEdFh0OaiaLkKz3kuLkYlOXpVNswJjTmqkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ofir Bitton <obitton@habana.ai>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 013/118] habanalabs: fix report of RAZWI initiator coordinates
Date:   Mon, 21 Sep 2020 18:27:05 +0200
Message-Id: <20200921162036.948681699@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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



