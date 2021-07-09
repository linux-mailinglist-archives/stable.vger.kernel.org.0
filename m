Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE6D3C243B
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbhGINVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:21:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232021AbhGINVl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:21:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E82AF61357;
        Fri,  9 Jul 2021 13:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836738;
        bh=aNIfBMAS+OUJJ23eapl/YTXCKRYtQWg8KfJDh4UNTkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HN8noom+uIbU1YHnuipGBIwnDRy9YTQTRecRZFP8FJcihOsSemuXXTYt9Sztn3MUN
         /kz7cuFVgzMG/XcVI23MRMz7f4/OSC2x1ykCf59b2oFYTQc2uEeNf3+a32oxUkW51R
         PVNgM0dUhP5DmPhAUc0nSEVKJ06e08LpojkiLDoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        jenhaochen@google.com, Martin Liu <liumartin@google.com>,
        Minchan Kim <minchan@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 7/9] kthread_worker: split code for canceling the delayed work timer
Date:   Fri,  9 Jul 2021 15:18:34 +0200
Message-Id: <20210709131552.455038494@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131542.410636747@linuxfoundation.org>
References: <20210709131542.410636747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Mladek <pmladek@suse.com>

commit 34b3d5344719d14fd2185b2d9459b3abcb8cf9d8 upstream.

Patch series "kthread_worker: Fix race between kthread_mod_delayed_work()
and kthread_cancel_delayed_work_sync()".

This patchset fixes the race between kthread_mod_delayed_work() and
kthread_cancel_delayed_work_sync() including proper return value
handling.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/kthread.c |   46 +++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 17 deletions(-)

--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -952,6 +952,33 @@ void kthread_flush_work(struct kthread_w
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
+	spin_unlock_irqrestore(&worker->lock, *flags);
+	del_timer_sync(&dwork->timer);
+	spin_lock_irqsave(&worker->lock, *flags);
+	work->canceling--;
+}
+
+/*
  * This function removes the work from the worker queue. Also it makes sure
  * that it won't get queued later via the delayed work's timer.
  *
@@ -965,23 +992,8 @@ static bool __kthread_cancel_work(struct
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
-		spin_unlock_irqrestore(&worker->lock, *flags);
-		del_timer_sync(&dwork->timer);
-		spin_lock_irqsave(&worker->lock, *flags);
-		work->canceling--;
-	}
+	if (is_dwork)
+		kthread_cancel_delayed_work_timer(work, flags);
 
 	/*
 	 * Try to remove the work from a worker list. It might either


