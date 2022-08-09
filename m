Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8E858DFAD
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 21:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245670AbiHITEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 15:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343772AbiHITDK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 15:03:10 -0400
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2631F2B619;
        Tue,  9 Aug 2022 11:37:41 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:59912)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oLU6m-00Do99-GN; Tue, 09 Aug 2022 12:37:40 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:38634 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oLU6l-002rCO-HA; Tue, 09 Aug 2022 12:37:40 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        stable@vger.kernel.org
References: <20220809170751.164716-1-cascardo@canonical.com>
Date:   Tue, 09 Aug 2022 13:37:14 -0500
In-Reply-To: <20220809170751.164716-1-cascardo@canonical.com> (Thadeu Lima de
        Souza Cascardo's message of "Tue, 9 Aug 2022 14:07:51 -0300")
Message-ID: <87wnbhxnz9.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1oLU6l-002rCO-HA;;;mid=<87wnbhxnz9.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX1/UwIv/sDnk+velCRIhMdo+ZBZMJ2rguDo=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 424 ms - load_scoreonly_sql: 0.07 (0.0%),
        signal_user_changed: 11 (2.7%), b_tie_ro: 10 (2.3%), parse: 1.10
        (0.3%), extract_message_metadata: 13 (3.1%), get_uri_detail_list: 1.82
        (0.4%), tests_pri_-1000: 13 (3.0%), tests_pri_-950: 1.38 (0.3%),
        tests_pri_-900: 1.05 (0.2%), tests_pri_-90: 77 (18.1%), check_bayes:
        75 (17.7%), b_tokenize: 8 (1.8%), b_tok_get_all: 8 (1.9%),
        b_comp_prob: 2.5 (0.6%), b_tok_touch_all: 53 (12.6%), b_finish: 1.00
        (0.2%), tests_pri_0: 289 (68.2%), check_dkim_signature: 0.85 (0.2%),
        check_dkim_adsp: 2.5 (0.6%), poll_dns_idle: 0.83 (0.2%), tests_pri_10:
        2.1 (0.5%), tests_pri_500: 12 (2.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] posix-cpu-timers: Cleanup CPU timers before freeing
 them during exec
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thadeu Lima de Souza Cascardo <cascardo@canonical.com> writes:

> Commit 55e8c8eb2c7b ("posix-cpu-timers: Store a reference to a pid not a
> task") started looking up tasks by PID when deleting a CPU timer.
>
> When a non-leader thread calls execve, it will switch PIDs with the leader
> process. Then, as it calls exit_itimers, posix_cpu_timer_del cannot find
> the task because the timer still points out to the old PID.


I think this description is missing something.

Looking at how clock_pid_type selects which task to go through
to obtain the sighand lock, and the fact that the sighand_struct
can change during exec all make me think that this change isn't
necessarily wrong, I am just trying to understand what is going
on that makes this necessary.

The function cpu_timer_task_rcu should return the one remaining task if
it is process wide timer, as all of the other threads have been reaped
after de_thread.

For a per thread timer for the surviving thread I can see exchange_tids
causing clock_pid_type to returning the threads old pid, and which
exchange_tids attached to a task that de_thread has freed with
release_task.

If that analysis is correct I think your change is safe only
because posix_cpu_timers_exit does not do anything with the pids.

Perhaps it would be better to do something like the diff below.  That
is always call posix_cpu_timers_exit before exchange_tids can run.  That
way there is nothing clever going on for us to stumble over later.

Once long ago I tried to remove the pid swap but unfortunately the
glibc pthread relies on the fact that getpid() == gettid() for the
first thread after exec.  Sigh.

diff --git a/fs/exec.c b/fs/exec.c
index 45914e57c0d5..a2a0b3faf603 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1072,6 +1072,10 @@ static int de_thread(struct task_struct *tsk)
 	if (!thread_group_leader(tsk))
 		sig->notify_count--;
 
+#ifdef CONFIG_POSIX_TIMERS
+	/* Cleanup the per thread timers before the pid changes */
+	posix_cpu_timers_exit(tsk);
+#endif
 	while (sig->notify_count) {
 		__set_current_state(TASK_KILLABLE);
 		spin_unlock_irq(lock);
diff --git a/kernel/exit.c b/kernel/exit.c
index 4f7424523bac..f7e19b73cf6c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -104,7 +104,6 @@ static void __exit_signal(struct task_struct *tsk)
 	spin_lock(&sighand->siglock);
 
 #ifdef CONFIG_POSIX_TIMERS
-	posix_cpu_timers_exit(tsk);
 	if (group_dead)
 		posix_cpu_timers_exit_group(tsk);
 #endif
@@ -772,6 +771,12 @@ void __noreturn do_exit(long code)
 	if (tsk->mm)
 		sync_mm_rss(tsk->mm);
 	acct_update_integrals(tsk);
+#ifdef CONFIG_POSIX_TIMERS
+	/* Cleanup the per thread timers before de_thread can change the pid */
+	spin_lock_irq(&tsk->sighand->siglock);
+	posix_cpu_timers_exit(tsk);
+	spin_unlock_irq(&tsk->sighand->siglock);
+#endif
 	group_dead = atomic_dec_and_test(&tsk->signal->live);
 	if (group_dead) {
 		/*

Eric
