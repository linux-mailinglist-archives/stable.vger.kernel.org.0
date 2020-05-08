Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E63D1CBABB
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 00:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgEHWcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 18:32:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727082AbgEHWcV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 18:32:21 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50A452184D;
        Fri,  8 May 2020 22:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588977139;
        bh=Im4ylCDaHYECVOrSW8a5s73yrxYc6iAcCllW/cynk4E=;
        h=Date:From:To:Subject:From;
        b=Emjk49QDJ3W7ZX/Pb6nbhqSE61nwnIAU5Elf2XTttSSzYnk9Lt1qafjaQ6pbhwMOZ
         nChgjQFWK7n7ciHScOKo0LGBksEpF1bA/wFe1wsXViidey2cZ0Az+RSNVNhUayq1/o
         g6oP2BYY2G0v58WeZI3Zyk9mk0ERHiIaBuel5T9s=
Date:   Fri, 08 May 2020 15:32:18 -0700
From:   akpm@linux-foundation.org
To:     1vier1@web.de, dave@stgolabs.net, ebiederm@xmission.com,
        elfring@users.sourceforge.net, manfred@colorfullife.com,
        mm-commits@vger.kernel.org, oleg@redhat.com,
        stable@vger.kernel.org, yoji.fujihar.min@gmail.com
Subject:  [merged]
 ipc-mqueuec-change-__do_notify-to-bypass-check_kill_permission-v2.patch
 removed from -mm tree
Message-ID: <20200508223218.hrb5ZW_Fi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ipc/mqueue.c: change __do_notify() to bypass check_kill_permission()
has been removed from the -mm tree.  Its filename was
     ipc-mqueuec-change-__do_notify-to-bypass-check_kill_permission-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from oleg@redhat.com are

aio-simplify-read_events.patch

