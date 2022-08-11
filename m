Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6F85907E8
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 23:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbiHKVLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 17:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233628AbiHKVLM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 17:11:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38721B56;
        Thu, 11 Aug 2022 14:11:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA9C16141C;
        Thu, 11 Aug 2022 21:11:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D26C433C1;
        Thu, 11 Aug 2022 21:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660252270;
        bh=4cn4It3glBJ8E15qEnG3ZZu8v9DI7qnpoJpv2pBCZHI=;
        h=Date:To:From:Subject:From;
        b=AHGcmvgh9GzIquFtPMMbJNQqAw46nSHx67Es62maatNQ5m3gnoYOVCjpKHtkIn3hq
         wKF53bqU6xmZ2h/hURKOTl22VSdQ2+8Wp3f0aDZAAU8FgAa+amIpBNF/+8xpHk5WiS
         u4IUaqLt4af7MKPWJkvrSi2F8uAzr/bkVuVtoSMk=
Date:   Thu, 11 Aug 2022 14:11:09 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-uffd-reset-write-protection-when-unregister-with-wp-mode.patch added to mm-hotfixes-unstable branch
Message-Id: <20220811211110.26D26C433C1@smtp.kernel.org>
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
     Subject: mm/uffd: reset write protection when unregister with wp-mode
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-uffd-reset-write-protection-when-unregister-with-wp-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-uffd-reset-write-protection-when-unregister-with-wp-mode.patch

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

mm-smaps-dont-access-young-dirty-bit-if-pte-unpresent.patch
mm-uffd-reset-write-protection-when-unregister-with-wp-mode.patch

