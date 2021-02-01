Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87EE030A4D8
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 11:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhBAKC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 05:02:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232790AbhBAKCz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 05:02:55 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527E8C0613D6
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 02:02:15 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id g10so15884497wrx.1
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 02:02:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j+pI7rP4alOtZeqOXZIiiPmT2Z8ZBGSq2k5HmQdHbwQ=;
        b=Rt/sFTvfyALMfEuNJqHxRt42NAbvFlxfpyDxd4WvR4tzgOgT8BiTE1h3/cR067jYbB
         G2a9TidXAOiiL7JNtulcuB5DzozZAbe0NQ9vtoW33fBSWipvxwcROquNonsOizLe5R9w
         BhEcU4i+KOJ5rW7d1xfasOZC5XgUmZw7jBngWRH8icfp5Rq0M1c9RsYJgVnXRAgBKbkG
         6Fyq4cgD0p8VBRqppRfBXaFkQL4tvGn1nouAMwcnhMsLpTSjvo/Rv7WmC+0Osz4hLZCZ
         WomNIKOwMK6dYnnhK8Ue58jHWuiIn6GY5PS2vzWMRl/yTxOOcGGpDpkQR7/hHOljzbmB
         6Ysg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j+pI7rP4alOtZeqOXZIiiPmT2Z8ZBGSq2k5HmQdHbwQ=;
        b=OQ0VlINDYW+sFY36CqML+qFWMfIlVSpcHQ1vtXK+MJSB6h+ho4/ufxpavw3YH2pfNT
         2NBwIf2w1/1+pwWSFHJt6z6HADf8rH2tmckt1SBXQyVMVY/9bIL/w3N/mP0BkzLP5xyO
         rNrAqCgc9RSJCpEVTP4lZ8mKQtoDJl9PvtCLVo87S2AJyBXak8TWmn2kBivVpFODGf2O
         IAgFeUe7k7W2EOfxx+0QR6Be2+mf5iBApw8dbS4gqilEh2ng67QIIzQ5qzz8SZy6KtNK
         oB625uGZp+7qTth+UtPiwg289UZ5hOMXtyv5HagM7J+OhAenS8Ozz2IoXJKYUMt8gX8E
         KK7A==
X-Gm-Message-State: AOAM533kRrYDRlGUlXnO665dSp2xZDKRR5i6QNEEyI4l28QowUR0+T62
        nKV8p8yFX2t17idtBLonOeq9YeHLZtFBUD69
X-Google-Smtp-Source: ABdhPJz6QFfphJkrkIq4JOr/hlP4jRDoMjkxcks9E2XNu8OtSjMvOv9ZumojNziMe00aAocPZyYhKw==
X-Received: by 2002:adf:b60e:: with SMTP id f14mr4988231wre.99.1612173733625;
        Mon, 01 Feb 2021 02:02:13 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id p15sm26151387wrt.15.2021.02.01.02.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 02:02:13 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 04/12] exit/exec: Seperate mm_release()
Date:   Mon,  1 Feb 2021 10:01:35 +0000
Message-Id: <20210201100143.2028618-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201100143.2028618-1-lee.jones@linaro.org>
References: <20210201100143.2028618-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 4610ba7ad877fafc0a25a30c6c82015304120426 upstream.

mm_release() contains the futex exit handling. mm_release() is called from
do_exit()->exit_mm() and from exec()->exec_mm().

In the exit_mm() case PF_EXITING and the futex state is updated. In the
exec_mm() case these states are not touched.

As the futex exit code needs further protections against exit races, this
needs to be split into two functions.

Preparatory only, no functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20191106224556.240518241@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 fs/exec.c             |  2 +-
 include/linux/sched.h |  6 ++++--
 kernel/exit.c         |  2 +-
 kernel/fork.c         | 12 +++++++++++-
 4 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index cd5da140f94cb..319a1f5732fa9 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1021,7 +1021,7 @@ static int exec_mmap(struct mm_struct *mm)
 	/* Notify parent that we're no longer interested in the old VM */
 	tsk = current;
 	old_mm = current->mm;
-	mm_release(tsk, old_mm);
+	exec_mm_release(tsk, old_mm);
 
 	if (old_mm) {
 		sync_mm_rss(old_mm);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4de48b251447f..fcbe5904cbd97 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2955,8 +2955,10 @@ extern struct mm_struct *get_task_mm(struct task_struct *task);
  * succeeds.
  */
 extern struct mm_struct *mm_access(struct task_struct *task, unsigned int mode);
-/* Remove the current tasks stale references to the old mm_struct */
-extern void mm_release(struct task_struct *, struct mm_struct *);
+/* Remove the current tasks stale references to the old mm_struct on exit() */
+extern void exit_mm_release(struct task_struct *, struct mm_struct *);
+/* Remove the current tasks stale references to the old mm_struct on exec() */
+extern void exec_mm_release(struct task_struct *, struct mm_struct *);
 
 #ifdef CONFIG_HAVE_COPY_THREAD_TLS
 extern int copy_thread_tls(unsigned long, unsigned long, unsigned long,
diff --git a/kernel/exit.c b/kernel/exit.c
index 969e1468f2538..b65285f5ee0c9 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -464,7 +464,7 @@ static void exit_mm(struct task_struct *tsk)
 	struct mm_struct *mm = tsk->mm;
 	struct core_state *core_state;
 
-	mm_release(tsk, mm);
+	exit_mm_release(tsk, mm);
 	if (!mm)
 		return;
 	sync_mm_rss(mm);
diff --git a/kernel/fork.c b/kernel/fork.c
index 000447bfcfde5..ad9dbbf03d7bc 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1082,7 +1082,7 @@ static int wait_for_vfork_done(struct task_struct *child,
  * restoring the old one. . .
  * Eric Biederman 10 January 1998
  */
-void mm_release(struct task_struct *tsk, struct mm_struct *mm)
+static void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 {
 	/* Get rid of any futexes when releasing the mm */
 	futex_mm_release(tsk);
@@ -1119,6 +1119,16 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 		complete_vfork_done(tsk);
 }
 
+void exit_mm_release(struct task_struct *tsk, struct mm_struct *mm)
+{
+	mm_release(tsk, mm);
+}
+
+void exec_mm_release(struct task_struct *tsk, struct mm_struct *mm)
+{
+	mm_release(tsk, mm);
+}
+
 /*
  * Allocate a new mm structure and copy contents from the
  * mm structure of the passed in task structure.
-- 
2.25.1

