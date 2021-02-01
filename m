Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC0230A4E2
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 11:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbhBAKDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 05:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233011AbhBAKDi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 05:03:38 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4B6C061788
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 02:02:18 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id p15so15827322wrq.8
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 02:02:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qqBoT1xpWEYMKezlYyKQ2zkhv0Ilyy8rHIYG+0h8Im8=;
        b=VZVSw6E8CrBMDpWIroh7AP3ijX6WSF/iNqU7a3OsFxWDE0C7NN8ad06UubkFhbSf/P
         lQ7oLzLCLKTTf9lN7OtY4wHQP7Mb+Fz5x1RjWlODXgfdFRBd80r42g9lJgS9BlNq68bu
         Fj0NWOAWoAZAli//1fi/8NttxABhPJcroBYktMSX07jPfzFzQvjF666VbzibrVmaZrOE
         lbosIeCcY5GXi1PrXa5hGUrE2YJEcGMPJogSmB1lf2eNI+BlaC14clUDpe8qfqtOZpdR
         9BH6Bd14T2l6x8BcXaMfLaRXHikK9jwM5HSNK9rSf+AbYjxzj7lrXr2IbJVZFcQe/KJM
         gJBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qqBoT1xpWEYMKezlYyKQ2zkhv0Ilyy8rHIYG+0h8Im8=;
        b=eIeJXIQ6L+Fwf1aoY4BErFxkqp+wG6e7B8hTIqDItKE8XDAfmFeoJgsprIYmIiVvWE
         9ucFBkq22b4RbdMBfA2L9LYDXtxpqTNpg7GWkE9xu8Y50o1yI+3E6SCRN4yBroJnnV7R
         fMjtE6xxW/iDAj1ltyOIkr60fb4qGpvRK3qeKEwL+ooq5O7w+tCtH+6Ma1sxN9EY4cTq
         fPwEB6/bJ0muc4WeAlt8Sv3fXxtivF1Zawkh2cR0PZO/HRTwPflCv4pJxnMiU8//Go26
         xeO1cKL4s+Y2365TyOgl4q+qwFal8SVAL79p1co9QT/Br1q/bARF5MqoP9nt8wAnRme5
         VzYg==
X-Gm-Message-State: AOAM530VRrM17gzCLRFFXAH6+Iklg4RE+9F1OBbQt2pP+RZNrASMs5y5
        EfixULX21BcAQwDzzeJZKy7zmHEchLHkCAxZ
X-Google-Smtp-Source: ABdhPJz7kIyduzRBRM6Stw5d2o2h50P0RG2vt2xn90Xv1VB1DNTd0rW+KM/D2n8V+SOIhZRz3rnMjw==
X-Received: by 2002:a5d:5283:: with SMTP id c3mr16682221wrv.319.1612173734636;
        Mon, 01 Feb 2021 02:02:14 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id p15sm26151387wrt.15.2021.02.01.02.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 02:02:14 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/12] futex: Split futex_mm_release() for exit/exec
Date:   Mon,  1 Feb 2021 10:01:36 +0000
Message-Id: <20210201100143.2028618-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201100143.2028618-1-lee.jones@linaro.org>
References: <20210201100143.2028618-1-lee.jones@linaro.org>
MIME-Version: 1.0
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
---
 include/linux/futex.h | 6 ++++--
 kernel/fork.c         | 5 ++---
 kernel/futex.c        | 7 ++++++-
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/linux/futex.h b/include/linux/futex.h
index a0de6fe28e00b..063a5cd00d770 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -98,13 +98,15 @@ static inline void futex_exit_done(struct task_struct *tsk)
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
diff --git a/kernel/fork.c b/kernel/fork.c
index ad9dbbf03d7bc..91349fd3e162d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1084,9 +1084,6 @@ static int wait_for_vfork_done(struct task_struct *child,
  */
 static void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 {
-	/* Get rid of any futexes when releasing the mm */
-	futex_mm_release(tsk);
-
 	uprobe_free_utask(tsk);
 
 	/* Get rid of any cached register state */
@@ -1121,11 +1118,13 @@ static void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 
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
 
diff --git a/kernel/futex.c b/kernel/futex.c
index 51bbe57bb14ac..902ce420c4ba0 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3269,7 +3269,7 @@ static void exit_robust_list(struct task_struct *curr)
 				   curr, pip);
 }
 
-void futex_mm_release(struct task_struct *tsk)
+void futex_exec_release(struct task_struct *tsk)
 {
 	if (unlikely(tsk->robust_list)) {
 		exit_robust_list(tsk);
@@ -3287,6 +3287,11 @@ void futex_mm_release(struct task_struct *tsk)
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
-- 
2.25.1

