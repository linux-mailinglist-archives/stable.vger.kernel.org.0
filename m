Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F24CE2E20E
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 18:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfE2QMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 12:12:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37844 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbfE2QMV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 12:12:21 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E2F213001835;
        Wed, 29 May 2019 16:12:04 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.159])
        by smtp.corp.redhat.com (Postfix) with SMTP id 676095D9D6;
        Wed, 29 May 2019 16:11:58 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Wed, 29 May 2019 18:12:04 +0200 (CEST)
Date:   Wed, 29 May 2019 18:11:57 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Deepa Dinamani <deepa.kernel@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        arnd@arndb.de, dbueso@suse.de, axboe@kernel.dk, dave@stgolabs.net,
        e@80x24.org, jbaron@akamai.com, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, omar.kilani@gmail.com, tglx@linutronix.de,
        stable@vger.kernel.org
Subject: pselect/etc semantics (Was: [PATCH v2] signal: Adjust error codes
 according to restore_user_sigmask())
Message-ID: <20190529161157.GA27659@redhat.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522032144.10995-1-deepa.kernel@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Wed, 29 May 2019 16:12:20 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Al, Linus, Eric, please help.

The previous discussion was very confusing, we simply can not understand each
other.

To me everything looks very simple and clear, but perhaps I missed something
obvious? Please correct me.

I think that the following code is correct

	int interrupted = 0;

	void sigint_handler(int sig)
	{
		interrupted = 1;
	}

	int main(void)
	{
		sigset_t sigint, empty;

		sigemptyset(&sigint);
		sigaddset(&sigint, SIGINT);
		sigprocmask(SIG_BLOCK, &sigint, NULL);

		signal(SIGINT, sigint_handler);

		sigemptyset(&empty);	// so pselect() unblocks SIGINT

		ret = pselect(..., &empty);

		if (ret >= 0)		// sucess or timeout
			assert(!interrupted);

		if (interrupted)
			assert(ret == -EINTR);
	}

IOW, if pselect(sigmask) temporary unblocks SIGINT according to sigmask, this
signal should not be delivered if a ready fd was found or timeout. The signal
handle should only run if ret == -EINTR.

(pselect() can be interrupted by any other signal which has a handler. In this
 case the handler can be called even if ret >= 0. This is correct, I fail to
 understand why some people think this is wrong, and in any case we simply can't
 avoid this).

This was true until 854a6ed56839a ("signal: Add restore_user_sigmask()"),
now this is broken by the signal_pending() check in restore_user_sigmask().

This patch https://lore.kernel.org/lkml/20190522032144.10995-1-deepa.kernel@gmail.com/
turns 0 into -EINTR if signal_pending(), but I think we should simply restore
the old behaviour and simplify the code.

See the compile-tested patch at the end. Of course, the new _xxx() helpers
should be renamed somehow. fs/aio.c doesn't look right with or without this
patch, but iiuc this is what it did before 854a6ed56839a.

Let me show the code with the patch applied. I am using epoll_pwait() as an
example because it looks very simple.


	static inline void set_restore_sigmask(void)
	{
// WARN_ON(!TIF_SIGPENDING) was removed by this patch
		current->restore_sigmask = true;
	}

	int set_xxx(const sigset_t __user *umask, size_t sigsetsize)
	{
		sigset_t *kmask;

		if (!umask)
			return 0;
		if (sigsetsize != sizeof(sigset_t))
			return -EINVAL;
		if (copy_from_user(kmask, umask, sizeof(sigset_t)))
			return -EFAULT;

// we can safely modify ->saved_sigmask/restore_sigmask, they has no meaning
// until the syscall returns.
		set_restore_sigmask();
		current->saved_sigmask = current->blocked;
		set_current_blocked(kmask);

		return 0;
	}


	void update_xxx(bool interrupted)
	{
// the main reason for this helper is WARN_ON(!TIF_SIGPENDING) which was "moved"
// from set_restore_sigmask() above.
		if (interrupted)
			WARN_ON(!test_thread_flag(TIF_SIGPENDING));
		else
			restore_saved_sigmask();
	}

	SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
			int, maxevents, int, timeout, const sigset_t __user *, sigmask,
			size_t, sigsetsize)
	{
		int error;

		error = set_xxx(sigmask, sigsetsize);
		if (error)
			return error;

		error = do_epoll_wait(epfd, events, maxevents, timeout);
		update_xxx(error == -EINTR);

		return error;
	}

