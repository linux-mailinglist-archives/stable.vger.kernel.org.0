Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83F6C61581D
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbiKBCpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiKBCpi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:45:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF73320F66
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:45:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79E9DB82075
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0EEC433D6;
        Wed,  2 Nov 2022 02:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357135;
        bh=vAYOtUxPKtKKMTHciRMMwaYZ0q7PAkLwIDwOv9ss5wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJMaW6DmAOoVwG/lYUL1+/4jKEQaaavwMdKUPBHNn7dvSbS1rDf8+vCdxClimJ+GT
         dPgXhYH5D0mpF2bm5DnnUSyx2LHjaTjJIb4BD7pp6ZQ04uQh3a7g1ZbQqLRJ4qS1Zu
         IRI2yGEGSRDT2bY5ua2Yp1e76x1hsVvUIJTZ7sFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mel Gorman <mgorman@techsingularity.net>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Yang Shi <shy828301@gmail.com>,
        Brian Foster <bfoster@redhat.com>,
        Dan Streetman <ddstreet@ieee.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Seth Jennings <sjenning@redhat.com>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 091/240] mm/huge_memory: do not clobber swp_entry_t during THP split
Date:   Wed,  2 Nov 2022 03:31:06 +0100
Message-Id: <20221102022113.454626293@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>

commit 71e2d666ef85d51834d658830f823560c402b8b6 upstream.

The following has been observed when running stressng mmap since commit
b653db77350c ("mm: Clear page->private when splitting or migrating a page")

   watchdog: BUG: soft lockup - CPU#75 stuck for 26s! [stress-ng:9546]
   CPU: 75 PID: 9546 Comm: stress-ng Tainted: G            E      6.0.0-revert-b653db77-fix+ #29 0357d79b60fb09775f678e4f3f64ef0579ad1374
   Hardware name: SGI.COM C2112-4GP3/X10DRT-P-Series, BIOS 2.0a 05/09/2016
   RIP: 0010:xas_descend+0x28/0x80
   Code: cc cc 0f b6 0e 48 8b 57 08 48 d3 ea 83 e2 3f 89 d0 48 83 c0 04 48 8b 44 c6 08 48 89 77 18 48 89 c1 83 e1 03 48 83 f9 02 75 08 <48> 3d fd 00 00 00 76 08 88 57 12 c3 cc cc cc cc 48 c1 e8 02 89 c2
   RSP: 0018:ffffbbf02a2236a8 EFLAGS: 00000246
   RAX: ffff9cab7d6a0002 RBX: ffffe04b0af88040 RCX: 0000000000000002
   RDX: 0000000000000030 RSI: ffff9cab60509b60 RDI: ffffbbf02a2236c0
   RBP: 0000000000000000 R08: ffff9cab60509b60 R09: ffffbbf02a2236c0
   R10: 0000000000000001 R11: ffffbbf02a223698 R12: 0000000000000000
   R13: ffff9cab4e28da80 R14: 0000000000039c01 R15: ffff9cab4e28da88
   FS:  00007fab89b85e40(0000) GS:ffff9cea3fcc0000(0000) knlGS:0000000000000000
   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   CR2: 00007fab84e00000 CR3: 00000040b73a4003 CR4: 00000000003706e0
   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
   Call Trace:
    <TASK>
    xas_load+0x3a/0x50
    __filemap_get_folio+0x80/0x370
    ? put_swap_page+0x163/0x360
    pagecache_get_page+0x13/0x90
    __try_to_reclaim_swap+0x50/0x190
    scan_swap_map_slots+0x31e/0x670
    get_swap_pages+0x226/0x3c0
    folio_alloc_swap+0x1cc/0x240
    add_to_swap+0x14/0x70
    shrink_page_list+0x968/0xbc0
    reclaim_page_list+0x70/0xf0
    reclaim_pages+0xdd/0x120
    madvise_cold_or_pageout_pte_range+0x814/0xf30
    walk_pgd_range+0x637/0xa30
    __walk_page_range+0x142/0x170
    walk_page_range+0x146/0x170
    madvise_pageout+0xb7/0x280
    ? asm_common_interrupt+0x22/0x40
    madvise_vma_behavior+0x3b7/0xac0
    ? find_vma+0x4a/0x70
    ? find_vma+0x64/0x70
    ? madvise_vma_anon_name+0x40/0x40
    madvise_walk_vmas+0xa6/0x130
    do_madvise+0x2f4/0x360
    __x64_sys_madvise+0x26/0x30
    do_syscall_64+0x5b/0x80
    ? do_syscall_64+0x67/0x80
    ? syscall_exit_to_user_mode+0x17/0x40
    ? do_syscall_64+0x67/0x80
    ? syscall_exit_to_user_mode+0x17/0x40
    ? do_syscall_64+0x67/0x80
    ? do_syscall_64+0x67/0x80
    ? common_interrupt+0x8b/0xa0
    entry_SYSCALL_64_after_hwframe+0x63/0xcd

The problem can be reproduced with the mmtests config
config-workload-stressng-mmap.  It does not always happen and when it
triggers is variable but it has happened on multiple machines.

The intent of commit b653db77350c patch was to avoid the case where
PG_private is clear but folio->private is not-NULL.  However, THP tail
pages uses page->private for "swp_entry_t if folio_test_swapcache()" as
stated in the documentation for struct folio.  This patch only clobbers
page->private for tail pages if the head page was not in swapcache and
warns once if page->private had an unexpected value.

Link: https://lkml.kernel.org/r/20221019134156.zjyyn5aownakvztf@techsingularity.net
Fixes: b653db77350c ("mm: Clear page->private when splitting or migrating a page")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2445,7 +2445,16 @@ static void __split_huge_page_tail(struc
 			page_tail);
 	page_tail->mapping = head->mapping;
 	page_tail->index = head->index + tail;
-	page_tail->private = 0;
+
+	/*
+	 * page->private should not be set in tail pages with the exception
+	 * of swap cache pages that store the swp_entry_t in tail pages.
+	 * Fix up and warn once if private is unexpectedly set.
+	 */
+	if (!folio_test_swapcache(page_folio(head))) {
+		VM_WARN_ON_ONCE_PAGE(page_tail->private != 0, head);
+		page_tail->private = 0;
+	}
 
 	/* Page flags must be visible before we make the page non-compound. */
 	smp_wmb();


