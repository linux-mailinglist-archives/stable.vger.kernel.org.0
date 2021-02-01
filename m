Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3234C30AACA
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 16:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhBAPPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 10:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbhBAPO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 10:14:57 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C18FC061794
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 07:13:46 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id g10so16980654wrx.1
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 07:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q27H37/zpcTikuASjIMD4FhxtWUcta8dDgeh38mJ6rY=;
        b=Q4MQbzN7KagSSyZ68E9POBDyRqxUcOspqukH42Stuk/h19Vv+2ghdy8TUd6Yhtw+sJ
         fJPNPL1vInwJXsofZ+4Py7dCY4waVqj6sjKpzQ+Eu1RcsQHD1LxQAzAx59jMjWyvz6yN
         cdVNCz0j661b86g4pKYv9U5Pg6ffG9Bjxzk26TljQ4lc1oR6cb434Jkn2JLQeI1lUFz9
         wbkXTykPYT2TuEvOYP+NrPd99OEaAe+VZsmpwDIgLBYypY8FhbxdvYt5LpCglEbZKYlh
         bI9pHuUUlsjYf8lGiIs1WyE847ZLZVfGTd25NrhlkG/jx7dV9EI8A864c8+9mC41qxlo
         dyCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q27H37/zpcTikuASjIMD4FhxtWUcta8dDgeh38mJ6rY=;
        b=nfcTX7yCyAkv1b4M9K1B5muxATTNq6/2D0nxhj/raM3b6j+U61WUV5fslSssO757WL
         Zz27ly0XH17QD3zqIA3+0TkFiZ0nVdMrGI+lpXBWLvnqYCSwtd0DEzsk1AHe1g3QCdwb
         ePf2cVdiysK5bPVTPH0TSfAckWoryghThI4GwHCB6fTr5MRJwmlYXx2IARhUswkcCH1A
         snBlqjYqh6Xro1dBxbANzm0A3Q8fI0YGK+z7uH4EC3fmfDFHLYToK7nprzE/UajZrxCr
         c97DpTHy6/CguwhtXXCBMVaP2j+Xmc5kT8jNlEy0QBnd0MKWhd4+h1Q4+z6Hny4OpJQH
         0bCA==
X-Gm-Message-State: AOAM531kHml/x8Xugk2eBdsMXUJKgkhKXB1KQ90Poyfs1iYm1ZnXzDOu
        aOD/qqK0ANnxmMqUXdcek9l36Q6Hgz63asOR
X-Google-Smtp-Source: ABdhPJzDDCGp4lAZQlhqCxuBboU2bk7GmpTqGp3DLrV7qwRXkrQ9p1jdZT0ZHm7bCczfsV23ixWLrQ==
X-Received: by 2002:a5d:47ae:: with SMTP id 14mr18321414wrb.378.1612192424811;
        Mon, 01 Feb 2021 07:13:44 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id 192sm23323381wme.27.2021.02.01.07.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 07:13:44 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 10/12] futex: Add mutex around futex exit
Date:   Mon,  1 Feb 2021 15:12:12 +0000
Message-Id: <20210201151214.2193508-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201151214.2193508-1-lee.jones@linaro.org>
References: <20210201151214.2193508-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 3f186d974826847a07bc7964d79ec4eded475ad9 upstream.

The mutex will be used in subsequent changes to replace the busy looping of
a waiter when the futex owner is currently executing the exit cleanup to
prevent a potential live lock.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20191106224556.845798895@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/linux/futex.h |  1 +
 include/linux/sched.h |  1 +
 kernel/futex.c        | 16 ++++++++++++++++
 3 files changed, 18 insertions(+)

diff --git a/include/linux/futex.h b/include/linux/futex.h
index 805508373fcea..0f294ae63c78c 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -70,6 +70,7 @@ static inline void futex_init_task(struct task_struct *tsk)
 	INIT_LIST_HEAD(&tsk->pi_state_list);
 	tsk->pi_state_cache = NULL;
 	tsk->futex_state = FUTEX_STATE_OK;
+	mutex_init(&tsk->futex_exit_mutex);
 }
 
 void futex_exit_recursive(struct task_struct *tsk);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index aba34bba5e9e3..8c10e97f94fea 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1704,6 +1704,7 @@ struct task_struct {
 #endif
 	struct list_head pi_state_list;
 	struct futex_pi_state *pi_state_cache;
+	struct mutex futex_exit_mutex;
 	unsigned int futex_state;
 #endif
 #ifdef CONFIG_PERF_EVENTS
diff --git a/kernel/futex.c b/kernel/futex.c
index feef5ce071aa5..d21b151216aa3 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3271,11 +3271,22 @@ static void futex_cleanup(struct task_struct *tsk)
  */
 void futex_exit_recursive(struct task_struct *tsk)
 {
+	/* If the state is FUTEX_STATE_EXITING then futex_exit_mutex is held */
+	if (tsk->futex_state == FUTEX_STATE_EXITING)
+		mutex_unlock(&tsk->futex_exit_mutex);
 	tsk->futex_state = FUTEX_STATE_DEAD;
 }
 
 static void futex_cleanup_begin(struct task_struct *tsk)
 {
+	/*
+	 * Prevent various race issues against a concurrent incoming waiter
+	 * including live locks by forcing the waiter to block on
+	 * tsk->futex_exit_mutex when it observes FUTEX_STATE_EXITING in
+	 * attach_to_pi_owner().
+	 */
+	mutex_lock(&tsk->futex_exit_mutex);
+
 	/*
 	 * Switch the state to FUTEX_STATE_EXITING under tsk->pi_lock.
 	 *
@@ -3299,6 +3310,11 @@ static void futex_cleanup_end(struct task_struct *tsk, int state)
 	 * take another loop until it becomes visible.
 	 */
 	tsk->futex_state = state;
+	/*
+	 * Drop the exit protection. This unblocks waiters which observed
+	 * FUTEX_STATE_EXITING to reevaluate the state.
+	 */
+	mutex_unlock(&tsk->futex_exit_mutex);
 }
 
 void futex_exec_release(struct task_struct *tsk)
-- 
2.25.1

