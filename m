Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDF938D809
	for <lists+stable@lfdr.de>; Sun, 23 May 2021 02:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbhEWAnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 May 2021 20:43:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231451AbhEWAnR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 May 2021 20:43:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C0396115C;
        Sun, 23 May 2021 00:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621730510;
        bh=RTGHLSV0sRrbGVo6iU50bglxjdiC/YXcGUsQU7SqSVA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YKX61EtvunMNUwVyEZgkpDAsJb3OrAa2xKj6ffajRA95ln5VvFgreM6ykmYQcehzr
         ekg0THhdvxVuNvmykkOwWszf3EdlwyDxMaSftlEmfPYTEgeO8qTTOHDdAJKHQxg94D
         l+yORH8KAdrvQjYCXc+6Uyn6xbtrDEHcxFtWCW0o=
Date:   Sat, 22 May 2021 17:41:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, christian.brauner@ubuntu.com,
        dbueso@suse.de, ebiederm@xmission.com, linux-mm@kvack.org,
        manfred@colorfullife.com, matthias.vonfaber@aox-tech.de,
        mm-commits@vger.kernel.org, oleg@redhat.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        varad.gautam@suse.com
Subject:  [patch 03/10] ipc/mqueue, msg, sem: avoid relying on a
 stack reference past its expiry
Message-ID: <20210523004149.A5pCYgAYt%akpm@linux-foundation.org>
In-Reply-To: <20210522174113.47fd4c853c0a1470c57deefa@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Varad Gautam <varad.gautam@suse.com>
Subject: ipc/mqueue, msg, sem: avoid relying on a stack reference past its expiry

do_mq_timedreceive calls wq_sleep with a stack local address.  The sender
(do_mq_timedsend) uses this address to later call pipelined_send.

This leads to a very hard to trigger race where a do_mq_timedreceive call
might return and leave do_mq_timedsend to rely on an invalid address,
causing the following crash:

[  240.739977] RIP: 0010:wake_q_add_safe+0x13/0x60
[  240.739991] Call Trace:
[  240.739999]  __x64_sys_mq_timedsend+0x2a9/0x490
[  240.740003]  ? auditd_test_task+0x38/0x40
[  240.740007]  ? auditd_test_task+0x38/0x40
[  240.740011]  do_syscall_64+0x80/0x680
[  240.740017]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  240.740019] RIP: 0033:0x7f5928e40343

The race occurs as:

1. do_mq_timedreceive calls wq_sleep with the address of `struct
   ext_wait_queue` on function stack (aliased as `ewq_addr` here) - it
   holds a valid `struct ext_wait_queue *` as long as the stack has not
   been overwritten.

2. `ewq_addr` gets added to info->e_wait_q[RECV].list in wq_add, and
   do_mq_timedsend receives it via wq_get_first_waiter(info, RECV) to call
   __pipelined_op.

3. Sender calls __pipelined_op::smp_store_release(&this->state,
   STATE_READY).  Here is where the race window begins.  (`this` is
   `ewq_addr`.)

4. If the receiver wakes up now in do_mq_timedreceive::wq_sleep, it
   will see `state == STATE_READY` and break.

5. do_mq_timedreceive returns, and `ewq_addr` is no longer guaranteed
   to be a `struct ext_wait_queue *` since it was on do_mq_timedreceive's
   stack.  (Although the address may not get overwritten until another
   function happens to touch it, which means it can persist around for an
   indefinite time.)

6. do_mq_timedsend::__pipelined_op() still believes `ewq_addr` is a
   `struct ext_wait_queue *`, and uses it to find a task_struct to pass to
   the wake_q_add_safe call.  In the lucky case where nothing has
   overwritten `ewq_addr` yet, `ewq_addr->task` is the right task_struct. 
   In the unlucky case, __pipelined_op::wake_q_add_safe gets handed a
   bogus address as the receiver's task_struct causing the crash.

do_mq_timedsend::__pipelined_op() should not dereference `this` after
setting STATE_READY, as the receiver counterpart is now free to return. 
Change __pipelined_op to call wake_q_add_safe on the receiver's
task_struct returned by get_task_struct, instead of dereferencing `this`
which sits on the receiver's stack.

As Manfred pointed out, the race potentially also exists in
ipc/msg.c::expunge_all and ipc/sem.c::wake_up_sem_queue_prepare.  Fix
those in the same way.

Link: https://lkml.kernel.org/r/20210510102950.12551-1-varad.gautam@suse.com
Fixes: c5b2cbdbdac563 ("ipc/mqueue.c: update/document memory barriers")
Fixes: 8116b54e7e23ef ("ipc/sem.c: document and update memory barriers")
Fixes: 0d97a82ba830d8 ("ipc/msg.c: update and document memory barriers")
Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Reported-by: Matthias von Faber <matthias.vonfaber@aox-tech.de>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    6 ++++--
 ipc/msg.c    |    6 ++++--
 ipc/sem.c    |    6 ++++--
 3 files changed, 12 insertions(+), 6 deletions(-)

--- a/ipc/mqueue.c~ipc-mqueue-msg-sem-avoid-relying-on-a-stack-reference-past-its-expiry
+++ a/ipc/mqueue.c
@@ -1004,12 +1004,14 @@ static inline void __pipelined_op(struct
 				  struct mqueue_inode_info *info,
 				  struct ext_wait_queue *this)
 {
+	struct task_struct *task;
+
 	list_del(&this->list);
-	get_task_struct(this->task);
+	task = get_task_struct(this->task);
 
 	/* see MQ_BARRIER for purpose/pairing */
 	smp_store_release(&this->state, STATE_READY);
-	wake_q_add_safe(wake_q, this->task);
+	wake_q_add_safe(wake_q, task);
 }
 
 /* pipelined_send() - send a message directly to the task waiting in
--- a/ipc/msg.c~ipc-mqueue-msg-sem-avoid-relying-on-a-stack-reference-past-its-expiry
+++ a/ipc/msg.c
@@ -251,11 +251,13 @@ static void expunge_all(struct msg_queue
 	struct msg_receiver *msr, *t;
 
 	list_for_each_entry_safe(msr, t, &msq->q_receivers, r_list) {
-		get_task_struct(msr->r_tsk);
+		struct task_struct *r_tsk;
+
+		r_tsk = get_task_struct(msr->r_tsk);
 
 		/* see MSG_BARRIER for purpose/pairing */
 		smp_store_release(&msr->r_msg, ERR_PTR(res));
-		wake_q_add_safe(wake_q, msr->r_tsk);
+		wake_q_add_safe(wake_q, r_tsk);
 	}
 }
 
--- a/ipc/sem.c~ipc-mqueue-msg-sem-avoid-relying-on-a-stack-reference-past-its-expiry
+++ a/ipc/sem.c
@@ -784,12 +784,14 @@ would_block:
 static inline void wake_up_sem_queue_prepare(struct sem_queue *q, int error,
 					     struct wake_q_head *wake_q)
 {
-	get_task_struct(q->sleeper);
+	struct task_struct *sleeper;
+
+	sleeper = get_task_struct(q->sleeper);
 
 	/* see SEM_BARRIER_2 for purpose/pairing */
 	smp_store_release(&q->status, error);
 
-	wake_q_add_safe(wake_q, q->sleeper);
+	wake_q_add_safe(wake_q, sleeper);
 }
 
 static void unlink_queue(struct sem_array *sma, struct sem_queue *q)
_
