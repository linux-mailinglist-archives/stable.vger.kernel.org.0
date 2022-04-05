Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 950874F3313
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238184AbiDEKeV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239654AbiDEJeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:34:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF430765BF;
        Tue,  5 Apr 2022 02:22:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8022BB81C82;
        Tue,  5 Apr 2022 09:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3404C385A0;
        Tue,  5 Apr 2022 09:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150569;
        bh=ZVxBPKQvOrh1G+gK9bV1ofevUQ3EaZJg0aUZSZ2aC7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LoUgxCxVJp7t2CuRzdhMUxjZMdRdtM9WhGa9y9FhFJ4SbKBc1ARFz/UlCzq9+Dmi6
         hWs5AiuySvGA4kdcRzu//B5SlFCz8V4pBtKjm8IW/0wEd/NAE3uzs6OPt/CsKF7zyM
         hERwBNEzUE8adY5YxJOv0FWPcRYq2no9YVW8nQP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alistair Popple <apopple@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        John Hubbard <jhubbard@nvidia.com>, Zi Yan <ziy@nvidia.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Oscar Salvador <osalvador@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 084/913] mm/pages_alloc.c: dont create ZONE_MOVABLE beyond the end of a node
Date:   Tue,  5 Apr 2022 09:19:06 +0200
Message-Id: <20220405070342.340709627@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alistair Popple <apopple@nvidia.com>

commit ddbc84f3f595cf1fc8234a191193b5d20ad43938 upstream.

ZONE_MOVABLE uses the remaining memory in each node.  Its starting pfn
is also aligned to MAX_ORDER_NR_PAGES.  It is possible for the remaining
memory in a node to be less than MAX_ORDER_NR_PAGES, meaning there is
not enough room for ZONE_MOVABLE on that node.

Unfortunately this condition is not checked for.  This leads to
zone_movable_pfn[] getting set to a pfn greater than the last pfn in a
node.

calculate_node_totalpages() then sets zone->present_pages to be greater
than zone->spanned_pages which is invalid, as spanned_pages represents
the maximum number of pages in a zone assuming no holes.

Subsequently it is possible free_area_init_core() will observe a zone of
size zero with present pages.  In this case it will skip setting up the
zone, including the initialisation of free_lists[].

However populated_zone() checks zone->present_pages to see if a zone has
memory available.  This is used by iterators such as
walk_zones_in_node().  pagetypeinfo_showfree() uses this to walk the
free_list of each zone in each node, which are assumed to be initialised
due to the zone not being empty.

As free_area_init_core() never initialised the free_lists[] this results
in the following kernel crash when trying to read /proc/pagetypeinfo:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
  CPU: 0 PID: 456 Comm: cat Not tainted 5.16.0 #461
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
  RIP: 0010:pagetypeinfo_show+0x163/0x460
  Code: 9e 82 e8 80 57 0e 00 49 8b 06 b9 01 00 00 00 4c 39 f0 75 16 e9 65 02 00 00 48 83 c1 01 48 81 f9 a0 86 01 00 0f 84 48 02 00 00 <48> 8b 00 4c 39 f0 75 e7 48 c7 c2 80 a2 e2 82 48 c7 c6 79 ef e3 82
  RSP: 0018:ffffc90001c4bd10 EFLAGS: 00010003
  RAX: 0000000000000000 RBX: ffff88801105f638 RCX: 0000000000000001
  RDX: 0000000000000001 RSI: 000000000000068b RDI: ffff8880163dc68b
  RBP: ffffc90001c4bd90 R08: 0000000000000001 R09: ffff8880163dc67e
  R10: 656c6261766f6d6e R11: 6c6261766f6d6e55 R12: ffff88807ffb4a00
  R13: ffff88807ffb49f8 R14: ffff88807ffb4580 R15: ffff88807ffb3000
  FS:  00007f9c83eff5c0(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000000 CR3: 0000000013c8e000 CR4: 0000000000350ef0
  Call Trace:
   seq_read_iter+0x128/0x460
   proc_reg_read_iter+0x51/0x80
   new_sync_read+0x113/0x1a0
   vfs_read+0x136/0x1d0
   ksys_read+0x70/0xf0
   __x64_sys_read+0x1a/0x20
   do_syscall_64+0x3b/0xc0
   entry_SYSCALL_64_after_hwframe+0x44/0xae

Fix this by checking that the aligned zone_movable_pfn[] does not exceed
the end of the node, and if it does skip creating a movable zone on this
node.

Link: https://lkml.kernel.org/r/20220215025831.2113067-1-apopple@nvidia.com
Fixes: 2a1e274acf0b ("Create the ZONE_MOVABLE zone")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7899,10 +7899,17 @@ restart:
 
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


