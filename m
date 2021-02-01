Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2083430AACC
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 16:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhBAPPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 10:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbhBAPO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 10:14:57 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F13FC061793
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 07:13:45 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id u14so12938060wml.4
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 07:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MCVDRoiJdy/Do7csl/30kMZE1zZamBX1lgP8roH5D6M=;
        b=J0w3ovp+vCnLYkGRkQmCZ5FrnFU7ex17dn7x5K7Lanyd942kM8Ds9aw6A37qAVCaqE
         gKyJADcqGLD3xtd/vGi51UshfYvnfNO7ZoyOBaFnRTl+93uMy50Z3lkKP8CEjzcyQCqI
         y9OM7lMce+gVaCF63DzI9EDh/MzOckGMmFAlvACObd2MMSFscAMeFDkkjunhYwEvnvft
         m6DmK97o8D3E1ir8x6snqV5Jg8hAhH5sbGYZCDPAK+s1Bzxr+2G0lH5qQEuL9MgMQfkz
         sHHEGc68AfLV4/aLLTJtaBvrIWv32XGakJBFmTKfbRW4Gm+Ho9rTdN6kvbVvgT91uBer
         fW8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MCVDRoiJdy/Do7csl/30kMZE1zZamBX1lgP8roH5D6M=;
        b=t4UrTgqGLk/eeGVkqsedaSAM3Wy6qTjZRTbUtmhNv6gACqxrb0KZc1t9sRaCAHQGFw
         UYbOlnoX6+ZOoWf9glxJyJFgeBjYZRMTjVy2vl0K1OBCu9R5rzgqDObEGLhBqMTtlBL5
         V+bcyd/BEtHFiKd0IQY/hGCZrDD6P94yPumpBVb4sGTsXaGCTNXPDvOm1XC949oSQ8DC
         rFvslfM5QPbNdusSRoc9P791iPvKQi8TPWB+qjAC0CWycrw5s0LAWrjY/rKjvT+rxVBn
         XIaz2E90GZk7sE5Z5ncrH8XlyPAScuh6lTimU96M3DlbhHmZsdjmi5HU1rqJVtpVirsL
         B/VQ==
X-Gm-Message-State: AOAM530yGlKIdhJfXBfQaIFS/t2xlqPqEzvIK15uftEVOhrgVsQVRbOo
        UFNM8MKqAYW8TsGadCKBFIQn9+SMeT8sWF8P
X-Google-Smtp-Source: ABdhPJxO2auQovz82L7jBHqWJnc8AK/mtowV+DIUtO4w2BXSk0yfAwNdKloCL47wMZB37pdEzh5cRQ==
X-Received: by 2002:a1c:4c0a:: with SMTP id z10mr7427390wmf.163.1612192423862;
        Mon, 01 Feb 2021 07:13:43 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id 192sm23323381wme.27.2021.02.01.07.13.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 07:13:43 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/12] futex: Provide state handling for exec() as well
Date:   Mon,  1 Feb 2021 15:12:11 +0000
Message-Id: <20210201151214.2193508-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201151214.2193508-1-lee.jones@linaro.org>
References: <20210201151214.2193508-1-lee.jones@linaro.org>
MIME-Version: 1.0
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
---
 kernel/futex.c | 38 ++++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 0efcb55455c2a..feef5ce071aa5 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3234,7 +3234,7 @@ static void exit_robust_list(struct task_struct *curr)
 				   curr, pip);
 }
 
-void futex_exec_release(struct task_struct *tsk)
+static void futex_cleanup(struct task_struct *tsk)
 {
 	if (unlikely(tsk->robust_list)) {
 		exit_robust_list(tsk);
@@ -3274,7 +3274,7 @@ void futex_exit_recursive(struct task_struct *tsk)
 	tsk->futex_state = FUTEX_STATE_DEAD;
 }
 
-void futex_exit_release(struct task_struct *tsk)
+static void futex_cleanup_begin(struct task_struct *tsk)
 {
 	/*
 	 * Switch the state to FUTEX_STATE_EXITING under tsk->pi_lock.
@@ -3290,10 +3290,40 @@ void futex_exit_release(struct task_struct *tsk)
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
-- 
2.25.1

