Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD3A4F29F5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242688AbiDEJh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236609AbiDEJDO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:03:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617BAE89;
        Tue,  5 Apr 2022 01:55:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0FBB614E4;
        Tue,  5 Apr 2022 08:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ECF9C385A0;
        Tue,  5 Apr 2022 08:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148904;
        bh=8JqsUZD3l0J1Ds296wU9SUMpq6UVExyeq74Hyjg9rIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jEVhjsWrI1Db0mYXJHegU29ZY9ymOzVjGehTcvbeMJdAv3BaqM+3NXNwcM9DA2pzo
         oMhWHceSYZINRfXSaL8OvZbe9IBWGl6fwkNAHcQhdhvi02W6whNyRpVkY52ZkRCdCR
         nOM7iaqeVW5OzbavVLkjpkXsW2pjj55oWASlFQHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sriram R <srirrama@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>,
        P Praneesh <ppranees@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0524/1017] ath11k: avoid active pdev check for each msdu
Date:   Tue,  5 Apr 2022 09:23:57 +0200
Message-Id: <20220405070409.850659501@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: P Praneesh <ppranees@codeaurora.org>

[ Upstream commit c4d12cb37ea2e6c2b70880350d7bf1bbbd825c6c ]

The Active Pdev and CAC check are done for each msdu in
ath11k_dp_rx_process_received_packets which is a overhead.
To avoid this overhead, collect all msdus in a per mac msdu
list and pass to function.

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.4.0.1.r2-00012-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.4.0.1-01695-QCAHKSWPL_SILICONZ-1

