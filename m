Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 187EE664AE1
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239396AbjAJSha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:37:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239433AbjAJSgT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:36:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC4952763
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:31:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 68FB9CE18B3
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B84C433D2;
        Tue, 10 Jan 2023 18:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375500;
        bh=H0bkkrcJ3lBTuKIJXAOoMxftvazkvOMumBBOphUg2bY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cyAFYcmgxgWHqLMUS0EjHJFWl987bRI8c48rme2Wze4yIDZoyoX8gVBO6t40NOUE1
         Mz3Z09KlcyX+tmliFji+ffShHo0WMfgSqJbG/bdKvh0zopG9aXMDByWVLk06XFhazj
         /gEs7TX1tXSUsude8F9pyFIZNUJ1o06XxzgIY/58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peng Li <lipeng321@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 210/290] net: hns3: extract macro to simplify ring stats update code
Date:   Tue, 10 Jan 2023 19:05:02 +0100
Message-Id: <20230110180039.235884790@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

[ Upstream commit e6d72f6ac2ad4965491354d74b48e35a60abf298 ]

As the code to update ring stats is alike for different ring stats
type, this patch extract macro to simplify ring stats update code.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 7d89b53cea1a ("net: hns3: fix miss L3E checking for rx packet")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 123 +++++-------------
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |   7 +
 2 files changed, 38 insertions(+), 92 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index e9f2d51a8b7b..d06e2d0bae2e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1005,9 +1005,7 @@ static bool hns3_can_use_tx_bounce(struct hns3_enet_ring *ring,
 		return false;
 
 	if (ALIGN(len, dma_get_cache_alignment()) > space) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.tx_spare_full++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, tx_spare_full);
 		return false;
 	}
 
@@ -1024,9 +1022,7 @@ static bool hns3_can_use_tx_sgl(struct hns3_enet_ring *ring,
 		return false;
 
 	if (space < HNS3_MAX_SGL_SIZE) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.tx_spare_full++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, tx_spare_full);
 		return false;
 	}
 
@@ -1554,9 +1550,7 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 
 	ret = hns3_handle_vtags(ring, skb);
 	if (unlikely(ret < 0)) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.tx_vlan_err++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, tx_vlan_err);
 		return ret;
 	} else if (ret == HNS3_INNER_VLAN_TAG) {
 		inner_vtag = skb_vlan_tag_get(skb);
@@ -1591,9 +1585,7 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 
 		ret = hns3_get_l4_protocol(skb, &ol4_proto, &il4_proto);
 		if (unlikely(ret < 0)) {
-			u64_stats_update_begin(&ring->syncp);
-			ring->stats.tx_l4_proto_err++;
-			u64_stats_update_end(&ring->syncp);
+			hns3_ring_stats_update(ring, tx_l4_proto_err);
 			return ret;
 		}
 
@@ -1601,18 +1593,14 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 				      &type_cs_vlan_tso,
 				      &ol_type_vlan_len_msec);
 		if (unlikely(ret < 0)) {
-			u64_stats_update_begin(&ring->syncp);
-			ring->stats.tx_l2l3l4_err++;
-			u64_stats_update_end(&ring->syncp);
+			hns3_ring_stats_update(ring, tx_l2l3l4_err);
 			return ret;
 		}
 
 		ret = hns3_set_tso(skb, &paylen_ol4cs, &mss_hw_csum,
 				   &type_cs_vlan_tso, &desc_cb->send_bytes);
 		if (unlikely(ret < 0)) {
-			u64_stats_update_begin(&ring->syncp);
-			ring->stats.tx_tso_err++;
-			u64_stats_update_end(&ring->syncp);
+			hns3_ring_stats_update(ring, tx_tso_err);
 			return ret;
 		}
 	}
@@ -1705,9 +1693,7 @@ static int hns3_map_and_fill_desc(struct hns3_enet_ring *ring, void *priv,
 	}
 
 	if (unlikely(dma_mapping_error(dev, dma))) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.sw_err_cnt++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, sw_err_cnt);
 		return -ENOMEM;
 	}
 
@@ -1853,9 +1839,7 @@ static int hns3_skb_linearize(struct hns3_enet_ring *ring,
 	 * recursion level of over HNS3_MAX_RECURSION_LEVEL.
 	 */
 	if (bd_num == UINT_MAX) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.over_max_recursion++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, over_max_recursion);
 		return -ENOMEM;
 	}
 
@@ -1864,16 +1848,12 @@ static int hns3_skb_linearize(struct hns3_enet_ring *ring,
 	 */
 	if (skb->len > HNS3_MAX_TSO_SIZE ||
 	    (!skb_is_gso(skb) && skb->len > HNS3_MAX_NON_TSO_SIZE)) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.hw_limitation++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, hw_limitation);
 		return -ENOMEM;
 	}
 
 	if (__skb_linearize(skb)) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.sw_err_cnt++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, sw_err_cnt);
 		return -ENOMEM;
 	}
 
