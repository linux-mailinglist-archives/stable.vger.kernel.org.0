Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2584122B1
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359049AbhITSQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:16:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376726AbhITSOW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:14:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9593460ED5;
        Mon, 20 Sep 2021 17:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158495;
        bh=6Gq9oFqm669+Nl+EdOCm6ywT1iQbl8LAnBgZK3UmQNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cdHY9bl2Pa/EVa1GiOxaHDo2tb8rfemK0+7THd9uJ0IkuYotvGNVOBfjMDVV9PRBh
         H4LdvUVAAWsdDJ3HM0niSj/kncYr8JcQoiYV6e+ZlG49ZYL4HzzlrnTqWYdOI4IDRr
         F9Etuhdkbjb8r3E2bnlpFWiLkU1lLpzPgA91KDUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Zixian <liuzixian4@huawei.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 181/260] mm/hugetlb: initialize hugetlb_usage in mm_init
Date:   Mon, 20 Sep 2021 18:43:19 +0200
Message-Id: <20210920163937.261076194@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
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
@@ -542,6 +542,11 @@ static inline spinlock_t *huge_pte_lockp
 
 void hugetlb_report_usage(struct seq_file *m, struct mm_struct *mm);
 
+static inline void hugetlb_count_init(struct mm_struct *mm)
+{
+	atomic_long_set(&mm->hugetlb_usage, 0);
+}
+
 static inline void hugetlb_count_add(long l, struct mm_struct *mm)
 {
 	atomic_long_add(l, &mm->hugetlb_usage);
@@ -711,6 +716,10 @@ static inline spinlock_t *huge_pte_lockp
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
@@ -1028,6 +1028,7 @@ static struct mm_struct *mm_init(struct
 	mm->pmd_huge_pte = NULL;
 #endif
 	mm_init_uprobes_state(mm);
+	hugetlb_count_init(mm);
 
 	if (current->mm) {
 		mm->flags = current->mm->flags & MMF_INIT_MASK;


