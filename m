Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA1D30F9BB
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 18:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238362AbhBDRbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 12:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238518AbhBDR3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 12:29:50 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D909FC06178A
        for <stable@vger.kernel.org>; Thu,  4 Feb 2021 09:29:09 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id m13so4447198wro.12
        for <stable@vger.kernel.org>; Thu, 04 Feb 2021 09:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9G32MvUQnMihp2dXE+SFBFZc9Ph7JPBNbbGYxik49LE=;
        b=lsk7RF6wOITHSRBg7Mzg4E+e4uDvAVoApQDk+AC872daBAx5hySzKh7ogKt7UUSDR3
         K9JHNlQ8YvMw1YIpXDNskGwmszMbExLzbGZkau3Se3zxgK3jhH9LrAhXRqbmW5HY/vvI
         7ZK7KSD1KHQgebbtQ8laY+qIsDiYsp/EAl3QSzdLGBuAiRSrNnj07zPasCH5mQeX15IR
         iBIpWuC9WyBTuJHF4BLoIgxX0iddGf+3tIKjpughl4qEvimmffhbkZokH6sSnfaDtqhl
         eMAkX0oRi+G4goUGXhzB7g3ZFma2qa8ixf92ngv4W1dwepHObbVREFaDbajcUFE5mukN
         l1nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9G32MvUQnMihp2dXE+SFBFZc9Ph7JPBNbbGYxik49LE=;
        b=DXx/E2SOgcZVhz3Gsm5FPeyNYlL+4OMuX1FCwg/AJ+BDYtyX+yvHlyTzbHHtpb4eXA
         D8yHf5oXHoxTnH6ARGPUJPNwDuD6/quaWJku+XDgdwYQSCs5EiyNMXl+BYUA+ct63uHl
         CQ6F2jjeovk/9dTMDqDKH7Wy9i1KfycSkMeMNwX7VppdsC6z3oOeW72KXKqj9hrZD/X/
         4iIvnSuAG5EEL4g40xXs17iRr9jt3s62a/n05lONcjJNaK+aCbO8HGJT0XZA/C6EqKAw
         eN8W88Lua5p+Nb5Us2H3BmBsPVWms6thw/84XzvJg4r8Rmu7iAf4B0BBvHWWuS1F5GOf
         BqCQ==
X-Gm-Message-State: AOAM530q5VahRgHOJKM6BBHhVvIkxiXkYdlSF36wSj4VqC5idmysBDFq
        aLMrgnIVx0FCqzWm3RpIyaZmOyR+r6mSAg==
X-Google-Smtp-Source: ABdhPJzqiq6RIbxfAaopoIgkc7FKdaHi52D5ShDaSW3DUu4g1moW7QpaC4id3ODxFj75tIQNIq7Mng==
X-Received: by 2002:a05:6000:1189:: with SMTP id g9mr475090wrx.230.1612459748318;
        Thu, 04 Feb 2021 09:29:08 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id j7sm9641334wrp.72.2021.02.04.09.29.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 09:29:07 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>, juri.lelli@arm.com,
        bigeasy@linutronix.de, xlpang@redhat.com, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, jdesfossez@efficios.com,
        dvhart@infradead.org, bristot@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 01/10] futex,rt_mutex: Provide futex specific rt_mutex API
Date:   Thu,  4 Feb 2021 17:28:54 +0000
Message-Id: <20210204172903.2860981-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204172903.2860981-1-lee.jones@linaro.org>
References: <20210204172903.2860981-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 5293c2efda37775346885c7e924d4ef7018ea60b ]

Part of what makes futex_unlock_pi() intricate is that
rt_mutex_futex_unlock() -> rt_mutex_slowunlock() can drop
rt_mutex::wait_lock.

This means it cannot rely on the atomicy of wait_lock, which would be
preferred in order to not rely on hb->lock so much.

The reason rt_mutex_slowunlock() needs to drop wait_lock is because it can
race with the rt_mutex fastpath, however futexes have their own fast path.

