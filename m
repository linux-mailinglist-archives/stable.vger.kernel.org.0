Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 046234B7A57
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 23:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243959AbiBOWRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 17:17:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244549AbiBOWRL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 17:17:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48352AC73;
        Tue, 15 Feb 2022 14:16:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73D7D60B81;
        Tue, 15 Feb 2022 22:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03AEC340EB;
        Tue, 15 Feb 2022 22:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644963418;
        bh=UniqfsgCb3F+Dbb8zGGA7iIIaDQl0TdQFxJzx72t/fY=;
        h=Date:To:From:Subject:From;
        b=JzP4aPLSPG//hljAOWrYxe6+XvIZyx3qDFq09owT3iSpBLcSYWLRG7q8dm8kNFu4L
         MNbJm1kJNnK6HAyCiMxInRQlnmhqgmlRvThNxrJGNKEyNzwHk8vlcw8TDmwjrhGQtd
         bAae3tZ179Vm4oWdoCF2+GYbqqTEEKFff9n4UTmY=
Date:   Tue, 15 Feb 2022 14:16:58 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, stable@vger.kernel.org,
        osalvador@suse.de, mgorman@techsingularity.net,
        jhubbard@nvidia.com, anshuman.khandual@arm.com, apopple@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pages_allocc-dont-create-zone_movable-beyond-the-end-of-a-node.patch added to -mm tree
Message-Id: <20220215221658.D03AEC340EB@smtp.kernel.org>
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
     Subject: mm/pages_alloc.c: don't create ZONE_MOVABLE beyond the end of a node
has been added to the -mm tree.  Its filename is
     mm-pages_allocc-dont-create-zone_movable-beyond-the-end-of-a-node.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-pages_allocc-dont-create-zone_movable-beyond-the-end-of-a-node.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-pages_allocc-dont-create-zone_movable-beyond-the-end-of-a-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/pages_alloc.c: don't create ZONE_MOVABLE beyond the end of a node

ZONE_MOVABLE uses the remaining memory in each node.  Its starting pfn is
also aligned to MAX_ORDER_NR_PAGES.  It is possible for the remaining
memory in a node to be less than MAX_ORDER_NR_PAGES, meaning there is not
enough room for ZONE_MOVABLE on that node.

Unfortunately this condition is not checked for.  This leads to
zone_movable_pfn[] getting set to a pfn greater than the last pfn in a
node.

calculate_node_totalpages() then sets zone->present_pages to be greater
than zone->spanned_pages which is invalid, as spanned_pages represents the
maximum number of pages in a zone assuming no holes.

Subsequently it is possible free_area_init_core() will observe a zone of
size zero with present pages.  In this case it will skip setting up the
zone, including the initialisation of free_lists[].

However populated_zone() checks zone->present_pages to see if a zone has
memory available.  This is used by iterators such as walk_zones_in_node().
pagetypeinfo_showfree() uses this to walk the free_list of each zone in
each node, which are assumed to be initialised due to the zone not being
empty.  As free_area_init_core() never initialised the free_lists[] this
results in the following kernel crash when trying to read
/proc/pagetypeinfo:

