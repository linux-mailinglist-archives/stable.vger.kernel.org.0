Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85A8318721
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 10:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhBKJaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 04:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbhBKJ2O (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 04:28:14 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9492C06178B
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 01:27:28 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id w4so4775582wmi.4
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 01:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CxJjMXkMj/WyIEge7vE6JXU1t1YR/vT3MHOJ75WJKbg=;
        b=MP5Ab8cgakCP4eYLpA3NexSZkhYH29ZLk5DAd1LojwAt8he8j7sWlmhbtLRrJR3tjR
         J7Zp3E65m52drtm9s/if8lfD2KMahbAkr4+Czhnz2zcuYdSqFQ524hHI4bm5FoA+5KeN
         0Y9yutoN9qQX9Cmvc5+DsCai5MEV8AuNTb0P8zW/cfS35oN/47gGQwLe3cZ2m6JjCH0Y
         Jgsx1cqfnn8J4PKPWC2yBIo94TnhXBK/lvYQmc2W3oqItex/xV19aYM9QMAGhVyo//UR
         SmK7a/1W3wDSJe7vDIIW55olJ63lzBCVj8ep1UUwApxZng5Htn2fxRtCEkWNizLaW4jx
         aFtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CxJjMXkMj/WyIEge7vE6JXU1t1YR/vT3MHOJ75WJKbg=;
        b=Uy9usiQ7g+PT1nHnX4dar6RI8SYWBS8g1X8MJtWLLb1zQW5gaQf+qhd8kpU6yjyboW
         tAcUr+vEU8+9L9biHow2WnXwJInxsueu97YYFjumFF/icsSuOFbUQuINkNBD5UOdkL9o
         DA2ZZQ3ZczA31jh6OfAoy3djpC2qyhog2VKXOjZcqhcoZet8Zgbg9rASA9/N8+/yEyav
         K6BRYQPfMJQdPzCWbGv48EWuhf+m6EtaOrGmc4MVyeOEsv1X61HeRgoP5X8HgPZelg+0
         UNx4OfED1O17rQT7a7stPTovj2swZzWCSMlgG2Sy21spxH9+dwSL96e7sg+o1veY++Qs
         cRaw==
X-Gm-Message-State: AOAM531uqHVnnST28UtQ7x4W6WaBLJCCvfDhIyEyZi0Spu8+epH++UMT
        1OUicHpGl6WpirA9jVCSzL2T6Ls+o5FKhw==
X-Google-Smtp-Source: ABdhPJzB8iEkW1VqnucqbMVW9KqhYqSpNqodp0+2aBilAx6d2LIVBZk+IXFM3mN0Htey8rhTK2XhRA==
X-Received: by 2002:a7b:c193:: with SMTP id y19mr4132390wmi.23.1613035647285;
        Thu, 11 Feb 2021 01:27:27 -0800 (PST)
Received: from dell.default ([91.110.221.159])
        by smtp.gmail.com with ESMTPSA id y5sm8335124wmi.10.2021.02.11.01.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 01:27:26 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     zhengyejian@foxmail.com, Peter Zijlstra <peterz@infradead.org>,
        juri.lelli@arm.com, bigeasy@linutronix.de, xlpang@redhat.com,
        rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        jdesfossez@efficios.com, dvhart@infradead.org, bristot@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 2/3] futex: Change locking rules
Date:   Thu, 11 Feb 2021 09:26:59 +0000
Message-Id: <20210211092700.11772-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211092700.11772-1-lee.jones@linaro.org>
References: <20210211092700.11772-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

Currently futex-pi relies on hb->lock to serialize everything. But hb->lock
creates another set of problems, especially priority inversions on RT where
hb->lock becomes a rt_mutex itself.

The rt_mutex::wait_lock is the most obvious protection for keeping the
futex user space value and the kernel internal pi_state in sync.

Rework and document the locking so rt_mutex::wait_lock is held accross all
operations which modify the user space value and the pi state.

This allows to invoke rt_mutex_unlock() (including deboost) without holding
hb->lock as a next step.

Nothing yet relies on the new locking rules.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: juri.lelli@arm.com
Cc: bigeasy@linutronix.de
Cc: xlpang@redhat.com
Cc: rostedt@goodmis.org
Cc: mathieu.desnoyers@efficios.com
Cc: jdesfossez@efficios.com
Cc: dvhart@infradead.org
Cc: bristot@redhat.com
Link: http://lkml.kernel.org/r/20170322104151.751993333@infradead.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[Lee: Back-ported in support of a previous futex back-port attempt]
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 kernel/futex.c | 138 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 112 insertions(+), 26 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index a43cf67c2fe91..829e897c8883b 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1019,6 +1019,39 @@ static void exit_pi_state_list(struct task_struct *curr)
  * [10] There is no transient state which leaves owner and user space
  *	TID out of sync. Except one error case where the kernel is denied
  *	write access to the user address, see fixup_pi_state_owner().
