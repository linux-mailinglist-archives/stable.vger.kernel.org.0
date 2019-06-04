Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 725D434383
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 11:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbfFDJuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 05:50:25 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51284 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727027AbfFDJuZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 05:50:25 -0400
Received: by mail-wm1-f68.google.com with SMTP id f10so14159536wmb.1;
        Tue, 04 Jun 2019 02:50:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XGNv0OSnomtJgkMDSycA6r4cSqqSMDzWgJ1t4jYNTbw=;
        b=h6j7mOtE4f5NJsin6OHtk24tLebrFOEdTIgFSHL2+CBzYtUCKZE5iUuQXimXbQzWbH
         4JyQljGNsdd87aDOTC2XLXv8KpYgnlBrKsybUs1jr0MBRUGwTtVtEYBNwVgo7TEqO9PZ
         3jw8BCZhuBbDzqt9xp88NXdPIfAkr9KfjsV5H5Zo46LadgD3Dgx8U7HrgRBKYxRmNSdy
         1ujBnNuZqtTb5nD/zcxxkdfggG1I0grX15SFzCGLrZNpEnYzBm7BHK/C/MLmPPYz86xv
         zZ8C+5S8IG+C/6W40qDAvL1gfKDkgjbdDo6eb8vw4xhknjbgDNr9P49o33B1LNktSn6d
         rSXg==
X-Gm-Message-State: APjAAAVQjh5dB9aUsYo6kwmSYWo6Vy63mTxpgDmZ+DUeE/O8eZyejcdf
        ldt2x32sO/3GUJm78dht83nMdkGy
X-Google-Smtp-Source: APXvYqx8c1t9iWf88iRpzzASYshZ+t070LyNHU/jb8WuYE3oIPg/yFwLY/qHKXXK36mrZP1Y2LLn+Q==
X-Received: by 2002:a1c:c003:: with SMTP id q3mr17505639wmf.42.1559641820952;
        Tue, 04 Jun 2019 02:50:20 -0700 (PDT)
Received: from tiehlicka.suse.cz (ip-37-188-163-245.eurotel.cz. [37.188.163.245])
        by smtp.gmail.com with ESMTPSA id k66sm6020531wmb.34.2019.06.04.02.50.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 04 Jun 2019 02:50:19 -0700 (PDT)
From:   Michal Hocko <mhocko@kernel.org>
To:     Stable tree <stable@vger.kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [RFC PATCH stable-4.4] coredump: fix race condition between mmget_not_zero()/get_task_mm() and core dumping
Date:   Tue,  4 Jun 2019 11:49:53 +0200
Message-Id: <20190604094953.26688-1-mhocko@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Arcangeli <aarcange@redhat.com>

Upstream 04f5866e41fb70690e28397487d8bd8eea7d712a commit.

The core dumping code has always run without holding the mmap_sem for
writing, despite that is the only way to ensure that the entire vma
layout will not change from under it.  Only using some signal
serialization on the processes belonging to the mm is not nearly enough.
This was pointed out earlier.  For example in Hugh's post from Jul 2017:

  https://lkml.kernel.org/r/alpine.LSU.2.11.1707191716030.2055@eggly.anvils

  "Not strictly relevant here, but a related note: I was very surprised
   to discover, only quite recently, how handle_mm_fault() may be called
   without down_read(mmap_sem) - when core dumping. That seems a
   misguided optimization to me, which would also be nice to correct"

In particular because the growsdown and growsup can move the
vm_start/vm_end the various loops the core dump does around the vma will
not be consistent if page faults can happen concurrently.

Pretty much all users calling mmget_not_zero()/get_task_mm() and then
taking the mmap_sem had the potential to introduce unexpected side
effects in the core dumping code.

Adding mmap_sem for writing around the ->core_dump invocation is a
viable long term fix, but it requires removing all copy user and page
faults and to replace them with get_dump_page() for all binary formats
which is not suitable as a short term fix.

For the time being this solution manually covers the places that can
confuse the core dump either by altering the vma layout or the vma flags
while it runs.  Once ->core_dump runs under mmap_sem for writing the
function mmget_still_valid() can be dropped.

