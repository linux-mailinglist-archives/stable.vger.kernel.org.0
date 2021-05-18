Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C319386EE3
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 03:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345528AbhERBLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 21:11:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345525AbhERBL0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 21:11:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27703613C5;
        Tue, 18 May 2021 01:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621300209;
        bh=dvRhylMM555JA8EOpyrJQdp6quiVFeZiBnuhqqBa5fY=;
        h=From:To:Cc:Subject:Date:From;
        b=Tp/aO6l1k5SITjc41imVCUNOJSwb1JFgTigNsZOsZ8J0eaGFTLG+pfSUosUiMzhK1
         8Fb7VzSQ6iQvY/1TAyxo9kwqD7zTxCjcog1mU595zHhGs4RrAWKllnMxie5dy+T1E+
         7Dpb67faLNp1ibboDv3mw6t4P9Sm89HVQEyQol9tTdZetH1QXUMYdfHVvJD8bQt7qr
         s9ILRv+w9tMxj8dTfhcURqxouXoJtiC7AwPd26J9zEWFFn/To86aD+15g7+3e7GgFM
         fUgZYT6GMPO0r5igaAtpyXh8oqEltawqmnC9psOLnRueZy1YIIsoqX7zm7eO02EavD
         6nuQgBX2k0wfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oleg Nesterov <oleg@redhat.com>,
        Simon Marchi <simon.marchi@efficios.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pedro Alves <palves@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 1/2] ptrace: make ptrace() fail if the tracee changed its pid unexpectedly
Date:   Mon, 17 May 2021 21:10:05 -0400
Message-Id: <20210518011006.1486026-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

[ Upstream commit dbb5afad100a828c97e012c6106566d99f041db6 ]

Suppose we have 2 threads, the group-leader L and a sub-theread T,
both parked in ptrace_stop(). Debugger tries to resume both threads
and does

	ptrace(PTRACE_CONT, T);
	ptrace(PTRACE_CONT, L);

If the sub-thread T execs in between, the 2nd PTRACE_CONT doesn not
resume the old leader L, it resumes the post-exec thread T which was
actually now stopped in PTHREAD_EVENT_EXEC. In this case the
PTHREAD_EVENT_EXEC event is lost, and the tracer can't know that the
tracee changed its pid.

This patch makes ptrace() fail in this case until debugger does wait()
and consumes PTHREAD_EVENT_EXEC which reports old_pid. This affects all
ptrace requests except the "asynchronous" PTRACE_INTERRUPT/KILL.

The patch doesn't add the new PTRACE_ option to not complicate the API,
and I _hope_ this won't cause any noticeable regression:

	- If debugger uses PTRACE_O_TRACEEXEC and the thread did an exec
	  and the tracer does a ptrace request without having consumed
	  the exec event, it's 100% sure that the thread the ptracer
	  thinks it is targeting does not exist anymore, or isn't the
	  same as the one it thinks it is targeting.

	- To some degree this patch adds nothing new. In the scenario
	  above ptrace(L) can fail with -ESRCH if it is called after the
	  execing sub-thread wakes the leader up and before it "steals"
	  the leader's pid.

Test-case:

	#include <stdio.h>
	#include <unistd.h>
	#include <signal.h>
	#include <sys/ptrace.h>
	#include <sys/wait.h>
	#include <errno.h>
	#include <pthread.h>
	#include <assert.h>

	void *tf(void *arg)
	{
		execve("/usr/bin/true", NULL, NULL);
		assert(0);

		return NULL;
	}

	int main(void)
	{
		int leader = fork();
		if (!leader) {
			kill(getpid(), SIGSTOP);

			pthread_t th;
			pthread_create(&th, NULL, tf, NULL);
			for (;;)
				pause();

			return 0;
		}

		waitpid(leader, NULL, WSTOPPED);

		ptrace(PTRACE_SEIZE, leader, 0,
				PTRACE_O_TRACECLONE | PTRACE_O_TRACEEXEC);
		waitpid(leader, NULL, 0);

		ptrace(PTRACE_CONT, leader, 0,0);
		waitpid(leader, NULL, 0);

		int status, thread = waitpid(-1, &status, 0);
		assert(thread > 0 && thread != leader);
		assert(status == 0x80137f);

		ptrace(PTRACE_CONT, thread, 0,0);
		/*
		 * waitid() because waitpid(leader, &status, WNOWAIT) does not
		 * report status. Why ????
		 *
		 * Why WEXITED? because we have another kernel problem connected
		 * to mt-exec.
		 */
		siginfo_t info;
		assert(waitid(P_PID, leader, &info, WSTOPPED|WEXITED|WNOWAIT) == 0);
		assert(info.si_pid == leader && info.si_status == 0x0405);

		/* OK, it sleeps in ptrace(PTRACE_EVENT_EXEC == 0x04) */
		assert(ptrace(PTRACE_CONT, leader, 0,0) == -1);
		assert(errno == ESRCH);

		assert(leader == waitpid(leader, &status, WNOHANG));
		assert(status == 0x04057f);

		assert(ptrace(PTRACE_CONT, leader, 0,0) == 0);

		return 0;
	}

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Simon Marchi <simon.marchi@efficios.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Pedro Alves <palves@redhat.com>
Acked-by: Simon Marchi <simon.marchi@efficios.com>
Acked-by: Jan Kratochvil <jan.kratochvil@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/ptrace.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index ecdb7402072f..af74e843221b 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -163,6 +163,21 @@ void __ptrace_unlink(struct task_struct *child)
 	spin_unlock(&child->sighand->siglock);
 }
 
+static bool looks_like_a_spurious_pid(struct task_struct *task)
+{
+	if (task->exit_code != ((PTRACE_EVENT_EXEC << 8) | SIGTRAP))
+		return false;
+
+	if (task_pid_vnr(task) == task->ptrace_message)
+		return false;
+	/*
+	 * The tracee changed its pid but the PTRACE_EVENT_EXEC event
+	 * was not wait()'ed, most probably debugger targets the old
+	 * leader which was destroyed in de_thread().
+	 */
+	return true;
+}
+
 /* Ensure that nothing can wake it up, even SIGKILL */
 static bool ptrace_freeze_traced(struct task_struct *task)
 {
@@ -173,7 +188,8 @@ static bool ptrace_freeze_traced(struct task_struct *task)
 		return ret;
 
 	spin_lock_irq(&task->sighand->siglock);
-	if (task_is_traced(task) && !__fatal_signal_pending(task)) {
+	if (task_is_traced(task) && !looks_like_a_spurious_pid(task) &&
+	    !__fatal_signal_pending(task)) {
 		task->state = __TASK_TRACED;
 		ret = true;
 	}
-- 
2.30.2

