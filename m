Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E843C31DF69
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 20:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhBQTHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 14:07:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:51304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231491AbhBQTHY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Feb 2021 14:07:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEC4D64E45;
        Wed, 17 Feb 2021 19:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613588804;
        bh=ppWodC2x3evZp4C3JH55ouugKaldiv516PsZqHqCSNY=;
        h=Date:From:To:Subject:From;
        b=DWaB8pl6EcyTAq0Hhj3vsIyIWxfXVSqW2wTFXXwzPtTd6qdhWZ7Pf9vaO0wBF/BtQ
         OJYzrtjdgkvRVVsjEsvZAIHck0XMM5k1x0vRtfMj/i16fCc6OrBgxprePOrGNoWDbx
         WwwUGI/6lMa7eEvy+0Qp2YFZF3RM1YATxn1mo5x8=
Date:   Wed, 17 Feb 2021 11:06:43 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        stable@vger.kernel.org, osalvador@suse.de,
        kirill.shutemov@linux.intel.com, joao.m.martins@oracle.com,
        dbueso@suse.de, aarcange@redhat.com, mike.kravetz@oracle.com
Subject:  +
 hugetlb-fix-copy_huge_page_from_user-contig-page-struct-assumption.patch
 added to -mm tree
Message-ID: <20210217190643.m4y-2%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: hugetlb: fix copy_huge_page_from_user contig page struct assumption
has been added to the -mm tree.  Its filename is
     hugetlb-fix-copy_huge_page_from_user-contig-page-struct-assumption.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-fix-copy_huge_page_from_user-contig-page-struct-assumption.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-fix-copy_huge_page_from_user-contig-page-struct-assumption.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: fix copy_huge_page_from_user contig page struct assumption

page structs are not guaranteed to be contiguous for gigantic pages.  The
routine copy_huge_page_from_user can encounter gigantic pages, yet it
assumes page structs are contiguous when copying pages from user space.

Since page structs for the target gigantic page are not contiguous, the
data copied from user space could overwrite other pages not associated
with the gigantic page and cause data corruption.

Non-contiguous page structs are generally not an issue.  However, they can
exist with a specific kernel configuration and hotplug operations.  For
example: Configure the kernel with CONFIG_SPARSEMEM and
!CONFIG_SPARSEMEM_VMEMMAP.  Then, hotplug add memory for the area where
the gigantic page will be allocated.

Link: https://lkml.kernel.org/r/20210217184926.33567-2-mike.kravetz@oracle.com
Fixes: 8fb5debc5fcd ("userfaultfd: hugetlbfs: add hugetlb_mcopy_atomic_pte for userfaultfd support")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/memory.c~hugetlb-fix-copy_huge_page_from_user-contig-page-struct-assumption
+++ a/mm/memory.c
@@ -5173,17 +5173,19 @@ long copy_huge_page_from_user(struct pag
 	void *page_kaddr;
 	unsigned long i, rc = 0;
 	unsigned long ret_val = pages_per_huge_page * PAGE_SIZE;
+	struct page *subpage = dst_page;
 
-	for (i = 0; i < pages_per_huge_page; i++) {
+	for (i = 0; i < pages_per_huge_page;
+	     i++, subpage = mem_map_next(subpage, dst_page, i)) {
 		if (allow_pagefault)
-			page_kaddr = kmap(dst_page + i);
+			page_kaddr = kmap(subpage);
 		else
-			page_kaddr = kmap_atomic(dst_page + i);
+			page_kaddr = kmap_atomic(subpage);
 		rc = copy_from_user(page_kaddr,
 				(const void __user *)(src + i * PAGE_SIZE),
 				PAGE_SIZE);
 		if (allow_pagefault)
-			kunmap(dst_page + i);
+			kunmap(subpage);
 		else
 			kunmap_atomic(page_kaddr);
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-fix-update_and_free_page-contig-page-struct-assumption.patch
hugetlb-fix-copy_huge_page_from_user-contig-page-struct-assumption.patch
hugetlb-use-pageprivate-for-hugetlb-specific-page-flags.patch
hugetlb-convert-page_huge_active-hpagemigratable-flag.patch
hugetlb-convert-pagehugetemporary-to-hpagetemporary-flag.patch
hugetlb-convert-pagehugefreed-to-hpagefreed-flag.patch
mm-hugetlb-change-hugetlb_reserve_pages-to-type-bool.patch
hugetlbfs-remove-special-hugetlbfs_set_page_dirty.patch

