Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A0638EDF1
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbhEXPn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:43:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233045AbhEXPmE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:42:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1894C61449;
        Mon, 24 May 2021 15:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870488;
        bh=eOKaja5hCBW7m2c8I8KG96QDT2EdqZCH3DzPKDvwX6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zHAfMS8/quoPpFNKVXx+TtSsx/Zo2w5uGfKa9zL9IxrWVEoGzukIj7F/oxaz34rWw
         8RZoUkyENemlfP54jKgye4nyRLyJYsdVgcX7S4W4t7BEkWuMmNEbKCBUZIUPYLpaW1
         r6I538hWMs7mcCrg4J1fd/2bdf4WhWLi4tDSf/sw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Zqiang <qiang.zhang@windriver.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 09/49] locking/mutex: clear MUTEX_FLAGS if wait_list is empty due to signal
Date:   Mon, 24 May 2021 17:25:20 +0200
Message-Id: <20210524152324.694690812@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152324.382084875@linuxfoundation.org>
References: <20210524152324.382084875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zqiang <qiang.zhang@windriver.com>

[ Upstream commit 3a010c493271f04578b133de977e0e5dd2848cea ]

When a interruptible mutex locker is interrupted by a signal
without acquiring this lock and removed from the wait queue.
if the mutex isn't contended enough to have a waiter
put into the wait queue again, the setting of the WAITER
bit will force mutex locker to go into the slowpath to
acquire the lock every time, so if the wait queue is empty,
the WAITER bit need to be clear.

Fixes: 040a0a371005 ("mutex: Add support for wound/wait style locks")
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Zqiang <qiang.zhang@windriver.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210517034005.30828-1-qiang.zhang@windriver.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/mutex-debug.c |  4 ++--
 kernel/locking/mutex-debug.h |  2 +-
 kernel/locking/mutex.c       | 18 +++++++++++++-----
 kernel/locking/mutex.h       |  4 +---
 4 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/kernel/locking/mutex-debug.c b/kernel/locking/mutex-debug.c
index 9aa713629387..839df4383799 100644
--- a/kernel/locking/mutex-debug.c
+++ b/kernel/locking/mutex-debug.c
@@ -57,7 +57,7 @@ void debug_mutex_add_waiter(struct mutex *lock, struct mutex_waiter *waiter,
 	task->blocked_on = waiter;
 }
 
-void mutex_remove_waiter(struct mutex *lock, struct mutex_waiter *waiter,
+void debug_mutex_remove_waiter(struct mutex *lock, struct mutex_waiter *waiter,
 			 struct task_struct *task)
 {
 	DEBUG_LOCKS_WARN_ON(list_empty(&waiter->list));
@@ -65,7 +65,7 @@ void mutex_remove_waiter(struct mutex *lock, struct mutex_waiter *waiter,
 	DEBUG_LOCKS_WARN_ON(task->blocked_on != waiter);
 	task->blocked_on = NULL;
 
-	list_del_init(&waiter->list);
+	INIT_LIST_HEAD(&waiter->list);
 	waiter->task = NULL;
 }
 
diff --git a/kernel/locking/mutex-debug.h b/kernel/locking/mutex-debug.h
index 1edd3f45a4ec..53e631e1d76d 100644
--- a/kernel/locking/mutex-debug.h
+++ b/kernel/locking/mutex-debug.h
@@ -22,7 +22,7 @@ extern void debug_mutex_free_waiter(struct mutex_waiter *waiter);
 extern void debug_mutex_add_waiter(struct mutex *lock,
 				   struct mutex_waiter *waiter,
 				   struct task_struct *task);
-extern void mutex_remove_waiter(struct mutex *lock, struct mutex_waiter *waiter,
+extern void debug_mutex_remove_waiter(struct mutex *lock, struct mutex_waiter *waiter,
 				struct task_struct *task);
 extern void debug_mutex_unlock(struct mutex *lock);
 extern void debug_mutex_init(struct mutex *lock, const char *name,
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index b3da782cdfbd..354151fef06a 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -177,7 +177,7 @@ static inline bool __mutex_waiter_is_first(struct mutex *lock, struct mutex_wait
  * Add @waiter to a given location in the lock wait_list and set the
  * FLAG_WAITERS flag if it's the first waiter.
  */
-static void __sched
+static void
 __mutex_add_waiter(struct mutex *lock, struct mutex_waiter *waiter,
 		   struct list_head *list)
 {
@@ -188,6 +188,16 @@ __mutex_add_waiter(struct mutex *lock, struct mutex_waiter *waiter,
 		__mutex_set_flag(lock, MUTEX_FLAG_WAITERS);
 }
 
+static void
+__mutex_remove_waiter(struct mutex *lock, struct mutex_waiter *waiter)
+{
+	list_del(&waiter->list);
+	if (likely(list_empty(&lock->wait_list)))
+		__mutex_clear_flag(lock, MUTEX_FLAGS);
+
+	debug_mutex_remove_waiter(lock, waiter, current);
+}
+
 /*
  * Give up ownership to a specific task, when @task = NULL, this is equivalent
  * to a regular unlock. Sets PICKUP on a handoff, clears HANDOF, preserves
@@ -1040,9 +1050,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 			__ww_mutex_check_waiters(lock, ww_ctx);
 	}
 
-	mutex_remove_waiter(lock, &waiter, current);
-	if (likely(list_empty(&lock->wait_list)))
-		__mutex_clear_flag(lock, MUTEX_FLAGS);
+	__mutex_remove_waiter(lock, &waiter);
 
 	debug_mutex_free_waiter(&waiter);
 
@@ -1059,7 +1067,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 
 err:
 	__set_current_state(TASK_RUNNING);
-	mutex_remove_waiter(lock, &waiter, current);
+	__mutex_remove_waiter(lock, &waiter);
 err_early_kill:
 	spin_unlock(&lock->wait_lock);
 	debug_mutex_free_waiter(&waiter);
diff --git a/kernel/locking/mutex.h b/kernel/locking/mutex.h
index 1c2287d3fa71..f0c710b1d192 100644
--- a/kernel/locking/mutex.h
+++ b/kernel/locking/mutex.h
@@ -10,12 +10,10 @@
  * !CONFIG_DEBUG_MUTEXES case. Most of them are NOPs:
  */
 
-#define mutex_remove_waiter(lock, waiter, task) \
-		__list_del((waiter)->list.prev, (waiter)->list.next)
-
 #define debug_mutex_wake_waiter(lock, waiter)		do { } while (0)
 #define debug_mutex_free_waiter(waiter)			do { } while (0)
 #define debug_mutex_add_waiter(lock, waiter, ti)	do { } while (0)
+#define debug_mutex_remove_waiter(lock, waiter, ti)     do { } while (0)
 #define debug_mutex_unlock(lock)			do { } while (0)
 #define debug_mutex_init(lock, name, key)		do { } while (0)
 
-- 
2.30.2



