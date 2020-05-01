Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4211C13D1
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730390AbgEANdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:33:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730387AbgEANdK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:33:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A38624962;
        Fri,  1 May 2020 13:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339989;
        bh=eHuWPSMZSuzAJmjlGUzfmMAlm/csoLgewNpCCAi9xkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HFYJt8UVZKjatUtR1WiTvmPMq3C2sGiC5BWfYUgwRMHgF8ntF1aS05nD5VZGH1pNr
         eHIGBd7apBNIJCyUIu2i8fVgCZdAivsemrrEhS3uwI1aVkinGy5bO4QR79ChBq8EBc
         k/9qGAX5MnZOuyQuwLUqbUD6uEcV48c96/XkJHqQ=
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
Subject: [PATCH 4.14 049/117] vmalloc: fix remap_vmalloc_range() bounds checks
Date:   Fri,  1 May 2020 15:21:25 +0200
Message-Id: <20200501131550.594421179@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
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
@@ -102,7 +102,7 @@ extern void vunmap(const void *addr);
 
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
 
 #include <linux/uaccess.h>
 #include <asm/tlbflush.h>
@@ -2246,6 +2247,7 @@ finished:
  *	@vma:		vma to cover
  *	@uaddr:		target user address to start at
  *	@kaddr:		virtual address of vmalloc kernel memory
+ *	@pgoff:		offset from @kaddr to start at
  *	@size:		size of map area
  *
  *	Returns:	0 for success, -Exxx on failure
@@ -2258,9 +2260,15 @@ finished:
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
 
@@ -2274,8 +2282,10 @@ int remap_vmalloc_range_partial(struct v
 	if (!(area->flags & VM_USERMAP))
 		return -EINVAL;
 
-	if (kaddr + size > area->addr + get_vm_area_size(area))
+	if (check_add_overflow(size, off, &end_index) ||
+	    end_index > get_vm_area_size(area))
 		return -EINVAL;
+	kaddr += off;
 
 	do {
 		struct page *page = vmalloc_to_page(kaddr);
@@ -2314,7 +2324,7 @@ int remap_vmalloc_range(struct vm_area_s
 						unsigned long pgoff)
 {
 	return remap_vmalloc_range_partial(vma, vma->vm_start,
-					   addr + (pgoff << PAGE_SHIFT),
+					   addr, pgoff,
 					   vma->vm_end - vma->vm_start);
 }
 EXPORT_SYMBOL(remap_vmalloc_range);


