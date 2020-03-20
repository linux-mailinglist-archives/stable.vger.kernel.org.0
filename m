Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02C6618DC31
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 00:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgCTXs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 19:48:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbgCTXs1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 19:48:27 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FF5A2072C;
        Fri, 20 Mar 2020 23:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584748106;
        bh=WTc4amYvfakkzx+/DMp/O0fGsBEJLY5htT9PZWYecak=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=d2JF09diUuqtDWWSSTK3XljF3hKCyG+YICphWfzcb/NOPn5aVWzVnEdbQjxNKVLlq
         VJ7b/lY0ziBPJzsJU67DccRpLQtLYj/6le/3nRzGYPpUgXmjJoes+iGmkZvdWYwlwy
         9haDVKrWeLas+qduZx0BwxhDlOAOhZCbHjI4H3ZE=
Date:   Fri, 20 Mar 2020 16:48:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     bharata@linux.ibm.com, cl@linux.com, iamjoonsoo.kim@lge.com,
        ktkhai@virtuozzo.com, mgorman@techsingularity.net,
        mhocko@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        nathanl@linux.ibm.com, penberg@kernel.org,
        puvichakravarthy@in.ibm.com, rientjes@google.com,
        sachinp@linux.vnet.ibm.com, srikar@linux.vnet.ibm.com,
        stable@vger.kernel.org, vbabka@suse.cz
Subject:  +
 mm-slub-prevent-kmalloc_node-crashes-and-memory-leaks.patch added to -mm
 tree
Message-ID: <20200320234825.GfL2XD8Hw%akpm@linux-foundation.org>
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, slub: prevent kmalloc_node crashes and memory leaks
has been added to the -mm tree.  Its filename is
     mm-slub-prevent-kmalloc_node-crashes-and-memory-leaks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-prevent-kmalloc_node-crashes-and-memory-leaks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-prevent-kmalloc_node-crashes-and-memory-leaks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: prevent kmalloc_node crashes and memory leaks

Sachin reports [1] a crash in SLUB __slab_alloc():

