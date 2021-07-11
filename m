Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87EA3C3BB4
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 13:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbhGKLLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 07:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232024AbhGKLLh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Jul 2021 07:11:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18632611CB;
        Sun, 11 Jul 2021 11:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626001730;
        bh=79PMguCFF0YqtGRbeArsKJrNQMO2FBrXUe0nyu30pY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D4MAgumWbch9PeJiiBvHzjQYI5Pe9sWBn+HKrVhmcUBSE2W1o6/75PX2o416HXFXg
         1UgDh4jQ57iOiv9/eYT5AV2OZCoMoBmKDur2gxBXK6eZz+7/iVaZ5N5hMOK6XwPSHm
         H2LA5GfONQg7WPBsz3Z+FGXyfFexT11ZN2Y1MPA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.239
Date:   Sun, 11 Jul 2021 13:08:40 +0200
Message-Id: <1626001718187174@kroah.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1626001718201109@kroah.com>
References: <1626001718201109@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 5442918651e0..3bb379664a96 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 238
+SUBLEVEL = 239
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index e427f80344c4..a2d770acd10a 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -450,7 +450,7 @@ nouveau_bo_sync_for_device(struct nouveau_bo *nvbo)
 	struct ttm_dma_tt *ttm_dma = (struct ttm_dma_tt *)nvbo->bo.ttm;
 	int i;
 
-	if (!ttm_dma)
+	if (!ttm_dma || !ttm_dma->dma_address)
 		return;
 
 	/* Don't waste time looping if the object is coherent */
@@ -470,7 +470,7 @@ nouveau_bo_sync_for_cpu(struct nouveau_bo *nvbo)
 	struct ttm_dma_tt *ttm_dma = (struct ttm_dma_tt *)nvbo->bo.ttm;
 	int i;
 
-	if (!ttm_dma)
+	if (!ttm_dma || !ttm_dma->dma_address)
 		return;
 
 	/* Don't waste time looping if the object is coherent */
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 5be3d6b7991b..a46fbe2d2ee6 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -216,6 +216,8 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 		return DISK_EVENT_EJECT_REQUEST;
 	else if (med->media_event_code == 2)
 		return DISK_EVENT_MEDIA_CHANGE;
+	else if (med->media_event_code == 3)
+		return DISK_EVENT_EJECT_REQUEST;
 	return 0;
 }
 
diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index b370144682ed..a2f8130e18fe 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -524,6 +524,9 @@ static void xen_irq_lateeoi_locked(struct irq_info *info, bool spurious)
 	}
 
 	info->eoi_time = 0;
+
+	/* is_active hasn't been reset yet, do it now. */
+	smp_store_release(&info->is_active, 0);
 	do_unmask(info, EVT_MASK_REASON_EOI_PENDING);
 }
 
@@ -1780,10 +1783,22 @@ static void lateeoi_ack_dynirq(struct irq_data *data)
 	struct irq_info *info = info_for_irq(data->irq);
 	evtchn_port_t evtchn = info ? info->evtchn : 0;
 
-	if (VALID_EVTCHN(evtchn)) {
-		do_mask(info, EVT_MASK_REASON_EOI_PENDING);
-		ack_dynirq(data);
-	}
+	if (!VALID_EVTCHN(evtchn))
+		return;
+
+	do_mask(info, EVT_MASK_REASON_EOI_PENDING);
+
+	if (unlikely(irqd_is_setaffinity_pending(data)) &&
+	    likely(!irqd_irq_disabled(data))) {
+		do_mask(info, EVT_MASK_REASON_TEMPORARY);
+
+		clear_evtchn(evtchn);
+
+		irq_move_masked_irq(data);
+
+		do_unmask(info, EVT_MASK_REASON_TEMPORARY);
+	} else
+		clear_evtchn(evtchn);
 }
 
 static void lateeoi_mask_ack_dynirq(struct irq_data *data)
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index fe0ec0a29db7..d2b5cc8ce54f 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -467,17 +467,6 @@ static inline int hstate_index(struct hstate *h)
 	return h - hstates;
 }
 
-pgoff_t __basepage_index(struct page *page);
-
-/* Return page->index in PAGE_SIZE units */
-static inline pgoff_t basepage_index(struct page *page)
-{
-	if (!PageCompound(page))
-		return page->index;
-
-	return __basepage_index(page);
-}
-
 extern int dissolve_free_huge_page(struct page *page);
 extern int dissolve_free_huge_pages(unsigned long start_pfn,
 				    unsigned long end_pfn);
