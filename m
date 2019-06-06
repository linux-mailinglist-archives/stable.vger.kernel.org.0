Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E729B372FB
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 13:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727564AbfFFLc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 07:32:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60116 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727416AbfFFLc1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 07:32:27 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E6FCA81F0D;
        Thu,  6 Jun 2019 11:32:15 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.159])
        by smtp.corp.redhat.com (Postfix) with SMTP id 49BE57D649;
        Thu,  6 Jun 2019 11:32:07 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu,  6 Jun 2019 13:32:15 +0200 (CEST)
Date:   Thu, 6 Jun 2019 13:32:06 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>
Cc:     linux-kernel@vger.kernel.org, arnd@arndb.de, dbueso@suse.de,
        axboe@kernel.dk, dave@stgolabs.net, e@80x24.org, jbaron@akamai.com,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        omar.kilani@gmail.com, tglx@linutronix.de, stable@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Laight <David.Laight@ACULAB.COM>
Subject: [PATCH -mm V2 1/1] signal: simplify
 set_user_sigmask/restore_user_sigmask
Message-ID: <20190606113206.GA9464@redhat.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com>
 <20190604134117.GA29963@redhat.com>
 <20190605155801.GA25165@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605155801.GA25165@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 06 Jun 2019 11:32:26 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

task->saved_sigmask and ->restore_sigmask are only used in the ret-from-
syscall paths. This means that set_user_sigmask() can save ->blocked in
->saved_sigmask and do set_restore_sigmask() to indicate that ->blocked
was modified.

This way the callers do not need 2 sigset_t's passed to set/restore and
restore_user_sigmask() renamed to restore_saved_sigmask_unless() turns
into the trivial helper which just calls restore_saved_sigmask().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/aio.c                     | 20 +++++--------
 fs/eventpoll.c               | 12 +++-----
 fs/io_uring.c                | 11 ++-----
 fs/select.c                  | 34 ++++++++--------------
 include/linux/compat.h       |  3 +-
 include/linux/sched/signal.h | 12 ++++++--
 include/linux/signal.h       |  4 ---
 kernel/signal.c              | 69 ++++++++++++--------------------------------
 8 files changed, 57 insertions(+), 108 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index c1e581d..8200f97 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -2093,7 +2093,6 @@ SYSCALL_DEFINE6(io_pgetevents,
 		const struct __aio_sigset __user *, usig)
 {
 	struct __aio_sigset	ksig = { NULL, };
-	sigset_t		ksigmask, sigsaved;
 	struct timespec64	ts;
 	bool interrupted;
 	int ret;
@@ -2104,14 +2103,14 @@ SYSCALL_DEFINE6(io_pgetevents,
 	if (usig && copy_from_user(&ksig, usig, sizeof(ksig)))
 		return -EFAULT;
 
-	ret = set_user_sigmask(ksig.sigmask, &ksigmask, &sigsaved, ksig.sigsetsize);
+	ret = set_user_sigmask(ksig.sigmask, ksig.sigsetsize);
 	if (ret)
 		return ret;
 
 	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &ts : NULL);
 
 	interrupted = signal_pending(current);
-	restore_user_sigmask(ksig.sigmask, &sigsaved, interrupted);
+	restore_saved_sigmask_unless(interrupted);
 	if (interrupted && !ret)
 		ret = -ERESTARTNOHAND;
 
@@ -2129,7 +2128,6 @@ SYSCALL_DEFINE6(io_pgetevents_time32,
 		const struct __aio_sigset __user *, usig)
 {
 	struct __aio_sigset	ksig = { NULL, };
-	sigset_t		ksigmask, sigsaved;
 	struct timespec64	ts;
 	bool interrupted;
 	int ret;
@@ -2141,14 +2139,14 @@ SYSCALL_DEFINE6(io_pgetevents_time32,
 		return -EFAULT;
 
 
-	ret = set_user_sigmask(ksig.sigmask, &ksigmask, &sigsaved, ksig.sigsetsize);
+	ret = set_user_sigmask(ksig.sigmask, ksig.sigsetsize);
 	if (ret)
 		return ret;
 
 	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &ts : NULL);
 
 	interrupted = signal_pending(current);
-	restore_user_sigmask(ksig.sigmask, &sigsaved, interrupted);
+	restore_saved_sigmask_unless(interrupted);
 	if (interrupted && !ret)
 		ret = -ERESTARTNOHAND;
 
@@ -2197,7 +2195,6 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents,
 		const struct __compat_aio_sigset __user *, usig)
 {
 	struct __compat_aio_sigset ksig = { NULL, };
-	sigset_t ksigmask, sigsaved;
 	struct timespec64 t;
 	bool interrupted;
 	int ret;
@@ -2208,14 +2205,14 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents,
 	if (usig && copy_from_user(&ksig, usig, sizeof(ksig)))
 		return -EFAULT;
 
-	ret = set_compat_user_sigmask(ksig.sigmask, &ksigmask, &sigsaved, ksig.sigsetsize);
+	ret = set_compat_user_sigmask(ksig.sigmask, ksig.sigsetsize);
 	if (ret)
 		return ret;
 
 	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &t : NULL);
 
 	interrupted = signal_pending(current);
-	restore_user_sigmask(ksig.sigmask, &sigsaved, interrupted);
+	restore_saved_sigmask_unless(interrupted);
 	if (interrupted && !ret)
 		ret = -ERESTARTNOHAND;
 
@@ -2233,7 +2230,6 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents_time64,
 		const struct __compat_aio_sigset __user *, usig)
 {
 	struct __compat_aio_sigset ksig = { NULL, };
-	sigset_t ksigmask, sigsaved;
 	struct timespec64 t;
 	bool interrupted;
 	int ret;
@@ -2244,14 +2240,14 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents_time64,
 	if (usig && copy_from_user(&ksig, usig, sizeof(ksig)))
 		return -EFAULT;
 
-	ret = set_compat_user_sigmask(ksig.sigmask, &ksigmask, &sigsaved, ksig.sigsetsize);
+	ret = set_compat_user_sigmask(ksig.sigmask, ksig.sigsetsize);
 	if (ret)
 		return ret;
 
 	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &t : NULL);
 
 	interrupted = signal_pending(current);
