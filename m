Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4D7E133134
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 21:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbgAGU6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:58:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:58012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727897AbgAGU6d (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:58:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46509208C4;
        Tue,  7 Jan 2020 20:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430712;
        bh=VszkgkuGVtd5AejUcO16fOLaWvuil+mFODEPGFVBXYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iMhSKHNJgSS2Of2avEYMtTye0vh2QInQoWMe6gmXJv6dQnxnYHeukpnLdn/snFjxH
         a4y9c0jN/gX4s2WP5LWL1hHe35aKVwQAW+C413bHWl882lFvHIII1WMPSPn/MAlka6
         v2Oo3azLTBeRyJZFnloiQN0ihAiqGlurUDiC//Qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Hillf Danton <hdanton@sina.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 065/191] mm: drop mmap_sem before calling balance_dirty_pages() in write fault
Date:   Tue,  7 Jan 2020 21:53:05 +0100
Message-Id: <20200107205336.471219797@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

[ Upstream commit 89b15332af7c0312a41e50846819ca6613b58b4c ]

One of our services is observing hanging ps/top/etc under heavy write
IO, and the task states show this is an mmap_sem priority inversion:

A write fault is holding the mmap_sem in read-mode and waiting for
(heavily cgroup-limited) IO in balance_dirty_pages():

    balance_dirty_pages+0x724/0x905
    balance_dirty_pages_ratelimited+0x254/0x390
    fault_dirty_shared_page.isra.96+0x4a/0x90
    do_wp_page+0x33e/0x400
    __handle_mm_fault+0x6f0/0xfa0
    handle_mm_fault+0xe4/0x200
    __do_page_fault+0x22b/0x4a0
    page_fault+0x45/0x50

Somebody tries to change the address space, contending for the mmap_sem in
write-mode:

    call_rwsem_down_write_failed_killable+0x13/0x20
    do_mprotect_pkey+0xa8/0x330
    SyS_mprotect+0xf/0x20
    do_syscall_64+0x5b/0x100
    entry_SYSCALL_64_after_hwframe+0x3d/0xa2

The waiting writer locks out all subsequent readers to avoid lock
starvation, and several threads can be seen hanging like this:

    call_rwsem_down_read_failed+0x14/0x30
    proc_pid_cmdline_read+0xa0/0x480
    __vfs_read+0x23/0x140
    vfs_read+0x87/0x130
    SyS_read+0x42/0x90
    do_syscall_64+0x5b/0x100
    entry_SYSCALL_64_after_hwframe+0x3d/0xa2

To fix this, do what we do for cache read faults already: drop the
mmap_sem before calling into anything IO bound, in this case the
balance_dirty_pages() function, and return VM_FAULT_RETRY.

Link: http://lkml.kernel.org/r/20190924194238.GA29030@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/filemap.c  | 21 ---------------------
 mm/internal.h | 21 +++++++++++++++++++++
 mm/memory.c   | 38 +++++++++++++++++++++++++++-----------
 3 files changed, 48 insertions(+), 32 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 85b7d087eb45..1f5731768222 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2329,27 +2329,6 @@ EXPORT_SYMBOL(generic_file_read_iter);
 
 #ifdef CONFIG_MMU
 #define MMAP_LOTSAMISS  (100)
-static struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf,
-					     struct file *fpin)
-{
-	int flags = vmf->flags;
-
-	if (fpin)
-		return fpin;
-
-	/*
-	 * FAULT_FLAG_RETRY_NOWAIT means we don't want to wait on page locks or
-	 * anything, so we only pin the file and drop the mmap_sem if only
-	 * FAULT_FLAG_ALLOW_RETRY is set.
-	 */
-	if ((flags & (FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT)) ==
-	    FAULT_FLAG_ALLOW_RETRY) {
-		fpin = get_file(vmf->vma->vm_file);
-		up_read(&vmf->vma->vm_mm->mmap_sem);
-	}
-	return fpin;
-}
-
 /*
  * lock_page_maybe_drop_mmap - lock the page, possibly dropping the mmap_sem
  * @vmf - the vm_fault for this fault.
diff --git a/mm/internal.h b/mm/internal.h
index 0d5f720c75ab..7dd7fbb577a9 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -362,6 +362,27 @@ vma_address(struct page *page, struct vm_area_struct *vma)
 	return max(start, vma->vm_start);
 }
 
+static inline struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf,
+						    struct file *fpin)
+{
+	int flags = vmf->flags;
+
+	if (fpin)
+		return fpin;
+
+	/*
+	 * FAULT_FLAG_RETRY_NOWAIT means we don't want to wait on page locks or
+	 * anything, so we only pin the file and drop the mmap_sem if only
+	 * FAULT_FLAG_ALLOW_RETRY is set.
+	 */
+	if ((flags & (FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT)) ==
+	    FAULT_FLAG_ALLOW_RETRY) {
+		fpin = get_file(vmf->vma->vm_file);
+		up_read(&vmf->vma->vm_mm->mmap_sem);
+	}
+	return fpin;
+}
+
 #else /* !CONFIG_MMU */
 static inline void clear_page_mlock(struct page *page) { }
 static inline void mlock_vma_page(struct page *page) { }
