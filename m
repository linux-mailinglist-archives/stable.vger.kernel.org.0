Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711EA3B810B
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 13:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbhF3LE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 07:04:56 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:55204 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234148AbhF3LEz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 07:04:55 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 803191FE6A;
        Wed, 30 Jun 2021 11:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625050940; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mFIBs+f5hnPcq8COTn/0n4Gy7wRSa6VQ95lQBkwb+4k=;
        b=mHsvLJ5+aU+5mTGdv6H8Q3l/paa8zbRD7sHieUG+e+n4jczVLYQo/c7tVkOirEJCwlAb0H
        maOXAfA6KFa6CjqJu4AZPsfj0v1eOYuBOKJybpmp9UC7wHW/qOMPzX9nWFZQV63rDVlZPB
        o/txy5nxd0UC/vElnBFsNWmUr8Ogots=
Received: from alley.suse.cz (unknown [10.100.224.162])
        by relay2.suse.de (Postfix) with ESMTP id 3F90BA3B88;
        Wed, 30 Jun 2021 11:02:20 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        jenhaochen@google.com, liumartin@google.com, minchan@google.com,
        nathan@kernel.org, ndesaulniers@google.com, oleg@redhat.com,
        tj@kernel.org, torvalds@linux-foundation.org,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH 2/2] kthread: prevent deadlock when kthread_mod_delayed_work() races with kthread_cancel_delayed_work_sync()
Date:   Wed, 30 Jun 2021 13:01:49 +0200
Message-Id: <20210630110149.25086-3-pmladek@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210630110149.25086-1-pmladek@suse.com>
References: <162480383515619@kroah.com>
 <20210630110149.25086-1-pmladek@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The system might hang with the following backtrace:

	schedule+0x80/0x100
	schedule_timeout+0x48/0x138
	wait_for_common+0xa4/0x134
	wait_for_completion+0x1c/0x2c
	kthread_flush_work+0x114/0x1cc
	kthread_cancel_work_sync.llvm.16514401384283632983+0xe8/0x144
	kthread_cancel_delayed_work_sync+0x18/0x2c
	xxxx_pm_notify+0xb0/0xd8
	blocking_notifier_call_chain_robust+0x80/0x194
	pm_notifier_call_chain_robust+0x28/0x4c
	suspend_prepare+0x40/0x260
	enter_state+0x80/0x3f4
	pm_suspend+0x60/0xdc
	state_store+0x108/0x144
	kobj_attr_store+0x38/0x88
	sysfs_kf_write+0x64/0xc0
	kernfs_fop_write_iter+0x108/0x1d0
	vfs_write+0x2f4/0x368
	ksys_write+0x7c/0xec

It is caused by the following race between kthread_mod_delayed_work()
and kthread_cancel_delayed_work_sync():

CPU0				CPU1

Context: Thread A		Context: Thread B

kthread_mod_delayed_work()
  spin_lock()
  __kthread_cancel_work()
     spin_unlock()
     del_timer_sync()
				kthread_cancel_delayed_work_sync()
				  spin_lock()
				  __kthread_cancel_work()
				    spin_unlock()
				    del_timer_sync()
				    spin_lock()

				  work->canceling++
				  spin_unlock
     spin_lock()
   queue_delayed_work()
     // dwork is put into the worker->delayed_work_list

   spin_unlock()

				  kthread_flush_work()
     // flush_work is put at the tail of the dwork

				    wait_for_completion()

Context: IRQ

  kthread_delayed_work_timer_fn()
    spin_lock()
    list_del_init(&work->node);
    spin_unlock()

BANG: flush_work is not longer linked and will never get proceed.

The problem is that kthread_mod_delayed_work() checks work->canceling
flag before canceling the timer.

A simple solution is to (re)check work->canceling after
__kthread_cancel_work().  But then it is not clear what should be
returned when __kthread_cancel_work() removed the work from the queue
(list) and it can't queue it again with the new @delay.