@@ -572,11 +561,6 @@ static inline int hstate_index(struct hstate *h)
 	return 0;
 }
 
-static inline pgoff_t basepage_index(struct page *page)
-{
-	return page->index;
-}
-
 static inline int dissolve_free_huge_page(struct page *page)
 {
 	return 0;
diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index 41eb6fdf87a8..86b5fb08e96c 100644
--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -113,7 +113,8 @@ struct kfifo_rec_ptr_2 __STRUCT_KFIFO_PTR(unsigned char, 2, void);
  * array is a part of the structure and the fifo type where the array is
  * outside of the fifo structure.
  */
-#define	__is_kfifo_ptr(fifo)	(sizeof(*fifo) == sizeof(struct __kfifo))
+#define	__is_kfifo_ptr(fifo) \
+	(sizeof(*fifo) == sizeof(STRUCT_KFIFO_PTR(typeof(*(fifo)->type))))
 
 /**
  * DECLARE_KFIFO_PTR - macro to declare a fifo pointer object
diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
index 57b0030d3800..5d0767cb424a 100644
--- a/include/linux/mmdebug.h
+++ b/include/linux/mmdebug.h
@@ -37,10 +37,22 @@ void dump_mm(const struct mm_struct *mm);
 			BUG();						\
 		}							\
 	} while (0)
-#define VM_WARN_ON(cond) WARN_ON(cond)
-#define VM_WARN_ON_ONCE(cond) WARN_ON_ONCE(cond)
-#define VM_WARN_ONCE(cond, format...) WARN_ONCE(cond, format)
-#define VM_WARN(cond, format...) WARN(cond, format)
+#define VM_WARN_ON_ONCE_PAGE(cond, page)	({			\
+	static bool __section(".data.once") __warned;			\
+	int __ret_warn_once = !!(cond);					\
+									\
+	if (unlikely(__ret_warn_once && !__warned)) {			\
+		dump_page(page, "VM_WARN_ON_ONCE_PAGE(" __stringify(cond)")");\
+		__warned = true;					\
+		WARN_ON(1);						\
+	}								\
+	unlikely(__ret_warn_once);					\
+})
+
+#define VM_WARN_ON(cond) (void)WARN_ON(cond)
+#define VM_WARN_ON_ONCE(cond) (void)WARN_ON_ONCE(cond)
+#define VM_WARN_ONCE(cond, format...) (void)WARN_ONCE(cond, format)
+#define VM_WARN(cond, format...) (void)WARN(cond, format)
 #else
 #define VM_BUG_ON(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_BUG_ON_PAGE(cond, page) VM_BUG_ON(cond)
@@ -48,6 +60,7 @@ void dump_mm(const struct mm_struct *mm);
 #define VM_BUG_ON_MM(cond, mm) VM_BUG_ON(cond)
 #define VM_WARN_ON(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_ONCE(cond) BUILD_BUG_ON_INVALID(cond)
+#define VM_WARN_ON_ONCE_PAGE(cond, page)  BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ONCE(cond, format...) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN(cond, format...) BUILD_BUG_ON_INVALID(cond)
 #endif
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index e08b5339023c..84c7fc7f63e7 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -399,7 +399,7 @@ static inline struct page *read_mapping_page(struct address_space *mapping,
 }
 
 /*
- * Get index of the page with in radix-tree
+ * Get index of the page within radix-tree (but not for hugetlb pages).
  * (TODO: remove once hugetlb pages will have ->index in PAGE_SIZE)
  */
 static inline pgoff_t page_to_index(struct page *page)
@@ -418,15 +418,16 @@ static inline pgoff_t page_to_index(struct page *page)
 	return pgoff;
 }
 
