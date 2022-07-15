Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC20457625D
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 15:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbiGONAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 09:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiGONAK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 09:00:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE4214D0F
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 06:00:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66FAC62395
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 13:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB8EC34115;
        Fri, 15 Jul 2022 13:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657890008;
        bh=ba+rD8TJO8JaHDS6z7pvawGS69EHzw/IDDPn4U5C3So=;
        h=Subject:To:Cc:From:Date:From;
        b=iofMeAvSI6IpXvcJ93RWhFipOnrF/NoAono7dEcP3sl1vLjTFGLqZJsjR6HLx7Dr3
         /WEPhl9Zc3HT9ge1qWWnqa3h0CciVnhAYeK1U+G0pruFZLNFZ/tj9R/Fq7qFj0FQej
         vwzfAKlQtYEkXv/zvJ4kaao0yo7C/DGiHtDC49LE=
Subject: FAILED: patch "[PATCH] fix race between exit_itimers() and /proc/pid/timers" failed to apply to 4.9-stable tree
To:     oleg@redhat.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Jul 2022 14:59:52 +0200
Message-ID: <165788999219535@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d5b36a4dbd06c5e8e36ca8ccc552f679069e2946 Mon Sep 17 00:00:00 2001
From: Oleg Nesterov <oleg@redhat.com>
Date: Mon, 11 Jul 2022 18:16:25 +0200
Subject: [PATCH] fix race between exit_itimers() and /proc/pid/timers

As Chris explains, the comment above exit_itimers() is not correct,
we can race with proc_timers_seq_ops. Change exit_itimers() to clear
signal->posix_timers with ->siglock held.

Cc: <stable@vger.kernel.org>
Reported-by: chris@accessvector.net
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/exec.c b/fs/exec.c
index 0989fb8472a1..778123259e42 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1301,7 +1301,7 @@ int begin_new_exec(struct linux_binprm * bprm)
 	bprm->mm = NULL;
 
 #ifdef CONFIG_POSIX_TIMERS
-	exit_itimers(me->signal);
+	exit_itimers(me);
 	flush_itimer_signals();
 #endif
 
diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index 505aaf9fe477..81cab4b01edc 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -85,7 +85,7 @@ static inline void exit_thread(struct task_struct *tsk)
 extern __noreturn void do_group_exit(int);
 
 extern void exit_files(struct task_struct *);
-extern void exit_itimers(struct signal_struct *);
+extern void exit_itimers(struct task_struct *);
 
 extern pid_t kernel_clone(struct kernel_clone_args *kargs);
 struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node);
diff --git a/kernel/exit.c b/kernel/exit.c
index f072959fcab7..64c938ce36fe 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -766,7 +766,7 @@ void __noreturn do_exit(long code)
 
 #ifdef CONFIG_POSIX_TIMERS
 		hrtimer_cancel(&tsk->signal->real_timer);
-		exit_itimers(tsk->signal);
+		exit_itimers(tsk);
 #endif
 		if (tsk->mm)
 			setmax_mm_hiwater_rss(&tsk->signal->maxrss, tsk->mm);
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 1cd10b102c51..5dead89308b7 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -1051,15 +1051,24 @@ static void itimer_delete(struct k_itimer *timer)
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

