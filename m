Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34CB5950B7
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 00:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbfHSWXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 18:23:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728615AbfHSWXj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Aug 2019 18:23:39 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE7DE214DA;
        Mon, 19 Aug 2019 22:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566253418;
        bh=fyvKSpMWs3GIrksg6GGRrDpKvs9xwtUISTeOubuKX90=;
        h=Date:From:To:Subject:From;
        b=tntXzZldtughG4TdUgy/U0IzDVBUvr004GfYBYPRouGfFKWSB/XQviHlB3miHvhzX
         85F8iVDVFIpsDaBkZmfxYDA/pPnYzoqdfZCSZCssBW3SA9JbFvweIT+N5NM2ChGCU/
         FSq0rSi+hFs2NWgdVwbYe/kn9fdz+XzSvnRVVdsk=
Date:   Mon, 19 Aug 2019 15:23:37 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        stable@vger.kernel.org, mhocko@suse.com, hannes@cmpxchg.org,
        guro@fb.com
Subject:  [to-be-updated]
 mm-memcontrol-flush-percpu-vmstats-before-releasing-memcg.patch removed from
 -mm tree
Message-ID: <20190819222337.WSzRo%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.11
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: flush percpu vmstats before releasing memcg
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-flush-percpu-vmstats-before-releasing-memcg.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: memcontrol: flush percpu vmstats before releasing memcg

Percpu caching of local vmstats with the conditional propagation by the
cgroup tree leads to an accumulation of errors on non-leaf levels.

Let's imagine two nested memory cgroups A and A/B.  Say, a process
belonging to A/B allocates 100 pagecache pages on the CPU 0.  The percpu
cache will spill 3 times, so that 32*3=96 pages will be accounted to A/B
and A atomic vmstat counters, 4 pages will remain in the percpu cache.

Imagine A/B is nearby memory.max, so that every following allocation
triggers a direct reclaim on the local CPU.  Say, each such attempt will
free 16 pages on a new cpu.  That means every percpu cache will have -16
pages, except the first one, which will have 4 - 16 = -12.  A/B and A
atomic counters will not be touched at all.

Now a user removes A/B.  All percpu caches are freed and corresponding
vmstat numbers are forgotten.  A has 96 pages more than expected.

As memory cgroups are created and destroyed, errors do accumulate.  Even
1-2 pages differences can accumulate into large numbers.

To fix this issue let's accumulate and propagate percpu vmstat values
before releasing the memory cgroup.  At this point these numbers are
stable and cannot be changed.

Since on cpu hotplug we do flush percpu vmstats anyway, we can iterate
only over online cpus.

Link: http://lkml.kernel.org/r/20190812222911.2364802-2-guro@fb.com
Fixes: 42a300353577 ("mm: memcontrol: fix recursive statistics correctness & scalabilty")
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

--- a/mm/memcontrol.c~mm-memcontrol-flush-percpu-vmstats-before-releasing-memcg
+++ a/mm/memcontrol.c
@@ -3289,6 +3289,41 @@ static int memcg_online_kmem(struct mem_
 	return 0;
 }
 
+static void memcg_flush_percpu_vmstats(struct mem_cgroup *memcg)
+{
+	unsigned long stat[MEMCG_NR_STAT];
+	struct mem_cgroup *mi;
+	int node, cpu, i;
+
+	for (i = 0; i < MEMCG_NR_STAT; i++)
+		stat[i] = 0;
+
+	for_each_online_cpu(cpu)
+		for (i = 0; i < MEMCG_NR_STAT; i++)
+			stat[i] += raw_cpu_read(memcg->vmstats_percpu->stat[i]);
+
+	for (mi = memcg; mi; mi = parent_mem_cgroup(mi))
+		for (i = 0; i < MEMCG_NR_STAT; i++)
+			atomic_long_add(stat[i], &mi->vmstats[i]);
+
+	for_each_node(node) {
+		struct mem_cgroup_per_node *pn = memcg->nodeinfo[node];
+		struct mem_cgroup_per_node *pi;
+
+		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
+			stat[i] = 0;
+
+		for_each_online_cpu(cpu)
+			for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
+				stat[i] += raw_cpu_read(
+					pn->lruvec_stat_cpu->count[i]);
+
+		for (pi = pn; pi; pi = parent_nodeinfo(pi, node))
+			for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
+				atomic_long_add(stat[i], &pi->lruvec_stat[i]);
+	}
+}
+
 static void memcg_offline_kmem(struct mem_cgroup *memcg)
 {
 	struct cgroup_subsys_state *css;
@@ -4682,6 +4717,11 @@ static void __mem_cgroup_free(struct mem
 {
 	int node;
 
+	/*
+	 * Flush percpu vmstats to guarantee the value correctness
+	 * on parent's and all ancestor levels.
+	 */
+	memcg_flush_percpu_vmstats(memcg);
 	for_each_node(node)
 		free_mem_cgroup_per_node_info(memcg, node);
 	free_percpu(memcg->vmstats_percpu);
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcontrol-flush-percpu-slab-vmstats-on-kmem-offlining.patch
mm-memcontrol-flush-percpu-slab-vmstats-on-kmem-offlining-fix.patch
mm-memcontrol-flush-percpu-vmevents-before-releasing-memcg.patch
mm-memcontrol-switch-to-rcu-protection-in-drain_all_stock.patch

