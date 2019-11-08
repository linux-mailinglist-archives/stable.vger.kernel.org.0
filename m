Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA50F3CFC
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 01:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbfKHAjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 19:39:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:58094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727952AbfKHAjU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Nov 2019 19:39:20 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C2E421D82;
        Fri,  8 Nov 2019 00:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573173557;
        bh=RZ82SbrFW9YSctxVKW1gB98z6yM6KzoN3cQk2mIgUU0=;
        h=Date:From:To:Subject:From;
        b=1nE9Br9Gum2LbjfFSWu6hnT2+/3tSevbNTWPigANu4vcRQ0v4uI4XBXT7XyXCKmar
         LaDbx8VOOzn12r2m8CWgzBz8KJxCSNBdplyI8RF+4fV9VsjyQn0kjebvoO768ff3+H
         7196e6FT08NsznR9mU48PQIlQk+dF0OrFOAOTKOc=
Date:   Thu, 07 Nov 2019 16:39:17 -0800
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        shakeelb@google.com, stable@vger.kernel.org, suleiman@google.com
Subject:  [merged]
 mm-memcontrol-fix-network-errors-from-failing-__gfp_atomic-charges.patch
 removed from -mm tree
Message-ID: <20191108003917.P1g7WASZ7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix network errors from failing __GFP_ATOMIC charges
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-network-errors-from-failing-__gfp_atomic-charges.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: fix network errors from failing __GFP_ATOMIC charges

While upgrading from 4.16 to 5.2, we noticed these allocation errors in
the log of the new kernel:

[ 8642.253395] SLUB: Unable to allocate memory on node -1, gfp=0xa20(GFP_ATOMIC)
[ 8642.269170]   cache: tw_sock_TCPv6(960:helper-logs), object size: 232, buffer size: 240, default order: 1, min order: 0
[ 8642.293009]   node 0: slabs: 5, objs: 170, free: 0

        slab_out_of_memory+1
        ___slab_alloc+969
        __slab_alloc+14
        kmem_cache_alloc+346
        inet_twsk_alloc+60
        tcp_time_wait+46
        tcp_fin+206
        tcp_data_queue+2034
        tcp_rcv_state_process+784
        tcp_v6_do_rcv+405
        __release_sock+118
        tcp_close+385
        inet_release+46
        __sock_release+55
        sock_close+17
        __fput+170
        task_work_run+127
        exit_to_usermode_loop+191
        do_syscall_64+212
        entry_SYSCALL_64_after_hwframe+68

accompanied by an increase in machines going completely radio silent under
memory pressure.

One thing that changed since 4.16 is e699e2c6a654 ("net, mm: account sock
objects to kmemcg"), which made these slab caches subject to cgroup memory
accounting and control.

The problem with that is that cgroups, unlike the page allocator, do not
maintain dedicated atomic reserves.  As a cgroup's usage hovers at its
limit, atomic allocations - such as done during network rx - can fail
consistently for extended periods of time.  The kernel is not able to
operate under these conditions.

We don't want to revert the culprit patch, because it indeed tracks a
potentially substantial amount of memory used by a cgroup.

We also don't want to implement dedicated atomic reserves for cgroups. 
There is no point in keeping a fixed margin of unused bytes in the
cgroup's memory budget to accomodate a consumer that is impossible to
predict - we'd be wasting memory and get into configuration headaches, not
unlike what we have going with min_free_kbytes.  We do this for physical
mem because we have to, but cgroups are an accounting game.

Instead, account these privileged allocations to the cgroup, but let them
bypass the configured limit if they have to.  This way, we get the
benefits of accounting the consumed memory and have it exert pressure on
the rest of the cgroup, but like with the page allocator, we shift the
burden of reclaimining on behalf of atomic allocations onto the regular
allocations that can block.

Link: http://lkml.kernel.org/r/20191022233708.365764-1-hannes@cmpxchg.org
Fixes: e699e2c6a654 ("net, mm: account sock objects to kmemcg")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>	[4.18+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/memcontrol.c~mm-memcontrol-fix-network-errors-from-failing-__gfp_atomic-charges
+++ a/mm/memcontrol.c
@@ -2535,6 +2535,15 @@ retry:
 	}
 
 	/*
+	 * Memcg doesn't have a dedicated reserve for atomic
+	 * allocations. But like the global atomic pool, we need to
+	 * put the burden of reclaim on regular allocation requests
+	 * and let these go through as privileged allocations.
+	 */
+	if (gfp_mask & __GFP_ATOMIC)
+		goto force;
+
+	/*
 	 * Unlike in global OOM situations, memcg is not in a physical
 	 * memory shortage.  Allow dying and OOM-killed tasks to
 	 * bypass the last charges so that they can exit quickly and
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-remove-dead-code-from-memory_max_write.patch
mm-memcontrol-try-harder-to-set-a-new-memoryhigh.patch
mm-drop-mmap_sem-before-calling-balance_dirty_pages-in-write-fault.patch
mm-vmscan-simplify-lruvec_lru_size.patch
mm-clean-up-and-clarify-lruvec-lookup-procedure.patch
mm-vmscan-move-inactive_list_is_low-swap-check-to-the-caller.patch
mm-vmscan-naming-fixes-global_reclaim-and-sane_reclaim.patch
mm-vmscan-replace-shrink_node-loop-with-a-retry-jump.patch
mm-vmscan-turn-shrink_node_memcg-into-shrink_lruvec.patch
mm-vmscan-split-shrink_node-into-node-part-and-memcgs-part.patch
mm-vmscan-split-shrink_node-into-node-part-and-memcgs-part-fix.patch
mm-vmscan-harmonize-writeback-congestion-tracking-for-nodes-memcgs.patch
kernel-sysctl-make-drop_caches-write-only.patch

