Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5346C60BD0C
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 00:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbiJXWEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 18:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232101AbiJXWEI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 18:04:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC9231F99;
        Mon, 24 Oct 2022 13:18:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4975FB8120F;
        Mon, 24 Oct 2022 20:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71D6C433C1;
        Mon, 24 Oct 2022 20:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666642019;
        bh=vWbPVZTXG42ttaagmZ8ZUhLXVfrABJDS3zn58Z/nGgw=;
        h=Date:To:From:Subject:From;
        b=o1e+byaEVltsUaCg3V7wRwvp95Z2TgmDqRWfyIa8zK9efQbWyQF8fKFWWnS/CfWmj
         7atPzwtFSegifSL2e8g1EnSLZ60xLoxI2zcUBWWXtZ5I/Yh4CVUunD0dhnJ0pRrlbi
         qrUBxB9YH1jiP7BaBNB4wDfIupdFDL+ryLDGW0xM=
Date:   Mon, 24 Oct 2022 13:06:59 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        nadav.amit@gmail.com, axelrasmussen@google.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-uffd-fix-vma-check-on-userfault-for-wp.patch added to mm-hotfixes-unstable branch
Message-Id: <20221024200659.D71D6C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/uffd: fix vma check on userfault for wp
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-uffd-fix-vma-check-on-userfault-for-wp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-uffd-fix-vma-check-on-userfault-for-wp.patch

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
Subject: mm/uffd: fix vma check on userfault for wp
Date: Mon, 24 Oct 2022 15:33:35 -0400

We used to have a report that pte-marker code can be reached even when
uffd-wp is not compiled in for file memories, here:

https://lore.kernel.org/all/YzeR+R6b4bwBlBHh@x1n/T/#u

I just got time to revisit this and found that the root cause is we simply
messed up with the vma check, so that for !PTE_MARKER_UFFD_WP system, we
will allow UFFDIO_REGISTER of MINOR & WP upon shmem as the check was
wrong:

    if (vm_flags & VM_UFFD_MINOR)
        return is_vm_hugetlb_page(vma) || vma_is_shmem(vma);

Where we'll allow anything to pass on shmem as long as minor mode is
requested.

Axel did it right when introducing minor mode but I messed it up in
b1f9e876862d when moving code around.  Fix it.

Link: https://lkml.kernel.org/r/20221024193336.1233616-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20221024193336.1233616-2-peterx@redhat.com
Fixes: b1f9e876862d ("mm/uffd: enable write protection for shmem & hugetlbfs")
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/userfaultfd_k.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/userfaultfd_k.h~mm-uffd-fix-vma-check-on-userfault-for-wp
+++ a/include/linux/userfaultfd_k.h
@@ -146,9 +146,9 @@ static inline bool userfaultfd_armed(str
 static inline bool vma_can_userfault(struct vm_area_struct *vma,
 				     unsigned long vm_flags)
 {
-	if (vm_flags & VM_UFFD_MINOR)
-		return is_vm_hugetlb_page(vma) || vma_is_shmem(vma);
-
+	if ((vm_flags & VM_UFFD_MINOR) &&
+	    (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))
+		return false;
 #ifndef CONFIG_PTE_MARKER_UFFD_WP
 	/*
 	 * If user requested uffd-wp but not enabled pte markers for
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-uffd-fix-vma-check-on-userfault-for-wp.patch
revert-mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in.patch
selftests-vm-use-memfd-for-uffd-hugetlb-tests.patch
selftests-vm-use-memfd-for-hugetlb-madvise-test.patch
selftests-vm-use-memfd-for-hugepage-mremap-test.patch
selftests-vm-drop-mnt-point-for-hugetlb-in-run_vmtestssh.patch
mm-hugetlb-unify-clearing-of-restorereserve-for-private-pages.patch

