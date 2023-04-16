Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A85376E3ABB
	for <lists+stable@lfdr.de>; Sun, 16 Apr 2023 19:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjDPRmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Apr 2023 13:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjDPRl7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Apr 2023 13:41:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9012127;
        Sun, 16 Apr 2023 10:41:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50C2A61523;
        Sun, 16 Apr 2023 17:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92DFC433EF;
        Sun, 16 Apr 2023 17:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681666916;
        bh=OONfGxq/Rs5CmV+JkrT2wWcVmi5cE/Vqcj6JjCtBwhQ=;
        h=Date:To:From:Subject:From;
        b=vfFr/S3OlREgoOL8nuvX3OSvMhP+qGhlVYmmsHJXwhfYOlS6F0RiMSNqn/Nulavnj
         ihAUAb9AORNNWwVWnY+M9YEtxmeZGK71+HLzKGFQiKmTcF3P3UmmgPWeHyVV7DETws
         8hX1v/M/fUXZ/7mIXCGhq/7iwrKLHcgkZVH89APY=
Date:   Sun, 16 Apr 2023 10:41:56 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        stable@vger.kernel.org, peterx@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-userfaultfd-fix-uffd-wp-handling-for-thp-migration-entries.patch removed from -mm tree
Message-Id: <20230416174156.A92DFC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/userfaultfd: fix uffd-wp handling for THP migration entries
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-fix-uffd-wp-handling-for-thp-migration-entries.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/userfaultfd: fix uffd-wp handling for THP migration entries
Date: Wed, 5 Apr 2023 18:02:35 +0200

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
---

 mm/huge_memory.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-userfaultfd-fix-uffd-wp-handling-for-thp-migration-entries
+++ a/mm/huge_memory.c
@@ -1838,10 +1838,10 @@ int change_huge_pmd(struct mmu_gather *t
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
@@ -1855,8 +1855,16 @@ int change_huge_pmd(struct mmu_gather *t
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
@@ -3251,6 +3259,8 @@ int set_pmd_migration_entry(struct page_
 	pmdswp = swp_entry_to_pmd(entry);
 	if (pmd_soft_dirty(pmdval))
 		pmdswp = pmd_swp_mksoft_dirty(pmdswp);
+	if (pmd_uffd_wp(pmdval))
+		pmdswp = pmd_swp_mkuffd_wp(pmdswp);
 	set_pmd_at(mm, address, pvmw->pmd, pmdswp);
 	page_remove_rmap(page, vma, true);
 	put_page(page);
_

Patches currently in -mm which might be from david@redhat.com are

m68k-mm-use-correct-bit-number-in-_page_swp_exclusive-comment.patch
mm-userfaultfd-dont-consider-uffd-wp-bit-of-writable-migration-entries.patch
selftests-mm-reuse-read_pmd_pagesize-in-cow-selftest.patch
selftests-mm-mkdirty-test-behavior-of-ptepmd_mkdirty-on-vmas-without-write-permissions.patch
sparc-mm-dont-unconditionally-set-hw-writable-bit-when-setting-pte-dirty-on-64bit.patch
mm-migrate-revert-mm-migrate-fix-wrongly-apply-write-bit-after-mkdirty-on-sparc64.patch
mm-huge_memory-revert-partly-revert-mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd.patch
mm-huge_memory-conditionally-call-maybe_mkwrite-and-drop-pte_wrprotect-in-__split_huge_pmd_locked.patch