Co-developed-by: Sriram R <srirrama@codeaurora.org>
Signed-off-by: Sriram R <srirrama@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Signed-off-by: P Praneesh <ppranees@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1630560820-21905-6-git-send-email-ppranees@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 70 ++++++++++++-------------
 1 file changed, 34 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 621372c568d2..0bc3baf4af5c 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -2596,13 +2596,11 @@ static int ath11k_dp_rx_process_msdu(struct ath11k *ar,
 static void ath11k_dp_rx_process_received_packets(struct ath11k_base *ab,
 						  struct napi_struct *napi,
 						  struct sk_buff_head *msdu_list,
-						  int *quota, int ring_id)
+						  int *quota, int mac_id)
 {
-	struct ath11k_skb_rxcb *rxcb;
 	struct sk_buff *msdu;
 	struct ath11k *ar;
 	struct ieee80211_rx_status rx_status = {0};
-	u8 mac_id;
 	int ret;
 
 	if (skb_queue_empty(msdu_list))
@@ -2610,20 +2608,20 @@ static void ath11k_dp_rx_process_received_packets(struct ath11k_base *ab,
 
 	rcu_read_lock();
 
-	while (*quota && (msdu = __skb_dequeue(msdu_list))) {
-		rxcb = ATH11K_SKB_RXCB(msdu);
-		mac_id = rxcb->mac_id;
-		ar = ab->pdevs[mac_id].ar;
-		if (!rcu_dereference(ab->pdevs_active[mac_id])) {
-			dev_kfree_skb_any(msdu);
-			continue;
-		}
+	ar = ab->pdevs[mac_id].ar;
+	if (!rcu_dereference(ab->pdevs_active[mac_id])) {
+		__skb_queue_purge(msdu_list);
+		rcu_read_unlock();
+		return;
+	}
 
-		if (test_bit(ATH11K_CAC_RUNNING, &ar->dev_flags)) {
-			dev_kfree_skb_any(msdu);
-			continue;
-		}
+	if (test_bit(ATH11K_CAC_RUNNING, &ar->dev_flags)) {
+		__skb_queue_purge(msdu_list);
+		rcu_read_unlock();
+		return;
+	}
 
+	while ((msdu = __skb_dequeue(msdu_list))) {
 		ret = ath11k_dp_rx_process_msdu(ar, msdu, msdu_list, &rx_status);
 		if (ret) {
 			ath11k_dbg(ab, ATH11K_DBG_DATA,
@@ -2645,7 +2643,7 @@ int ath11k_dp_process_rx(struct ath11k_base *ab, int ring_id,
 	struct ath11k_dp *dp = &ab->dp;
 	struct dp_rxdma_ring *rx_ring;
 	int num_buffs_reaped[MAX_RADIOS] = {0};
-	struct sk_buff_head msdu_list;
+	struct sk_buff_head msdu_list[MAX_RADIOS];
 	struct ath11k_skb_rxcb *rxcb;
 	int total_msdu_reaped = 0;
 	struct hal_srng *srng;
@@ -2654,10 +2652,13 @@ int ath11k_dp_process_rx(struct ath11k_base *ab, int ring_id,
 	bool done = false;
 	int buf_id, mac_id;
 	struct ath11k *ar;
-	u32 *rx_desc;
+	struct hal_reo_dest_ring *desc;
+	enum hal_reo_dest_ring_push_reason push_reason;
+	u32 cookie;
 	int i;
 
-	__skb_queue_head_init(&msdu_list);
+	for (i = 0; i < MAX_RADIOS; i++)
+		__skb_queue_head_init(&msdu_list[i]);
 
 	srng = &ab->hal.srng_list[dp->reo_dst_ring[ring_id].ring_id];
 
@@ -2666,13 +2667,11 @@ int ath11k_dp_process_rx(struct ath11k_base *ab, int ring_id,
 	ath11k_hal_srng_access_begin(ab, srng);
 
 try_again:
-	while ((rx_desc = ath11k_hal_srng_dst_get_next_entry(ab, srng))) {
-		struct hal_reo_dest_ring desc = *(struct hal_reo_dest_ring *)rx_desc;
-		enum hal_reo_dest_ring_push_reason push_reason;
-		u32 cookie;
-
+	while (likely(desc =
+	      (struct hal_reo_dest_ring *)ath11k_hal_srng_dst_get_next_entry(ab,
+									     srng))) {
 		cookie = FIELD_GET(BUFFER_ADDR_INFO1_SW_COOKIE,
-				   desc.buf_addr_info.info1);
+				   desc->buf_addr_info.info1);
 		buf_id = FIELD_GET(DP_RXDMA_BUF_COOKIE_BUF_ID,
 				   cookie);
 		mac_id = FIELD_GET(DP_RXDMA_BUF_COOKIE_PDEV_ID, cookie);
@@ -2700,7 +2699,7 @@ int ath11k_dp_process_rx(struct ath11k_base *ab, int ring_id,
 		total_msdu_reaped++;
 
 		push_reason = FIELD_GET(HAL_REO_DEST_RING_INFO0_PUSH_REASON,
-					desc.info0);
+					desc->info0);
 		if (push_reason !=
 		    HAL_REO_DEST_RING_PUSH_REASON_ROUTING_INSTRUCTION) {
 			dev_kfree_skb_any(msdu);
@@ -2708,21 +2707,21 @@ int ath11k_dp_process_rx(struct ath11k_base *ab, int ring_id,
 			continue;
 		}
 
-		rxcb->is_first_msdu = !!(desc.rx_msdu_info.info0 &
+		rxcb->is_first_msdu = !!(desc->rx_msdu_info.info0 &
 					 RX_MSDU_DESC_INFO0_FIRST_MSDU_IN_MPDU);
-		rxcb->is_last_msdu = !!(desc.rx_msdu_info.info0 &
+		rxcb->is_last_msdu = !!(desc->rx_msdu_info.info0 &
 					RX_MSDU_DESC_INFO0_LAST_MSDU_IN_MPDU);
-		rxcb->is_continuation = !!(desc.rx_msdu_info.info0 &
+		rxcb->is_continuation = !!(desc->rx_msdu_info.info0 &
 					   RX_MSDU_DESC_INFO0_MSDU_CONTINUATION);
 		rxcb->peer_id = FIELD_GET(RX_MPDU_DESC_META_DATA_PEER_ID,
-					  desc.rx_mpdu_info.meta_data);
+					  desc->rx_mpdu_info.meta_data);
 		rxcb->seq_no = FIELD_GET(RX_MPDU_DESC_INFO0_SEQ_NUM,
-					 desc.rx_mpdu_info.info0);
+					 desc->rx_mpdu_info.info0);
 		rxcb->tid = FIELD_GET(HAL_REO_DEST_RING_INFO0_RX_QUEUE_NUM,
-				      desc.info0);
+				      desc->info0);
 
 		rxcb->mac_id = mac_id;
-		__skb_queue_tail(&msdu_list, msdu);
+		__skb_queue_tail(&msdu_list[mac_id], msdu);
 
 		if (total_msdu_reaped >= quota && !rxcb->is_continuation) {
 			done = true;
@@ -2752,16 +2751,15 @@ int ath11k_dp_process_rx(struct ath11k_base *ab, int ring_id,
 		if (!num_buffs_reaped[i])
 			continue;
 
+		ath11k_dp_rx_process_received_packets(ab, napi, &msdu_list[i],
+						      &quota, i);
+
 		ar = ab->pdevs[i].ar;
 		rx_ring = &ar->dp.rx_refill_buf_ring;
 
 		ath11k_dp_rxbufs_replenish(ab, i, rx_ring, num_buffs_reaped[i],
 					   ab->hw_params.hal_params->rx_buf_rbm);
 	}
-
-	ath11k_dp_rx_process_received_packets(ab, napi, &msdu_list,
-					      &quota, ring_id);
-
 exit:
 	return budget - quota;
 }
-- 
2.34.1



