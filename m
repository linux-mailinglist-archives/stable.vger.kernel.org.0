Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC47328B94
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240193AbhCASh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:37:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:44682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238030AbhCAS31 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:29:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA9036527D;
        Mon,  1 Mar 2021 17:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619836;
        bh=okeCtSG7Ka7Bj1vHqCXyN3O/rjwda6/+h163fwI1cZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R75gqU5Xsp+4/MZ9KAssZumM/B5UEbi9o8ylSQ8P4lmmKCubpdvcmJtwgLFjPejMQ
         sdDb6JZZ/Fjevbt9kGTSwVfOV71lYHjWON8f7TPuMa4YtsLJ0WWc+viUtUSgVvs+vn
         rMUkyFbeKhIjLcG1ph51GFltBEhGm6Jiuwhzkke8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Kravetz <mike.kravetz@oracle.com>,
        Zi Yan <ziy@nvidia.com>, Davidlohr Bueso <dbueso@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Oscar Salvador <osalvador@suse.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 599/663] hugetlb: fix copy_huge_page_from_user contig page struct assumption
Date:   Mon,  1 Mar 2021 17:14:07 +0100
Message-Id: <20210301161211.501704308@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>

commit 3272cfc2525b3a2810a59312d7a1e6f04a0ca3ef upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5203,17 +5203,19 @@ long copy_huge_page_from_user(struct pag
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
 


