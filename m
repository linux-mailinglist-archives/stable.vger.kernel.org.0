Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE030567874
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 22:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiGEUci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 16:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbiGEUce (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 16:32:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078621B7BA;
        Tue,  5 Jul 2022 13:32:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9833461C0D;
        Tue,  5 Jul 2022 20:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E90B8C341C8;
        Tue,  5 Jul 2022 20:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657053152;
        bh=ZyoSSSeK/2msTcwEXg/f8m333ya+IMUL0XKBF6AoHL8=;
        h=Date:To:From:Subject:From;
        b=odGBpje+IvaZO18ipBc0oESuXANy+QIsy0qqZSVcp9KXa3kWdjueYkoFr/gERapXe
         HZBbQr/Sp8M1vxrnsUIZ1spBXs/UlrzikRwy8XJjfG3+gSe9o0g4HTRJNEY2r2/Y6u
         93hg2o1kYZjU2E9z2S9ykFBcUP04Ei8hl7T0agno=
Date:   Tue, 05 Jul 2022 13:32:31 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, riel@surriel.com,
        kirill.shutemov@linux.intel.com, clm@fb.com, josef@toxicpanda.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-page-leak-with-multiple-threads-mapping-the-same-page.patch added to mm-hotfixes-unstable branch
Message-Id: <20220705203231.E90B8C341C8@smtp.kernel.org>
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
     Subject: mm: fix page leak with multiple threads mapping the same page
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-page-leak-with-multiple-threads-mapping-the-same-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-page-leak-with-multiple-threads-mapping-the-same-page.patch

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

Link: https://lkml.kernel.org/r/2b798acfd95c9ab9395fe85e8d5a835e2e10a920.1657051137.git.josef@toxicpanda.com
Fixes: f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault() codepaths")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Chris Mason <clm@fb.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-fix-page-leak-with-multiple-threads-mapping-the-same-page
+++ a/mm/memory.c
@@ -4371,7 +4371,7 @@ vm_fault_t finish_fault(struct vm_fault
 
 	/* See comment in handle_pte_fault() */
 	if (pmd_devmap_trans_unstable(vmf->pmd))
-		return 0;
+		return VM_FAULT_NOPAGE;
 
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
 				      vmf->address, &vmf->ptl);
_

Patches currently in -mm which might be from josef@toxicpanda.com are

mm-fix-page-leak-with-multiple-threads-mapping-the-same-page.patch

