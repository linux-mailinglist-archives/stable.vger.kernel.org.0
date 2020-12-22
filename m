Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F592DB768
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 01:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgLPAB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 19:01:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:59814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729405AbgLOXZI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Dec 2020 18:25:08 -0500
Date:   Tue, 15 Dec 2020 15:22:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074578;
        bh=J4NmjXH8xAj+8S2DExgCME9WdYxZ0t2IQ9mAw05/EPk=;
        h=From:To:Subject:From;
        b=cuYD9dvwNEe3Y0JDK3enCs2BQOcDOWF3/36AJFa1mLDhgpCuTb98PgmzhNbg32Qpg
         0KIHN7L4hD+2hmMgKzGBI4r6ea/S0Xf0jaZ+RP5JH/FEzw0JtpiZ/LwAGQ/BoHRipY
         E6Krpb/xWX+H9fzbuV31J4v9obqiCnB0JxJhqLq8=
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, efault@gmx.de, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, vitaly.wool@konsulko.com
Subject:  [merged]
 z3fold-stricter-locking-and-more-careful-reclaim.patch removed from -mm
 tree
Message-ID: <20201215232258.6t05h_QUM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: z3fold: stricter locking and more careful reclaim
has been removed from the -mm tree.  Its filename was
     z3fold-stricter-locking-and-more-careful-reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vitaly Wool <vitaly.wool@konsulko.com>
Subject: z3fold: stricter locking and more careful reclaim

Use temporary slots in reclaim function to avoid possible race when
freeing those.

While at it, make sure we check CLAIMED flag under page lock in the
reclaim function to make sure we are not racing with z3fold_alloc().

Link: https://lkml.kernel.org/r/20201209145151.18994-4-vitaly.wool@konsulko.com
Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: <stable@vger.kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |  143 +++++++++++++++++++++++++++++---------------------
 1 file changed, 85 insertions(+), 58 deletions(-)

--- a/mm/z3fold.c~z3fold-stricter-locking-and-more-careful-reclaim
+++ a/mm/z3fold.c
@@ -182,6 +182,13 @@ enum z3fold_page_flags {
 };
 
 /*
+ * handle flags, go under HANDLE_FLAG_MASK
+ */
+enum z3fold_handle_flags {
+	HANDLES_NOFREE = 0,
+};
+
+/*
  * Forward declarations
  */
 static struct z3fold_header *__z3fold_alloc(struct z3fold_pool *, size_t, bool);
@@ -311,6 +318,12 @@ static inline void free_handle(unsigned
 	slots = handle_to_slots(handle);
 	write_lock(&slots->lock);
 	*(unsigned long *)handle = 0;
+
+	if (test_bit(HANDLES_NOFREE, &slots->pool)) {
+		write_unlock(&slots->lock);
+		return; /* simple case, nothing else to do */
+	}
+
 	if (zhdr->slots != slots)
 		zhdr->foreign_handles--;
 
@@ -621,6 +634,28 @@ static inline void add_to_unbuddied(stru
 	}
 }
 
