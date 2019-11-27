Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C669110BBCD
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733005AbfK0VNv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:13:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:46514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733026AbfK0VNt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:13:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABE0B21556;
        Wed, 27 Nov 2019 21:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889228;
        bh=/oiVwlw5huv5nj+44vr4xJH+qcP4zMZhOulht6WwE50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XhqZyTX5+3zLvJhDSBWn2jDrUVIJUJsFowqSf2yXAAlE+NQtucraU2HZtln4c5TQM
         PIK6lzYexEOnv07bMUQeFCX1wt4yPCsDdDQ9pleZr7JCXJgILCf4ZdsbxVXFvh89ID
         Aa7Ywm7Btjz3f25QHC5VWF8l4JtgTmFwSA2VrUMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.4 36/66] futex: Move futex exit handling into futex code
Date:   Wed, 27 Nov 2019 21:32:31 +0100
Message-Id: <20191127202715.746860857@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202632.536277063@linuxfoundation.org>
References: <20191127202632.536277063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

---
 include/linux/compat.h |    2 --
 include/linux/futex.h  |   29 ++++++++++++++++-------------
 kernel/fork.c          |   25 +++----------------------
 kernel/futex.c         |   33 +++++++++++++++++++++++++++++----
 4 files changed, 48 insertions(+), 41 deletions(-)

--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -410,8 +410,6 @@ struct compat_kexec_segment;
 struct compat_mq_attr;
 struct compat_msgbuf;
 
-extern void compat_exit_robust_list(struct task_struct *curr);
-
 #define BITS_PER_COMPAT_LONG    (8*sizeof(compat_long_t))
 
 #define BITS_TO_COMPAT_LONGS(bits) DIV_ROUND_UP(bits, BITS_PER_COMPAT_LONG)
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -2,7 +2,9 @@
 #ifndef _LINUX_FUTEX_H
 #define _LINUX_FUTEX_H
 
+#include <linux/sched.h>
 #include <linux/ktime.h>
+
 #include <uapi/linux/futex.h>
 
 struct inode;
@@ -48,15 +50,24 @@ union futex_key {
 #define FUTEX_KEY_INIT (union futex_key) { .both = { .ptr = NULL } }
 
 #ifdef CONFIG_FUTEX
-extern void exit_robust_list(struct task_struct *curr);
 
-long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
-	      u32 __user *uaddr2, u32 val2, u32 val3);
-#else
-static inline void exit_robust_list(struct task_struct *curr)
+static inline void futex_init_task(struct task_struct *tsk)
 {
+	tsk->robust_list = NULL;
+#ifdef CONFIG_COMPAT
+	tsk->compat_robust_list = NULL;
+#endif
+	INIT_LIST_HEAD(&tsk->pi_state_list);
+	tsk->pi_state_cache = NULL;
 }
 
+void futex_mm_release(struct task_struct *tsk);
+
+long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
+	      u32 __user *uaddr2, u32 val2, u32 val3);
+#else
+static inline void futex_init_task(struct task_struct *tsk) { }
+static inline void futex_mm_release(struct task_struct *tsk) { }
 static inline long do_futex(u32 __user *uaddr, int op, u32 val,
 			    ktime_t *timeout, u32 __user *uaddr2,
 			    u32 val2, u32 val3)
@@ -65,12 +76,4 @@ static inline long do_futex(u32 __user *
 }
 #endif
 
-#ifdef CONFIG_FUTEX_PI
-extern void exit_pi_state_list(struct task_struct *curr);
-#else
-static inline void exit_pi_state_list(struct task_struct *curr)
-{
-}
-#endif
-
 #endif
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1286,20 +1286,7 @@ static int wait_for_vfork_done(struct ta
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
 
@@ -2062,14 +2049,8 @@ static __latent_entropy struct task_stru
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
@@ -325,6 +325,12 @@ static inline bool should_fail_futex(boo
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
 	mmgrab(key->private.mm);
@@ -890,7 +896,7 @@ static void put_pi_state(struct futex_pi
  * Kernel cleans up PI-state, but userspace is likely hosed.
  * (Robust-futex cleanup is separate and might save the day for userspace.)
  */
-void exit_pi_state_list(struct task_struct *curr)
+static void exit_pi_state_list(struct task_struct *curr)
 {
 	struct list_head *next, *head = &curr->pi_state_list;
 	struct futex_pi_state *pi_state;
@@ -960,7 +966,8 @@ void exit_pi_state_list(struct task_stru
 	}
 	raw_spin_unlock_irq(&curr->pi_lock);
 }
-
+#else
+static inline void exit_pi_state_list(struct task_struct *curr) { }
 #endif
 
 /*
@@ -3588,7 +3595,7 @@ static inline int fetch_robust_entry(str
  *
  * We silently return on any sign of list-walking problem.
  */
-void exit_robust_list(struct task_struct *curr)
+static void exit_robust_list(struct task_struct *curr)
 {
 	struct robust_list_head __user *head = curr->robust_list;
 	struct robust_list __user *entry, *next_entry, *pending;
@@ -3653,6 +3660,24 @@ void exit_robust_list(struct task_struct
 	}
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
@@ -3780,7 +3805,7 @@ static void __user *futex_uaddr(struct r
  *
  * We silently return on any sign of list-walking problem.
  */
-void compat_exit_robust_list(struct task_struct *curr)
+static void compat_exit_robust_list(struct task_struct *curr)
 {
 	struct compat_robust_list_head __user *head = curr->compat_robust_list;
 	struct robust_list __user *entry, *next_entry, *pending;