The return value might be used for reference counting.  The caller has
to know whether a new work has been queued or an existing one was
replaced.

The proper solution is that kthread_mod_delayed_work() will remove the
work from the queue (list) _only_ when work->canceling is not set.  The
flag must be checked after the timer is stopped and the remaining
operations can be done under worker->lock.

Note that kthread_mod_delayed_work() could remove the timer and then
bail out.  It is fine.  The other canceling caller needs to cancel the
timer as well.  The important thing is that the queue (list)
manipulation is done atomically under worker->lock.

Link: https://lkml.kernel.org/r/20210610133051.15337-3-pmladek@suse.com
Fixes: 9a6b06c8d9a220860468a ("kthread: allow to modify delayed kthread work")
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reported-by: Martin Liu <liumartin@google.com>
Cc: <jenhaochen@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 kernel/kthread.c | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index b2688c39c6f1..9750f4f7f901 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -1037,8 +1037,11 @@ static void kthread_cancel_delayed_work_timer(struct kthread_work *work,
 }
 
 /*
- * This function removes the work from the worker queue. Also it makes sure
- * that it won't get queued later via the delayed work's timer.
+ * This function removes the work from the worker queue.
+ *
+ * It is called under worker->lock. The caller must make sure that
+ * the timer used by delayed work is not running, e.g. by calling
+ * kthread_cancel_delayed_work_timer().
  *
  * The work might still be in use when this function finishes. See the
  * current_work proceed by the worker.
@@ -1046,13 +1049,8 @@ static void kthread_cancel_delayed_work_timer(struct kthread_work *work,
  * Return: %true if @work was pending and successfully canceled,
  *	%false if @work was not pending
  */
-static bool __kthread_cancel_work(struct kthread_work *work, bool is_dwork,
-				  unsigned long *flags)
+static bool __kthread_cancel_work(struct kthread_work *work)
 {
-	/* Try to cancel the timer if exists. */
-	if (is_dwork)
-		kthread_cancel_delayed_work_timer(work, flags);
-
 	/*
 	 * Try to remove the work from a worker list. It might either
 	 * be from worker->work_list or from worker->delayed_work_list.
@@ -1105,11 +1103,23 @@ bool kthread_mod_delayed_work(struct kthread_worker *worker,
 	/* Work must not be used with >1 worker, see kthread_queue_work() */
 	WARN_ON_ONCE(work->worker != worker);
 
-	/* Do not fight with another command that is canceling this work. */
+	/*
+	 * Temporary cancel the work but do not fight with another command
+	 * that is canceling the work as well.
+	 *
+	 * It is a bit tricky because of possible races with another
+	 * mod_delayed_work() and cancel_delayed_work() callers.
+	 *
+	 * The timer must be canceled first because worker->lock is released
+	 * when doing so. But the work can be removed from the queue (list)
+	 * only when it can be queued again so that the return value can
+	 * be used for reference counting.
+	 */
+	kthread_cancel_delayed_work_timer(work, &flags);
 	if (work->canceling)
 		goto out;
+	ret = __kthread_cancel_work(work);
 
-	ret = __kthread_cancel_work(work, true, &flags);
 fast_queue:
 	__kthread_queue_delayed_work(worker, dwork, delay);
 out:
@@ -1131,7 +1141,10 @@ static bool __kthread_cancel_work_sync(struct kthread_work *work, bool is_dwork)
 	/* Work must not be used with >1 worker, see kthread_queue_work(). */
 	WARN_ON_ONCE(work->worker != worker);
 
-	ret = __kthread_cancel_work(work, is_dwork, &flags);
+	if (is_dwork)
+		kthread_cancel_delayed_work_timer(work, &flags);
+
+	ret = __kthread_cancel_work(work);
 
 	if (worker->current_work != work)
 		goto out_fast;
-- 
2.26.2

