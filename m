Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBA430A4DE
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 11:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbhBAKDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 05:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbhBAKDf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 05:03:35 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA80AC061793
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 02:02:22 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id s7so12882235wru.5
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 02:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Gg480XhfMoGXqP/teEw7Tq4vypgx+NgStVfH6LwTrK4=;
        b=GAPw2+g8hF10x6QLkaCRtPjUnas1YfgHqJSLyJkmj6r0J1kybPL+9KQdOCkc27eJnS
         YntJQMcPex5g0d+Y9o6ptI6hNfKmW9JIZb9x+aVm/6SSZ0vsumNlVMGboAk5EDg84g4I
         kR71FAKBtou87mbd5Z8yha3PDgvjXUX34dbHgLGgfLBie/ncoxdf9c9Iva4pOGwsQ65X
         z2gjH5OCxeMNSfLyxWl2viXFDH8TfsZgt91NvfXWji8H4VwsW7gIb2D9y595BwIthGql
         WUI62EE9IPaJGORSm1qBe23IbqNfy3jk3AayjMjIpDDQfpRK1FLc9P0nG9l0o2Bx1c/5
         vfXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gg480XhfMoGXqP/teEw7Tq4vypgx+NgStVfH6LwTrK4=;
        b=R3XYKTm5vNVvdYIx8o9w3cIJfY6L95tdQLZiDE3tSOzvXSDuvkxjF4glCPqlC6cINZ
         MFzh8t17Ju2n1N0JhLzNPnFeLLvi5CPCw3Y7znIv5yXVYCWCUmjq7SvUI2NkH9WYgFJq
         qW2P/K/gGpKw479oBYjilCpjzHxuBQIUNwiYwttEgWwzXjNf1eORB36cJgwSM0nLKDe0
         HkBtvLM8L7v+HUP/jWOEO5mB37u9FisakmksfBgKivoqR6F5LhURrDqkKg6czB9Brm1c
         iDckrUiCTavbq6rDH22Cs9l4C3FyEIEqo2ugqztXY/UWu3taikph9DHB4JK9YQbwVvy5
         Y56g==
X-Gm-Message-State: AOAM5319/cjBE+ehKX0XybQiHch2/HqqQnDoRwV0zrX8rAiMNzMwoTUu
        qHm8WePcbkvoiN0AHkuvBdWZkpyUub0bFXYq
X-Google-Smtp-Source: ABdhPJwVDgIo2yxEyZRI8z8qKNW2JE0iUUiCT6KvOYhK2pwG//5FIkpySSgHQ1beZdIgjYyjaRv0Qg==
X-Received: by 2002:adf:eccc:: with SMTP id s12mr10973223wro.383.1612173741148;
        Mon, 01 Feb 2021 02:02:21 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id p15sm26151387wrt.15.2021.02.01.02.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 02:02:20 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/12] futex: Provide state handling for exec() as well
Date:   Mon,  1 Feb 2021 10:01:40 +0000
Message-Id: <20210201100143.2028618-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201100143.2028618-1-lee.jones@linaro.org>
References: <20210201100143.2028618-1-lee.jones@linaro.org>
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
index f1e8ba64fe8ae..50f61d0e51b59 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3269,7 +3269,7 @@ static void exit_robust_list(struct task_struct *curr)
 				   curr, pip);
 }
 
-void futex_exec_release(struct task_struct *tsk)
+static void futex_cleanup(struct task_struct *tsk)
 {
 	if (unlikely(tsk->robust_list)) {
 		exit_robust_list(tsk);
@@ -3309,7 +3309,7 @@ void futex_exit_recursive(struct task_struct *tsk)
 	tsk->futex_state = FUTEX_STATE_DEAD;
 }
 
-void futex_exit_release(struct task_struct *tsk)
+static void futex_cleanup_begin(struct task_struct *tsk)
 {
 	/*
 	 * Switch the state to FUTEX_STATE_EXITING under tsk->pi_lock.
@@ -3325,10 +3325,40 @@ void futex_exit_release(struct task_struct *tsk)
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

