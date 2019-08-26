Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1933D9D858
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 23:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728642AbfHZVbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 17:31:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728595AbfHZVbm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 17:31:42 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E94821881;
        Mon, 26 Aug 2019 21:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566855100;
        bh=28PUkZirApNIzSfvINzyiGkgXFuUkj+9aL0J5o30BtE=;
        h=Date:From:To:Subject:From;
        b=0h2OMCdBqsmm10NbL6G8zu9ivqoQvfNROunl/9bO1CbBV09J0eCyLxBuT5F3z65fB
         doLIzMreFp3AYq8seRdYSuXZFCe+jogFGWeFMwO34+PCmC6WO6nLydbgkYumsFR3IC
         93aiyM7l1h4swnTo9/cm+t1dzXosLMnAU1tpV//s=
Date:   Mon, 26 Aug 2019 14:31:40 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcontrol-flush-percpu-vmevents-before-releasing-memcg.patch removed
 from -mm tree
Message-ID: <20190826213140.7vOhY2f5g%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: flush percpu vmevents before releasing memcg
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-flush-percpu-vmevents-before-releasing-memcg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: memcontrol: flush percpu vmevents before releasing memcg

Similar to vmstats, percpu caching of local vmevents leads to an
accumulation of errors on non-leaf levels.  This happens because some
leftovers may remain in percpu caches, so that they are never propagated
up by the cgroup tree and just disappear into nonexistence with on
releasing of the memory cgroup.

To fix this issue let's accumulate and propagate percpu vmevents values
before releasing the memory cgroup similar to what we're doing with
vmstats.

Since on cpu hotplug we do flush percpu vmstats anyway, we can iterate
only over online cpus.

Link: http://lkml.kernel.org/r/20190819202338.363363-4-guro@fb.com
Fixes: 42a300353577 ("mm: memcontrol: fix recursive statistics correctness & scalabilty")
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-flush-percpu-vmevents-before-releasing-memcg
+++ a/mm/memcontrol.c
@@ -3295,6 +3295,25 @@ static void memcg_flush_percpu_vmstats(s
 	}
 }
 
+static void memcg_flush_percpu_vmevents(struct mem_cgroup *memcg)
+{
+	unsigned long events[NR_VM_EVENT_ITEMS];
+	struct mem_cgroup *mi;
+	int cpu, i;
+
+	for (i = 0; i < NR_VM_EVENT_ITEMS; i++)
+		events[i] = 0;
+
+	for_each_online_cpu(cpu)
+		for (i = 0; i < NR_VM_EVENT_ITEMS; i++)
+			events[i] += raw_cpu_read(
+				memcg->vmstats_percpu->events[i]);
+
+	for (mi = memcg; mi; mi = parent_mem_cgroup(mi))
+		for (i = 0; i < NR_VM_EVENT_ITEMS; i++)
+			atomic_long_add(events[i], &mi->vmevents[i]);
+}
+
 #ifdef CONFIG_MEMCG_KMEM
 static int memcg_online_kmem(struct mem_cgroup *memcg)
 {
@@ -4718,10 +4737,11 @@ static void __mem_cgroup_free(struct mem
 	int node;
 
 	/*
-	 * Flush percpu vmstats to guarantee the value correctness
+	 * Flush percpu vmstats and vmevents to guarantee the value correctness
 	 * on parent's and all ancestor levels.
 	 */
 	memcg_flush_percpu_vmstats(memcg);
+	memcg_flush_percpu_vmevents(memcg);
 	for_each_node(node)
 		free_mem_cgroup_per_node_info(memcg, node);
 	free_percpu(memcg->vmstats_percpu);
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcontrol-flush-percpu-slab-vmstats-on-kmem-offlining.patch
partially-revert-mm-memcontrolc-keep-local-vm-counters-in-sync-with-the-hierarchical-ones.patch
mm-memcontrol-switch-to-rcu-protection-in-drain_all_stock.patch

