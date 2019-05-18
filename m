Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9502224E
	for <lists+stable@lfdr.de>; Sat, 18 May 2019 10:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728859AbfERIqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 May 2019 04:46:17 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8205 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725446AbfERIqR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 May 2019 04:46:17 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 636DA98F3BD9CDE92B79;
        Sat, 18 May 2019 16:46:14 +0800 (CST)
Received: from use12-sp2.huawei.com (10.67.188.162) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Sat, 18 May 2019 16:46:04 +0800
From:   jianhong chen <chenjianhong2@huawei.com>
To:     <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>,
        <mhocko@suse.com>, <vbabka@suse.cz>,
        <kirill.shutemov@linux.intel.com>, <yang.shi@linux.alibaba.com>,
        <jannh@google.com>, <steve.capper@arm.com>,
        <tiny.windzz@gmail.com>, <walken@google.com>, <willy@infradead.org>
CC:     <chenjianhong2@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <stable@vger.kernel.org>, <hughd@google.com>,
        <linux@arm.linux.org.uk>, <ralf@linux-mips.org>,
        <lethal@linux-sh.org>, <davem@davemloft.net>,
        <cmetcalf@tilera.com>, <mingo@elte.hu>, <tglx@linutronix.de>,
        <hpa@zytor.com>
Subject: [PATCH] mm/mmap: fix the adjusted length error
Date:   Sat, 18 May 2019 16:50:33 +0800
Message-ID: <1558169433-121358-1-git-send-email-chenjianhong2@huawei.com>
X-Mailer: git-send-email 1.8.5.6
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.188.162]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In linux version 4.4, a 32-bit process may fail to allocate 64M hugepage
memory by function shmat even though there is a 64M memory gap in
the process.

It is the adjusted length that causes the problem, introduced from
commit db4fbfb9523c935 ("mm: vm_unmapped_area() lookup function").
Accounting for the worst case alignment overhead, function unmapped_area
and unmapped_area_topdown adjust the search length before searching
for available vma gap. This is an estimated length, sum of the desired
length and the longest alignment offset, which can cause misjudgement
if the system has very few virtual memory left. For example, if the
longest memory gap available is 64M, we can’t get it from the system
by allocating 64M hugepage memory via shmat function. The reason is
that it requires a longger length, the sum of the desired length(64M)
and the longest alignment offset.

To fix this error ,we can calculate the alignment offset of
gap_start or gap_end to get a desired gap_start or gap_end value,
before searching for the available gap. In this way, we don't
need to adjust the search length.

Problem reproduces procedure:
1. allocate a lot of virtual memory segments via shmat and malloc
2. release one of the biggest memory segment via shmdt
3. attach the biggest memory segment via shmat

e.g.
process maps:
00008000-00009000 r-xp 00000000 00:12 3385    /tmp/memory_mmap
00011000-00012000 rw-p 00001000 00:12 3385    /tmp/memory_mmap
27536000-f756a000 rw-p 00000000 00:00 0
f756a000-f7691000 r-xp 00000000 01:00 560     /lib/libc-2.11.1.so
f7691000-f7699000 ---p 00127000 01:00 560     /lib/libc-2.11.1.so
f7699000-f769b000 r--p 00127000 01:00 560     /lib/libc-2.11.1.so
f769b000-f769c000 rw-p 00129000 01:00 560     /lib/libc-2.11.1.so
f769c000-f769f000 rw-p 00000000 00:00 0
f769f000-f76c0000 r-xp 00000000 01:00 583     /lib/libgcc_s.so.1
f76c0000-f76c7000 ---p 00021000 01:00 583     /lib/libgcc_s.so.1
f76c7000-f76c8000 rw-p 00020000 01:00 583     /lib/libgcc_s.so.1
f76c8000-f76e5000 r-xp 00000000 01:00 543     /lib/ld-2.11.1.so
f76e9000-f76ea000 rw-p 00000000 00:00 0
f76ea000-f76ec000 rw-p 00000000 00:00 0
f76ec000-f76ed000 r--p 0001c000 01:00 543     /lib/ld-2.11.1.so
f76ed000-f76ee000 rw-p 0001d000 01:00 543     /lib/ld-2.11.1.so
f7800000-f7a00000 rw-s 00000000 00:0e 0       /SYSV000000ea (deleted)
fba00000-fca00000 rw-s 00000000 00:0e 65538   /SYSV000000ec (deleted)
fca00000-fce00000 rw-s 00000000 00:0e 98307   /SYSV000000ed (deleted)
fce00000-fd800000 rw-s 00000000 00:0e 131076  /SYSV000000ee (deleted)
ff913000-ff934000 rw-p 00000000 00:00 0       [stack]
ffff0000-ffff1000 r-xp 00000000 00:00 0       [vectors]