+ *
+ *
+ * Serialization and lifetime rules:
+ *
+ * hb->lock:
+ *
+ *	hb -> futex_q, relation
+ *	futex_q -> pi_state, relation
+ *
+ *	(cannot be raw because hb can contain arbitrary amount
+ *	 of futex_q's)
+ *
+ * pi_mutex->wait_lock:
+ *
+ *	{uval, pi_state}
+ *
+ *	(and pi_mutex 'obviously')
+ *
+ * p->pi_lock:
+ *
+ *	p->pi_state_list -> pi_state->list, relation
+ *
+ * pi_state->refcount:
+ *
+ *	pi_state lifetime
+ *
+ *
+ * Lock order:
+ *
+ *   hb->lock
+ *     pi_mutex->wait_lock
+ *       p->pi_lock
+ *
  */
 
 /*
@@ -1026,10 +1059,12 @@ static void exit_pi_state_list(struct task_struct *curr)
  * the pi_state against the user space value. If correct, attach to
  * it.
  */
-static int attach_to_pi_state(u32 uval, struct futex_pi_state *pi_state,
+static int attach_to_pi_state(u32 __user *uaddr, u32 uval,
+			      struct futex_pi_state *pi_state,
 			      struct futex_pi_state **ps)
 {
 	pid_t pid = uval & FUTEX_TID_MASK;
+	int ret, uval2;
 
 	/*
 	 * Userspace might have messed up non-PI and PI futexes [3]
@@ -1037,8 +1072,33 @@ static int attach_to_pi_state(u32 uval, struct futex_pi_state *pi_state,
 	if (unlikely(!pi_state))
 		return -EINVAL;
 
+	/*
+	 * We get here with hb->lock held, and having found a
+	 * futex_top_waiter(). This means that futex_lock_pi() of said futex_q
+	 * has dropped the hb->lock in between queue_me() and unqueue_me_pi(),
+	 * which in turn means that futex_lock_pi() still has a reference on
+	 * our pi_state.
+	 */
 	WARN_ON(!atomic_read(&pi_state->refcount));
 
+	/*
+	 * Now that we have a pi_state, we can acquire wait_lock
+	 * and do the state validation.
+	 */
+	raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
+
+	/*
+	 * Since {uval, pi_state} is serialized by wait_lock, and our current
+	 * uval was read without holding it, it can have changed. Verify it
+	 * still is what we expect it to be, otherwise retry the entire
+	 * operation.
+	 */
+	if (get_futex_value_locked(&uval2, uaddr))
+		goto out_efault;
+
+	if (uval != uval2)
+		goto out_eagain;
+
 	/*
 	 * Handle the owner died case:
 	 */
@@ -1054,11 +1114,11 @@ static int attach_to_pi_state(u32 uval, struct futex_pi_state *pi_state,
 			 * is not 0. Inconsistent state. [5]
 			 */
 			if (pid)
-				return -EINVAL;
+				goto out_einval;
 			/*
 			 * Take a ref on the state and return success. [4]
 			 */
-			goto out_state;
+			goto out_attach;
 		}
 
 		/*
@@ -1070,14 +1130,14 @@ static int attach_to_pi_state(u32 uval, struct futex_pi_state *pi_state,
 		 * Take a ref on the state and return success. [6]
 		 */
 		if (!pid)
-			goto out_state;
+			goto out_attach;
 	} else {
 		/*
 		 * If the owner died bit is not set, then the pi_state
 		 * must have an owner. [7]
 		 */
 		if (!pi_state->owner)
-			return -EINVAL;
+			goto out_einval;
 	}
 
 	/*
@@ -1086,11 +1146,29 @@ static int attach_to_pi_state(u32 uval, struct futex_pi_state *pi_state,
 	 * user space TID. [9/10]
 	 */
 	if (pid != task_pid_vnr(pi_state->owner))
-		return -EINVAL;
-out_state:
+		goto out_einval;
+
+out_attach:
 	atomic_inc(&pi_state->refcount);
+	raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
 	*ps = pi_state;
 	return 0;
+
+out_einval:
+	ret = -EINVAL;
+	goto out_error;
+
+out_eagain:
+	ret = -EAGAIN;
+	goto out_error;
+
+out_efault:
+	ret = -EFAULT;
+	goto out_error;
+
+out_error:
+	raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
+	return ret;
 }
 
 /**
@@ -1183,6 +1261,9 @@ static int attach_to_pi_owner(u32 uval, union futex_key *key,
 
 	/*
 	 * No existing pi state. First waiter. [2]
+	 *
+	 * This creates pi_state, we have hb->lock held, this means nothing can
+	 * observe this state, wait_lock is irrelevant.
 	 */
 	pi_state = alloc_pi_state();
 
@@ -1207,7 +1288,8 @@ static int attach_to_pi_owner(u32 uval, union futex_key *key,
 	return 0;
 }
 
-static int lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
+static int lookup_pi_state(u32 __user *uaddr, u32 uval,
+			   struct futex_hash_bucket *hb,
 			   union futex_key *key, struct futex_pi_state **ps,
 			   struct task_struct **exiting)
 {
@@ -1218,7 +1300,7 @@ static int lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
 	 * attach to the pi_state when the validation succeeds.
 	 */
 	if (match)
-		return attach_to_pi_state(uval, match->pi_state, ps);
+		return attach_to_pi_state(uaddr, uval, match->pi_state, ps);
 
 	/*
 	 * We are the first waiter - try to look up the owner based on
@@ -1237,7 +1319,7 @@ static int lock_pi_update_atomic(u32 __user *uaddr, u32 uval, u32 newval)
 	if (unlikely(cmpxchg_futex_value_locked(&curval, uaddr, uval, newval)))
 		return -EFAULT;
 
-	/*If user space value changed, let the caller retry */
+	/* If user space value changed, let the caller retry */
 	return curval != uval ? -EAGAIN : 0;
 }
 
@@ -1301,7 +1383,7 @@ static int futex_lock_pi_atomic(u32 __user *uaddr, struct futex_hash_bucket *hb,
 	 */
 	match = futex_top_waiter(hb, key);
 	if (match)
-		return attach_to_pi_state(uval, match->pi_state, ps);
+		return attach_to_pi_state(uaddr, uval, match->pi_state, ps);
 
 	/*
 	 * No waiter and user TID is 0. We are here because the
@@ -1441,6 +1523,7 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this,
 
 	if (cmpxchg_futex_value_locked(&curval, uaddr, uval, newval)) {
 		ret = -EFAULT;
+
 	} else if (curval != uval) {
 		/*
 		 * If a unconditional UNLOCK_PI operation (user space did not
@@ -1977,7 +2060,7 @@ static int futex_requeue(u32 __user *uaddr1, unsigned int flags,
 			 * If that call succeeds then we have pi_state and an
 			 * initial refcount on it.
 			 */
-			ret = lookup_pi_state(ret, hb2, &key2,
+			ret = lookup_pi_state(uaddr2, ret, hb2, &key2,
 					      &pi_state, &exiting);
 		}
 
@@ -2282,7 +2365,6 @@ static int __fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 	int err = 0;
 
 	oldowner = pi_state->owner;
-
 	/* Owner died? */
 	if (!pi_state->owner)
 		newtid |= FUTEX_OWNER_DIED;
@@ -2305,11 +2387,10 @@ static int __fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 	 * because we can fault here. Imagine swapped out pages or a fork
 	 * that marked all the anonymous memory readonly for cow.
 	 *
-	 * Modifying pi_state _before_ the user space value would
-	 * leave the pi_state in an inconsistent state when we fault
-	 * here, because we need to drop the hash bucket lock to
-	 * handle the fault. This might be observed in the PID check
-	 * in lookup_pi_state.
+	 * Modifying pi_state _before_ the user space value would leave the
+	 * pi_state in an inconsistent state when we fault here, because we
+	 * need to drop the locks to handle the fault. This might be observed
+	 * in the PID check in lookup_pi_state.
 	 */
 retry:
 	if (!argowner) {
@@ -2367,21 +2448,26 @@ static int __fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 	return argowner == current;
 
 	/*
-	 * To handle the page fault we need to drop the hash bucket
-	 * lock here. That gives the other task (either the highest priority
-	 * waiter itself or the task which stole the rtmutex) the
-	 * chance to try the fixup of the pi_state. So once we are
-	 * back from handling the fault we need to check the pi_state
-	 * after reacquiring the hash bucket lock and before trying to
-	 * do another fixup. When the fixup has been done already we
-	 * simply return.
+	 * To handle the page fault we need to drop the locks here. That gives
+	 * the other task (either the highest priority waiter itself or the
+	 * task which stole the rtmutex) the chance to try the fixup of the
+	 * pi_state. So once we are back from handling the fault we need to
+	 * check the pi_state after reacquiring the locks and before trying to
+	 * do another fixup. When the fixup has been done already we simply
+	 * return.
+	 *
+	 * Note: we hold both hb->lock and pi_mutex->wait_lock. We can safely
+	 * drop hb->lock since the caller owns the hb -> futex_q relation.
+	 * Dropping the pi_mutex->wait_lock requires the state revalidate.
 	 */
 handle_fault:
+	raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
 	spin_unlock(q->lock_ptr);
 
 	err = fault_in_user_writeable(uaddr);
 
 	spin_lock(q->lock_ptr);
+	raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
 
 	/*
 	 * Check if someone else fixed it for us:
-- 
2.25.1

