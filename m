Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E946030C10B
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234168AbhBBOMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 09:12:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:49658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234031AbhBBOLh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:11:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA5F264DA5;
        Tue,  2 Feb 2021 13:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273886;
        bh=bF97D2Cp35ONk8SQs12WBaieUMN5tD3+lNcFGZmUN1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GZBH0FY7vQT8hhhChzsVMSKRkom9cIDznGSYV1cvOBhdfqnN5UXIY/olWpvNQtWSw
         heYvCX6c6w4+kTc9z+D+KtcHE8zflr/TaglXD5IQdeQtVUXB4HiJHMEXVeq9f5qzLl
         2GLEZ+VI4qRQjEajraPp2CK/x//EAXOyqbS5Smd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 12/32] futex: Provide state handling for exec() as well
Date:   Tue,  2 Feb 2021 14:38:35 +0100
Message-Id: <20210202132942.505465780@linuxfoundation.org>
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

commit af8cbda2cfcaa5515d61ec500498d46e9a8247e2 upstream.

exec() attempts to handle potentially held futexes gracefully by running
the futex exit handling code like exit() does.

The current implementation has no protection against concurrent incoming
waiters. The reason is that the futex state cannot be set to
FUTEX_STATE_DEAD after the cleanup because the task struct is still active
and just about to execute the new binary.

While its arguably buggy when a task holds a futex over exec(), for
consistency sake the state handling can at least cover the actual futex
exit cleanup section. This provides state consistency protection accross
the cleanup. As the futex state of the task becomes FUTEX_STATE_OK after the
cleanup has been finished, this cannot prevent subsequent attempts to
attach to the task in case that the cleanup was not successfull in mopping
up all leftovers.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20191106224556.753355618@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |   38 ++++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3269,7 +3269,7 @@ static void exit_robust_list(struct task
 				   curr, pip);
 }
 
-void futex_exec_release(struct task_struct *tsk)
+static void futex_cleanup(struct task_struct *tsk)
 {
 	if (unlikely(tsk->robust_list)) {
 		exit_robust_list(tsk);
@@ -3309,7 +3309,7 @@ void futex_exit_recursive(struct task_st
 	tsk->futex_state = FUTEX_STATE_DEAD;
 }
 
-void futex_exit_release(struct task_struct *tsk)
+static void futex_cleanup_begin(struct task_struct *tsk)
 {
 	/*
 	 * Switch the state to FUTEX_STATE_EXITING under tsk->pi_lock.
@@ -3325,10 +3325,40 @@ void futex_exit_release(struct task_stru
 	raw_spin_lock_irq(&tsk->pi_lock);
 	tsk->futex_state = FUTEX_STATE_EXITING;
 	raw_spin_unlock_irq(&tsk->pi_lock);
+}
 
-	futex_exec_release(tsk);
+static void futex_cleanup_end(struct task_struct *tsk, int state)
+{
+	/*
+	 * Lockless store. The only side effect is that an observer might
+	 * take another loop until it becomes visible.
+	 */
+	tsk->futex_state = state;
+}
 
-	tsk->futex_state = FUTEX_STATE_DEAD;
+void futex_exec_release(struct task_struct *tsk)
+{
+	/*
+	 * The state handling is done for consistency, but in the case of
+	 * exec() there is no way to prevent futher damage as the PID stays
+	 * the same. But for the unlikely and arguably buggy case that a
+	 * futex is held on exec(), this provides at least as much state
+	 * consistency protection which is possible.
+	 */
+	futex_cleanup_begin(tsk);
+	futex_cleanup(tsk);
+	/*
+	 * Reset the state to FUTEX_STATE_OK. The task is alive and about
+	 * exec a new binary.
+	 */
+	futex_cleanup_end(tsk, FUTEX_STATE_OK);
+}
+
+void futex_exit_release(struct task_struct *tsk)
+{
+	futex_cleanup_begin(tsk);
+	futex_cleanup(tsk);
+	futex_cleanup_end(tsk, FUTEX_STATE_DEAD);
 }
 
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,


