Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1785930A4D7
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 11:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbhBAKC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 05:02:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhBAKCz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 05:02:55 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB55C061756
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 02:02:14 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id m1so9335890wml.2
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 02:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zTLj8rZ658syZ+1sSn6qZ3dkC38f1lTVa0M8kGwEtcs=;
        b=DNEty4bMcb7C8YuwlL3GTFizFq4+l1T4dFgKHwQCInBZLd/hZvZyxc9w+YuRKlmu2l
         ZTco1UGayiVHuQJIJMUMz8AC/bLyMvnnUk5tlQSkpeX+GFRiTeOBaJafIAQN8N12jdtG
         yn9kBRHv1+zSVyOC0P5D3N8BJkPKzddMC8jQYOFfZp+c0bxgxoI4CQQiuG3ctnnXS4yP
         NAv2UtCPZHN4UC2liRFOHhg6eIt0p83+WVi1JcNRmjTZjfW5Qwb06433540lknOKW5qk
         FPLWrPreeCYgBr0GRewBot4rKLI0yICvRJoN8IpvfCRNJUSOuMHwppG/dvkXJKHFoaac
         PQTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zTLj8rZ658syZ+1sSn6qZ3dkC38f1lTVa0M8kGwEtcs=;
        b=UOt0lAkDtIVvCvTPIkuqBpYdMCzq5ScwpgZ8Nm5oP8FiftsbP6jPJ5F7DRapBekBxH
         J+GXmGJ20ZiukhQ/HKbY91HGgGfKznXXkUtRzmjdIpc1W+oYhKhaGsSHeCQMhqlRZIur
         O7y9xH+RSmloT7VqObcvMi+aNsDveWIillnA1ykKjOkMTTyCq5rDvQ/3qXQfZlRgYPWs
         K9MOC5/2xVdRNmYRLIyWC2W9IvffYdcJXPm016WcaMQmAi+j87tSv8bpXPNPNycdid6g
         nkv6YlizNVVjHQsb8/nngOHQQwYWWQ1Xx6X1gmv7U+skcMXrKRyzZ79sd/6CtLjnpvFm
         7mZg==
X-Gm-Message-State: AOAM533SkJPDN9qXNTGbWz9Tv3M82LKSjOq9r4mRV8m3Fp2m8pY3YCbZ
        d7+W8eKmW97SVtiFzKNkX+7ihyZxOnbW5qO/
X-Google-Smtp-Source: ABdhPJwzQ6afZQJYp7LzxFO7wqoQXVzK7Ohqsx6QHUgcD/PYgAZYDhFDFPQtVoRqgIN7M6fI4+7WXA==
X-Received: by 2002:a1c:7206:: with SMTP id n6mr1626129wmc.33.1612173732622;
        Mon, 01 Feb 2021 02:02:12 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id p15sm26151387wrt.15.2021.02.01.02.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 02:02:11 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 03/12] futex: Replace PF_EXITPIDONE with a state
Date:   Mon,  1 Feb 2021 10:01:34 +0000
Message-Id: <20210201100143.2028618-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201100143.2028618-1-lee.jones@linaro.org>
References: <20210201100143.2028618-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 3d4775df0a89240f671861c6ab6e8d59af8e9e41 upstream.

The futex exit handling relies on PF_ flags. That's suboptimal as it
requires a smp_mb() and an ugly lock/unlock of the exiting tasks pi_lock in
the middle of do_exit() to enforce the observability of PF_EXITING in the
futex code.

Add a futex_state member to task_struct and convert the PF_EXITPIDONE logic
over to the new state. The PF_EXITING dependency will be cleaned up in a
later step.

This prepares for handling various futex exit issues later.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20191106224556.149449274@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/linux/futex.h | 34 ++++++++++++++++++++++++++++++++++
 include/linux/sched.h |  2 +-
 kernel/exit.c         | 18 ++----------------
 kernel/futex.c        | 17 ++++++++---------
 4 files changed, 45 insertions(+), 26 deletions(-)

