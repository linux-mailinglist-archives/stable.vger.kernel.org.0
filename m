Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F00030F9BA
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 18:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238579AbhBDRbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 12:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238519AbhBDR3v (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 12:29:51 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297ADC06178B
        for <stable@vger.kernel.org>; Thu,  4 Feb 2021 09:29:11 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id c127so3682961wmf.5
        for <stable@vger.kernel.org>; Thu, 04 Feb 2021 09:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Wf5g1tBsiAuXWWCi8IkrUKPbvvUqMLHqfwWU02yQBFw=;
        b=yt9iTqx9dfQKksFWrw/IwVn2S2Xa2eBB9TNBrZchb49oUDjjQI6oBGzYH8WF3FOetV
         UOXsm395cG+TyTqbvV1xY8eCalGeMEUZ934tkbBUXODTAIz3zCK6tds6E+l1fz9piswG
         AVV/M186yrTJjgdoK2XkHS0dHV+8fVdgEI4CdJUocSzQzaRZz6yuvEdPWpI50wNQmcOM
         zI8CpNLxHdAnb4TyhGAa7wsypcVWrbfyY1uUfRhSLnbu3l1ZrbPwAmZMKcdP21JPa195
         k+BPZ5u1f32Qrod23nYlFDnJV2wHnyUe0jNM5M/H2TNhfBNhWrByFDsg1JToHGmTXoho
         FYDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wf5g1tBsiAuXWWCi8IkrUKPbvvUqMLHqfwWU02yQBFw=;
        b=C+HufJkyfM/cPhkBxIwASlLGZ5X9gfEqliItmWA+f7uEeXGd8C21p68wTiqOY1Vpno
         U3mUjXD4wIC16lsCZGsbJlsBz2m62DXPhcVBylAVJxYqNUrGHDzldTiU6RGNH6eQ1Kzx
         WKIHgFWPfjd/31iQABLg1bWDi7JQPe1+G+RsYFRUky5CvVwKvb/VCT6mISXuS7cKnsxE
         3iitPqsN1TSaxneRZvN+jLF1smW8jlR+IVR9D5UM4FawUvjZOzgbHT5fBj6vp/eOND6h
         o/KYutuS5kJ9tqYUKCcdcG3fVWnXsnTqIuq7DLm+hUQkc2tpcERsU5FkdSM8ItlgMPX1
         j4kQ==
X-Gm-Message-State: AOAM5323M2NKCV48DLa9tBzX5F0pHcxQqGGPwVGlHGPlwI7P97Ts2uKn
        KjCMhpDIrnznMPBcME8gyic8dG4/Ps5qrA==
X-Google-Smtp-Source: ABdhPJxBZBFrBuSwiWR707KzTn7wNAxko55jTTwY9F45s1u15/ogVVp+AA5KpIcqWtRoh2XLjsRVFQ==
X-Received: by 2002:a7b:c5cc:: with SMTP id n12mr206107wmk.123.1612459749560;
        Thu, 04 Feb 2021 09:29:09 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id j7sm9641334wrp.72.2021.02.04.09.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 09:29:08 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>, juri.lelli@arm.com,
        bigeasy@linutronix.de, xlpang@redhat.com, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, jdesfossez@efficios.com,
        dvhart@infradead.org, bristot@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 02/10] futex: Remove rt_mutex_deadlock_account_*()
Date:   Thu,  4 Feb 2021 17:28:55 +0000
Message-Id: <20210204172903.2860981-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204172903.2860981-1-lee.jones@linaro.org>
References: <20210204172903.2860981-1-lee.jones@linaro.org>
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
index 3323ef935372f..e3dd1642423f8 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -937,8 +937,6 @@ takeit:
 	 */
 	rt_mutex_set_owner(lock, task);
 
-	rt_mutex_deadlock_account_lock(lock, task);
-
 	return 1;
 }
 
@@ -1331,8 +1329,6 @@ static bool __sched rt_mutex_slowunlock(struct rt_mutex *lock,
 
 	debug_rt_mutex_unlock(lock);
 
-	rt_mutex_deadlock_account_unlock(current);
-
 	/*
 	 * We must be careful here if the fast path is enabled. If we
 	 * have no waiters queued we cannot set owner to NULL here
@@ -1398,11 +1394,10 @@ rt_mutex_fastlock(struct rt_mutex *lock, int state,
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
@@ -1414,21 +1409,19 @@ rt_mutex_timed_fastlock(struct rt_mutex *lock, int state,
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
 
@@ -1438,19 +1431,18 @@ rt_mutex_fastunlock(struct rt_mutex *lock,
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
@@ -1648,7 +1640,6 @@ void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
 	__rt_mutex_init(lock, NULL);
 	debug_rt_mutex_proxy_lock(lock, proxy_owner);
 	rt_mutex_set_owner(lock, proxy_owner);
-	rt_mutex_deadlock_account_lock(lock, proxy_owner);
 }
 
 /**
@@ -1664,7 +1655,6 @@ void rt_mutex_proxy_unlock(struct rt_mutex *lock,
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

