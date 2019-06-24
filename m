Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C12450B65
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 15:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730538AbfFXNDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 09:03:11 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:28307 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729130AbfFXNDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jun 2019 09:03:11 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Mon, 24 Jun 2019 06:03:08 -0700
Received: from akaher-lnx-dev.eng.vmware.com (unknown [10.110.19.203])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 69A894135D;
        Mon, 24 Jun 2019 06:03:03 -0700 (PDT)
From:   Ajay Kaher <akaher@vmware.com>
To:     <aarcange@redhat.com>, <jannh@google.com>, <oleg@redhat.com>,
        <peterx@redhat.com>, <rppt@linux.ibm.com>, <jgg@mellanox.com>,
        <mhocko@suse.com>
CC:     <jglisse@redhat.com>, <akpm@linux-foundation.org>,
        <mike.kravetz@oracle.com>, <viro@zeniv.linux.org.uk>,
        <riandrews@android.com>, <arve@android.com>,
        <yishaih@mellanox.com>, <dledford@redhat.com>,
        <sean.hefty@intel.com>, <hal.rosenstock@gmail.com>,
        <matanb@mellanox.com>, <leonro@mellanox.com>,
        <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@driverdev.osuosl.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <akaher@vmware.com>, <srivatsab@vmware.com>,
        <amakhalov@vmware.com>, Hugh Dickins <hughd@google.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v4 3/3] [v4.9.y] coredump: fix race condition between mmget_not_zero()/get_task_mm() and core dumping
Date:   Tue, 25 Jun 2019 02:33:05 +0530
Message-ID: <1561410186-3919-3-git-send-email-akaher@vmware.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561410186-3919-1-git-send-email-akaher@vmware.com>
References: <1561410186-3919-1-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: akaher@vmware.com does not
 designate permitted sender hosts)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Arcangeli <aarcange@redhat.com>

coredump: fix race condition between collapse_huge_page() and core dumping

commit 59ea6d06cfa9247b586a695c21f94afa7183af74 upstream.

When fixing the race conditions between the coredump and the mmap_sem
holders outside the context of the process, we focused on
mmget_not_zero()/get_task_mm() callers in 04f5866e41fb70 ("coredump: fix
race condition between mmget_not_zero()/get_task_mm() and core
dumping"), but those aren't the only cases where the mmap_sem can be
taken outside of the context of the process as Michal Hocko noticed
while backporting that commit to older -stable kernels.

If mmgrab() is called in the context of the process, but then the
mm_count reference is transferred outside the context of the process,
that can also be a problem if the mmap_sem has to be taken for writing
through that mm_count reference.

khugepaged registration calls mmgrab() in the context of the process,
but the mmap_sem for writing is taken later in the context of the
khugepaged kernel thread.

collapse_huge_page() after taking the mmap_sem for writing doesn't
modify any vma, so it's not obvious that it could cause a problem to the
coredump, but it happens to modify the pmd in a way that breaks an
invariant that pmd_trans_huge_lock() relies upon.  collapse_huge_page()
needs the mmap_sem for writing just to block concurrent page faults that
call pmd_trans_huge_lock().

Specifically the invariant that "!pmd_trans_huge()" cannot become a
"pmd_trans_huge()" doesn't hold while collapse_huge_page() runs.

The coredump will call __get_user_pages() without mmap_sem for reading,
which eventually can invoke a lockless page fault which will need a
functional pmd_trans_huge_lock().

So collapse_huge_page() needs to use mmget_still_valid() to check it's
not running concurrently with the coredump...  as long as the coredump
can invoke page faults without holding the mmap_sem for reading.

This has "Fixes: khugepaged" to facilitate backporting, but in my view
it's more a bug in the coredump code that will eventually have to be
rewritten to stop invoking page faults without the mmap_sem for reading.
So the long term plan is still to drop all mmget_still_valid().

Link: http://lkml.kernel.org/r/20190607161558.32104-1-aarcange@redhat.com
Fixes: ba76149f47d8 ("thp: khugepaged")
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[Ajay: Just adjusted to apply on v4.9]
Signed-off-by: Ajay Kaher <akaher@vmware.com>
---
 include/linux/mm.h | 4 ++++
 mm/khugepaged.c    | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c239984..8852158 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1194,6 +1194,10 @@ void unmap_vmas(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
  * followed by taking the mmap_sem for writing before modifying the
  * vmas or anything the coredump pretends not to change from under it.
  *
+ * It also has to be called when mmgrab() is used in the context of
+ * the process, but then the mm_count refcount is transferred outside
+ * the context of the process to run down_write() on that pinned mm.
+ *
  * NOTE: find_extend_vma() called from GUP context is the only place
  * that can modify the "mm" (notably the vm_start/end) under mmap_sem
  * for reading and outside the context of the process, so it is also
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e0cfc3a..8217ee5 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1004,6 +1004,9 @@ static void collapse_huge_page(struct mm_struct *mm,
 	 * handled by the anon_vma lock + PG_lock.
 	 */
 	down_write(&mm->mmap_sem);
+	result = SCAN_ANY_PROCESS;
+	if (!mmget_still_valid(mm))
+		goto out;
 	result = hugepage_vma_revalidate(mm, address, &vma);
 	if (result)
 		goto out;
-- 
2.7.4

