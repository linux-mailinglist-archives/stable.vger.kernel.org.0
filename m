Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC51630FA1B
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 18:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238456AbhBDRqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 12:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238522AbhBDRaK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 12:30:10 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA5AC06178C
        for <stable@vger.kernel.org>; Thu,  4 Feb 2021 09:29:12 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id l12so4525179wry.2
        for <stable@vger.kernel.org>; Thu, 04 Feb 2021 09:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t1Tdhu9sPTY73dg7/Bf+eqje/Zu+kzB0VXGmoviIFF4=;
        b=EKiI2lzv+CAJcOpp0AeAe/WMXEeawAjECzkvWSdJ6WsxFSTiBHWsOUvaZv7FlEUivd
         SzA0rypFDIcCo/Gdn+fr35Y6spj/1R+wCumlFLM07BQtBgRdP884Qu7XKDsv4Cj5TgnX
         GxrdUH5vATme9cks1F/CfDZUUy5N5i4PftM6uboozqMG5jxNwOO2uzRwxGHKSGnoJlNK
         npeFVWKCVLjdsQNgJIzpvxMUmZAG+tN4KdrSrBv5zv4rC+wH63lmxxUtEapYi7d1eXLc
         oPC4e9eSZmIoRraOTwH+oV2QrLK3hIs2/jktxZFjLF+KWJ0JRFZOnTpdiKo0sbFY64oM
         nddg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t1Tdhu9sPTY73dg7/Bf+eqje/Zu+kzB0VXGmoviIFF4=;
        b=IQfMcsuR2F9l2WXd0jHN/nsryAx/jrOHSuoSraohF2SidK5qem11JB0Y3mlLypQJdy
         dsXdP6+cHjnEHR/gFEyf1QELU8e8IhoPhckF6+n8SWTYou094y/18euF6l4QTdYTy2UK
         JMUvrmynTi3RAl4pGkZYp2zh9rl4d3n6W1CstjvHLEg4n6OBZ412kjuU6tNmEHSV4lQB
         eBmFwOmM0gUxjZOEPwv20bmXfLQ8kT7kp83wjp2FFaxc9cekbU0zAb0YIGmF/ToA5yyV
         JhbtRjlqna52Zek0T89Q2implXAiSI+fQbygq7HWraoVfHc+a2y8NBWTPPWQAqbvzoZm
         9KBA==
X-Gm-Message-State: AOAM533RPquJ0iiKUzis7rXzdPwcT7UJVFp2mst4lEwR7d5/prLmq08q
        byqlFYyO9sngBZ/0/nwPHjeftYwqx5oiyw==
X-Google-Smtp-Source: ABdhPJw+FprIzNZEb5sSaYJiGLZ8QmWZnZt6iDh14VDaq4kO5REFu3aop+wI0Yh31TWn5loG/pCYfA==
X-Received: by 2002:adf:f606:: with SMTP id t6mr456334wrp.360.1612459751182;
        Thu, 04 Feb 2021 09:29:11 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id j7sm9641334wrp.72.2021.02.04.09.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 09:29:10 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>, juri.lelli@arm.com,
        bigeasy@linutronix.de, xlpang@redhat.com, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, jdesfossez@efficios.com,
        dvhart@infradead.org, bristot@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 03/10] futex: Rework inconsistent rt_mutex/futex_q state
Date:   Thu,  4 Feb 2021 17:28:56 +0000
Message-Id: <20210204172903.2860981-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204172903.2860981-1-lee.jones@linaro.org>
References: <20210204172903.2860981-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[Upstream commit 73d786bd043ebc855f349c81ea805f6b11cbf2aa ]

There is a weird state in the futex_unlock_pi() path when it interleaves
with a concurrent futex_lock_pi() at the point where it drops hb->lock.

In this case, it can happen that the rt_mutex wait_list and the futex_q
disagree on pending waiters, in particular rt_mutex will find no pending
waiters where futex_q thinks there are. In this case the rt_mutex unlock
code cannot assign an owner.

The futex side fixup code has to cleanup the inconsistencies with quite a
bunch of interesting corner cases.

Simplify all this by changing wake_futex_pi() to return -EAGAIN when this
situation occurs. This then gives the futex_lock_pi() code the opportunity
to continue and the retried futex_unlock_pi() will now observe a coherent
state.