from 0xf7a00000 to fba00000, it has 64M memory gap, but we can't get
it from kernel.

Signed-off-by: jianhong chen <chenjianhong2@huawei.com>
Cc: stable@vger.kernel.org
---
 mm/mmap.c | 43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index bd7b9f2..c5a5782 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1865,6 +1865,22 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 	return error;
 }
 
+static inline unsigned long gap_start_offset(struct vm_unmapped_area_info *info,
+					unsigned long addr)
+{
+	/* get gap_start offset to adjust gap address to the
+	 * desired alignment
+	 */
+	return (info->align_offset - addr) & info->align_mask;
+}
+
+static inline unsigned long gap_end_offset(struct vm_unmapped_area_info *info,
+					unsigned long addr)
+{
+	/* get gap_end offset to adjust gap address to the desired alignment */
+	return (addr - info->align_offset) & info->align_mask;
+}
+
 unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 {
 	/*
@@ -1879,10 +1895,7 @@ unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 	struct vm_area_struct *vma;
 	unsigned long length, low_limit, high_limit, gap_start, gap_end;
 
-	/* Adjust search length to account for worst case alignment overhead */
-	length = info->length + info->align_mask;
-	if (length < info->length)
-		return -ENOMEM;
+	length = info->length;
 
 	/* Adjust search limits by the desired length */
 	if (info->high_limit < length)
@@ -1914,6 +1927,7 @@ unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 		}
 
 		gap_start = vma->vm_prev ? vm_end_gap(vma->vm_prev) : 0;
+		gap_start += gap_start_offset(info, gap_start);
 check_current:
 		/* Check if current node has a suitable gap */
 		if (gap_start > high_limit)
@@ -1942,6 +1956,7 @@ unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 				       struct vm_area_struct, vm_rb);
 			if (prev == vma->vm_rb.rb_left) {
 				gap_start = vm_end_gap(vma->vm_prev);
+				gap_start += gap_start_offset(info, gap_start);
 				gap_end = vm_start_gap(vma);
 				goto check_current;
 			}
@@ -1951,17 +1966,17 @@ unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 check_highest:
 	/* Check highest gap, which does not precede any rbtree node */
 	gap_start = mm->highest_vm_end;
+	gap_start += gap_start_offset(info, gap_start);
 	gap_end = ULONG_MAX;  /* Only for VM_BUG_ON below */
 	if (gap_start > high_limit)
 		return -ENOMEM;
 
 found:
 	/* We found a suitable gap. Clip it with the original low_limit. */
-	if (gap_start < info->low_limit)
+	if (gap_start < info->low_limit) {
 		gap_start = info->low_limit;
-
-	/* Adjust gap address to the desired alignment */
-	gap_start += (info->align_offset - gap_start) & info->align_mask;
+		gap_start += gap_start_offset(info, gap_start);
+	}
 
 	VM_BUG_ON(gap_start + info->length > info->high_limit);
 	VM_BUG_ON(gap_start + info->length > gap_end);
@@ -1974,16 +1989,14 @@ unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
 	struct vm_area_struct *vma;
 	unsigned long length, low_limit, high_limit, gap_start, gap_end;
 
-	/* Adjust search length to account for worst case alignment overhead */
-	length = info->length + info->align_mask;
-	if (length < info->length)
-		return -ENOMEM;
+	length = info->length;
 
 	/*
 	 * Adjust search limits by the desired length.
 	 * See implementation comment at top of unmapped_area().
 	 */
 	gap_end = info->high_limit;
+	gap_end -= gap_end_offset(info, gap_end);
 	if (gap_end < length)
 		return -ENOMEM;
 	high_limit = gap_end - length;
@@ -2020,6 +2033,7 @@ unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
 check_current:
 		/* Check if current node has a suitable gap */
 		gap_end = vm_start_gap(vma);
+		gap_end -= gap_end_offset(info, gap_end);
 		if (gap_end < low_limit)
 			return -ENOMEM;
 		if (gap_start <= high_limit &&
@@ -2054,13 +2068,14 @@ unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
 
 found:
 	/* We found a suitable gap. Clip it with the original high_limit. */
-	if (gap_end > info->high_limit)
+	if (gap_end > info->high_limit) {
 		gap_end = info->high_limit;
+		gap_end -= gap_end_offset(info, gap_end);
+	}
 
 found_highest:
 	/* Compute highest gap address at the desired alignment */
 	gap_end -= info->length;
-	gap_end -= (gap_end - info->align_offset) & info->align_mask;
 
 	VM_BUG_ON(gap_end < info->low_limit);
 	VM_BUG_ON(gap_end < gap_start);
-- 
1.8.5.6

