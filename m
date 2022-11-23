Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407B76369F7
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 20:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237291AbiKWTjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 14:39:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237463AbiKWTju (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 14:39:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1B690386;
        Wed, 23 Nov 2022 11:39:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBEBE61ED3;
        Wed, 23 Nov 2022 19:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B254C433C1;
        Wed, 23 Nov 2022 19:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669232389;
        bh=WPQ8jSW2w5XVr7s07TsrmP4ku620sh2BjlZVwr2IAfk=;
        h=Date:To:From:Subject:From;
        b=uDmK7f7poODWF/p3gDokffjEQjN3unnYkPgiZXZEjsDOIQAW8ZgF/6u7pa/XBYZPM
         ko3Y4g69A4wlzclDIz98ymjS3uGjuF/9MRKFLIhMtMehixq5QJOVyyDSdVMDTxdjhc
         o8XejjX1fjQckcIS2hwnbJn5QEs7jsZ21l70Isfs=
Date:   Wed, 23 Nov 2022 11:39:48 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shy828301@gmail.com, peterx@redhat.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, david@redhat.com, jannh@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-invoke-mmu-notifiers-in-shmem-file-collapse-paths.patch added to mm-hotfixes-unstable branch
Message-Id: <20221123193949.1B254C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: invoke MMU notifiers in shmem/file collapse paths
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-khugepaged-invoke-mmu-notifiers-in-shmem-file-collapse-paths.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-invoke-mmu-notifiers-in-shmem-file-collapse-paths.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: mm/khugepaged: invoke MMU notifiers in shmem/file collapse paths
Date: Wed, 23 Nov 2022 17:56:52 +0100

Any codepath that zaps page table entries must invoke MMU notifiers to
ensure that secondary MMUs (like KVM) don't keep accessing pages which
aren't mapped anymore.  Secondary MMUs don't hold their own references to
pages that are mirrored over, so failing to notify them can lead to page
use-after-free.

I'm marking this as addressing an issue introduced in commit f3f0e1d2150b
("khugepaged: add support of collapse for tmpfs/shmem pages"), but most of
the security impact of this only came in commit 27e1f8273113 ("khugepaged:
enable collapse pmd for pte-mapped THP"), which actually omitted flushes
for the removal of present PTEs, not just for the removal of empty page
tables.

Link: https://lkml.kernel.org/r/20221123165652.2204925-5-jannh@google.com
Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem p=
ages")
Signed-off-by: Jann Horn <jannh@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/khugepaged.c~mm-khugepaged-invoke-mmu-notifiers-in-shmem-file-collapse-paths
+++ a/mm/khugepaged.c
@@ -1421,6 +1421,7 @@ static void collapse_and_free_pmd(struct
 {
 	pmd_t pmd;
 	struct mmu_gather tlb;
+	struct mmu_notifier_range range;
 
 	mmap_assert_write_locked(mm);
 	if (vma->vm_file)
@@ -1433,12 +1434,16 @@ static void collapse_and_free_pmd(struct
 		lockdep_assert_held_write(&vma->anon_vma->root->rwsem);
 	page_table_check_pte_clear_range(mm, addr, pmd);
 
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, NULL, mm, addr,
+				addr + HPAGE_PMD_SIZE);
+	mmu_notifier_invalidate_range_start(&range);
 	tlb_gather_mmu(&tlb, mm);
 	pmd = READ_ONCE(*pmdp);
 	pmd_clear(pmdp);
 	tlb_flush_pte_range(&tlb, addr, HPAGE_PMD_SIZE);
 	pte_free_tlb(&tlb, pmd_pgtable(pmd), addr);
 	tlb_finish_mmu(&tlb);
+	mmu_notifier_invalidate_range_end(&range);
 	mm_dec_nr_ptes(mm);
 }
 
_

Patches currently in -mm which might be from jannh@google.com are

mm-khugepaged-take-the-right-locks-for-page-table-retraction.patch
mmu_gather-use-macro-arguments-more-carefully.patch
mm-khugepaged-fix-gup-fast-interaction-by-freeing-ptes-via-mmu_gather.patch
mm-khugepaged-invoke-mmu-notifiers-in-shmem-file-collapse-paths.patch

