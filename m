Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26194666777
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 01:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjALAPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 19:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233181AbjALAPF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 19:15:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D0FD11F;
        Wed, 11 Jan 2023 16:15:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 846C461ED9;
        Thu, 12 Jan 2023 00:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7300C433D2;
        Thu, 12 Jan 2023 00:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673482502;
        bh=agIoyjEA8rOz/CYMzezF2O9qz63s7qJ0/G53/Abh0+A=;
        h=Date:To:From:Subject:From;
        b=wHx4nvXlEXJWbzM3zaqwRTXbCXNth0n/d5LEIhCraxMV2cqfi7QVspNRBlk++8sSe
         qNNz0VI13ztbOVRmckCaLYa2GksNTWMAGJ+rYEOLL1PahiRWaV/L7RaIU+MiRWyFR3
         nf7aQWpXQ6FaiPLPoGZzY0xMXqs1/hjmA8jDqIeQ=
Date:   Wed, 11 Jan 2023 16:15:01 -0800
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        stable@vger.kernel.org, songliubraving@fb.com, shy828301@gmail.com,
        jannh@google.com, david@redhat.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-khugepaged-fix-collapse_pte_mapped_thp-to-allow-anon_vma.patch removed from -mm tree
Message-Id: <20230112001502.D7300C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: fix collapse_pte_mapped_thp() to allow anon_vma
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-fix-collapse_pte_mapped_thp-to-allow-anon_vma.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/khugepaged: fix collapse_pte_mapped_thp() to allow anon_vma
Date: Thu, 22 Dec 2022 12:41:50 -0800 (PST)

uprobe_write_opcode() uses collapse_pte_mapped_thp() to restore huge pmd,
when removing a breakpoint from hugepage text: vma->anon_vma is always set
in that case, so undo the prohibition.  And MADV_COLLAPSE ought to be able
to collapse some page tables in a vma which happens to have anon_vma set
from CoWing elsewhere.

Is anon_vma lock required?  Almost not: if any page other than expected
subpage of the non-anon huge page is found in the page table, collapse is
aborted without making any change.  However, it is possible that an anon
page was CoWed from this extent in another mm or vma, in which case a
concurrent lookup might look here: so keep it away while clearing pmd (but
perhaps we shall go back to using pmd_lock() there in future).

Note that collapse_pte_mapped_thp() is exceptional in freeing a page table
without having cleared its ptes: I'm uneasy about that, and had thought
pte_clear()ing appropriate; but exclusive i_mmap lock does fix the
problem, and we would have to move the mmu_notification if clearing those
ptes.

What this fixes is not a dangerous instability.  But I suggest Cc stable
because uprobes "healing" has regressed in that way, so this should follow
8d3c106e19e8 into those stable releases where it was backported (and may
want adjustment there - I'll supply backports as needed).

Link: https://lkml.kernel.org/r/b740c9fb-edba-92ba-59fb-7a5592e5dfc@google.com
Fixes: 8d3c106e19e8 ("mm/khugepaged: take the right locks for page table retraction")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: <stable@vger.kernel.org>    [5.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-fix-collapse_pte_mapped_thp-to-allow-anon_vma
+++ a/mm/khugepaged.c
@@ -1460,14 +1460,6 @@ int collapse_pte_mapped_thp(struct mm_st
 	if (!hugepage_vma_check(vma, vma->vm_flags, false, false, false))
 		return SCAN_VMA_CHECK;
 
-	/*
-	 * Symmetry with retract_page_tables(): Exclude MAP_PRIVATE mappings
-	 * that got written to. Without this, we'd have to also lock the
-	 * anon_vma if one exists.
-	 */
-	if (vma->anon_vma)
-		return SCAN_VMA_CHECK;
-
 	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
 	if (userfaultfd_wp(vma))
 		return SCAN_PTE_UFFD_WP;
@@ -1567,8 +1559,14 @@ int collapse_pte_mapped_thp(struct mm_st
 	}
 
 	/* step 4: remove pte entries */
+	/* we make no change to anon, but protect concurrent anon page lookup */
+	if (vma->anon_vma)
+		anon_vma_lock_write(vma->anon_vma);
+
 	collapse_and_free_pmd(mm, vma, haddr, pmd);
 
+	if (vma->anon_vma)
+		anon_vma_unlock_write(vma->anon_vma);
 	i_mmap_unlock_write(vma->vm_file->f_mapping);
 
 maybe_install_pmd:
_

Patches currently in -mm which might be from hughd@google.com are


