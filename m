Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8210B22A4DE
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 03:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387564AbgGWBtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 21:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729198AbgGWBtV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jul 2020 21:49:21 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147D7C0619DC;
        Wed, 22 Jul 2020 18:49:21 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id z3so2188275pfn.12;
        Wed, 22 Jul 2020 18:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=X9S60bF0x51rzQ7ntN8JyfNKAz6dUEkcZzUI5TDgG14=;
        b=MBBm7WTUiiOuCsPTJp5qo0K1GbLaB89bzPkBXSPYX/unc9HQ6lER8kiS0jp1MhztU0
         IGN3vx1Wtj5GtUzWgR+NiFfNfTbshxdpZk623F22NIU0FdVrhauvGfOfIZ4iM14wBLi/
         ocKCOfdAJHSYWDqlOX5JF7S/tvHw4/2m2l0oUNKN1+znt3lJ+P3MgnKi8yXz0YTME93X
         oxLjlaYKDNqA1+MkcRzq2V/tn4f6dNanDlqYz51YdM7K2FeiSC5I6kKvWu0GtLhzZGn4
         MbmNNotScBjEn5KbFVe/YgoRf3samtMhzDh0v43EiYhDtHeM/vS4Em7EQdtedgbZbVR0
         JnTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=X9S60bF0x51rzQ7ntN8JyfNKAz6dUEkcZzUI5TDgG14=;
        b=e0giBiWVchFRR9cjM7dE+OInlJGsZgrhoRvNcBPCWrXJf/uK5yaoxYcxk69h0ny0tR
         0Hr9KH3xqbXyR+t0w0CP3APXobFhVY3l53AoPmJ8ayBWEPRpdvzGDT6xhhEID3Tab8Mn
         BowR/K9p5cm+r1UhxkXf1weTot16orwGIJRlaQERI3HIr9Y3crr1+361N6++85X9JX8u
         mnz1g3Z5b46auPvElXok9UpRLTHH1ntNfjoT0vy8TDUD1K1xkqDW7T2+3Zrl8vsvv+mV
         QILsmUaFHhluPCmZ8JancpE7GpDeAsqFuBpKIL7HGWsahy9sF+RbvT08TZA68DXPkUeJ
         BVgA==
X-Gm-Message-State: AOAM532klMlbCXATBkxMhCCaIHCRkrUAC2SwlVDxHQPJy2PwqB4VVgN6
        0K+Ms8mzo0gF01LMIZ4TRx0=
X-Google-Smtp-Source: ABdhPJxw8gNAXkDEm7OnN1Hxgg9MIjdh0ViCYejDRxXLj8oyxSUEvvLIef7rU4EjsH8L63vVeweoKA==
X-Received: by 2002:a62:7650:: with SMTP id r77mr2058875pfc.235.1595468960492;
        Wed, 22 Jul 2020 18:49:20 -0700 (PDT)
Received: from localhost.localdomain ([114.206.198.176])
        by smtp.gmail.com with ESMTPSA id e18sm887210pff.37.2020.07.22.18.49.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jul 2020 18:49:20 -0700 (PDT)
From:   js1304@gmail.com
X-Google-Original-From: iamjoonsoo.kim@lge.com
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kernel-team@lge.com, Vlastimil Babka <vbabka@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Roman Gushchin <guro@fb.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Michal Hocko <mhocko@suse.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, stable@vger.kernel.org
Subject: [PATCH v2] mm/page_alloc: fix memalloc_nocma_{save/restore} APIs
Date:   Thu, 23 Jul 2020 10:49:02 +0900
Message-Id: <1595468942-29687-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>

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

Fixes: d7fefcc8de91 (mm/cma: add PF flag to force non cma alloc)
Cc: <stable@vger.kernel.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 include/linux/sched/mm.h |  8 +-------
 mm/page_alloc.c          | 31 +++++++++++++++++++++----------
 2 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 480a4d1..17e0c31 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -177,12 +177,10 @@ static inline bool in_vfork(struct task_struct *tsk)
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
@@ -191,10 +189,6 @@ static inline gfp_t current_gfp_context(gfp_t flags)
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
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e028b87c..7336e94 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2790,7 +2790,7 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
 	 * allocating from CMA when over half of the zone's free memory
 	 * is in the CMA area.
 	 */
-	if (migratetype == MIGRATE_MOVABLE &&
+	if (alloc_flags & ALLOC_CMA &&
 	    zone_page_state(zone, NR_FREE_CMA_PAGES) >
 	    zone_page_state(zone, NR_FREE_PAGES) / 2) {
 		page = __rmqueue_cma_fallback(zone, order);
@@ -2801,7 +2801,7 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
 retry:
 	page = __rmqueue_smallest(zone, order, migratetype);
 	if (unlikely(!page)) {
-		if (migratetype == MIGRATE_MOVABLE)
+		if (alloc_flags & ALLOC_CMA)
 			page = __rmqueue_cma_fallback(zone, order);
 
 		if (!page && __rmqueue_fallback(zone, order, migratetype,
@@ -3671,6 +3671,20 @@ alloc_flags_nofragment(struct zone *zone, gfp_t gfp_mask)
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
 
@@ -4620,7 +4632,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 
 	reserve_flags = __gfp_pfmemalloc_flags(gfp_mask);
 	if (reserve_flags)
-		alloc_flags = reserve_flags;
+		alloc_flags = current_alloc_flags(gfp_mask, reserve_flags);
 
 	/*
 	 * Reset the nodemask and zonelist iterators if memory policies can be
@@ -4697,7 +4709,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 
 	/* Avoid allocations with no watermarks from looping endlessly */
 	if (tsk_is_oom_victim(current) &&
-	    (alloc_flags == ALLOC_OOM ||
+	    (alloc_flags & ALLOC_OOM ||
 	     (gfp_mask & __GFP_NOMEMALLOC)))
 		goto nopage;
 
@@ -4785,8 +4797,7 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 	if (should_fail_alloc_page(gfp_mask, order))
 		return false;
 
-	if (IS_ENABLED(CONFIG_CMA) && ac->migratetype == MIGRATE_MOVABLE)
-		*alloc_flags |= ALLOC_CMA;
+	*alloc_flags = current_alloc_flags(gfp_mask, *alloc_flags);
 
 	return true;
 }
-- 
2.7.4