diff --git a/mm/memory.c b/mm/memory.c
index b1ca51a079f2..cb7c940cf800 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2227,10 +2227,11 @@ static vm_fault_t do_page_mkwrite(struct vm_fault *vmf)
  *
  * The function expects the page to be locked and unlocks it.
  */
-static void fault_dirty_shared_page(struct vm_area_struct *vma,
-				    struct page *page)
+static vm_fault_t fault_dirty_shared_page(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	struct address_space *mapping;
+	struct page *page = vmf->page;
 	bool dirtied;
 	bool page_mkwrite = vma->vm_ops && vma->vm_ops->page_mkwrite;
 
@@ -2245,16 +2246,30 @@ static void fault_dirty_shared_page(struct vm_area_struct *vma,
 	mapping = page_rmapping(page);
 	unlock_page(page);
 
+	if (!page_mkwrite)
+		file_update_time(vma->vm_file);
+
+	/*
+	 * Throttle page dirtying rate down to writeback speed.
+	 *
+	 * mapping may be NULL here because some device drivers do not
+	 * set page.mapping but still dirty their pages
+	 *
+	 * Drop the mmap_sem before waiting on IO, if we can. The file
+	 * is pinning the mapping, as per above.
+	 */
 	if ((dirtied || page_mkwrite) && mapping) {
-		/*
-		 * Some device drivers do not set page.mapping
-		 * but still dirty their pages
-		 */
+		struct file *fpin;
+
+		fpin = maybe_unlock_mmap_for_io(vmf, NULL);
 		balance_dirty_pages_ratelimited(mapping);
+		if (fpin) {
+			fput(fpin);
+			return VM_FAULT_RETRY;
+		}
 	}
 
-	if (!page_mkwrite)
-		file_update_time(vma->vm_file);
+	return 0;
 }
 
 /*
@@ -2497,6 +2512,7 @@ static vm_fault_t wp_page_shared(struct vm_fault *vmf)
 	__releases(vmf->ptl)
 {
 	struct vm_area_struct *vma = vmf->vma;
+	vm_fault_t ret = VM_FAULT_WRITE;
 
 	get_page(vmf->page);
 
@@ -2520,10 +2536,10 @@ static vm_fault_t wp_page_shared(struct vm_fault *vmf)
 		wp_page_reuse(vmf);
 		lock_page(vmf->page);
 	}
-	fault_dirty_shared_page(vma, vmf->page);
+	ret |= fault_dirty_shared_page(vmf);
 	put_page(vmf->page);
 
-	return VM_FAULT_WRITE;
+	return ret;
 }
 
 /*
@@ -3567,7 +3583,7 @@ static vm_fault_t do_shared_fault(struct vm_fault *vmf)
 		return ret;
 	}
 
-	fault_dirty_shared_page(vma, vmf->page);
+	ret |= fault_dirty_shared_page(vmf);
 	return ret;
 }
 
-- 
2.20.1



