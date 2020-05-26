Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3CD1BA979
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 18:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbgD0QAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 12:00:25 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:37467 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728489AbgD0QAZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 12:00:25 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2BA24194067B;
        Mon, 27 Apr 2020 12:00:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 27 Apr 2020 12:00:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+8X/zH
        YEASh7Q23VvCst/TnqkKnGtmDymba3tPfCQ+o=; b=ystF637xGnTzEFOmNNfSSJ
        KYRdSJ7N1v4QnQEAFgGVe+3ryAV8CDSAKYbhwQlZkPZCGQxzDH/y0su/AHZaGAx0
        sn8WHtxkRcXLeooRh74Vp+cYjd7iLKfIaO1YtT6jryHOAQNsR23sJxM0U8ZWjXf3
        fNBvUTWg5+jEmdARRCN5jVXM/wFGh8AUgVoeU6oX8IDqiBQpDVt7wrCqLx5cJRyF
        UC2cCXj+gUuojGkps4QQ611anDlBSbNGBMNZc6pOkLuWsfa21ov+llHAH9r9eO15
        MKLjYlo5P1VQc7WHNwHUo+slKGn2XazfkZ0CN9PreMQoa9tS5HkNkrWaUPVvln2w
        ==
X-ME-Sender: <xms:lgGnXv1CEXIut9_CmJDFbtRmn_fOT6LO4JQcS3X6affRTn7eNbXz8w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdelfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:lgGnXiXJ6dsTVnDQCO4-3WvpT4RvTu3y4HWHX3hPclJo922GqC6ODA>
    <xmx:lgGnXq7PCPMmmYdBE1g7z4TNN0A00sP5Mqn1mlTjSwIzFQhh30bpUw>
    <xmx:lgGnXpLKvcyi51YLNpnRhTRi54lrKI_0y1Kv38qBLJsg2N9tHaiWFg>
    <xmx:lwGnXtHE3pc98MM9jFUrTN0Kqz9f8YpnVSSC2qX7wxjFw-NCfxAFBA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A16393280067;
        Mon, 27 Apr 2020 12:00:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] signal: Avoid corrupting si_pid and si_uid in" failed to apply to 4.14-stable tree
To:     ebiederm@xmission.com, christian.brauner@ubuntu.com,
        cmeerw@cmeerw.org, oleg@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Apr 2020 18:00:18 +0200
Message-ID: <158800321824270@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 61e713bdca3678e84815f2427f7a063fc353a1fc Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 20 Apr 2020 11:41:50 -0500
Subject: [PATCH] signal: Avoid corrupting si_pid and si_uid in
 do_notify_parent

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

diff --git a/kernel/signal.c b/kernel/signal.c
index e58a6c619824..7938c60e11dd 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1993,8 +1993,12 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
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
 

