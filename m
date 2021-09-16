Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 045A240E8B6
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356134AbhIPRpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:45:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355681AbhIPRl7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:41:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6460F6326A;
        Thu, 16 Sep 2021 16:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811242;
        bh=zOxIMmM7JqWdZCY4KIrYNtd1vD/SZ3H0XjVafAUFlXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PO3hTT8mgbof//V6683nlY6FKKKtMu9hoxW06yFwmr0z7G8spJkNGrJTPyYgabWsl
         XliufxTDXxjMzc+dvsYjKizaIBy/0geOGF7K3m8M1gLtHxde/585oMfjvkvVlC4iIP
         VMjgAtissi7qHM2QvM1gtbsTCg7I2waa7w20Uasc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, yanghui <yanghui.def@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.14 409/432] mm/mempolicy: fix a race between offset_il_node and mpol_rebind_task
Date:   Thu, 16 Sep 2021 18:02:38 +0200
Message-Id: <20210916155824.711041910@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yanghui <yanghui.def@bytedance.com>

commit 276aeee1c5fc00df700f0782060beae126600472 upstream.

Servers happened below panic:

  Kernel version:5.4.56
  BUG: unable to handle page fault for address: 0000000000002c48
  RIP: 0010:__next_zones_zonelist+0x1d/0x40
  Call Trace:
    __alloc_pages_nodemask+0x277/0x310
    alloc_page_interleave+0x13/0x70
    handle_mm_fault+0xf99/0x1390
    __do_page_fault+0x288/0x500
    do_page_fault+0x30/0x110
    page_fault+0x3e/0x50

The reason for the panic is that MAX_NUMNODES is passed in the third
parameter in __alloc_pages_nodemask(preferred_nid).  So access to
zonelist->zoneref->zone_idx in __next_zones_zonelist will cause a panic.

In offset_il_node(), first_node() returns nid from pol->v.nodes, after
this other threads may chang pol->v.nodes before next_node().  This race
condition will let next_node return MAX_NUMNODES.  So put pol->nodes in
a local variable.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mempolicy.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1965,17 +1965,26 @@ unsigned int mempolicy_slab_node(void)
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
 


