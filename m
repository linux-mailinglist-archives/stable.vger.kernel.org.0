Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7601CA01E
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 03:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgEHBfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 21:35:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbgEHBfl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 21:35:41 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 935E4208D6;
        Fri,  8 May 2020 01:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588901740;
        bh=FPDT0W0AtRtGB503SATyNKtLfA9QKfQ0kS9zIImZNH0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DKtSi6oGnZtC3PMCDEFGCo/5QIl0gmOODYvdgTA5N0z1g75QlIgjCn5LhmiB2TrGO
         SpfP2LF7UuEuxLL+rnO0abUPJ1Ni0qN5jNLCV6zXRkBu64YyzmOGHxgqgK2uqrAo4s
         1syuOlNUaqIs35KArViKMpmn2M0HfVKYLYZ6D1vY=
Date:   Thu, 07 May 2020 18:35:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     1vier1@web.de, akpm@linux-foundation.org, dave@stgolabs.net,
        ebiederm@xmission.com, elfring@users.sourceforge.net,
        linux-mm@kvack.org, manfred@colorfullife.com,
        mm-commits@vger.kernel.org, oleg@redhat.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        yoji.fujihar.min@gmail.com
Subject:  [patch 01/15] ipc/mqueue.c: change __do_notify() to
 bypass check_kill_permission()
Message-ID: <20200508013539.Q-iufOGqB%akpm@linux-foundation.org>
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>
Subject: ipc/mqueue.c: change __do_notify() to bypass check_kill_permission()

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
Link: http://lkml.kernel.org/r/e2a782e4-eab9-4f5c-c749-c07a8f7a4e66@colorfullife.com
Fixes: cc731525f26a ("signal: Remove kernel interal si_code magic")
Reported-by: Yoji <yoji.fujihar.min@gmail.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Markus Elfring <elfring@users.sourceforge.net>
Cc: <1vier1@web.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |   34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

--- a/ipc/mqueue.c~ipc-mqueuec-change-__do_notify-to-bypass-check_kill_permission-v2
+++ a/ipc/mqueue.c
@@ -142,6 +142,7 @@ struct mqueue_inode_info {
 
 	struct sigevent notify;
 	struct pid *notify_owner;
+	u32 notify_self_exec_id;
 	struct user_namespace *notify_user_ns;
 	struct user_struct *user;	/* user who created, for accounting */
 	struct sock *notify_sock;
@@ -773,28 +774,44 @@ static void __do_notify(struct mqueue_in
 	 * synchronously. */
 	if (info->notify_owner &&
 	    info->attr.mq_curmsgs == 1) {
-		struct kernel_siginfo sig_i;
 		switch (info->notify.sigev_notify) {
 		case SIGEV_NONE:
 			break;
-		case SIGEV_SIGNAL:
-			/* sends signal */
+		case SIGEV_SIGNAL: {
+			struct kernel_siginfo sig_i;
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
@@ -1383,6 +1400,7 @@ retry:
 			info->notify.sigev_signo = notification->sigev_signo;
 			info->notify.sigev_value = notification->sigev_value;
 			info->notify.sigev_notify = SIGEV_SIGNAL;
+			info->notify_self_exec_id = current->self_exec_id;
 			break;
 		}
 
_
