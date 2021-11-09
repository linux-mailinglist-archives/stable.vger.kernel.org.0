Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256E244A77F
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 08:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241044AbhKIH0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 02:26:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:41290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240071AbhKIH0B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 02:26:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 563FE61165;
        Tue,  9 Nov 2021 07:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636442595;
        bh=FRY2NeBGnnZzYkxzAdi6/EjK3XgLR0VWkM9LRaCd/g4=;
        h=Subject:To:Cc:From:Date:From;
        b=jKGlbcBJZNQlKtFllYjeFw97QatT1DBsrXfctJcaiGJdulHLZGsvHaD+yj9rbG5Qf
         i+Sa21u+TEWSlouKasVEGPm6i3hpP334bdEJoYU70TMR/eTFvAWmiJ8TIbsotATdqh
         NT11rG+eH4qcxs2VJb1jItDLmDH1JPjeamjrAfIk=
Subject: FAILED: patch "[PATCH] binder: use euid from cred instead of using task" failed to apply to 4.19-stable tree
To:     tkjos@google.com, casey@schaufler-ca.com, jannh@google.com,
        paul@paul-moore.com, stephen.smalley.work@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 09 Nov 2021 08:23:03 +0100
Message-ID: <1636442583229101@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 29bc22ac5e5bc63275e850f0c8fc549e3d0e306b Mon Sep 17 00:00:00 2001
From: Todd Kjos <tkjos@google.com>
Date: Tue, 12 Oct 2021 09:56:12 -0700
Subject: [PATCH] binder: use euid from cred instead of using task

Save the 'struct cred' associated with a binder process
at initial open to avoid potential race conditions
when converting to an euid.

Set a transaction's sender_euid from the 'struct cred'
saved at binder_open() instead of looking up the euid
from the binder proc's 'struct task'. This ensures
the euid is associated with the security context that
of the task that opened binder.

Cc: stable@vger.kernel.org # 4.4+
Fixes: 457b9a6f09f0 ("Staging: android: add binder driver")
Signed-off-by: Todd Kjos <tkjos@google.com>
Suggested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Suggested-by: Jann Horn <jannh@google.com>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index d9030cb6b1e4..231cff9b3b75 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2702,7 +2702,7 @@ static void binder_transaction(struct binder_proc *proc,
 		t->from = thread;
 	else
 		t->from = NULL;
-	t->sender_euid = task_euid(proc->tsk);
+	t->sender_euid = proc->cred->euid;
 	t->to_proc = target_proc;
 	t->to_thread = target_thread;
 	t->code = tr->code;
@@ -4343,6 +4343,7 @@ static void binder_free_proc(struct binder_proc *proc)
 	}
 	binder_alloc_deferred_release(&proc->alloc);
 	put_task_struct(proc->tsk);
+	put_cred(proc->cred);
 	binder_stats_deleted(BINDER_STAT_PROC);
 	kfree(proc);
 }
@@ -5021,6 +5022,7 @@ static int binder_open(struct inode *nodp, struct file *filp)
 	spin_lock_init(&proc->outer_lock);
 	get_task_struct(current->group_leader);
 	proc->tsk = current->group_leader;
+	proc->cred = get_cred(filp->f_cred);
 	INIT_LIST_HEAD(&proc->todo);
 	init_waitqueue_head(&proc->freeze_wait);
 	proc->default_priority = task_nice(current);
diff --git a/drivers/android/binder_internal.h b/drivers/android/binder_internal.h
index 810c0b84d3f8..e7d4920b3368 100644
--- a/drivers/android/binder_internal.h
+++ b/drivers/android/binder_internal.h
@@ -364,6 +364,9 @@ struct binder_ref {
  *                        (invariant after initialized)
  * @tsk                   task_struct for group_leader of process
  *                        (invariant after initialized)
+ * @cred                  struct cred associated with the `struct file`
+ *                        in binder_open()
+ *                        (invariant after initialized)
  * @deferred_work_node:   element for binder_deferred_list
  *                        (protected by binder_deferred_lock)
  * @deferred_work:        bitmap of deferred work to perform
@@ -424,6 +427,7 @@ struct binder_proc {
 	struct list_head waiting_threads;
 	int pid;
 	struct task_struct *tsk;
+	const struct cred *cred;
 	struct hlist_node deferred_work_node;
 	int deferred_work;
 	int outstanding_txns;

