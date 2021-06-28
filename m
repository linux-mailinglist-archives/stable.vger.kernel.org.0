Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDCBC3B6044
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbhF1OXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:23:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233185AbhF1OWS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:22:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BFF061C96;
        Mon, 28 Jun 2021 14:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889977;
        bh=KVS/7tMs5yvTC6JGk7bFZ9UO3XIuOrrUq7aPBjqrQgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cZBDkcG7HFAavcb2BfvolreK/Y94x6tyRdvKyfkDwqbuygsZ0xqMmRxu96LAVJvA2
         hFAQxGs38X6Fl9+xlfhJHfydi0RsJPBjF7tdAqVfQ3n2QTrZAK017NUABaD/Q9CMNj
         82rhOf3Jpm8dd+TiQ15DFHl21Ybcd/fyWAt2cEZ6INgi504MW/YA72NrjLD+tkQvi5
         aBWtebV2Uu+EKwuJmXarPH9brTQKyr7d/ylcr5cq8a4V0NEZB+0IRPTp5ziarlclBq
         +LbpeeP1TA3kCXgvUS3F1Ce7NjvtgRHUOWqlDyrsDh9YF/wb8w7RmLfIztYcclbQ94
         yKtGgHfH0J/ZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Mladek <pmladek@suse.com>, Martin Liu <liumartin@google.com>,
        jenhaochen@google.com, Minchan Kim <minchan@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.12 078/110] kthread: prevent deadlock when kthread_mod_delayed_work() races with kthread_cancel_delayed_work_sync()
Date:   Mon, 28 Jun 2021 10:17:56 -0400
Message-Id: <20210628141828.31757-79-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Mladek <pmladek@suse.com>

commit 5fa54346caf67b4b1b10b1f390316ae466da4d53 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kthread.c | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index fc7536079f7e..4fdf2bd9b558 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -1119,8 +1119,11 @@ static void kthread_cancel_delayed_work_timer(struct kthread_work *work,
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
@@ -1128,13 +1131,8 @@ static void kthread_cancel_delayed_work_timer(struct kthread_work *work,
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
@@ -1187,11 +1185,23 @@ bool kthread_mod_delayed_work(struct kthread_worker *worker,
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
@@ -1213,7 +1223,10 @@ static bool __kthread_cancel_work_sync(struct kthread_work *work, bool is_dwork)
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
2.30.2

