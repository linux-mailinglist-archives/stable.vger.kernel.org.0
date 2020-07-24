Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33EE922BCCB
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 06:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgGXEPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jul 2020 00:15:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgGXEPf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jul 2020 00:15:35 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C9432065F;
        Fri, 24 Jul 2020 04:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595564134;
        bh=b0W4lX8wbjuHM2Nxb8mh+HiplDl7+Q8TqMh+NXBorwU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gEM/Nx1jMDCEoNblHf5Fw/QhLEvEW/rmUjCW1Ij5T++aMv63BdKlFLQRCULGRLMIJ
         uPCHSLtXDhVPvihtgwCBfa9M6v4CcA4CGhnCkBM8dHzTQGNC7l2AkOmlfOmQXnTApA
         B2i0ha8DfCPrMCu3ZI55PNdfPoeILxQYT/RDRJkU=
Date:   Thu, 23 Jul 2020 21:15:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, yang.shi@linux.alibaba.com
Subject:  [patch 09/15] khugepaged: fix null-pointer dereference
 due to race
Message-ID: <20200724041534.D87eQcPUp%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: khugepaged: fix null-pointer dereference due to race

khugepaged has to drop mmap lock several times while collapsing a page. 
The situation can change while the lock is dropped and we need to
re-validate that the VMA is still in place and the PMD is still subject
for collapse.

But we miss one corner case: while collapsing an anonymous pages the VMA
could be replaced with file VMA. If the file VMA doesn't have any
private pages we get NULL pointer dereference:

	general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
	KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
	anon_vma_lock_write include/linux/rmap.h:120 [inline]
	collapse_huge_page mm/khugepaged.c:1110 [inline]
	khugepaged_scan_pmd mm/khugepaged.c:1349 [inline]
	khugepaged_scan_mm_slot mm/khugepaged.c:2110 [inline]
	khugepaged_do_scan mm/khugepaged.c:2193 [inline]
	khugepaged+0x3bba/0x5a10 mm/khugepaged.c:2238

The fix is to make sure that the VMA is anonymous in
hugepage_vma_revalidate().  The helper is only used for collapsing
anonymous pages.

Link: http://lkml.kernel.org/r/20200722121439.44328-1-kirill.shutemov@linux.intel.com
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: syzbot+ed318e8b790ca72c5ad0@syzkaller.appspotmail.com
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/khugepaged.c~khugepaged-fix-null-pointer-dereference-due-to-race
+++ a/mm/khugepaged.c
@@ -958,6 +958,9 @@ static int hugepage_vma_revalidate(struc
 		return SCAN_ADDRESS_RANGE;
 	if (!hugepage_vma_check(vma, vma->vm_flags))
 		return SCAN_VMA_CHECK;
+	/* Anon VMA expected */
+	if (!vma->anon_vma || vma->vm_ops)
+		return SCAN_VMA_CHECK;
 	return 0;
 }
 
_
