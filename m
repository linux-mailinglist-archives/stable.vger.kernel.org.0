Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898C82256D6
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 06:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgGTE4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 00:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgGTE4k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 00:56:40 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCAE5C0619D2;
        Sun, 19 Jul 2020 21:56:39 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t15so9441053pjq.5;
        Sun, 19 Jul 2020 21:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7XZ1yiqOe35kdakB9GHkuYUBhfbDIazTMpdsBAOBGI0=;
        b=D9b+hil/EKWi01z92dGYgM6Eg+Mn4eCSB4sU2gUcjvSoLURm2g4sMSlO9XBsxrtnJd
         RiF1EKePVVGQdkf93QLDfgtoTpf5z6dz3qJb3ghPtkDy+yVAl+FM6vX/6EdmySSndNze
         ezVSIfU/lpRHMjnH3gO9x54exLrN/G4f20Rp6p2/FwSehf+No/kJfQZ2ayWGs388Q6v6
         tJd7lGNAD25oPVOIaLXlyln1BgNNJGjxnlua/8MM2ONEBiBrUThTsfzIFfO1WGW0OnHy
         YL9Mbh+UMAW4X+jpY/kJQL48RG2gznH/PJqngLepfPHZLAP+K1cFxdUPtPwwjBWKFnQt
         cG+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7XZ1yiqOe35kdakB9GHkuYUBhfbDIazTMpdsBAOBGI0=;
        b=pNa+/0yu1+rb+iu8i8s8I//k/jXh5EPj6kt8iQFA5u/jwiGlhpG6bmYYBvCUyUiNBT
         BnWzXE+S91IrEtdq3z0OZWIjKqUWSUcaBHlAc7Op71+bk8sUnBhAbzZj6n+wF4qeEsKx
         7/cCZa5mIYq1fjrfQybAmeFcD2wQXmLDcO7ljNBdJ58W9dv7gzMcMSgmGsc7jGfSFFQr
         uaK9k8bZVa7rGAIP6EC/oSP341/ERutO1mF0zWtLms5X4QQlhl+YZwUD4VjC8Ho+7cyX
         RZ4EcLt9aF2Pvk+x5bBhtA7Zgm+Ah0fYOYKrhG9VEu02dlz1KjD9j9aJDiRPiDBVVN5R
         tc/w==
X-Gm-Message-State: AOAM531la56UjDS6OrLHY+X/x2fHcH6dWMAfQPzpPpU2bABS1Vu2pTGt
        flFNF3yq8OOgYnNFhCx0EY4=
X-Google-Smtp-Source: ABdhPJw8THXmkyFCDT/i9W2aRFTHs5f9KUIt1uCRbuMq10MITpRPoLEtr70zOcUIblItW9btiHf4WQ==
X-Received: by 2002:a17:90b:19cc:: with SMTP id nm12mr21886955pjb.144.1595220999277;
        Sun, 19 Jul 2020 21:56:39 -0700 (PDT)
Received: from localhost.localdomain ([114.206.198.176])
        by smtp.gmail.com with ESMTPSA id w2sm10177532pjt.19.2020.07.19.21.56.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 19 Jul 2020 21:56:38 -0700 (PDT)
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
Subject: [PATCH v2 1/4] mm/page_alloc: fix non cma alloc context
Date:   Mon, 20 Jul 2020 13:56:15 +0900
Message-Id: <1595220978-9890-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Currently, preventing cma area in page allocation is implemented by using
current_gfp_context(). However, there are two problems of this
implementation.

First, this doesn't work for allocation fastpath. In the fastpath,
original gfp_mask is used since current_gfp_context() is introduced in
order to control reclaim and it is on slowpath.
Second, clearing __GFP_MOVABLE has a side effect to exclude the memory
on the ZONE_MOVABLE for allocation target.

To fix these problems, this patch changes the implementation to exclude
cma area in page allocation. Main point of this change is using the
alloc_flags. alloc_flags is mainly used to control allocation so it fits
for excluding cma area in allocation.

Fixes: d7fefcc8de91 (mm/cma: add PF flag to force non cma alloc)
Cc: <stable@vger.kernel.org>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 include/linux/sched/mm.h |  8 +-------
 mm/page_alloc.c          | 37 ++++++++++++++++++++++++-------------
 2 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 44ad5b7..6c652ec 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -175,14 +175,12 @@ static inline bool in_vfork(struct task_struct *tsk)
  * Applies per-task gfp context to the given allocation flags.
  * PF_MEMALLOC_NOIO implies GFP_NOIO
  * PF_MEMALLOC_NOFS implies GFP_NOFS
