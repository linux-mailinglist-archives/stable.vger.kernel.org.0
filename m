Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEDC3950C8
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 00:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728538AbfHSW3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 18:29:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728438AbfHSW3H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Aug 2019 18:29:07 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B93522CE8;
        Mon, 19 Aug 2019 22:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566253746;
        bh=gKXjzj2thXw1NrLXTfVBNJCAsAGbw2xe+U3ar2qUAYc=;
        h=Date:From:To:Subject:From;
        b=DeDzt/wEqzpbGhLxkowof/157SMwVT2OBH+7rVPCtOH7E91iz3v6eOanKG36CSO4u
         vU6ZQl5yUjAaL6h18BKby6fttbpRUJXG7gtMztvII51yYW47jrNsp8xMmOAj9UF9/9
         Wc5bBc8foQ6a5We0r8ZmScDEAqgDHPtZ+6xkBpTU=
Date:   Mon, 19 Aug 2019 15:29:05 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        stable@vger.kernel.org, mhocko@suse.com, hannes@cmpxchg.org,
        guro@fb.com
Subject:  +
 mm-memcontrol-flush-percpu-vmevents-before-releasing-memcg.patch added to -mm
 tree
Message-ID: <20190819222905.jJDso%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.11
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: flush percpu vmevents before releasing memcg
has been added to the -mm tree.  Its filename is
     mm-memcontrol-flush-percpu-vmevents-before-releasing-memcg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-flush-percpu-vmevents-before-releasing-memcg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-flush-percpu-vmevents-before-releasing-memcg.patch

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
@@ -3307,6 +3307,25 @@ static void memcg_flush_percpu_vmstats(s
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
@@ -4737,10 +4756,11 @@ static void __mem_cgroup_free(struct mem
 	int node;
 
 	/*
-	 * Flush percpu vmstats to guarantee the value correctness
+	 * Flush percpu vmstats and vmevents to guarantee the value correctness
 	 * on parent's and all ancestor levels.
 	 */
 	memcg_flush_percpu_vmstats(memcg, false);
+	memcg_flush_percpu_vmevents(memcg);
 	for_each_node(node)
 		free_mem_cgroup_per_node_info(memcg, node);
 	free_percpu(memcg->vmstats_percpu);
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcontrol-flush-percpu-vmstats-before-releasing-memcg.patch
mm-memcontrol-flush-percpu-slab-vmstats-on-kmem-offlining.patch
mm-memcontrol-flush-percpu-vmevents-before-releasing-memcg.patch
mm-memcontrol-switch-to-rcu-protection-in-drain_all_stock.patch

