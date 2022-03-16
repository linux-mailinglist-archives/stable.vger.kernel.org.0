Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD324DBA71
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 22:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358201AbiCPWAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 18:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356693AbiCPWAQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 18:00:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7242183F;
        Wed, 16 Mar 2022 14:59:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70A25B81CE8;
        Wed, 16 Mar 2022 21:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB93C340E9;
        Wed, 16 Mar 2022 21:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647467938;
        bh=Y3CcxMe1+8xCuYIMXNEFP4fxuLf/+TIF+RAfoizJIGg=;
        h=Date:To:From:Subject:From;
        b=h0yRUJ6siR+tZbNjOhcYKiLT9lBAly5usEcuP+RJsg1ItlG45zfKWLzd+uxIcBuLm
         Ro0SNjzFebqR7Nwd7Vvj8Xi0zKgtxchWzmIAfDgAtJbTootIrMsdVIIZ3qJRDMDYm2
         4R/6zxrLlFvYEL4LHuGr6pWUBw7YyvZ2kQWY2hMk=
Date:   Wed, 16 Mar 2022 14:58:57 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, stable@vger.kernel.org,
        osalvador@suse.de, mhocko@suse.com, dennis@kernel.org,
        david@redhat.com, cl@linux.com, amakhalov@vmware.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-fix-panic-in-__alloc_pages.patch removed from -mm tree
Message-Id: <20220316215858.0DB93C340E9@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: fix panic in __alloc_pages
has been removed from the -mm tree.  Its filename was
     mm-fix-panic-in-__alloc_pages.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Alexey Makhalov <amakhalov@vmware.com>
Subject: mm: fix panic in __alloc_pages

There is a kernel panic caused by pcpu_alloc_pages() passing offlined and
uninitialized node to alloc_pages_node() leading to panic by NULL
dereferencing uninitialized NODE_DATA(nid).

 CPU2 has been hot-added
 BUG: unable to handle page fault for address: 0000000000001608
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] SMP PTI
 CPU: 0 PID: 1 Comm: systemd Tainted: G            E     5.15.0-rc7+ #11
 Hardware name: VMware, Inc. VMware7,1/440BX Desktop Reference Platform, BIOS VMW

 RIP: 0010:__alloc_pages+0x127/0x290
 Code: 4c 89 f0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 44 89 e0 48 8b 55 b8 c1 e8 0c 83 e0 01 88 45 d0 4c 89 c8 48 85 d2 0f 85 1a 01 00 00 <45> 3b 41 08 0f 82 10 01 00 00 48 89 45 c0 48 8b 00 44 89 e2 81 e2
 RSP: 0018:ffffc900006f3bc8 EFLAGS: 00010246
 RAX: 0000000000001600 RBX: 0000000000000000 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000cc2
 RBP: ffffc900006f3c18 R08: 0000000000000001 R09: 0000000000001600
 R10: ffffc900006f3a40 R11: ffff88813c9fffe8 R12: 0000000000000cc2
 R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000cc2
 FS:  00007f27ead70500(0000) GS:ffff88807ce00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000001608 CR3: 000000000582c003 CR4: 00000000001706b0
 Call Trace:
  pcpu_alloc_pages.constprop.0+0xe4/0x1c0
  pcpu_populate_chunk+0x33/0xb0
  pcpu_alloc+0x4d3/0x6f0
  __alloc_percpu_gfp+0xd/0x10
  alloc_mem_cgroup_per_node_info+0x54/0xb0
  mem_cgroup_alloc+0xed/0x2f0
  mem_cgroup_css_alloc+0x33/0x2f0
  css_create+0x3a/0x1f0
  cgroup_apply_control_enable+0x12b/0x150
  cgroup_mkdir+0xdd/0x110
  kernfs_iop_mkdir+0x4f/0x80
  vfs_mkdir+0x178/0x230
  do_mkdirat+0xfd/0x120
  __x64_sys_mkdir+0x47/0x70
  ? syscall_exit_to_user_mode+0x21/0x50
  do_syscall_64+0x43/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Panic can be easily reproduced by disabling udev rule for automatic
onlining hot added CPU followed by CPU with memoryless node (NUMA node
with CPU only) hot add.

Hot adding CPU and memoryless node does not bring the node to online
state.  Memoryless node will be onlined only during the onlining its CPU.

Node can be in one of the following states:
1. not present.(nid == NUMA_NO_NODE)
2. present, but offline (nid > NUMA_NO_NODE, node_online(nid) == 0,
				NODE_DATA(nid) == NULL)
3. present and online (nid > NUMA_NO_NODE, node_online(nid) > 0,
				NODE_DATA(nid) != NULL)

Percpu code is doing allocations for all possible CPUs.  The issue happens
when it serves hot added but not yet onlined CPU when its node is in 2nd
state.  This node is not ready to use, fallback to numa_mem_id().

Link: https://lkml.kernel.org/r/20211108202325.20304-1-amakhalov@vmware.com
Signed-off-by: Alexey Makhalov <amakhalov@vmware.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Dennis Zhou <dennis@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu-vm.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/percpu-vm.c~mm-fix-panic-in-__alloc_pages
+++ a/mm/percpu-vm.c
@@ -84,15 +84,19 @@ static int pcpu_alloc_pages(struct pcpu_
 			    gfp_t gfp)
 {
 	unsigned int cpu, tcpu;
-	int i;
+	int i, nid;
 
 	gfp |= __GFP_HIGHMEM;
 
 	for_each_possible_cpu(cpu) {
+		nid = cpu_to_node(cpu);
+		if (nid == NUMA_NO_NODE || !node_online(nid))
+			nid = numa_mem_id();
+
 		for (i = page_start; i < page_end; i++) {
 			struct page **pagep = &pages[pcpu_page_idx(cpu, i)];
 
-			*pagep = alloc_pages_node(cpu_to_node(cpu), gfp, 0);
+			*pagep = alloc_pages_node(nid, gfp, 0);
 			if (!*pagep)
 				goto err;
 		}
_

Patches currently in -mm which might be from amakhalov@vmware.com are


