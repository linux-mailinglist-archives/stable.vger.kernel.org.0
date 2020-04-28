Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACFB91BC897
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbgD1Sd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:33:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730011AbgD1Sd6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:33:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85EEE20575;
        Tue, 28 Apr 2020 18:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098837;
        bh=EGlY97GK0ijcW+1LMPkvF75GLNdBEqnwBDP+xSKZCk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fa9lGD7J2FSOyYfjKI5sutagnjiA91ZBvilk+s+7goNZl5f4pANRB3/Thopzqne6h
         P7ekA8RMVspdF6ViIZ69OPZvMF/0W1ab+UURGpRd8oanr7fhoX+k6YBYejAGmvjwam
         tX40z2rfM8d3gpXc9gkcRy1JmiyoavHFXh6Bx3YM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christof Meerwald <cmeerw@cmeerw.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.6 118/167] signal: Avoid corrupting si_pid and si_uid in do_notify_parent
Date:   Tue, 28 Apr 2020 20:24:54 +0200
Message-Id: <20200428182240.149941180@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit 61e713bdca3678e84815f2427f7a063fc353a1fc upstream.

Christof Meerwald <cmeerw@cmeerw.org> writes:
> Hi,
>
> this is probably related to commit
> 7a0cf094944e2540758b7f957eb6846d5126f535 (signal: Correct namespace
> fixups of si_pid and si_uid).
>
> With a 5.6.5 kernel I am seeing SIGCHLD signals that don't include a
> properly set si_pid field - this seems to happen for multi-threaded
> child processes.
>
> A simple test program (based on the sample from the signalfd man page):
>
> #include <sys/signalfd.h>
> #include <signal.h>
> #include <unistd.h>
> #include <spawn.h>
> #include <stdlib.h>
> #include <stdio.h>
>
> #define handle_error(msg) \
>     do { perror(msg); exit(EXIT_FAILURE); } while (0)
>
> int main(int argc, char *argv[])
> {
>   sigset_t mask;
>   int sfd;
>   struct signalfd_siginfo fdsi;
>   ssize_t s;
>
>   sigemptyset(&mask);
>   sigaddset(&mask, SIGCHLD);
>
>   if (sigprocmask(SIG_BLOCK, &mask, NULL) == -1)
>     handle_error("sigprocmask");
>
>   pid_t chldpid;
>   char *chldargv[] = { "./sfdclient", NULL };
>   posix_spawn(&chldpid, "./sfdclient", NULL, NULL, chldargv, NULL);
>
>   sfd = signalfd(-1, &mask, 0);
>   if (sfd == -1)
>     handle_error("signalfd");
>
>   for (;;) {
>     s = read(sfd, &fdsi, sizeof(struct signalfd_siginfo));
>     if (s != sizeof(struct signalfd_siginfo))
>       handle_error("read");
>
>     if (fdsi.ssi_signo == SIGCHLD) {
>       printf("Got SIGCHLD %d %d %d %d\n",
>           fdsi.ssi_status, fdsi.ssi_code,
>           fdsi.ssi_uid, fdsi.ssi_pid);
>       return 0;
>     } else {
>       printf("Read unexpected signal\n");
>     }
>   }
> }
>
>
> and a multi-threaded client to test with:
>
> #include <unistd.h>
> #include <pthread.h>
>
> void *f(void *arg)
> {
>   sleep(100);
> }
>
> int main()
> {
>   pthread_t t[8];
>
>   for (int i = 0; i != 8; ++i)
>   {
>     pthread_create(&t[i], NULL, f, NULL);
>   }
> }
>
> I tried to do a bit of debugging and what seems to be happening is
> that
>
>   /* From an ancestor pid namespace? */
>   if (!task_pid_nr_ns(current, task_active_pid_ns(t))) {
>
> fails inside task_pid_nr_ns because the check for "pid_alive" fails.
>
> This code seems to be called from do_notify_parent and there we
> actually have "tsk != current" (I am assuming both are threads of the
> current process?)

I instrumented the code with a warning and received the following backtrace:
> WARNING: CPU: 0 PID: 777 at kernel/pid.c:501 __task_pid_nr_ns.cold.6+0xc/0x15
> Modules linked in:
> CPU: 0 PID: 777 Comm: sfdclient Not tainted 5.7.0-rc1userns+ #2924
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> RIP: 0010:__task_pid_nr_ns.cold.6+0xc/0x15
> Code: ff 66 90 48 83 ec 08 89 7c 24 04 48 8d 7e 08 48 8d 74 24 04 e8 9a b6 44 00 48 83 c4 08 c3 48 c7 c7 59 9f ac 82 e8 c2 c4 04 00 <0f> 0b e9 3fd
> RSP: 0018:ffffc9000042fbf8 EFLAGS: 00010046
> RAX: 000000000000000c RBX: 0000000000000000 RCX: ffffc9000042faf4
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81193d29
> RBP: ffffc9000042fc18 R08: 0000000000000000 R09: 0000000000000001
> R10: 000000100f938416 R11: 0000000000000309 R12: ffff8880b941c140
> R13: 0000000000000000 R14: 0000000000000000 R15: ffff8880b941c140
> FS:  0000000000000000(0000) GS:ffff8880bca00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f2e8c0a32e0 CR3: 0000000002e10000 CR4: 00000000000006f0
> Call Trace:
>  send_signal+0x1c8/0x310
>  do_notify_parent+0x50f/0x550
>  release_task.part.21+0x4fd/0x620
>  do_exit+0x6f6/0xaf0
>  do_group_exit+0x42/0xb0
>  get_signal+0x13b/0xbb0
>  do_signal+0x2b/0x670
>  ? __audit_syscall_exit+0x24d/0x2b0
>  ? rcu_read_lock_sched_held+0x4d/0x60
>  ? kfree+0x24c/0x2b0
>  do_syscall_64+0x176/0x640
>  ? trace_hardirqs_off_thunk+0x1a/0x1c
>  entry_SYSCALL_64_after_hwframe+0x49/0xb3

The immediate problem is as Christof noticed that "pid_alive(current) == false".
This happens because do_notify_parent is called from the last thread to exit
in a process after that thread has been reaped.

The bigger issue is that do_notify_parent can be called from any
process that manages to wait on a thread of a multi-threaded process
from wait_task_zombie.  So any logic based upon current for
do_notify_parent is just nonsense, as current can be pretty much
anything.

So change do_notify_parent to call __send_signal directly.

Inspecting the code it appears this problem has existed since the pid
namespace support started handling this case in 2.6.30.  This fix only
backports to 7a0cf094944e ("signal: Correct namespace fixups of si_pid and si_uid")
where the problem logic was moved out of __send_signal and into send_signal.

Cc: stable@vger.kernel.org
Fixes: 6588c1e3ff01 ("signals: SI_USER: Masquerade si_pid when crossing pid ns boundary")
Ref: 921cf9f63089 ("signals: protect cinit from unblocked SIG_DFL signals")
Link: https://lore.kernel.org/lkml/20200419201336.GI22017@edge.cmeerw.net/
Reported-by: Christof Meerwald <cmeerw@cmeerw.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/signal.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1993,8 +1993,12 @@ bool do_notify_parent(struct task_struct
 		if (psig->action[SIGCHLD-1].sa.sa_handler == SIG_IGN)
 			sig = 0;
 	}
+	/*
+	 * Send with __send_signal as si_pid and si_uid are in the
+	 * parent's namespaces.
+	 */
 	if (valid_signal(sig) && sig)
-		__group_send_sig_info(sig, &info, tsk->parent);
+		__send_signal(sig, &info, tsk->parent, PIDTYPE_TGID, false);
 	__wake_up_parent(tsk, tsk->parent);
 	spin_unlock_irqrestore(&psig->siglock, flags);
 


