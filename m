Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2CE21E539
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 00:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfENWkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 18:40:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbfENWkt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 18:40:49 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5700320873;
        Tue, 14 May 2019 22:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557873647;
        bh=jrMSV+j6sJroPnlFDZCfz6fSoaJX59efEzNHIq6kCM4=;
        h=Date:From:To:Subject:From;
        b=mNbl34NsidTvBNivFsMuDGEtLIJPZFrHlc8OWM0yOIrXhgPgM5l+Kh8vDcmcLz8HL
         2RT57ijOezYD3OM8Dfkol8j7ulYzidk5KxbNIJ6VsogT5mksy4kO9w/QEBn78L5Ez+
         YUg/WlYF+uC7Q9mTf5LxaLIu7pG90iwEsUH0MxGY=
Date:   Tue, 14 May 2019 15:40:46 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, akpm@linux-foundation.org, hughd@google.com,
        jannh@google.com, jgg@mellanox.com,
        kirill.shutemov@linux.intel.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        oleg@redhat.com, peterx@redhat.com, rppt@linux.vnet.ibm.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        zhongjiang@huawei.com
Subject:  [patch 002/126] userfaultfd: use RCU to free the task
 struct when fork fails
Message-ID: <20190514224046.PuG0ahnFz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: use RCU to free the task struct when fork fails

The task structure is freed while get_mem_cgroup_from_mm() holds
rcu_read_lock() and dereferences mm->owner.

get_mem_cgroup_from_mm()                failing fork()
----                                    ---
task = mm->owner
                                        mm->owner = NULL;
                                        free(task)
if (task) *task; /* use after free */

The fix consists in freeing the task with RCU also in the fork failure
case, exactly like it always happens for the regular exit(2) path.  That
is enough to make the rcu_read_lock hold in get_mem_cgroup_from_mm() (left
side above) effective to avoid a use after free when dereferencing the
task structure.

An alternate possible fix would be to defer the delivery of the
userfaultfd contexts to the monitor until after fork() is guaranteed to
succeed.  Such a change would require more changes because it would create
a strict ordering dependency where the uffd methods would need to be
called beyond the last potentially failing branch in order to be safe. 
This solution as opposed only adds the dependency to common code to set
mm->owner to NULL and to free the task struct that was pointed by
mm->owner with RCU, if fork ends up failing.  The userfaultfd methods can
still be called anywhere during the fork runtime and the monitor will keep
discarding orphaned "mm" coming from failed forks in userland.

This race condition couldn't trigger if CONFIG_MEMCG was set =n at build
time.

[aarcange@redhat.com: improve changelog, reduce #ifdefs per Michal]
  Link: http://lkml.kernel.org/r/20190429035752.4508-1-aarcange@redhat.com
Link: http://lkml.kernel.org/r/20190325225636.11635-2-aarcange@redhat.com
Fixes: 893e26e61d04 ("userfaultfd: non-cooperative: Add fork() event")
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Tested-by: zhong jiang <zhongjiang@huawei.com>
Reported-by: syzbot+cbb52e396df3e565ab02@syzkaller.appspotmail.com
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: zhong jiang <zhongjiang@huawei.com>
Cc: syzbot+cbb52e396df3e565ab02@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

--- a/kernel/fork.c~userfaultfd-use-rcu-to-free-the-task-struct-when-fork-fails
+++ a/kernel/fork.c
@@ -955,6 +955,15 @@ static void mm_init_aio(struct mm_struct
 #endif
 }
 
+static __always_inline void mm_clear_owner(struct mm_struct *mm,
+					   struct task_struct *p)
+{
+#ifdef CONFIG_MEMCG
+	if (mm->owner == p)
+		WRITE_ONCE(mm->owner, NULL);
+#endif
+}
+
 static void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
 {
 #ifdef CONFIG_MEMCG
@@ -1343,6 +1352,7 @@ static struct mm_struct *dup_mm(struct t
 free_pt:
 	/* don't put binfmt in mmput, we haven't got module yet */
 	mm->binfmt = NULL;
+	mm_init_owner(mm, NULL);
 	mmput(mm);
 
 fail_nomem:
@@ -1726,6 +1736,21 @@ static int pidfd_create(struct pid *pid)
 	return fd;
 }
 
+static void __delayed_free_task(struct rcu_head *rhp)
+{
+	struct task_struct *tsk = container_of(rhp, struct task_struct, rcu);
+
+	free_task(tsk);
+}
+
+static __always_inline void delayed_free_task(struct task_struct *tsk)
+{
+	if (IS_ENABLED(CONFIG_MEMCG))
+		call_rcu(&tsk->rcu, __delayed_free_task);
+	else
+		free_task(tsk);
+}
+
 /*
  * This creates a new process as a copy of the old one,
  * but does not actually start it yet.
@@ -2233,8 +2258,10 @@ bad_fork_cleanup_io:
 bad_fork_cleanup_namespaces:
 	exit_task_namespaces(p);
 bad_fork_cleanup_mm:
-	if (p->mm)
+	if (p->mm) {
+		mm_clear_owner(p->mm, p);
 		mmput(p->mm);
+	}
 bad_fork_cleanup_signal:
 	if (!(clone_flags & CLONE_THREAD))
 		free_signal_struct(p->signal);
@@ -2265,7 +2292,7 @@ bad_fork_cleanup_count:
 bad_fork_free:
 	p->state = TASK_DEAD;
 	put_task_stack(p);
-	free_task(p);
+	delayed_free_task(p);
 fork_out:
 	spin_lock_irq(&current->sighand->siglock);
 	hlist_del_init(&delayed.node);
_
