Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E4D30DBA3
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 14:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhBCNqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 08:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbhBCNqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 08:46:31 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE2CC061786
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 05:45:51 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id c127so5262965wmf.5
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 05:45:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6FNiNs5lJeBkWHcEwgaGKVxFwLZYESISi48d/nAi7B0=;
        b=dy6YcRnTIvwFhxdcZuT43NpbGPf7LGpIOS37jhupT4Itan6CM0NW7nqarAhPqDsNM3
         IW5k/IUIS77fa7BgLNfOj5EKe59MpMgAULUg7INgr4h/Do3BH5wKB8Y1lmFjmj/ybzO7
         +1eWg8sjeXH7drEHBBLDmRsrqVmlaJRBXLVIlmHFM1rMX9Hpn7xdhQ/R43u2gJTwFmgb
         O/h8m0yd24DbsgKbIXfQHPKi6dWcpON8wCX/VAiZ5q8Ux+aKyq44tqHyNduAJAj1mClD
         JNz9bZ1LjxcUAbZD4JK34bhwOhcEFWcRPYhFo3zLYfDhXZ1NXYuiWl2da/rjvB/FzX62
         jGFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6FNiNs5lJeBkWHcEwgaGKVxFwLZYESISi48d/nAi7B0=;
        b=clztdXDeT721Zl76Xe2f8Tw1aRqItttFhVDpNu/oRU2AhUmS7q5r0Zaqmg0diOqTL2
         OY6uzJkQhABcKp+iBY4j5g/ZQUHD56AzO2LS1ogmkMfpaGE3vIggvKKmkl379vrBpqdP
         a03Jptmfna2pTdLaY4rHqNn2/UzvXgP00DgU+c/kcRYvQW0GSJbNCMglS3Q7jhUTGCtf
         D5WQzYnSSJKkvlq02zsnCyeinFfKCUVaoJVCQ6FE68PS2Ezj+5uXvJtQj3YSzs+R7c9a
         85OwWCSR5hmH57ACAGKwiV03uYbPby41PomwrPBNl6R/4ze/nxQpi1DbwwsWA7cHAh0A
         h/bQ==
X-Gm-Message-State: AOAM533vCe1eT4nr60ANyguXRUlE3uPlMuufH6CNw6qWz7N5jRlu57hb
        VXfQJUjIXybSGWY9AFvkYEOW+ggnJiTixg==
X-Google-Smtp-Source: ABdhPJyLu5EXAhgXTKvV8kE9Ue4OKJz32zLfMF1w8BJWWQkIOlrI/UwSVmlvyresnWUd1XU2dlfA1A==
X-Received: by 2002:a05:600c:4ec7:: with SMTP id g7mr2873543wmq.56.1612359949525;
        Wed, 03 Feb 2021 05:45:49 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id r124sm2867900wmr.16.2021.02.03.05.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 05:45:48 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>, juri.lelli@arm.com,
        bigeasy@linutronix.de, xlpang@redhat.com, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, jdesfossez@efficios.com,
        dvhart@infradead.org, bristot@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 02/10] futex: Remove rt_mutex_deadlock_account_*()
Date:   Wed,  3 Feb 2021 13:45:31 +0000
Message-Id: <20210203134539.2583943-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203134539.2583943-1-lee.jones@linaro.org>
References: <20210203134539.2583943-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 kernel/locking/rtmutex-debug.c |  9 --------
 kernel/locking/rtmutex-debug.h |  3 ---
 kernel/locking/rtmutex.c       | 42 +++++++++++++---------------------
 kernel/locking/rtmutex.h       |  2 --
 4 files changed, 16 insertions(+), 40 deletions(-)

diff --git a/kernel/locking/rtmutex-debug.c b/kernel/locking/rtmutex-debug.c
index 62b6cee8ea7f9..0613c4b1d0596 100644
--- a/kernel/locking/rtmutex-debug.c
+++ b/kernel/locking/rtmutex-debug.c
@@ -173,12 +173,3 @@ void debug_rt_mutex_init(struct rt_mutex *lock, const char *name)
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
diff --git a/kernel/locking/rtmutex-debug.h b/kernel/locking/rtmutex-debug.h
index d0519c3432b67..b585af9a1b508 100644
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
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index 38e6cd23d2e76..de302c580d65d 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -956,8 +956,6 @@ static int try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
 	 */
 	rt_mutex_set_owner(lock, task);
 
-	rt_mutex_deadlock_account_lock(lock, task);
-
 	return 1;
 }
 
@@ -1365,8 +1363,6 @@ static bool __sched rt_mutex_slowunlock(struct rt_mutex *lock,
 
 	debug_rt_mutex_unlock(lock);
 
-	rt_mutex_deadlock_account_unlock(current);
-
 	/*
 	 * We must be careful here if the fast path is enabled. If we
 	 * have no waiters queued we cannot set owner to NULL here
@@ -1432,11 +1428,10 @@ rt_mutex_fastlock(struct rt_mutex *lock, int state,
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
@@ -1448,21 +1443,19 @@ rt_mutex_timed_fastlock(struct rt_mutex *lock, int state,
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
 
@@ -1472,19 +1465,18 @@ rt_mutex_fastunlock(struct rt_mutex *lock,
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
@@ -1682,7 +1674,6 @@ void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
 	__rt_mutex_init(lock, NULL);
 	debug_rt_mutex_proxy_lock(lock, proxy_owner);
 	rt_mutex_set_owner(lock, proxy_owner);
-	rt_mutex_deadlock_account_lock(lock, proxy_owner);
 }
 
 /**
@@ -1698,7 +1689,6 @@ void rt_mutex_proxy_unlock(struct rt_mutex *lock,
 {
 	debug_rt_mutex_proxy_unlock(lock);
 	rt_mutex_set_owner(lock, NULL);
-	rt_mutex_deadlock_account_unlock(proxy_owner);
 }
 
 /**
diff --git a/kernel/locking/rtmutex.h b/kernel/locking/rtmutex.h
index c4060584c4076..6607802efa8bd 100644
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
-- 
2.25.1

