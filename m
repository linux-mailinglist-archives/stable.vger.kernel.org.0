Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4523430CA05
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 19:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238644AbhBBSgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 13:36:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:47078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233815AbhBBOFJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:05:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F71964F4A;
        Tue,  2 Feb 2021 13:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273735;
        bh=Oo5HIG0brDoJXARCiepfJw+bQlNXeDiat9eKbDVELL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XU+ue4j6hL1Q1V3XtxePt00jphAS3Zo9BpIbtpbPdb3m07TayqP9F6nX0nYjEjJsa
         G1r7E0H9i51ADe4AQrWpVI5QhoJ7ZreaxQBbkMFPuaERFlB+jLVvm1QsxAQlDGvx3v
         6dhHohEx6//7MqSSTK+vyZqEK3VJou4qTaybMktE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 11/28] futex: Split futex_mm_release() for exit/exec
Date:   Tue,  2 Feb 2021 14:38:31 +0100
Message-Id: <20210202132941.642956012@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132941.180062901@linuxfoundation.org>
References: <20210202132941.180062901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 150d71584b12809144b8145b817e83b81158ae5f upstream.

To allow separate handling of the futex exit state in the futex exit code
for exit and exec, split futex_mm_release() into two functions and invoke
them from the corresponding exit/exec_mm_release() callsites.

Preparatory only, no functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20191106224556.332094221@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/futex.h |    6 ++++--
 kernel/fork.c         |    5 ++---
 kernel/futex.c        |    7 ++++++-
 3 files changed, 12 insertions(+), 6 deletions(-)

--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -98,13 +98,15 @@ static inline void futex_exit_done(struc
 	tsk->futex_state = FUTEX_STATE_DEAD;
 }
 
-void futex_mm_release(struct task_struct *tsk);
+void futex_exit_release(struct task_struct *tsk);
+void futex_exec_release(struct task_struct *tsk);
 
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 	      u32 __user *uaddr2, u32 val2, u32 val3);
 #else
 static inline void futex_init_task(struct task_struct *tsk) { }
-static inline void futex_mm_release(struct task_struct *tsk) { }
 static inline void futex_exit_done(struct task_struct *tsk) { }
+static inline void futex_exit_release(struct task_struct *tsk) { }
+static inline void futex_exec_release(struct task_struct *tsk) { }
 #endif
 #endif
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -889,9 +889,6 @@ static int wait_for_vfork_done(struct ta
  */
 static void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 {
-	/* Get rid of any futexes when releasing the mm */
-	futex_mm_release(tsk);
-
 	uprobe_free_utask(tsk);
 
 	/* Get rid of any cached register state */
@@ -926,11 +923,13 @@ static void mm_release(struct task_struc
 
 void exit_mm_release(struct task_struct *tsk, struct mm_struct *mm)
 {
+	futex_exit_release(tsk);
 	mm_release(tsk, mm);
 }
 
 void exec_mm_release(struct task_struct *tsk, struct mm_struct *mm)
 {
+	futex_exec_release(tsk);
 	mm_release(tsk, mm);
 }
 
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3234,7 +3234,7 @@ static void exit_robust_list(struct task
 				   curr, pip);
 }
 
-void futex_mm_release(struct task_struct *tsk)
+void futex_exec_release(struct task_struct *tsk)
 {
 	if (unlikely(tsk->robust_list)) {
 		exit_robust_list(tsk);
@@ -3252,6 +3252,11 @@ void futex_mm_release(struct task_struct
 		exit_pi_state_list(tsk);
 }
 
+void futex_exit_release(struct task_struct *tsk)
+{
+	futex_exec_release(tsk);
+}
+
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		u32 __user *uaddr2, u32 val2, u32 val3)
 {