+extern pgoff_t hugetlb_basepage_index(struct page *page);
+
 /*
- * Get the offset in PAGE_SIZE.
- * (TODO: hugepage should have ->index in PAGE_SIZE)
+ * Get the offset in PAGE_SIZE (even for hugetlb pages).
+ * (TODO: hugetlb pages should have ->index in PAGE_SIZE)
  */
 static inline pgoff_t page_to_pgoff(struct page *page)
 {
-	if (unlikely(PageHeadHuge(page)))
-		return page->index << compound_order(page);
-
+	if (unlikely(PageHuge(page)))
+		return hugetlb_basepage_index(page);
 	return page_to_index(page);
 }
 
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index d7d6d4eb1794..91ccae946716 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -98,7 +98,8 @@ enum ttu_flags {
 					 * do a final flush if necessary */
 	TTU_RMAP_LOCKED		= 0x80,	/* do not grab rmap lock:
 					 * caller holds it */
-	TTU_SPLIT_FREEZE	= 0x100,		/* freeze pte under splitting thp */
+	TTU_SPLIT_FREEZE	= 0x100, /* freeze pte under splitting thp */
+	TTU_SYNC		= 0x200, /* avoid racy checks with PVMW_SYNC */
 };
 
 #ifdef CONFIG_MMU
diff --git a/kernel/futex.c b/kernel/futex.c
index af1d9a993988..e282c083df59 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -719,7 +719,7 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
 
 		key->both.offset |= FUT_OFF_INODE; /* inode-based key */
 		key->shared.i_seq = get_inode_sequence_number(inode);
-		key->shared.pgoff = basepage_index(tail);
+		key->shared.pgoff = page_to_pgoff(tail);
 		rcu_read_unlock();
 	}
 
diff --git a/kernel/kthread.c b/kernel/kthread.c
index fd6f9322312a..7dd2c8a797d7 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -979,8 +979,38 @@ void kthread_flush_work(struct kthread_work *work)
 EXPORT_SYMBOL_GPL(kthread_flush_work);
 
 /*
- * This function removes the work from the worker queue. Also it makes sure
- * that it won't get queued later via the delayed work's timer.
+ * Make sure that the timer is neither set nor running and could
+ * not manipulate the work list_head any longer.
+ *
+ * The function is called under worker->lock. The lock is temporary
+ * released but the timer can't be set again in the meantime.
+ */
+static void kthread_cancel_delayed_work_timer(struct kthread_work *work,
+					      unsigned long *flags)
+{
+	struct kthread_delayed_work *dwork =
+		container_of(work, struct kthread_delayed_work, work);
+	struct kthread_worker *worker = work->worker;
+
+	/*
+	 * del_timer_sync() must be called to make sure that the timer
+	 * callback is not running. The lock must be temporary released
+	 * to avoid a deadlock with the callback. In the meantime,
+	 * any queuing is blocked by setting the canceling counter.
+	 */
+	work->canceling++;
+	spin_unlock_irqrestore(&worker->lock, *flags);
+	del_timer_sync(&dwork->timer);
+	spin_lock_irqsave(&worker->lock, *flags);
+	work->canceling--;
+}
+
+/*
+ * This function removes the work from the worker queue.
+ *
+ * It is called under worker->lock. The caller must make sure that
+ * the timer used by delayed work is not running, e.g. by calling
+ * kthread_cancel_delayed_work_timer().
  *
  * The work might still be in use when this function finishes. See the
  * current_work proceed by the worker.
@@ -988,28 +1018,8 @@ EXPORT_SYMBOL_GPL(kthread_flush_work);
  * Return: %true if @work was pending and successfully canceled,
  *	%false if @work was not pending
  */