diff --git a/include/linux/futex.h b/include/linux/futex.h
index 63d353cedfcde..a0de6fe28e00b 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -55,6 +55,11 @@ union futex_key {
 #define FUTEX_KEY_INIT (union futex_key) { .both = { .ptr = 0ULL } }
 
 #ifdef CONFIG_FUTEX
+enum {
+	FUTEX_STATE_OK,
+	FUTEX_STATE_DEAD,
+};
+
 static inline void futex_init_task(struct task_struct *tsk)
 {
 	tsk->robust_list = NULL;
@@ -63,6 +68,34 @@ static inline void futex_init_task(struct task_struct *tsk)
 #endif
 	INIT_LIST_HEAD(&tsk->pi_state_list);
 	tsk->pi_state_cache = NULL;
+	tsk->futex_state = FUTEX_STATE_OK;
+}
+
+/**
+ * futex_exit_done - Sets the tasks futex state to FUTEX_STATE_DEAD
+ * @tsk:	task to set the state on
+ *
+ * Set the futex exit state of the task lockless. The futex waiter code
+ * observes that state when a task is exiting and loops until the task has
+ * actually finished the futex cleanup. The worst case for this is that the
+ * waiter runs through the wait loop until the state becomes visible.
+ *
+ * This has two callers:
+ *
+ * - futex_mm_release() after the futex exit cleanup has been done
+ *
+ * - do_exit() from the recursive fault handling path.
+ *
+ * In case of a recursive fault this is best effort. Either the futex exit
+ * code has run already or not. If the OWNER_DIED bit has been set on the
+ * futex then the waiter can take it over. If not, the problem is pushed
+ * back to user space. If the futex exit code did not run yet, then an
+ * already queued waiter might block forever, but there is nothing which
+ * can be done about that.
+ */
+static inline void futex_exit_done(struct task_struct *tsk)
+{
+	tsk->futex_state = FUTEX_STATE_DEAD;
 }
 
 void futex_mm_release(struct task_struct *tsk);
@@ -72,5 +105,6 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 #else
 static inline void futex_init_task(struct task_struct *tsk) { }
 static inline void futex_mm_release(struct task_struct *tsk) { }
+static inline void futex_exit_done(struct task_struct *tsk) { }
 #endif
 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1872d4e9acbe1..4de48b251447f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1815,6 +1815,7 @@ struct task_struct {
 #endif
 	struct list_head pi_state_list;
 	struct futex_pi_state *pi_state_cache;
+	unsigned int futex_state;
 #endif
 #ifdef CONFIG_PERF_EVENTS
 	struct perf_event_context *perf_event_ctxp[perf_nr_task_contexts];
@@ -2276,7 +2277,6 @@ extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut,
  * Per process flags
  */
 #define PF_EXITING	0x00000004	/* getting shut down */
-#define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
 #define PF_VCPU		0x00000010	/* I'm a virtual CPU */
 #define PF_WQ_WORKER	0x00000020	/* I'm a workqueue worker */
 #define PF_FORKNOEXEC	0x00000040	/* forked but didn't exec */
diff --git a/kernel/exit.c b/kernel/exit.c
index f9943ef23fa82..969e1468f2538 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -785,16 +785,7 @@ void __noreturn do_exit(long code)
 	 */
 	if (unlikely(tsk->flags & PF_EXITING)) {
 		pr_alert("Fixing recursive fault but reboot is needed!\n");
-		/*
-		 * We can do this unlocked here. The futex code uses
-		 * this flag just to verify whether the pi state
-		 * cleanup has been done or not. In the worst case it
-		 * loops once more. We pretend that the cleanup was
-		 * done as there is no way to return. Either the
-		 * OWNER_DIED bit is set by now or we push the blocked
-		 * task into the wait for ever nirwana as well.
-		 */
-		tsk->flags |= PF_EXITPIDONE;
+		futex_exit_done(tsk);
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule();
 	}
@@ -876,12 +867,7 @@ void __noreturn do_exit(long code)
 	 * Make sure we are holding no locks:
 	 */
 	debug_check_no_locks_held();
-	/*
-	 * We can do this unlocked here. The futex code uses this flag
-	 * just to verify whether the pi state cleanup has been done
-	 * or not. In the worst case it loops once more.
-	 */
-	tsk->flags |= PF_EXITPIDONE;
+	futex_exit_done(tsk);
 
 	if (tsk->io_context)
 		exit_io_context(tsk);
diff --git a/kernel/futex.c b/kernel/futex.c
index 156b23f4b9aac..51bbe57bb14ac 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1099,19 +1099,18 @@ static int attach_to_pi_owner(u32 uval, union futex_key *key,
 	}
 
 	/*
-	 * We need to look at the task state flags to figure out,
-	 * whether the task is exiting. To protect against the do_exit
-	 * change of the task flags, we do this protected by
-	 * p->pi_lock:
+	 * We need to look at the task state to figure out, whether the
+	 * task is exiting. To protect against the change of the task state
+	 * in futex_exit_release(), we do this protected by p->pi_lock:
 	 */
 	raw_spin_lock_irq(&p->pi_lock);
-	if (unlikely(p->flags & PF_EXITING)) {
+	if (unlikely(p->futex_state != FUTEX_STATE_OK)) {
 		/*
-		 * The task is on the way out. When PF_EXITPIDONE is
-		 * set, we know that the task has finished the
-		 * cleanup:
+		 * The task is on the way out. When the futex state is
+		 * FUTEX_STATE_DEAD, we know that the task has finished
+		 * the cleanup:
 		 */
-		int ret = (p->flags & PF_EXITPIDONE) ? -ESRCH : -EAGAIN;
+		int ret = (p->futex_state = FUTEX_STATE_DEAD) ? -ESRCH : -EAGAIN;
 
 		raw_spin_unlock_irq(&p->pi_lock);
 		put_task_struct(p);
-- 
2.25.1

