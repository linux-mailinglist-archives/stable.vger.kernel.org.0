Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF623244EC
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 21:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbhBXUJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 15:09:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:60432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233143AbhBXUIg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 15:08:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 389E364E09;
        Wed, 24 Feb 2021 20:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197275;
        bh=br2SndbgWMiTdshaOJ96Bl/IjnRBOH6TI6vIRuk13hA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=j4coavo/7wIDbnXSiGAKMsdOw27MuUSL3vUcUJzYlO/u6RGStE0PdlKVWTpfr31Vv
         ANtks2OJDILcCxp2ugUvB8JDW958pEt5FAaPluYVH8jto6wNkdiKq6bkQpCGsvsUJH
         E9SGLDvWoIGvr+THUgAo1a5adCKoUUbaiYU2eMzU=
Date:   Wed, 24 Feb 2021 12:07:54 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org, dbueso@suse.de,
        joao.m.martins@oracle.com, kirill.shutemov@linux.intel.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org, ziy@nvidia.com
Subject:  [patch 131/173] hugetlb: fix copy_huge_page_from_user
 contig page struct assumption
Message-ID: <20210224200754.-vZcYjb2n%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
@@ -5177,17 +5177,19 @@ long copy_huge_page_from_user(struct pag
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
