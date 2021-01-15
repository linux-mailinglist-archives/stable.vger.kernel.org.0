Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07BEF2F79DA
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387854AbhAOMl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:41:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:47474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387768AbhAOMjv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:39:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A6F3221F7;
        Fri, 15 Jan 2021 12:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714350;
        bh=pWjCMLjv2pYMZd6+kQNtsltVjadB5Tcw2kPDVAdAfdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sld7KQEVcUZqGb8TlxchgZk37ruffze8MtpcVfbzypjL2SCZ/xxEQbWq3u6IhfMiQ
         aryGezSo/hP/jJYwNQluSN6YlImFJp+YliQd7pyOjdwkbqdyXLqNHAeMsGMxDGgJo1
         lwZKVi7fnlOoMQyO2fxwFCIPZt2aOP+bcDrE5w1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>
Subject: [PATCH 5.10 095/103] xsk: Fix race in SKB mode transmit with shared cq
Date:   Fri, 15 Jan 2021 13:28:28 +0100
Message-Id: <20210115122010.601877170@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

commit f09ced4053bc0a2094a12b60b646114c966ef4c6 upstream.

Fix a race when multiple sockets are simultaneously calling sendto()
when the completion ring is shared in the SKB case. This is the case
when you share the same netdev and queue id through the
XDP_SHARED_UMEM bind flag. The problem is that multiple processes can
be in xsk_generic_xmit() and call the backpressure mechanism in
xskq_prod_reserve(xs->pool->cq). As this is a shared resource in this
specific scenario, a race might occur since the rings are
single-producer single-consumer.

Fix this by moving the tx_completion_lock from the socket to the pool
as the pool is shared between the sockets that share the completion
ring. (The pool is not shared when this is not the case.) And then
protect the accesses to xskq_prod_reserve() with this lock. The
tx_completion_lock is renamed cq_lock to better reflect that it
protects accesses to the potentially shared completion ring.

Fixes: 35fcde7f8deb ("xsk: support for Tx")
Reported-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Link: https://lore.kernel.org/bpf/20201218134525.13119-2-magnus.karlsson@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/xdp_sock.h      |    4 ----
 include/net/xsk_buff_pool.h |    5 +++++
 net/xdp/xsk.c               |    9 ++++++---
 net/xdp/xsk_buff_pool.c     |    1 +
 4 files changed, 12 insertions(+), 7 deletions(-)

--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -58,10 +58,6 @@ struct xdp_sock {
 
 	struct xsk_queue *tx ____cacheline_aligned_in_smp;
 	struct list_head tx_list;
-	/* Mutual exclusion of NAPI TX thread and sendmsg error paths
-	 * in the SKB destructor callback.
-	 */
-	spinlock_t tx_completion_lock;
 	/* Protects generic receive. */
 	spinlock_t rx_lock;
 
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -73,6 +73,11 @@ struct xsk_buff_pool {
 	bool dma_need_sync;
 	bool unaligned;
 	void *addrs;
+	/* Mutual exclusion of the completion ring in the SKB mode. Two cases to protect:
+	 * NAPI TX thread and sendmsg error paths in the SKB destructor callback and when
+	 * sockets share a single cq when the same netdev and queue id is shared.
+	 */
+	spinlock_t cq_lock;
 	struct xdp_buff_xsk *free_heads[];
 };
 
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -364,9 +364,9 @@ static void xsk_destruct_skb(struct sk_b
 	struct xdp_sock *xs = xdp_sk(skb->sk);
 	unsigned long flags;
 
-	spin_lock_irqsave(&xs->tx_completion_lock, flags);
+	spin_lock_irqsave(&xs->pool->cq_lock, flags);
 	xskq_prod_submit_addr(xs->pool->cq, addr);
-	spin_unlock_irqrestore(&xs->tx_completion_lock, flags);
+	spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
 
 	sock_wfree(skb);
 }
@@ -378,6 +378,7 @@ static int xsk_generic_xmit(struct sock
 	bool sent_frame = false;
 	struct xdp_desc desc;
 	struct sk_buff *skb;
+	unsigned long flags;
 	int err = 0;
 
 	mutex_lock(&xs->mutex);
@@ -409,10 +410,13 @@ static int xsk_generic_xmit(struct sock
 		 * if there is space in it. This avoids having to implement
 		 * any buffering in the Tx path.
 		 */
+		spin_lock_irqsave(&xs->pool->cq_lock, flags);
 		if (unlikely(err) || xskq_prod_reserve(xs->pool->cq)) {
+			spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
 			kfree_skb(skb);
 			goto out;
 		}
+		spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
 
 		skb->dev = xs->dev;
 		skb->priority = sk->sk_priority;
@@ -1197,7 +1201,6 @@ static int xsk_create(struct net *net, s
 	xs->state = XSK_READY;
 	mutex_init(&xs->mutex);
 	spin_lock_init(&xs->rx_lock);
-	spin_lock_init(&xs->tx_completion_lock);
 
 	INIT_LIST_HEAD(&xs->map_list);
 	spin_lock_init(&xs->map_list_lock);
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -71,6 +71,7 @@ struct xsk_buff_pool *xp_create_and_assi
 	INIT_LIST_HEAD(&pool->free_list);
 	INIT_LIST_HEAD(&pool->xsk_tx_list);
 	spin_lock_init(&pool->xsk_tx_list_lock);
+	spin_lock_init(&pool->cq_lock);
 	refcount_set(&pool->users, 1);
 
 	pool->fq = xs->fq_tmp;


