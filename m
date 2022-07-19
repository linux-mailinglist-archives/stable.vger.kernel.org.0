Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3093B579BAB
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240851AbiGSMaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240557AbiGSM3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:29:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978876A9DB;
        Tue, 19 Jul 2022 05:11:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 076F9B81B31;
        Tue, 19 Jul 2022 12:11:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E492C36AEF;
        Tue, 19 Jul 2022 12:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232676;
        bh=GWvAQx0tgg8EEA1qM3b01H386Iq5ubCuuE5kSze3yTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eWId6kjQ0NWZbLSwzjDLJFa3QN/KT6pDQgBHqSImehsuTiL/uJuKpAVg32e6/ykY+
         tC0Ohk/DpcN/0X4+p/pY2Hb28xSD/bY1Nzw7pu0VeBu5p8lo6vfQobfLTPkMhK79L0
         Gk+y5ptnS/hl5upG94laAiPDnD42Svdky866cucc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, chris@accessvector.net,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 009/167] fix race between exit_itimers() and /proc/pid/timers
Date:   Tue, 19 Jul 2022 13:52:21 +0200
Message-Id: <20220719114657.607636428@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

commit d5b36a4dbd06c5e8e36ca8ccc552f679069e2946 upstream.

As Chris explains, the comment above exit_itimers() is not correct,
we can race with proc_timers_seq_ops. Change exit_itimers() to clear
signal->posix_timers with ->siglock held.

Cc: <stable@vger.kernel.org>
Reported-by: chris@accessvector.net
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exec.c                  |    2 +-
 include/linux/sched/task.h |    2 +-
 kernel/exit.c              |    2 +-
 kernel/time/posix-timers.c |   19 ++++++++++++++-----
 4 files changed, 17 insertions(+), 8 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1298,7 +1298,7 @@ int begin_new_exec(struct linux_binprm *
 	bprm->mm = NULL;
 
 #ifdef CONFIG_POSIX_TIMERS
-	exit_itimers(me->signal);
+	exit_itimers(me);
 	flush_itimer_signals();
 #endif
 
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -81,7 +81,7 @@ static inline void exit_thread(struct ta
 extern void do_group_exit(int);
 
 extern void exit_files(struct task_struct *);
-extern void exit_itimers(struct signal_struct *);
+extern void exit_itimers(struct task_struct *);
 
 extern pid_t kernel_clone(struct kernel_clone_args *kargs);
 struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node);
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -796,7 +796,7 @@ void __noreturn do_exit(long code)
 
 #ifdef CONFIG_POSIX_TIMERS
 		hrtimer_cancel(&tsk->signal->real_timer);
-		exit_itimers(tsk->signal);
+		exit_itimers(tsk);
 #endif
 		if (tsk->mm)
 			setmax_mm_hiwater_rss(&tsk->signal->maxrss, tsk->mm);
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -1051,15 +1051,24 @@ retry_delete:
 }
 
 /*
- * This is called by do_exit or de_thread, only when there are no more
- * references to the shared signal_struct.
+ * This is called by do_exit or de_thread, only when nobody else can
+ * modify the signal->posix_timers list. Yet we need sighand->siglock
+ * to prevent the race with /proc/pid/timers.
  */
-void exit_itimers(struct signal_struct *sig)
+void exit_itimers(struct task_struct *tsk)
 {
+	struct list_head timers;
 	struct k_itimer *tmr;
 
-	while (!list_empty(&sig->posix_timers)) {
-		tmr = list_entry(sig->posix_timers.next, struct k_itimer, list);
+	if (list_empty(&tsk->signal->posix_timers))
+		return;
+
+	spin_lock_irq(&tsk->sighand->siglock);
+	list_replace_init(&tsk->signal->posix_timers, &timers);
+	spin_unlock_irq(&tsk->sighand->siglock);
+
+	while (!list_empty(&timers)) {
+		tmr = list_first_entry(&timers, struct k_itimer, list);
 		itimer_delete(tmr);
 	}
 }


