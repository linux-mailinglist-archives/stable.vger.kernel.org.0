Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D65C1157849
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729545AbgBJMjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:39:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:38534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729539AbgBJMjv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:51 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16FE82080C;
        Mon, 10 Feb 2020 12:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338391;
        bh=09SYqOBbhNp3PmyxLBZXQZrSJJzmBUGN03hJg5diMvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5lcY1cZNgIcrhIdX1HcwgOzrxz3kF2HnnqR+iIlypkY3EZbeOhuHHzQF408w2l6q
         dXWPjDNpARUN1+Lb/km0DJBlISZ7I97PvA4vQ5Rw4vpIMI+ccHcdU3GoIBy0GoQMLw
         MGz184R2NVIh6HwXa3yfsfwUhIUQIHe25BQc6Ilo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.5 082/367] s390/mm: fix dynamic pagetable upgrade for hugetlbfs
Date:   Mon, 10 Feb 2020 04:29:55 -0800
Message-Id: <20200210122431.896727832@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

commit 5f490a520bcb393389a4d44bec90afcb332eb112 upstream.

Commit ee71d16d22bb ("s390/mm: make TASK_SIZE independent from the number
of page table levels") changed the logic of TASK_SIZE and also removed the
arch_mmap_check() implementation for s390. This combination has a subtle
effect on how get_unmapped_area() for hugetlbfs pages works. It is now
possible that a user process establishes a hugetlbfs mapping at an address
above 4 TB, without triggering a dynamic pagetable upgrade from 3 to 4
levels.

This is because hugetlbfs mappings will not use mm->get_unmapped_area, but
rather file->f_op->get_unmapped_area, which currently is the generic
implementation of hugetlb_get_unmapped_area() that does not know about s390
dynamic pagetable upgrades, but with the new definition of TASK_SIZE, it
will now allow mappings above 4 TB.

Subsequent access to such a mapped address above 4 TB will result in a page
fault loop, because the CPU cannot translate such a large address with 3
pagetable levels. The fault handler will try to map in a hugepage at the
address, but due to the folded pagetable logic it will end up with creating
entries in the 3 level pagetable, possibly overwriting existing mappings,
and then it all repeats when the access is retried.

Apart from the page fault loop, this can have various nasty effects, e.g.
kernel panic from one of the BUG_ON() checks in memory management code,
or even data loss if an existing mapping gets overwritten.

Fix this by implementing HAVE_ARCH_HUGETLB_UNMAPPED_AREA support for s390,
providing an s390 version for hugetlb_get_unmapped_area() with pagetable
upgrade support similar to arch_get_unmapped_area(), which will then be
used instead of the generic version.

Fixes: ee71d16d22bb ("s390/mm: make TASK_SIZE independent from the number of page table levels")
Cc: <stable@vger.kernel.org> # 4.12+
Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/include/asm/page.h |    2 
 arch/s390/mm/hugetlbpage.c   |  100 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 101 insertions(+), 1 deletion(-)

--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -33,6 +33,8 @@
 #define ARCH_HAS_PREPARE_HUGEPAGE
 #define ARCH_HAS_HUGEPAGE_CLEAR_FLUSH
 
+#define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
+
 #include <asm/setup.h>
 #ifndef __ASSEMBLY__
 
--- a/arch/s390/mm/hugetlbpage.c
+++ b/arch/s390/mm/hugetlbpage.c
@@ -2,7 +2,7 @@
 /*
  *  IBM System z Huge TLB Page Support for Kernel.
  *
- *    Copyright IBM Corp. 2007,2016
+ *    Copyright IBM Corp. 2007,2020
  *    Author(s): Gerald Schaefer <gerald.schaefer@de.ibm.com>
  */
 
@@ -11,6 +11,9 @@
 
 #include <linux/mm.h>
 #include <linux/hugetlb.h>
+#include <linux/mman.h>
+#include <linux/sched/mm.h>
+#include <linux/security.h>
 
 /*
  * If the bit selected by single-bit bitmask "a" is set within "x", move
@@ -267,3 +270,98 @@ static __init int setup_hugepagesz(char
 	return 1;
 }
 __setup("hugepagesz=", setup_hugepagesz);
+
+static unsigned long hugetlb_get_unmapped_area_bottomup(struct file *file,
+		unsigned long addr, unsigned long len,
+		unsigned long pgoff, unsigned long flags)
+{
+	struct hstate *h = hstate_file(file);
+	struct vm_unmapped_area_info info;
+
+	info.flags = 0;
+	info.length = len;
+	info.low_limit = current->mm->mmap_base;
+	info.high_limit = TASK_SIZE;
+	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
+	info.align_offset = 0;
+	return vm_unmapped_area(&info);
+}
+
+static unsigned long hugetlb_get_unmapped_area_topdown(struct file *file,
+		unsigned long addr0, unsigned long len,
+		unsigned long pgoff, unsigned long flags)
+{
+	struct hstate *h = hstate_file(file);
+	struct vm_unmapped_area_info info;
+	unsigned long addr;
+
+	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
+	info.length = len;
+	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
+	info.high_limit = current->mm->mmap_base;
+	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
+	info.align_offset = 0;
+	addr = vm_unmapped_area(&info);
+
+	/*
+	 * A failed mmap() very likely causes application failure,
+	 * so fall back to the bottom-up function here. This scenario
+	 * can happen with large stack limits and large mmap()
+	 * allocations.
+	 */
+	if (addr & ~PAGE_MASK) {
+		VM_BUG_ON(addr != -ENOMEM);
+		info.flags = 0;
+		info.low_limit = TASK_UNMAPPED_BASE;
+		info.high_limit = TASK_SIZE;
+		addr = vm_unmapped_area(&info);
+	}
+
+	return addr;
+}
+
+unsigned long hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
+		unsigned long len, unsigned long pgoff, unsigned long flags)
+{
+	struct hstate *h = hstate_file(file);
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma;
+	int rc;
+
+	if (len & ~huge_page_mask(h))
+		return -EINVAL;
+	if (len > TASK_SIZE - mmap_min_addr)
+		return -ENOMEM;
+
+	if (flags & MAP_FIXED) {
+		if (prepare_hugepage_range(file, addr, len))
+			return -EINVAL;
+		goto check_asce_limit;
+	}
+
+	if (addr) {
+		addr = ALIGN(addr, huge_page_size(h));
+		vma = find_vma(mm, addr);
+		if (TASK_SIZE - len >= addr && addr >= mmap_min_addr &&
+		    (!vma || addr + len <= vm_start_gap(vma)))
+			goto check_asce_limit;
+	}
+
+	if (mm->get_unmapped_area == arch_get_unmapped_area)
+		addr = hugetlb_get_unmapped_area_bottomup(file, addr, len,
+				pgoff, flags);
+	else
+		addr = hugetlb_get_unmapped_area_topdown(file, addr, len,
+				pgoff, flags);
+	if (addr & ~PAGE_MASK)
+		return addr;
+
+check_asce_limit:
+	if (addr + len > current->mm->context.asce_limit &&
+	    addr + len <= TASK_SIZE) {
+		rc = crst_table_upgrade(mm, addr + len);
+		if (rc)
+			return (unsigned long) rc;
+	}
+	return addr;
+}


