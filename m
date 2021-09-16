Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7750240DA6D
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 14:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239568AbhIPM6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 08:58:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239126AbhIPM6U (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 08:58:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49D4360F3A;
        Thu, 16 Sep 2021 12:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631797019;
        bh=Bds+Erm0a9mOh22/vfWPfDPMDiVZI0enQyB1dvMKqHI=;
        h=Subject:To:Cc:From:Date:From;
        b=QEilamBTukbdiICGZO1h6pBXa1MOZpuc0ih09Db+oxeWcLUiNBD70nnxmrYhomo3r
         x+Nseht4knLUPLilHHCcNp39JUksrEl0FTOHaZZOU8xrtgqfvlmKWpeaJ9wIEGkkIG
         3unIYwy439AHYaWgk7VjYod7gTcQdVCMSO/OUIsE=
Subject: FAILED: patch "[PATCH] mm/hugetlb: initialize hugetlb_usage in mm_init" failed to apply to 4.4-stable tree
To:     liuzixian4@huawei.com, akpm@linux-foundation.org,
        mike.kravetz@oracle.com, naoya.horiguchi@nec.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 16 Sep 2021 14:56:56 +0200
Message-ID: <163179701667234@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 13db8c50477d83ad3e3b9b0ae247e5cd833a7ae4 Mon Sep 17 00:00:00 2001
From: Liu Zixian <liuzixian4@huawei.com>
Date: Wed, 8 Sep 2021 18:10:05 -0700
Subject: [PATCH] mm/hugetlb: initialize hugetlb_usage in mm_init

After fork, the child process will get incorrect (2x) hugetlb_usage.  If
a process uses 5 2MB hugetlb pages in an anonymous mapping,

	HugetlbPages:	   10240 kB

and then forks, the child will show,

	HugetlbPages:	   20480 kB

The reason for double the amount is because hugetlb_usage will be copied
from the parent and then increased when we copy page tables from parent
to child.  Child will have 2x actual usage.

Fix this by adding hugetlb_count_init in mm_init.

Link: https://lkml.kernel.org/r/20210826071742.877-1-liuzixian4@huawei.com
Fixes: 5d317b2b6536 ("mm: hugetlb: proc: add HugetlbPages field to /proc/PID/status")
Signed-off-by: Liu Zixian <liuzixian4@huawei.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index f7ca1a3870ea..1faebe1cd0ed 100644
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
index ff5be23800af..38681ad44c76 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1063,6 +1063,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	mm->pmd_huge_pte = NULL;
 #endif
 	mm_init_uprobes_state(mm);
+	hugetlb_count_init(mm);
 
 	if (current->mm) {
 		mm->flags = current->mm->flags & MMF_INIT_MASK;

