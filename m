Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13ADB68D24F
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 10:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbjBGJOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 04:14:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbjBGJOo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 04:14:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2301ABDF
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 01:14:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0775C61228
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 09:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB15EC433EF;
        Tue,  7 Feb 2023 09:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675761282;
        bh=rfBAp/i9SX0YV3T/RGUzFjl4n2LIGHW331QFTIb6Sug=;
        h=Subject:To:Cc:From:Date:From;
        b=wRlQTdVM/JshOjamAzjfQBfjRruEYsGjorY7l5bCouXGp6zgAGZe9e21FYloGxtZ5
         WdW9glrkWmPTReepNwcf2VM2EtVBQ2mJ2XdIPu59rY25LI63IhWx4WqKJFhAL+Tbyg
         8/0l/qd4bDIT95S+dxf7p6b5ktsEfTLbA9ubug/I=
Subject: FAILED: patch "[PATCH] mm/khugepaged: fix ->anon_vma race" failed to apply to 4.14-stable tree
To:     jannh@google.com, akpm@linux-foundation.org, david@redhat.com,
        kirill.shutemov@intel.linux.com, shy828301@gmail.com,
        stable@vger.kernel.org, zokeefe@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Feb 2023 10:14:31 +0100
Message-ID: <167576127113325@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

023f47a8250c ("mm/khugepaged: fix ->anon_vma race")
34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
58ac9a8993a1 ("mm/khugepaged: attempt to map file/shmem-backed pte-mapped THPs by pmds")
780a4b6fb865 ("mm/khugepaged: check compound_order() in collapse_pte_mapped_thp()")
b26e27015ec9 ("mm: thp: convert to use common struct mm_slot")
685405020b9f ("mm/khugepaged: stop using vma linked list")
7d2c4385c341 ("mm/khugepaged: rename prefix of shared collapse functions")
7d8faaf15545 ("mm/madvise: introduce MADV_COLLAPSE sync hugepage collapse")
507228044236 ("mm/khugepaged: record SCAN_PMD_MAPPED when scan_pmd() finds hugepage")
a7f4e6e4c47c ("mm/thp: add flag to enforce sysfs THP in hugepage_vma_check()")
50ad2f24b3b4 ("mm/khugepaged: propagate enum scan_result codes back to callers")
9710a78ab2ae ("mm/khugepaged: dedup and simplify hugepage alloc and charging")
34d6b470ab9c ("mm/khugepaged: add struct collapse_control")
c6a7f445a272 ("mm: khugepaged: don't carry huge page to the next loop for !CONFIG_NUMA")
1064026bab9f ("mm: khugepaged: reorg some khugepaged helpers")
7da4e2cb8b1f ("mm: thp: kill __transhuge_page_enabled()")
9fec51689ff6 ("mm: thp: kill transparent_hugepage_active()")
f707fa493784 ("mm: khugepaged: better comments for anon vma check in hugepage_vma_revalidate")
4fa6893faeaa ("mm: thp: consolidate vma size check to transhuge_vma_suitable")
66137fb34a4b ("mm: khugepaged: check THP flag in hugepage_vma_check()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 023f47a8250c6bdb4aebe744db4bf7f73414028b Mon Sep 17 00:00:00 2001
From: Jann Horn <jannh@google.com>
Date: Wed, 11 Jan 2023 14:33:51 +0100
Subject: [PATCH] mm/khugepaged: fix ->anon_vma race

If an ->anon_vma is attached to the VMA, collapse_and_free_pmd() requires
it to be locked.

Page table traversal is allowed under any one of the mmap lock, the
anon_vma lock (if the VMA is associated with an anon_vma), and the
mapping lock (if the VMA is associated with a mapping); and so to be
able to remove page tables, we must hold all three of them.
retract_page_tables() bails out if an ->anon_vma is attached, but does
this check before holding the mmap lock (as the comment above the check
explains).

If we racily merged an existing ->anon_vma (shared with a child
process) from a neighboring VMA, subsequent rmap traversals on pages
belonging to the child will be able to see the page tables that we are
concurrently removing while assuming that nothing else can access them.

Repeat the ->anon_vma check once we hold the mmap lock to ensure that
there really is no concurrent page table access.

Hitting this bug causes a lockdep warning in collapse_and_free_pmd(),
in the line "lockdep_assert_held_write(&vma->anon_vma->root->rwsem)".
It can also lead to use-after-free access.

Link: https://lore.kernel.org/linux-mm/CAG48ez3434wZBKFFbdx4M9j6eUwSUVPd4dxhzW_k_POneSDF+A@mail.gmail.com/
Link: https://lkml.kernel.org/r/20230111133351.807024-1-jannh@google.com
Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem pages")
Signed-off-by: Jann Horn <jannh@google.com>
Reported-by: Zach O'Keefe <zokeefe@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@intel.linux.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 79be13133322..935aa8b71d1c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1642,7 +1642,7 @@ static int retract_page_tables(struct address_space *mapping, pgoff_t pgoff,
 		 * has higher cost too. It would also probably require locking
 		 * the anon_vma.
 		 */
-		if (vma->anon_vma) {
+		if (READ_ONCE(vma->anon_vma)) {
 			result = SCAN_PAGE_ANON;
 			goto next;
 		}
@@ -1670,6 +1670,18 @@ static int retract_page_tables(struct address_space *mapping, pgoff_t pgoff,
 		result = SCAN_PTE_MAPPED_HUGEPAGE;
 		if ((cc->is_khugepaged || is_target) &&
 		    mmap_write_trylock(mm)) {
+			/*
+			 * Re-check whether we have an ->anon_vma, because
+			 * collapse_and_free_pmd() requires that either no
+			 * ->anon_vma exists or the anon_vma is locked.
+			 * We already checked ->anon_vma above, but that check
+			 * is racy because ->anon_vma can be populated under the
+			 * mmap lock in read mode.
+			 */
+			if (vma->anon_vma) {
+				result = SCAN_PAGE_ANON;
+				goto unlock_next;
+			}
 			/*
 			 * When a vma is registered with uffd-wp, we can't
 			 * recycle the pmd pgtable because there can be pte