Since futexes already have a bunch of separate rt_mutex accessors, complete
that set and implement a rt_mutex variant without fastpath for them.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: juri.lelli@arm.com
Cc: bigeasy@linutronix.de
Cc: xlpang@redhat.com
Cc: rostedt@goodmis.org
Cc: mathieu.desnoyers@efficios.com
Cc: jdesfossez@efficios.com
Cc: dvhart@infradead.org
Cc: bristot@redhat.com
Link: http://lkml.kernel.org/r/20170322104151.702962446@infradead.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[Lee: Back-ported to solve a dependency]
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 kernel/futex.c                  | 30 +++++++++---------
 kernel/locking/rtmutex.c        | 56 ++++++++++++++++++++++++---------
 kernel/locking/rtmutex_common.h |  8 +++--
 3 files changed, 61 insertions(+), 33 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index f1990e2a51e5a..00b474b4b54e0 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -936,7 +936,7 @@ static void exit_pi_state_list(struct task_struct *curr)
 		pi_state->owner = NULL;
 		raw_spin_unlock_irq(&curr->pi_lock);
 
-		rt_mutex_unlock(&pi_state->pi_mutex);
+		rt_mutex_futex_unlock(&pi_state->pi_mutex);
 
 		spin_unlock(&hb->lock);
 
@@ -1436,20 +1436,18 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this,
 	pi_state->owner = new_owner;
 	raw_spin_unlock_irq(&new_owner->pi_lock);
 
-	raw_spin_unlock(&pi_state->pi_mutex.wait_lock);
-
-	deboost = rt_mutex_futex_unlock(&pi_state->pi_mutex, &wake_q);
-
 	/*
-	 * First unlock HB so the waiter does not spin on it once he got woken
-	 * up. Second wake up the waiter before the priority is adjusted. If we
-	 * deboost first (and lose our higher priority), then the task might get
-	 * scheduled away before the wake up can take place.
+	 * We've updated the uservalue, this unlock cannot fail.
 	 */
+	deboost = __rt_mutex_futex_unlock(&pi_state->pi_mutex, &wake_q);
+
+	raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
 	spin_unlock(&hb->lock);
-	wake_up_q(&wake_q);
-	if (deboost)
+
+	if (deboost) {
+		wake_up_q(&wake_q);
 		rt_mutex_adjust_prio(current);
+	}
 
 	return 0;
 }
@@ -2362,7 +2360,7 @@ static int fixup_owner(u32 __user *uaddr, struct futex_q *q, int locked)
 		 * task acquired the rt_mutex after we removed ourself from the
 		 * rt_mutex waiters list.
 		 */
-		if (rt_mutex_trylock(&q->pi_state->pi_mutex)) {
+		if (rt_mutex_futex_trylock(&q->pi_state->pi_mutex)) {
 			locked = 1;
 			goto out;
 		}
@@ -2686,7 +2684,7 @@ retry_private:
 	if (!trylock) {
 		ret = rt_mutex_timed_futex_lock(&q.pi_state->pi_mutex, to);
 	} else {
-		ret = rt_mutex_trylock(&q.pi_state->pi_mutex);
+		ret = rt_mutex_futex_trylock(&q.pi_state->pi_mutex);
 		/* Fixup the trylock return value: */
 		ret = ret ? 0 : -EWOULDBLOCK;
 	}
@@ -2709,7 +2707,7 @@ retry_private:
 	 * it and return the fault to userspace.
 	 */
 	if (ret && (rt_mutex_owner(&q.pi_state->pi_mutex) == current))
-		rt_mutex_unlock(&q.pi_state->pi_mutex);
+		rt_mutex_futex_unlock(&q.pi_state->pi_mutex);
 
 	/* Unqueue and drop the lock */
 	unqueue_me_pi(&q);
@@ -3016,7 +3014,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 			spin_lock(q.lock_ptr);
 			ret = fixup_pi_state_owner(uaddr2, &q, current);
 			if (ret && rt_mutex_owner(&q.pi_state->pi_mutex) == current)
-				rt_mutex_unlock(&q.pi_state->pi_mutex);
+				rt_mutex_futex_unlock(&q.pi_state->pi_mutex);
 			/*
 			 * Drop the reference to the pi state which
 			 * the requeue_pi() code acquired for us.
@@ -3059,7 +3057,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 		 * userspace.
 		 */
 		if (ret && rt_mutex_owner(pi_mutex) == current)
-			rt_mutex_unlock(pi_mutex);
+			rt_mutex_futex_unlock(pi_mutex);
 
 		/* Unqueue and drop the lock. */
 		unqueue_me_pi(&q);
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index dd173df9ee5e5..3323ef935372f 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1485,15 +1485,23 @@ EXPORT_SYMBOL_GPL(rt_mutex_lock_interruptible);
 
 /*
  * Futex variant with full deadlock detection.
+ * Futex variants must not use the fast-path, see __rt_mutex_futex_unlock().
  */
-int rt_mutex_timed_futex_lock(struct rt_mutex *lock,
+int __sched rt_mutex_timed_futex_lock(struct rt_mutex *lock,
 			      struct hrtimer_sleeper *timeout)
 {
 	might_sleep();
 
-	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout,
-				       RT_MUTEX_FULL_CHAINWALK,
-				       rt_mutex_slowlock);
+	return rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE,
+				 timeout, RT_MUTEX_FULL_CHAINWALK);
+}
+
+/*
+ * Futex variant, must not use fastpath.
+ */
+int __sched rt_mutex_futex_trylock(struct rt_mutex *lock)
+{
+	return rt_mutex_slowtrylock(lock);
 }
 
 /**
@@ -1552,20 +1560,38 @@ void __sched rt_mutex_unlock(struct rt_mutex *lock)
 EXPORT_SYMBOL_GPL(rt_mutex_unlock);
 
 /**
- * rt_mutex_futex_unlock - Futex variant of rt_mutex_unlock
- * @lock: the rt_mutex to be unlocked
- *
- * Returns: true/false indicating whether priority adjustment is
- * required or not.
+ * Futex variant, that since futex variants do not use the fast-path, can be
+ * simple and will not need to retry.
  */
