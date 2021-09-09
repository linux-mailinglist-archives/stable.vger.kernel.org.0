Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFD140428F
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 03:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348960AbhIIBLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 21:11:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348941AbhIIBLO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Sep 2021 21:11:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00C9261158;
        Thu,  9 Sep 2021 01:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631149806;
        bh=Qi5g0WJd95Lld7Mm36JDS4ey+bIpL2U8i+LE+7t0DLI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=tjX2+W5MSJQBvZaQvgy8Uog1sLFUictDCV5dS3QSpYfquLIZL36s3y3i02xB/No63
         yVlJms9wjDsYwnF2SQTHwpfwnt9HbBRrjjVyezXnZ5n9mzKoqmLRTSamTsx+ocesqM
         719qPO22gqbK8XhJuq/EEQCISXpRAsdCNZdUEqyk=
Date:   Wed, 08 Sep 2021 18:10:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        liuzixian4@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 2/8] mm/hugetlb: initialize hugetlb_usage in
 mm_init
Message-ID: <20210909011005.6UTH8UzKk%akpm@linux-foundation.org>
In-Reply-To: <20210908180859.d523d4bb4ad8eec11c61500d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
