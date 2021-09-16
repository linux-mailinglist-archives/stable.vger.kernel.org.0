Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA98B40E0F6
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235193AbhIPQZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:25:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240828AbhIPQX4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:23:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75A4360F58;
        Thu, 16 Sep 2021 16:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808967;
        bh=+Kr3ie4VEwZik2Umf/lHuUVql+qx/7MRHU7MoUOo8D8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oE6PkvbIm9uCVmMyx5FJLIMzHpM7/MK85pgYbeVjh0b1gD9Z9zT554CPEbuG4tN3j
         9UlTe3mdy5LB1Yf88k5JMyQIQ7bFHcwq/TTi02oBfiXD+9zEJGr9jVRKlEmy0Xyy8G
         bzqxPgDRw0MkZsFMTnlDVbfOMhZTma1uAijjcG0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Zixian <liuzixian4@huawei.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 289/306] mm/hugetlb: initialize hugetlb_usage in mm_init
Date:   Thu, 16 Sep 2021 18:00:34 +0200
Message-Id: <20210916155803.958012206@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Zixian <liuzixian4@huawei.com>

commit 13db8c50477d83ad3e3b9b0ae247e5cd833a7ae4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hugetlb.h |    9 +++++++++
 kernel/fork.c           |    1 +
 2 files changed, 10 insertions(+)

--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -722,6 +722,11 @@ static inline spinlock_t *huge_pte_lockp
 
 void hugetlb_report_usage(struct seq_file *m, struct mm_struct *mm);
 
+static inline void hugetlb_count_init(struct mm_struct *mm)
+{
+	atomic_long_set(&mm->hugetlb_usage, 0);
+}
+
 static inline void hugetlb_count_add(long l, struct mm_struct *mm)
 {
 	atomic_long_add(l, &mm->hugetlb_usage);
@@ -897,6 +902,10 @@ static inline spinlock_t *huge_pte_lockp
 	return &mm->page_table_lock;
 }
 
+static inline void hugetlb_count_init(struct mm_struct *mm)
+{
+}
+
 static inline void hugetlb_report_usage(struct seq_file *f, struct mm_struct *m)
 {
 }
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1037,6 +1037,7 @@ static struct mm_struct *mm_init(struct
 	mm->pmd_huge_pte = NULL;
 #endif
 	mm_init_uprobes_state(mm);
+	hugetlb_count_init(mm);
 
 	if (current->mm) {
 		mm->flags = current->mm->flags & MMF_INIT_MASK;