[   67.534914] BUG: kernel NULL pointer dereference, address: 0000000000000000
[   67.535429] #PF: supervisor read access in kernel mode
[   67.535789] #PF: error_code(0x0000) - not-present page
[   67.536128] PGD 0 P4D 0
[   67.536305] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
[   67.536696] CPU: 0 PID: 456 Comm: cat Not tainted 5.16.0 #461
[   67.537096] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
[   67.537638] RIP: 0010:pagetypeinfo_show+0x163/0x460
[   67.537992] Code: 9e 82 e8 80 57 0e 00 49 8b 06 b9 01 00 00 00 4c 39 f0 75 16 e9 65 02 00 00 48 83 c1 01 48 81 f9 a0 86 01 00 0f 84 48 02 00 00 <48> 8b 00 4c 39 f0 75 e7 48 c7 c2 80 a2 e2 82 48 c7 c6 79 ef e3 82
[   67.538259] RSP: 0018:ffffc90001c4bd10 EFLAGS: 00010003
[   67.538259] RAX: 0000000000000000 RBX: ffff88801105f638 RCX: 0000000000000001
[   67.538259] RDX: 0000000000000001 RSI: 000000000000068b RDI: ffff8880163dc68b
[   67.538259] RBP: ffffc90001c4bd90 R08: 0000000000000001 R09: ffff8880163dc67e
[   67.538259] R10: 656c6261766f6d6e R11: 6c6261766f6d6e55 R12: ffff88807ffb4a00
[   67.538259] R13: ffff88807ffb49f8 R14: ffff88807ffb4580 R15: ffff88807ffb3000
[   67.538259] FS:  00007f9c83eff5c0(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
[   67.538259] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   67.538259] CR2: 0000000000000000 CR3: 0000000013c8e000 CR4: 0000000000350ef0
[   67.538259] Call Trace:
[   67.538259]  <TASK>
[   67.538259]  seq_read_iter+0x128/0x460
[   67.538259]  ? aa_file_perm+0x1af/0x5f0
[   67.538259]  proc_reg_read_iter+0x51/0x80
[   67.538259]  ? lock_is_held_type+0xea/0x140
[   67.538259]  new_sync_read+0x113/0x1a0
[   67.538259]  vfs_read+0x136/0x1d0
[   67.538259]  ksys_read+0x70/0xf0
[   67.538259]  __x64_sys_read+0x1a/0x20
[   67.538259]  do_syscall_64+0x3b/0xc0
[   67.538259]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   67.538259] RIP: 0033:0x7f9c83e23cce
[   67.538259] Code: c0 e9 b6 fe ff ff 50 48 8d 3d 6e 13 0a 00 e8 c9 e3 01 00 66 0f 1f 84 00 00 00 00 00 64 8b 04 25 18 00 00 00 85 c0 75 14 0f 05 <48> 3d 00 f0 ff ff 77 5a c3 66 0f 1f 84 00 00 00 00 00 48 83 ec 28
[   67.538259] RSP: 002b:00007fff116e1a08 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[   67.538259] RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007f9c83e23cce
[   67.538259] RDX: 0000000000020000 RSI: 00007f9c83a2c000 RDI: 0000000000000003
[   67.538259] RBP: 00007f9c83a2c000 R08: 00007f9c83a2b010 R09: 0000000000000000
[   67.538259] R10: 00007f9c83f2d7d0 R11: 0000000000000246 R12: 0000000000000000
[   67.538259] R13: 0000000000000003 R14: 0000000000020000 R15: 0000000000020000
[   67.538259]  </TASK>

Fix this by checking that the aligned zone_movable_pfn[] does not exceed
the end of the node, and if it does skip creating a movable zone on this
node.

Link: https://lkml.kernel.org/r/20220215025831.2113067-1-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Fixes: 2a1e274acf0b ("Create the ZONE_MOVABLE zone")
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-pages_allocc-dont-create-zone_movable-beyond-the-end-of-a-node
+++ a/mm/page_alloc.c
@@ -7998,10 +7998,17 @@ restart:
 
 out2:
 	/* Align start of ZONE_MOVABLE on all nids to MAX_ORDER_NR_PAGES */
-	for (nid = 0; nid < MAX_NUMNODES; nid++)
+	for (nid = 0; nid < MAX_NUMNODES; nid++) {
+		unsigned long start_pfn, end_pfn;
+
 		zone_movable_pfn[nid] =
 			roundup(zone_movable_pfn[nid], MAX_ORDER_NR_PAGES);
 
+		get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
+		if (zone_movable_pfn[nid] >= end_pfn)
+			zone_movable_pfn[nid] = 0;
+	}
+
 out:
 	/* restore the node_state */
 	node_states[N_MEMORY] = saved_node_state;
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-pages_allocc-dont-create-zone_movable-beyond-the-end-of-a-node.patch
mm-remove-the-vma-check-in-migrate_vma_setup.patch
mm-gup-migrate-device-coherent-pages-when-pinning-instead-of-failing.patch

