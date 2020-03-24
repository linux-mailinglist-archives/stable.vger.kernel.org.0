Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A769191024
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbgCXNZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:25:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgCXNZh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:25:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32A5420775;
        Tue, 24 Mar 2020 13:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056336;
        bh=ORvtMhMdKgNc0eJyObJDx47xrCnmPs22ZWh7w983iDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BicuWVBYXjwYTm2HQ3hxzl1Bu5qx49a7/JOxesQuERYHXnkSvEJVGwqn4bRdLbyBS
         xO3qfMa+5GvPajOZXqWh3zt1qTXKxXbxO9VjIl8VXg41dI9YEPqUCV8HA+RiZmeaPA
         fMa7YsGMNpKDbxcAMw+6/tLCrzv02BV5FcNrR44o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Chris Down <chris@chrisdown.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Roman Gushchin <guro@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.5 094/119] mm, memcg: throttle allocators based on ancestral memory.high
Date:   Tue, 24 Mar 2020 14:11:19 +0100
Message-Id: <20200324130817.562078821@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Down <chris@chrisdown.name>

commit e26733e0d0ec6798eca93daa300bc3f43616127f upstream.

Prior to this commit, we only directly check the affected cgroup's
memory.high against its usage.  However, it's possible that we are being
reclaimed as a result of hitting an ancestor memory.high and should be
penalised based on that, instead.

This patch changes memory.high overage throttling to use the largest
overage in its ancestors when considering how many penalty jiffies to
charge.  This makes sure that we penalise poorly behaving cgroups in the
same way regardless of at what level of the hierarchy memory.high was
breached.

Fixes: 0e4b01df8659 ("mm, memcg: throttle allocators when failing reclaim over memory.high")
Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: <stable@vger.kernel.org>	[5.4.x+]
Link: http://lkml.kernel.org/r/8cd132f84bd7e16cdb8fde3378cdbf05ba00d387.1584036142.git.chris@chrisdown.name
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |   93 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 58 insertions(+), 35 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
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


