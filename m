Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B89030A4D6
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 11:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232651AbhBAKCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 05:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhBAKCx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 05:02:53 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE9D5C06174A
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 02:02:12 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id s7so12881610wru.5
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 02:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SbL/H5EXTKeLRGZKCiBhrlOPYKA29ODSWb0e+HweDuw=;
        b=Wh34svONTy1KOVuy3DGyqQKhkF9yQBmUQyyd8NH+XN7h8xzRup8KPn7yR74/YVVLnd
         F0neHaspZKOV8K1Rktc1fplGiRrLIKC9CW1FHm6l6+560oIKvyWJx9oV7dPbC3W/SbLy
         bDSwCBy8SCXD+5wzPEH5g1EBObavfs8sDy96ERu7KYjNgZy7a3OPJjQ0RNYMDl1wWxUt
         mamqus//u7jgzXgb+AVeR+BpZ+wTO3Va7TlJD1ACWTXBA4Y9A7Ra7qHYpaVAx4BvfF1b
         o2PI/b4yn4AydWWwiWzAjtdAudS0b2Vz92f+fpcVmNGgGOqFvwdte60Xg1KCOr6P9pTE
         VDeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SbL/H5EXTKeLRGZKCiBhrlOPYKA29ODSWb0e+HweDuw=;
        b=Bi1SMu2ZIhSYChH6IX/JiNVLeGF7dtjDyxoL343ghMBrFDBl3f6/2OK/vCFWtX1D+L
         t8ayF4Kx+DsHQliSGZlC0XGKUssvEIN+rNCkADb66l+FLo2waR3SRKdzaWNmhsbu1hC+
         XP/YQOtiSr05oZBLZevovCCFJOx5sTg176zd+UjQ3ZGPsTnrJmL/UgPt0sBznyRwWux1
         mjf3w+hZldkKlmsCjkakGIhrMYBsJxIjJNqBUev2Bvbjb42pYqpPtJPS2d8TTT9gNLCL
         Khgeuy4EGFgRPb3PW+87jZYaiEe9cdgP9PzRWyJ5SEGn1Vou+ICQ1s8nraywls7PQPVI
         UukA==
X-Gm-Message-State: AOAM530MF8jOkziOCEztWr7IfKUDythcJQh8gSwb8f4IfbrrICW7FzfI
        p2Lrpad+bpLpHEHc4LUqWG2Bw+dP8z9SryhW
X-Google-Smtp-Source: ABdhPJzmBgshrEH1MoFnQavn7NdEdf2iSpgXQwUmFrSw9pUsjFySLS7nqh5nh8ZFApSwT9fI4q0KPQ==
X-Received: by 2002:adf:ce89:: with SMTP id r9mr17449541wrn.345.1612173731189;
        Mon, 01 Feb 2021 02:02:11 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id p15sm26151387wrt.15.2021.02.01.02.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 02:02:10 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 02/12] futex: Move futex exit handling into futex code
Date:   Mon,  1 Feb 2021 10:01:33 +0000
Message-Id: <20210201100143.2028618-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201100143.2028618-1-lee.jones@linaro.org>
References: <20210201100143.2028618-1-lee.jones@linaro.org>
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
index fab35daf87596..6b9d38a7adcaf 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -311,8 +311,6 @@ struct compat_kexec_segment;
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
index b64efec4a6e6e..000447bfcfde5 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1085,20 +1085,7 @@ static int wait_for_vfork_done(struct task_struct *child,
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
 
@@ -1706,14 +1693,8 @@ static __latent_entropy struct task_struct *copy_process(
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
index 220e3924869b0..156b23f4b9aac 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -339,6 +339,12 @@ static inline bool should_fail_futex(bool fshared)
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
@@ -894,7 +900,7 @@ static struct task_struct * futex_find_get_task(pid_t pid)
  * Kernel cleans up PI-state, but userspace is likely hosed.
  * (Robust-futex cleanup is separate and might save the day for userspace.)
  */
-void exit_pi_state_list(struct task_struct *curr)
+static void exit_pi_state_list(struct task_struct *curr)
 {
 	struct list_head *next, *head = &curr->pi_state_list;
 	struct futex_pi_state *pi_state;
@@ -3201,7 +3207,7 @@ static inline int fetch_robust_entry(struct robust_list __user **entry,
  *
  * We silently return on any sign of list-walking problem.
  */
-void exit_robust_list(struct task_struct *curr)
+static void exit_robust_list(struct task_struct *curr)
 {
 	struct robust_list_head __user *head = curr->robust_list;
 	struct robust_list __user *entry, *next_entry, *pending;
@@ -3264,6 +3270,24 @@ void exit_robust_list(struct task_struct *curr)
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

