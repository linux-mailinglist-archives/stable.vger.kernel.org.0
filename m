Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75BF830AAC1
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 16:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhBAPOb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 10:14:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbhBAPOR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 10:14:17 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 068ECC061786
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 07:13:37 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id u14so13492737wmq.4
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 07:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jDC51W2JTzWT110KNMO3wDJiHHG/GCkuWxt8htB7+e0=;
        b=a55neDiWRBwHIjb18hk+wIAr5faGMbOaOwQKoxCerwEdPgtPsN15fvsZ/0V7kgORwu
         Jao2vOS4ZlfF/BhdtQtu6HO6tnAa8UYsrqgG/tVL4iF3em61L3yfKln5PKPL82rvPhNx
         WXNd04ymELKiddR5vCI/d/wDnBzzyYYMhLzk+rz+7OOwBvnCxI/81BEXtCh2F2SAwEiz
         GL7c/a5XeLBpKvNxYk/bTSH9JA3kIfCFQzTQ96Jj/2+sow7zXV3CVkwlb78hZBFuM8Xl
         Dbywt7PuKZjDERZ5pvchaqy7f6RSwaslxEaCIwuSV2ogjwvR7djS4l/detB9mxAvYBGf
         Zb6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jDC51W2JTzWT110KNMO3wDJiHHG/GCkuWxt8htB7+e0=;
        b=uiplobRC3uLbcux4O8XblRg97H8nEGb92nA5kuc4kAHo7f7y9ZRy7cbkgb7GFMhuyq
         +dlzIHraZevBETwZLZaT17YFQn67+9a9vofOAyvhRx7eYQtpgJBYJ7PXEsiJWvuRABFB
         bn6v1FK4t3TowJC3VnTuQPewOijWx1H6Xy7uORKTe4Yi37KeALkB9iJqSnXdGaYJdIEW
         kyNTaq6B4IcykANBzXmxjI7X1v+M1puoITNMYIVhFUZlq31MGNs4Fzf2bC06dgbzMexK
         wdr5dt1eQ7SECztoAb65ygBGgwxazR45vF5CdGTBKwL9prTSA/+iThYjmgrJiQjMTVq4
         jbDg==
X-Gm-Message-State: AOAM533YzqKt6wd3aJU6lVU+1hJcG0CFX4ZsAyatG7ehmAi/wLk+Oieo
        BwU423kTlYdrcILEYsc/eawzUQSDk/LDNN10
X-Google-Smtp-Source: ABdhPJyMbzs543p4+stK014r0vI5OF/5MNmDgSTka0BAKDARtUAtW0JQwjD07dXoy2hAaccjR7rBBQ==
X-Received: by 2002:a1c:2e04:: with SMTP id u4mr63551wmu.79.1612192415316;
        Mon, 01 Feb 2021 07:13:35 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id 192sm23323381wme.27.2021.02.01.07.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 07:13:34 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 02/12] futex: Move futex exit handling into futex code
Date:   Mon,  1 Feb 2021 15:12:04 +0000
Message-Id: <20210201151214.2193508-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201151214.2193508-1-lee.jones@linaro.org>
References: <20210201151214.2193508-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit ba31c1a48538992316cc71ce94fa9cd3e7b427c0 upstream.

The futex exit handling is #ifdeffed into mm_release() which is not pretty
to begin with. But upcoming changes to address futex exit races need to add
more functionality to this exit code.

Split it out into a function, move it into futex code and make the various
futex exit functions static.

Preparatory only and no functional change.

Folded build fix from Borislav.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20191106224556.049705556@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/linux/compat.h |  2 --
 include/linux/futex.h  | 24 +++++++++++++++++-------
 kernel/fork.c          | 25 +++----------------------
 kernel/futex.c         | 28 ++++++++++++++++++++++++++--
 4 files changed, 46 insertions(+), 33 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index a76c9172b2eb0..24dd42910d7c2 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -306,8 +306,6 @@ struct compat_kexec_segment;
 struct compat_mq_attr;
 struct compat_msgbuf;
 
-extern void compat_exit_robust_list(struct task_struct *curr);
-
 asmlinkage long
 compat_sys_set_robust_list(struct compat_robust_list_head __user *head,
 			   compat_size_t len);
diff --git a/include/linux/futex.h b/include/linux/futex.h
index fb4e12cbe887e..63d353cedfcde 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_FUTEX_H
 #define _LINUX_FUTEX_H
 
+#include <linux/sched.h>
+
 #include <uapi/linux/futex.h>
 
 struct inode;
