Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE9985AB8CA
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 21:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiIBTRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 15:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiIBTRJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 15:17:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD315F32C4;
        Fri,  2 Sep 2022 12:17:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74F4E622A2;
        Fri,  2 Sep 2022 19:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9B5C4314E;
        Fri,  2 Sep 2022 19:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662146227;
        bh=qN8WR76ajCrZucvw1qME9pdM92lDd7e+/otKCwexFOY=;
        h=Date:To:From:Subject:From;
        b=pmAfUEJ20Z4Ut+X0vvz1EBgDYeCHZU1pmFNtSzDgyZGAKv4YANh6HXps/YnKkvxqU
         fs4lCsod9T8x5ZgRKnG6KoBBlPoIGKZsiuJtvh949C+b9a7DfWVcBMoTv2uSCi9eVH
         w8GtTtMbFElPqFGi+nPpRysd5Gw+mXjOBouJLNCM=
Date:   Fri, 02 Sep 2022 12:17:06 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, stable@vger.kernel.org, rcampbell@nvidia.com,
        peterx@redhat.com, paulus@ozlabs.org, nadav.amit@gmail.com,
        lyude@redhat.com, logang@deltatee.com, kherbst@redhat.com,
        jhubbard@nvidia.com, jgg@nvidia.com, huang.ying.caritas@gmail.com,
        Felix.Kuehling@amd.com, david@redhat.com, bskeggs@redhat.com,
        alex.sierra@amd.com, apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate_devicec-flush-tlb-while-holding-ptl.patch added to mm-hotfixes-unstable branch
Message-Id: <20220902191707.7D9B5C4314E@smtp.kernel.org>
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
     Subject: mm/migrate_device.c: flush TLB while holding PTL
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-migrate_devicec-flush-tlb-while-holding-ptl.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate_devicec-flush-tlb-while-holding-ptl.patch

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
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/migrate_device.c: flush TLB while holding PTL
Date: Fri, 2 Sep 2022 10:35:51 +1000

When clearing a PTE the TLB should be flushed whilst still holding the PTL
to avoid a potential race with madvise/munmap/etc.  For example consider
the following sequence:

  CPU0                          CPU1
  ----                          ----

  migrate_vma_collect_pmd()
  pte_unmap_unlock()
                                madvise(MADV_DONTNEED)
                                -> zap_pte_range()
                                pte_offset_map_lock()
                                [ PTE not present, TLB not flushed ]
                                pte_unmap_unlock()
                                [ page is still accessible via stale TLB ]
  flush_tlb_range()

In this case the page may still be accessed via the stale TLB entry after
madvise returns.  Fix this by flushing the TLB while holding the PTL.

Fixes: 8c3328f1f36a ("mm/migrate: migrate_vma() unmap page from vma while collecting pages")
Link: https://lkml.kernel.org/r/9f801e9d8d830408f2ca27821f606e09aa856899.1662078528.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reported-by: Nadav Amit <nadav.amit@gmail.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: huang ying <huang.ying.caritas@gmail.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_devicec-flush-tlb-while-holding-ptl
+++ a/mm/migrate_device.c
@@ -254,13 +254,14 @@ next:
 		migrate->dst[migrate->npages] = 0;
 		migrate->src[migrate->npages++] = mpfn;
 	}
-	arch_leave_lazy_mmu_mode();
-	pte_unmap_unlock(ptep - 1, ptl);
 
 	/* Only flush the TLB if we actually modified any entries */
 	if (unmapped)
 		flush_tlb_range(walk->vma, start, end);
 
+	arch_leave_lazy_mmu_mode();
+	pte_unmap_unlock(ptep - 1, ptl);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-migrate_devicec-flush-tlb-while-holding-ptl.patch
mm-migrate_devicec-add-missing-flush_cache_page.patch
mm-migrate_devicec-copy-pte-dirty-bit-to-page.patch
mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes.patch
selftests-hmm-tests-add-test-for-dirty-bits.patch
mm-gupc-dont-pass-gup_flags-to-check_and_migrate_movable_pages.patch
mm-gupc-refactor-check_and_migrate_movable_pages.patch
mm-migrate_devicec-fix-a-misleading-and-out-dated-comment.patch

