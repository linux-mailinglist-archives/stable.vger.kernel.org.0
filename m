Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3924C30C8D9
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 19:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237388AbhBBSCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 13:02:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:47582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233931AbhBBOIK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:08:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30B4E6502C;
        Tue,  2 Feb 2021 13:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273819;
        bh=0bZso9ozzYebTs7H/oXmtDZHr5CG1Y8XYZU4iIaFh6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=thQPeU6BALCdZSZhGLhoDeT+CUxhkxfmZRRM+qzVFbMKN947woRmhveTmw6OBsgoV
         U1epZGyXhJNo820WkY7i4Y6yS1IzTpJcRCNObdRS6Gm/+Uv/39g4Pka0FCkRQM67ZL
         hlZ7LJITYxXVm5YGwGrDEO9IMbaVF8TF5zfKop/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 05/32] futex: Move futex exit handling into futex code
Date:   Tue,  2 Feb 2021 14:38:28 +0100
Message-Id: <20210202132942.249450957@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.035179752@linuxfoundation.org>
References: <20210202132942.035179752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/compat.h |    2 --
 include/linux/futex.h  |   24 +++++++++++++++++-------
 kernel/fork.c          |   25 +++----------------------
 kernel/futex.c         |   28 ++++++++++++++++++++++++++--
 4 files changed, 46 insertions(+), 33 deletions(-)

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
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1085,20 +1085,7 @@ static int wait_for_vfork_done(struct ta
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
 
@@ -1706,14 +1693,8 @@ static __latent_entropy struct task_stru
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
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -339,6 +339,12 @@ static inline bool should_fail_futex(boo
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
@@ -894,7 +900,7 @@ static struct task_struct * futex_find_g
  * Kernel cleans up PI-state, but userspace is likely hosed.
  * (Robust-futex cleanup is separate and might save the day for userspace.)
  */
-void exit_pi_state_list(struct task_struct *curr)
+static void exit_pi_state_list(struct task_struct *curr)
 {
 	struct list_head *next, *head = &curr->pi_state_list;
 	struct futex_pi_state *pi_state;
@@ -3201,7 +3207,7 @@ static inline int fetch_robust_entry(str
  *
  * We silently return on any sign of list-walking problem.
  */
-void exit_robust_list(struct task_struct *curr)
+static void exit_robust_list(struct task_struct *curr)
 {
 	struct robust_list_head __user *head = curr->robust_list;
 	struct robust_list __user *entry, *next_entry, *pending;
@@ -3264,6 +3270,24 @@ void exit_robust_list(struct task_struct
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


