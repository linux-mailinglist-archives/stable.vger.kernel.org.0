Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A2A30AAC8
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 16:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbhBAPO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 10:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbhBAPOz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 10:14:55 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C5BC06178B
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 07:13:43 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id z6so16909593wrq.10
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 07:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QzQj1EdG176w+bcW/LUmQ/cOr3Onvdscuk/WhMM2DZg=;
        b=xQgq5dWOnqZGP4Cwr00PBH50Nqo2h5cQTfJiDLh4MArixKV0YGdCU8DEuN02AB5M+K
         R4/1G2+7iQACv35wdiRHwrpH/KCvllQXF7KH4afBp1fRQtycOgRK9kNggF6OG4HHwayj
         ZA/QxbB+vlbOuMBsQ72jYG0t+iyGm2IY+rWZusY6NFJIeEUT+DdOU6VrpCggJeYXLvzb
         UpMBDhWqgKjLofEarjn1TuGznQjTHIf9ad3XcVhGIrdZ0AVM/25Q94+o9gnDV94mAUxt
         g9bxeISDp4eHQwfmyILTspyNg6UAbc7Q23Dam1zP6J5OhcEEC32qYrb9U2vWqHsnbpF3
         uBxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QzQj1EdG176w+bcW/LUmQ/cOr3Onvdscuk/WhMM2DZg=;
        b=isjRxU4CdEWSBGPlKvlo9d+qV/u4eT7Ook8/5rHCSRoVwCNhIbCgK/jA5lHjr7lJNj
         LgBQFzNodjtXqeBzCJ6ztLEBlMT9kpWT75dOVg8EnaNcncE6jDlkZVsd+H1Std0JgUuj
         XtCx9J5M0RyXj36OBFyDiILGBzFVDauh9wvn5/KZ5rR9xx7yeivri8n58a6EZsM2H9Zu
         MHobqYT14kwEdHus0srGhQYsZv79y+9gRLusaFJrjWHuwDZo0znAiD3LoeFOlYBkMmQX
         BnrGRbJ9YN2yNZqrIeaE9wbfm71s3aLNKs3OiwYZNoJKMBkgUbJyT8/Rbp4Sx4lzqWZM
         s0Wg==
X-Gm-Message-State: AOAM531hBI2oyYdw1YPKShbONLsYvz6w3YwuAks17x+vnu7Sd+s+kR9o
        6YoitSpaZSk8XkUFKgAkfXNJeyj9j2Lc4SNb
X-Google-Smtp-Source: ABdhPJyQiFecMcD7vb7rYTGuCNZXFoVX51CLzdIGJiAwHYR8lLpZNRq02uvpnUKWZunX2chFoshacQ==
X-Received: by 2002:adf:f189:: with SMTP id h9mr12200603wro.286.1612192421834;
        Mon, 01 Feb 2021 07:13:41 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id 192sm23323381wme.27.2021.02.01.07.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 07:13:41 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 07/12] futex: Mark the begin of futex exit explicitly
Date:   Mon,  1 Feb 2021 15:12:09 +0000
Message-Id: <20210201151214.2193508-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201151214.2193508-1-lee.jones@linaro.org>
References: <20210201151214.2193508-1-lee.jones@linaro.org>
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
 kernel/exit.c         |  8 +-------
 kernel/futex.c        | 37 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 40 insertions(+), 36 deletions(-)

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
index b39f4b3c0f37c..8d3c268fb1b8d 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -695,18 +695,12 @@ void do_exit(long code)
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
-	 * tsk->flags are checked in the futex code to protect against
-	 * an exiting task cleaning up the robust pi futexes.
-	 */
-	smp_mb();
-	raw_spin_unlock_wait(&tsk->pi_lock);
 
 	if (unlikely(in_atomic())) {
 		pr_info("note: %s[%d] exited with preempt_count %d\n",
diff --git a/kernel/futex.c b/kernel/futex.c
index f85635ff2fce1..5bd3afee4e139 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3252,10 +3252,45 @@ void futex_exec_release(struct task_struct *tsk)
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

