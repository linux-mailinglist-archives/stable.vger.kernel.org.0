Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85714611C2C
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 23:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiJ1VHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 17:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiJ1VHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 17:07:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D137F24A54C;
        Fri, 28 Oct 2022 14:07:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AE9C62A79;
        Fri, 28 Oct 2022 21:07:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3AFC43470;
        Fri, 28 Oct 2022 21:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666991237;
        bh=0+e7Xxdxc1t7UEyZnOedoGYLMfA+rgYzC8E356YLITQ=;
        h=Date:To:From:Subject:From;
        b=fx16iUefjGoKTM/l1FDNdfFYtSu8WuRVqLDhdnFVOIkwTO3VNh2+q1Wei1MPh1SmU
         4w3NjdiM6rFr5OuvnbW+3pcsyadfqBh8sATcTvAmJJYQzD+kH6wkNbp97UTgfeA3j5
         NMUXJBiyxSYZMu2ad8T2nKGki+W+1tr2hw1M5Fc8=
Date:   Fri, 28 Oct 2022 14:07:16 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        nadav.amit@gmail.com, axelrasmussen@google.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-uffd-fix-vma-check-on-userfault-for-wp.patch removed from -mm tree
Message-Id: <20221028210717.AF3AFC43470@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/uffd: fix vma check on userfault for wp
has been removed from the -mm tree.  Its filename was
     mm-uffd-fix-vma-check-on-userfault-for-wp.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-vm-use-memfd-for-uffd-hugetlb-tests.patch
selftests-vm-use-memfd-for-hugetlb-madvise-test.patch
selftests-vm-use-memfd-for-hugepage-mremap-test.patch
selftests-vm-drop-mnt-point-for-hugetlb-in-run_vmtestssh.patch
mm-hugetlb-unify-clearing-of-restorereserve-for-private-pages.patch
revert-mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in.patch

