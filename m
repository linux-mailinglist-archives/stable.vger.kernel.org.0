Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF187623D7
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389699AbfGHPbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:31:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728274AbfGHPbT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:31:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3288E21738;
        Mon,  8 Jul 2019 15:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599878;
        bh=UEbIvTbrXoNpQWQis8llokLelW+pvuGtGp9YbkDSf/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cmeHXYAvJ59eyB2hN5SK9lKTbv5056yyO3JixIS/EZlHRXDiZXMXp4CQ0q9DaRr2l
         uA1hRy6qlecUM3AppzmMF7quZIuoF8FCigUHZhy6pMSJHwSW0+TEtryfXupX3eIxSx
         K94Ren01pxyvoc9IZIX6RhzCvBdIEzoRHdWWOptE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Eric Wong <e@80x24.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jason Baron <jbaron@akamai.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        David Laight <David.Laight@ACULAB.COM>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.1 02/96] signal: remove the wrong signal_pending() check in restore_user_sigmask()
Date:   Mon,  8 Jul 2019 17:12:34 +0200
Message-Id: <20190708150526.393509319@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
References: <20190708150526.234572443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

commit 97abc889ee296faf95ca0e978340fb7b942a3e32 upstream.

This is the minimal fix for stable, I'll send cleanups later.

Commit 854a6ed56839 ("signal: Add restore_user_sigmask()") introduced
the visible change which breaks user-space: a signal temporary unblocked
by set_user_sigmask() can be delivered even if the caller returns
success or timeout.

Change restore_user_sigmask() to accept the additional "interrupted"
argument which should be used instead of signal_pending() check, and
update the callers.

Eric said:

: For clarity.  I don't think this is required by posix, or fundamentally to
: remove the races in select.  It is what linux has always done and we have
: applications who care so I agree this fix is needed.
:
: Further in any case where the semantic change that this patch rolls back
: (aka where allowing a signal to be delivered and the select like call to
: complete) would be advantage we can do as well if not better by using
: signalfd.
:
: Michael is there any chance we can get this guarantee of the linux
: implementation of pselect and friends clearly documented.  The guarantee
: that if the system call completes successfully we are guaranteed that no
: signal that is unblocked by using sigmask will be delivered?

Link: http://lkml.kernel.org/r/20190604134117.GA29963@redhat.com
Fixes: 854a6ed56839a40f6b5d02a2962f48841482eec4 ("signal: Add restore_user_sigmask()")
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Eric Wong <e@80x24.org>
Tested-by: Eric Wong <e@80x24.org>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: <stable@vger.kernel.org>	[5.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c               |   28 ++++++++++++++++++++--------
 fs/eventpoll.c         |    4 ++--
 fs/io_uring.c          |    2 +-
 fs/select.c            |   18 ++++++------------
 include/linux/signal.h |    2 +-
 kernel/signal.c        |    5 +++--
 6 files changed, 33 insertions(+), 26 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -2095,6 +2095,7 @@ SYSCALL_DEFINE6(io_pgetevents,
 	struct __aio_sigset	ksig = { NULL, };
 	sigset_t		ksigmask, sigsaved;
 	struct timespec64	ts;
+	bool interrupted;
 	int ret;
 
 	if (timeout && unlikely(get_timespec64(&ts, timeout)))
@@ -2108,8 +2109,10 @@ SYSCALL_DEFINE6(io_pgetevents,
 		return ret;
 
 	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &ts : NULL);
-	restore_user_sigmask(ksig.sigmask, &sigsaved);
-	if (signal_pending(current) && !ret)
+
+	interrupted = signal_pending(current);
+	restore_user_sigmask(ksig.sigmask, &sigsaved, interrupted);
+	if (interrupted && !ret)
 		ret = -ERESTARTNOHAND;
 
 	return ret;
@@ -2128,6 +2131,7 @@ SYSCALL_DEFINE6(io_pgetevents_time32,
 	struct __aio_sigset	ksig = { NULL, };
 	sigset_t		ksigmask, sigsaved;
 	struct timespec64	ts;
+	bool interrupted;
 	int ret;
 
 	if (timeout && unlikely(get_old_timespec32(&ts, timeout)))
@@ -2142,8 +2146,10 @@ SYSCALL_DEFINE6(io_pgetevents_time32,
 		return ret;
 
 	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &ts : NULL);
-	restore_user_sigmask(ksig.sigmask, &sigsaved);
-	if (signal_pending(current) && !ret)
+
+	interrupted = signal_pending(current);
+	restore_user_sigmask(ksig.sigmask, &sigsaved, interrupted);
+	if (interrupted && !ret)
 		ret = -ERESTARTNOHAND;
 
 	return ret;
@@ -2193,6 +2199,7 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents,
 	struct __compat_aio_sigset ksig = { NULL, };
 	sigset_t ksigmask, sigsaved;
 	struct timespec64 t;
+	bool interrupted;
 	int ret;
 
 	if (timeout && get_old_timespec32(&t, timeout))
@@ -2206,8 +2213,10 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents,
 		return ret;
 
 	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &t : NULL);
-	restore_user_sigmask(ksig.sigmask, &sigsaved);
-	if (signal_pending(current) && !ret)
+
+	interrupted = signal_pending(current);
+	restore_user_sigmask(ksig.sigmask, &sigsaved, interrupted);
+	if (interrupted && !ret)
 		ret = -ERESTARTNOHAND;
 
 	return ret;
@@ -2226,6 +2235,7 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents_tim
 	struct __compat_aio_sigset ksig = { NULL, };
 	sigset_t ksigmask, sigsaved;
 	struct timespec64 t;
+	bool interrupted;
 	int ret;
 
 	if (timeout && get_timespec64(&t, timeout))
@@ -2239,8 +2249,10 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents_tim
 		return ret;
 
 	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &t : NULL);
-	restore_user_sigmask(ksig.sigmask, &sigsaved);
-	if (signal_pending(current) && !ret)
+
+	interrupted = signal_pending(current);
+	restore_user_sigmask(ksig.sigmask, &sigsaved, interrupted);
+	if (interrupted && !ret)
 		ret = -ERESTARTNOHAND;
 
 	return ret;
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2330,7 +2330,7 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 
 	error = do_epoll_wait(epfd, events, maxevents, timeout);
 
-	restore_user_sigmask(sigmask, &sigsaved);
+	restore_user_sigmask(sigmask, &sigsaved, error == -EINTR);
 
 	return error;
 }
