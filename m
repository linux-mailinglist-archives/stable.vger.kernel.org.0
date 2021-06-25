Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2AFA3B3A89
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 03:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbhFYBmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 21:42:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232942AbhFYBmH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Jun 2021 21:42:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E69B6610A7;
        Fri, 25 Jun 2021 01:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624585186;
        bh=8aA8l0gUvl7gKVc+xnD7wWRrAJB4Gfj9ScpG9tt1Ikk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=et+frLiJ9+f0WRKF0I6mkc5u6tojPbOzXj6Z7Oy1u3NfZSfGIKTczShOr66XwLUEi
         XU29UABB99WEWSX7WPhsxnYUic45VjvQAhZGTSDCyEp7cfXbAB/hj+86S4sYnRzo5l
         SU4MnduFiEmQe73GC+//UQvuOP6jYL1PpDSIml3E=
Date:   Thu, 24 Jun 2021 18:39:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jenhaochen@google.com,
        linux-mm@kvack.org, liumartin@google.com, minchan@google.com,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, oleg@redhat.com, pmladek@suse.com,
        stable@vger.kernel.org, tj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 15/24] kthread_worker: split code for canceling
 the delayed work timer
Message-ID: <20210625013945.Wgs7ttT2t%akpm@linux-foundation.org>
In-Reply-To: <20210624183838.ac3161ca4a43989665ac8b2f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Mladek <pmladek@suse.com>
Subject: kthread_worker: split code for canceling the delayed work timer

Patch series "kthread_worker: Fix race between kthread_mod_delayed_work()
and kthread_cancel_delayed_work_sync()".

This patchset fixes the race between kthread_mod_delayed_work() and
kthread_cancel_delayed_work_sync() including proper return value handling.


This patch (of 2):

Simple code refactoring as a preparation step for fixing a race between
kthread_mod_delayed_work() and kthread_cancel_delayed_work_sync().

It does not modify the existing behavior.

Link: https://lkml.kernel.org/r/20210610133051.15337-2-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Cc: <jenhaochen@google.com>
Cc: Martin Liu <liumartin@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |   46 ++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 17 deletions(-)

--- a/kernel/kthread.c~kthread_worker-split-code-for-canceling-the-delayed-work-timer
+++ a/kernel/kthread.c
@@ -1093,6 +1093,33 @@ void kthread_flush_work(struct kthread_w
 EXPORT_SYMBOL_GPL(kthread_flush_work);
 
 /*
+ * Make sure that the timer is neither set nor running and could
+ * not manipulate the work list_head any longer.
+ *
+ * The function is called under worker->lock. The lock is temporary
+ * released but the timer can't be set again in the meantime.
+ */
+static void kthread_cancel_delayed_work_timer(struct kthread_work *work,
+					      unsigned long *flags)
+{
+	struct kthread_delayed_work *dwork =
+		container_of(work, struct kthread_delayed_work, work);
+	struct kthread_worker *worker = work->worker;
+
+	/*
+	 * del_timer_sync() must be called to make sure that the timer
+	 * callback is not running. The lock must be temporary released
+	 * to avoid a deadlock with the callback. In the meantime,
+	 * any queuing is blocked by setting the canceling counter.
+	 */
+	work->canceling++;
+	raw_spin_unlock_irqrestore(&worker->lock, *flags);
+	del_timer_sync(&dwork->timer);
+	raw_spin_lock_irqsave(&worker->lock, *flags);
+	work->canceling--;
+}
+
+/*
  * This function removes the work from the worker queue. Also it makes sure
  * that it won't get queued later via the delayed work's timer.
  *
@@ -1106,23 +1133,8 @@ static bool __kthread_cancel_work(struct
 				  unsigned long *flags)
 {
 	/* Try to cancel the timer if exists. */
-	if (is_dwork) {
-		struct kthread_delayed_work *dwork =
-			container_of(work, struct kthread_delayed_work, work);
-		struct kthread_worker *worker = work->worker;
-
-		/*
-		 * del_timer_sync() must be called to make sure that the timer
-		 * callback is not running. The lock must be temporary released
-		 * to avoid a deadlock with the callback. In the meantime,
-		 * any queuing is blocked by setting the canceling counter.
-		 */
-		work->canceling++;
-		raw_spin_unlock_irqrestore(&worker->lock, *flags);
-		del_timer_sync(&dwork->timer);
-		raw_spin_lock_irqsave(&worker->lock, *flags);
-		work->canceling--;
-	}
+	if (is_dwork)
+		kthread_cancel_delayed_work_timer(work, flags);
 
 	/*
 	 * Try to remove the work from a worker list. It might either
_
