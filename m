Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E013F5051
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 20:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhHWSZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 14:25:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231955AbhHWSZA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 14:25:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9C7C613A6;
        Mon, 23 Aug 2021 18:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629743058;
        bh=aZ/IordTX1/kS+HbrPfKzwauOIRfW3IndPvEkxg1rmc=;
        h=Date:From:To:Subject:From;
        b=JiSr0SmhtlkjeJzzhjw4kDBFHt7pwupHM0BBS6/1f0Qxu8KceowpM2FuQhC9bY/Iv
         nwlpygNnrdiDn5nJijz3zPYDVK5e6r7V6neVvhO2y27zdDXHcpUZZF8OCBATODL55u
         Xcg1F+Q8N4x8mUOjLGhGIFjVEf9Gz595/cvZg4zg=
Date:   Mon, 23 Aug 2021 11:24:17 -0700
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org,
        lnyng@fb.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        riel@surriel.com, shakeelb@google.com, stable@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-memcontrol-fix-occasional-ooms-due-to-proportional-mem?=
 =?US-ASCII?Q?orylow-reclaim.patch?= removed from -mm tree
Message-ID: <20210823182417.cV8hn-NZL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix occasional OOMs due to proportional memory.low reclaim
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-occasional-ooms-due-to-proportional-memorylow-reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-remove-irqsave-restore-locking-from-contexts-with-irqs-enabled.patch
fs-drop_caches-fix-skipping-over-shadow-cache-inodes.patch
fs-inode-count-invalidated-shadow-pages-in-pginodesteal.patch
vfs-keep-inodes-with-page-cache-off-the-inode-shrinker-lru.patch

