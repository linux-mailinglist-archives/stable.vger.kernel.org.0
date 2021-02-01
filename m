Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6255A30A4DC
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 11:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbhBAKDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 05:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232893AbhBAKDd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 05:03:33 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FB9C06178B
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 02:02:21 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id y187so12623279wmd.3
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 02:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H8SGnzV5I3ZFHFe8hRMUykXFpl/MX53xmNixUdziUtA=;
        b=Wq8MoyoHM/kx+Ta2dRX15xYcAFJvW0RSFkP/xCs1VUuI1u4tI21qsaJxKYQ+xld60s
         Q27H7xMWNt8uF6+VwtBDc/osF9mWasBknWc8Lz3WiE9b2SeY8fyGP+eIH4ZcC/GAeX25
         pZw2h7VWZHPo5Y1H9q6iPaWOds6KIKK5WZ2Awm/2TcWeWaanAsoRa4YoTLnrm786wxiq
         fiV56cdA+Om8sAzghF9zMBbN20mV3IG4ycd/lqWpXSdb3SU5QrHnzb4XbQ9g+kGokvcF
         udQy9tu5UrCD/WPbXUDNAxX6lKe/+oUzzXgnpgmyyvVxiJ88zicZ2lFgYMygRvPauudE
         KcYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H8SGnzV5I3ZFHFe8hRMUykXFpl/MX53xmNixUdziUtA=;
        b=jRVUV4KEPb/JMn9DzoJZNKlP8+xCRq23+hRTLDK/Ve8mpOaMu+rmYYZd+rfZPkSdWE
         4AHgO7iSuJnd/1FvbS4Drh5v7sRhR3nhclARPeP5rpxo0FP6pJH+gaHFX7eDYeHmiMDp
         bnoaPxZVh8VXeDs5ULRyjs2ow9vhwRW55f2XcO1pBU0dW/dzXxuSjyD7x+HpR//tDf8L
         fBJ4tsq+oMwJFHVXvrHU5QwSDxNHsKenzDCoq/bjrr3zsa8j5/D0PZeNo75QM88UOTUa
         /Lpem2sXAOgrY4FLJ1N4PTcWaPokYMxXsrLQcigDuudcg465h72mCpF2ftjFZQNYoaNx
         GMPw==
X-Gm-Message-State: AOAM531vIlHZElbNkjp8yIOvur5HQKP69eCnSvu6UrJBRWSpLco0F+sv
        MH79cBD52gG4Dwk76PuD6gm9iRLVRaJd1fg9
X-Google-Smtp-Source: ABdhPJw9yaz0cOlLOKCwrV2l8IxCKhpknyz1v8hY0syz+yZpx56Ip09WD7T4MjT6LBP7ge9criJuJg==
X-Received: by 2002:a05:600c:4f50:: with SMTP id m16mr14036164wmq.175.1612173738875;
        Mon, 01 Feb 2021 02:02:18 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id p15sm26151387wrt.15.2021.02.01.02.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 02:02:18 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 07/12] futex: Mark the begin of futex exit explicitly
Date:   Mon,  1 Feb 2021 10:01:38 +0000
Message-Id: <20210201100143.2028618-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201100143.2028618-1-lee.jones@linaro.org>
References: <20210201100143.2028618-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 18f694385c4fd77a09851fd301236746ca83f3cb upstream.

Instead of relying on PF_EXITING use an explicit state for the futex exit
and set it in the futex exit function. This moves the smp barrier and the
lock/unlock serialization into the futex code.

As with the DEAD state this is restricted to the exit path as exec
continues to use the same task struct.

This allows to simplify that logic in a next step.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20191106224556.539409004@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/linux/futex.h | 31 +++----------------------------
 kernel/exit.c         | 12 +-----------
 kernel/futex.c        | 37 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/include/linux/futex.h b/include/linux/futex.h
index 063a5cd00d770..805508373fcea 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -57,6 +57,7 @@ union futex_key {
 #ifdef CONFIG_FUTEX
 enum {
 	FUTEX_STATE_OK,
+	FUTEX_STATE_EXITING,
 	FUTEX_STATE_DEAD,
 };
 
@@ -71,33 +72,7 @@ static inline void futex_init_task(struct task_struct *tsk)
 	tsk->futex_state = FUTEX_STATE_OK;
 }
 
