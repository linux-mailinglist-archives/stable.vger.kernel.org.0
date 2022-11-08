Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6DC622089
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 00:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiKHX6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 18:58:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiKHX6R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 18:58:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57806606A1;
        Tue,  8 Nov 2022 15:58:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3CC5617E4;
        Tue,  8 Nov 2022 23:58:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32AE2C43470;
        Tue,  8 Nov 2022 23:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667951895;
        bh=Rhokdn+5ejET0d+ZjL2KZQYSQALDc+3DCu8V18KSs4o=;
        h=Date:To:From:Subject:From;
        b=Mn4wYFf7HorFsjSqOc5dUY/gPrfed3vvpfOShe6NmrXfsJnqzZoytKjwgr/sKTWtf
         ReHLRuFC7YjIc3mD3msmc9AeAn9ZVvf41KNA0M6vHDY1QOkMRsx/6MAlvXKJhWFtuf
         3aZpNbIAyaEc9f/4MWQb9R8DaoMth1Y/4z06tJV8=
Date:   Tue, 08 Nov 2022 15:58:14 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, hughd@google.com, axelrasmussen@google.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-shmem-use-page_mapping-to-detect-page-cache-for-uffd-continue.patch removed from -mm tree
Message-Id: <20221108235815.32AE2C43470@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/shmem: use page_mapping() to detect page cache for uffd continue
has been removed from the -mm tree.  Its filename was
     mm-shmem-use-page_mapping-to-detect-page-cache-for-uffd-continue.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/shmem: use page_mapping() to detect page cache for uffd continue
Date: Wed, 2 Nov 2022 14:41:52 -0400

mfill_atomic_install_pte() checks page->mapping to detect whether one page
is used in the page cache.  However as pointed out by Matthew, the page
can logically be a tail page rather than always the head in the case of
uffd minor mode with UFFDIO_CONTINUE.  It means we could wrongly install
one pte with shmem thp tail page assuming it's an anonymous page.

It's not that clear even for anonymous page, since normally anonymous
pages also have page->mapping being setup with the anon vma.  It's safe
here only because the only such caller to mfill_atomic_install_pte() is
always passing in a newly allocated page (mcopy_atomic_pte()), whose
page->mapping is not yet setup.  However that's not extremely obvious
either.

For either of above, use page_mapping() instead.

Link: https://lkml.kernel.org/r/Y2K+y7wnhC4vbnP2@x1n
Fixes: 153132571f02 ("userfaultfd/shmem: support UFFDIO_CONTINUE for shmem")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Matthew Wilcox <willy@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/userfaultfd.c~mm-shmem-use-page_mapping-to-detect-page-cache-for-uffd-continue
+++ a/mm/userfaultfd.c
@@ -64,7 +64,7 @@ int mfill_atomic_install_pte(struct mm_s
 	pte_t _dst_pte, *dst_pte;
 	bool writable = dst_vma->vm_flags & VM_WRITE;
 	bool vm_shared = dst_vma->vm_flags & VM_SHARED;
-	bool page_in_cache = page->mapping;
+	bool page_in_cache = page_mapping(page);
 	spinlock_t *ptl;
 	struct inode *inode;
 	pgoff_t offset, max_off;
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-vm-use-memfd-for-uffd-hugetlb-tests.patch
selftests-vm-use-memfd-for-hugetlb-madvise-test.patch
selftests-vm-use-memfd-for-hugepage-mremap-test.patch
selftests-vm-drop-mnt-point-for-hugetlb-in-run_vmtestssh.patch
mm-hugetlb-unify-clearing-of-restorereserve-for-private-pages.patch
revert-mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in.patch
mm-always-compile-in-pte-markers.patch
mm-use-pte-markers-for-swap-errors.patch

