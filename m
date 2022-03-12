Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF3F54D6B85
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 01:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiCLArv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 19:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiCLArt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 19:47:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDE127ED8A;
        Fri, 11 Mar 2022 16:46:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 862A6B80E97;
        Sat, 12 Mar 2022 00:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40408C340E9;
        Sat, 12 Mar 2022 00:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647046002;
        bh=uk7EeWrbjIc8MIB1xzo/DOo2tXWPrFMwx6EmzSwnHLw=;
        h=Date:To:From:Subject:From;
        b=yXqVIE4gjSsN6neyH/mA3s9JxbkZdenltqqJsb65AjsUVEs4gqhLRrp6wtLFPILLq
         KgEHHQmcRe+IotgjeLxVnHLNLXNJnvRjXHXnUQVK+iOrVkYQoUtsQj98c7mghbIw0i
         +kryFqpI8/2wPGJc1AJ3rX6w48bhFJBiEseB/8KA=
Date:   Fri, 11 Mar 2022 16:46:41 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org,
        oleg@redhat.com, Liam.Howlett@oracle.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mempolicy-mbind_range-set_policy-after-vma_merge.patch added to -mm tree
Message-Id: <20220312004642.40408C340E9@smtp.kernel.org>
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
     Subject: mempolicy: mbind_range() set_policy() after vma_merge()
has been added to the -mm tree.  Its filename is
     mempolicy-mbind_range-set_policy-after-vma_merge.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mempolicy-mbind_range-set_policy-after-vma_merge.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mempolicy-mbind_range-set_policy-after-vma_merge.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mempolicy: mbind_range() set_policy() after vma_merge()

v2.6.34 commit 9d8cebd4bcd7 ("mm: fix mbind vma merge problem") introduced
vma_merge() to mbind_range(); but unlike madvise, mlock and mprotect, it
put a "continue" to next vma where its precedents go to update flags on
current vma before advancing: that left vma with the wrong setting in the
infamous vma_merge() case 8.

v3.10 commit 1444f92c8498 ("mm: merging memory blocks resets mempolicy")
tried to fix that in vma_adjust(), without fully understanding the issue.

v3.11 commit 3964acd0dbec ("mm: mempolicy: fix mbind_range() &&
vma_adjust() interaction") reverted that, and went about the fix in the
right way, but chose to optimize out an unnecessary mpol_dup() with a
prior mpol_equal() test.  But on tmpfs, that also pessimized out the vital
call to its ->set_policy(), leaving the new mbind unenforced.

The user visible effect was that the pages got allocated on the local
node (happened to be 0), after the mbind() caller had specifically
asked for them to be allocated on node 1.  There was not any page
migration involved in the case reported: the pages simply got allocated
on the wrong node.

Just delete that optimization now (though it could be made conditional on
vma not having a set_policy).  Also remove the "next" variable: it turned
out to be blameless, but also pointless.

Link: https://lkml.kernel.org/r/319e4db9-64ae-4bca-92f0-ade85d342ff@google.com
Fixes: 3964acd0dbec ("mm: mempolicy: fix mbind_range() && vma_adjust() interaction")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/mm/mempolicy.c~mempolicy-mbind_range-set_policy-after-vma_merge
+++ a/mm/mempolicy.c
@@ -786,7 +786,6 @@ static int vma_replace_policy(struct vm_
 static int mbind_range(struct mm_struct *mm, unsigned long start,
 		       unsigned long end, struct mempolicy *new_pol)
 {
-	struct vm_area_struct *next;
 	struct vm_area_struct *prev;
 	struct vm_area_struct *vma;
 	int err = 0;
@@ -801,8 +800,7 @@ static int mbind_range(struct mm_struct
 	if (start > vma->vm_start)
 		prev = vma;
 
-	for (; vma && vma->vm_start < end; prev = vma, vma = next) {
-		next = vma->vm_next;
+	for (; vma && vma->vm_start < end; prev = vma, vma = vma->vm_next) {
 		vmstart = max(start, vma->vm_start);
 		vmend   = min(end, vma->vm_end);
 
@@ -817,10 +815,6 @@ static int mbind_range(struct mm_struct
 				 anon_vma_name(vma));
 		if (prev) {
 			vma = prev;
-			next = vma->vm_next;
-			if (mpol_equal(vma_policy(vma), new_pol))
-				continue;
-			/* vma_merge() joined vma && vma->next, case 8 */
 			goto replace;
 		}
 		if (vma->vm_start != vmstart) {
_

Patches currently in -mm which might be from hughd@google.com are

mm-fs-delete-pf_swapwrite.patch
mm-__isolate_lru_page_prepare-in-isolate_migratepages_block.patch
tmpfs-support-for-file-creation-time-fix.patch
shmem-mapping_set_exiting-to-help-mapped-resilience.patch
tmpfs-do-not-allocate-pages-on-read.patch
mm-_install_special_mapping-apply-vm_locked_clear_mask.patch
mempolicy-mbind_range-set_policy-after-vma_merge.patch
mm-thp-refix-__split_huge_pmd_locked-for-migration-pmd.patch
mm-thp-clearpagedoublemap-in-first-page_add_file_rmap.patch
mm-delete-__clearpagewaiters.patch
mm-filemap_unaccount_folio-large-skip-mapcount-fixup.patch
mm-thp-fix-nr_file_mapped-accounting-in-page__file_rmap.patch
mm-warn-on-deleting-redirtied-only-if-accounted.patch
mm-unmap_mapping_range_tree-with-i_mmap_rwsem-shared.patch

