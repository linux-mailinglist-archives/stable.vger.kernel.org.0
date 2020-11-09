Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94CB2AB970
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731473AbgKINJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:09:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:34148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731812AbgKINJO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:09:14 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 349D520663;
        Mon,  9 Nov 2020 13:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927353;
        bh=CWceMhB0cPrlGmheUzrBUAb/GEZjuNyVqksjiSGqbSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=laiU8ncdX46hu8Fbk93haEmt4ZLVdC1YNYVV6yXGTqQmC2kJxcXSaz3ZGzoSW0qo+
         VnRKbWV4Z/Dj/ijUD1Kaf5lW495ZYm0tEmWQ6l7pDbaJz7m3X3DX49kd/Gx9q5uEqN
         OMTysYfE0anhw/1hso4bRQzJAf5kK1yWwZl2VpfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+3485e3773f7da290eecc@syzkaller.appspotmail.com,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <christian@brauner.io>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 03/71] ptrace: fix task_join_group_stop() for the case when current is traced
Date:   Mon,  9 Nov 2020 13:54:57 +0100
Message-Id: <20201109125020.066127281@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
References: <20201109125019.906191744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

commit 7b3c36fc4c231ca532120bbc0df67a12f09c1d96 upstream.

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

Reported-by: syzbot+3485e3773f7da290eecc@syzkaller.appspotmail.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <christian@brauner.io>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20201019134237.GA18810@redhat.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/signal.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -385,16 +385,17 @@ static bool task_participate_group_stop(
 
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


