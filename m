Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B7C60ACD6
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbiJXOQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235373AbiJXOOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:14:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799795F75;
        Mon, 24 Oct 2022 05:54:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 539BEB8172E;
        Mon, 24 Oct 2022 12:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB3C0C433C1;
        Mon, 24 Oct 2022 12:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615201;
        bh=huePQwevaGT6+HUAOdvqS3WDJkZYWypGr7OZu4Qs4+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2fIG9WRIASR/9hTCSFbMge/INEZdxf+4+OWFI64xERxPlKJRu375ElAim2qQH4ct2
         GhEARVhoxbECpPPlGkT8xM3G0E9s+bhSjHR0scNPRcLI0TmxOGiQLVPbm2PGDPypXM
         fQQOCVmifYdaWZA+oQCpK2lsaCcleWda5cd9yW/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 159/530] xsk: Fix backpressure mechanism on Tx
Date:   Mon, 24 Oct 2022 13:28:23 +0200
Message-Id: <20221024113052.266687883@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit c00c4461689e15ac2cc3b9a595a54e4d8afd3d77 ]

Commit d678cbd2f867 ("xsk: Fix handling of invalid descriptors in XSK TX
batching API") fixed batch API usage against set of descriptors with
invalid ones but introduced a problem when AF_XDP SW rings are smaller
than HW ones. Mismatch of reported Tx'ed frames between HW generator and
user space app was observed. It turned out that backpressure mechanism
became a bottleneck when the amount of produced descriptors to CQ is
lower than what we grabbed from XSK Tx ring.

Say that 512 entries had been taken from XSK Tx ring but we had only 490
free entries in CQ. Then callsite (ZC driver) will produce only 490
entries onto HW Tx ring but 512 entries will be released from Tx ring
and this is what will be seen by the user space.

In order to fix this case, mix XSK Tx/CQ ring interractions by moving
around internal functions and changing call order:

*  pull out xskq_prod_nb_free() from xskq_prod_reserve_addr_batch()
   up to xsk_tx_peek_release_desc_batch();
** move xskq_cons_release_n() into xskq_cons_read_desc_batch()

After doing so, algorithm can be described as follows:

1. lookup Tx entries
2. use value from 1. to reserve space in CQ (*)
3. Read from Tx ring as much descriptors as value from 2
 3a. release descriptors from XSK Tx ring (**)
4. Finally produce addresses to CQ

Fixes: d678cbd2f867 ("xsk: Fix handling of invalid descriptors in XSK TX batching API")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220830121705.8618-1-maciej.fijalkowski@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c       |   22 +++++++++++-----------
 net/xdp/xsk_queue.h |   22 ++++++++++------------
 2 files changed, 21 insertions(+), 23 deletions(-)

--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -370,16 +370,15 @@ static u32 xsk_tx_peek_release_fallback(
 	return nb_pkts;
 }
 
-u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, u32 max_entries)
+u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, u32 nb_pkts)
 {
 	struct xdp_sock *xs;
-	u32 nb_pkts;
 
 	rcu_read_lock();
 	if (!list_is_singular(&pool->xsk_tx_list)) {
 		/* Fallback to the non-batched version */
 		rcu_read_unlock();
-		return xsk_tx_peek_release_fallback(pool, max_entries);
+		return xsk_tx_peek_release_fallback(pool, nb_pkts);
 	}
 
 	xs = list_first_or_null_rcu(&pool->xsk_tx_list, struct xdp_sock, tx_list);
@@ -388,12 +387,7 @@ u32 xsk_tx_peek_release_desc_batch(struc
 		goto out;
 	}
 
-	max_entries = xskq_cons_nb_entries(xs->tx, max_entries);
-	nb_pkts = xskq_cons_read_desc_batch(xs->tx, pool, max_entries);
-	if (!nb_pkts) {
-		xs->tx->queue_empty_descs++;
-		goto out;
-	}
+	nb_pkts = xskq_cons_nb_entries(xs->tx, nb_pkts);
 
 	/* This is the backpressure mechanism for the Tx path. Try to
 	 * reserve space in the completion queue for all packets, but
@@ -401,12 +395,18 @@ u32 xsk_tx_peek_release_desc_batch(struc
 	 * packets. This avoids having to implement any buffering in
 	 * the Tx path.
 	 */
-	nb_pkts = xskq_prod_reserve_addr_batch(pool->cq, pool->tx_descs, nb_pkts);
+	nb_pkts = xskq_prod_nb_free(pool->cq, nb_pkts);
 	if (!nb_pkts)
 		goto out;
 
-	xskq_cons_release_n(xs->tx, max_entries);
+	nb_pkts = xskq_cons_read_desc_batch(xs->tx, pool, nb_pkts);
+	if (!nb_pkts) {
+		xs->tx->queue_empty_descs++;
+		goto out;
+	}
+
 	__xskq_cons_release(xs->tx);
+	xskq_prod_write_addr_batch(pool->cq, pool->tx_descs, nb_pkts);
 	xs->sk.sk_write_space(&xs->sk);
 
 out:
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -201,6 +201,11 @@ static inline bool xskq_cons_read_desc(s
 	return false;
 }
 
+static inline void xskq_cons_release_n(struct xsk_queue *q, u32 cnt)
+{
+	q->cached_cons += cnt;
+}
+
 static inline u32 xskq_cons_read_desc_batch(struct xsk_queue *q, struct xsk_buff_pool *pool,
 					    u32 max)
 {
@@ -222,6 +227,8 @@ static inline u32 xskq_cons_read_desc_ba
 		cached_cons++;
 	}
 
+	/* Release valid plus any invalid entries */
+	xskq_cons_release_n(q, cached_cons - q->cached_cons);
 	return nb_entries;
 }
 
@@ -287,11 +294,6 @@ static inline void xskq_cons_release(str
 	q->cached_cons++;
 }
 
-static inline void xskq_cons_release_n(struct xsk_queue *q, u32 cnt)
-{
-	q->cached_cons += cnt;
-}
-
 static inline bool xskq_cons_is_full(struct xsk_queue *q)
 {
 	/* No barriers needed since data is not accessed */
@@ -353,21 +355,17 @@ static inline int xskq_prod_reserve_addr
 	return 0;
 }
 
-static inline u32 xskq_prod_reserve_addr_batch(struct xsk_queue *q, struct xdp_desc *descs,
-					       u32 max)
+static inline void xskq_prod_write_addr_batch(struct xsk_queue *q, struct xdp_desc *descs,
+					      u32 nb_entries)
 {
 	struct xdp_umem_ring *ring = (struct xdp_umem_ring *)q->ring;
-	u32 nb_entries, i, cached_prod;
-
-	nb_entries = xskq_prod_nb_free(q, max);
+	u32 i, cached_prod;
 
 	/* A, matches D */
 	cached_prod = q->cached_prod;
 	for (i = 0; i < nb_entries; i++)
 		ring->desc[cached_prod++ & q->ring_mask] = descs[i].addr;
 	q->cached_prod = cached_prod;
-
-	return nb_entries;
 }
 
 static inline int xskq_prod_reserve_desc(struct xsk_queue *q,