-	restore_user_sigmask(ksig.sigmask, &sigsaved, interrupted);
+	restore_saved_sigmask_unless(interrupted);
 	if (interrupted && !ret)
 		ret = -ERESTARTNOHAND;
 
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 4c74c76..0f9c073 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2313,19 +2313,17 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
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
-
-	restore_user_sigmask(sigmask, &sigsaved, error == -EINTR);
+	restore_saved_sigmask_unless(error == -EINTR);
 
 	return error;
 }
@@ -2338,19 +2336,17 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 			compat_size_t, sigsetsize)
 {
 	long err;
-	sigset_t ksigmask, sigsaved;
 
 	/*
 	 * If the caller wants a certain signal mask to be set during the wait,
 	 * we apply it here.
 	 */
-	err = set_compat_user_sigmask(sigmask, &ksigmask, &sigsaved, sigsetsize);
+	err = set_compat_user_sigmask(sigmask, sigsetsize);
 	if (err)
 		return err;
 
 	err = do_epoll_wait(epfd, events, maxevents, timeout);
-
-	restore_user_sigmask(sigmask, &sigsaved, err == -EINTR);
+	restore_saved_sigmask_unless(err == -EINTR);
 
 	return err;
 }
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1147c5d..ad7b9bc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2180,7 +2180,6 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 			  const sigset_t __user *sig, size_t sigsz)
 {
 	struct io_cq_ring *ring = ctx->cq_ring;
-	sigset_t ksigmask, sigsaved;
 	int ret;
 
 	if (io_cqring_events(ring) >= min_events)
@@ -2190,21 +2189,17 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 #ifdef CONFIG_COMPAT
 		if (in_compat_syscall())
 			ret = set_compat_user_sigmask((const compat_sigset_t __user *)sig,
-						      &ksigmask, &sigsaved, sigsz);
+						      sigsz);
 		else
 #endif
-			ret = set_user_sigmask(sig, &ksigmask,
-					       &sigsaved, sigsz);
+			ret = set_user_sigmask(sig, sigsz);
 
 		if (ret)
 			return ret;
 	}
 
 	ret = wait_event_interruptible(ctx->wait, io_cqring_events(ring) >= min_events);