Oleg.
---

 fs/aio.c                     | 40 ++++++++++++++---------
 fs/eventpoll.c               | 12 +++----
 fs/io_uring.c                | 12 +++----
 fs/select.c                  | 40 +++++++----------------
 include/linux/compat.h       |  4 +--
 include/linux/sched/signal.h |  2 --
 include/linux/signal.h       |  6 ++--
 kernel/signal.c              | 77 ++++++++++++++++----------------------------
 8 files changed, 74 insertions(+), 119 deletions(-)


diff --git a/fs/aio.c b/fs/aio.c
index 3490d1f..8315bd2 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -2093,8 +2093,8 @@ SYSCALL_DEFINE6(io_pgetevents,
 		const struct __aio_sigset __user *, usig)
 {
 	struct __aio_sigset	ksig = { NULL, };
-	sigset_t		ksigmask, sigsaved;
 	struct timespec64	ts;
+	bool interrupted;
 	int ret;
 
 	if (timeout && unlikely(get_timespec64(&ts, timeout)))
@@ -2103,13 +2103,15 @@ SYSCALL_DEFINE6(io_pgetevents,
 	if (usig && copy_from_user(&ksig, usig, sizeof(ksig)))
 		return -EFAULT;
 
-	ret = set_user_sigmask(ksig.sigmask, &ksigmask, &sigsaved, ksig.sigsetsize);
+	ret = set_xxx(ksig.sigmask, ksig.sigsetsize);
 	if (ret)
 		return ret;
 
 	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &ts : NULL);
-	restore_user_sigmask(ksig.sigmask, &sigsaved);
-	if (signal_pending(current) && !ret)
+
+	interrupted = signal_pending(current);
+	update_xxx(interrupted);
+	if (interrupted && !ret)
 		ret = -ERESTARTNOHAND;
 
 	return ret;
@@ -2126,8 +2128,8 @@ SYSCALL_DEFINE6(io_pgetevents_time32,
 		const struct __aio_sigset __user *, usig)
 {
 	struct __aio_sigset	ksig = { NULL, };
-	sigset_t		ksigmask, sigsaved;
 	struct timespec64	ts;
+	bool interrupted;
 	int ret;
 
 	if (timeout && unlikely(get_old_timespec32(&ts, timeout)))
@@ -2137,13 +2139,15 @@ SYSCALL_DEFINE6(io_pgetevents_time32,
 		return -EFAULT;
 
 
-	ret = set_user_sigmask(ksig.sigmask, &ksigmask, &sigsaved, ksig.sigsetsize);
+	ret = set_xxx(ksig.sigmask, ksig.sigsetsize);
 	if (ret)
 		return ret;
 
 	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &ts : NULL);
-	restore_user_sigmask(ksig.sigmask, &sigsaved);
-	if (signal_pending(current) && !ret)
+
+	interrupted = signal_pending(current);
+	update_xxx(interrupted);
+	if (interrupted && !ret)
 		ret = -ERESTARTNOHAND;
 
 	return ret;
@@ -2191,8 +2195,8 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents,
 		const struct __compat_aio_sigset __user *, usig)
 {
 	struct __compat_aio_sigset ksig = { NULL, };
-	sigset_t ksigmask, sigsaved;
 	struct timespec64 t;
+	bool interrupted;
 	int ret;
 
 	if (timeout && get_old_timespec32(&t, timeout))
@@ -2201,13 +2205,15 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents,
 	if (usig && copy_from_user(&ksig, usig, sizeof(ksig)))
 		return -EFAULT;
 
-	ret = set_compat_user_sigmask(ksig.sigmask, &ksigmask, &sigsaved, ksig.sigsetsize);
+	ret = set_compat_xxx(ksig.sigmask, ksig.sigsetsize);
 	if (ret)
 		return ret;
 
 	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &t : NULL);
-	restore_user_sigmask(ksig.sigmask, &sigsaved);
-	if (signal_pending(current) && !ret)
+
+	interrupted = signal_pending(current);
+	update_xxx(interrupted);
+	if (interrupted && !ret)
 		ret = -ERESTARTNOHAND;
 
 	return ret;
@@ -2224,8 +2230,8 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents_time64,
 		const struct __compat_aio_sigset __user *, usig)
 {
 	struct __compat_aio_sigset ksig = { NULL, };
-	sigset_t ksigmask, sigsaved;
 	struct timespec64 t;
+	bool interrupted;
 	int ret;
 
 	if (timeout && get_timespec64(&t, timeout))
@@ -2234,13 +2240,15 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents_time64,
 	if (usig && copy_from_user(&ksig, usig, sizeof(ksig)))
 		return -EFAULT;
 
-	ret = set_compat_user_sigmask(ksig.sigmask, &ksigmask, &sigsaved, ksig.sigsetsize);
+	ret = set_compat_xxx(ksig.sigmask, ksig.sigsetsize);
 	if (ret)
 		return ret;
 
 	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &t : NULL);