Allowing mmap_sem protected sections to run in parallel with the
coredump provides some minor parallelism advantage to the swapoff code
(which seems to be safe enough by never mangling any vma field and can
keep doing swapins in parallel to the core dumping) and to some other
corner case.

In order to facilitate the backporting I added "Fixes: 86039bd3b4e6"
however the side effect of this same race condition in /proc/pid/mem
should be reproducible since before 2.6.12-rc2 so I couldn't add any
other "Fixes:" because there's no hash beyond the git genesis commit.

Because find_extend_vma() is the only location outside of the process
context that could modify the "mm" structures under mmap_sem for
reading, by adding the mmget_still_valid() check to it, all other cases
that take the mmap_sem for reading don't need the new check after
mmget_not_zero()/get_task_mm().  The expand_stack() in page fault
context also doesn't need the new check, because all tasks under core
dumping are frozen.

Link: http://lkml.kernel.org/r/20190325224949.11068-1-aarcange@redhat.com
Fixes: 86039bd3b4e6 ("userfaultfd: add new syscall to provide memory externalization")
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Jann Horn <jannh@google.com>
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Jann Horn <jannh@google.com>
Acked-by: Jason Gunthorpe <jgg@mellanox.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
[mhocko@suse.com: stable 4.4 backport
 - drop infiniband part because of missing 5f9794dc94f59
 - drop userfaultfd_event_wait_completion hunk because of
   missing 9cd75c3cd4c3d]
 - handle binder_update_page_range because of missing 720c241924046
 - add check to collapse_huge_page
]
Signed-off-by: Michal Hocko <mhocko@suse.com>
---
Hi,
this is based on the backport I have done for out 4.4 based distribution
kernel. Please double check that I haven't missed anything before
applying to the stable tree. I have also CCed Joel for the binder part
which is not in the current upstream anymore but I believe it needs the
check as well.