-
-	if (sig)
-		restore_user_sigmask(sig, &sigsaved, ret == -ERESTARTSYS);
-
+	restore_saved_sigmask_unless(ret == -ERESTARTSYS);
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
 
diff --git a/fs/select.c b/fs/select.c
index a4d8f6e..1fc1b24 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -730,7 +730,6 @@ static long do_pselect(int n, fd_set __user *inp, fd_set __user *outp,
 		       const sigset_t __user *sigmask, size_t sigsetsize,
 		       enum poll_time_type type)
 {
-	sigset_t ksigmask, sigsaved;
 	struct timespec64 ts, end_time, *to = NULL;
 	int ret;
 
@@ -753,12 +752,12 @@ static long do_pselect(int n, fd_set __user *inp, fd_set __user *outp,
 			return -EINVAL;
 	}
 
-	ret = set_user_sigmask(sigmask, &ksigmask, &sigsaved, sigsetsize);
+	ret = set_user_sigmask(sigmask, sigsetsize);
 	if (ret)
 		return ret;
 
 	ret = core_sys_select(n, inp, outp, exp, to);
-	restore_user_sigmask(sigmask, &sigsaved, ret == -ERESTARTNOHAND);
+	restore_saved_sigmask_unless(ret == -ERESTARTNOHAND);
 	ret = poll_select_copy_remaining(&end_time, tsp, type, ret);
 
 	return ret;
@@ -1086,7 +1085,6 @@ SYSCALL_DEFINE5(ppoll, struct pollfd __user *, ufds, unsigned int, nfds,
 		struct __kernel_timespec __user *, tsp, const sigset_t __user *, sigmask,
 		size_t, sigsetsize)
 {
-	sigset_t ksigmask, sigsaved;
 	struct timespec64 ts, end_time, *to = NULL;
 	int ret;
 
@@ -1099,17 +1097,16 @@ SYSCALL_DEFINE5(ppoll, struct pollfd __user *, ufds, unsigned int, nfds,
 			return -EINVAL;
 	}
 
-	ret = set_user_sigmask(sigmask, &ksigmask, &sigsaved, sigsetsize);
+	ret = set_user_sigmask(sigmask, sigsetsize);
 	if (ret)
 		return ret;
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	restore_user_sigmask(sigmask, &sigsaved, ret == -EINTR);
+	restore_saved_sigmask_unless(ret == -EINTR);
 	/* We can restart this syscall, usually */
 	if (ret == -EINTR)
 		ret = -ERESTARTNOHAND;
-
 	ret = poll_select_copy_remaining(&end_time, tsp, PT_TIMESPEC, ret);
 
 	return ret;
@@ -1121,7 +1118,6 @@ SYSCALL_DEFINE5(ppoll_time32, struct pollfd __user *, ufds, unsigned int, nfds,
 		struct old_timespec32 __user *, tsp, const sigset_t __user *, sigmask,
 		size_t, sigsetsize)
 {
-	sigset_t ksigmask, sigsaved;
 	struct timespec64 ts, end_time, *to = NULL;
 	int ret;
 
@@ -1134,17 +1130,16 @@ SYSCALL_DEFINE5(ppoll_time32, struct pollfd __user *, ufds, unsigned int, nfds,
 			return -EINVAL;
 	}
 
-	ret = set_user_sigmask(sigmask, &ksigmask, &sigsaved, sigsetsize);
+	ret = set_user_sigmask(sigmask, sigsetsize);
 	if (ret)
 		return ret;
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	restore_user_sigmask(sigmask, &sigsaved, ret == -EINTR);
+	restore_saved_sigmask_unless(ret == -EINTR);
 	/* We can restart this syscall, usually */
 	if (ret == -EINTR)
 		ret = -ERESTARTNOHAND;
-
 	ret = poll_select_copy_remaining(&end_time, tsp, PT_OLD_TIMESPEC, ret);
 
 	return ret;
@@ -1319,7 +1314,6 @@ static long do_compat_pselect(int n, compat_ulong_t __user *inp,
 	void __user *tsp, compat_sigset_t __user *sigmask,
 	compat_size_t sigsetsize, enum poll_time_type type)
 {
-	sigset_t ksigmask, sigsaved;
 	struct timespec64 ts, end_time, *to = NULL;
 	int ret;
 
@@ -1342,12 +1336,12 @@ static long do_compat_pselect(int n, compat_ulong_t __user *inp,
 			return -EINVAL;
 	}
 
-	ret = set_compat_user_sigmask(sigmask, &ksigmask, &sigsaved, sigsetsize);
+	ret = set_compat_user_sigmask(sigmask, sigsetsize);
 	if (ret)
 		return ret;
 
 	ret = compat_core_sys_select(n, inp, outp, exp, to);
-	restore_user_sigmask(sigmask, &sigsaved, ret == -ERESTARTNOHAND);
+	restore_saved_sigmask_unless(ret == -ERESTARTNOHAND);
 	ret = poll_select_copy_remaining(&end_time, tsp, type, ret);
 
 	return ret;
@@ -1402,7 +1396,6 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time32, struct pollfd __user *, ufds,
 	unsigned int,  nfds, struct old_timespec32 __user *, tsp,
 	const compat_sigset_t __user *, sigmask, compat_size_t, sigsetsize)
 {
-	sigset_t ksigmask, sigsaved;
 	struct timespec64 ts, end_time, *to = NULL;
 	int ret;
 
@@ -1415,17 +1408,16 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time32, struct pollfd __user *, ufds,
 			return -EINVAL;
 	}
 
-	ret = set_compat_user_sigmask(sigmask, &ksigmask, &sigsaved, sigsetsize);
+	ret = set_compat_user_sigmask(sigmask, sigsetsize);
 	if (ret)
 		return ret;
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	restore_user_sigmask(sigmask, &sigsaved, ret == -EINTR);
+	restore_saved_sigmask_unless(ret == -EINTR);
 	/* We can restart this syscall, usually */
 	if (ret == -EINTR)
 		ret = -ERESTARTNOHAND;
-
 	ret = poll_select_copy_remaining(&end_time, tsp, PT_OLD_TIMESPEC, ret);
 
 	return ret;
@@ -1437,7 +1429,6 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time64, struct pollfd __user *, ufds,
 	unsigned int,  nfds, struct __kernel_timespec __user *, tsp,
 	const compat_sigset_t __user *, sigmask, compat_size_t, sigsetsize)
 {
-	sigset_t ksigmask, sigsaved;
 	struct timespec64 ts, end_time, *to = NULL;
 	int ret;
 
@@ -1450,17 +1441,16 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time64, struct pollfd __user *, ufds,
 			return -EINVAL;
 	}
 
-	ret = set_compat_user_sigmask(sigmask, &ksigmask, &sigsaved, sigsetsize);
+	ret = set_compat_user_sigmask(sigmask, sigsetsize);
 	if (ret)
 		return ret;
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	restore_user_sigmask(sigmask, &sigsaved, ret == -EINTR);
+	restore_saved_sigmask_unless(ret == -EINTR);
 	/* We can restart this syscall, usually */
 	if (ret == -EINTR)
 		ret = -ERESTARTNOHAND;
-
 	ret = poll_select_copy_remaining(&end_time, tsp, PT_TIMESPEC, ret);
 
 	return ret;
diff --git a/include/linux/compat.h b/include/linux/compat.h
index ebddcb6..16dafd9 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -138,8 +138,7 @@ typedef struct {
 	compat_sigset_word	sig[_COMPAT_NSIG_WORDS];
 } compat_sigset_t;
 
-int set_compat_user_sigmask(const compat_sigset_t __user *usigmask,
-			    sigset_t *set, sigset_t *oldset,
+int set_compat_user_sigmask(const compat_sigset_t __user *umask,
 			    size_t sigsetsize);
 
 struct compat_sigaction {
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 38a0f07..4d9c71d 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -417,7 +417,6 @@ void task_join_group_stop(struct task_struct *task);
 static inline void set_restore_sigmask(void)
 {
 	set_thread_flag(TIF_RESTORE_SIGMASK);
-	WARN_ON(!test_thread_flag(TIF_SIGPENDING));
 }
 
 static inline void clear_tsk_restore_sigmask(struct task_struct *task)
@@ -448,7 +447,6 @@ static inline bool test_and_clear_restore_sigmask(void)
 static inline void set_restore_sigmask(void)
 {
 	current->restore_sigmask = true;
-	WARN_ON(!test_thread_flag(TIF_SIGPENDING));
 }
 static inline void clear_tsk_restore_sigmask(struct task_struct *task)
 {
@@ -481,6 +479,16 @@ static inline void restore_saved_sigmask(void)
 		__set_current_blocked(&current->saved_sigmask);
 }
 
+extern int set_user_sigmask(const sigset_t __user *umask, size_t sigsetsize);
+
+static inline void restore_saved_sigmask_unless(bool interrupted)
+{
+	if (interrupted)
+		WARN_ON(!test_thread_flag(TIF_SIGPENDING));
+	else
+		restore_saved_sigmask();
+}
+
 static inline sigset_t *sigmask_to_save(void)
 {
 	sigset_t *res = &current->blocked;
diff --git a/include/linux/signal.h b/include/linux/signal.h
index 78c2bb3..b5d99482 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -273,10 +273,6 @@ extern int group_send_sig_info(int sig, struct kernel_siginfo *info,
 			       struct task_struct *p, enum pid_type type);
 extern int __group_send_sig_info(int, struct kernel_siginfo *, struct task_struct *);
 extern int sigprocmask(int, sigset_t *, sigset_t *);
-extern int set_user_sigmask(const sigset_t __user *usigmask, sigset_t *set,
-	sigset_t *oldset, size_t sigsetsize);
-extern void restore_user_sigmask(const void __user *usigmask,
-				 sigset_t *sigsaved, bool interrupted);
 extern void set_current_blocked(sigset_t *);
 extern void __set_current_blocked(const sigset_t *);
 extern int show_unhandled_signals;
diff --git a/kernel/signal.c b/kernel/signal.c
index aa6a6f1..1a1013e1 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2863,80 +2863,49 @@ EXPORT_SYMBOL(sigprocmask);
  *
  * This is useful for syscalls such as ppoll, pselect, io_pgetevents and
  * epoll_pwait where a new sigmask is passed from userland for the syscalls.
+ *
+ * Note that it does set_restore_sigmask() in advance, so it must be always
+ * paired with restore_saved_sigmask_unless() before return from syscall.
  */
-int set_user_sigmask(const sigset_t __user *usigmask, sigset_t *set,
-		     sigset_t *oldset, size_t sigsetsize)
+int set_user_sigmask(const sigset_t __user *umask, size_t sigsetsize)
 {
-	if (!usigmask)
-		return 0;
+	sigset_t kmask;
 
+	if (!umask)
+		return 0;
 	if (sigsetsize != sizeof(sigset_t))
 		return -EINVAL;
-	if (copy_from_user(set, usigmask, sizeof(sigset_t)))
+	if (copy_from_user(&kmask, umask, sizeof(sigset_t)))
 		return -EFAULT;
 
-	*oldset = current->blocked;
-	set_current_blocked(set);
+	set_restore_sigmask();
+	current->saved_sigmask = current->blocked;
+	set_current_blocked(&kmask);
 
 	return 0;
 }
-EXPORT_SYMBOL(set_user_sigmask);
 
 #ifdef CONFIG_COMPAT
-int set_compat_user_sigmask(const compat_sigset_t __user *usigmask,
-			    sigset_t *set, sigset_t *oldset,
+int set_compat_user_sigmask(const compat_sigset_t __user *umask,
 			    size_t sigsetsize)
 {
-	if (!usigmask)
-		return 0;
+	sigset_t kmask;
 
+	if (!umask)
+		return 0;
 	if (sigsetsize != sizeof(compat_sigset_t))
 		return -EINVAL;
-	if (get_compat_sigset(set, usigmask))
+	if (get_compat_sigset(&kmask, umask))
 		return -EFAULT;
 
-	*oldset = current->blocked;
-	set_current_blocked(set);
+	set_restore_sigmask();
+	current->saved_sigmask = current->blocked;
+	set_current_blocked(&kmask);
 
 	return 0;
 }
-EXPORT_SYMBOL(set_compat_user_sigmask);
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
-void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved,
-				bool interrupted)
-{
-
-	if (!usigmask)
-		return;
-	/*
-	 * When signals are pending, do not restore them here.
-	 * Restoring sigmask here can lead to delivering signals that the above
-	 * syscalls are intended to block because of the sigmask passed in.
-	 */
-	if (interrupted) {
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
-- 
2.5.0