The only problem is that this breaks RT timeliness guarantees. That
is, consider the following scenario:

  T1 and T2 are both pinned to CPU0. prio(T2) > prio(T1)

    CPU0

    T1
      lock_pi()
      queue_me()  <- Waiter is visible

    preemption

    T2
      unlock_pi()
	loops with -EAGAIN forever

Which is undesirable for PI primitives. Future patches will rectify
this.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: juri.lelli@arm.com
Cc: bigeasy@linutronix.de
Cc: xlpang@redhat.com
Cc: rostedt@goodmis.org
Cc: mathieu.desnoyers@efficios.com
Cc: jdesfossez@efficios.com
Cc: dvhart@infradead.org
Cc: bristot@redhat.com
Link: http://lkml.kernel.org/r/20170322104151.850383690@infradead.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[Lee: Back-ported to solve a dependency]
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 kernel/futex.c | 50 ++++++++++++++------------------------------------
 1 file changed, 14 insertions(+), 36 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 00b474b4b54e0..a5a91a55c451f 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1389,12 +1389,19 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this,
 	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
 
 	/*
-	 * It is possible that the next waiter (the one that brought
-	 * this owner to the kernel) timed out and is no longer
-	 * waiting on the lock.
+	 * When we interleave with futex_lock_pi() where it does
+	 * rt_mutex_timed_futex_lock(), we might observe @this futex_q waiter,
+	 * but the rt_mutex's wait_list can be empty (either still, or again,
+	 * depending on which side we land).
+	 *
+	 * When this happens, give up our locks and try again, giving the
+	 * futex_lock_pi() instance time to complete, either by waiting on the
+	 * rtmutex or removing itself from the futex queue.
 	 */
-	if (!new_owner)
-		new_owner = this->task;
+	if (!new_owner) {
+		raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
+		return -EAGAIN;
+	}
 
 	/*
 	 * We pass it to the next owner. The WAITERS bit is always
@@ -2337,7 +2344,6 @@ static long futex_wait_restart(struct restart_block *restart);
  */
 static int fixup_owner(u32 __user *uaddr, struct futex_q *q, int locked)
 {
-	struct task_struct *owner;
 	int ret = 0;
 
 	if (locked) {
@@ -2350,44 +2356,16 @@ static int fixup_owner(u32 __user *uaddr, struct futex_q *q, int locked)
 		goto out;
 	}
 
-	/*
-	 * Catch the rare case, where the lock was released when we were on the
-	 * way back before we locked the hash bucket.
-	 */
-	if (q->pi_state->owner == current) {
-		/*
-		 * Try to get the rt_mutex now. This might fail as some other
-		 * task acquired the rt_mutex after we removed ourself from the
-		 * rt_mutex waiters list.
-		 */
-		if (rt_mutex_futex_trylock(&q->pi_state->pi_mutex)) {
-			locked = 1;
-			goto out;
-		}
-
-		/*
-		 * pi_state is incorrect, some other task did a lock steal and
-		 * we returned due to timeout or signal without taking the
-		 * rt_mutex. Too late.
-		 */
-		raw_spin_lock(&q->pi_state->pi_mutex.wait_lock);
-		owner = rt_mutex_owner(&q->pi_state->pi_mutex);
-		if (!owner)
-			owner = rt_mutex_next_owner(&q->pi_state->pi_mutex);
-		raw_spin_unlock(&q->pi_state->pi_mutex.wait_lock);
-		ret = fixup_pi_state_owner(uaddr, q, owner);
-		goto out;
-	}
-
 	/*
 	 * Paranoia check. If we did not take the lock, then we should not be
 	 * the owner of the rt_mutex.
 	 */
-	if (rt_mutex_owner(&q->pi_state->pi_mutex) == current)
+	if (rt_mutex_owner(&q->pi_state->pi_mutex) == current) {
 		printk(KERN_ERR "fixup_owner: ret = %d pi-mutex: %p "
 				"pi-state %p\n", ret,
 				q->pi_state->pi_mutex.owner,
 				q->pi_state->owner);
+	}
 
 out:
 	return ret ? ret : locked;
-- 
2.25.1

