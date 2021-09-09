Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A920405E95
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 23:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbhIIVIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 17:08:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348160AbhIIVHb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 17:07:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72B9D611B0;
        Thu,  9 Sep 2021 21:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221581;
        bh=AxJCkDEpShrQUlXh5uda1KrXeb96xr+L4noP5Mh8mKc=;
        h=Date:From:To:Subject:From;
        b=xlnj+VUOZQ732MWNAGpHjbfNvJ4iCvxV3drjBFyh54sGXwo7M2CELYKCV6E2GvqXS
         YDMB1AUneIiqif9XqPyFc77C6pjPo7XbWqNrIrac0wiyM2LNDPguUXA0cuE1fX+fwk
         sDu5wnx8HbyAFzmrXK6H6oFZRxr/gkHH6RGnXk6o=
Date:   Thu, 09 Sep 2021 14:06:21 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        stable@vger.kernel.org, yanghui.def@bytedance.com
Subject:  [merged]
 mm-mempolicy-fix-a-race-between-offset_il_node-and-mpol_rebind_task.patch
 removed from -mm tree
Message-ID: <20210909210621.ei9jo8-8M%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: fix a race between offset_il_node and mpol_rebind_task
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-fix-a-race-between-offset_il_node-and-mpol_rebind_task.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: yanghui <yanghui.def@bytedance.com>
Subject: mm/mempolicy: fix a race between offset_il_node and mpol_rebind_task

Servers happened below panic:
Kernel version:5.4.56
BUG: unable to handle page fault for address: 0000000000002c48
RIP: 0010:__next_zones_zonelist+0x1d/0x40
[264003.977696] RAX: 0000000000002c40 RBX: 0000000000100dca RCX: 0000000000000014
[264003.977872] Call Trace:
[264003.977888]  __alloc_pages_nodemask+0x277/0x310
[264003.977908]  alloc_page_interleave+0x13/0x70
[264003.977926]  handle_mm_fault+0xf99/0x1390
[264003.977951]  __do_page_fault+0x288/0x500
[264003.977979]  ? schedule+0x39/0xa0
[264003.977994]  do_page_fault+0x30/0x110
[264003.978010]  page_fault+0x3e/0x50

The reason for the panic is that MAX_NUMNODES is passed in the third
parameter in __alloc_pages_nodemask(preferred_nid).  So access to
zonelist->zoneref->zone_idx in __next_zones_zonelist will cause a panic.

In offset_il_node(), first_node() returns nid from pol->v.nodes, after
this other threads may chang pol->v.nodes before next_node().  This race
condition will let next_node return MAX_NUMNODES.  So put pol->nodes in a
local variable.

The race condition is between offset_il_node and cpuset_change_task_nodemask:
CPU0:                                     CPU1:
alloc_pages_vma()
  interleave_nid(pol,)
    offset_il_node(pol,)
      first_node(pol->v.nodes)            cpuset_change_task_nodemask
                      //nodes==0xc          mpol_rebind_task
                                              mpol_rebind_policy
                                                mpol_rebind_nodemask(pol,nodes)
                      //nodes==0x3
      next_node(nid, pol->v.nodes)//return MAX_NUMNODES

Link: https://lkml.kernel.org/r/20210906034658.48721-1-yanghui.def@bytedance.com
Signed-off-by: yanghui <yanghui.def@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-a-race-between-offset_il_node-and-mpol_rebind_task
+++ a/mm/mempolicy.c
@@ -1876,17 +1876,26 @@ unsigned int mempolicy_slab_node(void)
  */
 static unsigned offset_il_node(struct mempolicy *pol, unsigned long n)
 {
-	unsigned nnodes = nodes_weight(pol->nodes);
-	unsigned target;
+	nodemask_t nodemask = pol->nodes;
+	unsigned int target, nnodes;
 	int i;
 	int nid;
+	/*
+	 * The barrier will stabilize the nodemask in a register or on
+	 * the stack so that it will stop changing under the code.
+	 *
+	 * Between first_node() and next_node(), pol->nodes could be changed
+	 * by other threads. So we put pol->nodes in a local stack.
+	 */
+	barrier();
 
+	nnodes = nodes_weight(nodemask);
 	if (!nnodes)
 		return numa_node_id();
 	target = (unsigned int)n % nnodes;
-	nid = first_node(pol->nodes);
+	nid = first_node(nodemask);
 	for (i = 0; i < target; i++)
-		nid = next_node(nid, pol->nodes);
+		nid = next_node(nid, nodemask);
 	return nid;
 }
 
_

Patches currently in -mm which might be from yanghui.def@bytedance.com are


