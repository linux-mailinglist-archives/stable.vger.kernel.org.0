Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3E1A71C1
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 19:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730217AbfICRfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 13:35:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729485AbfICRfp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 13:35:45 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7EA522D6D;
        Tue,  3 Sep 2019 17:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567532144;
        bh=/qvT7h3JzcF0wtZVIqhOXw+X9MYZ2uwS0AtG6mDNMxU=;
        h=Date:From:To:Subject:From;
        b=MrQgJnsAnqsh/S7M9A9P917H4ifFHMKFUrR0foJdmY1z/l4jMpPJB3mc0VVyA+ghC
         e8uQCtJMCJJi4hlaxFtXUrBDnykwwruTrtN6XblsV3FQyxcwS28cpkooLQVqyCLtCk
         DK49dprtrJabNl6Q7CSGpNLecBw3JbX5PEG0Aog0=
Date:   Tue, 03 Sep 2019 10:35:44 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, laoar.shao@gmail.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?partially-revert-mm-memcontrolc-keep-local-vm-counters-in-s?=
 =?US-ASCII?Q?ync-with-the-hierarchical-ones.patch?= removed from -mm tree
Message-ID: <20190903173544.v9AfFl-oL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, memcg: partially revert "mm/memcontrol.c: keep local VM counters in sync with the hierarchical ones"
has been removed from the -mm tree.  Its filename was
     partially-revert-mm-memcontrolc-keep-local-vm-counters-in-sync-with-the-hierarchical-ones.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm, memcg: partially revert "mm/memcontrol.c: keep local VM counters in sync with the hierarchical ones"

Commit 766a4c19d880 ("mm/memcontrol.c: keep local VM counters in sync with
the hierarchical ones") effectively decreased the precision of per-memcg
vmstats_local and per-memcg-per-node lruvec percpu counters.

That's good for displaying in memory.stat, but brings a serious regression
into the reclaim process.

One issue I've discovered and debugged is the following: lruvec_lru_size()
can return 0 instead of the actual number of pages in the lru list,
preventing the kernel to reclaim last remaining pages.  Result is yet
another dying memory cgroups flooding.  The opposite is also happening:
scanning an empty lru list is the waste of cpu time.

Also, inactive_list_is_low() can return incorrect values, preventing the
active lru from being scanned and freed.  It can fail both because the
size of active and inactive lists are inaccurate, and because the number
of workingset refaults isn't precise.  In other words, the result is
pretty random.

I'm not sure, if using the approximate number of slab pages in
count_shadow_number() is acceptable, but issues described above are enough
to partially revert the patch.

Let's keep per-memcg vmstat_local batched (they are only used for
displaying stats to the userspace), but keep lruvec stats precise.  This
change fixes the dead memcg flooding on my setup.

Link: http://lkml.kernel.org/r/20190817004726.2530670-1-guro@fb.com
Fixes: 766a4c19d880 ("mm/memcontrol.c: keep local VM counters in sync with the hierarchical ones")
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c~partially-revert-mm-memcontrolc-keep-local-vm-counters-in-sync-with-the-hierarchical-ones
+++ a/mm/memcontrol.c
@@ -752,15 +752,13 @@ void __mod_lruvec_state(struct lruvec *l
 	/* Update memcg */
 	__mod_memcg_state(memcg, idx, val);
 
+	/* Update lruvec */
+	__this_cpu_add(pn->lruvec_stat_local->count[idx], val);
+
 	x = val + __this_cpu_read(pn->lruvec_stat_cpu->count[idx]);
 	if (unlikely(abs(x) > MEMCG_CHARGE_BATCH)) {
 		struct mem_cgroup_per_node *pi;
 
-		/*
-		 * Batch local counters to keep them in sync with
-		 * the hierarchical ones.
-		 */
-		__this_cpu_add(pn->lruvec_stat_local->count[idx], x);
 		for (pi = pn; pi; pi = parent_nodeinfo(pi, pgdat->node_id))
 			atomic_long_add(x, &pi->lruvec_stat[idx]);
 		x = 0;
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcontrol-switch-to-rcu-protection-in-drain_all_stock.patch

