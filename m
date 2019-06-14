Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A10E1467B4
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 20:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbfFNSmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 14:42:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:34512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbfFNSmG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 14:42:06 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81A8221841;
        Fri, 14 Jun 2019 18:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560537725;
        bh=KvCBbaSfqp4klI6SvMn13j2vrcsewt30QIIXecxqo3o=;
        h=Date:From:To:Subject:From;
        b=SIEojztP5ArPpzWXXJTaNkec/qIUJSPP/ekWGJ7TtrgNony5W11shNn2dvMtj5NQC
         +hifW3LfeQVe1bfhB/QDhqoXuFEREGR+6BSM0NGqjpT+gTRLKzabzWDbIkDqSXZiYH
         sIpzAk6xgMnYH2B5dC310hA+/FIAxgB0rRNV76oc=
Date:   Fri, 14 Jun 2019 11:42:05 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, hughd@google.com, jannh@google.com,
        jgg@mellanox.com, kirill.shutemov@linux.intel.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        oleg@redhat.com, peterx@redhat.com, rppt@linux.vnet.ibm.com,
        stable@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?coredump-fix-race-condition-between-collapse=5Fhuge=5Fpag?=
 =?US-ASCII?Q?e-and-core-dumping.patch?= removed from -mm tree
Message-ID: <20190614184205.kjeQstXAI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: coredump: fix race condition between collapse_huge_page() and core dumping
has been removed from the -mm tree.  Its filename was
     coredump-fix-race-condition-between-collapse_huge_page-and-core-dumping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: coredump: fix race condition between collapse_huge_page() and core dumping

When fixing the race conditions between the coredump and the mmap_sem
holders outside the context of the process, we focused on
mmget_not_zero()/get_task_mm() callers in 04f5866e41fb70 ("coredump: fix
race condition between mmget_not_zero()/get_task_mm() and core dumping"),
but those aren't the only cases where the mmap_sem can be taken outside of
the context of the process as Michal Hocko noticed while backporting that
commit to older -stable kernels.

If mmgrab() is called in the context of the process, but then the mm_count
reference is transferred outside the context of the process, that can also
be a problem if the mmap_sem has to be taken for writing through that
mm_count reference.

khugepaged registration calls mmgrab() in the context of the process, but
the mmap_sem for writing is taken later in the context of the khugepaged
kernel thread.

collapse_huge_page() after taking the mmap_sem for writing doesn't modify
any vma, so it's not obvious that it could cause a problem to the
coredump, but it happens to modify the pmd in a way that breaks an
invariant that pmd_trans_huge_lock() relies upon.  collapse_huge_page()
needs the mmap_sem for writing just to block concurrent page faults that
call pmd_trans_huge_lock().

Specifically the invariant that "!pmd_trans_huge()" cannot become a
"pmd_trans_huge()" doesn't hold while collapse_huge_page() runs.

The coredump will call __get_user_pages() without mmap_sem for reading,
which eventually can invoke a lockless page fault which will need a
functional pmd_trans_huge_lock().

So collapse_huge_page() needs to use mmget_still_valid() to check it's not
running concurrently with the coredump...  as long as the coredump can
invoke page faults without holding the mmap_sem for reading.

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
---

 include/linux/sched/mm.h |    4 ++++
 mm/khugepaged.c          |    3 +++
 2 files changed, 7 insertions(+)

--- a/include/linux/sched/mm.h~coredump-fix-race-condition-between-collapse_huge_page-and-core-dumping
+++ a/include/linux/sched/mm.h
@@ -54,6 +54,10 @@ static inline void mmdrop(struct mm_stru
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
--- a/mm/khugepaged.c~coredump-fix-race-condition-between-collapse_huge_page-and-core-dumping
+++ a/mm/khugepaged.c
@@ -1004,6 +1004,9 @@ static void collapse_huge_page(struct mm
 	 * handled by the anon_vma lock + PG_lock.
 	 */
 	down_write(&mm->mmap_sem);
+	result = SCAN_ANY_PROCESS;
+	if (!mmget_still_valid(mm))
+		goto out;
 	result = hugepage_vma_revalidate(mm, address, &vma);
 	if (result)
 		goto out;
_

Patches currently in -mm which might be from aarcange@redhat.com are