@@ -1903,9 +1883,7 @@ static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 
 		bd_num = hns3_tx_bd_count(skb->len);
 
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.tx_copy++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, tx_copy);
 	}
 
 out:
@@ -1925,9 +1903,7 @@ static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 		return bd_num;
 	}
 
-	u64_stats_update_begin(&ring->syncp);
-	ring->stats.tx_busy++;
-	u64_stats_update_end(&ring->syncp);
+	hns3_ring_stats_update(ring, tx_busy);
 
 	return -EBUSY;
 }
@@ -2012,9 +1988,7 @@ static void hns3_tx_doorbell(struct hns3_enet_ring *ring, int num,
 	ring->pending_buf += num;
 
 	if (!doorbell) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.tx_more++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, tx_more);
 		return;
 	}
 
@@ -2064,9 +2038,7 @@ static int hns3_handle_tx_bounce(struct hns3_enet_ring *ring,
 	ret = skb_copy_bits(skb, 0, buf, size);
 	if (unlikely(ret < 0)) {
 		hns3_tx_spare_rollback(ring, cb_len);
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.copy_bits_err++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, copy_bits_err);
 		return ret;
 	}
 
@@ -2089,9 +2061,8 @@ static int hns3_handle_tx_bounce(struct hns3_enet_ring *ring,
 	dma_sync_single_for_device(ring_to_dev(ring), dma, size,
 				   DMA_TO_DEVICE);
 
-	u64_stats_update_begin(&ring->syncp);
-	ring->stats.tx_bounce++;
-	u64_stats_update_end(&ring->syncp);
+	hns3_ring_stats_update(ring, tx_bounce);
+
 	return bd_num;
 }
 
@@ -2121,9 +2092,7 @@ static int hns3_handle_tx_sgl(struct hns3_enet_ring *ring,
 	nents = skb_to_sgvec(skb, sgt->sgl, 0, skb->len);
 	if (unlikely(nents < 0)) {
 		hns3_tx_spare_rollback(ring, cb_len);
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.skb2sgl_err++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, skb2sgl_err);
 		return -ENOMEM;
 	}
 
@@ -2132,9 +2101,7 @@ static int hns3_handle_tx_sgl(struct hns3_enet_ring *ring,
 				DMA_TO_DEVICE);
 	if (unlikely(!sgt->nents)) {
 		hns3_tx_spare_rollback(ring, cb_len);
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.map_sg_err++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, map_sg_err);
 		return -ENOMEM;
 	}
 
@@ -2146,10 +2113,7 @@ static int hns3_handle_tx_sgl(struct hns3_enet_ring *ring,
 	for (i = 0; i < sgt->nents; i++)
 		bd_num += hns3_fill_desc(ring, sg_dma_address(sgt->sgl + i),
 					 sg_dma_len(sgt->sgl + i));
-
-	u64_stats_update_begin(&ring->syncp);
-	ring->stats.tx_sgl++;
-	u64_stats_update_end(&ring->syncp);
+	hns3_ring_stats_update(ring, tx_sgl);
 
 	return bd_num;
 }
@@ -2188,9 +2152,7 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 	if (skb_put_padto(skb, HNS3_MIN_TX_LEN)) {
 		hns3_tx_doorbell(ring, 0, !netdev_xmit_more());
 
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.sw_err_cnt++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, sw_err_cnt);
 
 		return NETDEV_TX_OK;
 	}
