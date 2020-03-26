Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC0819350A
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 01:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbgCZAll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 20:41:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727537AbgCZAll (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Mar 2020 20:41:41 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D34F020737;
        Thu, 26 Mar 2020 00:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585183299;
        bh=zBUJOw+hLdLQx9G/V6j1H3LAc21EVxXUc5sG6TV3J38=;
        h=Date:From:To:Subject:From;
        b=rowhcAh5aRl9C5ItavziV/WK4IMceJ3wz0v0qaIrQR2bSSsWcZa/CSe5ZcdwwzEYU
         7+H6HDcDvjHYi/R8d+LI1lXIJRFTlTzMH0+MdUtpo6xK5UZw/OWWZRv5o2Uz6YbgSC
         0qw/0adYDPACmt1X1cQfxVuT/JFdkC01ah4LIYhY=
Date:   Wed, 25 Mar 2020 17:41:38 -0700
From:   akpm@linux-foundation.org
To:     dave@stgolabs.net, ebiederm@xmission.com,
        elfring@users.sourceforge.net, manfred@colorfullife.com,
        mm-commits@vger.kernel.org, oleg@redhat.com,
        stable@vger.kernel.org, yoji.fujihar.min@gmail.com
Subject:  +
 ipc-mqueuec-change-__do_notify-to-bypass-check_kill_permission.patch added
 to -mm tree
Message-ID: <20200326004138.ceNbB-Eca%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ipc/mqueue.c: change __do_notify() to bypass check_kill_permission()
has been added to the -mm tree.  Its filename is
     ipc-mqueuec-change-__do_notify-to-bypass-check_kill_permission.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-mqueuec-change-__do_notify-to-bypass-check_kill_permission.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-mqueuec-change-__do_notify-to-bypass-check_kill_permission.patch

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

Link: http://lkml.kernel.org/r/20200324200932.GB24230@redhat.com
Fixes: cc731525f26a ("signal: Remove kernel interal si_code magic")
Reported-by: Yoji <yoji.fujihar.min@gmail.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Markus Elfring <elfring@users.sourceforge.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

--- a/ipc/mqueue.c~ipc-mqueuec-change-__do_notify-to-bypass-check_kill_permission
+++ a/ipc/mqueue.c
@@ -774,28 +774,40 @@ static void __do_notify(struct mqueue_in
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
+			 */
+			task = pid_task(info->notify_owner, PIDTYPE_PID);
+			if (task)
+				do_send_sig_info(info->notify.sigev_signo,
+						&sig_i, task, PIDTYPE_TGID);
 			rcu_read_unlock();
-
-			kill_pid_info(info->notify.sigev_signo,
-				      &sig_i, info->notify_owner);
 			break;
+		}
 		case SIGEV_THREAD:
 			set_cookie(info->notify_cookie, NOTIFY_WOKENUP);
 			netlink_sendskb(info->notify_sock, info->notify_cookie);
_

Patches currently in -mm which might be from oleg@redhat.com are

ipc-mqueuec-change-__do_notify-to-bypass-check_kill_permission.patch
aio-simplify-read_events.patch

