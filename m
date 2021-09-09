Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB94405E91
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 23:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347899AbhIIVHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 17:07:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348198AbhIIVHS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 17:07:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2BF2611B0;
        Thu,  9 Sep 2021 21:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221569;
        bh=ka/9eF4fzUIX9dx2sNmtez63Jqit37Qtafw6kzzRrcM=;
        h=Date:From:To:Subject:From;
        b=ADuld4ZRSeCkkdxeGwpOGLLWHILh+ARHoBaL0k3MiYn/jEwXd07m/2w8DPy52C5JL
         mUC9rwIhJ1SrLao2wTZBpD8+SqL8I50N5TvGAqYbJV77kwubCSHRGSk96EueixkEx2
         uM692Sld7JCW+WovUKDAO3cPKjLZ98eOQfPa9L0U=
Date:   Thu, 09 Sep 2021 14:06:08 -0700
From:   akpm@linux-foundation.org
To:     liuzixian4@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        stable@vger.kernel.org
Subject:  [merged]
 mm-hugetlb-initialize-hugetlb_usage-in-mm_init.patch removed from -mm tree
Message-ID: <20210909210608.t5RrxBIjm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: initialize hugetlb_usage in mm_init
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-initialize-hugetlb_usage-in-mm_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liu Zixian <liuzixian4@huawei.com>
Subject: mm/hugetlb: initialize hugetlb_usage in mm_init

After fork, the child process will get incorrect (2x) hugetlb_usage.
If a process uses 5 2MB hugetlb pages in an anonymous mapping,

	HugetlbPages:	   10240 kB

and then forks, the child will show,

	HugetlbPages:	   20480 kB

The reason for double the amount is because hugetlb_usage will be copied
from the parent and then increased when we copy page tables from parent to
child.  Child will have 2x actual usage.

Fix this by adding hugetlb_count_init in mm_init.

Link: https://lkml.kernel.org/r/20210826071742.877-1-liuzixian4@huawei.com
Fixes: 5d317b2b6536 ("mm: hugetlb: proc: add HugetlbPages field to /proc/PID/status")
Signed-off-by: Liu Zixian <liuzixian4@huawei.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    9 +++++++++
 kernel/fork.c           |    1 +
 2 files changed, 10 insertions(+)

--- a/include/linux/hugetlb.h~mm-hugetlb-initialize-hugetlb_usage-in-mm_init
+++ a/include/linux/hugetlb.h
@@ -858,6 +858,11 @@ static inline spinlock_t *huge_pte_lockp
 
 void hugetlb_report_usage(struct seq_file *m, struct mm_struct *mm);
 
+static inline void hugetlb_count_init(struct mm_struct *mm)
+{
+	atomic_long_set(&mm->hugetlb_usage, 0);
+}
+
 static inline void hugetlb_count_add(long l, struct mm_struct *mm)
 {
 	atomic_long_add(l, &mm->hugetlb_usage);
@@ -1042,6 +1047,10 @@ static inline spinlock_t *huge_pte_lockp
 	return &mm->page_table_lock;
 }
 
+static inline void hugetlb_count_init(struct mm_struct *mm)
+{
+}
+
 static inline void hugetlb_report_usage(struct seq_file *f, struct mm_struct *m)
 {
 }
--- a/kernel/fork.c~mm-hugetlb-initialize-hugetlb_usage-in-mm_init
+++ a/kernel/fork.c
@@ -1063,6 +1063,7 @@ static struct mm_struct *mm_init(struct
 	mm->pmd_huge_pte = NULL;
 #endif
 	mm_init_uprobes_state(mm);
+	hugetlb_count_init(mm);
 
 	if (current->mm) {
 		mm->flags = current->mm->flags & MMF_INIT_MASK;
_

Patches currently in -mm which might be from liuzixian4@huawei.com are