BUG: Kernel NULL pointer dereference on read at 0x000073b0
Faulting instruction address: 0xc0000000003d55f4
Oops: Kernel access of bad area, sig: 11 [#1]
LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
Modules linked in:
CPU: 19 PID: 1 Comm: systemd Not tainted 5.6.0-rc2-next-20200218-autotest #1
NIP:  c0000000003d55f4 LR: c0000000003d5b94 CTR: 0000000000000000
REGS: c0000008b37836d0 TRAP: 0300   Not tainted  (5.6.0-rc2-next-20200218-autotest)
MSR:  8000000000009033 <SF,EE,ME,IR,DR,RI,LE>  CR: 24004844  XER: 00000000
CFAR: c00000000000dec4 DAR: 00000000000073b0 DSISR: 40000000 IRQMASK: 1
GPR00: c0000000003d5b94 c0000008b3783960 c00000000155d400 c0000008b301f500
GPR04: 0000000000000dc0 0000000000000002 c0000000003443d8 c0000008bb398620
GPR08: 00000008ba2f0000 0000000000000001 0000000000000000 0000000000000000
GPR12: 0000000024004844 c00000001ec52a00 0000000000000000 0000000000000000
GPR16: c0000008a1b20048 c000000001595898 c000000001750c18 0000000000000002
GPR20: c000000001750c28 c000000001624470 0000000fffffffe0 5deadbeef0000122
GPR24: 0000000000000001 0000000000000dc0 0000000000000002 c0000000003443d8
GPR28: c0000008b301f500 c0000008bb398620 0000000000000000 c00c000002287180
NIP [c0000000003d55f4] ___slab_alloc+0x1f4/0x760
LR [c0000000003d5b94] __slab_alloc+0x34/0x60
Call Trace:
[c0000008b3783960] [c0000000003d5734] ___slab_alloc+0x334/0x760 (unreliable)
[c0000008b3783a40] [c0000000003d5b94] __slab_alloc+0x34/0x60
[c0000008b3783a70] [c0000000003d6fa0] __kmalloc_node+0x110/0x490
[c0000008b3783af0] [c0000000003443d8] kvmalloc_node+0x58/0x110
[c0000008b3783b30] [c0000000003fee38] mem_cgroup_css_online+0x108/0x270
[c0000008b3783b90] [c000000000235aa8] online_css+0x48/0xd0
[c0000008b3783bc0] [c00000000023eaec] cgroup_apply_control_enable+0x2ec/0x4d0
[c0000008b3783ca0] [c000000000242318] cgroup_mkdir+0x228/0x5f0
[c0000008b3783d10] [c00000000051e170] kernfs_iop_mkdir+0x90/0xf0
[c0000008b3783d50] [c00000000043dc00] vfs_mkdir+0x110/0x230
[c0000008b3783da0] [c000000000441c90] do_mkdirat+0xb0/0x1a0
[c0000008b3783e20] [c00000000000b278] system_call+0x5c/0x68

This is a PowerPC platform with following NUMA topology:

available: 2 nodes (0-1)
node 0 cpus:
node 0 size: 0 MB
node 0 free: 0 MB
node 1 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
node 1 size: 35247 MB
node 1 free: 30907 MB
node distances:
node   0   1
  0:  10  40
  1:  40  10

possible numa nodes: 0-31

This only happens with a mmotm patch "mm/memcontrol.c: allocate shrinker_map on
appropriate NUMA node" [2] which effectively calls kmalloc_node for each
possible node. SLUB however only allocates kmem_cache_node on online
N_NORMAL_MEMORY nodes, and relies on node_to_mem_node to return such valid node
for other nodes since commit a561ce00b09e ("slub: fall back to
node_to_mem_node() node if allocating on memoryless node"). This is however not
true in this configuration where the _node_numa_mem_ array is not initialized
for nodes 0 and 2-31, thus it contains zeroes and get_partial() ends up
accessing non-allocated kmem_cache_node.

A related issue was reported by Bharata (originally by Ramachandran) [3] where
a similar PowerPC configuration, but with mainline kernel without patch [2]
ends up allocating large amounts of pages by kmalloc-1k kmalloc-512. This seems
to have the same underlying issue with node_to_mem_node() not behaving as
expected, and might probably also lead to an infinite loop with
CONFIG_SLUB_CPU_PARTIAL [4].

This patch should fix both issues by not relying on node_to_mem_node() anymore
and instead simply falling back to NUMA_NO_NODE, when kmalloc_node(node) is
attempted for a node that's not online, or has no usable memory. The "usable
memory" condition is also changed from node_present_pages() to N_NORMAL_MEMORY
node state, as that is exactly the condition that SLUB uses to allocate
kmem_cache_node structures. The check in get_partial() is removed completely,
as the checks in ___slab_alloc() are now sufficient to prevent get_partial()
being reached with an invalid node.

[1] https://lore.kernel.org/linux-next/3381CD91-AB3D-4773-BA04-E7A072A63968@linux.vnet.ibm.com/
[2] https://lore.kernel.org/linux-mm/fff0e636-4c36-ed10-281c-8cdb0687c839@virtuozzo.com/
[3] https://lore.kernel.org/linux-mm/20200317092624.GB22538@in.ibm.com/
[4] https://lore.kernel.org/linux-mm/088b5996-faae-8a56-ef9c-5b567125ae54@suse.cz/

Link: http://lkml.kernel.org/r/20200320115533.9604-1-vbabka@suse.cz
Fixes: a561ce00b09e ("slub: fall back to node_to_mem_node() node if allocating on memoryless node")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Tested-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Reported-by: PUVICHAKRAVARTHY RAMACHANDRAN <puvichakravarthy@in.ibm.com>
Tested-by: Bharata B Rao <bharata@linux.ibm.com>
Debugged-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Christopher Lameter <cl@linux.com>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

--- a/mm/slub.c~mm-slub-prevent-kmalloc_node-crashes-and-memory-leaks
+++ a/mm/slub.c
@@ -1973,8 +1973,6 @@ static void *get_partial(struct kmem_cac
 
 	if (node == NUMA_NO_NODE)
 		searchnode = numa_mem_id();
-	else if (!node_present_pages(node))
-		searchnode = node_to_mem_node(node);
 
 	object = get_partial_node(s, get_node(s, searchnode), c, flags);
 	if (object || node != NUMA_NO_NODE)
@@ -2563,17 +2561,27 @@ static void *___slab_alloc(struct kmem_c
 	struct page *page;
 
 	page = c->page;
-	if (!page)
+	if (!page) {
+		/*
+		 * if the node is not online or has no normal memory, just
+		 * ignore the node constraint
+		 */
+		if (unlikely(node != NUMA_NO_NODE &&
+			     !node_state(node, N_NORMAL_MEMORY)))
+			node = NUMA_NO_NODE;
 		goto new_slab;
+	}
 redo:
 
 	if (unlikely(!node_match(page, node))) {
-		int searchnode = node;
-
-		if (node != NUMA_NO_NODE && !node_present_pages(node))
-			searchnode = node_to_mem_node(node);
-
-		if (unlikely(!node_match(page, searchnode))) {
+		/*
+		 * same as above but node_match() being false already
+		 * implies node != NUMA_NO_NODE
+		 */
+		if (!node_state(node, N_NORMAL_MEMORY)) {
+			node = NUMA_NO_NODE;
+			goto redo;
+		} else {
 			stat(s, ALLOC_NODE_MISMATCH);
 			deactivate_slab(s, page, c->freelist, c);
 			goto new_slab;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-prevent-kmalloc_node-crashes-and-memory-leaks.patch
revert-topology-add-support-for-node_to_mem_node-to-determine-the-fallback-node.patch
mm-compaction-fully-assume-capture-is-not-null-in-compact_zone_order.patch
mm-hugetlb-remove-unnecessary-memory-fetch-in-pageheadhuge.patch

