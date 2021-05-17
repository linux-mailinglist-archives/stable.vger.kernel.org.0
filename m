Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4913830C2
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238059AbhEQOad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:30:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239515AbhEQO2r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:28:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9EC0613DF;
        Mon, 17 May 2021 14:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260876;
        bh=X8HwRuh0gNgA/1ZwOanDDb7SRUIhV8vjrQQsFUQx7WI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RvXZGhBR9W1DlilWP4m7G73fbeGs3eV7DZky7btf23resGYRzPwlJc9reJuwxa6nI
         XOSv780G19wSRLKl3n6/vGXeu5BRdMtY5kKpol1yCqZLUivOY3J71CEt+bxbSGIaDw
         02kbE4X8vAjNAyMv0cTdow28G+WvmRyvtHfYgyvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.12 258/363] mm/hugetlb: fix F_SEAL_FUTURE_WRITE
Date:   Mon, 17 May 2021 16:02:04 +0200
Message-Id: <20210517140311.317699322@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

commit 22247efd822e6d263f3c8bd327f3f769aea9b1d9 upstream.

Patch series "mm/hugetlb: Fix issues on file sealing and fork", v2.

Hugh reported issue with F_SEAL_FUTURE_WRITE not applied correctly to
hugetlbfs, which I can easily verify using the memfd_test program, which
seems that the program is hardly run with hugetlbfs pages (as by default
shmem).

Meanwhile I found another probably even more severe issue on that hugetlb
fork won't wr-protect child cow pages, so child can potentially write to
parent private pages.  Patch 2 addresses that.

After this series applied, "memfd_test hugetlbfs" should start to pass.

This patch (of 2):

F_SEAL_FUTURE_WRITE is missing for hugetlb starting from the first day.
There is a test program for that and it fails constantly.

$ ./memfd_test hugetlbfs
memfd-hugetlb: CREATE
memfd-hugetlb: BASIC
memfd-hugetlb: SEAL-WRITE
memfd-hugetlb: SEAL-FUTURE-WRITE
mmap() didn't fail as expected
Aborted (core dumped)

I think it's probably because no one is really running the hugetlbfs test.

Fix it by checking FUTURE_WRITE also in hugetlbfs_file_mmap() as what we
do in shmem_mmap().  Generalize a helper for that.

Link: https://lkml.kernel.org/r/20210503234356.9097-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20210503234356.9097-2-peterx@redhat.com
Fixes: ab3948f58ff84 ("mm/memfd: add an F_SEAL_FUTURE_WRITE seal to memfd")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hugetlbfs/inode.c |    5 +++++
 include/linux/mm.h   |   32 ++++++++++++++++++++++++++++++++
 mm/shmem.c           |   22 ++++------------------
 3 files changed, 41 insertions(+), 18 deletions(-)

--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -131,6 +131,7 @@ static void huge_pagevec_release(struct
 static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct inode *inode = file_inode(file);
+	struct hugetlbfs_inode_info *info = HUGETLBFS_I(inode);
 	loff_t len, vma_len;
 	int ret;
 	struct hstate *h = hstate_file(file);
@@ -146,6 +147,10 @@ static int hugetlbfs_file_mmap(struct fi
 	vma->vm_flags |= VM_HUGETLB | VM_DONTEXPAND;
 	vma->vm_ops = &hugetlb_vm_ops;
 
+	ret = seal_check_future_write(info->seals, vma);
+	if (ret)
+		return ret;
+
 	/*
 	 * page based offset in vm_pgoff could be sufficiently large to
 	 * overflow a loff_t when converted to byte offset.  This can
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3170,5 +3170,37 @@ extern int sysctl_nr_trim_pages;
 
 void mem_dump_obj(void *object);
 
+/**
+ * seal_check_future_write - Check for F_SEAL_FUTURE_WRITE flag and handle it
+ * @seals: the seals to check
+ * @vma: the vma to operate on
+ *
+ * Check whether F_SEAL_FUTURE_WRITE is set; if so, do proper check/handling on
+ * the vma flags.  Return 0 if check pass, or <0 for errors.
+ */
+static inline int seal_check_future_write(int seals, struct vm_area_struct *vma)
+{
+	if (seals & F_SEAL_FUTURE_WRITE) {
+		/*
+		 * New PROT_WRITE and MAP_SHARED mmaps are not allowed when
+		 * "future write" seal active.
+		 */
+		if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_WRITE))
+			return -EPERM;
+
+		/*
+		 * Since an F_SEAL_FUTURE_WRITE sealed memfd can be mapped as
+		 * MAP_SHARED and read-only, take care to not allow mprotect to
+		 * revert protections on such mappings. Do this only for shared
+		 * mappings. For private mappings, don't need to mask
+		 * VM_MAYWRITE as we still want them to be COW-writable.
+		 */
+		if (vma->vm_flags & VM_SHARED)
+			vma->vm_flags &= ~(VM_MAYWRITE);
+	}
+
+	return 0;
+}
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2258,25 +2258,11 @@ out_nomem:
 static int shmem_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct shmem_inode_info *info = SHMEM_I(file_inode(file));
+	int ret;
 
-	if (info->seals & F_SEAL_FUTURE_WRITE) {
-		/*
-		 * New PROT_WRITE and MAP_SHARED mmaps are not allowed when
-		 * "future write" seal active.
-		 */
-		if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_WRITE))
-			return -EPERM;
-
-		/*
-		 * Since an F_SEAL_FUTURE_WRITE sealed memfd can be mapped as
-		 * MAP_SHARED and read-only, take care to not allow mprotect to
-		 * revert protections on such mappings. Do this only for shared
-		 * mappings. For private mappings, don't need to mask
-		 * VM_MAYWRITE as we still want them to be COW-writable.
-		 */
-		if (vma->vm_flags & VM_SHARED)
-			vma->vm_flags &= ~(VM_MAYWRITE);
-	}
+	ret = seal_check_future_write(info->seals, vma);
+	if (ret)
+		return ret;
 
 	/* arm64 - allow memory tagging on RAM-based files */
 	vma->vm_flags |= VM_MTE_ALLOWED;


