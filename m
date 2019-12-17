Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 701A21236B9
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbfLQULO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:11:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:37664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728617AbfLQULN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 15:11:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30FF521775;
        Tue, 17 Dec 2019 20:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576613471;
        bh=7hxZYCbVCGpQglZDgfbFl/gQ761wVQU4XYLHDttoV5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j39sdnXGEHea7chW/HkD66bnFRlXVJIV733xsEaZrwIlqRnEIOjk+C4EA38xv8lFn
         IBZTF2V3Xsidvl4xCX7t76tdJ8yExhURYeEyaYLf4KXLyOPA73PN3Ij5/JSZOeTnKR
         PKHxLZaioomGXA/z5+euNeo1wVBof0B/80HGUcL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 33/37] page_pool: do not release pool until inflight == 0.
Date:   Tue, 17 Dec 2019 21:09:54 +0100
Message-Id: <20191217200734.675740359@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217200721.741054904@linuxfoundation.org>
References: <20191217200721.741054904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Lemon <jonathan.lemon@gmail.com>

[ Upstream commit c3f812cea0d7006469d1cf33a4a9f0a12bb4b3a3 ]

The page pool keeps track of the number of pages in flight, and
it isn't safe to remove the pool until all pages are returned.

Disallow removing the pool until all pages are back, so the pool
is always available for page producers.

Make the page pool responsible for its own delayed destruction
instead of relying on XDP, so the page pool can be used without
the xdp memory model.

When all pages are returned, free the pool and notify xdp if the
pool is registered with the xdp memory system.  Have the callback
perform a table walk since some drivers (cpsw) may share the pool
among multiple xdp_rxq_info.

Note that the increment of pages_state_release_cnt may result in
inflight == 0, resulting in the pool being released.

Fixes: d956a048cd3f ("xdp: force mem allocator removal and periodic warning")
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    4 
 include/net/page_pool.h                           |   52 ++-------
 include/net/xdp_priv.h                            |    4 
 include/trace/events/xdp.h                        |   19 ---
 net/core/page_pool.c                              |  122 +++++++++++++---------
 net/core/xdp.c                                    |  121 +++++++--------------
 6 files changed, 139 insertions(+), 183 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1502,10 +1502,8 @@ static void free_dma_rx_desc_resources(s
 					  rx_q->dma_erx, rx_q->dma_rx_phy);
 
 		kfree(rx_q->buf_pool);
-		if (rx_q->page_pool) {
-			page_pool_request_shutdown(rx_q->page_pool);
+		if (rx_q->page_pool)
 			page_pool_destroy(rx_q->page_pool);
-		}
 	}
 }
 
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -70,7 +70,12 @@ struct page_pool_params {
 struct page_pool {
 	struct page_pool_params p;
 
-        u32 pages_state_hold_cnt;
+	struct delayed_work release_dw;
+	void (*disconnect)(void *);
+	unsigned long defer_start;
+	unsigned long defer_warn;
+
+	u32 pages_state_hold_cnt;
 
 	/*
 	 * Data structure for allocation side
@@ -129,25 +134,19 @@ inline enum dma_data_direction page_pool
 
 struct page_pool *page_pool_create(const struct page_pool_params *params);
 
-void __page_pool_free(struct page_pool *pool);
-static inline void page_pool_free(struct page_pool *pool)
-{
-	/* When page_pool isn't compiled-in, net/core/xdp.c doesn't
-	 * allow registering MEM_TYPE_PAGE_POOL, but shield linker.
-	 */
 #ifdef CONFIG_PAGE_POOL
-	__page_pool_free(pool);
-#endif
-}
-
-/* Drivers use this instead of page_pool_free */
+void page_pool_destroy(struct page_pool *pool);
+void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *));
+#else
 static inline void page_pool_destroy(struct page_pool *pool)
 {
-	if (!pool)
-		return;
+}
 
-	page_pool_free(pool);
+static inline void page_pool_use_xdp_mem(struct page_pool *pool,
+					 void (*disconnect)(void *))
+{
 }
+#endif
 
 /* Never call this directly, use helpers below */
 void __page_pool_put_page(struct page_pool *pool,
@@ -170,24 +169,6 @@ static inline void page_pool_recycle_dir
 	__page_pool_put_page(pool, page, true);
 }
 
