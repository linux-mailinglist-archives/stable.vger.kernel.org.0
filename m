Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71FDE3F2491
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 04:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236038AbhHTCE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 22:04:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234428AbhHTCE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Aug 2021 22:04:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6102261056;
        Fri, 20 Aug 2021 02:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629425061;
        bh=/aEvIhdntCA3unz+FfqjDENmiVx+8p5exlMeVe8F2Yo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yHq9ksdID5VOFwTzY7eVWpCoAwsakWiwH8HYTGBme3TeQ69kgZia+OzuvfJ1VcmwF
         vMibW4C4SWtvB4J6C05tPvpEuxrvE0jyLb53ZQXbxx2C9a2fkiwbhlQ9SVIyKYotLx
         KLrKs/aTi/ZWjkookFYf/gbd1hjhyTACIqH4pDRg=
Date:   Thu, 19 Aug 2021 19:04:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name, guro@fb.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, lnyng@fb.com,
        mhocko@suse.com, mm-commits@vger.kernel.org, riel@surriel.com,
        shakeelb@google.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 06/10] mm: memcontrol: fix occasional OOMs due to
 proportional memory.low reclaim
Message-ID: <20210820020421.yuaeOQMtB%akpm@linux-foundation.org>
In-Reply-To: <20210819190327.14fc4e97102e1af7929e30af@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: fix occasional OOMs due to proportional memory.low reclaim

We've noticed occasional OOM killing when memory.low settings are in
effect for cgroups.  This is unexpected and undesirable as memory.low
is supposed to express non-OOMing memory priorities between cgroups.

The reason for this is proportional memory.low reclaim.  When cgroups
are below their memory.low threshold, reclaim passes them over in the
first round, and then retries if it couldn't find pages anywhere else. 
But when cgroups are slightly above their memory.low setting, page scan
force is scaled down and diminished in proportion to the overage, to
the point where it can cause reclaim to fail as well - only in that
case we currently don't retry, and instead trigger OOM.

To fix this, hook proportional reclaim into the same retry logic we
have in place for when cgroups are skipped entirely.  This way if
reclaim fails and some cgroups were scanned with diminished pressure,
we'll try another full-force cycle before giving up and OOMing.

[akpm@linux-foundation.org: coding-style fixes]
Link: https://lkml.kernel.org/r/20210817180506.220056-1-hannes@cmpxchg.org
Fixes: 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Leon Yang <lnyng@fb.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Chris Down <chris@chrisdown.name>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>		[5.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   29 +++++++++++++++--------------
 mm/vmscan.c                |   27 +++++++++++++++++++--------
 2 files changed, 34 insertions(+), 22 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-fix-occasional-ooms-due-to-proportional-memorylow-reclaim
+++ a/include/linux/memcontrol.h
@@ -612,12 +612,15 @@ static inline bool mem_cgroup_disabled(v
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
 }
 
-static inline unsigned long mem_cgroup_protection(struct mem_cgroup *root,
-						  struct mem_cgroup *memcg,
-						  bool in_low_reclaim)
+static inline void mem_cgroup_protection(struct mem_cgroup *root,
+					 struct mem_cgroup *memcg,
+					 unsigned long *min,
+					 unsigned long *low)
 {
+	*min = *low = 0;
+
 	if (mem_cgroup_disabled())
-		return 0;
+		return;
 
 	/*
 	 * There is no reclaim protection applied to a targeted reclaim.
@@ -653,13 +656,10 @@ static inline unsigned long mem_cgroup_p
 	 *
 	 */
 	if (root == memcg)
-		return 0;
-
-	if (in_low_reclaim)
-		return READ_ONCE(memcg->memory.emin);
+		return;
 
-	return max(READ_ONCE(memcg->memory.emin),
-		   READ_ONCE(memcg->memory.elow));
+	*min = READ_ONCE(memcg->memory.emin);
+	*low = READ_ONCE(memcg->memory.elow);
 }
 
 void mem_cgroup_calculate_protection(struct mem_cgroup *root,
@@ -1147,11 +1147,12 @@ static inline void memcg_memory_event_mm
 {
 }
 
-static inline unsigned long mem_cgroup_protection(struct mem_cgroup *root,
-						  struct mem_cgroup *memcg,
-						  bool in_low_reclaim)
+static inline void mem_cgroup_protection(struct mem_cgroup *root,
+					 struct mem_cgroup *memcg,
+					 unsigned long *min,
+					 unsigned long *low)
 {
-	return 0;
+	*min = *low = 0;
 }
 
 static inline void mem_cgroup_calculate_protection(struct mem_cgroup *root,
--- a/mm/vmscan.c~mm-memcontrol-fix-occasional-ooms-due-to-proportional-memorylow-reclaim
+++ a/mm/vmscan.c
@@ -100,9 +100,12 @@ struct scan_control {
 	unsigned int may_swap:1;
 
 	/*
-	 * Cgroups are not reclaimed below their configured memory.low,
-	 * unless we threaten to OOM. If any cgroups are skipped due to
-	 * memory.low and nothing was reclaimed, go back for memory.low.
+	 * Cgroup memory below memory.low is protected as long as we
+	 * don't threaten to OOM. If any cgroup is reclaimed at
+	 * reduced force or passed over entirely due to its memory.low
+	 * setting (memcg_low_skipped), and nothing is reclaimed as a
+	 * result, then go back for one more cycle that reclaims the protected
+	 * memory (memcg_low_reclaim) to avert OOM.
 	 */
 	unsigned int memcg_low_reclaim:1;
 	unsigned int memcg_low_skipped:1;
@@ -2537,15 +2540,14 @@ out:
 	for_each_evictable_lru(lru) {
 		int file = is_file_lru(lru);
 		unsigned long lruvec_size;
+		unsigned long low, min;
 		unsigned long scan;
-		unsigned long protection;
 
 		lruvec_size = lruvec_lru_size(lruvec, lru, sc->reclaim_idx);
-		protection = mem_cgroup_protection(sc->target_mem_cgroup,
-						   memcg,
-						   sc->memcg_low_reclaim);
+		mem_cgroup_protection(sc->target_mem_cgroup, memcg,
+				      &min, &low);
 
-		if (protection) {
+		if (min || low) {
 			/*
 			 * Scale a cgroup's reclaim pressure by proportioning
 			 * its current usage to its memory.low or memory.min
@@ -2576,6 +2578,15 @@ out:
 			 * hard protection.
 			 */
 			unsigned long cgroup_size = mem_cgroup_size(memcg);
+			unsigned long protection;
+
+			/* memory.low scaling, make sure we retry before OOM */
+			if (!sc->memcg_low_reclaim && low > min) {
+				protection = low;
+				sc->memcg_low_skipped = 1;
+			} else {
+				protection = min;
+			}
 
 			/* Avoid TOCTOU with earlier protection check */
 			cgroup_size = max(cgroup_size, protection);
_
