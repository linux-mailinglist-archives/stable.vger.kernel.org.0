Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81D5E3135F3
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbhBHPDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:03:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:51778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232221AbhBHPDD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:03:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 677A664E8F;
        Mon,  8 Feb 2021 15:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796530;
        bh=Mo1uzfN0MpyLpClNFRuHdGMAfvRZYWwsEKoE1GTx8Fo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j1DVo+tpjTRnqAiY+kO8umKZG6KnsrE28LilH92enE8gk0JXe7ayW+oUMxEQTG3OK
         nmNXtQePF6OfBTqSPPregMMcqFhBM7xbXG8BGdDPu0TS1DLiKUlBVcrQI2GQZM74wQ
         A08kQP5CP8kl97TwfWgxrlgHKYdB7ZQg30pY7yYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        juri.lelli@arm.com, bigeasy@linutronix.de, xlpang@redhat.com,
        rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        jdesfossez@efficios.com, dvhart@infradead.org, bristot@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 03/38] futex: Remove rt_mutex_deadlock_account_*()
Date:   Mon,  8 Feb 2021 16:00:25 +0100
Message-Id: <20210208145805.425647086@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145805.279815326@linuxfoundation.org>
References: <20210208145805.279815326@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

From: Peter Zijlstra <peterz@infradead.org>

These are unused and clutter up the code.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: juri.lelli@arm.com
Cc: bigeasy@linutronix.de
Cc: xlpang@redhat.com
Cc: rostedt@goodmis.org
Cc: mathieu.desnoyers@efficios.com
Cc: jdesfossez@efficios.com
Cc: dvhart@infradead.org
Cc: bristot@redhat.com
Link: http://lkml.kernel.org/r/20170322104151.652692478@infradead.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[Lee: Back-ported to solve a dependency]
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/locking/rtmutex-debug.c |    9 --------
 kernel/locking/rtmutex-debug.h |    3 --
 kernel/locking/rtmutex.c       |   42 +++++++++++++++--------------------------
 kernel/locking/rtmutex.h       |    2 -
 4 files changed, 16 insertions(+), 40 deletions(-)

--- a/kernel/locking/rtmutex-debug.c
+++ b/kernel/locking/rtmutex-debug.c
@@ -173,12 +173,3 @@ void debug_rt_mutex_init(struct rt_mutex
 	lock->name = name;
 }
 
-void
-rt_mutex_deadlock_account_lock(struct rt_mutex *lock, struct task_struct *task)
-{
-}
-
-void rt_mutex_deadlock_account_unlock(struct task_struct *task)
-{
-}
-
--- a/kernel/locking/rtmutex-debug.h
+++ b/kernel/locking/rtmutex-debug.h
@@ -9,9 +9,6 @@
  * This file contains macros used solely by rtmutex.c. Debug version.
  */
 
-extern void
-rt_mutex_deadlock_account_lock(struct rt_mutex *lock, struct task_struct *task);
-extern void rt_mutex_deadlock_account_unlock(struct task_struct *task);
 extern void debug_rt_mutex_init_waiter(struct rt_mutex_waiter *waiter);
 extern void debug_rt_mutex_free_waiter(struct rt_mutex_waiter *waiter);
 extern void debug_rt_mutex_init(struct rt_mutex *lock, const char *name);
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -937,8 +937,6 @@ takeit:
 	 */
 	rt_mutex_set_owner(lock, task);
 
-	rt_mutex_deadlock_account_lock(lock, task);
-
 	return 1;
 }
 
