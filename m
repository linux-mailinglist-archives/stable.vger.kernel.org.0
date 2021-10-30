Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE5C4408BA
	for <lists+stable@lfdr.de>; Sat, 30 Oct 2021 14:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbhJ3M3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Oct 2021 08:29:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231875AbhJ3M27 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Oct 2021 08:28:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CFAA60F92;
        Sat, 30 Oct 2021 12:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635596789;
        bh=ub9Y82B9/lzXC946916RNtCALxJZrReE8ZL8kmdAgDY=;
        h=Subject:To:Cc:From:Date:From;
        b=tgNllNFpz2eMfcz3EnNoXruin09uu52SgKwLsIWJ6fAnoh6gl0yNNL40iLHV/goL2
         Lsy3HdHOB3U6Smca3+/dUrp6T7li9IAjucPW0M/7uRJ9oHQkVWpTmDgX0gDy3pFO2z
         UoH2kujM0hOIQExCCJhnpt3InOaFFR+GCS4n5sng=
Subject: FAILED: patch "[PATCH] mm: khugepaged: skip huge page collapse for special files" failed to apply to 5.10-stable tree
To:     shy828301@gmail.com, akpm@linux-foundation.org,
        andrea.righi@canonical.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, songliubraving@fb.com,
        stable@vger.kernel.org, sunhao.th@gmail.com,
        torvalds@linux-foundation.org, willy@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 30 Oct 2021 14:26:27 +0200
Message-ID: <1635596787134163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a4aeaa06d45e90f9b279f0b09de84bd00006e733 Mon Sep 17 00:00:00 2001
From: Yang Shi <shy828301@gmail.com>
Date: Thu, 28 Oct 2021 14:36:30 -0700
Subject: [PATCH] mm: khugepaged: skip huge page collapse for special files

The read-only THP for filesystems will collapse THP for files opened
readonly and mapped with VM_EXEC.  The intended usecase is to avoid TLB
misses for large text segments.  But it doesn't restrict the file types
so a THP could be collapsed for a non-regular file, for example, block
device, if it is opened readonly and mapped with EXEC permission.  This
may cause bugs, like [1] and [2].

This is definitely not the intended usecase, so just collapse THP for
regular files in order to close the attack surface.

[shy828301@gmail.com: fix vm_file check [3]]

Link: https://lore.kernel.org/lkml/CACkBjsYwLYLRmX8GpsDpMthagWOjWWrNxqY6ZLNQVr6yx+f5vA@mail.gmail.com/ [1]
Link: https://lore.kernel.org/linux-mm/000000000000c6a82505ce284e4c@google.com/ [2]
Link: https://lkml.kernel.org/r/CAHbLzkqTW9U3VvTu1Ki5v_cLRC9gHW+znBukg_ycergE0JWj-A@mail.gmail.com [3]
Link: https://lkml.kernel.org/r/20211027195221.3825-1-shy828301@gmail.com
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reported-by: Hao Sun <sunhao.th@gmail.com>
Reported-by: syzbot+aae069be1de40fb11825@syzkaller.appspotmail.com
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Andrea Righi <andrea.righi@canonical.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 48de4e1b0783..8a8b3aa92937 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -445,22 +445,25 @@ static bool hugepage_vma_check(struct vm_area_struct *vma,
 	if (!transhuge_vma_enabled(vma, vm_flags))
 		return false;
 
+	if (vma->vm_file && !IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) -
+				vma->vm_pgoff, HPAGE_PMD_NR))
+		return false;
+
 	/* Enabled via shmem mount options or sysfs settings. */
-	if (shmem_file(vma->vm_file) && shmem_huge_enabled(vma)) {
-		return IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
-				HPAGE_PMD_NR);
-	}
+	if (shmem_file(vma->vm_file))
+		return shmem_huge_enabled(vma);
 
 	/* THP settings require madvise. */
 	if (!(vm_flags & VM_HUGEPAGE) && !khugepaged_always())
 		return false;
 
-	/* Read-only file mappings need to be aligned for THP to work. */
+	/* Only regular file is valid */
 	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && vma->vm_file &&
-	    !inode_is_open_for_write(vma->vm_file->f_inode) &&
 	    (vm_flags & VM_EXEC)) {
-		return IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
-				HPAGE_PMD_NR);
+		struct inode *inode = vma->vm_file->f_inode;
+
+		return !inode_is_open_for_write(inode) &&
+			S_ISREG(inode->i_mode);
 	}
 
 	if (!vma->anon_vma || vma->vm_ops)

