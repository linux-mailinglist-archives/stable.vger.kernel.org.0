Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CA129836B
	for <lists+stable@lfdr.de>; Sun, 25 Oct 2020 20:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1418612AbgJYTpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Oct 2020 15:45:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1418608AbgJYTpX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 25 Oct 2020 15:45:23 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA31C2222C;
        Sun, 25 Oct 2020 19:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603655123;
        bh=rNlExHitv58TdCAgcht8DmfvbpZ0dm8In8ohJtF4Duw=;
        h=Date:From:To:Subject:From;
        b=WhVrbK/QEKfreeYDWz4e7mGyIBYuG8f7nnnl0DOuWCiOdYMd0jO1xal0m/YdKL7XT
         mftHTz2kXyxmoOR1iQtThRDGFxSC8+WxlMi0VRYeY6CjlippIJF/Bw+sHAgH+OLDzY
         Ol9bPlGboPs3TXzy6x82ezpIy821xmi9skRLS4s0=
Date:   Sun, 25 Oct 2020 12:45:22 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tj@kernel.org, stable@vger.kernel.org,
        liuzhiqiang26@huawei.com, ebiederm@xmission.com,
        christian@brauner.io, axboe@kernel.dk, oleg@redhat.com
Subject:  +
 ptrace-fix-task_join_group_stop-for-the-case-when-current-is-traced.patch
 added to -mm tree
Message-ID: <20201025194522.hA2XT%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ptrace: fix task_join_group_stop() for the case when current is traced
has been added to the -mm tree.  Its filename is
     ptrace-fix-task_join_group_stop-for-the-case-when-current-is-traced.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ptrace-fix-task_join_group_stop-for-the-case-when-current-is-traced.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ptrace-fix-task_join_group_stop-for-the-case-when-current-is-traced.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: ptrace: fix task_join_group_stop() for the case when current is traced

This testcase

	#include <stdio.h>
	#include <unistd.h>
	#include <signal.h>
	#include <sys/ptrace.h>
	#include <sys/wait.h>
	#include <pthread.h>
	#include <assert.h>

	void *tf(void *arg)
	{
		return NULL;
	}

	int main(void)
	{
		int pid = fork();
		if (!pid) {
			kill(getpid(), SIGSTOP);

			pthread_t th;
			pthread_create(&th, NULL, tf, NULL);

			return 0;
		}

		waitpid(pid, NULL, WSTOPPED);

		ptrace(PTRACE_SEIZE, pid, 0, PTRACE_O_TRACECLONE);
		waitpid(pid, NULL, 0);

		ptrace(PTRACE_CONT, pid, 0,0);
		waitpid(pid, NULL, 0);

		int status;
		int thread = waitpid(-1, &status, 0);
		assert(thread > 0 && thread != pid);
		assert(status == 0x80137f);

		return 0;
	}

fails and triggers WARN_ON_ONCE(!signr) in do_jobctl_trap().

This is because task_join_group_stop() has 2 problems when current is traced:

	1. We can't rely on the "JOBCTL_STOP_PENDING" check, a stopped tracee
	   can be woken up by debugger and it can clone another thread which
	   should join the group-stop.

	   We need to check group_stop_count || SIGNAL_STOP_STOPPED.

	2. If SIGNAL_STOP_STOPPED is already set, we should not increment
	   sig->group_stop_count and add JOBCTL_STOP_CONSUME. The new thread
	   should stop without another do_notify_parent_cldstop() report.

To clarify, the problem is very old and we should blame
ptrace_init_task().  But now that we have task_join_group_stop() it makes
more sense to fix this helper to avoid the code duplication.

Link: https://lkml.kernel.org/r/20201019134237.GA18810@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: syzbot+3485e3773f7da290eecc@syzkaller.appspotmail.com
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <christian@brauner.io>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/kernel/signal.c~ptrace-fix-task_join_group_stop-for-the-case-when-current-is-traced
+++ a/kernel/signal.c
@@ -391,16 +391,17 @@ static bool task_participate_group_stop(
 
 void task_join_group_stop(struct task_struct *task)
 {
+	unsigned long mask = current->jobctl & JOBCTL_STOP_SIGMASK;
+	struct signal_struct *sig = current->signal;
+
+	if (sig->group_stop_count) {
+		sig->group_stop_count++;
+		mask |= JOBCTL_STOP_CONSUME;
+	} else if (!(sig->flags & SIGNAL_STOP_STOPPED))
+		return;
+
 	/* Have the new thread join an on-going signal group stop */
-	unsigned long jobctl = current->jobctl;
-	if (jobctl & JOBCTL_STOP_PENDING) {
-		struct signal_struct *sig = current->signal;
-		unsigned long signr = jobctl & JOBCTL_STOP_SIGMASK;
-		unsigned long gstop = JOBCTL_STOP_PENDING | JOBCTL_STOP_CONSUME;
-		if (task_set_jobctl_pending(task, signr | gstop)) {
-			sig->group_stop_count++;
-		}
-	}
+	task_set_jobctl_pending(task, mask | JOBCTL_STOP_PENDING);
 }
 
 /*
_

Patches currently in -mm which might be from oleg@redhat.com are

ptrace-fix-task_join_group_stop-for-the-case-when-current-is-traced.patch
aio-simplify-read_events.patch

