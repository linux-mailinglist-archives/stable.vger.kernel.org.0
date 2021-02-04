Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F75D30F9BC
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 18:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238422AbhBDRbl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 12:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238526AbhBDRaK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 12:30:10 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F2CC061793
        for <stable@vger.kernel.org>; Thu,  4 Feb 2021 09:29:14 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id q7so4426286wre.13
        for <stable@vger.kernel.org>; Thu, 04 Feb 2021 09:29:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OeZnmFAMRqXu+BLMGhYtdJauLwns5kAZmT2Z5KbH+AM=;
        b=PfJ2wW3ed357ljBROw+x5Hu1pIRKkKx0J1vu70rtYA7thBW0zQJjx71IP0jVT64sP1
         dcgx30riEl6tKl+CkqytHQ27qMpkNEspv0okSYRiTLwaiSPPQTlNwPgHHl6GADDbWEil
         wLP0VeRjM7PktbLDOvbr39G4wp1Qw/Oci91LrfvjtrZdByYmUQ/TYbWcjSMIF1eqmwxC
         9+ECHd8VUC/eiKUompBV25w0XaS5JDeXd1jz1Nso/JBAwxyXmfvZ+Y/AOq22LXwt8rKn
         8yLgUKe3PHYXtH2MkK+UkzvMyMaLHNAxJhybSghQwnK7zD+d3bWMjjBiEn5u4TCV+MUo
         Long==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OeZnmFAMRqXu+BLMGhYtdJauLwns5kAZmT2Z5KbH+AM=;
        b=Y/eVb1CZpdGaxiDuooxdFzT7puRPphrx0FBSl4Chu/7HpqBav1Js0qqZLUSESE6iDj
         Rl7LGajAn/NbyTl56+sMd4mXslC+XcgwVH/qXlNx0qN2oIkB2x3/VX6WAcYWBCiSfCrS
         mFav0Re4klIdUHVEG1eH3znNzpPtGs0khPh7eS4upYeGy7zqVTA8LC4QwGIlMqyMXzUK
         4HcFFVa1pIBs1ovZFysufG7y1VqIifx6TMedNo2fqpGIWe+tED9rkzXDMGnY3K9OiXfR
         rViT+9G2vcWb44LsYkrH44QAwgsDjzFW6BL//JZceqVp0mfqI4IjmBpkAuCDys/Asuzx
         RJpg==
X-Gm-Message-State: AOAM532sZBpImE368/iqaLzQVOC+F4wMxaTK7EjU56Iet6CsbKYaRp7Y
        S1fCUcZ5im470zz7WQHRS5kuJ/ZTDuN2KQ==
X-Google-Smtp-Source: ABdhPJwJFNomL2l5UXZoLHYMkNv4m00C1cF476trISFUi1lLRohoby/nVzcd7YLHogqKqwcAAvQlVw==
X-Received: by 2002:adf:f18a:: with SMTP id h10mr399573wro.299.1612459752354;
        Thu, 04 Feb 2021 09:29:12 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id j7sm9641334wrp.72.2021.02.04.09.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 09:29:11 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Julia Cartwright <julia@ni.com>,
        Gratian Crisan <gratian.crisan@ni.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 04/10] futex: Avoid violating the 10th rule of futex
Date:   Thu,  4 Feb 2021 17:28:57 +0000
Message-Id: <20210204172903.2860981-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204172903.2860981-1-lee.jones@linaro.org>
References: <20210204172903.2860981-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit c1e2f0eaf015fb7076d51a339011f2383e6dd389 upstream.

Julia reported futex state corruption in the following scenario:

   waiter                                  waker                                            stealer (prio > waiter)

   futex(WAIT_REQUEUE_PI, uaddr, uaddr2,
         timeout=[N ms])
      futex_wait_requeue_pi()
         futex_wait_queue_me()
            freezable_schedule()
            <scheduled out>
                                           futex(LOCK_PI, uaddr2)
                                           futex(CMP_REQUEUE_PI, uaddr,
                                                 uaddr2, 1, 0)
                                              /* requeues waiter to uaddr2 */
                                           futex(UNLOCK_PI, uaddr2)
                                                 wake_futex_pi()
                                                    cmp_futex_value_locked(uaddr2, waiter)
                                                    wake_up_q()
           <woken by waker>
           <hrtimer_wakeup() fires,
            clears sleeper->task>
                                                                                           futex(LOCK_PI, uaddr2)
                                                                                              __rt_mutex_start_proxy_lock()
                                                                                                 try_to_take_rt_mutex() /* steals lock */
                                                                                                    rt_mutex_set_owner(lock, stealer)
                                                                                              <preempted>
         <scheduled in>
         rt_mutex_wait_proxy_lock()
            __rt_mutex_slowlock()
               try_to_take_rt_mutex() /* fails, lock held by stealer */
               if (timeout && !timeout->task)
                  return -ETIMEDOUT;
            fixup_owner()
               /* lock wasn't acquired, so,
                  fixup_pi_state_owner skipped */

   return -ETIMEDOUT;

   /* At this point, we've returned -ETIMEDOUT to userspace, but the
    * futex word shows waiter to be the owner, and the pi_mutex has
    * stealer as the owner */

   futex_lock(LOCK_PI, uaddr2)
     -> bails with EDEADLK, futex word says we're owner.

