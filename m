Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2463290FE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243128AbhCAUSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:18:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:39932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238168AbhCAUJv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:09:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56369653B6;
        Mon,  1 Mar 2021 18:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621609;
        bh=aaxF2QK9+OiZkI+dWI56rYOQNR1JLWXIT8rLprKfO9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ccpEp1UqIW8LtpbpXmJzHXJIbA8aAPvygR9dezXHWNKGW3xh5JuqYlSAvdi0Mez9Z
         /0pPR9Jx0cYJqYOW8LaVLjHYZVSdc5Qz8+53tHrcr3qCCSiXRXxKADl4I2tK/gIJKL
         z5/YBJq73T07G7kCKnNgpFuYEdk1jvwopoKXfuzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rik van Riel <riel@surriel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Xu Yu <xuyu@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 561/775] mm,thp,shmem: make khugepaged obey tmpfs mount flags
Date:   Mon,  1 Mar 2021 17:12:09 +0100
Message-Id: <20210301161229.204930640@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rik van Riel <riel@surriel.com>

[ Upstream commit cd89fb06509903f942a0ffe97ffa63034671ed0c ]

Currently if thp enabled=[madvise], mounting a tmpfs filesystem with
huge=always and mmapping files from that tmpfs does not result in
khugepaged collapsing those mappings, despite the mount flag indicating
that it should.

Fix that by breaking up the blocks of tests in hugepage_vma_check a little
bit, and testing things in the correct order.

Link: https://lkml.kernel.org/r/20201124194925.623931-4-riel@surriel.com
Fixes: c2231020ea7b ("mm: thp: register mm for khugepaged when merging vma for shmem")
Signed-off-by: Rik van Riel <riel@surriel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xu Yu <xuyu@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/khugepaged.h |  2 ++
 mm/khugepaged.c            | 22 ++++++++++++++++------
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
index c941b73773216..2fcc01891b474 100644
--- a/include/linux/khugepaged.h
+++ b/include/linux/khugepaged.h
@@ -3,6 +3,7 @@
 #define _LINUX_KHUGEPAGED_H
 
 #include <linux/sched/coredump.h> /* MMF_VM_HUGEPAGE */
+#include <linux/shmem_fs.h>
 
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -57,6 +58,7 @@ static inline int khugepaged_enter(struct vm_area_struct *vma,
 {
 	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags))
 		if ((khugepaged_always() ||
+		     (shmem_file(vma->vm_file) && shmem_huge_enabled(vma)) ||
 		     (khugepaged_req_madv() && (vm_flags & VM_HUGEPAGE))) &&
 		    !(vm_flags & VM_NOHUGEPAGE) &&
 		    !test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 67ab391a53739..494d3cb0b58a3 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -442,18 +442,28 @@ static inline int khugepaged_test_exit(struct mm_struct *mm)
 static bool hugepage_vma_check(struct vm_area_struct *vma,
 			       unsigned long vm_flags)
 {
-	if ((!(vm_flags & VM_HUGEPAGE) && !khugepaged_always()) ||
-	    (vm_flags & VM_NOHUGEPAGE) ||
+	/* Explicitly disabled through madvise. */
+	if ((vm_flags & VM_NOHUGEPAGE) ||
 	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
 		return false;
 
-	if (shmem_file(vma->vm_file) ||
-	    (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-	     vma->vm_file &&
-	     (vm_flags & VM_DENYWRITE))) {
+	/* Enabled via shmem mount options or sysfs settings. */
+	if (shmem_file(vma->vm_file) && shmem_huge_enabled(vma)) {
 		return IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
 				HPAGE_PMD_NR);
 	}
+
+	/* THP settings require madvise. */
+	if (!(vm_flags & VM_HUGEPAGE) && !khugepaged_always())
+		return false;
+
+	/* Read-only file mappings need to be aligned for THP to work. */
+	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && vma->vm_file &&
+	    (vm_flags & VM_DENYWRITE)) {
+		return IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
+				HPAGE_PMD_NR);
+	}
+
 	if (!vma->anon_vma || vma->vm_ops)
 		return false;
 	if (vma_is_temporary_stack(vma))
-- 
2.27.0



