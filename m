Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9C71BCB3B
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729653AbgD1SbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:31:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729646AbgD1SbS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:31:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 610A02076A;
        Tue, 28 Apr 2020 18:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098678;
        bh=Hk13QinprYZgIRF1dgkDe9eApvGfNPRK3fwtpheysR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u2EUKn+VomXgMUugW9EevGGkRilep+w+aHSb7Uh4Uo8anToX7F7X9LE/nNJr8KMAn
         oJHASAt65Bc661QBBWP0VvV191cQCazw9GxrgyC8cm082AM7VBT2RFBc2QLsnKYcAV
         SxH5+KoHiX47pLImO1xtvR9sYw4LYOOZkhPTi4TY=
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
Subject: [PATCH 5.6 097/167] vmalloc: fix remap_vmalloc_range() bounds checks
Date:   Tue, 28 Apr 2020 20:24:33 +0200
Message-Id: <20200428182237.414442594@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
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
 fs/proc/vmcore.c         |    5 +++--
 include/linux/vmalloc.h  |    2 +-
 mm/vmalloc.c             |   16 +++++++++++++---
 samples/vfio-mdev/mdpy.c |    2 +-
 4 files changed, 18 insertions(+), 7 deletions(-)

--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -266,7 +266,8 @@ static int vmcoredd_mmap_dumps(struct vm
 		if (start < offset + dump->size) {
 			tsz = min(offset + (u64)dump->size - start, (u64)size);
 			buf = dump->buf + start - offset;
-			if (remap_vmalloc_range_partial(vma, dst, buf, tsz)) {
+			if (remap_vmalloc_range_partial(vma, dst, buf, 0,
+							tsz)) {
 				ret = -EFAULT;
 				goto out_unlock;
 			}
@@ -624,7 +625,7 @@ static int mmap_vmcore(struct file *file
 		tsz = min(elfcorebuf_sz + elfnotes_sz - (size_t)start, size);
 		kaddr = elfnotes_buf + start - elfcorebuf_sz - vmcoredd_orig_sz;
 		if (remap_vmalloc_range_partial(vma, vma->vm_start + len,
-						kaddr, tsz))
+						kaddr, 0, tsz))
 			goto fail;
 
 		size -= tsz;
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -137,7 +137,7 @@ extern void vunmap(const void *addr);
 
 extern int remap_vmalloc_range_partial(struct vm_area_struct *vma,
 				       unsigned long uaddr, void *kaddr,
-				       unsigned long size);
+				       unsigned long pgoff, unsigned long size);
 
 extern int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
 							unsigned long pgoff);
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -34,6 +34,7 @@
 #include <linux/llist.h>
 #include <linux/bitops.h>
 #include <linux/rbtree_augmented.h>
+#include <linux/overflow.h>
 
 #include <linux/uaccess.h>
 #include <asm/tlbflush.h>
@@ -3054,6 +3055,7 @@ finished:
  * @vma:		vma to cover
  * @uaddr:		target user address to start at
  * @kaddr:		virtual address of vmalloc kernel memory
+ * @pgoff:		offset from @kaddr to start at
  * @size:		size of map area
  *
  * Returns:	0 for success, -Exxx on failure
@@ -3066,9 +3068,15 @@ finished:
  * Similar to remap_pfn_range() (see mm/memory.c)
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
 
@@ -3082,8 +3090,10 @@ int remap_vmalloc_range_partial(struct v
 	if (!(area->flags & (VM_USERMAP | VM_DMA_COHERENT)))
 		return -EINVAL;
 
-	if (kaddr + size > area->addr + get_vm_area_size(area))
+	if (check_add_overflow(size, off, &end_index) ||
+	    end_index > get_vm_area_size(area))
 		return -EINVAL;
+	kaddr += off;
 
 	do {
 		struct page *page = vmalloc_to_page(kaddr);
@@ -3122,7 +3132,7 @@ int remap_vmalloc_range(struct vm_area_s
 						unsigned long pgoff)
 {
 	return remap_vmalloc_range_partial(vma, vma->vm_start,
-					   addr + (pgoff << PAGE_SHIFT),
+					   addr, pgoff,
 					   vma->vm_end - vma->vm_start);
 }
 EXPORT_SYMBOL(remap_vmalloc_range);
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -418,7 +418,7 @@ static int mdpy_mmap(struct mdev_device
 		return -EINVAL;
 
 	return remap_vmalloc_range_partial(vma, vma->vm_start,
-					   mdev_state->memblk,
+					   mdev_state->memblk, 0,
 					   vma->vm_end - vma->vm_start);
 }
 


