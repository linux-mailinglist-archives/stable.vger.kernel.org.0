Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1EA129B7C
	for <lists+stable@lfdr.de>; Mon, 23 Dec 2019 23:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbfLWWkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 17:40:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:38774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbfLWWkq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Dec 2019 17:40:46 -0500
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E25D206B7;
        Mon, 23 Dec 2019 22:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577140845;
        bh=uobOWOH0W5b7s18IsrbZwPLytSbbwzYiHWgFPZ9TvrU=;
        h=Date:From:To:Subject:From;
        b=Co1c6YwzcmE/th7H//vBB37sN6C6EZ2XwB1zknvmE8ybQ0YfQzyEd+j27FLpsXOT1
         CPrHQ0wCkoOyB+cfCpx74MPGT3fX0sSVKXGijF4STJzuzkJ7f+/egi6GjuYjT7VJmx
         RrqxDjtmYbFPXBp9B3ySuhRTMRptK77XohuJxzaY=
Date:   Mon, 23 Dec 2019 14:40:44 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        mhocko@suse.com, hannes@cmpxchg.org, guro@fb.com
Subject:  + mm-memcg-slab-fix-percpu-slab-vmstats-flushing.patch
 added to -mm tree
Message-ID: <20191223224044.XRyPD%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: fix percpu slab vmstats flushing
has been added to the -mm tree.  Its filename is
     mm-memcg-slab-fix-percpu-slab-vmstats-flushing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-slab-fix-percpu-slab-vmstats-flushing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-slab-fix-percpu-slab-vmstats-flushing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg/slab: fix percpu slab vmstats flushing

Currently slab percpu vmstats are flushed twice: during the memcg
offlining and just before freeing the memcg structure.  Each time percpu
counters are summed, added to the atomic counterparts and propagated up by
the cgroup tree.

The second flushing is required due to how recursive vmstats are
implemented: counters are batched in percpu variables on a local level,
and once a percpu value is crossing some predefined threshold, it spills
over to atomic values on the local and each ascendant levels.  It means
that without flushing some numbers cached in percpu variables will be
dropped on floor each time a cgroup is destroyed.  And with uptime the
error on upper levels might become noticeable.

The first flushing aims to make counters on ancestor levels more precise. 
Dying cgroups may resume in the dying state for a long time.  After
kmem_cache reparenting which is performed during the offlining slab
counters of the dying cgroup don't have any chances to be updated, because
any slab operations will be performed on the parent level.  It means that
the inaccuracy caused by percpu batching will not decrease up to the final
destruction of the cgroup.  By the original idea flushing slab counters
during the offlining should minimize the visible inaccuracy of slab
counters on the parent level.

The problem is that percpu counters are not zeroed after the first
flushing.  So every cached percpu value is summed twice.  It creates a
small error (up to 32 pages per cpu, but usually less) which accumulates
on parent cgroup level.  After creating and destroying of thousands of
child cgroups, slab counter on parent level can be way off the real value.

For now, let's just stop flushing slab counters on memcg offlining.  It
can't be done correctly without scheduling a work on each cpu: reading and
zeroing it during css offlining can race with an asynchronous update,
which doesn't expect values to be changed underneath.

With this change, slab counters on parent level will become eventually
consistent.  Once all dying children are gone, values are correct.  And if
not, the error is capped by 32 * NR_CPUS pages per dying cgroup.

It's not perfect, as slab are reparented, so any updates after the
reparenting will happen on the parent level.  It means that if a slab page
was allocated, a counter on child level was bumped, then the page was
reparented and freed, the annihilation of positive and negative counter
values will not happen until the child cgroup is released.  It makes slab
counters different from others, and it might want us to implement flushing
in a correct form again.  But it's also a question of performance:
scheduling a work on each cpu isn't free, and it's an open question if the
benefit of having more accurate counters is worth it.

We might also consider flushing all counters on offlining, not only slab
counters.

So let's fix the main problem now: make the slab counters eventually
consistent, so at least the error won't grow with uptime (or more
precisely the number of created and destroyed cgroups).  And think about
the accuracy of counters separately.

Link: http://lkml.kernel.org/r/20191220042728.1045881-1-guro@fb.com
Fixes: bee07b33db78 ("mm: memcontrol: flush percpu slab vmstats on kmem offlining")
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    5 ++---
 mm/memcontrol.c        |   37 +++++++++----------------------------
 2 files changed, 11 insertions(+), 31 deletions(-)