And suggested that what commit:

  73d786bd043e ("futex: Rework inconsistent rt_mutex/futex_q state")

removes from fixup_owner() looks to be just what is needed. And indeed
it is -- I completely missed that requeue_pi could also result in this
case. So we need to restore that, except that subsequent patches, like
commit:

  16ffa12d7425 ("futex: Pull rt_mutex_futex_unlock() out from under hb->lock")

changed all the locking rules. Even without that, the sequence:

-               if (rt_mutex_futex_trylock(&q->pi_state->pi_mutex)) {
-                       locked = 1;
-                       goto out;
-               }

-               raw_spin_lock_irq(&q->pi_state->pi_mutex.wait_lock);
-               owner = rt_mutex_owner(&q->pi_state->pi_mutex);
-               if (!owner)
-                       owner = rt_mutex_next_owner(&q->pi_state->pi_mutex);
-               raw_spin_unlock_irq(&q->pi_state->pi_mutex.wait_lock);
-               ret = fixup_pi_state_owner(uaddr, q, owner);

already suggests there were races; otherwise we'd never have to look
at next_owner.

So instead of doing 3 consecutive wait_lock sections with who knows
what races, we do it all in a single section. Additionally, the usage
of pi_state->owner in fixup_owner() was only safe because only the
rt_mutex owner would modify it, which this additional case wrecks.

Luckily the values can only change away and not to the value we're
testing, this means we can do a speculative test and double check once
we have the wait_lock.

Fixes: 73d786bd043e ("futex: Rework inconsistent rt_mutex/futex_q state")
Reported-by: Julia Cartwright <julia@ni.com>
Reported-by: Gratian Crisan <gratian.crisan@ni.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Julia Cartwright <julia@ni.com>
Tested-by: Gratian Crisan <gratian.crisan@ni.com>
Cc: Darren Hart <dvhart@infradead.org>
Link: https://lkml.kernel.org/r/20171208124939.7livp7no2ov65rrc@hirez.programming.kicks-ass.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[Lee: Back-ported to solve a dependency]
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 kernel/futex.c                  | 80 +++++++++++++++++++++++++++------
 kernel/locking/rtmutex.c        | 26 ++++++++---
 kernel/locking/rtmutex_common.h |  1 +
 3 files changed, 87 insertions(+), 20 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index a5a91a55c451f..780872ac7d675 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2227,30 +2227,34 @@ static void unqueue_me_pi(struct futex_q *q)
 	spin_unlock(q->lock_ptr);
 }
 
-/*
- * Fixup the pi_state owner with the new owner.
- *
- * Must be called with hash bucket lock held and mm->sem held for non
- * private futexes.
- */
 static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
