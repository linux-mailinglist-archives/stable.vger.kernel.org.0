Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F4F65BBB7
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236997AbjACIPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236972AbjACIPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:15:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20285DF47
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:14:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7E10B80E49
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C372C433EF;
        Tue,  3 Jan 2023 08:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733691;
        bh=cvRm7o9B1QSPX1e+Zrk8vy7BHM1Br2gkNpATpkyE3Gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lIYjBEgqKbRfcwqFfxUrezUawBOFYeUE2hwDCpkqv5EMyLo9LRqhBtkL2HlpsULJy
         dKVy63m4bVBqzmQ8AfizCKueamqQzkQY4pWc8SbedcUwbQGJL+dXEFa9Fdtiq+4IVn
         izI9lGYuKmx6vpG7bWO29uJV3g7Hjjw/UR1bjQJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 5.10 11/63] signal: Add task_sigpending() helper
Date:   Tue,  3 Jan 2023 09:13:41 +0100
Message-Id: <20230103081309.240467560@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 5c251e9dc0e127bac6fc5b8e6696363d2e35f515 ]

This is in preparation for maintaining signal_pending() as the decider of
whether or not a schedule() loop should be broken, or continue sleeping.
This is different than the core signal use cases, which really need to know
whether an actual signal is pending or not. task_sigpending() returns
non-zero if TIF_SIGPENDING is set.

Only core kernel use cases should care about the distinction between
the two, make sure those use the task_sigpending() helper.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Link: https://lore.kernel.org/r/20201026203230.386348-2-axboe@kernel.dk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sched/signal.h |    9 +++++++--
 kernel/events/uprobes.c      |    2 +-
 kernel/signal.c              |    8 ++++----
 3 files changed, 12 insertions(+), 7 deletions(-)

--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -354,11 +354,16 @@ static inline int restart_syscall(void)
 	return -ERESTARTNOINTR;
 }
 
-static inline int signal_pending(struct task_struct *p)
+static inline int task_sigpending(struct task_struct *p)
 {
 	return unlikely(test_tsk_thread_flag(p,TIF_SIGPENDING));
 }
 
+static inline int signal_pending(struct task_struct *p)
+{
+	return task_sigpending(p);
+}
+
 static inline int __fatal_signal_pending(struct task_struct *p)
 {
 	return unlikely(sigismember(&p->pending.signal, SIGKILL));
@@ -366,7 +371,7 @@ static inline int __fatal_signal_pending
 
 static inline int fatal_signal_pending(struct task_struct *p)
 {
-	return signal_pending(p) && __fatal_signal_pending(p);
+	return task_sigpending(p) && __fatal_signal_pending(p);
 }
 
 static inline int signal_pending_state(long state, struct task_struct *p)
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1973,7 +1973,7 @@ bool uprobe_deny_signal(void)
 
 	WARN_ON_ONCE(utask->state != UTASK_SSTEP);
 
-	if (signal_pending(t)) {
+	if (task_sigpending(t)) {
 		spin_lock_irq(&t->sighand->siglock);
 		clear_tsk_thread_flag(t, TIF_SIGPENDING);
 		spin_unlock_irq(&t->sighand->siglock);
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -984,7 +984,7 @@ static inline bool wants_signal(int sig,
 	if (task_is_stopped_or_traced(p))
 		return false;
 
-	return task_curr(p) || !signal_pending(p);
+	return task_curr(p) || !task_sigpending(p);
 }
 
 static void complete_signal(int sig, struct task_struct *p, enum pid_type type)
@@ -2813,7 +2813,7 @@ static void retarget_shared_pending(stru
 		/* Remove the signals this thread can handle. */
 		sigandsets(&retarget, &retarget, &t->blocked);
 
-		if (!signal_pending(t))
+		if (!task_sigpending(t))
 			signal_wake_up(t, 0);
 
 		if (sigisemptyset(&retarget))
@@ -2847,7 +2847,7 @@ void exit_signals(struct task_struct *ts
 
 	cgroup_threadgroup_change_end(tsk);
 
-	if (!signal_pending(tsk))
+	if (!task_sigpending(tsk))
 		goto out;
 
 	unblocked = tsk->blocked;
@@ -2891,7 +2891,7 @@ long do_no_restart_syscall(struct restar
 
 static void __set_task_blocked(struct task_struct *tsk, const sigset_t *newset)
 {
-	if (signal_pending(tsk) && !thread_group_empty(tsk)) {
+	if (task_sigpending(tsk) && !thread_group_empty(tsk)) {
 		sigset_t newblocked;
 		/* A set of now blocked but previously unblocked signals. */
 		sigandnsets(&newblocked, newset, &current->blocked);