--- a/include/linux/mmzone.h~mm-memcg-slab-fix-percpu-slab-vmstats-flushing
+++ a/include/linux/mmzone.h
@@ -215,9 +215,8 @@ enum node_stat_item {
 	NR_INACTIVE_FILE,	/*  "     "     "   "       "         */
 	NR_ACTIVE_FILE,		/*  "     "     "   "       "         */
 	NR_UNEVICTABLE,		/*  "     "     "   "       "         */
-	NR_SLAB_RECLAIMABLE,	/* Please do not reorder this item */
-	NR_SLAB_UNRECLAIMABLE,	/* and this one without looking at
-				 * memcg_flush_percpu_vmstats() first. */
+	NR_SLAB_RECLAIMABLE,
+	NR_SLAB_UNRECLAIMABLE,
 	NR_ISOLATED_ANON,	/* Temporary isolated pages from anon lru */
 	NR_ISOLATED_FILE,	/* Temporary isolated pages from file lru */
 	WORKINGSET_NODES,
--- a/mm/memcontrol.c~mm-memcg-slab-fix-percpu-slab-vmstats-flushing
+++ a/mm/memcontrol.c
@@ -3287,49 +3287,34 @@ static u64 mem_cgroup_read_u64(struct cg
 	}
 }
 
-static void memcg_flush_percpu_vmstats(struct mem_cgroup *memcg, bool slab_only)
+static void memcg_flush_percpu_vmstats(struct mem_cgroup *memcg)
 {
-	unsigned long stat[MEMCG_NR_STAT];
+	unsigned long stat[MEMCG_NR_STAT] = {0};
 	struct mem_cgroup *mi;
 	int node, cpu, i;
-	int min_idx, max_idx;
-
-	if (slab_only) {
-		min_idx = NR_SLAB_RECLAIMABLE;
-		max_idx = NR_SLAB_UNRECLAIMABLE;
-	} else {
-		min_idx = 0;
-		max_idx = MEMCG_NR_STAT;
-	}
-
-	for (i = min_idx; i < max_idx; i++)
-		stat[i] = 0;
 
 	for_each_online_cpu(cpu)
-		for (i = min_idx; i < max_idx; i++)
+		for (i = 0; i < MEMCG_NR_STAT; i++)
 			stat[i] += per_cpu(memcg->vmstats_percpu->stat[i], cpu);
 
 	for (mi = memcg; mi; mi = parent_mem_cgroup(mi))
-		for (i = min_idx; i < max_idx; i++)
+		for (i = 0; i < MEMCG_NR_STAT; i++)
 			atomic_long_add(stat[i], &mi->vmstats[i]);
 
-	if (!slab_only)
-		max_idx = NR_VM_NODE_STAT_ITEMS;
-
 	for_each_node(node) {
 		struct mem_cgroup_per_node *pn = memcg->nodeinfo[node];
 		struct mem_cgroup_per_node *pi;
 
-		for (i = min_idx; i < max_idx; i++)
+		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
 			stat[i] = 0;
 
 		for_each_online_cpu(cpu)
-			for (i = min_idx; i < max_idx; i++)
+			for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
 				stat[i] += per_cpu(
 					pn->lruvec_stat_cpu->count[i], cpu);
 
 		for (pi = pn; pi; pi = parent_nodeinfo(pi, node))
-			for (i = min_idx; i < max_idx; i++)
+			for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
 				atomic_long_add(stat[i], &pi->lruvec_stat[i]);
 	}
 }
@@ -3403,13 +3388,9 @@ static void memcg_offline_kmem(struct me
 		parent = root_mem_cgroup;
 
 	/*
-	 * Deactivate and reparent kmem_caches. Then flush percpu
-	 * slab statistics to have precise values at the parent and
-	 * all ancestor levels. It's required to keep slab stats
-	 * accurate after the reparenting of kmem_caches.
+	 * Deactivate and reparent kmem_caches.
 	 */
 	memcg_deactivate_kmem_caches(memcg, parent);
-	memcg_flush_percpu_vmstats(memcg, true);
 
 	kmemcg_id = memcg->kmemcg_id;
 	BUG_ON(kmemcg_id < 0);
@@ -4913,7 +4894,7 @@ static void mem_cgroup_free(struct mem_c
 	 * Flush percpu vmstats and vmevents to guarantee the value correctness
 	 * on parent's and all ancestor levels.
 	 */
-	memcg_flush_percpu_vmstats(memcg, false);
+	memcg_flush_percpu_vmstats(memcg);
 	memcg_flush_percpu_vmevents(memcg);
 	__mem_cgroup_free(memcg);
 }
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcg-slab-fix-percpu-slab-vmstats-flushing.patch