-/* API user MUST have disconnected alloc-side (not allowed to call
- * page_pool_alloc_pages()) before calling this.  The free-side can
- * still run concurrently, to handle in-flight packet-pages.
- *
- * A request to shutdown can fail (with false) if there are still
- * in-flight packet-pages.
- */
-bool __page_pool_request_shutdown(struct page_pool *pool);
-static inline bool page_pool_request_shutdown(struct page_pool *pool)
-{
-	bool safe_to_remove = false;
-
-#ifdef CONFIG_PAGE_POOL
-	safe_to_remove = __page_pool_request_shutdown(pool);
-#endif
-	return safe_to_remove;
-}
-
 /* Disconnects a page (from a page_pool).  API users can have a need
  * to disconnect a page (from a page_pool), to allow it to be used as
  * a regular page (that will eventually be returned to the normal
@@ -216,11 +197,6 @@ static inline bool is_page_pool_compiled
 #endif
 }
 
-static inline void page_pool_get(struct page_pool *pool)
-{
-	refcount_inc(&pool->user_cnt);
-}
-
 static inline bool page_pool_put(struct page_pool *pool)
 {
 	return refcount_dec_and_test(&pool->user_cnt);
--- a/include/net/xdp_priv.h
+++ b/include/net/xdp_priv.h
@@ -12,12 +12,8 @@ struct xdp_mem_allocator {
 		struct page_pool *page_pool;
 		struct zero_copy_allocator *zc_alloc;
 	};
-	int disconnect_cnt;
-	unsigned long defer_start;
 	struct rhash_head node;
 	struct rcu_head rcu;
-	struct delayed_work defer_wq;
-	unsigned long defer_warn;
 };
 
 #endif /* __LINUX_NET_XDP_PRIV_H__ */
