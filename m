Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A756EBA6F
	for <lists+stable@lfdr.de>; Sat, 22 Apr 2023 18:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjDVQpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Apr 2023 12:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjDVQpe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Apr 2023 12:45:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84731FEE
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 09:45:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54B0E61207
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 16:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E77C433D2;
        Sat, 22 Apr 2023 16:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682181931;
        bh=DS+3n9bivplLHzYe31Ku76O5w8xEzm/usKYlK5lVUgI=;
        h=Subject:To:Cc:From:Date:From;
        b=Qii5yJAptk9MrckaSKqD30/QVaDvc3LajO/LQCsFqyetyGsWnEGrfEpY8COXDYXXd
         4XajvOxl0WCejZtOpKLSRKLUqlAodJ+q0VUgUOTEkQ0Qx3x5wg9xJm8ZJO+llCqK48
         nUxrEA9FVD90wfZ+AjJlDWlSnCqvVkLBtEA1HuWc=
Subject: FAILED: patch "[PATCH] mm/userfaultfd: fix uffd-wp handling for THP migration" failed to apply to 5.10-stable tree
To:     david@redhat.com, akpm@linux-foundation.org, peterx@redhat.com,
        stable@vger.kernel.org, usama.anjum@collabora.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 22 Apr 2023 18:45:18 +0200
Message-ID: <2023042218-hexagon-cheese-b961@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x 24bf08c4376be417f16ceb609188b16f461b0443
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023042218-hexagon-cheese-b961@gregkh' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

24bf08c4376b ("mm/userfaultfd: fix uffd-wp handling for THP migration entries")
6c287605fd56 ("mm: remember exclusively mapped anonymous pages with PG_anon_exclusive")
6c54dc6c7437 ("mm/rmap: use page_move_anon_rmap() when reusing a mapped PageAnon() page exclusively")
28c5209dfd5f ("mm/rmap: pass rmap flags to hugepage_add_anon_rmap()")
f1e2db12e45b ("mm/rmap: remove do_page_add_anon_rmap()")
14f9135d5470 ("mm/rmap: convert RMAP flags to a proper distinct rmap_t type")
fb3d824d1a46 ("mm/rmap: split page_dup_rmap() into page_dup_file_rmap() and page_try_dup_anon_rmap()")
b51ad4f8679e ("mm/memory: slightly simplify copy_present_pte()")
623a1ddfeb23 ("mm/hugetlb: take src_mm->write_protect_seq in copy_hugetlb_page_range()")
3bff7e3f1f16 ("mm/huge_memory: streamline COW logic in do_huge_pmd_wp_page()")
c145e0b47c77 ("mm: streamline COW logic in do_swap_page()")
84d60fdd3733 ("mm: slightly clarify KSM logic in do_swap_page()")
53a05ad9f21d ("mm: optimize do_wp_page() for exclusive pages in the swapcache")
9030fb0bb9d6 ("Merge tag 'folio-5.18c' of git://git.infradead.org/users/willy/pagecache")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 24bf08c4376be417f16ceb609188b16f461b0443 Mon Sep 17 00:00:00 2001
From: David Hildenbrand <david@redhat.com>
Date: Wed, 5 Apr 2023 18:02:35 +0200
Subject: [PATCH] mm/userfaultfd: fix uffd-wp handling for THP migration
 entries

Looks like what we fixed for hugetlb in commit 44f86392bdd1 ("mm/hugetlb:
fix uffd-wp handling for migration entries in
hugetlb_change_protection()") similarly applies to THP.

Setting/clearing uffd-wp on THP migration entries is not implemented
properly.  Further, while removing migration PMDs considers the uffd-wp
bit, inserting migration PMDs does not consider the uffd-wp bit.

We have to set/clear independently of the migration entry type in
change_huge_pmd() and properly copy the uffd-wp bit in
set_pmd_migration_entry().

Verified using a simple reproducer that triggers migration of a THP, that
the set_pmd_migration_entry() no longer loses the uffd-wp bit.

Link: https://lkml.kernel.org/r/20230405160236.587705-2-david@redhat.com
Fixes: f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 032fb0ef9cd1..e3706a2b34b2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1838,10 +1838,10 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	if (is_swap_pmd(*pmd)) {
 		swp_entry_t entry = pmd_to_swp_entry(*pmd);
 		struct page *page = pfn_swap_entry_to_page(entry);
+		pmd_t newpmd;
 
 		VM_BUG_ON(!is_pmd_migration_entry(*pmd));
 		if (is_writable_migration_entry(entry)) {
-			pmd_t newpmd;
 			/*
 			 * A protection check is difficult so
 			 * just be safe and disable write
@@ -1855,8 +1855,16 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 				newpmd = pmd_swp_mksoft_dirty(newpmd);
 			if (pmd_swp_uffd_wp(*pmd))
 				newpmd = pmd_swp_mkuffd_wp(newpmd);
-			set_pmd_at(mm, addr, pmd, newpmd);
+		} else {
+			newpmd = *pmd;
 		}
+
+		if (uffd_wp)
+			newpmd = pmd_swp_mkuffd_wp(newpmd);
+		else if (uffd_wp_resolve)
+			newpmd = pmd_swp_clear_uffd_wp(newpmd);
+		if (!pmd_same(*pmd, newpmd))
+			set_pmd_at(mm, addr, pmd, newpmd);
 		goto unlock;
 	}
 #endif
@@ -3251,6 +3259,8 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 	pmdswp = swp_entry_to_pmd(entry);
 	if (pmd_soft_dirty(pmdval))
 		pmdswp = pmd_swp_mksoft_dirty(pmdswp);
+	if (pmd_uffd_wp(pmdval))
+		pmdswp = pmd_swp_mkuffd_wp(pmdswp);
 	set_pmd_at(mm, address, pvmw->pmd, pmdswp);
 	page_remove_rmap(page, vma, true);
 	put_page(page);

