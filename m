Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E2A3FCF9D
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 00:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239894AbhHaWnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Aug 2021 18:43:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229602AbhHaWnq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Aug 2021 18:43:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0B8060FF2;
        Tue, 31 Aug 2021 22:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630449770;
        bh=JPaaH/lz1NiqWY8tspwvWTmAN1QHWj/poVs5KN/8N3c=;
        h=Date:From:To:Subject:From;
        b=AjWmw4YuvyEaWhT0m1QTjqG7mx9CgtA0x+yQRyGymxy4uUXuz0GDj/Fpeir/tlkOe
         Trl+HMpj3HHT6YFAVdtXGzi4FKVtXwxMdUJ2Gb2VjkvwfQaHJGrpgvvGMw8Fyrq2VC
         A6+mhS9fSWAYTJiLEJOEvfty87LuGxE0t6zppoas=
Date:   Tue, 31 Aug 2021 15:42:50 -0700
From:   akpm@linux-foundation.org
To:     liuzixian4@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        stable@vger.kernel.org
Subject:  + mm-hugetlb-initialize-hugetlb_usage-in-mm_init.patch
 added to -mm tree
Message-ID: <20210831224250.LRxYZi1vW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: initialize hugetlb_usage in mm_init
has been added to the -mm tree.  Its filename is
     mm-hugetlb-initialize-hugetlb_usage-in-mm_init.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-initialize-hugetlb_usage-in-mm_init.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-initialize-hugetlb_usage-in-mm_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1052,6 +1052,7 @@ static struct mm_struct *mm_init(struct
 	mm->pmd_huge_pte = NULL;
 #endif
 	mm_init_uprobes_state(mm);
+	hugetlb_count_init(mm);
 
 	if (current->mm) {
 		mm->flags = current->mm->flags & MMF_INIT_MASK;
_

Patches currently in -mm which might be from liuzixian4@huawei.com are

mm-hugetlb-initialize-hugetlb_usage-in-mm_init.patch

