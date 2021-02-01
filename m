Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF1C30A4DF
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 11:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbhBAKDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 05:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233011AbhBAKDf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 05:03:35 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1EEC061794
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 02:02:24 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id g10so15885102wrx.1
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 02:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aVoAzw89+a17gR7Osu1Lbh2IFkjRoOStrGb7pIoW1Us=;
        b=rT0MzlDNrgArkLuFqncWDG0LBLW5ELPTy8ULBD15CvQRx8+gcP9t/8VSy4EdLromj5
         VLWa0yGdxhZvLzYGMBGTxARnLG7JRg0pO/diAysLoxXlkwIluPn/TxfajZNlK9OaRZjW
         Bq0n8CXM5Jr3Wh03b/nmxT46Vb6ADpXcMP7WsSxXsTog9MwJWPvRqDMoBbwk5BtSJp/3
         LhbteVvA8AW5Qthp8ahEpGZosxjiK/8CZ1qui/upDqbq7GVzf937jKiuwH0dp8PQaVG8
         QNo5CkqMyupCYN5QWguuDrrq/NkhQ1b7PGkZ4L0GLY6lGLZmf7DuL1Q2OX45Q9H/A8CS
         Pt5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aVoAzw89+a17gR7Osu1Lbh2IFkjRoOStrGb7pIoW1Us=;
        b=L5VjWkcd2hrlei68RVdGnIZWqbbSGUQC65LZVyit7/xfBycAslqhJ1fZ82pLzK4/Q8
         J4zpDYNsPI5WD5jo2QB5J9XOduQS1lKAJO/UUxn8V7RCnj5pH7esqf0g28CLSJtpV7U2
         IzkS20cz6x/aOknivkO6KGoqQGLl4gBE8s8lMzajcJI3a5Gu2aTSJO9y3MBDOwpB6KsW
         giOCW8jiDGsPNK06pq+TzViMasXy8JggA8F/jVSPG7ehbxx3klHAFu+JO7xqtg/mQq6f
         dHJh7FuSLQmtDbrbu+zAFZYCbCUFJUsWMT+9yGtznHrCuWbTtoQacRIhEYSud5UAYjZl
         gGbQ==
X-Gm-Message-State: AOAM533INe74joDy+eyGZTD2u9xFsQUk6MufbswmEDYQTjsoFF0T7mHS
        T8Qu6K2u4Kyyfm89n7I5tA8sPF7TLyPhZHRP
X-Google-Smtp-Source: ABdhPJymlGuN1wcqviGR29He/ai3+F59iujyTbF2sNKzcWsFL2B+MLbVYwE9xxbp/C1HUMbiAr6uGw==
X-Received: by 2002:adf:e48b:: with SMTP id i11mr17343924wrm.406.1612173742392;
        Mon, 01 Feb 2021 02:02:22 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id p15sm26151387wrt.15.2021.02.01.02.02.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 02:02:21 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 10/12] futex: Add mutex around futex exit
Date:   Mon,  1 Feb 2021 10:01:41 +0000
Message-Id: <20210201100143.2028618-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201100143.2028618-1-lee.jones@linaro.org>
References: <20210201100143.2028618-1-lee.jones@linaro.org>
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
index fcbe5904cbd97..f094882822a63 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1815,6 +1815,7 @@ struct task_struct {
 #endif
 	struct list_head pi_state_list;
 	struct futex_pi_state *pi_state_cache;
+	struct mutex futex_exit_mutex;
 	unsigned int futex_state;
 #endif
 #ifdef CONFIG_PERF_EVENTS
diff --git a/kernel/futex.c b/kernel/futex.c
index 50f61d0e51b59..e7798ef3b4b71 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3306,11 +3306,22 @@ static void futex_cleanup(struct task_struct *tsk)
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
@@ -3334,6 +3345,11 @@ static void futex_cleanup_end(struct task_struct *tsk, int state)
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

