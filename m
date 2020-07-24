Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D618B22BB3D
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 03:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgGXBJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 21:09:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgGXBJX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jul 2020 21:09:23 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B730D206E3;
        Fri, 24 Jul 2020 01:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595552962;
        bh=VYerg0e2jfIqkZo61wO/U33twbFV3GGfUEhU16v6fFA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kS39KwM32cz6NzYAh2V8jLuVaJ2tF6HJ6Crj++orxT9ZBLM+EAo96y4pit4F4J1iN
         s/sulHm9ltAbONkdJscu/OBRMmRzHlCfB7k+z8oEMA3cI62YCfBjeSOd/3q2KZqbBu
         D7KC8h/3U8KYNXFKRqH0U+H1SHJBEV4Qy4oKEsYw=
Date:   Thu, 23 Jul 2020 18:09:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aneesh.kumar@linux.ibm.com, guro@fb.com, hch@infradead.org,
        iamjoonsoo.kim@lge.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        stable@vger.kernel.org, vbabka@suse.cz
Subject:  +
 mm-page_alloc-fix-memalloc_nocma_save-restore-apis.patch added to -mm tree
Message-ID: <20200724010921.x2GaU8ONd%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: fix memalloc_nocma_{save/restore} APIs
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fix-memalloc_nocma_save-restore-apis.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fix-memalloc_nocma_save-restore-apis.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fix-memalloc_nocma_save-restore-apis.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: js1304@gmail.com
Subject: mm/page_alloc: fix memalloc_nocma_{save/restore} APIs


Currently, memalloc_nocma_{save/restore} API that prevents CMA area
in page allocation is implemented by using current_gfp_context(). However,
there are two problems of this implementation.

First, this doesn't work for allocation fastpath. In the fastpath,
original gfp_mask is used since current_gfp_context() is introduced in
order to control reclaim and it is on slowpath. So, CMA area can be
allocated through the allocation fastpath even if
memalloc_nocma_{save/restore} APIs are used. Currently, there is just
one user for these APIs and it has a fallback method to prevent actual
problem.
Second, clearing __GFP_MOVABLE in current_gfp_context() has a side effect
to exclude the memory on the ZONE_MOVABLE for allocation target.

To fix these problems, this patch changes the implementation to exclude
CMA area in page allocation. Main point of this change is using the
alloc_flags. alloc_flags is mainly used to control allocation so it fits
for excluding CMA area in allocation.

Link: http://lkml.kernel.org/r/1595468942-29687-1-git-send-email-iamjoonsoo.kim@lge.com
Fixes: d7fefcc8de91 (mm/cma: add PF flag to force non cma alloc)
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/mm.h |    8 +-------
 mm/page_alloc.c          |   31 +++++++++++++++++++++----------
 2 files changed, 22 insertions(+), 17 deletions(-)

