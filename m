Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D656C395B9
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 21:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbfFGTbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 15:31:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729081AbfFGTbg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 15:31:36 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6EE8208C0;
        Fri,  7 Jun 2019 19:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559935895;
        bh=Gw/usvqp0v9ko/hEk7q90tRdkSd9aS+WSEKpShrB/7s=;
        h=Date:From:To:Subject:From;
        b=M8UPI8gBdo+BaY6Z7cez3BbnwyK3VJajklphD7sarTKuG4JQ769VUOD9h8GUtfQvN
         gvjendSNK65PjAkKDi1NghVhV3C2tgVU7udAz3vuE7d2cO0u+ujVp2p5XBg42EOr/F
         egTJlVom+2LQ/6zIoiU8KeIpvJ7VvX66/xznPKuU=
Date:   Fri, 07 Jun 2019 12:31:34 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, hughd@google.com, jannh@google.com,
        jgg@mellanox.com, kirill.shutemov@linux.intel.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        oleg@redhat.com, peterx@redhat.com, rppt@linux.vnet.ibm.com,
        stable@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?coredump-fix-race-condition-between-collapse=5Fhuge=5Fpag?=
 =?US-ASCII?Q?e-and-core-dumping.patch?= added to -mm tree
Message-ID: <20190607193134.P_CPE0lVe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: coredump: fix race condition between collapse_huge_page() and core dumping
has been added to the -mm tree.  Its filename is
     coredump-fix-race-condition-between-collapse_huge_page-and-core-dumping.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/coredump-fix-race-condition-between-collapse_huge_page-and-core-dumping.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/coredump-fix-race-condition-between-collapse_huge_page-and-core-dumping.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
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

coredump-fix-race-condition-between-collapse_huge_page-and-core-dumping.patch

