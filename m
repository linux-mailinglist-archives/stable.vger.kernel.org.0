Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D996D2D9EF0
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408429AbgLNSZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:25:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:46226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502322AbgLNRiO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:38:14 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovksy@oracle.com>,
        Jason Andryuk <jandryuk@gmail.com>
Subject: [PATCH 5.9 082/105] xen: dont use page->lru for ZONE_DEVICE memory
Date:   Mon, 14 Dec 2020 18:28:56 +0100
Message-Id: <20201214172559.225067206@linuxfoundation.org>
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

commit ee32f32335e8c7f6154bf397f4ac9b6175b488a8 upstream.

Commit 9e2369c06c8a18 ("xen: add helpers to allocate unpopulated
memory") introduced usage of ZONE_DEVICE memory for foreign memory
mappings.

Unfortunately this collides with using page->lru for Xen backend
private page caches.

Fix that by using page->zone_device_data instead.

Cc: <stable@vger.kernel.org> # 5.9
Fixes: 9e2369c06c8a18 ("xen: add helpers to allocate unpopulated memory")
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovksy@oracle.com>
Reviewed-by: Jason Andryuk <jandryuk@gmail.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/grant-table.c       |   65 +++++++++++++++++++++++++++++++++++-----
 drivers/xen/unpopulated-alloc.c |   20 ++++++------
 include/xen/grant_table.h       |    4 ++
 3 files changed, 73 insertions(+), 16 deletions(-)

--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -813,10 +813,63 @@ int gnttab_alloc_pages(int nr_pages, str
 }
 EXPORT_SYMBOL_GPL(gnttab_alloc_pages);
 
+#ifdef CONFIG_XEN_UNPOPULATED_ALLOC
+static inline void cache_init(struct gnttab_page_cache *cache)
+{
+	cache->pages = NULL;
+}
+
+static inline bool cache_empty(struct gnttab_page_cache *cache)
+{
+	return !cache->pages;
+}
+
+static inline struct page *cache_deq(struct gnttab_page_cache *cache)
+{
+	struct page *page;
+
+	page = cache->pages;
+	cache->pages = page->zone_device_data;
+
+	return page;
+}
+
+static inline void cache_enq(struct gnttab_page_cache *cache, struct page *page)
+{
+	page->zone_device_data = cache->pages;
+	cache->pages = page;
+}
+#else
+static inline void cache_init(struct gnttab_page_cache *cache)
+{
+	INIT_LIST_HEAD(&cache->pages);
+}
+
+static inline bool cache_empty(struct gnttab_page_cache *cache)
+{
+	return list_empty(&cache->pages);
+}
+
+static inline struct page *cache_deq(struct gnttab_page_cache *cache)
+{
+	struct page *page;
+
+	page = list_first_entry(&cache->pages, struct page, lru);
+	list_del(&page->lru);
+
+	return page;
+}
+
+static inline void cache_enq(struct gnttab_page_cache *cache, struct page *page)
+{
+	list_add(&page->lru, &cache->pages);
+}
+#endif
+
 void gnttab_page_cache_init(struct gnttab_page_cache *cache)
 {
 	spin_lock_init(&cache->lock);
-	INIT_LIST_HEAD(&cache->pages);
+	cache_init(cache);
 	cache->num_pages = 0;
 }
 EXPORT_SYMBOL_GPL(gnttab_page_cache_init);
@@ -827,13 +880,12 @@ int gnttab_page_cache_get(struct gnttab_
 
 	spin_lock_irqsave(&cache->lock, flags);
 
-	if (list_empty(&cache->pages)) {
+	if (cache_empty(cache)) {
 		spin_unlock_irqrestore(&cache->lock, flags);
 		return gnttab_alloc_pages(1, page);
 	}
 
-	page[0] = list_first_entry(&cache->pages, struct page, lru);
-	list_del(&page[0]->lru);
+	page[0] = cache_deq(cache);
 	cache->num_pages--;
 
 	spin_unlock_irqrestore(&cache->lock, flags);
@@ -851,7 +903,7 @@ void gnttab_page_cache_put(struct gnttab
 	spin_lock_irqsave(&cache->lock, flags);
 
 	for (i = 0; i < num; i++)
-		list_add(&page[i]->lru, &cache->pages);
+		cache_enq(cache, page[i]);
 	cache->num_pages += num;
 
 	spin_unlock_irqrestore(&cache->lock, flags);
@@ -867,8 +919,7 @@ void gnttab_page_cache_shrink(struct gnt
 	spin_lock_irqsave(&cache->lock, flags);
 
 	while (cache->num_pages > num) {
-		page[i] = list_first_entry(&cache->pages, struct page, lru);
-		list_del(&page[i]->lru);
+		page[i] = cache_deq(cache);
 		cache->num_pages--;
 		if (++i == ARRAY_SIZE(page)) {
 			spin_unlock_irqrestore(&cache->lock, flags);
--- a/drivers/xen/unpopulated-alloc.c
+++ b/drivers/xen/unpopulated-alloc.c
@@ -12,7 +12,7 @@
 #include <xen/xen.h>
 
 static DEFINE_MUTEX(list_lock);
-static LIST_HEAD(page_list);
+static struct page *page_list;
 static unsigned int list_count;
 
 static int fill_list(unsigned int nr_pages)
@@ -75,7 +75,8 @@ static int fill_list(unsigned int nr_pag
 		struct page *pg = virt_to_page(vaddr + PAGE_SIZE * i);
 
 		BUG_ON(!virt_addr_valid(vaddr + PAGE_SIZE * i));
-		list_add(&pg->lru, &page_list);
+		pg->zone_device_data = page_list;
+		page_list = pg;
 		list_count++;
 	}
 
@@ -101,12 +102,10 @@ int xen_alloc_unpopulated_pages(unsigned
 	}
 
 	for (i = 0; i < nr_pages; i++) {
-		struct page *pg = list_first_entry_or_null(&page_list,
-							   struct page,
-							   lru);
+		struct page *pg = page_list;
 
 		BUG_ON(!pg);
-		list_del(&pg->lru);
+		page_list = pg->zone_device_data;
 		list_count--;
 		pages[i] = pg;
 
@@ -117,7 +116,8 @@ int xen_alloc_unpopulated_pages(unsigned
 				unsigned int j;
 
 				for (j = 0; j <= i; j++) {
-					list_add(&pages[j]->lru, &page_list);
+					pages[j]->zone_device_data = page_list;
+					page_list = pages[j];
 					list_count++;
 				}
 				goto out;
@@ -143,7 +143,8 @@ void xen_free_unpopulated_pages(unsigned
 
 	mutex_lock(&list_lock);
 	for (i = 0; i < nr_pages; i++) {
-		list_add(&pages[i]->lru, &page_list);
+		pages[i]->zone_device_data = page_list;
+		page_list = pages[i];
 		list_count++;
 	}
 	mutex_unlock(&list_lock);
@@ -172,7 +173,8 @@ static int __init init(void)
 			struct page *pg =
 				pfn_to_page(xen_extra_mem[i].start_pfn + j);
 
-			list_add(&pg->lru, &page_list);
+			pg->zone_device_data = page_list;
+			page_list = pg;
 			list_count++;
 		}
 	}
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -200,7 +200,11 @@ void gnttab_free_pages(int nr_pages, str
 
 struct gnttab_page_cache {
 	spinlock_t		lock;
+#ifdef CONFIG_XEN_UNPOPULATED_ALLOC
+	struct page		*pages;
+#else
 	struct list_head	pages;
+#endif
 	unsigned int		num_pages;
 };
 