- * PF_MEMALLOC_NOCMA implies no allocation from CMA region.
  */
 static inline gfp_t current_gfp_context(gfp_t flags)
 {
 	unsigned int pflags = READ_ONCE(current->flags);
 
-	if (unlikely(pflags &
-		     (PF_MEMALLOC_NOIO | PF_MEMALLOC_NOFS | PF_MEMALLOC_NOCMA))) {
+	if (unlikely(pflags & (PF_MEMALLOC_NOIO | PF_MEMALLOC_NOFS))) {
 		/*
 		 * NOIO implies both NOIO and NOFS and it is a weaker context
 		 * so always make sure it makes precedence
@@ -191,10 +189,6 @@ static inline gfp_t current_gfp_context(gfp_t flags)
 			flags &= ~(__GFP_IO | __GFP_FS);
 		else if (pflags & PF_MEMALLOC_NOFS)
 			flags &= ~__GFP_FS;
-#ifdef CONFIG_CMA
-		if (pflags & PF_MEMALLOC_NOCMA)
-			flags &= ~__GFP_MOVABLE;
-#endif
 	}
 	return flags;
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6416d08..b529220 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2791,7 +2791,7 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
 	 * allocating from CMA when over half of the zone's free memory
 	 * is in the CMA area.
 	 */
-	if (migratetype == MIGRATE_MOVABLE &&
+	if (alloc_flags & ALLOC_CMA &&
 	    zone_page_state(zone, NR_FREE_CMA_PAGES) >
 	    zone_page_state(zone, NR_FREE_PAGES) / 2) {
 		page = __rmqueue_cma_fallback(zone, order);
@@ -2802,7 +2802,7 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
 retry:
 	page = __rmqueue_smallest(zone, order, migratetype);
 	if (unlikely(!page)) {
-		if (migratetype == MIGRATE_MOVABLE)
+		if (alloc_flags & ALLOC_CMA)
 			page = __rmqueue_cma_fallback(zone, order);
 
 		if (!page && __rmqueue_fallback(zone, order, migratetype,
@@ -3502,11 +3502,9 @@ static inline long __zone_watermark_unusable_free(struct zone *z,
 	if (likely(!alloc_harder))
 		unusable_free += z->nr_reserved_highatomic;
 
-#ifdef CONFIG_CMA
 	/* If allocation can't use CMA areas don't use free CMA pages */
-	if (!(alloc_flags & ALLOC_CMA))
+	if (IS_ENABLED(CONFIG_CMA) && !(alloc_flags & ALLOC_CMA))
 		unusable_free += zone_page_state(z, NR_FREE_CMA_PAGES);
-#endif
 
 	return unusable_free;
 }
@@ -3693,6 +3691,20 @@ alloc_flags_nofragment(struct zone *zone, gfp_t gfp_mask)
 	return alloc_flags;
 }
 
+static inline unsigned int current_alloc_flags(gfp_t gfp_mask,
+					unsigned int alloc_flags)
+{
+#ifdef CONFIG_CMA
+	unsigned int pflags = current->flags;
+
+	if (!(pflags & PF_MEMALLOC_NOCMA) &&
+		gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
+		alloc_flags |= ALLOC_CMA;
+
+#endif
+	return alloc_flags;
+}
+
 /*
  * get_page_from_freelist goes through the zonelist trying to allocate
  * a page.
@@ -4339,10 +4351,8 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
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
 
@@ -4642,8 +4652,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 		wake_all_kswapds(order, gfp_mask, ac);
 
 	reserve_flags = __gfp_pfmemalloc_flags(gfp_mask);
-	if (reserve_flags)
+	if (reserve_flags) {
 		alloc_flags = reserve_flags;
+		alloc_flags = current_alloc_flags(gfp_mask, alloc_flags);
+	}
 
 	/*
 	 * Reset the nodemask and zonelist iterators if memory policies can be
@@ -4720,7 +4732,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 
 	/* Avoid allocations with no watermarks from looping endlessly */
 	if (tsk_is_oom_victim(current) &&
-	    (alloc_flags == ALLOC_OOM ||
+	    (alloc_flags & ALLOC_OOM ||
 	     (gfp_mask & __GFP_NOMEMALLOC)))
 		goto nopage;
 
@@ -4808,8 +4820,7 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 	if (should_fail_alloc_page(gfp_mask, order))
 		return false;
 
-	if (IS_ENABLED(CONFIG_CMA) && ac->migratetype == MIGRATE_MOVABLE)
-		*alloc_flags |= ALLOC_CMA;
+	*alloc_flags = current_alloc_flags(gfp_mask, *alloc_flags);
 
 	return true;
 }
-- 
2.7.4

