Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4905757744F
	for <lists+stable@lfdr.de>; Sun, 17 Jul 2022 06:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbiGQEiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jul 2022 00:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232706AbiGQEh6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jul 2022 00:37:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5577F22289;
        Sat, 16 Jul 2022 21:37:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D541C60EBA;
        Sun, 17 Jul 2022 04:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34791C3411E;
        Sun, 17 Jul 2022 04:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658032676;
        bh=tBcUcdeAIImk8OfatCBc+zbL4ZGh0aMtIoTQpnUf8wI=;
        h=Date:To:From:Subject:From;
        b=tZxmwp4VYL5R8j3JJg7HV0dK/0aSOCBSq++HMwGr3SZcjug01oxzWdOpY9q1nprW+
         dRtyohoSmD/s4mFUG4x64nGqXNJVr1huiihDCQjPrC19plS12pEmeGPr1mcWVgzYBe
         od8iu1lELsnnUKrbnS5kRngk5pcElwCQS8JwyZU4=
Date:   Sat, 16 Jul 2022 21:37:55 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, riel@surriel.com,
        kirill.shutemov@linux.intel.com, clm@fb.com, josef@toxicpanda.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-page-leak-with-multiple-threads-mapping-the-same-page.patch removed from -mm tree
Message-Id: <20220717043756.34791C3411E@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm: fix page leak with multiple threads mapping the same page
has been removed from the -mm tree.  Its filename was
     mm-fix-page-leak-with-multiple-threads-mapping-the-same-page.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josef Bacik <josef@toxicpanda.com>
Subject: mm: fix page leak with multiple threads mapping the same page
Date: Tue, 5 Jul 2022 16:00:36 -0400

We have an application with a lot of threads that use a shared mmap backed
by tmpfs mounted with -o huge=within_size.  This application started
leaking loads of huge pages when we upgraded to a recent kernel.

Using the page ref tracepoints and a BPF program written by Tejun Heo we
were able to determine that these pages would have multiple refcounts from
the page fault path, but when it came to unmap time we wouldn't drop the
number of refs we had added from the faults.

I wrote a reproducer that mmap'ed a file backed by tmpfs with -o
huge=always, and then spawned 20 threads all looping faulting random
offsets in this map, while using madvise(MADV_DONTNEED) randomly for huge
page aligned ranges.  This very quickly reproduced the problem.

The problem here is that we check for the case that we have multiple
threads faulting in a range that was previously unmapped.  One thread maps
the PMD, the other thread loses the race and then returns 0.  However at
this point we already have the page, and we are no longer putting this
page into the processes address space, and so we leak the page.  We
actually did the correct thing prior to f9ce0be71d1f, however it looks
like Kirill copied what we do in the anonymous page case.  In the
anonymous page case we don't yet have a page, so we don't have to drop a
reference on anything.  Previously we did the correct thing for file based
faults by returning VM_FAULT_NOPAGE so we correctly drop the reference on
the page we faulted in.

Fix this by returning VM_FAULT_NOPAGE in the pmd_devmap_trans_unstable()
case, this makes us drop the ref on the page properly, and now my
reproducer no longer leaks the huge pages.

[josef@toxicpanda.com: v2]
  Link: https://lkml.kernel.org/r/e90c8f0dbae836632b669c2afc434006a00d4a67.1657721478.git.josef@toxicpanda.com
Link: https://lkml.kernel.org/r/2b798acfd95c9ab9395fe85e8d5a835e2e10a920.1657051137.git.josef@toxicpanda.com
Fixes: f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault() codepaths")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Chris Mason <clm@fb.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-fix-page-leak-with-multiple-threads-mapping-the-same-page
+++ a/mm/memory.c
@@ -4369,9 +4369,12 @@ vm_fault_t finish_fault(struct vm_fault
 			return VM_FAULT_OOM;
 	}
 
-	/* See comment in handle_pte_fault() */
+	/*
+	 * See comment in handle_pte_fault() for how this scenario happens, we
+	 * need to return NOPAGE so that we drop this page.
+	 */
 	if (pmd_devmap_trans_unstable(vmf->pmd))
-		return 0;
+		return VM_FAULT_NOPAGE;
 
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
 				      vmf->address, &vmf->ptl);
_

Patches currently in -mm which might be from josef@toxicpanda.com are


