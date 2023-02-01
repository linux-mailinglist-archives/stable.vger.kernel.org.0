Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11959685C57
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 01:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbjBAAp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 19:45:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbjBAApO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 19:45:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE874FAF8;
        Tue, 31 Jan 2023 16:45:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 894096175D;
        Wed,  1 Feb 2023 00:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16BCC433EF;
        Wed,  1 Feb 2023 00:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675212312;
        bh=HwsSI8Cj4FMKc1figgZ+7vqoH7BcUp2gnzsCNgIBbWY=;
        h=Date:To:From:Subject:From;
        b=ixYRqHw2aYrwLMjVLEvLZ7Op+iw8HgJoE6sH2fXHY781bJW2HHuQTsGSXVn4/zMdz
         jkHfs8e5k0cB28sPsiJncW3u4V2zs7sXp5rN4pIyiK6iQ8+iuXFSQqI+7hOLaRdJoQ
         ka6QvoTPoFCJ9t4v2OB3hxgodFKINh3k4LMnjoeU=
Date:   Tue, 31 Jan 2023 16:45:11 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shy828301@gmail.com, hughd@google.com, zokeefe@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-madv_collapse-catch-none-huge-bad-pmd-lookups.patch removed from -mm tree
Message-Id: <20230201004511.E16BCC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/MADV_COLLAPSE: catch !none !huge !bad pmd lookups
has been removed from the -mm tree.  Its filename was
     mm-madv_collapse-catch-none-huge-bad-pmd-lookups.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: mm/MADV_COLLAPSE: catch !none !huge !bad pmd lookups
Date: Wed, 25 Jan 2023 14:53:58 -0800

In commit 34488399fa08 ("mm/madvise: add file and shmem support to
MADV_COLLAPSE") we make the following change to find_pmd_or_thp_or_none():

	-       if (!pmd_present(pmde))
	-               return SCAN_PMD_NULL;
	+       if (pmd_none(pmde))
	+               return SCAN_PMD_NONE;

This was for-use by MADV_COLLAPSE file/shmem codepaths, where
MADV_COLLAPSE might identify a pte-mapped hugepage, only to have
khugepaged race-in, free the pte table, and clear the pmd.  Such codepaths
include:

A) If we find a suitably-aligned compound page of order HPAGE_PMD_ORDER
   already in the pagecache.
B) In retract_page_tables(), if we fail to grab mmap_lock for the target
   mm/address.

In these cases, collapse_pte_mapped_thp() really does expect a none (not
just !present) pmd, and we want to suitably identify that case separate
from the case where no pmd is found, or it's a bad-pmd (of course, many
things could happen once we drop mmap_lock, and the pmd could plausibly
undergo multiple transitions due to intervening fault, split, etc). 
Regardless, the code is prepared install a huge-pmd only when the existing
pmd entry is either a genuine pte-table-mapping-pmd, or the none-pmd.

However, the commit introduces a logical hole; namely, that we've allowed
!none- && !huge- && !bad-pmds to be classified as genuine
pte-table-mapping-pmds.  One such example that could leak through are swap
entries.  The pmd values aren't checked again before use in
pte_offset_map_lock(), which is expecting nothing less than a genuine
pte-table-mapping-pmd.

We want to put back the !pmd_present() check (below the pmd_none() check),
but need to be careful to deal with subtleties in pmd transitions and
treatments by various arch.

The issue is that __split_huge_pmd_locked() temporarily clears the present
bit (or otherwise marks the entry as invalid), but pmd_present() and
pmd_trans_huge() still need to return true while the pmd is in this
transitory state.  For example, x86's pmd_present() also checks the
_PAGE_PSE , riscv's version also checks the _PAGE_LEAF bit, and arm64 also
checks a PMD_PRESENT_INVALID bit.

Covering all 4 cases for x86 (all checks done on the same pmd value):

1) pmd_present() && pmd_trans_huge()
   All we actually know here is that the PSE bit is set. Either:
   a) We aren't racing with __split_huge_page(), and PRESENT or PROTNONE
      is set.
      => huge-pmd
   b) We are currently racing with __split_huge_page().  The danger here
      is that we proceed as-if we have a huge-pmd, but really we are
      looking at a pte-mapping-pmd.  So, what is the risk of this
      danger?

      The only relevant path is:

	madvise_collapse() -> collapse_pte_mapped_thp()

      Where we might just incorrectly report back "success", when really
      the memory isn't pmd-backed.  This is fine, since split could
      happen immediately after (actually) successful madvise_collapse().
      So, it should be safe to just assume huge-pmd here.

2) pmd_present() && !pmd_trans_huge()
   Either:
   a) PSE not set and either PRESENT or PROTNONE is.
      => pte-table-mapping pmd (or PROT_NONE)
   b) devmap.  This routine can be called immediately after
      unlocking/locking mmap_lock -- or called with no locks held (see
      khugepaged_scan_mm_slot()), so previous VMA checks have since been
      invalidated.

3) !pmd_present() && pmd_trans_huge()
  Not possible.

4) !pmd_present() && !pmd_trans_huge()
  Neither PRESENT nor PROTNONE set
  => not present

I've checked all archs that implement pmd_trans_huge() (arm64, riscv,
powerpc, longarch, x86, mips, s390) and this logic roughly translates
(though devmap treatment is unique to x86 and powerpc, and (3) doesn't
necessarily hold in general -- but that doesn't matter since
!pmd_present() always takes failure path).

Also, add a comment above find_pmd_or_thp_or_none() to help future
travelers reason about the validity of the code; namely, the possible
mutations that might happen out from under us, depending on how mmap_lock
is held (if at all).

Link: https://lkml.kernel.org/r/20230125225358.2576151-1-zokeefe@google.com
Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Reported-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/khugepaged.c~mm-madv_collapse-catch-none-huge-bad-pmd-lookups
+++ a/mm/khugepaged.c
@@ -847,6 +847,10 @@ static int hugepage_vma_revalidate(struc
 	return SCAN_SUCCEED;
 }
 
+/*
+ * See pmd_trans_unstable() for how the result may change out from
+ * underneath us, even if we hold mmap_lock in read.
+ */
 static int find_pmd_or_thp_or_none(struct mm_struct *mm,
 				   unsigned long address,
 				   pmd_t **pmd)
@@ -865,8 +869,12 @@ static int find_pmd_or_thp_or_none(struc
 #endif
 	if (pmd_none(pmde))
 		return SCAN_PMD_NONE;
+	if (!pmd_present(pmde))
+		return SCAN_PMD_NULL;
 	if (pmd_trans_huge(pmde))
 		return SCAN_PMD_MAPPED;
+	if (pmd_devmap(pmde))
+		return SCAN_PMD_NULL;
 	if (pmd_bad(pmde))
 		return SCAN_PMD_NULL;
 	return SCAN_SUCCEED;
_

Patches currently in -mm which might be from zokeefe@google.com are


