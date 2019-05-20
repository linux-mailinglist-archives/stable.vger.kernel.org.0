Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAD71235CF
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733055AbfETMjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:39:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390859AbfETMeP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:34:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 398CA216FD;
        Mon, 20 May 2019 12:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355654;
        bh=hC8xqWDPooGd/pURwxKcAJOcYzqQXTNT+ssNMs/ZMJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LTql7Euue/tXRIhI+ETdQpg9EOs4b8Dk3wB6DTAdYp6nJtGHRKSiETcGwpGLEzFU0
         TTY7jrSzKKJ5GYxGL9dN+tyfoTmzQhTQA4IZXRueetHrm8soomJVp96/Mz4/J6qA7M
         lluznZj56k06rD2tlhXzDEzW2EQbi6ydhjG7o/7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        zhong jiang <zhongjiang@huawei.com>,
        syzbot+cbb52e396df3e565ab02@syzkaller.appspotmail.com,
        Oleg Nesterov <oleg@redhat.com>, Jann Horn <jannh@google.com>,
        Hugh Dickins <hughd@google.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Peter Xu <peterx@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.1 074/128] userfaultfd: use RCU to free the task struct when fork fails
Date:   Mon, 20 May 2019 14:14:21 +0200
Message-Id: <20190520115254.758250607@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Arcangeli <aarcange@redhat.com>

commit c3f3ce049f7d97cc7ec9c01cb51d9ec74e0f37c2 upstream.

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
is enough to make the rcu_read_lock hold in get_mem_cgroup_from_mm()
(left side above) effective to avoid a use after free when dereferencing
the task structure.

An alternate possible fix would be to defer the delivery of the
userfaultfd contexts to the monitor until after fork() is guaranteed to
succeed.  Such a change would require more changes because it would
create a strict ordering dependency where the uffd methods would need to
be called beyond the last potentially failing branch in order to be
safe.  This solution as opposed only adds the dependency to common code
to set mm->owner to NULL and to free the task struct that was pointed by
mm->owner with RCU, if fork ends up failing.  The userfaultfd methods
can still be called anywhere during the fork runtime and the monitor
will keep discarding orphaned "mm" coming from failed forks in userland.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/fork.c |   31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -952,6 +952,15 @@ static void mm_init_aio(struct mm_struct
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
@@ -1331,6 +1340,7 @@ static struct mm_struct *dup_mm(struct t
 free_pt:
 	/* don't put binfmt in mmput, we haven't got module yet */
 	mm->binfmt = NULL;
+	mm_init_owner(mm, NULL);
 	mmput(mm);
 
 fail_nomem:
@@ -1662,6 +1672,21 @@ static inline void rcu_copy_process(stru
 #endif /* #ifdef CONFIG_TASKS_RCU */
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
@@ -2123,8 +2148,10 @@ bad_fork_cleanup_io:
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
@@ -2155,7 +2182,7 @@ bad_fork_cleanup_count:
 bad_fork_free:
 	p->state = TASK_DEAD;
 	put_task_stack(p);
-	free_task(p);
+	delayed_free_task(p);
 fork_out:
 	spin_lock_irq(&current->sighand->siglock);
 	hlist_del_init(&delayed.node);


