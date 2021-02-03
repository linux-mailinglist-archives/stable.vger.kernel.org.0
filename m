Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3362A30DB9F
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 14:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhBCNql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 08:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232181AbhBCNqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 08:46:31 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABACC0613ED
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 05:45:49 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id c4so21643490wru.9
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 05:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KBJgTERN4u5dqqvue5Bwso6/AEy/i3vNaSOQipjk4AE=;
        b=dRVIFDjSGbXs0Mh7mEKLOWfO04UCEQAkZDoX+x00aNE6UIrK78vB4laOwNUjrCJEYt
         zpxpFHnBCC4/MD5qJ07Ph0+97AjOtdDOn3NIYwWSYtQNjMNdZDeV4gjEV+KivZ81xN8X
         bmdE5VBLj3Kanj2ANRhmdgyvA5H2ignr5dn/O6wvu5SgEDyo8jts9pA6Kpgu4II6Uy7C
         ExAyZaZtSvoiPVWJ88jM1OosW+gfz9vYdnmIRaYltBYxv7MUnTxEgE+PiQn3Mt1qadek
         3YY744IYZoAkbiuGRUdE2i4Lqb0UUmz6q+EJbKviFXdXQi0vJvATryWySQX1hyhixBhG
         Nq2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KBJgTERN4u5dqqvue5Bwso6/AEy/i3vNaSOQipjk4AE=;
        b=rkxuUNB9cWOb8XGeNnoLwRLz8K3f4f9XzYEgd+f8Rnu5h9lr8B9mPPNkFHLT7PUGHG
         kqkxDyQ2SYwtFX4eRCGIaLxe49Rd/Okw8BK5DOM2mHB2ciUMdRQRfSdl6a0brXVNGFMv
         iLkO1bebqMxR86niG2Jox/pAmg6uph1c4nykTsLasanUs2ZxcsJ5R4WwAIgvmI2BMLj6
         qlHFQIkv2gI6BpDCBQdtLu4/bkTtCF9Lnl5fR8h5/w72eALvNb/gRkpbi0orIQ1qb7ts
         v1WyJNVeQICkwSrBG0xBhbWev/86Eok2KzQ4MEVyqx9pFeNLhMX1jfE1Nw0iJFoqmfue
         qECQ==
X-Gm-Message-State: AOAM530rCH62jOOlwHSt0VRJuLW9bCrgDv1/CTvg/PkVhucnfZYLU8Td
        ekcjJpRQTbFdLnfVTkNzsm+IISHEFAl+eg==
X-Google-Smtp-Source: ABdhPJwiP8ajb6Aa8lFlSGR9n/SWyEKbzRpDGgFcKkyo5oZ5Y4sQry8NPhW9tm0yFjnyKUExZAYczA==
X-Received: by 2002:a5d:4f86:: with SMTP id d6mr3683179wru.246.1612359948424;
        Wed, 03 Feb 2021 05:45:48 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id r124sm2867900wmr.16.2021.02.03.05.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 05:45:47 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>, juri.lelli@arm.com,
        bigeasy@linutronix.de, xlpang@redhat.com, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, jdesfossez@efficios.com,
        dvhart@infradead.org, bristot@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 01/10] futex,rt_mutex: Provide futex specific rt_mutex API
Date:   Wed,  3 Feb 2021 13:45:30 +0000
Message-Id: <20210203134539.2583943-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203134539.2583943-1-lee.jones@linaro.org>
References: <20210203134539.2583943-1-lee.jones@linaro.org>
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
index 2ef8c5aef35d0..97799bf825434 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -941,7 +941,7 @@ static void exit_pi_state_list(struct task_struct *curr)
 		pi_state->owner = NULL;
 		raw_spin_unlock_irq(&curr->pi_lock);
 
-		rt_mutex_unlock(&pi_state->pi_mutex);
+		rt_mutex_futex_unlock(&pi_state->pi_mutex);
 
 		spin_unlock(&hb->lock);
 
@@ -1441,20 +1441,18 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this,
 	pi_state->owner = new_owner;
 	raw_spin_unlock(&new_owner->pi_lock);
 
-	raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
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
@@ -2397,7 +2395,7 @@ static int fixup_owner(u32 __user *uaddr, struct futex_q *q, int locked)
 		 * task acquired the rt_mutex after we removed ourself from the
 		 * rt_mutex waiters list.
 		 */
-		if (rt_mutex_trylock(&q->pi_state->pi_mutex)) {
+		if (rt_mutex_futex_trylock(&q->pi_state->pi_mutex)) {
 			locked = 1;
 			goto out;
 		}
@@ -2721,7 +2719,7 @@ static int futex_lock_pi(u32 __user *uaddr, unsigned int flags,
 	if (!trylock) {
 		ret = rt_mutex_timed_futex_lock(&q.pi_state->pi_mutex, to);
 	} else {
-		ret = rt_mutex_trylock(&q.pi_state->pi_mutex);
+		ret = rt_mutex_futex_trylock(&q.pi_state->pi_mutex);
 		/* Fixup the trylock return value: */
 		ret = ret ? 0 : -EWOULDBLOCK;
 	}
@@ -2744,7 +2742,7 @@ static int futex_lock_pi(u32 __user *uaddr, unsigned int flags,
 	 * it and return the fault to userspace.
 	 */
 	if (ret && (rt_mutex_owner(&q.pi_state->pi_mutex) == current))
-		rt_mutex_unlock(&q.pi_state->pi_mutex);
+		rt_mutex_futex_unlock(&q.pi_state->pi_mutex);
 
 	/* Unqueue and drop the lock */
 	unqueue_me_pi(&q);
@@ -3051,7 +3049,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 			spin_lock(q.lock_ptr);
 			ret = fixup_pi_state_owner(uaddr2, &q, current);
 			if (ret && rt_mutex_owner(&q.pi_state->pi_mutex) == current)
-				rt_mutex_unlock(&q.pi_state->pi_mutex);
+				rt_mutex_futex_unlock(&q.pi_state->pi_mutex);
 			/*
 			 * Drop the reference to the pi state which
 			 * the requeue_pi() code acquired for us.
@@ -3094,7 +3092,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 		 * userspace.
 		 */
 		if (ret && rt_mutex_owner(pi_mutex) == current)
-			rt_mutex_unlock(pi_mutex);
+			rt_mutex_futex_unlock(pi_mutex);
 
 		/* Unqueue and drop the lock. */
 		unqueue_me_pi(&q);
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index 7615e7722258c..38e6cd23d2e76 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1519,15 +1519,23 @@ EXPORT_SYMBOL_GPL(rt_mutex_lock_interruptible);
 
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
@@ -1586,20 +1594,38 @@ void __sched rt_mutex_unlock(struct rt_mutex *lock)
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
index 14cbafed00142..882d84eda50aa 100644
--- a/kernel/locking/rtmutex_common.h
+++ b/kernel/locking/rtmutex_common.h
@@ -113,8 +113,12 @@ extern int rt_mutex_wait_proxy_lock(struct rt_mutex *lock,
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

