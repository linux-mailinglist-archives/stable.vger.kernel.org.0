Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD862D9EE5
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440743AbgLNSXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:23:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:46228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502326AbgLNRiO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:38:14 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovksy@oracle.com>
Subject: [PATCH 5.9 081/105] xen: add helpers for caching grant mapping pages
Date:   Mon, 14 Dec 2020 18:28:55 +0100
Message-Id: <20201214172559.171088903@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit ca33479cc7be2c9b5f8be078c8bf3ac26b7d6186 upstream.

Instead of having similar helpers in multiple backend drivers use
common helpers for caching pages allocated via gnttab_alloc_pages().

Make use of those helpers in blkback and scsiback.

Cc: <stable@vger.kernel.org> # 5.9
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovksy@oracle.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/xen-blkback/blkback.c |   89 ++++++------------------------------
 drivers/block/xen-blkback/common.h  |    4 -
 drivers/block/xen-blkback/xenbus.c  |    6 --
 drivers/xen/grant-table.c           |   72 +++++++++++++++++++++++++++++
 drivers/xen/xen-scsiback.c          |   60 ++++--------------------
 include/xen/grant_table.h           |   13 +++++
 6 files changed, 116 insertions(+), 128 deletions(-)

--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -132,73 +132,12 @@ module_param(log_stats, int, 0644);
 
 #define BLKBACK_INVALID_HANDLE (~0)
 
-/* Number of free pages to remove on each call to gnttab_free_pages */
-#define NUM_BATCH_FREE_PAGES 10
-
 static inline bool persistent_gnt_timeout(struct persistent_gnt *persistent_gnt)
 {
 	return pgrant_timeout && (jiffies - persistent_gnt->last_used >=
 			HZ * pgrant_timeout);
 }
 
-static inline int get_free_page(struct xen_blkif_ring *ring, struct page **page)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&ring->free_pages_lock, flags);
-	if (list_empty(&ring->free_pages)) {
-		BUG_ON(ring->free_pages_num != 0);
-		spin_unlock_irqrestore(&ring->free_pages_lock, flags);
-		return gnttab_alloc_pages(1, page);
-	}
-	BUG_ON(ring->free_pages_num == 0);
-	page[0] = list_first_entry(&ring->free_pages, struct page, lru);
-	list_del(&page[0]->lru);
-	ring->free_pages_num--;
-	spin_unlock_irqrestore(&ring->free_pages_lock, flags);
-
-	return 0;
-}
-
-static inline void put_free_pages(struct xen_blkif_ring *ring, struct page **page,
-                                  int num)
-{
-	unsigned long flags;
-	int i;
-
-	spin_lock_irqsave(&ring->free_pages_lock, flags);
-	for (i = 0; i < num; i++)
-		list_add(&page[i]->lru, &ring->free_pages);
-	ring->free_pages_num += num;
-	spin_unlock_irqrestore(&ring->free_pages_lock, flags);
-}
-
-static inline void shrink_free_pagepool(struct xen_blkif_ring *ring, int num)
-{
-	/* Remove requested pages in batches of NUM_BATCH_FREE_PAGES */
-	struct page *page[NUM_BATCH_FREE_PAGES];
-	unsigned int num_pages = 0;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ring->free_pages_lock, flags);
-	while (ring->free_pages_num > num) {
-		BUG_ON(list_empty(&ring->free_pages));
-		page[num_pages] = list_first_entry(&ring->free_pages,
-		                                   struct page, lru);
-		list_del(&page[num_pages]->lru);
-		ring->free_pages_num--;
-		if (++num_pages == NUM_BATCH_FREE_PAGES) {
-			spin_unlock_irqrestore(&ring->free_pages_lock, flags);
-			gnttab_free_pages(num_pages, page);
-			spin_lock_irqsave(&ring->free_pages_lock, flags);
-			num_pages = 0;
-		}
-	}
-	spin_unlock_irqrestore(&ring->free_pages_lock, flags);
-	if (num_pages != 0)
-		gnttab_free_pages(num_pages, page);
-}
-
 #define vaddr(page) ((unsigned long)pfn_to_kaddr(page_to_pfn(page)))
 
 static int do_block_io_op(struct xen_blkif_ring *ring, unsigned int *eoi_flags);
@@ -331,7 +270,8 @@ static void free_persistent_gnts(struct
 			unmap_data.count = segs_to_unmap;
 			BUG_ON(gnttab_unmap_refs_sync(&unmap_data));
 
-			put_free_pages(ring, pages, segs_to_unmap);
+			gnttab_page_cache_put(&ring->free_pages, pages,
+					      segs_to_unmap);
 			segs_to_unmap = 0;
 		}
 
