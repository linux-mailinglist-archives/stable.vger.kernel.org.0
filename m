Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22BC53492E
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 15:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbfFDNlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 09:41:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51338 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727129AbfFDNlw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 09:41:52 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E2E7330ADC7A;
        Tue,  4 Jun 2019 13:41:25 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.159])
        by smtp.corp.redhat.com (Postfix) with SMTP id 582FB6199A;
        Tue,  4 Jun 2019 13:41:18 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Tue,  4 Jun 2019 15:41:25 +0200 (CEST)
Date:   Tue, 4 Jun 2019 15:41:17 +0200
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
Subject: [PATCH] signal: remove the wrong signal_pending() check in
 restore_user_sigmask()
Message-ID: <20190604134117.GA29963@redhat.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529161157.GA27659@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Tue, 04 Jun 2019 13:41:51 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the minimal fix for stable, I'll send cleanups later.

The commit 854a6ed56839a40f6b5d02a2962f48841482eec4 ("signal: Add
restore_user_sigmask()") introduced the visible change which breaks
user-space: a signal temporary unblocked by set_user_sigmask() can
be delivered even if the caller returns success or timeout.

Change restore_user_sigmask() to accept the additional "interrupted"
argument which should be used instead of signal_pending() check, and
update the callers.

Reported-by: Eric Wong <e@80x24.org>
Fixes: 854a6ed56839a40f6b5d02a2962f48841482eec4 ("signal: Add restore_user_sigmask()")
cc: stable@vger.kernel.org (v5.0+)
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/aio.c               | 28 ++++++++++++++++++++--------
 fs/eventpoll.c         |  4 ++--
 fs/io_uring.c          |  7 ++++---
 fs/select.c            | 18 ++++++------------
 include/linux/signal.h |  2 +-
 kernel/signal.c        |  5 +++--
 6 files changed, 36 insertions(+), 28 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 3490d1f..c1e581d 100644
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
@@ -2226,6 +2235,7 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents_time64,
 	struct __compat_aio_sigset ksig = { NULL, };
 	sigset_t ksigmask, sigsaved;
 	struct timespec64 t;
+	bool interrupted;
 	int ret;
 
 	if (timeout && get_timespec64(&t, timeout))
@@ -2239,8 +2249,10 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents_time64,
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
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index c6f5131..4c74c76 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2325,7 +2325,7 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
 
 	error = do_epoll_wait(epfd, events, maxevents, timeout);
 
-	restore_user_sigmask(sigmask, &sigsaved);
+	restore_user_sigmask(sigmask, &sigsaved, error == -EINTR);
 
 	return error;
 }
@@ -2350,7 +2350,7 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 
 	err = do_epoll_wait(epfd, events, maxevents, timeout);
 
-	restore_user_sigmask(sigmask, &sigsaved);
+	restore_user_sigmask(sigmask, &sigsaved, err == -EINTR);
 
 	return err;
 }
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0fbb486..1147c5d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2201,11 +2201,12 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
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
diff --git a/fs/select.c b/fs/select.c
index 6cbc9ff..a4d8f6e 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -758,10 +758,9 @@ static long do_pselect(int n, fd_set __user *inp, fd_set __user *outp,
 		return ret;
 
 	ret = core_sys_select(n, inp, outp, exp, to);
+	restore_user_sigmask(sigmask, &sigsaved, ret == -ERESTARTNOHAND);
 	ret = poll_select_copy_remaining(&end_time, tsp, type, ret);
 
-	restore_user_sigmask(sigmask, &sigsaved);
-
 	return ret;
 }
 
@@ -1106,8 +1105,7 @@ SYSCALL_DEFINE5(ppoll, struct pollfd __user *, ufds, unsigned int, nfds,
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	restore_user_sigmask(sigmask, &sigsaved);
-
+	restore_user_sigmask(sigmask, &sigsaved, ret == -EINTR);
 	/* We can restart this syscall, usually */
 	if (ret == -EINTR)
 		ret = -ERESTARTNOHAND;
@@ -1142,8 +1140,7 @@ SYSCALL_DEFINE5(ppoll_time32, struct pollfd __user *, ufds, unsigned int, nfds,
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	restore_user_sigmask(sigmask, &sigsaved);
-
+	restore_user_sigmask(sigmask, &sigsaved, ret == -EINTR);
 	/* We can restart this syscall, usually */
 	if (ret == -EINTR)
 		ret = -ERESTARTNOHAND;
@@ -1350,10 +1347,9 @@ static long do_compat_pselect(int n, compat_ulong_t __user *inp,
 		return ret;
 
 	ret = compat_core_sys_select(n, inp, outp, exp, to);
+	restore_user_sigmask(sigmask, &sigsaved, ret == -ERESTARTNOHAND);
 	ret = poll_select_copy_remaining(&end_time, tsp, type, ret);
 
-	restore_user_sigmask(sigmask, &sigsaved);
-
 	return ret;
 }
 
@@ -1425,8 +1421,7 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time32, struct pollfd __user *, ufds,
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	restore_user_sigmask(sigmask, &sigsaved);
-
+	restore_user_sigmask(sigmask, &sigsaved, ret == -EINTR);
 	/* We can restart this syscall, usually */
 	if (ret == -EINTR)
 		ret = -ERESTARTNOHAND;
@@ -1461,8 +1456,7 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time64, struct pollfd __user *, ufds,
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	restore_user_sigmask(sigmask, &sigsaved);
-
+	restore_user_sigmask(sigmask, &sigsaved, ret == -EINTR);
 	/* We can restart this syscall, usually */
 	if (ret == -EINTR)
 		ret = -ERESTARTNOHAND;
diff --git a/include/linux/signal.h b/include/linux/signal.h
index 9702016..78c2bb3 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -276,7 +276,7 @@ extern int sigprocmask(int, sigset_t *, sigset_t *);
 extern int set_user_sigmask(const sigset_t __user *usigmask, sigset_t *set,
 	sigset_t *oldset, size_t sigsetsize);
 extern void restore_user_sigmask(const void __user *usigmask,
-				 sigset_t *sigsaved);
+				 sigset_t *sigsaved, bool interrupted);
 extern void set_current_blocked(sigset_t *);
 extern void __set_current_blocked(const sigset_t *);
 extern int show_unhandled_signals;
diff --git a/kernel/signal.c b/kernel/signal.c
index 328a01e..aa6a6f1 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2912,7 +2912,8 @@ EXPORT_SYMBOL(set_compat_user_sigmask);
  * This is useful for syscalls such as ppoll, pselect, io_pgetevents and
  * epoll_pwait where a new sigmask is passed in from userland for the syscalls.
  */
-void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved)
+void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved,
+				bool interrupted)
 {
 
 	if (!usigmask)
@@ -2922,7 +2923,7 @@ void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved)
 	 * Restoring sigmask here can lead to delivering signals that the above
 	 * syscalls are intended to block because of the sigmask passed in.
 	 */
-	if (signal_pending(current)) {
+	if (interrupted) {
 		current->saved_sigmask = *sigsaved;
 		set_restore_sigmask();
 		return;
-- 
2.5.0


