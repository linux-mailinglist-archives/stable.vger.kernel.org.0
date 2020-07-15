Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4437C220430
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 07:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgGOFFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 01:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgGOFFp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 01:05:45 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A852EC061755;
        Tue, 14 Jul 2020 22:05:45 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ls15so2427706pjb.1;
        Tue, 14 Jul 2020 22:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=z+wv8TGtFVQ1hlwrfyzpVwymGKMjlXdbSWkQQF4iJxI=;
        b=mVdrq8+UEYotcCGr+EDqNcpyWzyi3Tj+1an8oO/wgzzahQj8FEchq3rg5A6emWKwin
         bdpUO4taDuCCYFVROBKfbHlaZ5rFUFY5v89yvkVhm/t+WPA4P7zGZoIRufJvUdDO9hBt
         J3w2XHcwQgBQgNLMB/dqJqCW5F768LhYctTWl+qvaMu6M/nNWMsnC/AkmZj4cBtK96ir
         4ApDGo+FIPCh/F303Cjjxli3Aeo6r/F2pSFbogYpQDIYYR9R2j2jWIa63j/nvXn6X8Zx
         VQq9E4roHRDNlTHNiwt9v5bHL+Yv02VbmNBosu/MHVi8kfYb0cG7vbvM/b+MFHM9mJik
         RoGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=z+wv8TGtFVQ1hlwrfyzpVwymGKMjlXdbSWkQQF4iJxI=;
        b=o3R506+zkRDvjtmNg3kp1x7YRMUD6FnCj/aa8MR2aP1DSpu8JfKrTy5Zq5jROSWuDW
         evhbxZwvr/G1rIOuAw5CldLpKe6yKSTBi/xOysXEal17LPPOmtGBAXVP6SMm+R1oXQu7
         j5QcPu4my090ZX/dUZTIRLTkxwRxXsH0dlWlNnPEGP5TftsOdiaanNkTTJT2hprfEJx8
         XkSOepyB4vlphJhTKPyW73KwNO/KoHZZihVjBKc/1o1m8yDcd3AYqAsW0ud8Bp+xyu6S
         GLdmdqrk5n+D5bR2/imz1nxSNRtiCSyIJkcutYQ5vXkQALyi7PoBPoegnbGvOd28WaOZ
         e6Xg==
X-Gm-Message-State: AOAM531lxLHfVxYtY2+BRcWMFD1nYovBV6i733YsJ8wmsSi0rNrrwmEw
        BSXZcsBw4JVQ11NRCHLIXRyRa81a
X-Google-Smtp-Source: ABdhPJza7Rlli4ZIDhwyoO76GHLo1Ah2DCPstIOcYT7GHUj3pMDr9aKgEtz17O8TCQIjcamlkOFgiw==
X-Received: by 2002:a17:90b:3612:: with SMTP id ml18mr8160176pjb.193.1594789544814;
        Tue, 14 Jul 2020 22:05:44 -0700 (PDT)
Received: from localhost.localdomain ([114.206.198.176])
        by smtp.gmail.com with ESMTPSA id i21sm747251pfa.18.2020.07.14.22.05.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jul 2020 22:05:44 -0700 (PDT)
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
Subject: [PATCH 1/4] mm/page_alloc: fix non cma alloc context
Date:   Wed, 15 Jul 2020 14:05:26 +0900
Message-Id: <1594789529-6206-1-git-send-email-iamjoonsoo.kim@lge.com>
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

Fixes: d7fefcc (mm/cma: add PF flag to force non cma alloc)
Cc: <stable@vger.kernel.org>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 include/linux/sched/mm.h |  4 ----
 mm/page_alloc.c          | 27 +++++++++++++++------------
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 44ad5b7..a73847a 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -191,10 +191,6 @@ static inline gfp_t current_gfp_context(gfp_t flags)
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
index 6416d08..cd53894 100644
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
@@ -3693,6 +3691,16 @@ alloc_flags_nofragment(struct zone *zone, gfp_t gfp_mask)
 	return alloc_flags;
 }
 
+static inline void current_alloc_flags(gfp_t gfp_mask,
+				unsigned int *alloc_flags)
+{
+	unsigned int pflags = READ_ONCE(current->flags);
+
+	if (!(pflags & PF_MEMALLOC_NOCMA) &&
+		gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
+		*alloc_flags |= ALLOC_CMA;
+}
+
 /*
  * get_page_from_freelist goes through the zonelist trying to allocate
  * a page.
@@ -3706,6 +3714,8 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 	struct pglist_data *last_pgdat_dirty_limit = NULL;
 	bool no_fallback;
 
+	current_alloc_flags(gfp_mask, &alloc_flags);
+
 retry:
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
@@ -4339,10 +4349,6 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	} else if (unlikely(rt_task(current)) && !in_interrupt())
 		alloc_flags |= ALLOC_HARDER;
 
-#ifdef CONFIG_CMA
-	if (gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
-		alloc_flags |= ALLOC_CMA;
-#endif
 	return alloc_flags;
 }
 
@@ -4808,9 +4814,6 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 	if (should_fail_alloc_page(gfp_mask, order))
 		return false;
 
-	if (IS_ENABLED(CONFIG_CMA) && ac->migratetype == MIGRATE_MOVABLE)
-		*alloc_flags |= ALLOC_CMA;
-
 	return true;
 }
 
-- 
2.7.4