--- a/include/trace/events/xdp.h
+++ b/include/trace/events/xdp.h
@@ -317,19 +317,15 @@ __MEM_TYPE_MAP(__MEM_TYPE_TP_FN)
 
 TRACE_EVENT(mem_disconnect,
 
-	TP_PROTO(const struct xdp_mem_allocator *xa,
-		 bool safe_to_remove, bool force),
+	TP_PROTO(const struct xdp_mem_allocator *xa),
 
-	TP_ARGS(xa, safe_to_remove, force),
+	TP_ARGS(xa),
 
 	TP_STRUCT__entry(
 		__field(const struct xdp_mem_allocator *,	xa)
 		__field(u32,		mem_id)
 		__field(u32,		mem_type)
 		__field(const void *,	allocator)
-		__field(bool,		safe_to_remove)
-		__field(bool,		force)
-		__field(int,		disconnect_cnt)
 	),
 
 	TP_fast_assign(
@@ -337,19 +333,12 @@ TRACE_EVENT(mem_disconnect,
 		__entry->mem_id		= xa->mem.id;
 		__entry->mem_type	= xa->mem.type;
 		__entry->allocator	= xa->allocator;
-		__entry->safe_to_remove	= safe_to_remove;
-		__entry->force		= force;
-		__entry->disconnect_cnt	= xa->disconnect_cnt;
 	),
 
-	TP_printk("mem_id=%d mem_type=%s allocator=%p"
-		  " safe_to_remove=%s force=%s disconnect_cnt=%d",
+	TP_printk("mem_id=%d mem_type=%s allocator=%p",
 		  __entry->mem_id,
 		  __print_symbolic(__entry->mem_type, __MEM_TYPE_SYM_TAB),
-		  __entry->allocator,
-		  __entry->safe_to_remove ? "true" : "false",
-		  __entry->force ? "true" : "false",
-		  __entry->disconnect_cnt
+		  __entry->allocator
 	)
 );
 
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -18,6 +18,9 @@
 
 #include <trace/events/page_pool.h>
 
+#define DEFER_TIME (msecs_to_jiffies(1000))
+#define DEFER_WARN_INTERVAL (60 * HZ)
+
 static int page_pool_init(struct page_pool *pool,
 			  const struct page_pool_params *params)
 {
@@ -193,22 +196,14 @@ static s32 page_pool_inflight(struct pag
 {
 	u32 release_cnt = atomic_read(&pool->pages_state_release_cnt);
 	u32 hold_cnt = READ_ONCE(pool->pages_state_hold_cnt);
-	s32 distance;
-
-	distance = _distance(hold_cnt, release_cnt);
-
-	trace_page_pool_inflight(pool, distance, hold_cnt, release_cnt);
-	return distance;
-}
+	s32 inflight;
 
-static bool __page_pool_safe_to_destroy(struct page_pool *pool)
-{
-	s32 inflight = page_pool_inflight(pool);
+	inflight = _distance(hold_cnt, release_cnt);
 
-	/* The distance should not be able to become negative */
+	trace_page_pool_inflight(pool, inflight, hold_cnt, release_cnt);
 	WARN(inflight < 0, "Negative(%d) inflight packet-pages", inflight);
 
-	return (inflight == 0);
+	return inflight;
 }
 
 /* Cleanup page_pool state from page */
@@ -216,6 +211,7 @@ static void __page_pool_clean_page(struc
 				   struct page *page)
 {
 	dma_addr_t dma;
+	int count;
 
 	if (!(pool->p.flags & PP_FLAG_DMA_MAP))
 		goto skip_dma_unmap;
@@ -227,9 +223,11 @@ static void __page_pool_clean_page(struc
 			     DMA_ATTR_SKIP_CPU_SYNC);
 	page->dma_addr = 0;
 skip_dma_unmap:
-	atomic_inc(&pool->pages_state_release_cnt);
-	trace_page_pool_state_release(pool, page,
-			      atomic_read(&pool->pages_state_release_cnt));
+	/* This may be the last page returned, releasing the pool, so
+	 * it is not safe to reference pool afterwards.
+	 */
+	count = atomic_inc_return(&pool->pages_state_release_cnt);
+	trace_page_pool_state_release(pool, page, count);
 }
 
 /* unmap the page and clean our state */
@@ -338,31 +336,10 @@ static void __page_pool_empty_ring(struc
 	}
 }
 
-static void __warn_in_flight(struct page_pool *pool)
+static void page_pool_free(struct page_pool *pool)
 {
-	u32 release_cnt = atomic_read(&pool->pages_state_release_cnt);
-	u32 hold_cnt = READ_ONCE(pool->pages_state_hold_cnt);
-	s32 distance;
-
-	distance = _distance(hold_cnt, release_cnt);
-
-	/* Drivers should fix this, but only problematic when DMA is used */
-	WARN(1, "Still in-flight pages:%d hold:%u released:%u",
-	     distance, hold_cnt, release_cnt);
-}
-
-void __page_pool_free(struct page_pool *pool)
-{
-	/* Only last user actually free/release resources */
-	if (!page_pool_put(pool))
-		return;
-
-	WARN(pool->alloc.count, "API usage violation");
-	WARN(!ptr_ring_empty(&pool->ring), "ptr_ring is not empty");
-
-	/* Can happen due to forced shutdown */
-	if (!__page_pool_safe_to_destroy(pool))
-		__warn_in_flight(pool);
+	if (pool->disconnect)
+		pool->disconnect(pool);
 
 	ptr_ring_cleanup(&pool->ring, NULL);
 
@@ -371,12 +348,8 @@ void __page_pool_free(struct page_pool *
 
 	kfree(pool);
 }
-EXPORT_SYMBOL(__page_pool_free);
 
-/* Request to shutdown: release pages cached by page_pool, and check
- * for in-flight pages
- */
-bool __page_pool_request_shutdown(struct page_pool *pool)
+static void page_pool_scrub(struct page_pool *pool)
 {
 	struct page *page;
 
@@ -393,7 +366,64 @@ bool __page_pool_request_shutdown(struct
 	 * be in-flight.
 	 */
 	__page_pool_empty_ring(pool);
+}
+
+static int page_pool_release(struct page_pool *pool)
+{
+	int inflight;
+
+	page_pool_scrub(pool);
+	inflight = page_pool_inflight(pool);
+	if (!inflight)
+		page_pool_free(pool);
+
+	return inflight;
+}
+
+static void page_pool_release_retry(struct work_struct *wq)
+{
+	struct delayed_work *dwq = to_delayed_work(wq);
+	struct page_pool *pool = container_of(dwq, typeof(*pool), release_dw);
+	int inflight;
+
+	inflight = page_pool_release(pool);
+	if (!inflight)
+		return;
+
+	/* Periodic warning */
+	if (time_after_eq(jiffies, pool->defer_warn)) {
+		int sec = (s32)((u32)jiffies - (u32)pool->defer_start) / HZ;
+
+		pr_warn("%s() stalled pool shutdown %d inflight %d sec\n",
+			__func__, inflight, sec);
+		pool->defer_warn = jiffies + DEFER_WARN_INTERVAL;
+	}
+
+	/* Still not ready to be disconnected, retry later */
+	schedule_delayed_work(&pool->release_dw, DEFER_TIME);
+}
+
+void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *))
+{
+	refcount_inc(&pool->user_cnt);
+	pool->disconnect = disconnect;
+}
+
+void page_pool_destroy(struct page_pool *pool)
+{
+	if (!pool)
+		return;
+
+	if (!page_pool_put(pool))
+		return;
+
+	if (!page_pool_release(pool))
+		return;
+
+	pool->defer_start = jiffies;
+	pool->defer_warn  = jiffies + DEFER_WARN_INTERVAL;
 
-	return __page_pool_safe_to_destroy(pool);
+	INIT_DELAYED_WORK(&pool->release_dw, page_pool_release_retry);
+	schedule_delayed_work(&pool->release_dw, DEFER_TIME);
 }
-EXPORT_SYMBOL(__page_pool_request_shutdown);
+EXPORT_SYMBOL(page_pool_destroy);
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -70,10 +70,6 @@ static void __xdp_mem_allocator_rcu_free
 
 	xa = container_of(rcu, struct xdp_mem_allocator, rcu);
 
-	/* Allocator have indicated safe to remove before this is called */
-	if (xa->mem.type == MEM_TYPE_PAGE_POOL)
-		page_pool_free(xa->page_pool);
-
 	/* Allow this ID to be reused */
 	ida_simple_remove(&mem_id_pool, xa->mem.id);
 
@@ -85,62 +81,57 @@ static void __xdp_mem_allocator_rcu_free
 	kfree(xa);
 }
 
-static bool __mem_id_disconnect(int id, bool force)
+static void mem_xa_remove(struct xdp_mem_allocator *xa)
 {
-	struct xdp_mem_allocator *xa;
-	bool safe_to_remove = true;
+	trace_mem_disconnect(xa);
 
 	mutex_lock(&mem_id_lock);
 
-	xa = rhashtable_lookup_fast(mem_id_ht, &id, mem_id_rht_params);
-	if (!xa) {
-		mutex_unlock(&mem_id_lock);
-		WARN(1, "Request remove non-existing id(%d), driver bug?", id);
-		return true;
-	}
-	xa->disconnect_cnt++;
-
-	/* Detects in-flight packet-pages for page_pool */
-	if (xa->mem.type == MEM_TYPE_PAGE_POOL)
-		safe_to_remove = page_pool_request_shutdown(xa->page_pool);
-
-	trace_mem_disconnect(xa, safe_to_remove, force);
-
-	if ((safe_to_remove || force) &&
-	    !rhashtable_remove_fast(mem_id_ht, &xa->node, mem_id_rht_params))
+	if (!rhashtable_remove_fast(mem_id_ht, &xa->node, mem_id_rht_params))
 		call_rcu(&xa->rcu, __xdp_mem_allocator_rcu_free);
 
 	mutex_unlock(&mem_id_lock);
-	return (safe_to_remove|force);
 }
 
-#define DEFER_TIME (msecs_to_jiffies(1000))
-#define DEFER_WARN_INTERVAL (30 * HZ)
-#define DEFER_MAX_RETRIES 120
+static void mem_allocator_disconnect(void *allocator)
+{
+	struct xdp_mem_allocator *xa;
+	struct rhashtable_iter iter;
+
+	rhashtable_walk_enter(mem_id_ht, &iter);
+	do {
+		rhashtable_walk_start(&iter);
+
+		while ((xa = rhashtable_walk_next(&iter)) && !IS_ERR(xa)) {
+			if (xa->allocator == allocator)
+				mem_xa_remove(xa);
+		}
+
+		rhashtable_walk_stop(&iter);
+
+	} while (xa == ERR_PTR(-EAGAIN));
+	rhashtable_walk_exit(&iter);
+}
 
-static void mem_id_disconnect_defer_retry(struct work_struct *wq)
+static void mem_id_disconnect(int id)
 {
-	struct delayed_work *dwq = to_delayed_work(wq);
-	struct xdp_mem_allocator *xa = container_of(dwq, typeof(*xa), defer_wq);
-	bool force = false;
+	struct xdp_mem_allocator *xa;
 
-	if (xa->disconnect_cnt > DEFER_MAX_RETRIES)
-		force = true;
+	mutex_lock(&mem_id_lock);
 
-	if (__mem_id_disconnect(xa->mem.id, force))
+	xa = rhashtable_lookup_fast(mem_id_ht, &id, mem_id_rht_params);
+	if (!xa) {
+		mutex_unlock(&mem_id_lock);
+		WARN(1, "Request remove non-existing id(%d), driver bug?", id);
 		return;
+	}
 
-	/* Periodic warning */
-	if (time_after_eq(jiffies, xa->defer_warn)) {
-		int sec = (s32)((u32)jiffies - (u32)xa->defer_start) / HZ;
+	trace_mem_disconnect(xa);
 
-		pr_warn("%s() stalled mem.id=%u shutdown %d attempts %d sec\n",
-			__func__, xa->mem.id, xa->disconnect_cnt, sec);
-		xa->defer_warn = jiffies + DEFER_WARN_INTERVAL;
-	}
+	if (!rhashtable_remove_fast(mem_id_ht, &xa->node, mem_id_rht_params))
+		call_rcu(&xa->rcu, __xdp_mem_allocator_rcu_free);
 
-	/* Still not ready to be disconnected, retry later */
-	schedule_delayed_work(&xa->defer_wq, DEFER_TIME);
+	mutex_unlock(&mem_id_lock);
 }
 
 void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
@@ -153,38 +144,21 @@ void xdp_rxq_info_unreg_mem_model(struct
 		return;
 	}
 
-	if (xdp_rxq->mem.type != MEM_TYPE_PAGE_POOL &&
-	    xdp_rxq->mem.type != MEM_TYPE_ZERO_COPY) {
-		return;
-	}
-
 	if (id == 0)
 		return;
 
-	if (__mem_id_disconnect(id, false))
-		return;
-
-	/* Could not disconnect, defer new disconnect attempt to later */
-	mutex_lock(&mem_id_lock);
+	if (xdp_rxq->mem.type == MEM_TYPE_ZERO_COPY)
+		return mem_id_disconnect(id);
 
-	xa = rhashtable_lookup_fast(mem_id_ht, &id, mem_id_rht_params);
-	if (!xa) {
-		mutex_unlock(&mem_id_lock);
-		return;
+	if (xdp_rxq->mem.type == MEM_TYPE_PAGE_POOL) {
+		rcu_read_lock();
+		xa = rhashtable_lookup(mem_id_ht, &id, mem_id_rht_params);
+		page_pool_destroy(xa->page_pool);
+		rcu_read_unlock();
 	}
-	xa->defer_start = jiffies;
-	xa->defer_warn  = jiffies + DEFER_WARN_INTERVAL;
-
-	INIT_DELAYED_WORK(&xa->defer_wq, mem_id_disconnect_defer_retry);
-	mutex_unlock(&mem_id_lock);
-	schedule_delayed_work(&xa->defer_wq, DEFER_TIME);
 }
 EXPORT_SYMBOL_GPL(xdp_rxq_info_unreg_mem_model);
 
-/* This unregister operation will also cleanup and destroy the
- * allocator. The page_pool_free() operation is first called when it's
- * safe to remove, possibly deferred to a workqueue.
- */
 void xdp_rxq_info_unreg(struct xdp_rxq_info *xdp_rxq)
 {
 	/* Simplify driver cleanup code paths, allow unreg "unused" */
@@ -371,7 +345,7 @@ int xdp_rxq_info_reg_mem_model(struct xd
 	}
 
 	if (type == MEM_TYPE_PAGE_POOL)
-		page_pool_get(xdp_alloc->page_pool);
+		page_pool_use_xdp_mem(allocator, mem_allocator_disconnect);
 
 	mutex_unlock(&mem_id_lock);
 
@@ -402,15 +376,8 @@ static void __xdp_return(void *data, str
 		/* mem->id is valid, checked in xdp_rxq_info_reg_mem_model() */
 		xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
 		page = virt_to_head_page(data);
-		if (likely(xa)) {
-			napi_direct &= !xdp_return_frame_no_direct();
-			page_pool_put_page(xa->page_pool, page, napi_direct);
-		} else {
-			/* Hopefully stack show who to blame for late return */
-			WARN_ONCE(1, "page_pool gone mem.id=%d", mem->id);
-			trace_mem_return_failed(mem, page);
-			put_page(page);
-		}
+		napi_direct &= !xdp_return_frame_no_direct();
+		page_pool_put_page(xa->page_pool, page, napi_direct);
 		rcu_read_unlock();
 		break;
 	case MEM_TYPE_PAGE_SHARED:


