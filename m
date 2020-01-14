Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7A1F139E31
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 01:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbgANA3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 19:29:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:45034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728890AbgANA3M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Jan 2020 19:29:12 -0500
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA2E92080D;
        Tue, 14 Jan 2020 00:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578961751;
        bh=YI2CR8TD42NI+UiZNILuPqhvV3jhtV6hqkOe1BZvkvk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=F9daBbTegDbBNOmSsgqsKJ5CTiOx5biB1BimM6sJai64VycJPZ4MWSzUiqkEginKe
         GiIzSpobqJ2twgFHJfpUx0k0sJnqSEoW+1hPjXGHu0m8FbQhX7vX98GEzOLIjweru3
         fvEjkDJEHbgtTkUA0KsxpfUZteumroN/R8XjbKYY=
Date:   Mon, 13 Jan 2020 16:29:10 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     thomas.willhalm@intel.com, stable@vger.kernel.org,
        otto.g.bruggeman@intel.com, kirill.shutemov@linux.intel.com,
        dan.j.williams@intel.com, aneesh.kumar@linux.vnet.ibm.com,
        kirill@shutemov.name, akpm@linux-foundation.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 03/11] mm/huge_memory.c: thp: fix conflict of
 above-47bit hint address and PMD alignment
Message-ID: <20200114002910.rzSOD%akpm@linux-foundation.org>
In-Reply-To: <20200113162831.f7d69e11e9e673c40005c9b0@linux-foundation.org>
User-Agent: s-nail v14.9.15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm/huge_memory.c: thp: fix conflict of above-47bit hint address and PMD alignment

Patch series "Fix two above-47bit hint address vs. THP bugs".

The two get_unmapped_area() implementations have to be fixed to provide
THP-friendly mappings if above-47bit hint address is specified.


This patch (of 2):

Filesystems use thp_get_unmapped_area() to provide THP-friendly mappings. 
For DAX in particular.

Normally, the kernel doesn't create userspace mappings above 47-bit, even
if the machine allows this (such as with 5-level paging on x86-64).  Not
all user space is ready to handle wide addresses.  It's known that at
least some JIT compilers use higher bits in pointers to encode their
information.

Userspace can ask for allocation from full address space by specifying
hint address (with or without MAP_FIXED) above 47-bits.  If the
application doesn't need a particular address, but wants to allocate from
whole address space it can specify -1 as a hint address.

Unfortunately, this trick breaks thp_get_unmapped_area(): the function
would not try to allocate PMD-aligned area if *any* hint address
specified.

Modify the routine to handle it correctly:

 - Try to allocate the space at the specified hint address with length
   padding required for PMD alignment.
 - If failed, retry without length padding (but with the same hint
   address);
 - If the returned address matches the hint address return it.
 - Otherwise, align the address as required for THP and return.

The user specified hint address is passed down to get_unmapped_area() so
above-47bit hint address will be taken into account without breaking
alignment requirements.

Link: http://lkml.kernel.org/r/20191220142548.7118-2-kirill.shutemov@linux.intel.com
Fixes: b569bab78d8d ("x86/mm: Prepare to expose larger address space to userspace")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Thomas Willhalm <thomas.willhalm@intel.com>
Tested-by: Dan Williams <dan.j.williams@intel.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Bruggeman, Otto G" <otto.g.bruggeman@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

--- a/mm/huge_memory.c~thp-fix-conflict-of-above-47bit-hint-address-and-pmd-alignment
+++ a/mm/huge_memory.c
@@ -527,13 +527,13 @@ void prep_transhuge_page(struct page *pa
 	set_compound_page_dtor(page, TRANSHUGE_PAGE_DTOR);
 }
 
-static unsigned long __thp_get_unmapped_area(struct file *filp, unsigned long len,
+static unsigned long __thp_get_unmapped_area(struct file *filp,
+		unsigned long addr, unsigned long len,
 		loff_t off, unsigned long flags, unsigned long size)
 {
-	unsigned long addr;
 	loff_t off_end = off + len;
 	loff_t off_align = round_up(off, size);
-	unsigned long len_pad;
+	unsigned long len_pad, ret;
 
 	if (off_end <= off_align || (off_end - off_align) < size)
 		return 0;
@@ -542,30 +542,40 @@ static unsigned long __thp_get_unmapped_
 	if (len_pad < len || (off + len_pad) < off)
 		return 0;
 
-	addr = current->mm->get_unmapped_area(filp, 0, len_pad,
+	ret = current->mm->get_unmapped_area(filp, addr, len_pad,
 					      off >> PAGE_SHIFT, flags);
-	if (IS_ERR_VALUE(addr))
+
+	/*
+	 * The failure might be due to length padding. The caller will retry
+	 * without the padding.
+	 */
+	if (IS_ERR_VALUE(ret))
 		return 0;
 
-	addr += (off - addr) & (size - 1);
-	return addr;
+	/*
+	 * Do not try to align to THP boundary if allocation at the address
+	 * hint succeeds.
+	 */
+	if (ret == addr)
+		return addr;
+
+	ret += (off - ret) & (size - 1);
+	return ret;
 }
 
 unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags)
 {
+	unsigned long ret;
 	loff_t off = (loff_t)pgoff << PAGE_SHIFT;
 
-	if (addr)
-		goto out;
 	if (!IS_DAX(filp->f_mapping->host) || !IS_ENABLED(CONFIG_FS_DAX_PMD))
 		goto out;
 
-	addr = __thp_get_unmapped_area(filp, len, off, flags, PMD_SIZE);
-	if (addr)
-		return addr;
-
- out:
+	ret = __thp_get_unmapped_area(filp, addr, len, off, flags, PMD_SIZE);
+	if (ret)
+		return ret;
+out:
 	return current->mm->get_unmapped_area(filp, addr, len, pgoff, flags);
 }
 EXPORT_SYMBOL_GPL(thp_get_unmapped_area);
_