@@ -3522,17 +3484,13 @@ static bool hns3_nic_alloc_rx_buffers(struct hns3_enet_ring *ring,
 	for (i = 0; i < cleand_count; i++) {
 		desc_cb = &ring->desc_cb[ring->next_to_use];
 		if (desc_cb->reuse_flag) {
-			u64_stats_update_begin(&ring->syncp);
-			ring->stats.reuse_pg_cnt++;
-			u64_stats_update_end(&ring->syncp);
+			hns3_ring_stats_update(ring, reuse_pg_cnt);
 
 			hns3_reuse_buffer(ring, ring->next_to_use);
 		} else {
 			ret = hns3_alloc_and_map_buffer(ring, &res_cbs);
 			if (ret) {
-				u64_stats_update_begin(&ring->syncp);
-				ring->stats.sw_err_cnt++;
-				u64_stats_update_end(&ring->syncp);
+				hns3_ring_stats_update(ring, sw_err_cnt);
 
 				hns3_rl_err(ring_to_netdev(ring),
 					    "alloc rx buffer failed: %d\n",
@@ -3544,9 +3502,7 @@ static bool hns3_nic_alloc_rx_buffers(struct hns3_enet_ring *ring,
 			}
 			hns3_replace_buffer(ring, ring->next_to_use, &res_cbs);
 
-			u64_stats_update_begin(&ring->syncp);
-			ring->stats.non_reuse_pg++;
-			u64_stats_update_end(&ring->syncp);
+			hns3_ring_stats_update(ring, non_reuse_pg);
 		}
 
 		ring_ptr_move_fw(ring, next_to_use);
@@ -3573,9 +3529,7 @@ static int hns3_handle_rx_copybreak(struct sk_buff *skb, int i,
 	void *frag = napi_alloc_frag(frag_size);
 
 	if (unlikely(!frag)) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.frag_alloc_err++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, frag_alloc_err);
 
 		hns3_rl_err(ring_to_netdev(ring),
 			    "failed to allocate rx frag\n");
@@ -3587,9 +3541,7 @@ static int hns3_handle_rx_copybreak(struct sk_buff *skb, int i,
 	skb_add_rx_frag(skb, i, virt_to_page(frag),
 			offset_in_page(frag), frag_size, frag_size);
 
-	u64_stats_update_begin(&ring->syncp);
-	ring->stats.frag_alloc++;
-	u64_stats_update_end(&ring->syncp);
+	hns3_ring_stats_update(ring, frag_alloc);
 	return 0;
 }
 
@@ -3722,9 +3674,7 @@ static bool hns3_checksum_complete(struct hns3_enet_ring *ring,
 	    hns3_rx_ptype_tbl[ptype].ip_summed != CHECKSUM_COMPLETE)
 		return false;
 
-	u64_stats_update_begin(&ring->syncp);
-	ring->stats.csum_complete++;
-	u64_stats_update_end(&ring->syncp);
+	hns3_ring_stats_update(ring, csum_complete);
 	skb->ip_summed = CHECKSUM_COMPLETE;
 	skb->csum = csum_unfold((__force __sum16)csum);
 
@@ -3798,9 +3748,7 @@ static void hns3_rx_checksum(struct hns3_enet_ring *ring, struct sk_buff *skb,
 	if (unlikely(l234info & (BIT(HNS3_RXD_L3E_B) | BIT(HNS3_RXD_L4E_B) |
 				 BIT(HNS3_RXD_OL3E_B) |
 				 BIT(HNS3_RXD_OL4E_B)))) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.l3l4_csum_err++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, l3l4_csum_err);
 
 		return;
 	}
@@ -3891,10 +3839,7 @@ static int hns3_alloc_skb(struct hns3_enet_ring *ring, unsigned int length,
 	skb = ring->skb;
 	if (unlikely(!skb)) {
 		hns3_rl_err(netdev, "alloc rx skb fail\n");
-
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.sw_err_cnt++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, sw_err_cnt);
 
 		return -ENOMEM;
 	}
@@ -3925,9 +3870,7 @@ static int hns3_alloc_skb(struct hns3_enet_ring *ring, unsigned int length,
 	if (ring->page_pool)
 		skb_mark_for_recycle(skb);
 
-	u64_stats_update_begin(&ring->syncp);
-	ring->stats.seg_pkt_cnt++;
-	u64_stats_update_end(&ring->syncp);
+	hns3_ring_stats_update(ring, seg_pkt_cnt);
 
 	ring->pull_len = eth_get_headlen(netdev, va, HNS3_RX_HEAD_SIZE);
 	__skb_put(skb, ring->pull_len);
@@ -4119,9 +4062,7 @@ static int hns3_handle_bdinfo(struct hns3_enet_ring *ring, struct sk_buff *skb)
 	ret = hns3_set_gro_and_checksum(ring, skb, l234info,
 					bd_base_info, ol_info, csum);
 	if (unlikely(ret)) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.rx_err_cnt++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, rx_err_cnt);
 		return ret;
 	}
 
@@ -5333,9 +5274,7 @@ static int hns3_clear_rx_ring(struct hns3_enet_ring *ring)
 		if (!ring->desc_cb[ring->next_to_use].reuse_flag) {
 			ret = hns3_alloc_and_map_buffer(ring, &res_cbs);
 			if (ret) {
-				u64_stats_update_begin(&ring->syncp);
-				ring->stats.sw_err_cnt++;
-				u64_stats_update_end(&ring->syncp);
+				hns3_ring_stats_update(ring, sw_err_cnt);
 				/* if alloc new buffer fail, exit directly
 				 * and reclear in up flow.
 				 */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index f09a61d9c626..91b656adaacb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -654,6 +654,13 @@ static inline bool hns3_nic_resetting(struct net_device *netdev)
 
 #define hns3_buf_size(_ring) ((_ring)->buf_size)
 
+#define hns3_ring_stats_update(ring, cnt) do { \
+	typeof(ring) (tmp) = (ring); \
+	u64_stats_update_begin(&(tmp)->syncp); \
+	((tmp)->stats.cnt)++; \
+	u64_stats_update_end(&(tmp)->syncp); \
+} while (0) \
+
 static inline unsigned int hns3_page_order(struct hns3_enet_ring *ring)
 {
 #if (PAGE_SIZE < 8192)
-- 
2.35.1



