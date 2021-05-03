Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803583723AE
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 01:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbhECXo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 19:44:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60599 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229499AbhECXo5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 May 2021 19:44:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620085443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SgqZKuzF10VtS2gxChk76nX04SENhfjxF8qh9wfVxX4=;
        b=bD4ys/6l4+nuw6Uw/YgyDK08oBPedrbo2TBkj/PYSDmyj8CjlFxlM4whZ6CZQzPnhKK56c
        9XUxG7/6dwQP4h2WFMC1GgWc7C/DTNNNRN4xdRZ/3q2BkaBRs/4/c8wpHqlSBj7daPnjhl
        nKsumMP3ES+mzcksZx4f5Qc5PT6YvT4=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572-c448jNQfNK6OMktFZd54gQ-1; Mon, 03 May 2021 19:44:01 -0400
X-MC-Unique: c448jNQfNK6OMktFZd54gQ-1
Received: by mail-qv1-f70.google.com with SMTP id b10-20020a0cf04a0000b02901bda1df3afbso6202174qvl.13
        for <stable@vger.kernel.org>; Mon, 03 May 2021 16:44:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SgqZKuzF10VtS2gxChk76nX04SENhfjxF8qh9wfVxX4=;
        b=bpDJSlmgt3EJz+I+UOysy/+O/JQHKJO+HpqmP4G+9cmsTAcM5q3hxmt1nYqMZlwC/Y
         CEHLHC3Mw5cbmreirrqnRkVi6oC9FvYj+c3yjC8F80TUWVQB/PGSeilIfKLExupJqKEr
         WSdHySQliSbmVujO+acs7Yl2zDlnt3iexlQoyv5klZSQk1MrvVbjzt6zOabzK1VIIAJg
         pu9vxKoDN22S1Risz3it/oGlfvW3bSr7eDNnL27oPGHpkWYz/y+aTg+OCekdcl2oqANM
         zZ9ifrlAYTwH4wxW52uUwZQbaMhw0yMpaViuBLrYvuOYZBMzDWQNjHGyFEuN2zWFXJu2
         8k2Q==
X-Gm-Message-State: AOAM532mvdbQRRzFZKXzyaogUrwPjn8stngwA9vRT1Ubd5/N3xMrNue3
        wnDTwpBgI/asewKIl1BzAl12GhUTxYf+xqKrK9PJk7+lxA6aO8uo1XammbjZsreXaCfAZq8iZ4c
        lHRUKqta29NTtnM6w
X-Received: by 2002:ac8:7f04:: with SMTP id f4mr20100486qtk.88.1620085441269;
        Mon, 03 May 2021 16:44:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3/uFtTC37fwDHvfixViADg9ZV7qQj5qPTP5MX0Fsx6PvguTQXzqTCXbAffm0dw2XKzN9yPQ==
X-Received: by 2002:ac8:7f04:: with SMTP id f4mr20100473qtk.88.1620085441017;
        Mon, 03 May 2021 16:44:01 -0700 (PDT)
Received: from t490s.redhat.com (bras-base-toroon474qw-grc-72-184-145-4-219.dsl.bell.ca. [184.145.4.219])
        by smtp.gmail.com with ESMTPSA id 189sm7126903qkh.99.2021.05.03.16.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 16:44:00 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     Axel Rasmussen <axelrasmussen@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, peterx@redhat.com,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Hugh Dickins <hughd@google.com>,
        Joel Fernandes <joel@joelfernandes.org>, stable@vger.kernel.org
Subject: [PATCH v2 1/2] mm/hugetlb: Fix F_SEAL_FUTURE_WRITE
Date:   Mon,  3 May 2021 19:43:55 -0400
Message-Id: <20210503234356.9097-2-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210503234356.9097-1-peterx@redhat.com>
References: <20210503234356.9097-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Fix it by checking FUTURE_WRITE also in hugetlbfs_file_mmap() as what we do in
shmem_mmap().  Generalize a helper for that.

Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: stable@vger.kernel.org
Fixes: ab3948f58ff84 ("mm/memfd: add an F_SEAL_FUTURE_WRITE seal to memfd")
Reported-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 fs/hugetlbfs/inode.c |  5 +++++
 include/linux/mm.h   | 32 ++++++++++++++++++++++++++++++++
 mm/shmem.c           | 22 ++++------------------
 3 files changed, 41 insertions(+), 18 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 9b383c39756a5..6557cf2cb1879 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -131,6 +131,7 @@ static void huge_pagevec_release(struct pagevec *pvec)
 static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct inode *inode = file_inode(file);
+	struct hugetlbfs_inode_info *info = HUGETLBFS_I(inode);
 	loff_t len, vma_len;
 	int ret;
 	struct hstate *h = hstate_file(file);
@@ -146,6 +147,10 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	vma->vm_flags |= VM_HUGETLB | VM_DONTEXPAND;
 	vma->vm_ops = &hugetlb_vm_ops;
 
+	ret = seal_check_future_write(info->seals, vma);
+	if (ret)
+		return ret;
+
 	/*
 	 * page based offset in vm_pgoff could be sufficiently large to
 	 * overflow a loff_t when converted to byte offset.  This can
diff --git a/include/linux/mm.h b/include/linux/mm.h
index d6790ab0cf575..b9b2caf9302bc 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3238,5 +3238,37 @@ extern int sysctl_nr_trim_pages;
 
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
diff --git a/mm/shmem.c b/mm/shmem.c
index a1f21736ad68e..250b52e682590 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2258,25 +2258,11 @@ int shmem_lock(struct file *file, int lock, struct user_struct *user)
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
-- 
2.31.1

