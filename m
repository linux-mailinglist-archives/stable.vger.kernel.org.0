Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB7B4454F0
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbhKDOS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:18:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231861AbhKDOSE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:18:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A88C611C4;
        Thu,  4 Nov 2021 14:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636035326;
        bh=0AUwTX0c9ut9gVu5Ifzq7SKErsbHbxfBsi0dAHw3od0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cor2FBZTao98gOaE41b1DQIvIRuA6hdHyvDpYriCCE5m8s41wAS7BdZTwNULLRWA8
         jTkhe2+5xyHlY14raiKsiZJZOBBtTOZ/gwfaoyjPur4l6I7mvFN0ZuFXa3UD1NJaN0
         pDh46Ml4zdx8lIcvbebzpxfF3uVWnf7RRtFYif7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Yang Shi <shy828301@gmail.com>, Hao Sun <sunhao.th@gmail.com>,
        syzbot+aae069be1de40fb11825@syzkaller.appspotmail.com,
        Matthew Wilcox <willy@infradead.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Song Liu <songliubraving@fb.com>,
        Andrea Righi <andrea.righi@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 11/16] mm: khugepaged: skip huge page collapse for special files
Date:   Thu,  4 Nov 2021 15:12:50 +0100
Message-Id: <20211104141159.965954087@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211104141159.561284732@linuxfoundation.org>
References: <20211104141159.561284732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>

commit a4aeaa06d45e90f9b279f0b09de84bd00006e733 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/khugepaged.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -443,21 +443,24 @@ static bool hugepage_vma_check(struct vm
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
 	    (vm_flags & VM_DENYWRITE)) {
-		return IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
-				HPAGE_PMD_NR);
+		struct inode *inode = vma->vm_file->f_inode;
+
+		return S_ISREG(inode->i_mode);
 	}
 
 	if (!vma->anon_vma || vma->vm_ops)