--- a/include/linux/sched/mm.h~mm-page_alloc-fix-memalloc_nocma_save-restore-apis
+++ a/include/linux/sched/mm.h
@@ -177,12 +177,10 @@ static inline bool in_vfork(struct task_
  * Applies per-task gfp context to the given allocation flags.
  * PF_MEMALLOC_NOIO implies GFP_NOIO
  * PF_MEMALLOC_NOFS implies GFP_NOFS
- * PF_MEMALLOC_NOCMA implies no allocation from CMA region.
  */
 static inline gfp_t current_gfp_context(gfp_t flags)
 {
-	if (unlikely(current->flags &
-		     (PF_MEMALLOC_NOIO | PF_MEMALLOC_NOFS | PF_MEMALLOC_NOCMA))) {
+	if (unlikely(current->flags & (PF_MEMALLOC_NOIO | PF_MEMALLOC_NOFS))) {
 		/*
 		 * NOIO implies both NOIO and NOFS and it is a weaker context
 		 * so always make sure it makes precedence
@@ -191,10 +189,6 @@ static inline gfp_t current_gfp_context(
 			flags &= ~(__GFP_IO | __GFP_FS);
 		else if (current->flags & PF_MEMALLOC_NOFS)
 			flags &= ~__GFP_FS;
-#ifdef CONFIG_CMA
-		if (current->flags & PF_MEMALLOC_NOCMA)
-			flags &= ~__GFP_MOVABLE;
-#endif
 	}
 	return flags;
 }
--- a/mm/page_alloc.c~mm-page_alloc-fix-memalloc_nocma_save-restore-apis
+++ a/mm/page_alloc.c
@@ -2790,7 +2790,7 @@ __rmqueue(struct zone *zone, unsigned in
 	 * allocating from CMA when over half of the zone's free memory
 	 * is in the CMA area.
 	 */
-	if (migratetype == MIGRATE_MOVABLE &&
+	if (alloc_flags & ALLOC_CMA &&
 	    zone_page_state(zone, NR_FREE_CMA_PAGES) >
 	    zone_page_state(zone, NR_FREE_PAGES) / 2) {
 		page = __rmqueue_cma_fallback(zone, order);
@@ -2801,7 +2801,7 @@ __rmqueue(struct zone *zone, unsigned in
 retry:
 	page = __rmqueue_smallest(zone, order, migratetype);
 	if (unlikely(!page)) {
-		if (migratetype == MIGRATE_MOVABLE)
+		if (alloc_flags & ALLOC_CMA)
 			page = __rmqueue_cma_fallback(zone, order);
 
 		if (!page && __rmqueue_fallback(zone, order, migratetype,
@@ -3671,6 +3671,20 @@ alloc_flags_nofragment(struct zone *zone
 	return alloc_flags;
 }
 
+static inline unsigned int current_alloc_flags(gfp_t gfp_mask,
+					unsigned int alloc_flags)
+{
+#ifdef CONFIG_CMA
+	unsigned int pflags = current->flags;
+
+	if (!(pflags & PF_MEMALLOC_NOCMA) &&
+			gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
+		alloc_flags |= ALLOC_CMA;
+
+#endif
+	return alloc_flags;
+}
+
 /*
  * get_page_from_freelist goes through the zonelist trying to allocate
  * a page.
@@ -4316,10 +4330,8 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	} else if (unlikely(rt_task(current)) && !in_interrupt())
 		alloc_flags |= ALLOC_HARDER;
 
-#ifdef CONFIG_CMA
-	if (gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
-		alloc_flags |= ALLOC_CMA;
-#endif
+	alloc_flags = current_alloc_flags(gfp_mask, alloc_flags);
+
 	return alloc_flags;
 }
 
@@ -4620,7 +4632,7 @@ retry:
 
 	reserve_flags = __gfp_pfmemalloc_flags(gfp_mask);
 	if (reserve_flags)
-		alloc_flags = reserve_flags;
+		alloc_flags = current_alloc_flags(gfp_mask, reserve_flags);
 
 	/*
 	 * Reset the nodemask and zonelist iterators if memory policies can be
@@ -4697,7 +4709,7 @@ retry:
 
 	/* Avoid allocations with no watermarks from looping endlessly */
 	if (tsk_is_oom_victim(current) &&
-	    (alloc_flags == ALLOC_OOM ||
+	    (alloc_flags & ALLOC_OOM ||
 	     (gfp_mask & __GFP_NOMEMALLOC)))
 		goto nopage;
 
@@ -4785,8 +4797,7 @@ static inline bool prepare_alloc_pages(g
 	if (should_fail_alloc_page(gfp_mask, order))
 		return false;
 
-	if (IS_ENABLED(CONFIG_CMA) && ac->migratetype == MIGRATE_MOVABLE)
-		*alloc_flags |= ALLOC_CMA;
+	*alloc_flags = current_alloc_flags(gfp_mask, *alloc_flags);
 
 	return true;
 }
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-page_alloc-fix-memalloc_nocma_save-restore-apis.patch
mm-vmscan-make-active-inactive-ratio-as-1-1-for-anon-lru.patch
mm-vmscan-protect-the-workingset-on-anonymous-lru.patch
mm-workingset-prepare-the-workingset-detection-infrastructure-for-anon-lru.patch
mm-swapcache-support-to-handle-the-shadow-entries.patch
mm-swap-implement-workingset-detection-for-anonymous-lru.patch
mm-vmscan-restore-active-inactive-ratio-for-anonymous-lru.patch
mm-page_isolation-prefer-the-node-of-the-source-page.patch
mm-migrate-move-migration-helper-from-h-to-c.patch
mm-hugetlb-unify-migration-callbacks.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations.patch
mm-migrate-make-a-standard-migration-target-allocation-function.patch
mm-mempolicy-use-a-standard-migration-target-allocation-callback.patch
mm-page_alloc-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory-failure-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory_hotplug-remove-a-wrapper-for-alloc_migration_target.patch

