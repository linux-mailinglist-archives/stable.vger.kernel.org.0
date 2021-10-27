Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA2443D35C
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 22:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238576AbhJ0U7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 16:59:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234080AbhJ0U7I (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 16:59:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D02B60720;
        Wed, 27 Oct 2021 20:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635368202;
        bh=i66Gt8WNoXAI44A7TNM7eeizqI0+/HC02kO5gbjJpSo=;
        h=Date:From:To:Subject:From;
        b=EYgldAQykcLV87i4EnYfTyeaxvZe5mq8bFzRd3JK9xoiROgLErkh/tkqtfZXqYkKg
         CJgNRiHGzGQMT02fpW7lhDu3JomyS65AYnS0uQI+h8LMKZJ6Fp1CVna7LUfq5srtBs
         AQtPNLiFbXNcY+Unya3wg9hzDcFTWqEAWRcdyk4I=
Date:   Wed, 27 Oct 2021 13:56:41 -0700
From:   akpm@linux-foundation.org
To:     andrea.righi@canonical.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        shy828301@gmail.com, songliubraving@fb.com, stable@vger.kernel.org,
        sunhao.th@gmail.com, willy@infradead.org
Subject:  +
 mm-khugepaged-skip-huge-page-collapse-for-special-files.patch added to -mm
 tree
Message-ID: <20211027205641.f7NuUnodc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: khugepaged: skip huge page collapse for special files
has been added to the -mm tree.  Its filename is
     mm-khugepaged-skip-huge-page-collapse-for-special-files.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-khugepaged-skip-huge-page-collapse-for-special-files.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-khugepaged-skip-huge-page-collapse-for-special-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: khugepaged: skip huge page collapse for special files

The read-only THP for filesystems will collapse THP for files opened
readonly and mapped with VM_EXEC.  The intended usecase is to avoid TLB
misses for large text segments.  But it doesn't restrict the file types so
a THP could be collapsed for a non-regular file, for example, block
device, if it is opened readonly and mapped with EXEC permission.  This
may cause bugs, like [1] and [2].

This is definitely not the intended usecase, so just collapse THP for
regular files in order to close the attack surface.

[1] https://lore.kernel.org/lkml/CACkBjsYwLYLRmX8GpsDpMthagWOjWWrNxqY6ZLNQVr6yx+f5vA@mail.gmail.com/
[2] https://lore.kernel.org/linux-mm/000000000000c6a82505ce284e4c@google.com/

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
---

 mm/khugepaged.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-skip-huge-page-collapse-for-special-files
+++ a/mm/khugepaged.c
@@ -445,22 +445,25 @@ static bool hugepage_vma_check(struct vm
 	if (!transhuge_vma_enabled(vma, vm_flags))
 		return false;
 
-	/* Enabled via shmem mount options or sysfs settings. */
-	if (shmem_file(vma->vm_file) && shmem_huge_enabled(vma)) {
+	if (vma->vm_file)
 		return IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
 				HPAGE_PMD_NR);
-	}
+
+	/* Enabled via shmem mount options or sysfs settings. */
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
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-hwpoison-remove-the-unnecessary-thp-check.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault.patch
mm-khugepaged-skip-huge-page-collapse-for-special-files.patch
mm-khugepaged-skip-huge-page-collapse-for-special-files-fix.patch
mm-filemap-coding-style-cleanup-for-filemap_map_pmd.patch
mm-hwpoison-refactor-refcount-check-handling.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens.patch
mm-hwpoison-handle-non-anonymous-thp-correctly.patch
mm-migrate-make-demotion-knob-depend-on-migration.patch

