Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEA249A992
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378349AbiAYDXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:23:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40088 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387468AbiAXUgw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:36:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B12CB81057;
        Mon, 24 Jan 2022 20:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4919EC340E7;
        Mon, 24 Jan 2022 20:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056609;
        bh=8KuTjmPp/MLiNT/2gsOcGUGShT0/jxdVaVHuNmTztTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iTg+/HAw3Ty5a/T5izrSvxuNxQ5RzCor5ISmjD8TgeTShZLI2O1VLOhuYQFs+zlco
         L9o/WerCFujkHkoQb/7e4hwyZYEPkDWdX9ifjwozD4/hV/TP6sFP68Z4a5QAOSXrIA
         592OFE4p+vC8Rx+u2iGwUg6X60mO5z6TFRd6HGq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sriram R <quic_srirrama@quicinc.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 508/846] ath11k: Avoid NULL ptr access during mgmt tx cleanup
Date:   Mon, 24 Jan 2022 19:40:25 +0100
Message-Id: <20220124184118.552061646@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sriram R <quic_srirrama@quicinc.com>

[ Upstream commit a93789ae541c7d5c1c2a4942013adb6bcc5e2848 ]

Currently 'ar' reference is not added in skb_cb during
WMI mgmt tx. Though this is generally not used during tx completion
callbacks, on interface removal the remaining idr cleanup callback
uses the ar ptr from skb_cb from mgmt txmgmt_idr. Hence
fill them during tx call for proper usage.

Also free the skb which is missing currently in these
callbacks.

Crash_info:

[19282.489476] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[19282.489515] pgd = 91eb8000
[19282.496702] [00000000] *pgd=00000000
[19282.502524] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
[19282.783728] PC is at ath11k_mac_vif_txmgmt_idr_remove+0x28/0xd8 [ath11k]
[19282.789170] LR is at idr_for_each+0xa0/0xc8

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.5.0.1-00729-QCAHKSWPL_SILICONZ-3 v2
Signed-off-by: Sriram R <quic_srirrama@quicinc.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1637832614-13831-1-git-send-email-quic_srirrama@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 35 +++++++++++++++------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index f8f973ef150e2..3834be1587057 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2018-2019 The Linux Foundation. All rights reserved.
+ * Copyright (c) 2021 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
 #include <net/mac80211.h>
@@ -4136,23 +4137,32 @@ static int __ath11k_set_antenna(struct ath11k *ar, u32 tx_ant, u32 rx_ant)
 	return 0;
 }
 
-int ath11k_mac_tx_mgmt_pending_free(int buf_id, void *skb, void *ctx)
+static void ath11k_mac_tx_mgmt_free(struct ath11k *ar, int buf_id)
 {
-	struct sk_buff *msdu = skb;
+	struct sk_buff *msdu;
 	struct ieee80211_tx_info *info;
-	struct ath11k *ar = ctx;
-	struct ath11k_base *ab = ar->ab;
 
 	spin_lock_bh(&ar->txmgmt_idr_lock);
-	idr_remove(&ar->txmgmt_idr, buf_id);
+	msdu = idr_remove(&ar->txmgmt_idr, buf_id);
 	spin_unlock_bh(&ar->txmgmt_idr_lock);
-	dma_unmap_single(ab->dev, ATH11K_SKB_CB(msdu)->paddr, msdu->len,
+
+	if (!msdu)
+		return;
+
+	dma_unmap_single(ar->ab->dev, ATH11K_SKB_CB(msdu)->paddr, msdu->len,
 			 DMA_TO_DEVICE);
 
 	info = IEEE80211_SKB_CB(msdu);
 	memset(&info->status, 0, sizeof(info->status));
 
 	ieee80211_free_txskb(ar->hw, msdu);
+}
+
+int ath11k_mac_tx_mgmt_pending_free(int buf_id, void *skb, void *ctx)
+{
+	struct ath11k *ar = ctx;
+
+	ath11k_mac_tx_mgmt_free(ar, buf_id);
 
 	return 0;
 }
@@ -4161,17 +4171,10 @@ static int ath11k_mac_vif_txmgmt_idr_remove(int buf_id, void *skb, void *ctx)
 {
 	struct ieee80211_vif *vif = ctx;
 	struct ath11k_skb_cb *skb_cb = ATH11K_SKB_CB((struct sk_buff *)skb);
-	struct sk_buff *msdu = skb;
 	struct ath11k *ar = skb_cb->ar;
-	struct ath11k_base *ab = ar->ab;
 
-	if (skb_cb->vif == vif) {
-		spin_lock_bh(&ar->txmgmt_idr_lock);
-		idr_remove(&ar->txmgmt_idr, buf_id);
-		spin_unlock_bh(&ar->txmgmt_idr_lock);
-		dma_unmap_single(ab->dev, skb_cb->paddr, msdu->len,
-				 DMA_TO_DEVICE);
-	}
+	if (skb_cb->vif == vif)
+		ath11k_mac_tx_mgmt_free(ar, buf_id);
 
 	return 0;
 }
@@ -4186,6 +4189,8 @@ static int ath11k_mac_mgmt_tx_wmi(struct ath11k *ar, struct ath11k_vif *arvif,
 	int buf_id;
 	int ret;
 
+	ATH11K_SKB_CB(skb)->ar = ar;
+
 	spin_lock_bh(&ar->txmgmt_idr_lock);
 	buf_id = idr_alloc(&ar->txmgmt_idr, skb, 0,
 			   ATH11K_TX_MGMT_NUM_PENDING_MAX, GFP_ATOMIC);
-- 
2.34.1



