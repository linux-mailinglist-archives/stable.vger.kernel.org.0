Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8B554877F
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359414AbiFMNNP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356818AbiFMNHQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:07:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725F5381AC;
        Mon, 13 Jun 2022 04:18:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA18BB80EB5;
        Mon, 13 Jun 2022 11:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3F9C34114;
        Mon, 13 Jun 2022 11:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119119;
        bh=jjF5BlJcjAdBNuIar7WPoSR0eZDXG4Aryqf7Q2K4tp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IN8SfzintNo4V4Ejiet0P/OOdInA800049TG8+jCZzKAmQJgVVZW9CMSkD5+jAkiT
         wqFhlBXyU2MEIrBIJp+tV9NBjdRjnfWvk2By+lcKyu8wdI+o1gpcaZFYVCoq+tTDa+
         ohC0F4vuqiPkjSr9g/LXr6nfVUTdgJ1uwPoiB37k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 148/247] i40e: xsk: Move tmp desc array from driver to pool
Date:   Mon, 13 Jun 2022 12:10:50 +0200
Message-Id: <20220613094927.444165605@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit d1bc532e99becf104635ed4da6fefa306f452321 ]

Move desc_array from the driver to the pool. The reason behind this is
that we can then reuse this array as a temporary storage for descriptors
in all zero-copy drivers that use the batched interface. This will make
it easier to add batching to more drivers.

i40e is the only driver that has a batched Tx zero-copy
implementation, so no need to touch any other driver.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Link: https://lore.kernel.org/bpf/20220125160446.78976-6-maciej.fijalkowski@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 11 -----------
 drivers/net/ethernet/intel/i40e/i40e_txrx.h |  1 -
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  |  4 ++--
 include/net/xdp_sock_drv.h                  |  5 ++---
 include/net/xsk_buff_pool.h                 |  1 +
 net/xdp/xsk.c                               | 13 ++++++-------
 net/xdp/xsk_buff_pool.c                     |  7 +++++++
 net/xdp/xsk_queue.h                         | 12 ++++++------
 8 files changed, 24 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 10a83e5385c7..d3a4a33977ee 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -830,8 +830,6 @@ void i40e_free_tx_resources(struct i40e_ring *tx_ring)
 	i40e_clean_tx_ring(tx_ring);
 	kfree(tx_ring->tx_bi);
 	tx_ring->tx_bi = NULL;
-	kfree(tx_ring->xsk_descs);
-	tx_ring->xsk_descs = NULL;
 
 	if (tx_ring->desc) {
 		dma_free_coherent(tx_ring->dev, tx_ring->size,
@@ -1433,13 +1431,6 @@ int i40e_setup_tx_descriptors(struct i40e_ring *tx_ring)
 	if (!tx_ring->tx_bi)
 		goto err;
 
-	if (ring_is_xdp(tx_ring)) {
-		tx_ring->xsk_descs = kcalloc(I40E_MAX_NUM_DESCRIPTORS, sizeof(*tx_ring->xsk_descs),
-					     GFP_KERNEL);
-		if (!tx_ring->xsk_descs)
-			goto err;
-	}
-
 	u64_stats_init(&tx_ring->syncp);
 
 	/* round up to nearest 4K */
@@ -1463,8 +1454,6 @@ int i40e_setup_tx_descriptors(struct i40e_ring *tx_ring)
 	return 0;
 
 err:
-	kfree(tx_ring->xsk_descs);
-	tx_ring->xsk_descs = NULL;
 	kfree(tx_ring->tx_bi);
 	tx_ring->tx_bi = NULL;
 	return -ENOMEM;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index bfc2845c99d1..f6d91fa1562e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -390,7 +390,6 @@ struct i40e_ring {
 	u16 rx_offset;
 	struct xdp_rxq_info xdp_rxq;
 	struct xsk_buff_pool *xsk_pool;
-	struct xdp_desc *xsk_descs;      /* For storing descriptors in the AF_XDP ZC path */
 } ____cacheline_internodealigned_in_smp;
 
 static inline bool ring_uses_build_skb(struct i40e_ring *ring)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 3f27a8ebe2ec..54c91dc459dd 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -473,11 +473,11 @@ static void i40e_set_rs_bit(struct i40e_ring *xdp_ring)
  **/
 static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 {
-	struct xdp_desc *descs = xdp_ring->xsk_descs;
+	struct xdp_desc *descs = xdp_ring->xsk_pool->tx_descs;
 	u32 nb_pkts, nb_processed = 0;
 	unsigned int total_bytes = 0;
 
-	nb_pkts = xsk_tx_peek_release_desc_batch(xdp_ring->xsk_pool, descs, budget);
+	nb_pkts = xsk_tx_peek_release_desc_batch(xdp_ring->xsk_pool, budget);
 	if (!nb_pkts)
 		return true;
 
diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 4e295541e396..ffe13a10bc96 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -13,7 +13,7 @@
 
 void xsk_tx_completed(struct xsk_buff_pool *pool, u32 nb_entries);
 bool xsk_tx_peek_desc(struct xsk_buff_pool *pool, struct xdp_desc *desc);
-u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *desc, u32 max);
+u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, u32 max);
 void xsk_tx_release(struct xsk_buff_pool *pool);
 struct xsk_buff_pool *xsk_get_pool_from_qid(struct net_device *dev,
 					    u16 queue_id);
@@ -129,8 +129,7 @@ static inline bool xsk_tx_peek_desc(struct xsk_buff_pool *pool,
 	return false;
 }
 
-static inline u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *desc,
-						 u32 max)
+static inline u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, u32 max)
 {
 	return 0;
 }
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 7a9a23e7a604..ee152f031d0c 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -60,6 +60,7 @@ struct xsk_buff_pool {
 	 */
 	dma_addr_t *dma_pages;
 	struct xdp_buff_xsk *heads;
+	struct xdp_desc *tx_descs;
 	u64 chunk_mask;
 	u64 addrs_cnt;
 	u32 free_list_cnt;
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 444ad0bc0908..404cbfde2f84 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -358,9 +358,9 @@ bool xsk_tx_peek_desc(struct xsk_buff_pool *pool, struct xdp_desc *desc)
 }
 EXPORT_SYMBOL(xsk_tx_peek_desc);
 
