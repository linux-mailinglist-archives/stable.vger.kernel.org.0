Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2790026696
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 17:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729522AbfEVPFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 11:05:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33736 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728466AbfEVPFe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 11:05:34 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EA27B3082B1F;
        Wed, 22 May 2019 15:05:12 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.159])
        by smtp.corp.redhat.com (Postfix) with SMTP id A4FB4611A0;
        Wed, 22 May 2019 15:05:08 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Wed, 22 May 2019 17:05:10 +0200 (CEST)
Date:   Wed, 22 May 2019 17:05:06 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Deepa Dinamani <deepa.kernel@gmail.com>
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, arnd@arndb.de, dbueso@suse.de,
        axboe@kernel.dk, dave@stgolabs.net, e@80x24.org, jbaron@akamai.com,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        omar.kilani@gmail.com, tglx@linutronix.de, stable@vger.kernel.org
Subject: Re: [PATCH v2] signal: Adjust error codes according to
 restore_user_sigmask()
Message-ID: <20190522150505.GA4915@redhat.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522032144.10995-1-deepa.kernel@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Wed, 22 May 2019 15:05:33 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/21, Deepa Dinamani wrote:
>
> Note that this patch returns interrupted errors (EINTR, ERESTARTNOHAND,
> etc) only when there is no other error. If there is a signal and an error
> like EINVAL, the syscalls return -EINVAL rather than the interrupted
> error codes.

Ugh. I need to re-check, but at first glance I really dislike this change.

I think we can fix the problem _and_ simplify the code. Something like below.
The patch is obviously incomplete, it changes only only one caller of
set_user_sigmask(), epoll_pwait() to explain what I mean.

restore_user_sigmask() should simply die. Although perhaps another helper
makes sense to add WARN_ON(test_tsk_restore_sigmask() && !signal_pending).

Oleg.


diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 4a0e98d..85f56e4 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2318,19 +2318,19 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
 		size_t, sigsetsize)
 {
 	int error;
-	sigset_t ksigmask, sigsaved;
 
 	/*
 	 * If the caller wants a certain signal mask to be set during the wait,
 	 * we apply it here.
 	 */
-	error = set_user_sigmask(sigmask, &ksigmask, &sigsaved, sigsetsize);
+	error = set_user_sigmask(sigmask, sigsetsize);
 	if (error)
 		return error;
 
 	error = do_epoll_wait(epfd, events, maxevents, timeout);
 
-	restore_user_sigmask(sigmask, &sigsaved);
+	if (error != -EINTR)
+		restore_saved_sigmask();
 
 	return error;
 }
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index e412c09..1e82ae0 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -416,7 +416,6 @@ void task_join_group_stop(struct task_struct *task);
 static inline void set_restore_sigmask(void)
 {
 	set_thread_flag(TIF_RESTORE_SIGMASK);
-	WARN_ON(!test_thread_flag(TIF_SIGPENDING));
 }
 
 static inline void clear_tsk_restore_sigmask(struct task_struct *tsk)
@@ -447,7 +446,6 @@ static inline bool test_and_clear_restore_sigmask(void)
 static inline void set_restore_sigmask(void)
 {
 	current->restore_sigmask = true;
-	WARN_ON(!test_thread_flag(TIF_SIGPENDING));
 }
 static inline void clear_tsk_restore_sigmask(struct task_struct *tsk)
 {
diff --git a/include/linux/signal.h b/include/linux/signal.h
index 9702016..887cea6 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -273,8 +273,7 @@ extern int group_send_sig_info(int sig, struct kernel_siginfo *info,
 			       struct task_struct *p, enum pid_type type);
 extern int __group_send_sig_info(int, struct kernel_siginfo *, struct task_struct *);
 extern int sigprocmask(int, sigset_t *, sigset_t *);
-extern int set_user_sigmask(const sigset_t __user *usigmask, sigset_t *set,
-	sigset_t *oldset, size_t sigsetsize);
+extern int set_user_sigmask(const sigset_t __user *umask, size_t sigsetsize);
 extern void restore_user_sigmask(const void __user *usigmask,
 				 sigset_t *sigsaved);
 extern void set_current_blocked(sigset_t *);
diff --git a/kernel/signal.c b/kernel/signal.c
index 227ba17..76f4f9a 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2801,19 +2801,21 @@ EXPORT_SYMBOL(sigprocmask);
  * This is useful for syscalls such as ppoll, pselect, io_pgetevents and
  * epoll_pwait where a new sigmask is passed from userland for the syscalls.
  */
-int set_user_sigmask(const sigset_t __user *usigmask, sigset_t *set,
-		     sigset_t *oldset, size_t sigsetsize)
+int set_user_sigmask(const sigset_t __user *umask, size_t sigsetsize)
 {
-	if (!usigmask)
+	sigset_t *kmask;
+
+	if (!umask)
 		return 0;
 
 	if (sigsetsize != sizeof(sigset_t))
 		return -EINVAL;
-	if (copy_from_user(set, usigmask, sizeof(sigset_t)))
+	if (copy_from_user(kmask, umask, sizeof(sigset_t)))
 		return -EFAULT;
 
-	*oldset = current->blocked;
-	set_current_blocked(set);
+	set_restore_sigmask();
+	current->saved_sigmask = current->blocked;
+	set_current_blocked(kmask);
 
 	return 0;
 }
@@ -2840,39 +2842,6 @@ int set_compat_user_sigmask(const compat_sigset_t __user *usigmask,
 EXPORT_SYMBOL(set_compat_user_sigmask);
 #endif
 
-/*
- * restore_user_sigmask:
- * usigmask: sigmask passed in from userland.
- * sigsaved: saved sigmask when the syscall started and changed the sigmask to
- *           usigmask.
- *
- * This is useful for syscalls such as ppoll, pselect, io_pgetevents and
- * epoll_pwait where a new sigmask is passed in from userland for the syscalls.
- */
-void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved)
-{
-
-	if (!usigmask)
-		return;
-	/*
-	 * When signals are pending, do not restore them here.
-	 * Restoring sigmask here can lead to delivering signals that the above
-	 * syscalls are intended to block because of the sigmask passed in.
-	 */
-	if (signal_pending(current)) {
-		current->saved_sigmask = *sigsaved;
-		set_restore_sigmask();
-		return;
-	}
-
-	/*
-	 * This is needed because the fast syscall return path does not restore
-	 * saved_sigmask when signals are not pending.
-	 */
-	set_current_blocked(sigsaved);
-}
-EXPORT_SYMBOL(restore_user_sigmask);
-
 /**
  *  sys_rt_sigprocmask - change the list of currently blocked signals
  *  @how: whether to add, remove, or set signals