-				struct task_struct *newowner)
+				struct task_struct *argowner)
 {
-	u32 newtid = task_pid_vnr(newowner) | FUTEX_WAITERS;
 	struct futex_pi_state *pi_state = q->pi_state;
-	struct task_struct *oldowner = pi_state->owner;
 	u32 uval, uninitialized_var(curval), newval;
+	struct task_struct *oldowner, *newowner;
+	u32 newtid;
 	int ret;
 
+	lockdep_assert_held(q->lock_ptr);
+
+	oldowner = pi_state->owner;
 	/* Owner died? */
 	if (!pi_state->owner)
 		newtid |= FUTEX_OWNER_DIED;
 
 	/*
-	 * We are here either because we stole the rtmutex from the
-	 * previous highest priority waiter or we are the highest priority
-	 * waiter but failed to get the rtmutex the first time.
-	 * We have to replace the newowner TID in the user space variable.
+	 * We are here because either:
+	 *
+	 *  - we stole the lock and pi_state->owner needs updating to reflect
+	 *    that (@argowner == current),
+	 *
+	 * or:
+	 *
+	 *  - someone stole our lock and we need to fix things to point to the
+	 *    new owner (@argowner == NULL).
+	 *
+	 * Either way, we have to replace the TID in the user space variable.
 	 * This must be atomic as we have to preserve the owner died bit here.
 	 *
 	 * Note: We write the user space value _before_ changing the pi_state
@@ -2264,6 +2268,39 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 	 * in lookup_pi_state.
 	 */
 retry:
+	if (!argowner) {
+		if (oldowner != current) {
+			/*
+			 * We raced against a concurrent self; things are
+			 * already fixed up. Nothing to do.
+			 */
+			return 0;
+		}
+
+		if (__rt_mutex_futex_trylock(&pi_state->pi_mutex)) {
+			/* We got the lock after all, nothing to fix. */
+			return 0;
+		}
+
+		/*
+		 * Since we just failed the trylock; there must be an owner.
+		 */
+		newowner = rt_mutex_owner(&pi_state->pi_mutex);
+		BUG_ON(!newowner);
+	} else {
+		WARN_ON_ONCE(argowner != current);
+		if (oldowner == current) {
+			/*
+			 * We raced against a concurrent self; things are
+			 * already fixed up. Nothing to do.
+			 */
+			return 0;
+		}
+		newowner = argowner;
+	}
+
+	newtid = task_pid_vnr(newowner) | FUTEX_WAITERS;
+
 	if (get_futex_value_locked(&uval, uaddr))
 		goto handle_fault;
 
@@ -2350,12 +2387,29 @@ static int fixup_owner(u32 __user *uaddr, struct futex_q *q, int locked)
 		/*
 		 * Got the lock. We might not be the anticipated owner if we
 		 * did a lock-steal - fix up the PI-state in that case:
+		 *
+		 * Speculative pi_state->owner read (we don't hold wait_lock);
+		 * since we own the lock pi_state->owner == current is the
+		 * stable state, anything else needs more attention.
 		 */
 		if (q->pi_state->owner != current)
 			ret = fixup_pi_state_owner(uaddr, q, current);
 		goto out;
 	}
 
+	/*
+	 * If we didn't get the lock; check if anybody stole it from us. In
+	 * that case, we need to fix up the uval to point to them instead of
+	 * us, otherwise bad things happen. [10]
+	 *
+	 * Another speculative read; pi_state->owner == current is unstable
+	 * but needs our attention.
+	 */
+	if (q->pi_state->owner == current) {
+		ret = fixup_pi_state_owner(uaddr, q, NULL);
+		goto out;
+	}
+
 	/*
 	 * Paranoia check. If we did not take the lock, then we should not be
 	 * the owner of the rt_mutex.
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index e3dd1642423f8..45d3c9aec8533 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1284,6 +1284,19 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 	return ret;
 }
 
+static inline int __rt_mutex_slowtrylock(struct rt_mutex *lock)
+{
+	int ret = try_to_take_rt_mutex(lock, current, NULL);
+
+	/*
+	 * try_to_take_rt_mutex() sets the lock waiters bit
+	 * unconditionally. Clean this up.
+	 */
+	fixup_rt_mutex_waiters(lock);
+
+	return ret;
+}
+
 /*
  * Slow path try-lock function:
  */
@@ -1305,13 +1318,7 @@ static inline int rt_mutex_slowtrylock(struct rt_mutex *lock)
 	 */
 	raw_spin_lock(&lock->wait_lock);
 
-	ret = try_to_take_rt_mutex(lock, current, NULL);
-
-	/*
-	 * try_to_take_rt_mutex() sets the lock waiters bit
-	 * unconditionally. Clean this up.
-	 */
-	fixup_rt_mutex_waiters(lock);
+	ret = __rt_mutex_slowtrylock(lock);
 
 	raw_spin_unlock(&lock->wait_lock);
 
@@ -1496,6 +1503,11 @@ int __sched rt_mutex_futex_trylock(struct rt_mutex *lock)
 	return rt_mutex_slowtrylock(lock);
 }
 
+int __sched __rt_mutex_futex_trylock(struct rt_mutex *lock)
+{
+	return __rt_mutex_slowtrylock(lock);
+}
+
 /**
  * rt_mutex_timed_lock - lock a rt_mutex interruptible
  *			the timeout structure is provided
diff --git a/kernel/locking/rtmutex_common.h b/kernel/locking/rtmutex_common.h
index cdcaccfb74432..ea7310b9ce83a 100644
--- a/kernel/locking/rtmutex_common.h
+++ b/kernel/locking/rtmutex_common.h
@@ -113,6 +113,7 @@ extern bool rt_mutex_cleanup_proxy_lock(struct rt_mutex *lock,
 				 struct rt_mutex_waiter *waiter);
 extern int rt_mutex_timed_futex_lock(struct rt_mutex *l, struct hrtimer_sleeper *to);
 extern int rt_mutex_futex_trylock(struct rt_mutex *l);
+extern int __rt_mutex_futex_trylock(struct rt_mutex *l);
 
 extern void rt_mutex_futex_unlock(struct rt_mutex *lock);
 extern bool __rt_mutex_futex_unlock(struct rt_mutex *lock,
-- 
2.25.1