+static inline enum buddy get_free_buddy(struct z3fold_header *zhdr, int chunks)
+{
+	enum buddy bud = HEADLESS;
+
+	if (zhdr->middle_chunks) {
+		if (!zhdr->first_chunks &&
+		    chunks <= zhdr->start_middle - ZHDR_CHUNKS)
+			bud = FIRST;
+		else if (!zhdr->last_chunks)
+			bud = LAST;
+	} else {
+		if (!zhdr->first_chunks)
+			bud = FIRST;
+		else if (!zhdr->last_chunks)
+			bud = LAST;
+		else
+			bud = MIDDLE;
+	}
+
+	return bud;
+}
+
 static inline void *mchunk_memmove(struct z3fold_header *zhdr,
 				unsigned short dst_chunk)
 {
@@ -682,18 +717,7 @@ static struct z3fold_header *compact_sin
 		if (WARN_ON(new_zhdr == zhdr))
 			goto out_fail;
 
-		if (new_zhdr->first_chunks == 0) {
-			if (new_zhdr->middle_chunks != 0 &&
-					chunks >= new_zhdr->start_middle) {
-				new_bud = LAST;
-			} else {
-				new_bud = FIRST;
-			}
-		} else if (new_zhdr->last_chunks == 0) {
-			new_bud = LAST;
-		} else if (new_zhdr->middle_chunks == 0) {
-			new_bud = MIDDLE;
-		}
+		new_bud = get_free_buddy(new_zhdr, chunks);
 		q = new_zhdr;
 		switch (new_bud) {
 		case FIRST:
@@ -815,9 +839,8 @@ static void do_compact_page(struct z3fol
 		return;
 	}
 
-	if (unlikely(PageIsolated(page) ||
-		     test_bit(PAGE_CLAIMED, &page->private) ||
-		     test_bit(PAGE_STALE, &page->private))) {
+	if (test_bit(PAGE_STALE, &page->private) ||
+	    test_and_set_bit(PAGE_CLAIMED, &page->private)) {
 		z3fold_page_unlock(zhdr);
 		return;
 	}
@@ -826,13 +849,16 @@ static void do_compact_page(struct z3fol
 	    zhdr->mapped_count == 0 && compact_single_buddy(zhdr)) {
 		if (kref_put(&zhdr->refcount, release_z3fold_page_locked))
 			atomic64_dec(&pool->pages_nr);
-		else
+		else {
+			clear_bit(PAGE_CLAIMED, &page->private);
 			z3fold_page_unlock(zhdr);
+		}
 		return;
 	}
 
 	z3fold_compact_page(zhdr);
 	add_to_unbuddied(pool, zhdr);
+	clear_bit(PAGE_CLAIMED, &page->private);
 	z3fold_page_unlock(zhdr);
 }
 
@@ -1080,17 +1106,8 @@ static int z3fold_alloc(struct z3fold_po
 retry:
 		zhdr = __z3fold_alloc(pool, size, can_sleep);
 		if (zhdr) {
-			if (zhdr->first_chunks == 0) {
-				if (zhdr->middle_chunks != 0 &&
-				    chunks >= zhdr->start_middle)
-					bud = LAST;
-				else
-					bud = FIRST;
-			} else if (zhdr->last_chunks == 0)
-				bud = LAST;
-			else if (zhdr->middle_chunks == 0)
-				bud = MIDDLE;
-			else {
+			bud = get_free_buddy(zhdr, chunks);
+			if (bud == HEADLESS) {
 				if (kref_put(&zhdr->refcount,
 					     release_z3fold_page_locked))
 					atomic64_dec(&pool->pages_nr);
@@ -1236,7 +1253,6 @@ static void z3fold_free(struct z3fold_po
 		pr_err("%s: unknown bud %d\n", __func__, bud);
 		WARN_ON(1);
 		put_z3fold_header(zhdr);
-		clear_bit(PAGE_CLAIMED, &page->private);
 		return;
 	}
 
@@ -1251,8 +1267,7 @@ static void z3fold_free(struct z3fold_po
 		z3fold_page_unlock(zhdr);
 		return;
 	}
-	if (unlikely(PageIsolated(page)) ||
-	    test_and_set_bit(NEEDS_COMPACTING, &page->private)) {
+	if (test_and_set_bit(NEEDS_COMPACTING, &page->private)) {
 		put_z3fold_header(zhdr);
 		clear_bit(PAGE_CLAIMED, &page->private);
 		return;
@@ -1316,6 +1331,10 @@ static int z3fold_reclaim_page(struct z3
 	struct page *page = NULL;
 	struct list_head *pos;
 	unsigned long first_handle = 0, middle_handle = 0, last_handle = 0;
+	struct z3fold_buddy_slots slots __attribute__((aligned(SLOTS_ALIGN)));
+
+	rwlock_init(&slots.lock);
+	slots.pool = (unsigned long)pool | (1 << HANDLES_NOFREE);
 
 	spin_lock(&pool->lock);
 	if (!pool->ops || !pool->ops->evict || retries == 0) {
@@ -1330,35 +1349,36 @@ static int z3fold_reclaim_page(struct z3
 		list_for_each_prev(pos, &pool->lru) {
 			page = list_entry(pos, struct page, lru);
 
-			/* this bit could have been set by free, in which case
-			 * we pass over to the next page in the pool.
-			 */
-			if (test_and_set_bit(PAGE_CLAIMED, &page->private)) {
-				page = NULL;
-				continue;
-			}
-
-			if (unlikely(PageIsolated(page))) {
-				clear_bit(PAGE_CLAIMED, &page->private);
-				page = NULL;
-				continue;
-			}
 			zhdr = page_address(page);
 			if (test_bit(PAGE_HEADLESS, &page->private))
 				break;
 
+			if (kref_get_unless_zero(&zhdr->refcount) == 0) {
+				zhdr = NULL;
+				break;
+			}
 			if (!z3fold_page_trylock(zhdr)) {
-				clear_bit(PAGE_CLAIMED, &page->private);
+				if (kref_put(&zhdr->refcount,
+						release_z3fold_page))
+					atomic64_dec(&pool->pages_nr);
 				zhdr = NULL;
 				continue; /* can't evict at this point */
 			}
-			if (zhdr->foreign_handles) {
-				clear_bit(PAGE_CLAIMED, &page->private);
-				z3fold_page_unlock(zhdr);
+
+			/* test_and_set_bit is of course atomic, but we still
+			 * need to do it under page lock, otherwise checking
+			 * that bit in __z3fold_alloc wouldn't make sense
+			 */
+			if (zhdr->foreign_handles ||
+			    test_and_set_bit(PAGE_CLAIMED, &page->private)) {
+				if (kref_put(&zhdr->refcount,
+						release_z3fold_page))
+					atomic64_dec(&pool->pages_nr);
+				else
+					z3fold_page_unlock(zhdr);
 				zhdr = NULL;
 				continue; /* can't evict such page */
 			}
-			kref_get(&zhdr->refcount);
 			list_del_init(&zhdr->buddy);
 			zhdr->cpu = -1;
 			break;
@@ -1380,12 +1400,16 @@ static int z3fold_reclaim_page(struct z3
 			first_handle = 0;
 			last_handle = 0;
 			middle_handle = 0;
+			memset(slots.slot, 0, sizeof(slots.slot));
 			if (zhdr->first_chunks)
-				first_handle = encode_handle(zhdr, FIRST);
+				first_handle = __encode_handle(zhdr, &slots,
+								FIRST);
 			if (zhdr->middle_chunks)
-				middle_handle = encode_handle(zhdr, MIDDLE);
+				middle_handle = __encode_handle(zhdr, &slots,
+								MIDDLE);
 			if (zhdr->last_chunks)
-				last_handle = encode_handle(zhdr, LAST);
+				last_handle = __encode_handle(zhdr, &slots,
+								LAST);
 			/*
 			 * it's safe to unlock here because we hold a
 			 * reference to this page
@@ -1400,19 +1424,16 @@ static int z3fold_reclaim_page(struct z3
 			ret = pool->ops->evict(pool, middle_handle);
 			if (ret)
 				goto next;
-			free_handle(middle_handle, zhdr);
 		}
 		if (first_handle) {
 			ret = pool->ops->evict(pool, first_handle);
 			if (ret)
 				goto next;
-			free_handle(first_handle, zhdr);
 		}
 		if (last_handle) {
 			ret = pool->ops->evict(pool, last_handle);
 			if (ret)
 				goto next;
-			free_handle(last_handle, zhdr);
 		}
 next:
 		if (test_bit(PAGE_HEADLESS, &page->private)) {
@@ -1426,9 +1447,11 @@ next:
 			spin_unlock(&pool->lock);
 			clear_bit(PAGE_CLAIMED, &page->private);
 		} else {
+			struct z3fold_buddy_slots *slots = zhdr->slots;
 			z3fold_page_lock(zhdr);
 			if (kref_put(&zhdr->refcount,
 					release_z3fold_page_locked)) {
+				kmem_cache_free(pool->c_handle, slots);
 				atomic64_dec(&pool->pages_nr);
 				return 0;
 			}
@@ -1544,8 +1567,7 @@ static bool z3fold_page_isolate(struct p
 	VM_BUG_ON_PAGE(!PageMovable(page), page);
 	VM_BUG_ON_PAGE(PageIsolated(page), page);
 
-	if (test_bit(PAGE_HEADLESS, &page->private) ||
-	    test_bit(PAGE_CLAIMED, &page->private))
+	if (test_bit(PAGE_HEADLESS, &page->private))
 		return false;
 
 	zhdr = page_address(page);
@@ -1557,6 +1579,8 @@ static bool z3fold_page_isolate(struct p
 	if (zhdr->mapped_count != 0 || zhdr->foreign_handles != 0)
 		goto out;
 
+	if (test_and_set_bit(PAGE_CLAIMED, &page->private))
+		goto out;
 	pool = zhdr_to_pool(zhdr);
 	spin_lock(&pool->lock);
 	if (!list_empty(&zhdr->buddy))
@@ -1583,16 +1607,17 @@ static int z3fold_page_migrate(struct ad
 
 	VM_BUG_ON_PAGE(!PageMovable(page), page);
 	VM_BUG_ON_PAGE(!PageIsolated(page), page);
+	VM_BUG_ON_PAGE(!test_bit(PAGE_CLAIMED, &page->private), page);
 	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
 
 	zhdr = page_address(page);
 	pool = zhdr_to_pool(zhdr);
 
-	if (!z3fold_page_trylock(zhdr)) {
+	if (!z3fold_page_trylock(zhdr))
 		return -EAGAIN;
-	}
 	if (zhdr->mapped_count != 0 || zhdr->foreign_handles != 0) {
 		z3fold_page_unlock(zhdr);
+		clear_bit(PAGE_CLAIMED, &page->private);
 		return -EBUSY;
 	}
 	if (work_pending(&zhdr->work)) {
@@ -1634,6 +1659,7 @@ static int z3fold_page_migrate(struct ad
 	queue_work_on(new_zhdr->cpu, pool->compact_wq, &new_zhdr->work);
 
 	page_mapcount_reset(page);
+	clear_bit(PAGE_CLAIMED, &page->private);
 	put_page(page);
 	return 0;
 }
@@ -1657,6 +1683,7 @@ static void z3fold_page_putback(struct p
 	spin_lock(&pool->lock);
 	list_add(&page->lru, &pool->lru);
 	spin_unlock(&pool->lock);
+	clear_bit(PAGE_CLAIMED, &page->private);
 	z3fold_page_unlock(zhdr);
 }
 
_

Patches currently in -mm which might be from vitaly.wool@konsulko.com are