-bool __sched rt_mutex_futex_unlock(struct rt_mutex *lock,
-				   struct wake_q_head *wqh)
+bool __sched __rt_mutex_futex_unlock(struct rt_mutex *lock,
+				    struct wake_q_head *wake_q)
 {
-	if (likely(rt_mutex_cmpxchg_release(lock, current, NULL))) {
-		rt_mutex_deadlock_account_unlock(current);
-		return false;
+	lockdep_assert_held(&lock->wait_lock);
+
+	debug_rt_mutex_unlock(lock);
+
+	if (!rt_mutex_has_waiters(lock)) {
+		lock->owner = NULL;
+		return false; /* done */
+	}
+
+	mark_wakeup_next_waiter(wake_q, lock);
+	return true; /* deboost and wakeups */
+}
+
+void __sched rt_mutex_futex_unlock(struct rt_mutex *lock)
+{
+	WAKE_Q(wake_q);
+	bool deboost;
+
+	raw_spin_lock_irq(&lock->wait_lock);
+	deboost = __rt_mutex_futex_unlock(lock, &wake_q);
+	raw_spin_unlock_irq(&lock->wait_lock);
+
+	if (deboost) {
+		wake_up_q(&wake_q);
+		rt_mutex_adjust_prio(current);
 	}
-	return rt_mutex_slowunlock(lock, wqh);
 }
 
 /**
diff --git a/kernel/locking/rtmutex_common.h b/kernel/locking/rtmutex_common.h
index 6f8f68edb700c..cdcaccfb74432 100644
--- a/kernel/locking/rtmutex_common.h
+++ b/kernel/locking/rtmutex_common.h
@@ -112,8 +112,12 @@ extern int rt_mutex_wait_proxy_lock(struct rt_mutex *lock,
 extern bool rt_mutex_cleanup_proxy_lock(struct rt_mutex *lock,
 				 struct rt_mutex_waiter *waiter);
 extern int rt_mutex_timed_futex_lock(struct rt_mutex *l, struct hrtimer_sleeper *to);
-extern bool rt_mutex_futex_unlock(struct rt_mutex *lock,
-				  struct wake_q_head *wqh);
+extern int rt_mutex_futex_trylock(struct rt_mutex *l);
+
+extern void rt_mutex_futex_unlock(struct rt_mutex *lock);
+extern bool __rt_mutex_futex_unlock(struct rt_mutex *lock,
+				 struct wake_q_head *wqh);
+
 extern void rt_mutex_adjust_prio(struct task_struct *task);
 
 #ifdef CONFIG_DEBUG_RT_MUTEXES
-- 
2.25.1