-/**
- * futex_exit_done - Sets the tasks futex state to FUTEX_STATE_DEAD
- * @tsk:	task to set the state on
- *
- * Set the futex exit state of the task lockless. The futex waiter code
- * observes that state when a task is exiting and loops until the task has
- * actually finished the futex cleanup. The worst case for this is that the
- * waiter runs through the wait loop until the state becomes visible.
- *
- * This has two callers:
- *
- * - futex_mm_release() after the futex exit cleanup has been done
- *
- * - do_exit() from the recursive fault handling path.
- *
- * In case of a recursive fault this is best effort. Either the futex exit
- * code has run already or not. If the OWNER_DIED bit has been set on the
- * futex then the waiter can take it over. If not, the problem is pushed
- * back to user space. If the futex exit code did not run yet, then an
- * already queued waiter might block forever, but there is nothing which
- * can be done about that.
- */
-static inline void futex_exit_done(struct task_struct *tsk)
-{
-	tsk->futex_state = FUTEX_STATE_DEAD;
-}
-
+void futex_exit_recursive(struct task_struct *tsk);
 void futex_exit_release(struct task_struct *tsk);
 void futex_exec_release(struct task_struct *tsk);
 
@@ -105,7 +80,7 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 	      u32 __user *uaddr2, u32 val2, u32 val3);
 #else
 static inline void futex_init_task(struct task_struct *tsk) { }
-static inline void futex_exit_done(struct task_struct *tsk) { }
+static inline void futex_exit_recursive(struct task_struct *tsk) { }
 static inline void futex_exit_release(struct task_struct *tsk) { }
 static inline void futex_exec_release(struct task_struct *tsk) { }
 #endif
diff --git a/kernel/exit.c b/kernel/exit.c
index e87ab2ec654bc..8716f0780fe3d 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -785,22 +785,12 @@ void __noreturn do_exit(long code)
 	 */
 	if (unlikely(tsk->flags & PF_EXITING)) {
 		pr_alert("Fixing recursive fault but reboot is needed!\n");
-		futex_exit_done(tsk);
+		futex_exit_recursive(tsk);
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule();
 	}
 
 	exit_signals(tsk);  /* sets PF_EXITING */
-	/*
-	 * Ensure that all new tsk->pi_lock acquisitions must observe
-	 * PF_EXITING. Serializes against futex.c:attach_to_pi_owner().
-	 */
-	smp_mb();
-	/*
-	 * Ensure that we must observe the pi_state in exit_mm() ->
-	 * mm_release() -> exit_pi_state_list().
-	 */
-	raw_spin_unlock_wait(&tsk->pi_lock);
 
 	/* sync mm's RSS info before statistics gathering */
 	if (tsk->mm)
diff --git a/kernel/futex.c b/kernel/futex.c
index e8322c3208a44..482000996b983 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3287,10 +3287,45 @@ void futex_exec_release(struct task_struct *tsk)
 		exit_pi_state_list(tsk);
 }
 
+/**
+ * futex_exit_recursive - Set the tasks futex state to FUTEX_STATE_DEAD
+ * @tsk:	task to set the state on
+ *
+ * Set the futex exit state of the task lockless. The futex waiter code
+ * observes that state when a task is exiting and loops until the task has
+ * actually finished the futex cleanup. The worst case for this is that the
+ * waiter runs through the wait loop until the state becomes visible.
+ *
+ * This is called from the recursive fault handling path in do_exit().
+ *
+ * This is best effort. Either the futex exit code has run already or
+ * not. If the OWNER_DIED bit has been set on the futex then the waiter can
+ * take it over. If not, the problem is pushed back to user space. If the
+ * futex exit code did not run yet, then an already queued waiter might
+ * block forever, but there is nothing which can be done about that.
+ */
+void futex_exit_recursive(struct task_struct *tsk)
+{
+	tsk->futex_state = FUTEX_STATE_DEAD;
+}
+
 void futex_exit_release(struct task_struct *tsk)
 {
+	tsk->futex_state = FUTEX_STATE_EXITING;
+	/*
+	 * Ensure that all new tsk->pi_lock acquisitions must observe
+	 * FUTEX_STATE_EXITING. Serializes against attach_to_pi_owner().
+	 */
+	smp_mb();
+	/*
+	 * Ensure that we must observe the pi_state in exit_pi_state_list().
+	 */
+	raw_spin_lock_irq(&tsk->pi_lock);
+	raw_spin_unlock_irq(&tsk->pi_lock);
+
 	futex_exec_release(tsk);
-	futex_exit_done(tsk);
+
+	tsk->futex_state = FUTEX_STATE_DEAD;
 }
 
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
-- 
2.25.1

