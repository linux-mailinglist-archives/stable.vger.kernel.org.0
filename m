Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22AD499FAF
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842032AbiAXXAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835948AbiAXWhu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:37:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BAEC0E9BB7;
        Mon, 24 Jan 2022 13:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67A7FB81063;
        Mon, 24 Jan 2022 21:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B27C340E5;
        Mon, 24 Jan 2022 21:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058018;
        bh=NmOrhhpUlJ8q2hU8Rq29vfhkjMVwm9CScdOI61ffnmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nd/73ALCP+gDY9BQN3tcbdPkV9wIkl82E4Z4OrcgESatKBw1ib1L1DFwNXigZHhcZ
         Vnyl53J+WMlVwVIkerw6tpDcE9R1Ewau75U8sOLKmOudZ9BxYrA4/0vojU3gyydPhQ
         tZnwRBgOQTmC4Fr4uqHAvY4/lyn3aodZlIc58ZUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Sriram R <srirrama@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>,
        P Praneesh <ppranees@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0153/1039] ath11k: allocate dst ring descriptors from cacheable memory
Date:   Mon, 24 Jan 2022 19:32:22 +0100
Message-Id: <20220124184130.297143262@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: P Praneesh <ppranees@codeaurora.org>

[ Upstream commit 6452f0a3d5651bb7edfd9c709e78973aaa4d3bfc ]

tcl_data and reo_dst rings are currently being allocated using
dma_allocate_coherent() which is non cacheable.

Allocating ring memory from cacheable memory area allows cached descriptor
access and prefetch next descriptors to optimize CPU usage during
descriptor processing on NAPI. Based on the hardware param we can enable
or disable this feature for the corresponding platform.

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.4.0.1.r2-00012-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.4.0.1-01695-QCAHKSWPL_SILICONZ-1

Co-developed-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Co-developed-by: Sriram R <srirrama@codeaurora.org>
Signed-off-by: Sriram R <srirrama@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Signed-off-by: P Praneesh <ppranees@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1630560820-21905-3-git-send-email-ppranees@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.c |  5 ++++
 drivers/net/wireless/ath/ath11k/dp.c   | 38 ++++++++++++++++++++++----
 drivers/net/wireless/ath/ath11k/dp.h   |  1 +
 drivers/net/wireless/ath/ath11k/hal.c  | 28 +++++++++++++++++--
 drivers/net/wireless/ath/ath11k/hal.h  |  1 +
 drivers/net/wireless/ath/ath11k/hw.h   |  1 +
 6 files changed, 67 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index 7ee2ccc49c747..280f1c6411aeb 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -83,6 +83,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.max_tx_ring = DP_TCL_NUM_RING_MAX,
 		.hal_params = &ath11k_hw_hal_params_ipq8074,
 		.supports_dynamic_smps_6ghz = false,
+		.alloc_cacheable_memory = true,
 	},
 	{
 		.hw_rev = ATH11K_HW_IPQ6018_HW10,
@@ -133,6 +134,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.max_tx_ring = DP_TCL_NUM_RING_MAX,
 		.hal_params = &ath11k_hw_hal_params_ipq8074,
 		.supports_dynamic_smps_6ghz = false,
+		.alloc_cacheable_memory = true,
 	},
 	{
 		.name = "qca6390 hw2.0",
@@ -182,6 +184,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.max_tx_ring = DP_TCL_NUM_RING_MAX_QCA6390,
 		.hal_params = &ath11k_hw_hal_params_qca6390,
 		.supports_dynamic_smps_6ghz = false,
+		.alloc_cacheable_memory = false,
 	},
 	{
 		.name = "qcn9074 hw1.0",
@@ -231,6 +234,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.max_tx_ring = DP_TCL_NUM_RING_MAX,
 		.hal_params = &ath11k_hw_hal_params_ipq8074,
 		.supports_dynamic_smps_6ghz = true,
+		.alloc_cacheable_memory = true,
 	},
 	{
 		.name = "wcn6855 hw2.0",
@@ -280,6 +284,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.max_tx_ring = DP_TCL_NUM_RING_MAX_QCA6390,
 		.hal_params = &ath11k_hw_hal_params_qca6390,
 		.supports_dynamic_smps_6ghz = false,
+		.alloc_cacheable_memory = false,
 	},
 };
 