-	restore_user_sigmask(ksig.sigmask, &sigsaved);
-	if (signal_pending(current) && !ret)
+
+	interrupted = signal_pending(current);
+	update_xxx(interrupted);
+	if (interrupted && !ret)
 		ret = -ERESTARTNOHAND;
 
 	return ret;
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 4a0e98d..0b1a337 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2318,19 +2318,17 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
 		size_t, sigsetsize)
 {
 	int error;
-	sigset_t ksigmask, sigsaved;
 
 	/*
 	 * If the caller wants a certain signal mask to be set during the wait,
 	 * we apply it here.
 	 */
-	error = set_user_sigmask(sigmask, &ksigmask, &sigsaved, sigsetsize);
+	error = set_xxx(sigmask, sigsetsize);
 	if (error)
 		return error;
 
 	error = do_epoll_wait(epfd, events, maxevents, timeout);
-
-	restore_user_sigmask(sigmask, &sigsaved);
+	update_xxx(error == -EINTR);
 
 	return error;
 }
@@ -2343,19 +2341,17 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 			compat_size_t, sigsetsize)
 {
 	long err;
-	sigset_t ksigmask, sigsaved;
 
 	/*
 	 * If the caller wants a certain signal mask to be set during the wait,
 	 * we apply it here.
 	 */
-	err = set_compat_user_sigmask(sigmask, &ksigmask, &sigsaved, sigsetsize);
+	err = set_compat_xxx(sigmask, sigsetsize);
 	if (err)
 		return err;
 
 	err = do_epoll_wait(epfd, events, maxevents, timeout);
-
-	restore_user_sigmask(sigmask, &sigsaved);
+	update_xxx(err == -EINTR);
 
 	return err;
 }
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 310f8d1..b5b99e2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2180,7 +2180,6 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 			  const sigset_t __user *sig, size_t sigsz)
 {
 	struct io_cq_ring *ring = ctx->cq_ring;
-	sigset_t ksigmask, sigsaved;
 	int ret;
 
 	if (io_cqring_events(ring) >= min_events)
@@ -2189,24 +2188,21 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	if (sig) {
 #ifdef CONFIG_COMPAT
 		if (in_compat_syscall())
-			ret = set_compat_user_sigmask((const compat_sigset_t __user *)sig,
-						      &ksigmask, &sigsaved, sigsz);
+			ret = set_compat_xxx((const compat_sigset_t __user *)sig,
+						      sigsz);
 		else
 #endif
-			ret = set_user_sigmask(sig, &ksigmask,
-					       &sigsaved, sigsz);
+			ret = set_xxx(sig, sigsz);
 
 		if (ret)
 			return ret;
 	}
 
 	ret = wait_event_interruptible(ctx->wait, io_cqring_events(ring) >= min_events);
+	update_xxx(ret == -ERESTARTSYS);
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
 
-	if (sig)
-		restore_user_sigmask(sig, &sigsaved);
-
 	return READ_ONCE(ring->r.head) == READ_ONCE(ring->r.tail) ? ret : 0;
 }
 
diff --git a/fs/select.c b/fs/select.c
index 6cbc9ff..7eab132 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -730,7 +730,6 @@ static long do_pselect(int n, fd_set __user *inp, fd_set __user *outp,
 		       const sigset_t __user *sigmask, size_t sigsetsize,
 		       enum poll_time_type type)
 {
-	sigset_t ksigmask, sigsaved;
 	struct timespec64 ts, end_time, *to = NULL;
 	int ret;
 
@@ -753,15 +752,14 @@ static long do_pselect(int n, fd_set __user *inp, fd_set __user *outp,
 			return -EINVAL;
 	}
 
-	ret = set_user_sigmask(sigmask, &ksigmask, &sigsaved, sigsetsize);
+	ret = set_xxx(sigmask, sigsetsize);
 	if (ret)
 		return ret;
 
 	ret = core_sys_select(n, inp, outp, exp, to);
+	update_xxx(ret == -ERESTARTNOHAND);
 	ret = poll_select_copy_remaining(&end_time, tsp, type, ret);
 
-	restore_user_sigmask(sigmask, &sigsaved);
-
 	return ret;
 }
 
