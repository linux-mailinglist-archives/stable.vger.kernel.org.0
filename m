Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58452C6E5F
	for <lists+stable@lfdr.de>; Sat, 28 Nov 2020 03:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730991AbgK1CL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 21:11:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:38478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731751AbgK1CIh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Nov 2020 21:08:37 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD6732223F;
        Sat, 28 Nov 2020 02:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606529317;
        bh=2iN8HDvlE8/nMEvferhtIOcfkMKvU91MlMTULSyyRIA=;
        h=Date:From:To:Subject:From;
        b=1P57MgHBhI7YFMI3PxrcGZnmMNOVSGOVMCz4RLHhGNw40S0fa5IzfOETaIG8ZSeXz
         hHlRxXGtkRTG7DnYZ7wQ1GOnae9qlxwHrVkKPSaCESsOOgDHPghLjKFxkg8Sj7xiJM
         pmQvmORgM+Sl6SW7zKVfFi/U9thSFMmzzukrl9TI=
Date:   Fri, 27 Nov 2020 18:08:36 -0800
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, cl@linux.com, guro@fb.com,
        hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, laoar.shao@gmail.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, shakeelb@google.com, songmuchun@bytedance.com,
        stable@vger.kernel.org, vbabka@suse.cz, vdavydov.dev@gmail.com
Subject:  [merged] mm-memcg-slab-fix-root-memcg-vmstats.patch
 removed from -mm tree
Message-ID: <20201128020836.jsKUmkuAN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: fix root memcg vmstats
has been removed from the -mm tree.  Its filename was
     mm-memcg-slab-fix-root-memcg-vmstats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcg/slab: fix root memcg vmstats

If we reparent the slab objects to the root memcg, when we free the slab
object, we need to update the per-memcg vmstats to keep it correct for the
root memcg.  Now this at least affects the vmstat of NR_KERNEL_STACK_KB
for !CONFIG_VMAP_STACK when the thread stack size is smaller than the
PAGE_SIZE.

David said: "I assume that without this fix that the root memcg's
vmstat would always be inflated if we reparented."

Link: https://lkml.kernel.org/r/20201110031015.15715-1-songmuchun@bytedance.com
Fixes: ec9f02384f60 ("mm: workingset: fix vmstat counters for shadow nodes")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: <stable@vger.kernel.org>	[5.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-slab-fix-root-memcg-vmstats
+++ a/mm/memcontrol.c
@@ -867,8 +867,13 @@ void __mod_lruvec_slab_state(void *p, en
 	rcu_read_lock();
 	memcg = mem_cgroup_from_obj(p);
 
-	/* Untracked pages have no memcg, no lruvec. Update only the node */
-	if (!memcg || memcg == root_mem_cgroup) {
+	/*
+	 * Untracked pages have no memcg, no lruvec. Update only the
+	 * node. If we reparent the slab objects to the root memcg,
+	 * when we free the slab object, we need to update the per-memcg
+	 * vmstats to keep it correct for the root memcg.
+	 */
+	if (!memcg) {
 		__mod_node_page_state(pgdat, idx, val);
 	} else {
 		lruvec = mem_cgroup_lruvec(memcg, pgdat);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-remove-unused-mod_memcg_obj_state.patch
mm-memcg-slab-fix-return-child-memcg-objcg-for-root-memcg.patch
mm-memcg-slab-fix-use-after-free-in-obj_cgroup_charge.patch
mm-memcg-slab-rename-_lruvec_slab_state-to-_lruvec_kmem_state.patch