@@ -371,7 +311,8 @@ void xen_blkbk_unmap_purged_grants(struc
 		if (++segs_to_unmap == BLKIF_MAX_SEGMENTS_PER_REQUEST) {
 			unmap_data.count = segs_to_unmap;
 			BUG_ON(gnttab_unmap_refs_sync(&unmap_data));
-			put_free_pages(ring, pages, segs_to_unmap);
+			gnttab_page_cache_put(&ring->free_pages, pages,
+					      segs_to_unmap);
 			segs_to_unmap = 0;
 		}
 		kfree(persistent_gnt);
@@ -379,7 +320,7 @@ void xen_blkbk_unmap_purged_grants(struc
 	if (segs_to_unmap > 0) {
 		unmap_data.count = segs_to_unmap;
 		BUG_ON(gnttab_unmap_refs_sync(&unmap_data));
-		put_free_pages(ring, pages, segs_to_unmap);
+		gnttab_page_cache_put(&ring->free_pages, pages, segs_to_unmap);
 	}
 }
 
@@ -664,9 +605,10 @@ purge_gnt_list:
 
 		/* Shrink the free pages pool if it is too large. */
 		if (time_before(jiffies, blkif->buffer_squeeze_end))
-			shrink_free_pagepool(ring, 0);
+			gnttab_page_cache_shrink(&ring->free_pages, 0);
 		else
-			shrink_free_pagepool(ring, max_buffer_pages);
+			gnttab_page_cache_shrink(&ring->free_pages,
+						 max_buffer_pages);
 
 		if (log_stats && time_after(jiffies, ring->st_print))
 			print_stats(ring);
@@ -697,7 +639,7 @@ void xen_blkbk_free_caches(struct xen_bl
 	ring->persistent_gnt_c = 0;
 
 	/* Since we are shutting down remove all pages from the buffer */
-	shrink_free_pagepool(ring, 0 /* All */);
+	gnttab_page_cache_shrink(&ring->free_pages, 0 /* All */);
 }
 
 static unsigned int xen_blkbk_unmap_prepare(
@@ -736,7 +678,7 @@ static void xen_blkbk_unmap_and_respond_
 	   but is this the best way to deal with this? */
 	BUG_ON(result);
 
-	put_free_pages(ring, data->pages, data->count);
+	gnttab_page_cache_put(&ring->free_pages, data->pages, data->count);
 	make_response(ring, pending_req->id,
 		      pending_req->operation, pending_req->status);
 	free_req(ring, pending_req);
@@ -803,7 +745,8 @@ static void xen_blkbk_unmap(struct xen_b
 		if (invcount) {
 			ret = gnttab_unmap_refs(unmap, NULL, unmap_pages, invcount);
 			BUG_ON(ret);
-			put_free_pages(ring, unmap_pages, invcount);
+			gnttab_page_cache_put(&ring->free_pages, unmap_pages,
+					      invcount);
 		}
 		pages += batch;
 		num -= batch;
@@ -850,7 +793,8 @@ again:
 			pages[i]->page = persistent_gnt->page;
 			pages[i]->persistent_gnt = persistent_gnt;
 		} else {
-			if (get_free_page(ring, &pages[i]->page))
+			if (gnttab_page_cache_get(&ring->free_pages,
+						  &pages[i]->page))
 				goto out_of_memory;
 			addr = vaddr(pages[i]->page);
 			pages_to_gnt[segs_to_map] = pages[i]->page;
@@ -883,7 +827,8 @@ again:
 			BUG_ON(new_map_idx >= segs_to_map);
 			if (unlikely(map[new_map_idx].status != 0)) {
 				pr_debug("invalid buffer -- could not remap it\n");
-				put_free_pages(ring, &pages[seg_idx]->page, 1);
+				gnttab_page_cache_put(&ring->free_pages,
+						      &pages[seg_idx]->page, 1);
 				pages[seg_idx]->handle = BLKBACK_INVALID_HANDLE;
 				ret |= 1;
 				goto next;
@@ -944,7 +889,7 @@ next:
 
 out_of_memory:
 	pr_alert("%s: out of memory\n", __func__);
-	put_free_pages(ring, pages_to_gnt, segs_to_map);
+	gnttab_page_cache_put(&ring->free_pages, pages_to_gnt, segs_to_map);
 	for (i = last_map; i < num; i++)
 		pages[i]->handle = BLKBACK_INVALID_HANDLE;
 	return -ENOMEM;
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -288,9 +288,7 @@ struct xen_blkif_ring {
 	struct work_struct	persistent_purge_work;
 
 	/* Buffer of free pages to map grant refs. */
-	spinlock_t		free_pages_lock;
-	int			free_pages_num;
-	struct list_head	free_pages;
+	struct gnttab_page_cache free_pages;
 
 	struct work_struct	free_work;
 	/* Thread shutdown wait queue. */
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -144,8 +144,7 @@ static int xen_blkif_alloc_rings(struct
 		INIT_LIST_HEAD(&ring->pending_free);
 		INIT_LIST_HEAD(&ring->persistent_purge_list);
 		INIT_WORK(&ring->persistent_purge_work, xen_blkbk_unmap_purged_grants);
-		spin_lock_init(&ring->free_pages_lock);
-		INIT_LIST_HEAD(&ring->free_pages);
+		gnttab_page_cache_init(&ring->free_pages);
 
 		spin_lock_init(&ring->pending_free_lock);
 		init_waitqueue_head(&ring->pending_free_wq);
@@ -317,8 +316,7 @@ static int xen_blkif_disconnect(struct x
 		BUG_ON(atomic_read(&ring->persistent_gnt_in_use) != 0);
 		BUG_ON(!list_empty(&ring->persistent_purge_list));
 		BUG_ON(!RB_EMPTY_ROOT(&ring->persistent_gnts));
-		BUG_ON(!list_empty(&ring->free_pages));
-		BUG_ON(ring->free_pages_num != 0);
+		BUG_ON(ring->free_pages.num_pages != 0);
 		BUG_ON(ring->persistent_gnt_c != 0);
 		WARN_ON(i != (XEN_BLKIF_REQS_PER_PAGE * blkif->nr_ring_pages));
 		ring->active = false;
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -813,6 +813,78 @@ int gnttab_alloc_pages(int nr_pages, str
 }
 EXPORT_SYMBOL_GPL(gnttab_alloc_pages);
 
+void gnttab_page_cache_init(struct gnttab_page_cache *cache)
+{
+	spin_lock_init(&cache->lock);
+	INIT_LIST_HEAD(&cache->pages);
+	cache->num_pages = 0;
+}
+EXPORT_SYMBOL_GPL(gnttab_page_cache_init);
+
+int gnttab_page_cache_get(struct gnttab_page_cache *cache, struct page **page)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cache->lock, flags);
+
+	if (list_empty(&cache->pages)) {
+		spin_unlock_irqrestore(&cache->lock, flags);
+		return gnttab_alloc_pages(1, page);
+	}
+
+	page[0] = list_first_entry(&cache->pages, struct page, lru);
+	list_del(&page[0]->lru);
+	cache->num_pages--;
+
+	spin_unlock_irqrestore(&cache->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(gnttab_page_cache_get);
+
+void gnttab_page_cache_put(struct gnttab_page_cache *cache, struct page **page,
+			   unsigned int num)
+{
+	unsigned long flags;
+	unsigned int i;
+
+	spin_lock_irqsave(&cache->lock, flags);
+
+	for (i = 0; i < num; i++)
+		list_add(&page[i]->lru, &cache->pages);
+	cache->num_pages += num;
+
+	spin_unlock_irqrestore(&cache->lock, flags);
+}
+EXPORT_SYMBOL_GPL(gnttab_page_cache_put);
+
+void gnttab_page_cache_shrink(struct gnttab_page_cache *cache, unsigned int num)
+{
+	struct page *page[10];
+	unsigned int i = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cache->lock, flags);
+
+	while (cache->num_pages > num) {
+		page[i] = list_first_entry(&cache->pages, struct page, lru);
+		list_del(&page[i]->lru);
+		cache->num_pages--;
+		if (++i == ARRAY_SIZE(page)) {
+			spin_unlock_irqrestore(&cache->lock, flags);
+			gnttab_free_pages(i, page);
+			i = 0;
+			spin_lock_irqsave(&cache->lock, flags);
+		}
+	}
+
+	spin_unlock_irqrestore(&cache->lock, flags);
+
+	if (i != 0)
+		gnttab_free_pages(i, page);
+}
+EXPORT_SYMBOL_GPL(gnttab_page_cache_shrink);
+
 void gnttab_pages_clear_private(int nr_pages, struct page **pages)
 {
 	int i;
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -99,6 +99,8 @@ struct vscsibk_info {
 	struct list_head v2p_entry_lists;
 
 	wait_queue_head_t waiting_to_free;
+
+	struct gnttab_page_cache free_pages;
 };
 
 /* theoretical maximum of grants for one request */
@@ -188,10 +190,6 @@ module_param_named(max_buffer_pages, scs
 MODULE_PARM_DESC(max_buffer_pages,
 "Maximum number of free pages to keep in backend buffer");
 
-static DEFINE_SPINLOCK(free_pages_lock);
-static int free_pages_num;
-static LIST_HEAD(scsiback_free_pages);
-
 /* Global spinlock to protect scsiback TPG list */
 static DEFINE_MUTEX(scsiback_mutex);
 static LIST_HEAD(scsiback_list);
@@ -207,41 +205,6 @@ static void scsiback_put(struct vscsibk_
 		wake_up(&info->waiting_to_free);
 }
 
-static void put_free_pages(struct page **page, int num)
-{
-	unsigned long flags;
-	int i = free_pages_num + num, n = num;
-
-	if (num == 0)
-		return;
-	if (i > scsiback_max_buffer_pages) {
-		n = min(num, i - scsiback_max_buffer_pages);
-		gnttab_free_pages(n, page + num - n);
-		n = num - n;
-	}
-	spin_lock_irqsave(&free_pages_lock, flags);
-	for (i = 0; i < n; i++)
-		list_add(&page[i]->lru, &scsiback_free_pages);
-	free_pages_num += n;
-	spin_unlock_irqrestore(&free_pages_lock, flags);
-}
-
-static int get_free_page(struct page **page)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&free_pages_lock, flags);
-	if (list_empty(&scsiback_free_pages)) {
-		spin_unlock_irqrestore(&free_pages_lock, flags);
-		return gnttab_alloc_pages(1, page);
-	}
-	page[0] = list_first_entry(&scsiback_free_pages, struct page, lru);
-	list_del(&page[0]->lru);
-	free_pages_num--;
-	spin_unlock_irqrestore(&free_pages_lock, flags);
-	return 0;
-}
-
 static unsigned long vaddr_page(struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page);
@@ -302,7 +265,8 @@ static void scsiback_fast_flush_area(str
 		BUG_ON(err);
 	}
 
-	put_free_pages(req->pages, req->n_grants);
+	gnttab_page_cache_put(&req->info->free_pages, req->pages,
+			      req->n_grants);
 	req->n_grants = 0;
 }
 
@@ -445,8 +409,8 @@ static int scsiback_gnttab_data_map_list
 	struct vscsibk_info *info = pending_req->info;
 
 	for (i = 0; i < cnt; i++) {
-		if (get_free_page(pg + mapcount)) {
-			put_free_pages(pg, mapcount);
+		if (gnttab_page_cache_get(&info->free_pages, pg + mapcount)) {
+			gnttab_page_cache_put(&info->free_pages, pg, mapcount);
 			pr_err("no grant page\n");
 			return -ENOMEM;
 		}
@@ -796,6 +760,8 @@ static int scsiback_do_cmd_fn(struct vsc
 		cond_resched();
 	}
 
+	gnttab_page_cache_shrink(&info->free_pages, scsiback_max_buffer_pages);
+
 	RING_FINAL_CHECK_FOR_REQUESTS(&info->ring, more_to_do);
 	return more_to_do;
 }
@@ -1233,6 +1199,8 @@ static int scsiback_remove(struct xenbus
 
 	scsiback_release_translation_entry(info);
 
+	gnttab_page_cache_shrink(&info->free_pages, 0);
+
 	dev_set_drvdata(&dev->dev, NULL);
 
 	return 0;
@@ -1263,6 +1231,7 @@ static int scsiback_probe(struct xenbus_
 	info->irq = 0;
 	INIT_LIST_HEAD(&info->v2p_entry_lists);
 	spin_lock_init(&info->v2p_lock);
+	gnttab_page_cache_init(&info->free_pages);
 
 	err = xenbus_printf(XBT_NIL, dev->nodename, "feature-sg-grant", "%u",
 			    SG_ALL);
@@ -1879,13 +1848,6 @@ out:
 
 static void __exit scsiback_exit(void)
 {
-	struct page *page;
-
-	while (free_pages_num) {
-		if (get_free_page(&page))
-			BUG();
-		gnttab_free_pages(1, &page);
-	}
 	target_unregister_template(&scsiback_ops);
 	xenbus_unregister_driver(&scsiback_driver);
 }
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -198,6 +198,19 @@ void gnttab_free_auto_xlat_frames(void);
 int gnttab_alloc_pages(int nr_pages, struct page **pages);
 void gnttab_free_pages(int nr_pages, struct page **pages);
 
+struct gnttab_page_cache {
+	spinlock_t		lock;
+	struct list_head	pages;
+	unsigned int		num_pages;
+};
+
+void gnttab_page_cache_init(struct gnttab_page_cache *cache);
+int gnttab_page_cache_get(struct gnttab_page_cache *cache, struct page **page);
+void gnttab_page_cache_put(struct gnttab_page_cache *cache, struct page **page,
+			   unsigned int num);
+void gnttab_page_cache_shrink(struct gnttab_page_cache *cache,
+			      unsigned int num);
+
 #ifdef CONFIG_XEN_GRANT_DMA_ALLOC
 struct gnttab_dma_alloc_args {
 	/* Device for which DMA memory will be/was allocated. */