-static u32 xsk_tx_peek_release_fallback(struct xsk_buff_pool *pool, struct xdp_desc *descs,
-					u32 max_entries)
+static u32 xsk_tx_peek_release_fallback(struct xsk_buff_pool *pool, u32 max_entries)
 {
+	struct xdp_desc *descs = pool->tx_descs;
 	u32 nb_pkts = 0;
 
 	while (nb_pkts < max_entries && xsk_tx_peek_desc(pool, &descs[nb_pkts]))
@@ -370,8 +370,7 @@ static u32 xsk_tx_peek_release_fallback(struct xsk_buff_pool *pool, struct xdp_d
 	return nb_pkts;
 }
 
-u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *descs,
-				   u32 max_entries)
+u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, u32 max_entries)
 {
 	struct xdp_sock *xs;
 	u32 nb_pkts;
@@ -380,7 +379,7 @@ u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *
 	if (!list_is_singular(&pool->xsk_tx_list)) {
 		/* Fallback to the non-batched version */
 		rcu_read_unlock();
-		return xsk_tx_peek_release_fallback(pool, descs, max_entries);
+		return xsk_tx_peek_release_fallback(pool, max_entries);
 	}
 
 	xs = list_first_or_null_rcu(&pool->xsk_tx_list, struct xdp_sock, tx_list);
@@ -389,7 +388,7 @@ u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *
 		goto out;
 	}
 
-	nb_pkts = xskq_cons_peek_desc_batch(xs->tx, descs, pool, max_entries);
+	nb_pkts = xskq_cons_peek_desc_batch(xs->tx, pool, max_entries);
 	if (!nb_pkts) {
 		xs->tx->queue_empty_descs++;
 		goto out;
@@ -401,7 +400,7 @@ u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *
 	 * packets. This avoids having to implement any buffering in
 	 * the Tx path.
 	 */
-	nb_pkts = xskq_prod_reserve_addr_batch(pool->cq, descs, nb_pkts);
+	nb_pkts = xskq_prod_reserve_addr_batch(pool->cq, pool->tx_descs, nb_pkts);
 	if (!nb_pkts)
 		goto out;
 
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 8de01aaac4a0..23fbef4aef74 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -37,6 +37,7 @@ void xp_destroy(struct xsk_buff_pool *pool)
 	if (!pool)
 		return;
 
+	kvfree(pool->tx_descs);
 	kvfree(pool->heads);
 	kvfree(pool);
 }
@@ -57,6 +58,12 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 	if (!pool->heads)
 		goto out;
 
+	if (xs->tx) {
+		pool->tx_descs = kcalloc(xs->tx->nentries, sizeof(*pool->tx_descs), GFP_KERNEL);
+		if (!pool->tx_descs)
+			goto out;
+	}
+
 	pool->chunk_mask = ~((u64)umem->chunk_size - 1);
 	pool->addrs_cnt = umem->size;
 	pool->heads_cnt = umem->chunks;
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 9ae13cccfb28..b721795fe50c 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -201,11 +201,11 @@ static inline bool xskq_cons_read_desc(struct xsk_queue *q,
 	return false;
 }
 
-static inline u32 xskq_cons_read_desc_batch(struct xsk_queue *q,
-					    struct xdp_desc *descs,
-					    struct xsk_buff_pool *pool, u32 max)
+static inline u32 xskq_cons_read_desc_batch(struct xsk_queue *q, struct xsk_buff_pool *pool,
+					    u32 max)
 {
 	u32 cached_cons = q->cached_cons, nb_entries = 0;
+	struct xdp_desc *descs = pool->tx_descs;
 
 	while (cached_cons != q->cached_prod && nb_entries < max) {
 		struct xdp_rxtx_ring *ring = (struct xdp_rxtx_ring *)q->ring;
@@ -278,12 +278,12 @@ static inline bool xskq_cons_peek_desc(struct xsk_queue *q,
 	return xskq_cons_read_desc(q, desc, pool);
 }
 
-static inline u32 xskq_cons_peek_desc_batch(struct xsk_queue *q, struct xdp_desc *descs,
-					    struct xsk_buff_pool *pool, u32 max)
+static inline u32 xskq_cons_peek_desc_batch(struct xsk_queue *q, struct xsk_buff_pool *pool,
+					    u32 max)
 {
 	u32 entries = xskq_cons_nb_entries(q, max);
 
-	return xskq_cons_read_desc_batch(q, descs, pool, entries);
+	return xskq_cons_read_desc_batch(q, pool, entries);
 }
 
 /* To improve performance in the xskq_cons_release functions, only update local state here.
-- 
2.35.1



