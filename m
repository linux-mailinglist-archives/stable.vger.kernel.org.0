Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F1B1C1581
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729787AbgEAN3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:29:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729778AbgEAN30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:29:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B7D924954;
        Fri,  1 May 2020 13:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339765;
        bh=BEyE56IG2BLgUVUhN8lGGKRdFKk0i+zep4JC6V4wuVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P3tnVAoJriulEijaL+eRuJNSSobiqgX18xpJa5xjibcX9wdHvA/hYmRoyeCUFlipM
         /NuYQ2KKsmah6b6BsvtR10Tj5tVr/J0h8YZXdP7Ax1bfgkfE1IrdUdrDaTRgKERbnx
         nEW2YaT0J3ZBmJZz/yWiCgkDI8hd1Xd2htwQaY7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 39/80] vmalloc: fix remap_vmalloc_range() bounds checks
Date:   Fri,  1 May 2020 15:21:33 +0200
Message-Id: <20200501131526.076612229@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.810761598@linuxfoundation.org>
References: <20200501131513.810761598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit bdebd6a2831b6fab69eb85cee74a8ba77f1a1cc2 upstream.

remap_vmalloc_range() has had various issues with the bounds checks it
promises to perform ("This function checks that addr is a valid
vmalloc'ed area, and that it is big enough to cover the vma") over time,
e.g.:

 - not detecting pgoff<<PAGE_SHIFT overflow

 - not detecting (pgoff<<PAGE_SHIFT)+usize overflow

 - not checking whether addr and addr+(pgoff<<PAGE_SHIFT) are the same
   vmalloc allocation

 - comparing a potentially wildly out-of-bounds pointer with the end of
   the vmalloc region

In particular, since commit fc9702273e2e ("bpf: Add mmap() support for
BPF_MAP_TYPE_ARRAY"), unprivileged users can cause kernel null pointer
dereferences by calling mmap() on a BPF map with a size that is bigger
than the distance from the start of the BPF map to the end of the
address space.

This could theoretically be used as a kernel ASLR bypass, by using
whether mmap() with a given offset oopses or returns an error code to
perform a binary search over the possible address range.

To allow remap_vmalloc_range_partial() to verify that addr and
addr+(pgoff<<PAGE_SHIFT) are in the same vmalloc region, pass the offset
to remap_vmalloc_range_partial() instead of adding it to the pointer in
remap_vmalloc_range().

In remap_vmalloc_range_partial(), fix the check against
get_vm_area_size() by using size comparisons instead of pointer
comparisons, and add checks for pgoff.

Fixes: 833423143c3a ("[PATCH] mm: introduce remap_vmalloc_range()")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: Andrii Nakryiko <andriin@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@chromium.org>
Link: http://lkml.kernel.org/r/20200415222312.236431-1-jannh@google.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/vmcore.c        |    2 +-
 include/linux/vmalloc.h |    2 +-
 mm/vmalloc.c            |   16 +++++++++++++---
 3 files changed, 15 insertions(+), 5 deletions(-)

--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -459,7 +459,7 @@ static int mmap_vmcore(struct file *file
 		tsz = min(elfcorebuf_sz + elfnotes_sz - (size_t)start, size);
 		kaddr = elfnotes_buf + start - elfcorebuf_sz;
 		if (remap_vmalloc_range_partial(vma, vma->vm_start + len,
-						kaddr, tsz))
+						kaddr, 0, tsz))
 			goto fail;
 		size -= tsz;
 		start += tsz;
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -89,7 +89,7 @@ extern void vunmap(const void *addr);
 
 extern int remap_vmalloc_range_partial(struct vm_area_struct *vma,
 				       unsigned long uaddr, void *kaddr,
-				       unsigned long size);
+				       unsigned long pgoff, unsigned long size);
 
 extern int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
 							unsigned long pgoff);
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -31,6 +31,7 @@
 #include <linux/compiler.h>
 #include <linux/llist.h>
 #include <linux/bitops.h>
+#include <linux/overflow.h>
 
 #include <asm/uaccess.h>
 #include <asm/tlbflush.h>
@@ -2173,6 +2174,7 @@ finished:
  *	@vma:		vma to cover
  *	@uaddr:		target user address to start at
  *	@kaddr:		virtual address of vmalloc kernel memory
+ *	@pgoff:		offset from @kaddr to start at
  *	@size:		size of map area
  *
  *	Returns:	0 for success, -Exxx on failure
@@ -2185,9 +2187,15 @@ finished:
  *	Similar to remap_pfn_range() (see mm/memory.c)
  */
 int remap_vmalloc_range_partial(struct vm_area_struct *vma, unsigned long uaddr,
-				void *kaddr, unsigned long size)
+				void *kaddr, unsigned long pgoff,
+				unsigned long size)
 {
 	struct vm_struct *area;
+	unsigned long off;
+	unsigned long end_index;
+
+	if (check_shl_overflow(pgoff, PAGE_SHIFT, &off))
+		return -EINVAL;
 
 	size = PAGE_ALIGN(size);
 
@@ -2201,8 +2209,10 @@ int remap_vmalloc_range_partial(struct v
 	if (!(area->flags & VM_USERMAP))
 		return -EINVAL;
 
-	if (kaddr + size > area->addr + get_vm_area_size(area))
+	if (check_add_overflow(size, off, &end_index) ||
+	    end_index > get_vm_area_size(area))
 		return -EINVAL;
+	kaddr += off;
 
 	do {
 		struct page *page = vmalloc_to_page(kaddr);
@@ -2241,7 +2251,7 @@ int remap_vmalloc_range(struct vm_area_s
 						unsigned long pgoff)
 {
 	return remap_vmalloc_range_partial(vma, vma->vm_start,
-					   addr + (pgoff << PAGE_SHIFT),
+					   addr, pgoff,
 					   vma->vm_end - vma->vm_start);
 }
 EXPORT_SYMBOL(remap_vmalloc_range);


