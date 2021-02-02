Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D5530C10C
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbhBBOMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 09:12:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:49660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233730AbhBBOLi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:11:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98D0964F45;
        Tue,  2 Feb 2021 13:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273889;
        bh=yW4YfKZgRBG8juWBhGSURT8BOs/Hjb3RFDur95qg9q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eiIzH2BamhHFFjXzDG3XlPsFqkq+Wpx2Yy+xxvio1fNrRXb8WmSrnPJU53U+jePO6
         N5fXpstWzGfmR2SfiCWs88tVIGwTbSRLygtmxTU9r8YJ8ee39mXAljMgv5VhYi0gka
         ULEHucXR0ChdKLFIHaNxJbeK3Xk08Z4aGp+WbArM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 4.9 13/32] futex: Add mutex around futex exit
Date:   Tue,  2 Feb 2021 14:38:36 +0100
Message-Id: <20210202132942.549589995@linuxfoundation.org>
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

commit 3f186d974826847a07bc7964d79ec4eded475ad9 upstream.

The mutex will be used in subsequent changes to replace the busy looping of
a waiter when the futex owner is currently executing the exit cleanup to
prevent a potential live lock.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20191106224556.845798895@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/futex.h |    1 +
 include/linux/sched.h |    1 +
 kernel/futex.c        |   16 ++++++++++++++++
 3 files changed, 18 insertions(+)

--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -70,6 +70,7 @@ static inline void futex_init_task(struc
 	INIT_LIST_HEAD(&tsk->pi_state_list);
 	tsk->pi_state_cache = NULL;
 	tsk->futex_state = FUTEX_STATE_OK;
+	mutex_init(&tsk->futex_exit_mutex);
 }
 
 void futex_exit_recursive(struct task_struct *tsk);
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
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3306,12 +3306,23 @@ static void futex_cleanup(struct task_st
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
 	/*
+	 * Prevent various race issues against a concurrent incoming waiter
+	 * including live locks by forcing the waiter to block on
+	 * tsk->futex_exit_mutex when it observes FUTEX_STATE_EXITING in
+	 * attach_to_pi_owner().
+	 */
+	mutex_lock(&tsk->futex_exit_mutex);
+
+	/*
 	 * Switch the state to FUTEX_STATE_EXITING under tsk->pi_lock.
 	 *
 	 * This ensures that all subsequent checks of tsk->futex_state in
@@ -3334,6 +3345,11 @@ static void futex_cleanup_end(struct tas
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