@@ -2355,7 +2355,7 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int,
 
 	err = do_epoll_wait(epfd, events, maxevents, timeout);
 
-	restore_user_sigmask(sigmask, &sigsaved);
+	restore_user_sigmask(sigmask, &sigsaved, err == -EINTR);
 
 	return err;
 }
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2096,7 +2096,7 @@ static int io_cqring_wait(struct io_ring
 	finish_wait(&ctx->wait, &wait);
 
 	if (sig)
-		restore_user_sigmask(sig, &sigsaved);
+		restore_user_sigmask(sig, &sigsaved, ret == -EINTR);
 
 	return READ_ONCE(ring->r.head) == READ_ONCE(ring->r.tail) ? ret : 0;
 }
--- a/fs/select.c
+++ b/fs/select.c
@@ -758,10 +758,9 @@ static long do_pselect(int n, fd_set __u
 		return ret;
 
 	ret = core_sys_select(n, inp, outp, exp, to);
+	restore_user_sigmask(sigmask, &sigsaved, ret == -ERESTARTNOHAND);
 	ret = poll_select_copy_remaining(&end_time, tsp, type, ret);
 
-	restore_user_sigmask(sigmask, &sigsaved);
-
 	return ret;
 }
 
@@ -1106,8 +1105,7 @@ SYSCALL_DEFINE5(ppoll, struct pollfd __u
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	restore_user_sigmask(sigmask, &sigsaved);
-
+	restore_user_sigmask(sigmask, &sigsaved, ret == -EINTR);
 	/* We can restart this syscall, usually */
 	if (ret == -EINTR)
 		ret = -ERESTARTNOHAND;
@@ -1142,8 +1140,7 @@ SYSCALL_DEFINE5(ppoll_time32, struct pol
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	restore_user_sigmask(sigmask, &sigsaved);
-
+	restore_user_sigmask(sigmask, &sigsaved, ret == -EINTR);
 	/* We can restart this syscall, usually */
 	if (ret == -EINTR)
 		ret = -ERESTARTNOHAND;
@@ -1350,10 +1347,9 @@ static long do_compat_pselect(int n, com
 		return ret;
 
 	ret = compat_core_sys_select(n, inp, outp, exp, to);
+	restore_user_sigmask(sigmask, &sigsaved, ret == -ERESTARTNOHAND);
 	ret = poll_select_copy_remaining(&end_time, tsp, type, ret);
 
-	restore_user_sigmask(sigmask, &sigsaved);
-
 	return ret;
 }
 
@@ -1425,8 +1421,7 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time32, str
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	restore_user_sigmask(sigmask, &sigsaved);
-
+	restore_user_sigmask(sigmask, &sigsaved, ret == -EINTR);
 	/* We can restart this syscall, usually */
 	if (ret == -EINTR)
 		ret = -ERESTARTNOHAND;
@@ -1461,8 +1456,7 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time64, str
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	restore_user_sigmask(sigmask, &sigsaved);
-
+	restore_user_sigmask(sigmask, &sigsaved, ret == -EINTR);
 	/* We can restart this syscall, usually */
 	if (ret == -EINTR)
 		ret = -ERESTARTNOHAND;
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -276,7 +276,7 @@ extern int sigprocmask(int, sigset_t *,
 extern int set_user_sigmask(const sigset_t __user *usigmask, sigset_t *set,
 	sigset_t *oldset, size_t sigsetsize);
 extern void restore_user_sigmask(const void __user *usigmask,
-				 sigset_t *sigsaved);
+				 sigset_t *sigsaved, bool interrupted);
 extern void set_current_blocked(sigset_t *);
 extern void __set_current_blocked(const sigset_t *);
 extern int show_unhandled_signals;
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2851,7 +2851,8 @@ EXPORT_SYMBOL(set_compat_user_sigmask);
  * This is useful for syscalls such as ppoll, pselect, io_pgetevents and
  * epoll_pwait where a new sigmask is passed in from userland for the syscalls.
  */
-void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved)
+void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved,
+				bool interrupted)
 {
 
 	if (!usigmask)
@@ -2861,7 +2862,7 @@ void restore_user_sigmask(const void __u
 	 * Restoring sigmask here can lead to delivering signals that the above
 	 * syscalls are intended to block because of the sigmask passed in.
 	 */
-	if (signal_pending(current)) {
+	if (interrupted) {
 		current->saved_sigmask = *sigsaved;
 		set_restore_sigmask();
 		return;