@@ -53,14 +55,22 @@ union futex_key {
 #define FUTEX_KEY_INIT (union futex_key) { .both = { .ptr = 0ULL } }
 
 #ifdef CONFIG_FUTEX
-extern void exit_robust_list(struct task_struct *curr);
-extern void exit_pi_state_list(struct task_struct *curr);
-#else
-static inline void exit_robust_list(struct task_struct *curr)
-{
-}
-static inline void exit_pi_state_list(struct task_struct *curr)
+static inline void futex_init_task(struct task_struct *tsk)
 {
+	tsk->robust_list = NULL;
+#ifdef CONFIG_COMPAT
+	tsk->compat_robust_list = NULL;
+#endif
+	INIT_LIST_HEAD(&tsk->pi_state_list);
+	tsk->pi_state_cache = NULL;
 }
+
+void futex_mm_release(struct task_struct *tsk);
+
+long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
+	      u32 __user *uaddr2, u32 val2, u32 val3);
+#else
+static inline void futex_init_task(struct task_struct *tsk) { }
+static inline void futex_mm_release(struct task_struct *tsk) { }
 #endif
 #endif
diff --git a/kernel/fork.c b/kernel/fork.c
index 5d35be1e0913b..d0ab6aff5efdc 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -890,20 +890,7 @@ static int wait_for_vfork_done(struct task_struct *child,
 void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 {
 	/* Get rid of any futexes when releasing the mm */
-#ifdef CONFIG_FUTEX
-	if (unlikely(tsk->robust_list)) {
-		exit_robust_list(tsk);
-		tsk->robust_list = NULL;
-	}
-#ifdef CONFIG_COMPAT
-	if (unlikely(tsk->compat_robust_list)) {
-		compat_exit_robust_list(tsk);
-		tsk->compat_robust_list = NULL;
-	}
-#endif
-	if (unlikely(!list_empty(&tsk->pi_state_list)))
-		exit_pi_state_list(tsk);
-#endif
+	futex_mm_release(tsk);
 
 	uprobe_free_utask(tsk);
 
@@ -1511,14 +1498,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 #ifdef CONFIG_BLOCK
 	p->plug = NULL;
 #endif
-#ifdef CONFIG_FUTEX
-	p->robust_list = NULL;
-#ifdef CONFIG_COMPAT
-	p->compat_robust_list = NULL;
-#endif
-	INIT_LIST_HEAD(&p->pi_state_list);
-	p->pi_state_cache = NULL;
-#endif
+	futex_init_task(p);
+
 	/*
 	 * sigaltstack should be cleared when sharing the same VM
 	 */
diff --git a/kernel/futex.c b/kernel/futex.c
index 2815b1801ec5a..5282b9b8d1ec1 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -331,6 +331,12 @@ static inline bool should_fail_futex(bool fshared)
 }
 #endif /* CONFIG_FAIL_FUTEX */
 
+#ifdef CONFIG_COMPAT
+static void compat_exit_robust_list(struct task_struct *curr);
+#else
+static inline void compat_exit_robust_list(struct task_struct *curr) { }
+#endif
+
 static inline void futex_get_mm(union futex_key *key)
 {
 	atomic_inc(&key->private.mm->mm_count);
@@ -889,7 +895,7 @@ static struct task_struct * futex_find_get_task(pid_t pid)
  * Kernel cleans up PI-state, but userspace is likely hosed.
  * (Robust-futex cleanup is separate and might save the day for userspace.)
  */
-void exit_pi_state_list(struct task_struct *curr)
+static void exit_pi_state_list(struct task_struct *curr)
 {
 	struct list_head *next, *head = &curr->pi_state_list;
 	struct futex_pi_state *pi_state;
@@ -3166,7 +3172,7 @@ static inline int fetch_robust_entry(struct robust_list __user **entry,
  *
  * We silently return on any sign of list-walking problem.
  */
-void exit_robust_list(struct task_struct *curr)
+static void exit_robust_list(struct task_struct *curr)
 {
 	struct robust_list_head __user *head = curr->robust_list;
 	struct robust_list __user *entry, *next_entry, *pending;
@@ -3229,6 +3235,24 @@ void exit_robust_list(struct task_struct *curr)
 				   curr, pip);
 }
 
+void futex_mm_release(struct task_struct *tsk)
+{
+	if (unlikely(tsk->robust_list)) {
+		exit_robust_list(tsk);
+		tsk->robust_list = NULL;
+	}
+
+#ifdef CONFIG_COMPAT
+	if (unlikely(tsk->compat_robust_list)) {
+		compat_exit_robust_list(tsk);
+		tsk->compat_robust_list = NULL;
+	}
+#endif
+
+	if (unlikely(!list_empty(&tsk->pi_state_list)))
+		exit_pi_state_list(tsk);
+}
+
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		u32 __user *uaddr2, u32 val2, u32 val3)
 {
-- 
2.25.1

