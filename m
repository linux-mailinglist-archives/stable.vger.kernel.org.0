Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC995A4C6
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 21:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfF1TGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 15:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726565AbfF1TGw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jun 2019 15:06:52 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7929E20828;
        Fri, 28 Jun 2019 19:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561748811;
        bh=dxv5sEFuOWDzjwXBatvUY1sBZPZHOzzq5QYZXBWJesE=;
        h=Date:From:To:Subject:From;
        b=J1+L2giYoe3dKVnME5pA8OC+/2Y1wuz1KrX8inlRVxoNoOs6w/xrzTAVNLxCroJbK
         a04m2hee/TSkUlSa1bsQxSosm3OsvH/BR/OxIZEjcl/KMta1CVROuyqtmVJ9Cqh1u7
         wNrTE2ay9wS3adyQrBEh/w/xCMhfX8BD0lnjoKos=
Date:   Fri, 28 Jun 2019 12:06:50 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, arnd@arndb.de, axboe@kernel.dk,
        dave@stgolabs.net, David.Laight@ACULAB.COM, deepa.kernel@gmail.com,
        e@80x24.org, ebiederm@xmission.com, jbaron@akamai.com,
        mm-commits@vger.kernel.org, mtk.manpages@gmail.com,
        oleg@redhat.com, stable@vger.kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, viro@ZenIV.linux.org.uk
Subject:  [patch 05/15] signal: remove the wrong signal_pending()
 check in restore_user_sigmask()
Message-ID: <20190628190650.ncXpUClib%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>
Subject: signal: remove the wrong signal_pending() check in restore_user_sigmask()

This is the minimal fix for stable, I'll send cleanups later.

854a6ed56839a40f6b5 ("signal: Add restore_user_sigmask()") introduced the
visible change which breaks user-space: a signal temporary unblocked by
set_user_sigmask() can be delivered even if the caller returns success or
timeout.

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
---

 fs/aio.c               |   28 ++++++++++++++++++++--------
 fs/eventpoll.c         |    4 ++--
 fs/io_uring.c          |    7 ++++---
 fs/select.c            |   18 ++++++------------
 include/linux/signal.h |    2 +-
 kernel/signal.c        |    5 +++--
 6 files changed, 36 insertions(+), 28 deletions(-)

--- a/fs/aio.c~signal-remove-the-wrong-signal_pending-check-in-restore_user_sigmask
+++ a/fs/aio.c
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
--- a/fs/eventpoll.c~signal-remove-the-wrong-signal_pending-check-in-restore_user_sigmask
+++ a/fs/eventpoll.c
@@ -2325,7 +2325,7 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 
 	error = do_epoll_wait(epfd, events, maxevents, timeout);
 
-	restore_user_sigmask(sigmask, &sigsaved);
+	restore_user_sigmask(sigmask, &sigsaved, error == -EINTR);
 
 	return error;
 }
@@ -2350,7 +2350,7 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int,
 
 	err = do_epoll_wait(epfd, events, maxevents, timeout);
 
-	restore_user_sigmask(sigmask, &sigsaved);
+	restore_user_sigmask(sigmask, &sigsaved, err == -EINTR);
 
 	return err;
 }
--- a/fs/io_uring.c~signal-remove-the-wrong-signal_pending-check-in-restore_user_sigmask
+++ a/fs/io_uring.c
@@ -2201,11 +2201,12 @@ static int io_cqring_wait(struct io_ring
 	}
 
 	ret = wait_event_interruptible(ctx->wait, io_cqring_events(ring) >= min_events);
-	if (ret == -ERESTARTSYS)
-		ret = -EINTR;
 
 	if (sig)
-		restore_user_sigmask(sig, &sigsaved);
+		restore_user_sigmask(sig, &sigsaved, ret == -ERESTARTSYS);
+
+	if (ret == -ERESTARTSYS)
+		ret = -EINTR;
 
 	return READ_ONCE(ring->r.head) == READ_ONCE(ring->r.tail) ? ret : 0;
 }
--- a/fs/select.c~signal-remove-the-wrong-signal_pending-check-in-restore_user_sigmask
+++ a/fs/select.c
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
--- a/include/linux/signal.h~signal-remove-the-wrong-signal_pending-check-in-restore_user_sigmask
+++ a/include/linux/signal.h
@@ -276,7 +276,7 @@ extern int sigprocmask(int, sigset_t *,
 extern int set_user_sigmask(const sigset_t __user *usigmask, sigset_t *set,
 	sigset_t *oldset, size_t sigsetsize);
 extern void restore_user_sigmask(const void __user *usigmask,
-				 sigset_t *sigsaved);
+				 sigset_t *sigsaved, bool interrupted);
 extern void set_current_blocked(sigset_t *);
 extern void __set_current_blocked(const sigset_t *);
 extern int show_unhandled_signals;
--- a/kernel/signal.c~signal-remove-the-wrong-signal_pending-check-in-restore_user_sigmask
+++ a/kernel/signal.c
@@ -2912,7 +2912,8 @@ EXPORT_SYMBOL(set_compat_user_sigmask);
  * This is useful for syscalls such as ppoll, pselect, io_pgetevents and
  * epoll_pwait where a new sigmask is passed in from userland for the syscalls.
  */
-void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved)
+void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved,
+				bool interrupted)
 {
 
 	if (!usigmask)
@@ -2922,7 +2923,7 @@ void restore_user_sigmask(const void __u
 	 * Restoring sigmask here can lead to delivering signals that the above
 	 * syscalls are intended to block because of the sigmask passed in.
 	 */
-	if (signal_pending(current)) {
+	if (interrupted) {
 		current->saved_sigmask = *sigsaved;
 		set_restore_sigmask();
 		return;
_