diff --git a/drivers/net/wireless/ath/ath11k/dp.c b/drivers/net/wireless/ath/ath11k/dp.c
index 8baaeeb8cf821..8058b56028ded 100644
--- a/drivers/net/wireless/ath/ath11k/dp.c
+++ b/drivers/net/wireless/ath/ath11k/dp.c
@@ -101,8 +101,11 @@ void ath11k_dp_srng_cleanup(struct ath11k_base *ab, struct dp_srng *ring)
 	if (!ring->vaddr_unaligned)
 		return;
 
-	dma_free_coherent(ab->dev, ring->size, ring->vaddr_unaligned,
-			  ring->paddr_unaligned);
+	if (ring->cached)
+		kfree(ring->vaddr_unaligned);
+	else
+		dma_free_coherent(ab->dev, ring->size, ring->vaddr_unaligned,
+				  ring->paddr_unaligned);
 
 	ring->vaddr_unaligned = NULL;
 }
@@ -222,6 +225,7 @@ int ath11k_dp_srng_setup(struct ath11k_base *ab, struct dp_srng *ring,
 	int entry_sz = ath11k_hal_srng_get_entrysize(ab, type);
 	int max_entries = ath11k_hal_srng_get_max_entries(ab, type);
 	int ret;
+	bool cached = false;
 
 	if (max_entries < 0 || entry_sz < 0)
 		return -EINVAL;
@@ -230,9 +234,28 @@ int ath11k_dp_srng_setup(struct ath11k_base *ab, struct dp_srng *ring,
 		num_entries = max_entries;
 
 	ring->size = (num_entries * entry_sz) + HAL_RING_BASE_ALIGN - 1;
-	ring->vaddr_unaligned = dma_alloc_coherent(ab->dev, ring->size,
-						   &ring->paddr_unaligned,
-						   GFP_KERNEL);
+
+	if (ab->hw_params.alloc_cacheable_memory) {
+		/* Allocate the reo dst and tx completion rings from cacheable memory */
+		switch (type) {
+		case HAL_REO_DST:
+			cached = true;
+			break;
+		default:
+			cached = false;
+		}
+
+		if (cached) {
+			ring->vaddr_unaligned = kzalloc(ring->size, GFP_KERNEL);
+			ring->paddr_unaligned = virt_to_phys(ring->vaddr_unaligned);
+		}
+	}
+
+	if (!cached)
+		ring->vaddr_unaligned = dma_alloc_coherent(ab->dev, ring->size,
+							   &ring->paddr_unaligned,
+							   GFP_KERNEL);
+
 	if (!ring->vaddr_unaligned)
 		return -ENOMEM;
 
@@ -292,6 +315,11 @@ int ath11k_dp_srng_setup(struct ath11k_base *ab, struct dp_srng *ring,
 		return -EINVAL;
 	}
 
+	if (cached) {
+		params.flags |= HAL_SRNG_FLAGS_CACHED;
+		ring->cached = 1;
+	}
+
 	ret = ath11k_hal_srng_setup(ab, type, ring_num, mac_id, &params);
 	if (ret < 0) {
 		ath11k_warn(ab, "failed to setup srng: %d ring_id %d\n",
diff --git a/drivers/net/wireless/ath/ath11k/dp.h b/drivers/net/wireless/ath/ath11k/dp.h
index f524d19aca349..a4c36a9be338a 100644
--- a/drivers/net/wireless/ath/ath11k/dp.h
+++ b/drivers/net/wireless/ath/ath11k/dp.h
@@ -64,6 +64,7 @@ struct dp_srng {
 	dma_addr_t paddr;
 	int size;
 	u32 ring_id;
+	u8 cached;
 };
 
 struct dp_rxdma_ring {
diff --git a/drivers/net/wireless/ath/ath11k/hal.c b/drivers/net/wireless/ath/ath11k/hal.c
index eaa0edca55761..f04edafbd0f15 100644
--- a/drivers/net/wireless/ath/ath11k/hal.c
+++ b/drivers/net/wireless/ath/ath11k/hal.c
@@ -627,6 +627,21 @@ u32 *ath11k_hal_srng_dst_peek(struct ath11k_base *ab, struct hal_srng *srng)
 	return NULL;
 }
 
+static void ath11k_hal_srng_prefetch_desc(struct ath11k_base *ab,
+					  struct hal_srng *srng)
+{
+	u32 *desc;
+
+	/* prefetch only if desc is available */
+	desc = ath11k_hal_srng_dst_peek(ab, srng);
+	if (likely(desc)) {
+		dma_sync_single_for_cpu(ab->dev, virt_to_phys(desc),
+					(srng->entry_size * sizeof(u32)),
+					DMA_FROM_DEVICE);
+		prefetch(desc);
+	}
+}
+
 u32 *ath11k_hal_srng_dst_get_next_entry(struct ath11k_base *ab,
 					struct hal_srng *srng)
 {
@@ -642,6 +657,10 @@ u32 *ath11k_hal_srng_dst_get_next_entry(struct ath11k_base *ab,
 	srng->u.dst_ring.tp = (srng->u.dst_ring.tp + srng->entry_size) %
 			      srng->ring_size;
 
+	/* Try to prefetch the next descriptor in the ring */
+	if (srng->flags & HAL_SRNG_FLAGS_CACHED)
+		ath11k_hal_srng_prefetch_desc(ab, srng);
+
 	return desc;
 }
 
@@ -775,11 +794,16 @@ void ath11k_hal_srng_access_begin(struct ath11k_base *ab, struct hal_srng *srng)
 {
 	lockdep_assert_held(&srng->lock);
 
-	if (srng->ring_dir == HAL_SRNG_DIR_SRC)
+	if (srng->ring_dir == HAL_SRNG_DIR_SRC) {
 		srng->u.src_ring.cached_tp =
 			*(volatile u32 *)srng->u.src_ring.tp_addr;
-	else
+	} else {
 		srng->u.dst_ring.cached_hp = *srng->u.dst_ring.hp_addr;
+
+		/* Try to prefetch the next descriptor in the ring */
+		if (srng->flags & HAL_SRNG_FLAGS_CACHED)
+			ath11k_hal_srng_prefetch_desc(ab, srng);
+	}
 }
 
 /* Update cached ring head/tail pointers to HW. ath11k_hal_srng_access_begin()
diff --git a/drivers/net/wireless/ath/ath11k/hal.h b/drivers/net/wireless/ath/ath11k/hal.h
index 35ed3a14e200a..0f4f9ce74354b 100644
--- a/drivers/net/wireless/ath/ath11k/hal.h
+++ b/drivers/net/wireless/ath/ath11k/hal.h
@@ -513,6 +513,7 @@ enum hal_srng_dir {
 #define HAL_SRNG_FLAGS_DATA_TLV_SWAP		0x00000020
 #define HAL_SRNG_FLAGS_LOW_THRESH_INTR_EN	0x00010000
 #define HAL_SRNG_FLAGS_MSI_INTR			0x00020000
+#define HAL_SRNG_FLAGS_CACHED                   0x20000000
 #define HAL_SRNG_FLAGS_LMAC_RING		0x80000000
 
 #define HAL_SRNG_TLV_HDR_TAG		GENMASK(9, 1)
diff --git a/drivers/net/wireless/ath/ath11k/hw.h b/drivers/net/wireless/ath/ath11k/hw.h
index 6dcac596e3fe5..de9e9546f2ec6 100644
--- a/drivers/net/wireless/ath/ath11k/hw.h
+++ b/drivers/net/wireless/ath/ath11k/hw.h
@@ -177,6 +177,7 @@ struct ath11k_hw_params {
 	u8 max_tx_ring;
 	const struct ath11k_hw_hal_params *hal_params;
 	bool supports_dynamic_smps_6ghz;
+	bool alloc_cacheable_memory;
 };
 
 struct ath11k_hw_ops {
-- 
2.34.1



