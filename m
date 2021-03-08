Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD943331AE1
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 00:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbhCHXPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 18:15:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:35292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230342AbhCHXPY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 18:15:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDFBE650FC;
        Mon,  8 Mar 2021 23:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615245324;
        bh=UlvU9nend12bDrc24BwsqzwjdIntYbrKTgQzbhAqUcE=;
        h=Date:From:To:Subject:From;
        b=sYQTMHbnqEeXz9jy2xzL53LD5rgTBvO/mGvHi6/mst95q7ty6PEIDRtBkypZZCEjs
         KhobOYhpQS9o5obE+rPmJi7jsOAJO6sYspDCCjRBeG3Jy4skyC+Cuz1cDI5SN3egUa
         GxSpDk57bxrl/WIZWjX0ytRkSojIuQIY0tHGF5VE=
Date:   Mon, 08 Mar 2021 15:15:23 -0800
From:   akpm@linux-foundation.org
To:     chenjianhong2@huawei.com, gregkh@linuxfoundation.org,
        jannh@google.com, kirill.shutemov@linux.intel.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        steve.capper@arm.com, tiny.windzz@gmail.com, vbabka@suse.cz,
        walken@google.com, yang.shi@linux.alibaba.com
Subject:  [to-be-updated]
 mm-mmap-fix-the-adjusted-length-error.patch removed from -mm tree
Message-ID: <20210308231523.fwqRJcrHK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: fix the adjusted length error
has been removed from the -mm tree.  Its filename was
     mm-mmap-fix-the-adjusted-length-error.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: jianhong chen <chenjianhong2@huawei.com>
Subject: mm/mmap.c: fix the adjusted length error

In linux version 4.4, a 32-bit process may fail to allocate 64M hugepage
memory by function shmat even though there is a 64M memory gap in the
process.

It is the adjusted length that causes the problem, introduced by
db4fbfb9523c935 ("mm: vm_unmapped_area() lookup function").  Accounting
for the worst case alignment overhead, unmapped_area() and
unmapped_area_topdown() adjust the search length before searching for
available vma gap.  This is an estimated length, sum of the desired length
and the longest alignment offset, which can cause misjudgement if the
system has very little virtual memory left.  For example, if the longest
memory gap available is 64M, we can't get it from the system by allocating
64M hugepage memory via shmat function.  The reason is that it requires a
longer length, the sum of the desired length(64M) and the longest
alignment offset.

To fix this error we can calculate the alignment offset of gap_start or
gap_end to get a desired gap_start or gap_end value, before searching for
the available gap.  In this way, we don't need to adjust the search
length.

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

from 0xf7a00000 to fba00000, it has 64M memory gap, but we can't get it
from kernel.

Link: http://lkml.kernel.org/r/1558073209-79549-1-git-send-email-chenjianhong2@huawei.com
Fixes: db4fbfb9523c ("mm: vm_unmapped_area() lookup function")
Signed-off-by: jianhong chen <chenjianhong2@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Steve Capper <steve.capper@arm.com>
Cc: Yangtao Li <tiny.windzz@gmail.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

--- a/mm/mmap.c~mm-mmap-fix-the-adjusted-length-error
+++ a/mm/mmap.c
@@ -1914,6 +1914,22 @@ unacct_error:
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
 static unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 {
 	/*
@@ -1928,10 +1944,7 @@ static unsigned long unmapped_area(struc
 	struct vm_area_struct *vma;
 	unsigned long length, low_limit, high_limit, gap_start, gap_end;
 
-	/* Adjust search length to account for worst case alignment overhead */
-	length = info->length + info->align_mask;
-	if (length < info->length)
-		return -ENOMEM;
+	length = info->length;
 
 	/* Adjust search limits by the desired length */
 	if (info->high_limit < length)
@@ -1963,6 +1976,7 @@ static unsigned long unmapped_area(struc
 		}
 
 		gap_start = vma->vm_prev ? vm_end_gap(vma->vm_prev) : 0;
+		gap_start += gap_start_offset(info, gap_start);
 check_current:
 		/* Check if current node has a suitable gap */
 		if (gap_start > high_limit)
@@ -1991,6 +2005,7 @@ check_current:
 				       struct vm_area_struct, vm_rb);
 			if (prev == vma->vm_rb.rb_left) {
 				gap_start = vm_end_gap(vma->vm_prev);
+				gap_start += gap_start_offset(info, gap_start);
 				gap_end = vm_start_gap(vma);
 				goto check_current;
 			}
@@ -2000,17 +2015,17 @@ check_current:
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
@@ -2023,16 +2038,14 @@ static unsigned long unmapped_area_topdo
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
@@ -2069,6 +2082,7 @@ static unsigned long unmapped_area_topdo
 check_current:
 		/* Check if current node has a suitable gap */
 		gap_end = vm_start_gap(vma);
+		gap_end -= gap_end_offset(info, gap_end);
 		if (gap_end < low_limit)
 			return -ENOMEM;
 		if (gap_start <= high_limit &&
@@ -2103,13 +2117,14 @@ check_current:
 
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
_

Patches currently in -mm which might be from chenjianhong2@huawei.com are