@@ -1087,7 +1085,6 @@ SYSCALL_DEFINE5(ppoll, struct pollfd __user *, ufds, unsigned int, nfds,
 		struct __kernel_timespec __user *, tsp, const sigset_t __user *, sigmask,
 		size_t, sigsetsize)
 {
-	sigset_t ksigmask, sigsaved;
 	struct timespec64 ts, end_time, *to = NULL;
 	int ret;
 
@@ -1100,18 +1097,16 @@ SYSCALL_DEFINE5(ppoll, struct pollfd __user *, ufds, unsigned int, nfds,
 			return -EINVAL;
 	}
 
-	ret = set_user_sigmask(sigmask, &ksigmask, &sigsaved, sigsetsize);
+	ret = set_xxx(sigmask, sigsetsize);
 	if (ret)
 		return ret;
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	restore_user_sigmask(sigmask, &sigsaved);
-
+	update_xxx(ret == -EINTR);
 	/* We can restart this syscall, usually */
 	if (ret == -EINTR)
 		ret = -ERESTARTNOHAND;
-
 	ret = poll_select_copy_remaining(&end_time, tsp, PT_TIMESPEC, ret);
 
 	return ret;
@@ -1123,7 +1118,6 @@ SYSCALL_DEFINE5(ppoll_time32, struct pollfd __user *, ufds, unsigned int, nfds,
 		struct old_timespec32 __user *, tsp, const sigset_t __user *, sigmask,
 		size_t, sigsetsize)
 {
-	sigset_t ksigmask, sigsaved;
 	struct timespec64 ts, end_time, *to = NULL;
 	int ret;
 
@@ -1136,18 +1130,16 @@ SYSCALL_DEFINE5(ppoll_time32, struct pollfd __user *, ufds, unsigned int, nfds,
 			return -EINVAL;
 	}
 
-	ret = set_user_sigmask(sigmask, &ksigmask, &sigsaved, sigsetsize);
+	ret = set_xxx(sigmask, sigsetsize);
 	if (ret)
 		return ret;
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	restore_user_sigmask(sigmask, &sigsaved);
-
+	update_xxx(ret == -EINTR);
 	/* We can restart this syscall, usually */
 	if (ret == -EINTR)
 		ret = -ERESTARTNOHAND;
-
 	ret = poll_select_copy_remaining(&end_time, tsp, PT_OLD_TIMESPEC, ret);
 
 	return ret;
@@ -1322,7 +1314,6 @@ static long do_compat_pselect(int n, compat_ulong_t __user *inp,
 	void __user *tsp, compat_sigset_t __user *sigmask,
 	compat_size_t sigsetsize, enum poll_time_type type)
 {
-	sigset_t ksigmask, sigsaved;
 	struct timespec64 ts, end_time, *to = NULL;
 	int ret;
 
@@ -1345,15 +1336,14 @@ static long do_compat_pselect(int n, compat_ulong_t __user *inp,
 			return -EINVAL;
 	}
 
-	ret = set_compat_user_sigmask(sigmask, &ksigmask, &sigsaved, sigsetsize);
+	ret = set_compat_xxx(sigmask, sigsetsize);
 	if (ret)
 		return ret;
 
 	ret = compat_core_sys_select(n, inp, outp, exp, to);
+	update_xxx(ret == -ERESTARTNOHAND);
 	ret = poll_select_copy_remaining(&end_time, tsp, type, ret);
 
-	restore_user_sigmask(sigmask, &sigsaved);
-
 	return ret;
 }
 
@@ -1406,7 +1396,6 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time32, struct pollfd __user *, ufds,
 	unsigned int,  nfds, struct old_timespec32 __user *, tsp,
 	const compat_sigset_t __user *, sigmask, compat_size_t, sigsetsize)
 {
-	sigset_t ksigmask, sigsaved;
 	struct timespec64 ts, end_time, *to = NULL;
 	int ret;
 
@@ -1419,18 +1408,16 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time32, struct pollfd __user *, ufds,
 			return -EINVAL;
 	}
 
-	ret = set_compat_user_sigmask(sigmask, &ksigmask, &sigsaved, sigsetsize);
+	ret = set_compat_xxx(sigmask, sigsetsize);
 	if (ret)
 		return ret;
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	restore_user_sigmask(sigmask, &sigsaved);
-
+	update_xxx(ret == -EINTR);
 	/* We can restart this syscall, usually */
 	if (ret == -EINTR)
 		ret = -ERESTARTNOHAND;
-
 	ret = poll_select_copy_remaining(&end_time, tsp, PT_OLD_TIMESPEC, ret);
 
 	return ret;
@@ -1442,7 +1429,6 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time64, struct pollfd __user *, ufds,
 	unsigned int,  nfds, struct __kernel_timespec __user *, tsp,
 	const compat_sigset_t __user *, sigmask, compat_size_t, sigsetsize)
 {
-	sigset_t ksigmask, sigsaved;
 	struct timespec64 ts, end_time, *to = NULL;
 	int ret;
 
@@ -1455,18 +1441,16 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time64, struct pollfd __user *, ufds,
 			return -EINVAL;
 	}
 
