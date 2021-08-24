Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5DD3F647C
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233882AbhHXRFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:05:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235509AbhHXRCN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:02:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C467C61465;
        Tue, 24 Aug 2021 16:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824286;
        bh=BYhK/SLFqDbJch3IOwjfnpKSuRTxxu+mkZXxrRJ3Q74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hwqd/dXJ3F6T2mmD8UNOMD4qNR2QWhgf5g3+T+21sRVFM6JcC4pep73fLLiwFo7CV
         n5DDxBKmTadW+rgXaHfDrGHBllmyvWGQY/PMFbLnCJZG7R8KWRfV4+jdCeUZt6HrNd
         32PkipqQdj4ZcVHk7eUDeEBXqeMbPd9P4FZSslng6/RhRZPxYYssRNrw0bdsbnjl9M
         iaSUGkJhxu4ei9lxOxChLqonDOEmANZuf20iKRw6C5N5+xKdtfk0HXlnWHDO14JURq
         nU6b40YQ+UmnCyNv8x5DGRS1OzI6+jgoOg37OHaD0++VpEurXH7FZq9ROlznx+8ISE
         u8oB0E6edQCrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Weiner <hannes@cmpxchg.org>, Leon Yang <lnyng@fb.com>,
        Rik van Riel <riel@surriel.com>,
        Shakeel Butt <shakeelb@google.com>,
        Roman Gushchin <guro@fb.com>,
        Chris Down <chris@chrisdown.name>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 120/127] mm: memcontrol: fix occasional OOMs due to proportional memory.low reclaim
Date:   Tue, 24 Aug 2021 12:56:00 -0400
Message-Id: <20210824165607.709387-121-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

[ Upstream commit f56ce412a59d7d938b81de8878faef128812482c ]

We've noticed occasional OOM killing when memory.low settings are in
effect for cgroups.  This is unexpected and undesirable as memory.low is
supposed to express non-OOMing memory priorities between cgroups.

The reason for this is proportional memory.low reclaim.  When cgroups
are below their memory.low threshold, reclaim passes them over in the
first round, and then retries if it couldn't find pages anywhere else.
But when cgroups are slightly above their memory.low setting, page scan
force is scaled down and diminished in proportion to the overage, to the
point where it can cause reclaim to fail as well - only in that case we
currently don't retry, and instead trigger OOM.

To fix this, hook proportional reclaim into the same retry logic we have
in place for when cgroups are skipped entirely.  This way if reclaim
fails and some cgroups were scanned with diminished pressure, we'll try
another full-force cycle before giving up and OOMing.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/memcontrol.h | 29 +++++++++++++++--------------
 mm/vmscan.c                | 27 +++++++++++++++++++--------
 2 files changed, 34 insertions(+), 22 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index c193be760709..63f751faa5c1 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -613,12 +613,15 @@ static inline bool mem_cgroup_disabled(void)
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
@@ -654,13 +657,10 @@ static inline unsigned long mem_cgroup_protection(struct mem_cgroup *root,
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
@@ -1165,11 +1165,12 @@ static inline void memcg_memory_event_mm(struct mm_struct *mm,
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
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5199b9696bab..f62d81f61b56 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
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
@@ -2521,15 +2524,14 @@ out:
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
@@ -2560,6 +2562,15 @@ out:
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
-- 
2.30.2

