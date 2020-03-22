Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6308618E5C5
	for <lists+stable@lfdr.de>; Sun, 22 Mar 2020 02:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbgCVBWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 21:22:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726859AbgCVBWZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Mar 2020 21:22:25 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6C9420788;
        Sun, 22 Mar 2020 01:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584840144;
        bh=MoV+3sHT5zx7YB59B27MhpI7NCNNTTi5tDhSZaXJacg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GgKcpZCX6RhdQj8/Ue1i+SSs3eZjrF5R5s/uXy8kU8YZ1BSWiCpe1czt7Pklu7yef
         wWSQgWi2MZztDAhaAhDBk2IODkqDmKKBDS0bg65BMJ6M9oBXQGrkDbZGCQHbMwYj7I
         t/PqMEBEnO7C7qLAaq9Kz3Dy6lXeFzrX4zznk3Q4=
Date:   Sat, 21 Mar 2020 18:22:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name, guro@fb.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        stable@vger.kernel.org, tj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 05/10] mm, memcg: throttle allocators based on
 ancestral memory.high
Message-ID: <20200322012223.ExM_gA7dC%akpm@linux-foundation.org>
In-Reply-To: <20200321181954.c0564dfd5514cd742b534884@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Down <chris@chrisdown.name>
Subject: mm, memcg: throttle allocators based on ancestral memory.high

Prior to this commit, we only directly check the affected cgroup's
memory.high against its usage.  However, it's possible that we are being
reclaimed as a result of hitting an ancestor memory.high and should be
penalised based on that, instead.

This patch changes memory.high overage throttling to use the largest
overage in its ancestors when considering how many penalty jiffies to
charge.  This makes sure that we penalise poorly behaving cgroups in the
same way regardless of at what level of the hierarchy memory.high was
breached.

Link: http://lkml.kernel.org/r/8cd132f84bd7e16cdb8fde3378cdbf05ba00d387.1584036142.git.chris@chrisdown.name
Fixes: 0e4b01df8659 ("mm, memcg: throttle allocators when failing reclaim over memory.high")
Signed-off-by: Chris Down <chris@chrisdown.name>
Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: <stable@vger.kernel.org>	[5.4.x+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   93 ++++++++++++++++++++++++++++------------------
 1 file changed, 58 insertions(+), 35 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-throttle-allocators-based-on-ancestral-memoryhigh
+++ a/mm/memcontrol.c
@@ -2297,28 +2297,41 @@ static void high_work_func(struct work_s
  #define MEMCG_DELAY_SCALING_SHIFT 14
 
 /*
- * Scheduled by try_charge() to be executed from the userland return path
- * and reclaims memory over the high limit.
+ * Get the number of jiffies that we should penalise a mischievous cgroup which
+ * is exceeding its memory.high by checking both it and its ancestors.
  */
-void mem_cgroup_handle_over_high(void)
+static unsigned long calculate_high_delay(struct mem_cgroup *memcg,
+					  unsigned int nr_pages)
 {
-	unsigned long usage, high, clamped_high;
-	unsigned long pflags;
-	unsigned long penalty_jiffies, overage;
-	unsigned int nr_pages = current->memcg_nr_pages_over_high;
-	struct mem_cgroup *memcg;
+	unsigned long penalty_jiffies;
+	u64 max_overage = 0;
 
-	if (likely(!nr_pages))
-		return;
+	do {
+		unsigned long usage, high;
+		u64 overage;
+
+		usage = page_counter_read(&memcg->memory);
+		high = READ_ONCE(memcg->high);
+
+		/*
+		 * Prevent division by 0 in overage calculation by acting as if
+		 * it was a threshold of 1 page
+		 */
+		high = max(high, 1UL);
+
+		overage = usage - high;
+		overage <<= MEMCG_DELAY_PRECISION_SHIFT;
+		overage = div64_u64(overage, high);
+
+		if (overage > max_overage)
+			max_overage = overage;
+	} while ((memcg = parent_mem_cgroup(memcg)) &&
+		 !mem_cgroup_is_root(memcg));
 
-	memcg = get_mem_cgroup_from_mm(current->mm);
-	reclaim_high(memcg, nr_pages, GFP_KERNEL);
-	current->memcg_nr_pages_over_high = 0;
+	if (!max_overage)
+		return 0;
 
 	/*
-	 * memory.high is breached and reclaim is unable to keep up. Throttle
-	 * allocators proactively to slow down excessive growth.
-	 *
 	 * We use overage compared to memory.high to calculate the number of
 	 * jiffies to sleep (penalty_jiffies). Ideally this value should be
 	 * fairly lenient on small overages, and increasingly harsh when the
@@ -2326,24 +2339,9 @@ void mem_cgroup_handle_over_high(void)
 	 * its crazy behaviour, so we exponentially increase the delay based on
 	 * overage amount.
 	 */
-
-	usage = page_counter_read(&memcg->memory);
-	high = READ_ONCE(memcg->high);
-
-	if (usage <= high)
-		goto out;
-
-	/*
-	 * Prevent division by 0 in overage calculation by acting as if it was a
-	 * threshold of 1 page
-	 */
-	clamped_high = max(high, 1UL);
-
-	overage = div64_u64((u64)(usage - high) << MEMCG_DELAY_PRECISION_SHIFT,
-			  clamped_high);
-
-	penalty_jiffies = ((u64)overage * overage * HZ)
-		>> (MEMCG_DELAY_PRECISION_SHIFT + MEMCG_DELAY_SCALING_SHIFT);
+	penalty_jiffies = max_overage * max_overage * HZ;
+	penalty_jiffies >>= MEMCG_DELAY_PRECISION_SHIFT;
+	penalty_jiffies >>= MEMCG_DELAY_SCALING_SHIFT;
 
 	/*
 	 * Factor in the task's own contribution to the overage, such that four
@@ -2360,7 +2358,32 @@ void mem_cgroup_handle_over_high(void)
 	 * application moving forwards and also permit diagnostics, albeit
 	 * extremely slowly.
 	 */
-	penalty_jiffies = min(penalty_jiffies, MEMCG_MAX_HIGH_DELAY_JIFFIES);
+	return min(penalty_jiffies, MEMCG_MAX_HIGH_DELAY_JIFFIES);
+}
+
+/*
+ * Scheduled by try_charge() to be executed from the userland return path
+ * and reclaims memory over the high limit.
+ */
+void mem_cgroup_handle_over_high(void)
+{
+	unsigned long penalty_jiffies;
+	unsigned long pflags;
+	unsigned int nr_pages = current->memcg_nr_pages_over_high;
+	struct mem_cgroup *memcg;
+
+	if (likely(!nr_pages))
+		return;
+
+	memcg = get_mem_cgroup_from_mm(current->mm);
+	reclaim_high(memcg, nr_pages, GFP_KERNEL);
+	current->memcg_nr_pages_over_high = 0;
+
+	/*
+	 * memory.high is breached and reclaim is unable to keep up. Throttle
+	 * allocators proactively to slow down excessive growth.
+	 */
+	penalty_jiffies = calculate_high_delay(memcg, nr_pages);
 
 	/*
 	 * Don't sleep if the amount of jiffies this memcg owes us is so low
_
