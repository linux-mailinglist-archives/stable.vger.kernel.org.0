Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 312BF597869
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 23:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242151AbiHQU55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 16:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241823AbiHQU5V (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 16:57:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E44AAB4C0;
        Wed, 17 Aug 2022 13:57:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4850B615A6;
        Wed, 17 Aug 2022 20:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993BEC433D7;
        Wed, 17 Aug 2022 20:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660769831;
        bh=G0yky8FwvR8bwaQ9Oa8nyMfgH4KYs6JS9a7Yln94OIQ=;
        h=Date:To:From:Subject:From;
        b=LmpzNbZmuu0vy9DtE1hzMQsMyNySX8qZs5thF8P1oqhFOyIGgsPnEILaiMGRvpqcH
         VSP9/4S1RP0CD5P4XtEO6eh0DBRQTXf5QCvgGTaXm5VvT7wAtZHmBfEUPweghvxQcI
         O+Zf5YMzq54skRmRGm5dzuOKYD588zEOHGBfexRM=
Date:   Wed, 17 Aug 2022 13:57:10 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-uffd-reset-write-protection-when-unregister-with-wp-mode.patch removed from -mm tree
Message-Id: <20220817205711.993BEC433D7@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/uffd: reset write protection when unregister with wp-mode
has been removed from the -mm tree.  Its filename was
     mm-uffd-reset-write-protection-when-unregister-with-wp-mode.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/uffd: reset write protection when unregister with wp-mode
Date: Thu, 11 Aug 2022 16:13:40 -0400

The motivation of this patch comes from a recent report and patchfix from
David Hildenbrand on hugetlb shared handling of wr-protected page [1].

With the reproducer provided in commit message of [1], one can leverage
the uffd-wp lazy-reset of ptes to trigger a hugetlb issue which can affect
not only the attacker process, but also the whole system.

The lazy-reset mechanism of uffd-wp was used to make unregister faster,
meanwhile it has an assumption that any leftover pgtable entries should
only affect the process on its own, so not only the user should be aware
of anything it does, but also it should not affect outside of the process.

But it seems that this is not true, and it can also be utilized to make
some exploit easier.

So far there's no clue showing that the lazy-reset is important to any
userfaultfd users because normally the unregister will only happen once
for a specific range of memory of the lifecycle of the process.

Considering all above, what this patch proposes is to do explicit pte
resets when unregister an uffd region with wr-protect mode enabled.

It should be the same as calling ioctl(UFFDIO_WRITEPROTECT, wp=false)
right before ioctl(UFFDIO_UNREGISTER) for the user.  So potentially it'll
make the unregister slower.  From that pov it's a very slight abi change,
but hopefully nothing should break with this change either.

Regarding to the change itself - core of uffd write [un]protect operation
is moved into a separate function (uffd_wp_range()) and it is reused in
the unregister code path.

Note that the new function will not check for anything, e.g.  ranges or
memory types, because they should have been checked during the previous
UFFDIO_REGISTER or it should have failed already.  It also doesn't check
mmap_changing because we're with mmap write lock held anyway.

I added a Fixes upon introducing of uffd-wp shmem+hugetlbfs because that's
the only issue reported so far and that's the commit David's reproducer
will start working (v5.19+).  But the whole idea actually applies to not
only file memories but also anonymous.  It's just that we don't need to
fix anonymous prior to v5.19- because there's no known way to exploit.

IOW, this patch can also fix the issue reported in [1] as the patch 2 does.

[1] https://lore.kernel.org/all/20220811103435.188481-3-david@redhat.com/

Link: https://lkml.kernel.org/r/20220811201340.39342-1-peterx@redhat.com
Fixes: b1f9e876862d ("mm/uffd: enable write protection for shmem & hugetlbfs")
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c              |    4 ++++
 include/linux/userfaultfd_k.h |    2 ++
 mm/userfaultfd.c              |   29 ++++++++++++++++++-----------
 3 files changed, 24 insertions(+), 11 deletions(-)

--- a/fs/userfaultfd.c~mm-uffd-reset-write-protection-when-unregister-with-wp-mode
+++ a/fs/userfaultfd.c
@@ -1601,6 +1601,10 @@ static int userfaultfd_unregister(struct
 			wake_userfault(vma->vm_userfaultfd_ctx.ctx, &range);
 		}
 
+		/* Reset ptes for the whole vma range if wr-protected */
+		if (userfaultfd_wp(vma))
+			uffd_wp_range(mm, vma, start, vma_end - start, false);
+
 		new_flags = vma->vm_flags & ~__VM_UFFD_FLAGS;
 		prev = vma_merge(mm, prev, start, vma_end, new_flags,
 				 vma->anon_vma, vma->vm_file, vma->vm_pgoff,
--- a/include/linux/userfaultfd_k.h~mm-uffd-reset-write-protection-when-unregister-with-wp-mode
+++ a/include/linux/userfaultfd_k.h
@@ -73,6 +73,8 @@ extern ssize_t mcopy_continue(struct mm_
 extern int mwriteprotect_range(struct mm_struct *dst_mm,
 			       unsigned long start, unsigned long len,
 			       bool enable_wp, atomic_t *mmap_changing);
+extern void uffd_wp_range(struct mm_struct *dst_mm, struct vm_area_struct *vma,
+			  unsigned long start, unsigned long len, bool enable_wp);
 
 /* mm helpers */
 static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
--- a/mm/userfaultfd.c~mm-uffd-reset-write-protection-when-unregister-with-wp-mode
+++ a/mm/userfaultfd.c
@@ -703,14 +703,29 @@ ssize_t mcopy_continue(struct mm_struct
 			      mmap_changing, 0);
 }
 
+void uffd_wp_range(struct mm_struct *dst_mm, struct vm_area_struct *dst_vma,
+		   unsigned long start, unsigned long len, bool enable_wp)
+{
+	struct mmu_gather tlb;
+	pgprot_t newprot;
+
+	if (enable_wp)
+		newprot = vm_get_page_prot(dst_vma->vm_flags & ~(VM_WRITE));
+	else
+		newprot = vm_get_page_prot(dst_vma->vm_flags);
+
+	tlb_gather_mmu(&tlb, dst_mm);
+	change_protection(&tlb, dst_vma, start, start + len, newprot,
+			  enable_wp ? MM_CP_UFFD_WP : MM_CP_UFFD_WP_RESOLVE);
+	tlb_finish_mmu(&tlb);
+}
+
 int mwriteprotect_range(struct mm_struct *dst_mm, unsigned long start,
 			unsigned long len, bool enable_wp,
 			atomic_t *mmap_changing)
 {
 	struct vm_area_struct *dst_vma;
 	unsigned long page_mask;
-	struct mmu_gather tlb;
-	pgprot_t newprot;
 	int err;
 
 	/*
@@ -750,15 +765,7 @@ int mwriteprotect_range(struct mm_struct
 			goto out_unlock;
 	}
 
-	if (enable_wp)
-		newprot = vm_get_page_prot(dst_vma->vm_flags & ~(VM_WRITE));
-	else
-		newprot = vm_get_page_prot(dst_vma->vm_flags);
-
-	tlb_gather_mmu(&tlb, dst_mm);
-	change_protection(&tlb, dst_vma, start, start + len, newprot,
-			  enable_wp ? MM_CP_UFFD_WP : MM_CP_UFFD_WP_RESOLVE);
-	tlb_finish_mmu(&tlb);
+	uffd_wp_range(dst_mm, dst_vma, start, len, enable_wp);
 
 	err = 0;
 out_unlock:
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-x86-use-swp_type_bits-in-3-level-swap-macros.patch
mm-swap-comment-all-the-ifdef-in-swapopsh.patch
mm-swap-add-swp_offset_pfn-to-fetch-pfn-from-swap-entry.patch
mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd.patch
mm-remember-young-dirty-bit-for-page-migrations.patch
mm-swap-cache-maximum-swapfile-size-when-init-swap.patch
mm-swap-cache-swap-migration-a-d-bits-support.patch

