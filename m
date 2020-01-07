Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61A5E1331BE
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgAGVDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:03:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:45996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727652AbgAGVDi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:03:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12A522077B;
        Tue,  7 Jan 2020 21:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431017;
        bh=GRYJdEGuIdd2YyOwLqaW6WZ4KcT616LYXKdXQA3Ua44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QuJNm5cVKVjgoKS9ts9BMdq18MImMST03tD+7XVGJxG14oODeaUCdQvKAz7jRps/G
         3Kxk9Rs356jLJiZrT4NShCruCh14bo/PKN3Ele5jZeuePL5HaGT5tpyKav8iM94eby
         VbtXkOm3Sfl7DnJIdHluDfcZ0QIKk6NAduWsgCbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Davidlohr Bueso <dbueso@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 191/191] mm/hugetlb: defer freeing of huge pages if in non-task context
Date:   Tue,  7 Jan 2020 21:55:11 +0100
Message-Id: <20200107205343.209319955@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

[ Upstream commit c77c0a8ac4c522638a8242fcb9de9496e3cdbb2d ]

The following lockdep splat was observed when a certain hugetlbfs test
was run:

  ================================
  WARNING: inconsistent lock state
  4.18.0-159.el8.x86_64+debug #1 Tainted: G        W --------- -  -
  --------------------------------
  inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
  swapper/30/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
  ffffffff9acdc038 (hugetlb_lock){+.?.}, at: free_huge_page+0x36f/0xaa0
  {SOFTIRQ-ON-W} state was registered at:
    lock_acquire+0x14f/0x3b0
    _raw_spin_lock+0x30/0x70
    __nr_hugepages_store_common+0x11b/0xb30
    hugetlb_sysctl_handler_common+0x209/0x2d0
    proc_sys_call_handler+0x37f/0x450
    vfs_write+0x157/0x460
    ksys_write+0xb8/0x170
    do_syscall_64+0xa5/0x4d0
    entry_SYSCALL_64_after_hwframe+0x6a/0xdf
  irq event stamp: 691296
  hardirqs last  enabled at (691296): [<ffffffff99bb034b>] _raw_spin_unlock_irqrestore+0x4b/0x60
  hardirqs last disabled at (691295): [<ffffffff99bb0ad2>] _raw_spin_lock_irqsave+0x22/0x81
  softirqs last  enabled at (691284): [<ffffffff97ff0c63>] irq_enter+0xc3/0xe0
  softirqs last disabled at (691285): [<ffffffff97ff0ebe>] irq_exit+0x23e/0x2b0

  other info that might help us debug this:
   Possible unsafe locking scenario:

         CPU0
         ----
    lock(hugetlb_lock);
    <Interrupt>
      lock(hugetlb_lock);

   *** DEADLOCK ***
      :
  Call Trace:
   <IRQ>
   __lock_acquire+0x146b/0x48c0
   lock_acquire+0x14f/0x3b0
   _raw_spin_lock+0x30/0x70
   free_huge_page+0x36f/0xaa0
   bio_check_pages_dirty+0x2fc/0x5c0
   clone_endio+0x17f/0x670 [dm_mod]
   blk_update_request+0x276/0xe50
   scsi_end_request+0x7b/0x6a0
   scsi_io_completion+0x1c6/0x1570
   blk_done_softirq+0x22e/0x350
   __do_softirq+0x23d/0xad8
   irq_exit+0x23e/0x2b0
   do_IRQ+0x11a/0x200
   common_interrupt+0xf/0xf
   </IRQ>

Both the hugetbl_lock and the subpool lock can be acquired in
free_huge_page().  One way to solve the problem is to make both locks
irq-safe.  However, Mike Kravetz had learned that the hugetlb_lock is
held for a linear scan of ALL hugetlb pages during a cgroup reparentling
operation.  So it is just too long to have irq disabled unless we can
break hugetbl_lock down into finer-grained locks with shorter lock hold
times.

Another alternative is to defer the freeing to a workqueue job.  This
patch implements the deferred freeing by adding a free_hpage_workfn()
work function to do the actual freeing.  The free_huge_page() call in a
non-task context saves the page to be freed in the hpage_freelist linked
list in a lockless manner using the llist APIs.

The generic workqueue is used to process the work, but a dedicated
workqueue can be used instead if it is desirable to have the huge page
freed ASAP.

Thanks to Kirill Tkhai <ktkhai@virtuozzo.com> for suggesting the use of
llist APIs which simplfy the code.

Link: http://lkml.kernel.org/r/20191217170331.30893-1-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b45a95363a84..e0afd582ca01 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -27,6 +27,7 @@
 #include <linux/swapops.h>
 #include <linux/jhash.h>
 #include <linux/numa.h>
+#include <linux/llist.h>
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
@@ -1255,7 +1256,7 @@ static inline void ClearPageHugeTemporary(struct page *page)
 	page[2].mapping = NULL;
 }
 
-void free_huge_page(struct page *page)
+static void __free_huge_page(struct page *page)
 {
 	/*
 	 * Can't pass hstate in here because it is called from the
@@ -1318,6 +1319,54 @@ void free_huge_page(struct page *page)
 	spin_unlock(&hugetlb_lock);
 }
 
+/*
+ * As free_huge_page() can be called from a non-task context, we have
+ * to defer the actual freeing in a workqueue to prevent potential
+ * hugetlb_lock deadlock.
+ *
+ * free_hpage_workfn() locklessly retrieves the linked list of pages to
+ * be freed and frees them one-by-one. As the page->mapping pointer is
+ * going to be cleared in __free_huge_page() anyway, it is reused as the
+ * llist_node structure of a lockless linked list of huge pages to be freed.
+ */
+static LLIST_HEAD(hpage_freelist);
+
+static void free_hpage_workfn(struct work_struct *work)
+{
+	struct llist_node *node;
+	struct page *page;
+
+	node = llist_del_all(&hpage_freelist);
+
+	while (node) {
+		page = container_of((struct address_space **)node,
+				     struct page, mapping);
+		node = node->next;
+		__free_huge_page(page);
+	}
+}
+static DECLARE_WORK(free_hpage_work, free_hpage_workfn);
+
+void free_huge_page(struct page *page)
+{
+	/*
+	 * Defer freeing if in non-task context to avoid hugetlb_lock deadlock.
+	 */
+	if (!in_task()) {
+		/*
+		 * Only call schedule_work() if hpage_freelist is previously
+		 * empty. Otherwise, schedule_work() had been called but the
+		 * workfn hasn't retrieved the list yet.
+		 */
+		if (llist_add((struct llist_node *)&page->mapping,
+			      &hpage_freelist))
+			schedule_work(&free_hpage_work);
+		return;
+	}
+
+	__free_huge_page(page);
+}
+
 static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
 {
 	INIT_LIST_HEAD(&page->lru);
-- 
2.20.1