Review feedback welcome.

 drivers/android/binder.c |  6 ++++++
 fs/proc/task_mmu.c       | 18 ++++++++++++++++++
 fs/userfaultfd.c         | 10 ++++++++--
 include/linux/mm.h       | 21 +++++++++++++++++++++
 mm/huge_memory.c         |  2 +-
 mm/mmap.c                |  7 ++++++-
 6 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 260ce0e60187..1fb1cddbd19a 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -570,6 +570,12 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
 
 	if (mm) {
 		down_write(&mm->mmap_sem);
+		if (!mmget_still_valid(mm)) {
+			if (allocate == 0)
+				goto free_range;
+			goto err_no_vma;
+		}
+
 		vma = proc->vma;
 		if (vma && mm != proc->vma_vm_mm) {
 			pr_err("%d: vma mm and task mm mismatch\n",
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 75691a20313c..ad1ccdcef74e 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -947,6 +947,24 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 					continue;
 				up_read(&mm->mmap_sem);
 				down_write(&mm->mmap_sem);
+				/*
+				 * Avoid to modify vma->vm_flags
+				 * without locked ops while the
+				 * coredump reads the vm_flags.
+				 */
+				if (!mmget_still_valid(mm)) {
+					/*
+					 * Silently return "count"
+					 * like if get_task_mm()
+					 * failed. FIXME: should this
+					 * function have returned
+					 * -ESRCH if get_task_mm()
+					 * failed like if
+					 * get_proc_task() fails?
+					 */
+					up_write(&mm->mmap_sem);
+					goto out_mm;
+				}
 				for (vma = mm->mmap; vma; vma = vma->vm_next) {
 					vma->vm_flags &= ~VM_SOFTDIRTY;
 					vma_set_page_prot(vma);
diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 59d58bdad7d3..4053de7b7064 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -443,6 +443,8 @@ static int userfaultfd_release(struct inode *inode, struct file *file)
 	 * taking the mmap_sem for writing.
 	 */
 	down_write(&mm->mmap_sem);
+	if (!mmget_still_valid(mm))
+		goto skip_mm;
 	prev = NULL;
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		cond_resched();
@@ -465,6 +467,7 @@ static int userfaultfd_release(struct inode *inode, struct file *file)
 		vma->vm_flags = new_flags;
 		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
 	}
+skip_mm:
 	up_write(&mm->mmap_sem);
 
 	/*
@@ -761,9 +764,10 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 	end = start + uffdio_register.range.len;
 
 	down_write(&mm->mmap_sem);
-	vma = find_vma_prev(mm, start, &prev);
-
 	ret = -ENOMEM;
+	if (!mmget_still_valid(mm))
+		goto out_unlock;
+	vma = find_vma_prev(mm, start, &prev);
 	if (!vma)
 		goto out_unlock;
 
@@ -903,6 +907,8 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
 	end = start + uffdio_unregister.len;
 
 	down_write(&mm->mmap_sem);
+	if (!mmget_still_valid(mm))
+		goto out_unlock;
 	vma = find_vma_prev(mm, start, &prev);
 
 	ret = -ENOMEM;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 251adf4d8a71..ed653ba47c46 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1098,6 +1098,27 @@ void zap_page_range(struct vm_area_struct *vma, unsigned long address,
 void unmap_vmas(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
 		unsigned long start, unsigned long end);
 
+/*
+ * This has to be called after a get_task_mm()/mmget_not_zero()
+ * followed by taking the mmap_sem for writing before modifying the
+ * vmas or anything the coredump pretends not to change from under it.
+ *
+ * NOTE: find_extend_vma() called from GUP context is the only place
+ * that can modify the "mm" (notably the vm_start/end) under mmap_sem
+ * for reading and outside the context of the process, so it is also
+ * the only case that holds the mmap_sem for reading that must call
+ * this function. Generally if the mmap_sem is hold for reading
+ * there's no need of this check after get_task_mm()/mmget_not_zero().
+ *
+ * This function can be obsoleted and the check can be removed, after
+ * the coredump code will hold the mmap_sem for writing before
+ * invoking the ->core_dump methods.
+ */
+static inline bool mmget_still_valid(struct mm_struct *mm)
+{
+	return likely(!mm->core_state);
+}
+
 /**
  * mm_walk - callbacks for walk_page_range
  * @pmd_entry: if set, called for each non-empty PMD (3rd-level) entry
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 465786cd6490..281fde7b62d2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2587,7 +2587,7 @@ static void collapse_huge_page(struct mm_struct *mm,
 	 * handled by the anon_vma lock + PG_lock.
 	 */
 	down_write(&mm->mmap_sem);
-	if (unlikely(khugepaged_test_exit(mm)))
+	if (unlikely(khugepaged_test_exit(mm) || mmget_still_valid(mm)))
 		goto out;
 
 	vma = find_vma(mm, address);
diff --git a/mm/mmap.c b/mm/mmap.c
index baa4c1280bff..a24e42477001 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -42,6 +42,7 @@
 #include <linux/memory.h>
 #include <linux/printk.h>
 #include <linux/userfaultfd_k.h>
+#include <linux/mm.h>
 
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
@@ -2398,7 +2399,8 @@ find_extend_vma(struct mm_struct *mm, unsigned long addr)
 	vma = find_vma_prev(mm, addr, &prev);
 	if (vma && (vma->vm_start <= addr))
 		return vma;
-	if (!prev || expand_stack(prev, addr))
+	/* don't alter vm_end if the coredump is running */
+	if (!prev || !mmget_still_valid(mm) || expand_stack(prev, addr))
 		return NULL;
 	if (prev->vm_flags & VM_LOCKED)
 		populate_vma_page_range(prev, addr, prev->vm_end, NULL);
@@ -2424,6 +2426,9 @@ find_extend_vma(struct mm_struct *mm, unsigned long addr)
 		return vma;
 	if (!(vma->vm_flags & VM_GROWSDOWN))
 		return NULL;
+	/* don't alter vm_start if the coredump is running */
+	if (!mmget_still_valid(mm))
+		return NULL;
 	start = vma->vm_start;
 	if (expand_stack(vma, addr))
 		return NULL;
-- 
2.20.1