@@ -1331,8 +1329,6 @@ static bool __sched rt_mutex_slowunlock(
 
 	debug_rt_mutex_unlock(lock);
 
-	rt_mutex_deadlock_account_unlock(current);
-
 	/*
 	 * We must be careful here if the fast path is enabled. If we
 	 * have no waiters queued we cannot set owner to NULL here
@@ -1398,11 +1394,10 @@ rt_mutex_fastlock(struct rt_mutex *lock,
 				struct hrtimer_sleeper *timeout,
 				enum rtmutex_chainwalk chwalk))
 {
-	if (likely(rt_mutex_cmpxchg_acquire(lock, NULL, current))) {
-		rt_mutex_deadlock_account_lock(lock, current);
+	if (likely(rt_mutex_cmpxchg_acquire(lock, NULL, current)))
 		return 0;
-	} else
-		return slowfn(lock, state, NULL, RT_MUTEX_MIN_CHAINWALK);
+
+	return slowfn(lock, state, NULL, RT_MUTEX_MIN_CHAINWALK);
 }
 
 static inline int
@@ -1414,21 +1409,19 @@ rt_mutex_timed_fastlock(struct rt_mutex
 				      enum rtmutex_chainwalk chwalk))
 {
 	if (chwalk == RT_MUTEX_MIN_CHAINWALK &&
-	    likely(rt_mutex_cmpxchg_acquire(lock, NULL, current))) {
-		rt_mutex_deadlock_account_lock(lock, current);
+	    likely(rt_mutex_cmpxchg_acquire(lock, NULL, current)))
 		return 0;
-	} else
-		return slowfn(lock, state, timeout, chwalk);
+
+	return slowfn(lock, state, timeout, chwalk);
 }
 
 static inline int
 rt_mutex_fasttrylock(struct rt_mutex *lock,
 		     int (*slowfn)(struct rt_mutex *lock))
 {
-	if (likely(rt_mutex_cmpxchg_acquire(lock, NULL, current))) {
-		rt_mutex_deadlock_account_lock(lock, current);
+	if (likely(rt_mutex_cmpxchg_acquire(lock, NULL, current)))
 		return 1;
-	}
+
 	return slowfn(lock);
 }
 
@@ -1438,19 +1431,18 @@ rt_mutex_fastunlock(struct rt_mutex *loc
 				   struct wake_q_head *wqh))
 {
 	WAKE_Q(wake_q);
+	bool deboost;
 
-	if (likely(rt_mutex_cmpxchg_release(lock, current, NULL))) {
-		rt_mutex_deadlock_account_unlock(current);
+	if (likely(rt_mutex_cmpxchg_release(lock, current, NULL)))
+		return;
 
-	} else {
-		bool deboost = slowfn(lock, &wake_q);
+	deboost = slowfn(lock, &wake_q);
 
-		wake_up_q(&wake_q);
+	wake_up_q(&wake_q);
 
-		/* Undo pi boosting if necessary: */
-		if (deboost)
-			rt_mutex_adjust_prio(current);
-	}
+	/* Undo pi boosting if necessary: */
+	if (deboost)
+		rt_mutex_adjust_prio(current);
 }
 
 /**
@@ -1648,7 +1640,6 @@ void rt_mutex_init_proxy_locked(struct r
 	__rt_mutex_init(lock, NULL);
 	debug_rt_mutex_proxy_lock(lock, proxy_owner);
 	rt_mutex_set_owner(lock, proxy_owner);
-	rt_mutex_deadlock_account_lock(lock, proxy_owner);
 }
 
 /**
@@ -1664,7 +1655,6 @@ void rt_mutex_proxy_unlock(struct rt_mut
 {
 	debug_rt_mutex_proxy_unlock(lock);
 	rt_mutex_set_owner(lock, NULL);
-	rt_mutex_deadlock_account_unlock(proxy_owner);
 }
 
 /**
--- a/kernel/locking/rtmutex.h
+++ b/kernel/locking/rtmutex.h
@@ -11,8 +11,6 @@
  */
 
 #define rt_mutex_deadlock_check(l)			(0)
-#define rt_mutex_deadlock_account_lock(m, t)		do { } while (0)
-#define rt_mutex_deadlock_account_unlock(l)		do { } while (0)
 #define debug_rt_mutex_init_waiter(w)			do { } while (0)
 #define debug_rt_mutex_free_waiter(w)			do { } while (0)
 #define debug_rt_mutex_lock(l)				do { } while (0)


