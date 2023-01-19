Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2D1672DCD
	for <lists+stable@lfdr.de>; Thu, 19 Jan 2023 02:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjASBCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 20:02:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjASBCt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 20:02:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08922683CF;
        Wed, 18 Jan 2023 17:02:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C1CF61B08;
        Thu, 19 Jan 2023 01:02:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D6DC433D2;
        Thu, 19 Jan 2023 01:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090166;
        bh=uzD8Ka8JTx/epQ3MAVqfduaJNtunGYzsoPt7QvN+Bu4=;
        h=Date:To:From:Subject:From;
        b=d4Aqfv0xhM1k0oiB/z+r+KEzQYGvyNEyW9KWs1GYc4Mv9zJnSAyTHlU0l244f1VyZ
         Ub+CrX89j0xA2zDzfUTLDF+iZuCQa37i/UZ3um0jqSOx7VymOJp9Pn77sXmzqJJhPp
         CnLWtFtKyUgTmcVCSOF1XnohIoJ5fYt1IakICnmo=
Date:   Wed, 18 Jan 2023 17:02:46 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        stable@vger.kernel.org, pengfei.xu@intel.com, nadav.amit@gmail.com,
        linmiaohe@huawei.com, david@redhat.com, aarcange@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-uffd-fix-pte-marker-when-fork-without-fork-event.patch removed from -mm tree
Message-Id: <20230119010246.D5D6DC433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/uffd: fix pte marker when fork() without fork event
has been removed from the -mm tree.  Its filename was
     mm-uffd-fix-pte-marker-when-fork-without-fork-event.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/uffd: fix pte marker when fork() without fork event
Date: Wed, 14 Dec 2022 15:04:52 -0500

Patch series "mm: Fixes on pte markers".

Patch 1 resolves the syzkiller report from Pengfei.

Patch 2 further harden pte markers when used with the recent swapin error
markers.  The major case is we should persist a swapin error marker after
fork(), so child shouldn't read a corrupted page.


This patch (of 2):

When fork(), dst_vma is not guaranteed to have VM_UFFD_WP even if src may
have it and has pte marker installed.  The warning is improper along with
the comment.  The right thing is to inherit the pte marker when needed, or
keep the dst pte empty.

A vague guess is this happened by an accident when there's the prior patch
to introduce src/dst vma into this helper during the uffd-wp feature got
developed and I probably messed up in the rebase, since if we replace
dst_vma with src_vma the warning & comment it all makes sense too.

Hugetlb did exactly the right here (copy_hugetlb_page_range()).  Fix the
general path.

Reproducer:

https://github.com/xupengfe/syzkaller_logs/blob/main/221208_115556_copy_page_range/repro.c

Bugzilla report: https://bugzilla.kernel.org/show_bug.cgi?id=216808

Link: https://lkml.kernel.org/r/20221214200453.1772655-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20221214200453.1772655-2-peterx@redhat.com
Fixes: c56d1b62cce8 ("mm/shmem: handle uffd-wp during fork()")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: <stable@vger.kernel.org> # 5.19+
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/memory.c~mm-uffd-fix-pte-marker-when-fork-without-fork-event
+++ a/mm/memory.c
@@ -828,12 +828,8 @@ copy_nonpresent_pte(struct mm_struct *ds
 			return -EBUSY;
 		return -ENOENT;
 	} else if (is_pte_marker_entry(entry)) {
-		/*
-		 * We're copying the pgtable should only because dst_vma has
-		 * uffd-wp enabled, do sanity check.
-		 */
-		WARN_ON_ONCE(!userfaultfd_wp(dst_vma));
-		set_pte_at(dst_mm, addr, dst_pte, pte);
+		if (userfaultfd_wp(dst_vma))
+			set_pte_at(dst_mm, addr, dst_pte, pte);
 		return 0;
 	}
 	if (!userfaultfd_wp(dst_vma))
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-vm-remove-__use_gnu-in-hugetlb-madvisec.patch
mm-uffd-always-wr-protect-pte-in-ptepmd_mkuffd_wp.patch
mm-mprotect-use-long-for-page-accountings-and-retval.patch
mm-uffd-detect-pgtable-allocation-failures.patch
mm-hugetlb-let-vma_offset_start-to-return-start.patch
mm-hugetlb-dont-wait-for-migration-entry-during-follow-page.patch
mm-hugetlb-document-huge_pte_offset-usage.patch
mm-hugetlb-move-swap-entry-handling-into-vma-lock-when-faulted.patch
mm-hugetlb-make-userfaultfd_huge_must_wait-safe-to-pmd-unshare.patch
mm-hugetlb-make-hugetlb_follow_page_mask-safe-to-pmd-unshare.patch
mm-hugetlb-make-follow_hugetlb_page-safe-to-pmd-unshare.patch
mm-hugetlb-make-walk_hugetlb_range-safe-to-pmd-unshare.patch
mm-hugetlb-introduce-hugetlb_walk.patch

