Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5915B30AAC5
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 16:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhBAPOt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 10:14:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbhBAPOW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 10:14:22 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F0CC06174A
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 07:13:41 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id e15so13486797wme.0
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 07:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Iu4YQ/UttuQPFJ7M1Rq64N1axTPYV12HexbBC2SJPVQ=;
        b=T+hbEweKWZKT+yyzPDlE7nZL1uJChbb+ZeP7/5YjXKEvCCYfJbqpVNKKTmrLttaf5j
         5byHTBf13l0ub+VtF5zmOShMTvLn6Y7IojKkQm7t3nWKPnGQ2QkbcHDePRnflCoQoUZh
         M6Uw+JxbVxtHHnzYfu8cLgvSvFB/Xm3jPaZxD/Sg+SXBkSP7pvRiZkMd002R11JtAHlq
         p/8nWhqwU7XXpCHDjkfWzlR9tWhEExp87pgxim2WlLAZzuUPzbafosEHJyznJkZX79mG
         Uect+6qqdVLCDbeaAZnHYeViaJSwgEi2JOXtCTyTiqh2IoHMmSbrLWtRQBFDB6nQlpUx
         S6Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Iu4YQ/UttuQPFJ7M1Rq64N1axTPYV12HexbBC2SJPVQ=;
        b=jEVnB1HdmkjMYKZ+9xBKUrKwBT92NRZcXjjFMUlOUArfLw0+BgGLa7b+HiVnSwA8RD
         quPlmCaTu2WDvjaTnSgsHqGPR6ib+EVnkPonefspTYB7zmG4Bjuo9wI+4ZkZ2wC3pWxQ
         sDmdMrZLtzcDfLktyM/i2N9tNdPLBn7SEHoaoUKogZj/3/vKuHd6ANGX0Sn4XcCx4fIs
         cQS6CZuKDkcpcpx7WEs3ENH9GAdpz/6V8MJvVeBlsvixU0RQgqHdoypWAqpsEWB3F1uI
         8900t1P95dDGTNcuU5fTcVw1O6sRViIhe+95bHc/jT/xLSAld6d04XO3MSodV+V5ZiPn
         UbDw==
X-Gm-Message-State: AOAM533KofLHrBKdH88mXEsmS16O0ll7uC38ir3Sa69TMnh68WW8SaWa
        4RgyaYi5ff0/TD/+V+YIgIchQu2J2u2Q3M62
X-Google-Smtp-Source: ABdhPJxob6WrReVCbje/9PoMKm0nmIoBRCTDYFuI5ct/G4qKAejfK8ESuz6ca8XjGi1qvvjDF+7ADg==
X-Received: by 2002:a1c:7e4e:: with SMTP id z75mr15778850wmc.168.1612192419484;
        Mon, 01 Feb 2021 07:13:39 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id 192sm23323381wme.27.2021.02.01.07.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 07:13:38 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/12] futex: Split futex_mm_release() for exit/exec
Date:   Mon,  1 Feb 2021 15:12:07 +0000
Message-Id: <20210201151214.2193508-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201151214.2193508-1-lee.jones@linaro.org>
References: <20210201151214.2193508-1-lee.jones@linaro.org>
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
index 43a50072dd5b4..2bd4c38efa095 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -889,9 +889,6 @@ static int wait_for_vfork_done(struct task_struct *child,
  */
 static void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 {
-	/* Get rid of any futexes when releasing the mm */
-	futex_mm_release(tsk);
-
 	uprobe_free_utask(tsk);
 
 	/* Get rid of any cached register state */
@@ -926,11 +923,13 @@ static void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 
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
index e531789aa440a..32a606b605cbb 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3234,7 +3234,7 @@ static void exit_robust_list(struct task_struct *curr)
 				   curr, pip);
 }
 
-void futex_mm_release(struct task_struct *tsk)
+void futex_exec_release(struct task_struct *tsk)
 {
 	if (unlikely(tsk->robust_list)) {
 		exit_robust_list(tsk);
@@ -3252,6 +3252,11 @@ void futex_mm_release(struct task_struct *tsk)
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