-static bool __kthread_cancel_work(struct kthread_work *work, bool is_dwork,
-				  unsigned long *flags)
+static bool __kthread_cancel_work(struct kthread_work *work)
 {
-	/* Try to cancel the timer if exists. */
-	if (is_dwork) {
-		struct kthread_delayed_work *dwork =
-			container_of(work, struct kthread_delayed_work, work);
-		struct kthread_worker *worker = work->worker;
-
-		/*
-		 * del_timer_sync() must be called to make sure that the timer
-		 * callback is not running. The lock must be temporary released
-		 * to avoid a deadlock with the callback. In the meantime,
-		 * any queuing is blocked by setting the canceling counter.
-		 */
-		work->canceling++;
-		spin_unlock_irqrestore(&worker->lock, *flags);
-		del_timer_sync(&dwork->timer);
-		spin_lock_irqsave(&worker->lock, *flags);
-		work->canceling--;
-	}
-
 	/*
 	 * Try to remove the work from a worker list. It might either
 	 * be from worker->work_list or from worker->delayed_work_list.
@@ -1062,11 +1072,23 @@ bool kthread_mod_delayed_work(struct kthread_worker *worker,
 	/* Work must not be used with >1 worker, see kthread_queue_work() */
 	WARN_ON_ONCE(work->worker != worker);
 
-	/* Do not fight with another command that is canceling this work. */
+	/*
+	 * Temporary cancel the work but do not fight with another command
+	 * that is canceling the work as well.
+	 *
+	 * It is a bit tricky because of possible races with another
+	 * mod_delayed_work() and cancel_delayed_work() callers.
+	 *
+	 * The timer must be canceled first because worker->lock is released
+	 * when doing so. But the work can be removed from the queue (list)
+	 * only when it can be queued again so that the return value can
+	 * be used for reference counting.
+	 */
+	kthread_cancel_delayed_work_timer(work, &flags);
 	if (work->canceling)
 		goto out;
+	ret = __kthread_cancel_work(work);
 
-	ret = __kthread_cancel_work(work, true, &flags);
 fast_queue:
 	__kthread_queue_delayed_work(worker, dwork, delay);
 out:
@@ -1088,7 +1110,10 @@ static bool __kthread_cancel_work_sync(struct kthread_work *work, bool is_dwork)
 	/* Work must not be used with >1 worker, see kthread_queue_work(). */
 	WARN_ON_ONCE(work->worker != worker);
 
-	ret = __kthread_cancel_work(work, is_dwork, &flags);
+	if (is_dwork)
+		kthread_cancel_delayed_work_timer(work, &flags);
+
+	ret = __kthread_cancel_work(work);
 
 	if (worker->current_work != work)
 		goto out_fast;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 513f0cf173ad..972893908bcd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2324,16 +2324,16 @@ void vma_adjust_trans_huge(struct vm_area_struct *vma,
 static void unmap_page(struct page *page)
 {
 	enum ttu_flags ttu_flags = TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS |
-		TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD;
-	bool unmap_success;
+		TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD | TTU_SYNC;
 
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 
 	if (PageAnon(page))
 		ttu_flags |= TTU_SPLIT_FREEZE;
 
-	unmap_success = try_to_unmap(page, ttu_flags);
-	VM_BUG_ON_PAGE(!unmap_success, page);
+	try_to_unmap(page, ttu_flags);
+
+	VM_WARN_ON_ONCE_PAGE(page_mapped(page), page);
 }
 
 static void remap_page(struct page *page)
@@ -2586,7 +2586,7 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 	struct pglist_data *pgdata = NODE_DATA(page_to_nid(head));
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
-	int count, mapcount, extra_pins, ret;
+	int extra_pins, ret;
 	bool mlocked;
 	unsigned long flags;
 	pgoff_t end;
@@ -2648,7 +2648,6 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 
 	mlocked = PageMlocked(page);
 	unmap_page(head);
-	VM_BUG_ON_PAGE(compound_mapcount(head), head);
 
 	/* Make sure the page is not on per-CPU pagevec as it takes pin */
 	if (mlocked)
@@ -2674,9 +2673,7 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 
 	/* Prevent deferred_split_scan() touching ->_refcount */
 	spin_lock(&pgdata->split_queue_lock);
-	count = page_count(head);
-	mapcount = total_mapcount(head);
-	if (!mapcount && page_ref_freeze(head, 1 + extra_pins)) {
+	if (page_ref_freeze(head, 1 + extra_pins)) {
 		if (!list_empty(page_deferred_list(head))) {
 			pgdata->split_queue_len--;
 			list_del(page_deferred_list(head));
@@ -2692,16 +2689,9 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 		} else
 			ret = 0;
 	} else {
-		if (IS_ENABLED(CONFIG_DEBUG_VM) && mapcount) {
-			pr_alert("total_mapcount: %u, page_count(): %u\n",
-					mapcount, count);
-			if (PageTail(page))
-				dump_page(head, NULL);
-			dump_page(page, "total_mapcount(head) > 0");
-			BUG();
-		}
 		spin_unlock(&pgdata->split_queue_lock);
-fail:		if (mapping)
+fail:
+		if (mapping)
 			spin_unlock(&mapping->tree_lock);
 		spin_unlock_irqrestore(zone_lru_lock(page_zone(head)), flags);
 		remap_page(head);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0dc181290d1f..c765fd01f0aa 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1403,15 +1403,12 @@ int PageHeadHuge(struct page *page_head)
 	return get_compound_page_dtor(page_head) == free_huge_page;
 }
 
-pgoff_t __basepage_index(struct page *page)
+pgoff_t hugetlb_basepage_index(struct page *page)
 {
 	struct page *page_head = compound_head(page);
 	pgoff_t index = page_index(page_head);
 	unsigned long compound_idx;
 
-	if (!PageHuge(page_head))
-		return page_index(page);
-
 	if (compound_order(page_head) >= MAX_ORDER)
 		compound_idx = page_to_pfn(page) - page_to_pfn(page_head);
 	else
diff --git a/mm/internal.h b/mm/internal.h
index a182506242c4..97c8e896cd2f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -330,27 +330,52 @@ static inline void mlock_migrate_page(struct page *newpage, struct page *page)
 extern pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma);
 
 /*
- * At what user virtual address is page expected in @vma?
+ * At what user virtual address is page expected in vma?
+ * Returns -EFAULT if all of the page is outside the range of vma.
+ * If page is a compound head, the entire compound page is considered.
  */
 static inline unsigned long
-__vma_address(struct page *page, struct vm_area_struct *vma)
+vma_address(struct page *page, struct vm_area_struct *vma)
 {
-	pgoff_t pgoff = page_to_pgoff(page);
-	return vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
+	pgoff_t pgoff;
+	unsigned long address;
+
+	VM_BUG_ON_PAGE(PageKsm(page), page);	/* KSM page->index unusable */
+	pgoff = page_to_pgoff(page);
+	if (pgoff >= vma->vm_pgoff) {
+		address = vma->vm_start +
+			((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
+		/* Check for address beyond vma (or wrapped through 0?) */
+		if (address < vma->vm_start || address >= vma->vm_end)
+			address = -EFAULT;
+	} else if (PageHead(page) &&
+		   pgoff + (1UL << compound_order(page)) - 1 >= vma->vm_pgoff) {
+		/* Test above avoids possibility of wrap to 0 on 32-bit */
+		address = vma->vm_start;
+	} else {
+		address = -EFAULT;
+	}
+	return address;
 }
 
+/*
+ * Then at what user virtual address will none of the page be found in vma?
+ * Assumes that vma_address() already returned a good starting address.
+ * If page is a compound head, the entire compound page is considered.
+ */
 static inline unsigned long
-vma_address(struct page *page, struct vm_area_struct *vma)
+vma_address_end(struct page *page, struct vm_area_struct *vma)
 {
-	unsigned long start, end;
-
-	start = __vma_address(page, vma);
-	end = start + PAGE_SIZE * (hpage_nr_pages(page) - 1);
-
-	/* page should be within @vma mapping range */
-	VM_BUG_ON_VMA(end < vma->vm_start || start >= vma->vm_end, vma);
-
-	return max(start, vma->vm_start);
+	pgoff_t pgoff;
+	unsigned long address;
+
+	VM_BUG_ON_PAGE(PageKsm(page), page);	/* KSM page->index unusable */
+	pgoff = page_to_pgoff(page) + (1UL << compound_order(page));
+	address = vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
+	/* Check for address beyond vma (or wrapped through 0?) */
+	if (address < vma->vm_start || address > vma->vm_end)
+		address = vma->vm_end;
+	return address;
 }
 
 #else /* !CONFIG_MMU */
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index e00d985a51c5..a612daef5f00 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -110,6 +110,13 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw)
 	return true;
 }
 
+static void step_forward(struct page_vma_mapped_walk *pvmw, unsigned long size)
+{
+	pvmw->address = (pvmw->address + size) & ~(size - 1);
+	if (!pvmw->address)
+		pvmw->address = ULONG_MAX;
+}
+
 /**
  * page_vma_mapped_walk - check if @pvmw->page is mapped in @pvmw->vma at
  * @pvmw->address
@@ -138,6 +145,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 {
 	struct mm_struct *mm = pvmw->vma->vm_mm;
 	struct page *page = pvmw->page;
+	unsigned long end;
 	pgd_t *pgd;
 	p4d_t *p4d;
 	pud_t *pud;
@@ -147,10 +155,11 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 	if (pvmw->pmd && !pvmw->pte)
 		return not_found(pvmw);
 
-	if (pvmw->pte)
-		goto next_pte;
+	if (unlikely(PageHuge(page))) {
+		/* The only possible mapping was handled on last iteration */
+		if (pvmw->pte)
+			return not_found(pvmw);
 
-	if (unlikely(PageHuge(pvmw->page))) {
 		/* when pud is not present, pte will be NULL */
 		pvmw->pte = huge_pte_offset(mm, pvmw->address,
 					    PAGE_SIZE << compound_order(page));
@@ -163,78 +172,108 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			return not_found(pvmw);
 		return true;
 	}
-restart:
-	pgd = pgd_offset(mm, pvmw->address);
-	if (!pgd_present(*pgd))
-		return false;
-	p4d = p4d_offset(pgd, pvmw->address);
-	if (!p4d_present(*p4d))
-		return false;
-	pud = pud_offset(p4d, pvmw->address);
-	if (!pud_present(*pud))
-		return false;
-	pvmw->pmd = pmd_offset(pud, pvmw->address);
+
 	/*
-	 * Make sure the pmd value isn't cached in a register by the
-	 * compiler and used as a stale value after we've observed a
-	 * subsequent update.
+	 * Seek to next pte only makes sense for THP.
+	 * But more important than that optimization, is to filter out
+	 * any PageKsm page: whose page->index misleads vma_address()
+	 * and vma_address_end() to disaster.
 	 */
-	pmde = READ_ONCE(*pvmw->pmd);
-	if (pmd_trans_huge(pmde) || is_pmd_migration_entry(pmde)) {
-		pvmw->ptl = pmd_lock(mm, pvmw->pmd);
-		if (likely(pmd_trans_huge(*pvmw->pmd))) {
-			if (pvmw->flags & PVMW_MIGRATION)
-				return not_found(pvmw);
-			if (pmd_page(*pvmw->pmd) != page)
-				return not_found(pvmw);
-			return true;
-		} else if (!pmd_present(*pvmw->pmd)) {
-			if (thp_migration_supported()) {
-				if (!(pvmw->flags & PVMW_MIGRATION))
+	end = PageTransCompound(page) ?
+		vma_address_end(page, pvmw->vma) :
+		pvmw->address + PAGE_SIZE;
+	if (pvmw->pte)
+		goto next_pte;
+restart:
+	do {
+		pgd = pgd_offset(mm, pvmw->address);
+		if (!pgd_present(*pgd)) {
+			step_forward(pvmw, PGDIR_SIZE);
+			continue;
+		}
+		p4d = p4d_offset(pgd, pvmw->address);
+		if (!p4d_present(*p4d)) {
+			step_forward(pvmw, P4D_SIZE);
+			continue;
+		}
+		pud = pud_offset(p4d, pvmw->address);
+		if (!pud_present(*pud)) {
+			step_forward(pvmw, PUD_SIZE);
+			continue;
+		}
+
+		pvmw->pmd = pmd_offset(pud, pvmw->address);
+		/*
+		 * Make sure the pmd value isn't cached in a register by the
+		 * compiler and used as a stale value after we've observed a
+		 * subsequent update.
+		 */
+		pmde = READ_ONCE(*pvmw->pmd);
+
+		if (pmd_trans_huge(pmde) || is_pmd_migration_entry(pmde)) {
+			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
+			pmde = *pvmw->pmd;
+			if (likely(pmd_trans_huge(pmde))) {
+				if (pvmw->flags & PVMW_MIGRATION)
+					return not_found(pvmw);
+				if (pmd_page(pmde) != page)
 					return not_found(pvmw);
-				if (is_migration_entry(pmd_to_swp_entry(*pvmw->pmd))) {
-					swp_entry_t entry = pmd_to_swp_entry(*pvmw->pmd);
+				return true;
+			}
+			if (!pmd_present(pmde)) {
+				swp_entry_t entry;
 
-					if (migration_entry_to_page(entry) != page)
-						return not_found(pvmw);
-					return true;
-				}
+				if (!thp_migration_supported() ||
+				    !(pvmw->flags & PVMW_MIGRATION))
+					return not_found(pvmw);
+				entry = pmd_to_swp_entry(pmde);
+				if (!is_migration_entry(entry) ||
+				    migration_entry_to_page(entry) != page)
+					return not_found(pvmw);
+				return true;
 			}
-			return not_found(pvmw);
-		} else {
 			/* THP pmd was split under us: handle on pte level */
 			spin_unlock(pvmw->ptl);
 			pvmw->ptl = NULL;
+		} else if (!pmd_present(pmde)) {
+			/*
+			 * If PVMW_SYNC, take and drop THP pmd lock so that we
+			 * cannot return prematurely, while zap_huge_pmd() has
+			 * cleared *pmd but not decremented compound_mapcount().
+			 */
+			if ((pvmw->flags & PVMW_SYNC) &&
+			    PageTransCompound(page)) {
+				spinlock_t *ptl = pmd_lock(mm, pvmw->pmd);
+
+				spin_unlock(ptl);
+			}
+			step_forward(pvmw, PMD_SIZE);
+			continue;
 		}
-	} else if (!pmd_present(pmde)) {
-		return false;
-	}
-	if (!map_pte(pvmw))
-		goto next_pte;
-	while (1) {
+		if (!map_pte(pvmw))
+			goto next_pte;
+this_pte:
 		if (check_pte(pvmw))
 			return true;
 next_pte:
-		/* Seek to next pte only makes sense for THP */
-		if (!PageTransHuge(pvmw->page) || PageHuge(pvmw->page))
-			return not_found(pvmw);
 		do {
 			pvmw->address += PAGE_SIZE;
-			if (pvmw->address >= pvmw->vma->vm_end ||
-			    pvmw->address >=
-					__vma_address(pvmw->page, pvmw->vma) +
-					hpage_nr_pages(pvmw->page) * PAGE_SIZE)
+			if (pvmw->address >= end)
 				return not_found(pvmw);
 			/* Did we cross page table boundary? */
-			if (pvmw->address % PMD_SIZE == 0) {
-				pte_unmap(pvmw->pte);
+			if ((pvmw->address & (PMD_SIZE - PAGE_SIZE)) == 0) {
 				if (pvmw->ptl) {
 					spin_unlock(pvmw->ptl);
 					pvmw->ptl = NULL;
 				}
+				pte_unmap(pvmw->pte);
+				pvmw->pte = NULL;
 				goto restart;
-			} else {
-				pvmw->pte++;
+			}
+			pvmw->pte++;
+			if ((pvmw->flags & PVMW_SYNC) && !pvmw->ptl) {
+				pvmw->ptl = pte_lockptr(mm, pvmw->pmd);
+				spin_lock(pvmw->ptl);
 			}
 		} while (pte_none(*pvmw->pte));
 
@@ -242,7 +281,10 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			pvmw->ptl = pte_lockptr(mm, pvmw->pmd);
 			spin_lock(pvmw->ptl);
 		}
-	}
+		goto this_pte;
+	} while (pvmw->address < end);
+
+	return false;
 }
 
 /**
@@ -261,14 +303,10 @@ int page_mapped_in_vma(struct page *page, struct vm_area_struct *vma)
 		.vma = vma,
 		.flags = PVMW_SYNC,
 	};
-	unsigned long start, end;
-
-	start = __vma_address(page, vma);
-	end = start + PAGE_SIZE * (hpage_nr_pages(page) - 1);
 
-	if (unlikely(end < vma->vm_start || start >= vma->vm_end))
+	pvmw.address = vma_address(page, vma);
+	if (pvmw.address == -EFAULT)
 		return 0;
-	pvmw.address = max(start, vma->vm_start);
 	if (!page_vma_mapped_walk(&pvmw))
 		return 0;
 	page_vma_mapped_walk_done(&pvmw);
diff --git a/mm/rmap.c b/mm/rmap.c
index 8bd2ddd8febd..8ed8ec113d5a 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -686,7 +686,6 @@ static bool should_defer_flush(struct mm_struct *mm, enum ttu_flags flags)
  */
 unsigned long page_address_in_vma(struct page *page, struct vm_area_struct *vma)
 {
-	unsigned long address;
 	if (PageAnon(page)) {
 		struct anon_vma *page__anon_vma = page_anon_vma(page);
 		/*
@@ -696,15 +695,13 @@ unsigned long page_address_in_vma(struct page *page, struct vm_area_struct *vma)
 		if (!vma->anon_vma || !page__anon_vma ||
 		    vma->anon_vma->root != page__anon_vma->root)
 			return -EFAULT;
-	} else if (page->mapping) {
-		if (!vma->vm_file || vma->vm_file->f_mapping != page->mapping)
-			return -EFAULT;
-	} else
+	} else if (!vma->vm_file) {
 		return -EFAULT;
-	address = __vma_address(page, vma);
-	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
+	} else if (vma->vm_file->f_mapping != compound_head(page)->mapping) {
 		return -EFAULT;
-	return address;
+	}
+
+	return vma_address(page, vma);
 }
 
 pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address)
@@ -896,7 +893,7 @@ static bool page_mkclean_one(struct page *page, struct vm_area_struct *vma,
 	 * We have to assume the worse case ie pmd for invalidation. Note that
 	 * the page can not be free from this function.
 	 */
-	end = min(vma->vm_end, start + (PAGE_SIZE << compound_order(page)));
+	end = vma_address_end(page, vma);
 	mmu_notifier_invalidate_range_start(vma->vm_mm, start, end);
 
 	while (page_vma_mapped_walk(&pvmw)) {
@@ -1344,6 +1341,15 @@ static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 	unsigned long start = address, end;
 	enum ttu_flags flags = (enum ttu_flags)arg;
 
+	/*
+	 * When racing against e.g. zap_pte_range() on another cpu,
+	 * in between its ptep_get_and_clear_full() and page_remove_rmap(),
+	 * try_to_unmap() may return false when it is about to become true,
+	 * if page table locking is skipped: use TTU_SYNC to wait for that.
+	 */
+	if (flags & TTU_SYNC)
+		pvmw.flags = PVMW_SYNC;
+
 	/* munlock has nothing to gain from examining un-locked vmas */
 	if ((flags & TTU_MUNLOCK) && !(vma->vm_flags & VM_LOCKED))
 		return true;
@@ -1365,7 +1371,8 @@ static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 	 * Note that the page can not be free in this function as call of
 	 * try_to_unmap() must hold a reference on the page.
 	 */
-	end = min(vma->vm_end, start + (PAGE_SIZE << compound_order(page)));
+	end = PageKsm(page) ?
+			address + PAGE_SIZE : vma_address_end(page, vma);
 	if (PageHuge(page)) {
 		/*
 		 * If sharing is possible, start and end will be adjusted
@@ -1624,9 +1631,9 @@ static bool invalid_migration_vma(struct vm_area_struct *vma, void *arg)
 	return is_vma_temporary_stack(vma);
 }
 
-static int page_mapcount_is_zero(struct page *page)
+static int page_not_mapped(struct page *page)
 {
-	return !total_mapcount(page);
+	return !page_mapped(page);
 }
 
 /**
@@ -1644,7 +1651,7 @@ bool try_to_unmap(struct page *page, enum ttu_flags flags)
 	struct rmap_walk_control rwc = {
 		.rmap_one = try_to_unmap_one,
 		.arg = (void *)flags,
-		.done = page_mapcount_is_zero,
+		.done = page_not_mapped,
 		.anon_lock = page_lock_anon_vma_read,
 	};
 
@@ -1665,14 +1672,15 @@ bool try_to_unmap(struct page *page, enum ttu_flags flags)
 	else
 		rmap_walk(page, &rwc);
 
-	return !page_mapcount(page) ? true : false;
+	/*
+	 * When racing against e.g. zap_pte_range() on another cpu,
+	 * in between its ptep_get_and_clear_full() and page_remove_rmap(),
+	 * try_to_unmap() may return false when it is about to become true,
+	 * if page table locking is skipped: use TTU_SYNC to wait for that.
+	 */
+	return !page_mapcount(page);
 }
 
-static int page_not_mapped(struct page *page)
-{
-	return !page_mapped(page);
-};
-
 /**
  * try_to_munlock - try to munlock a page
  * @page: the page to be munlocked
@@ -1767,6 +1775,7 @@ static void rmap_walk_anon(struct page *page, struct rmap_walk_control *rwc,
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(page, vma);
 
+		VM_BUG_ON_VMA(address == -EFAULT, vma);
 		cond_resched();
 
 		if (rwc->invalid_vma && rwc->invalid_vma(vma, rwc->arg))
@@ -1821,6 +1830,7 @@ static void rmap_walk_file(struct page *page, struct rmap_walk_control *rwc,
 			pgoff_start, pgoff_end) {
 		unsigned long address = vma_address(page, vma);
 
+		VM_BUG_ON_VMA(address == -EFAULT, vma);
 		cond_resched();
 
 		if (rwc->invalid_vma && rwc->invalid_vma(vma, rwc->arg))
