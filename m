Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE3E3B6126
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234312AbhF1Ocv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:32:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233351AbhF1Oan (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:30:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E45D261CCB;
        Mon, 28 Jun 2021 14:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890426;
        bh=4GAMmsKPNq0ttjaP18oaCfcZpnElnJ6IQg+QepOmgwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KgLSkP8RV7qVIMBCA8SD9DHqTYB3NjJ+mtc2qu/JStOzvEjiE/x8zPzUh/EJWKJuC
         OTUxiOzqH9DZL6nW0JX1OMc9kU9pann+SQmpBR5UMq+8/L8RtQAW5TAxg1kPKVKTWw
         Xm6yVka2u9lYLsmL7V6s4nFgt0D1Nr5NM3efNlgfepzzAfWLkSQQRfZzG2bxRIsAXq
         gujKKVKksmf4agutF07ncgqtZ95wRS2nWbyaGE2I7+Q/KO3iohbcEz7T6VaDNN+zXd
         nNID9AvqApypadMFUMIb4g550IM60bfZBFBYVyNnnnIHYJ+gSiLcQYDwWr/w8EfODc
         4Ro8KzQ7aiLqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Mladek <pmladek@suse.com>, jenhaochen@google.com,
        Martin Liu <liumartin@google.com>,
        Minchan Kim <minchan@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.10 067/101] kthread_worker: split code for canceling the delayed work timer
Date:   Mon, 28 Jun 2021 10:25:33 -0400
Message-Id: <20210628142607.32218-68-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
 kernel/kthread.c | 46 +++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 5edf7e19ab26..415417b76bfb 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -1043,6 +1043,33 @@ void kthread_flush_work(struct kthread_work *work)
 }
 EXPORT_SYMBOL_GPL(kthread_flush_work);
 
+/*
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
 /*
  * This function removes the work from the worker queue. Also it makes sure
  * that it won't get queued later via the delayed work's timer.
@@ -1057,23 +1084,8 @@ static bool __kthread_cancel_work(struct kthread_work *work, bool is_dwork,
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
-- 
2.30.2

