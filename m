Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10A33F8301
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 09:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239628AbhHZHSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 03:18:32 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9366 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234415AbhHZHSc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 03:18:32 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GwDbK6TyNz8vM4;
        Thu, 26 Aug 2021 15:13:33 +0800 (CST)
Received: from dggpemm000001.china.huawei.com (7.185.36.245) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 26 Aug 2021 15:17:43 +0800
Received: from huawei.com (10.174.177.108) by dggpemm000001.china.huawei.com
 (7.185.36.245) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 26 Aug
 2021 15:17:42 +0800
From:   Liu Zixian <liuzixian4@huawei.com>
To:     <linux-mm@kvack.org>, <mike.kravetz@oracle.com>,
        <akpm@linux-foundation.org>
CC:     <naoya.horiguchi@nec.com>, <stable@vger.kernel.org>,
        <wuxu.wu@huawei.com>
Subject: [PATCH v2] mm/hugetlb: initialize hugetlb_usage in mm_init
Date:   Thu, 26 Aug 2021 15:17:42 +0800
Message-ID: <20210826071742.877-1-liuzixian4@huawei.com>
X-Mailer: git-send-email 2.29.2.windows.3
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.108]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm000001.china.huawei.com (7.185.36.245)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After fork, the child process will get incorrect (2x) hugetlb_usage.
If a process uses 5 2MB hugetlb pages in an anonymous mapping,
	HugetlbPages:	   10240 kB
and then forks, the child will show,
	HugetlbPages:	   20480 kB
The reason for double the amount is because hugetlb_usage will be
copied from the parent and then increased when we copy page tables
from parent to child. Child will have 2x actual usage.

Fix this by adding hugetlb_count_init in mm_init.

Fixes: 5d317b2b6536 ("mm: hugetlb: proc: add HugetlbPages field to
/proc/PID/status")
Signed-off-by: Liu Zixian <liuzixian4@huawei.com>
---
v2:
1. Create two hugetlb_count_init in hugetlb.h instead of using #ifdef
  in fork.c
2. Add an example to clearify this issue.
---
 include/linux/hugetlb.h | 9 +++++++++
 kernel/fork.c           | 1 +
 2 files changed, 10 insertions(+)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index f7ca1a387..1faebe1cd 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -858,6 +858,11 @@ static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
 
 void hugetlb_report_usage(struct seq_file *m, struct mm_struct *mm);
 
+static inline void hugetlb_count_init(struct mm_struct *mm)
+{
+	atomic_long_set(&mm->hugetlb_usage, 0);
+}
+
 static inline void hugetlb_count_add(long l, struct mm_struct *mm)
 {
 	atomic_long_add(l, &mm->hugetlb_usage);
@@ -1042,6 +1047,10 @@ static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
 	return &mm->page_table_lock;
 }
 
+static inline void hugetlb_count_init(struct mm_struct *mm)
+{
+}
+
 static inline void hugetlb_report_usage(struct seq_file *f, struct mm_struct *m)
 {
 }
diff --git a/kernel/fork.c b/kernel/fork.c
index bc94b2cc5..0dbc96ade 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1050,6 +1050,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	mm->pmd_huge_pte = NULL;
 #endif
 	mm_init_uprobes_state(mm);
+	hugetlb_count_init(mm);
 
 	if (current->mm) {
 		mm->flags = current->mm->flags & MMF_INIT_MASK;
-- 
2.18.1

