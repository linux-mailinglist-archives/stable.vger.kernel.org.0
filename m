Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE15264E380
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 22:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiLOVwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 16:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiLOVwC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 16:52:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C4E442F0;
        Thu, 15 Dec 2022 13:52:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35BFCB81CC0;
        Thu, 15 Dec 2022 21:52:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7EE6C433D2;
        Thu, 15 Dec 2022 21:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671141118;
        bh=iwvxEdyfXUm7cviwQ12hHMS0tUNEL3EVkx8xU4xxOw0=;
        h=Date:To:From:Subject:From;
        b=cL6cPXZYWP+fdHHnvN905ChgmIGGKrxzqPcOoiRKDMxZr4UjTzj8fmRc6Finpkmdv
         zHkmvSbSqP/x839PnoIqwJJtxoqTPvl4MzdmXHbLOtOjqgw9HDl046CQk1ILw6Hpnf
         WYQW8HQx0bybmoKtqmaud6vtA0Rc52V0f101z8Zw=
Date:   Thu, 15 Dec 2022 13:51:58 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        stable@vger.kernel.org, pengfei.xu@intel.com, nadav.amit@gmail.com,
        linmiaohe@huawei.com, david@redhat.com, aarcange@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-uffd-fix-pte-marker-when-fork-without-fork-event.patch added to mm-hotfixes-unstable branch
Message-Id: <20221215215158.D7EE6C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/uffd: fix pte marker when fork() without fork event
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-uffd-fix-pte-marker-when-fork-without-fork-event.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-uffd-fix-pte-marker-when-fork-without-fork-event.patch

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
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
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

mm-uffd-fix-pte-marker-when-fork-without-fork-event.patch
mm-fix-a-few-rare-cases-of-using-swapin-error-pte-marker.patch

