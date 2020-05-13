Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127801D0F1D
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732894AbgEMKEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 06:04:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732887AbgEMJrh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:47:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4156C20769;
        Wed, 13 May 2020 09:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363256;
        bh=GUIpK23XvnwYuYschf4nAkND8B9/PhPFyFh4GqVIbfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Sh+U0v/4ZxzF8Mkay1fCJ2S7DdRXhBjdgPciApNmDL92DzpHi7d8vsv0tIyb+80h
         rjOv8sgK7ORzkZLWqj5hW4f8QgDtc+UA24QjieqWEHQuMRcIkM3lVmed7TvGYEjgK3
         0LpLAWkNyuDfY7ULWb6RtTPe34lLShyFG/8WnCG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yoji <yoji.fujihar.min@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Markus Elfring <elfring@users.sourceforge.net>, 1vier1@web.de,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 48/48] ipc/mqueue.c: change __do_notify() to bypass check_kill_permission()
Date:   Wed, 13 May 2020 11:45:14 +0200
Message-Id: <20200513094405.122260162@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094351.100352960@linuxfoundation.org>
References: <20200513094351.100352960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

[ Upstream commit b5f2006144c6ae941726037120fa1001ddede784 ]

Commit cc731525f26a ("signal: Remove kernel interal si_code magic")
changed the value of SI_FROMUSER(SI_MESGQ), this means that mq_notify() no
longer works if the sender doesn't have rights to send a signal.

Change __do_notify() to use do_send_sig_info() instead of kill_pid_info()
to avoid check_kill_permission().

This needs the additional notify.sigev_signo != 0 check, shouldn't we
change do_mq_notify() to deny sigev_signo == 0 ?

Test-case:

	#include <signal.h>
	#include <mqueue.h>
	#include <unistd.h>
	#include <sys/wait.h>
	#include <assert.h>

	static int notified;

	static void sigh(int sig)
	{
		notified = 1;
	}

	int main(void)
	{
		signal(SIGIO, sigh);

		int fd = mq_open("/mq", O_RDWR|O_CREAT, 0666, NULL);
		assert(fd >= 0);

		struct sigevent se = {
			.sigev_notify	= SIGEV_SIGNAL,
			.sigev_signo	= SIGIO,
		};
		assert(mq_notify(fd, &se) == 0);

		if (!fork()) {
			assert(setuid(1) == 0);
			mq_send(fd, "",1,0);
			return 0;
		}

		wait(NULL);
		mq_unlink("/mq");
		assert(notified);
		return 0;
	}

[manfred@colorfullife.com: 1) Add self_exec_id evaluation so that the implementation matches do_notify_parent 2) use PIDTYPE_TGID everywhere]
Fixes: cc731525f26a ("signal: Remove kernel interal si_code magic")
Reported-by: Yoji <yoji.fujihar.min@gmail.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Markus Elfring <elfring@users.sourceforge.net>
Cc: <1vier1@web.de>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/e2a782e4-eab9-4f5c-c749-c07a8f7a4e66@colorfullife.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 ipc/mqueue.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index de4070d5472f2..46d0265423f5b 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -76,6 +76,7 @@ struct mqueue_inode_info {
 
 	struct sigevent notify;
 	struct pid *notify_owner;
+	u32 notify_self_exec_id;
 	struct user_namespace *notify_user_ns;
 	struct user_struct *user;	/* user who created, for accounting */
 	struct sock *notify_sock;
@@ -662,28 +663,44 @@ static void __do_notify(struct mqueue_inode_info *info)
 	 * synchronously. */
 	if (info->notify_owner &&
 	    info->attr.mq_curmsgs == 1) {
-		struct siginfo sig_i;
 		switch (info->notify.sigev_notify) {
 		case SIGEV_NONE:
 			break;
-		case SIGEV_SIGNAL:
-			/* sends signal */
+		case SIGEV_SIGNAL: {
+			struct siginfo sig_i;
+			struct task_struct *task;
+
+			/* do_mq_notify() accepts sigev_signo == 0, why?? */
+			if (!info->notify.sigev_signo)
+				break;
 
 			clear_siginfo(&sig_i);
 			sig_i.si_signo = info->notify.sigev_signo;
 			sig_i.si_errno = 0;
 			sig_i.si_code = SI_MESGQ;
 			sig_i.si_value = info->notify.sigev_value;
-			/* map current pid/uid into info->owner's namespaces */
 			rcu_read_lock();
+			/* map current pid/uid into info->owner's namespaces */
 			sig_i.si_pid = task_tgid_nr_ns(current,
 						ns_of_pid(info->notify_owner));
-			sig_i.si_uid = from_kuid_munged(info->notify_user_ns, current_uid());
+			sig_i.si_uid = from_kuid_munged(info->notify_user_ns,
+						current_uid());
+			/*
+			 * We can't use kill_pid_info(), this signal should
+			 * bypass check_kill_permission(). It is from kernel
+			 * but si_fromuser() can't know this.
+			 * We do check the self_exec_id, to avoid sending
+			 * signals to programs that don't expect them.
+			 */
+			task = pid_task(info->notify_owner, PIDTYPE_TGID);
+			if (task && task->self_exec_id ==
+						info->notify_self_exec_id) {
+				do_send_sig_info(info->notify.sigev_signo,
+						&sig_i, task, PIDTYPE_TGID);
+			}
 			rcu_read_unlock();
-
-			kill_pid_info(info->notify.sigev_signo,
-				      &sig_i, info->notify_owner);
 			break;
+		}
 		case SIGEV_THREAD:
 			set_cookie(info->notify_cookie, NOTIFY_WOKENUP);
 			netlink_sendskb(info->notify_sock, info->notify_cookie);
@@ -1273,6 +1290,7 @@ retry:
 			info->notify.sigev_signo = notification->sigev_signo;
 			info->notify.sigev_value = notification->sigev_value;
 			info->notify.sigev_notify = SIGEV_SIGNAL;
+			info->notify_self_exec_id = current->self_exec_id;
 			break;
 		}
 
-- 
2.20.1