-	ret = set_compat_user_sigmask(sigmask, &ksigmask, &sigsaved, sigsetsize);
+	ret = set_compat_xxx(sigmask, sigsetsize);
 	if (ret)
 		return ret;
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	restore_user_sigmask(sigmask, &sigsaved);
-
+	update_xxx(ret == -EINTR);
 	/* We can restart this syscall, usually */
 	if (ret == -EINTR)
 		ret = -ERESTARTNOHAND;
-
 	ret = poll_select_copy_remaining(&end_time, tsp, PT_TIMESPEC, ret);
 
 	return ret;
diff --git a/include/linux/compat.h b/include/linux/compat.h
index ebddcb6..b20b001 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -138,9 +138,7 @@ typedef struct {
 	compat_sigset_word	sig[_COMPAT_NSIG_WORDS];
 } compat_sigset_t;
 
-int set_compat_user_sigmask(const compat_sigset_t __user *usigmask,
-			    sigset_t *set, sigset_t *oldset,
-			    size_t sigsetsize);
+int set_compat_xxx(const compat_sigset_t __user *umask, size_t sigsetsize);
 
 struct compat_sigaction {
 #ifndef __ARCH_HAS_IRIX_SIGACTION
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 38a0f07..8b5b537 100644
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
diff --git a/include/linux/signal.h b/include/linux/signal.h
index 9702016..65f84ac 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -273,10 +273,8 @@ extern int group_send_sig_info(int sig, struct kernel_siginfo *info,
 			       struct task_struct *p, enum pid_type type);
 extern int __group_send_sig_info(int, struct kernel_siginfo *, struct task_struct *);
 extern int sigprocmask(int, sigset_t *, sigset_t *);
-extern int set_user_sigmask(const sigset_t __user *usigmask, sigset_t *set,
-	sigset_t *oldset, size_t sigsetsize);
-extern void restore_user_sigmask(const void __user *usigmask,
-				 sigset_t *sigsaved);
+extern int set_xxx(const sigset_t __user *umask, size_t sigsetsize);
+extern void update_xxx(bool interupted);
 extern void set_current_blocked(sigset_t *);
 extern void __set_current_blocked(const sigset_t *);
 extern int show_unhandled_signals;
diff --git a/kernel/signal.c b/kernel/signal.c
index d7b9d14..0a1ec68 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2861,79 +2861,56 @@ EXPORT_SYMBOL(sigprocmask);
  *
  * This is useful for syscalls such as ppoll, pselect, io_pgetevents and
  * epoll_pwait where a new sigmask is passed from userland for the syscalls.
+ *
+ * Note that it does set_restore_sigmask() in advance, so it must be always
+ * paired with update_xxx() before return from syscall.
  */
-int set_user_sigmask(const sigset_t __user *usigmask, sigset_t *set,
-		     sigset_t *oldset, size_t sigsetsize)
+int set_xxx(const sigset_t __user *umask, size_t sigsetsize)
 {
-	if (!usigmask)
-		return 0;
+	sigset_t *kmask;
 
+	if (!umask)
+		return 0;
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
-EXPORT_SYMBOL(set_user_sigmask);
+
+void update_xxx(bool interrupted)
+{
+	if (interrupted)
+		WARN_ON(!test_thread_flag(TIF_SIGPENDING));
+	else
+		restore_saved_sigmask();
+}
 
 #ifdef CONFIG_COMPAT
-int set_compat_user_sigmask(const compat_sigset_t __user *usigmask,
-			    sigset_t *set, sigset_t *oldset,
-			    size_t sigsetsize)
+int set_compat_xxx(const compat_sigset_t __user *umask, size_t sigsetsize)
 {
-	if (!usigmask)
-		return 0;
+	sigset_t *kmask;
 
+	if (!umask)
+		return 0;
 	if (sigsetsize != sizeof(compat_sigset_t))
 		return -EINVAL;
-	if (get_compat_sigset(set, usigmask))
+	if (get_compat_sigset(kmask, umask))
 		return -EFAULT;
 
-	*oldset = current->blocked;
-	set_current_blocked(set);
+	set_restore_sigmask();
+	current->saved_sigmask = current->blocked;
+	set_current_blocked(kmask);
 
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

