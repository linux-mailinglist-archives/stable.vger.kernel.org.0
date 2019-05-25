Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54D802A736
	for <lists+stable@lfdr.de>; Sun, 26 May 2019 00:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfEYWUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 May 2019 18:20:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726739AbfEYWUs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 May 2019 18:20:48 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33F3E20815;
        Sat, 25 May 2019 22:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558822847;
        bh=edXt8ADSrQmorOhenXIeKK305+HETN7cDe7i9eH7VhU=;
        h=Date:From:To:Subject:From;
        b=bJGE2JMJsAz3n00/L9dOZDkWU9zX4gZN9YNj/fxkojB8ccw9KMD6MpT6MfkMHTcle
         IODLJXChqaiU6bBan2FghCOhGEyE/VtSHAFwNa5QCCOg1lDWR8M8DD4cFDHBrwG2qM
         95XPCMzs89P3fQYu1IoBaWcrYoGBWTqiDl/E7z8Q=
Date:   Sat, 25 May 2019 15:20:46 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, axboe@kernel.dk, dave@stgolabs.net,
        deepa.kernel@gmail.com, e@80x24.org, jbaron@akamai.com,
        mm-commits@vger.kernel.org, oleg@redhat.com,
        stable@vger.kernel.org, tglx@linutronix.de, viro@zeniv.linux.org.uk
Subject:  [to-be-updated]
 signal-adjust-error-codes-according-to-restore_user_sigmask.patch removed
 from -mm tree
Message-ID: <20190525222046.S7yuY6bvW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: signal: adjust error codes according to restore_user_sigmask()
has been removed from the -mm tree.  Its filename was
     signal-adjust-error-codes-according-to-restore_user_sigmask.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: signal: adjust error codes according to restore_user_sigmask()

A regression caused by 854a6ed56839 ("signal: Add restore_user_sigmask()")
caused users of epoll_pwait, io_pgetevents, and ppoll to notice a latent
problem in signal handling during these syscalls.

That patch (854a6ed56839) moved the signal_pending() check closer to
restoring of the user sigmask.  But, it failed to update the error code
accordingly.  From the userspace perspective, the patch increased the time
window for the signal discovery and subsequent delivery to the userspace,
but did not always adjust the errno afterwards.  The behavior before
854a6ed56839a was that the signals were dropped after the error code was
decided.  This resulted in lost signals but the userspace did not notice
it as the syscalls had finished executing the core functionality and the
error codes returned notified success.

For all the syscalls that receive a sigmask from the userland, the user
sigmask is to be in effect through the syscall execution.  At the end of
syscall, sigmask of the current process is restored to what it was before
the switch over to user sigmask.  But, for this to be true in practice,
the sigmask should be restored only at the the point we change the
saved_sigmask.  Anything before that loses signals.  And, anything after
is just pointless as the signal is already lost by restoring the sigmask.

Detailed issue discussion permalink:
https://lore.kernel.org/linux-fsdevel/20190427093319.sgicqik2oqkez3wk@dcvr/

Note that this patch returns interrupted errors (EINTR, ERESTARTNOHAND,
etc) only when there is no other error.  If there is a signal and an error
like EINVAL, the syscalls return -EINVAL rather than the interrupted error
codes.

[deepa.kernel@gmail.com: restore accidentally removed local]
  Link: http://lkml.kernel.org/r/20190522144103.17733-1-deepa.kernel@gmail.com
Link: http://lkml.kernel.org/r/20190522032144.10995-1-deepa.kernel@gmail.com
Fixes: 854a6ed56839a40f ("signal: Add restore_user_sigmask()")
Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Reported-by: Eric Wong <e@80x24.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c               |   24 ++++++++++++------------
 fs/eventpoll.c         |   14 ++++++++++----
 fs/io_uring.c          |    7 +++++--
 fs/select.c            |   37 +++++++++++++++++++++----------------
 include/linux/signal.h |    2 +-
 kernel/signal.c        |   13 ++++++++++---
 6 files changed, 59 insertions(+), 38 deletions(-)

--- a/fs/aio.c~signal-adjust-error-codes-according-to-restore_user_sigmask
+++ a/fs/aio.c
@@ -2095,7 +2095,7 @@ SYSCALL_DEFINE6(io_pgetevents,
 	struct __aio_sigset	ksig = { NULL, };
 	sigset_t		ksigmask, sigsaved;
 	struct timespec64	ts;
-	int ret;
+	int ret, signal_detected;
 
 	if (timeout && unlikely(get_timespec64(&ts, timeout)))
 		return -EFAULT;
@@ -2108,8 +2108,8 @@ SYSCALL_DEFINE6(io_pgetevents,
 		return ret;
 
 	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &ts : NULL);
-	restore_user_sigmask(ksig.sigmask, &sigsaved);
-	if (signal_pending(current) && !ret)
+	signal_detected = restore_user_sigmask(ksig.sigmask, &sigsaved);
+	if (signal_detected && !ret)
 		ret = -ERESTARTNOHAND;
 
 	return ret;
@@ -2128,7 +2128,7 @@ SYSCALL_DEFINE6(io_pgetevents_time32,
 	struct __aio_sigset	ksig = { NULL, };
 	sigset_t		ksigmask, sigsaved;
 	struct timespec64	ts;
-	int ret;
+	int ret, signal_detected;
 
 	if (timeout && unlikely(get_old_timespec32(&ts, timeout)))
 		return -EFAULT;
@@ -2142,8 +2142,8 @@ SYSCALL_DEFINE6(io_pgetevents_time32,
 		return ret;
 
 	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &ts : NULL);
-	restore_user_sigmask(ksig.sigmask, &sigsaved);
-	if (signal_pending(current) && !ret)
+	signal_detected = restore_user_sigmask(ksig.sigmask, &sigsaved);
+	if (signal_detected && !ret)
 		ret = -ERESTARTNOHAND;
 
 	return ret;
@@ -2193,7 +2193,7 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents,
 	struct __compat_aio_sigset ksig = { NULL, };
 	sigset_t ksigmask, sigsaved;
 	struct timespec64 t;
-	int ret;
+	int ret, signal_detected;
 
 	if (timeout && get_old_timespec32(&t, timeout))
 		return -EFAULT;
@@ -2206,8 +2206,8 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents,
 		return ret;
 
 	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &t : NULL);
-	restore_user_sigmask(ksig.sigmask, &sigsaved);
-	if (signal_pending(current) && !ret)
+	signal_detected = restore_user_sigmask(ksig.sigmask, &sigsaved);
+	if (signal_detected && !ret)
 		ret = -ERESTARTNOHAND;
 
 	return ret;
@@ -2226,7 +2226,7 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents_tim
 	struct __compat_aio_sigset ksig = { NULL, };
 	sigset_t ksigmask, sigsaved;
 	struct timespec64 t;
-	int ret;
+	int ret, signal_detected;
 
 	if (timeout && get_timespec64(&t, timeout))
 		return -EFAULT;
@@ -2239,8 +2239,8 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents_tim
 		return ret;
 
 	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &t : NULL);
-	restore_user_sigmask(ksig.sigmask, &sigsaved);
-	if (signal_pending(current) && !ret)
+	signal_detected = restore_user_sigmask(ksig.sigmask, &sigsaved);
+	if (signal_detected && !ret)
 		ret = -ERESTARTNOHAND;
 
 	return ret;
--- a/fs/eventpoll.c~signal-adjust-error-codes-according-to-restore_user_sigmask
+++ a/fs/eventpoll.c
@@ -2317,7 +2317,7 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 		int, maxevents, int, timeout, const sigset_t __user *, sigmask,
 		size_t, sigsetsize)
 {
-	int error;
+	int error, signal_detected;
 	sigset_t ksigmask, sigsaved;
 
 	/*
@@ -2330,7 +2330,10 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 
 	error = do_epoll_wait(epfd, events, maxevents, timeout);
 
-	restore_user_sigmask(sigmask, &sigsaved);
+	signal_detected = restore_user_sigmask(sigmask, &sigsaved);
+
+	if (signal_detected && !error)
+		error = -EINTR;
 
 	return error;
 }
@@ -2342,7 +2345,7 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int,
 			const compat_sigset_t __user *, sigmask,
 			compat_size_t, sigsetsize)
 {
-	long err;
+	long err, signal_detected;
 	sigset_t ksigmask, sigsaved;
 
 	/*
@@ -2355,7 +2358,10 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int,
 
 	err = do_epoll_wait(epfd, events, maxevents, timeout);
 
-	restore_user_sigmask(sigmask, &sigsaved);
+	signal_detected = restore_user_sigmask(sigmask, &sigsaved);
+
+	if (signal_detected && !err)
+		err = -EINTR;
 
 	return err;
 }
--- a/fs/io_uring.c~signal-adjust-error-codes-according-to-restore_user_sigmask
+++ a/fs/io_uring.c
@@ -2204,8 +2204,11 @@ static int io_cqring_wait(struct io_ring
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
 
-	if (sig)
-		restore_user_sigmask(sig, &sigsaved);
+	if (sig) {
+		int signal_detected = restore_user_sigmask(sig, &sigsaved);
+		if (signal_detected && !ret)
+			ret  = -EINTR;
+	}
 
 	return READ_ONCE(ring->r.head) == READ_ONCE(ring->r.tail) ? ret : 0;
 }
--- a/fs/select.c~signal-adjust-error-codes-according-to-restore_user_sigmask
+++ a/fs/select.c
@@ -732,7 +732,7 @@ static long do_pselect(int n, fd_set __u
 {
 	sigset_t ksigmask, sigsaved;
 	struct timespec64 ts, end_time, *to = NULL;
-	int ret;
+	int ret, signal_detected;
 
 	if (tsp) {
 		switch (type) {
@@ -760,7 +760,9 @@ static long do_pselect(int n, fd_set __u
 	ret = core_sys_select(n, inp, outp, exp, to);
 	ret = poll_select_copy_remaining(&end_time, tsp, type, ret);
 
-	restore_user_sigmask(sigmask, &sigsaved);
+	signal_detected = restore_user_sigmask(sigmask, &sigsaved);
+	if (signal_detected && !ret)
+		ret = -EINTR;
 
 	return ret;
 }
@@ -1089,7 +1091,7 @@ SYSCALL_DEFINE5(ppoll, struct pollfd __u
 {
 	sigset_t ksigmask, sigsaved;
 	struct timespec64 ts, end_time, *to = NULL;
-	int ret;
+	int ret, signal_detected;
 
 	if (tsp) {
 		if (get_timespec64(&ts, tsp))
@@ -1106,10 +1108,10 @@ SYSCALL_DEFINE5(ppoll, struct pollfd __u
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	restore_user_sigmask(sigmask, &sigsaved);
+	signal_detected = restore_user_sigmask(sigmask, &sigsaved);
 
 	/* We can restart this syscall, usually */
-	if (ret == -EINTR)
+	if (ret == -EINTR || (signal_detected && !ret))
 		ret = -ERESTARTNOHAND;
 
 	ret = poll_select_copy_remaining(&end_time, tsp, PT_TIMESPEC, ret);
@@ -1125,7 +1127,7 @@ SYSCALL_DEFINE5(ppoll_time32, struct pol
 {
 	sigset_t ksigmask, sigsaved;
 	struct timespec64 ts, end_time, *to = NULL;
-	int ret;
+	int ret, signal_detected;
 
 	if (tsp) {
 		if (get_old_timespec32(&ts, tsp))
@@ -1142,10 +1144,10 @@ SYSCALL_DEFINE5(ppoll_time32, struct pol
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	restore_user_sigmask(sigmask, &sigsaved);
+	signal_detected = restore_user_sigmask(sigmask, &sigsaved);
 
 	/* We can restart this syscall, usually */
-	if (ret == -EINTR)
+	if (ret == -EINTR || (signal_detected && !ret))
 		ret = -ERESTARTNOHAND;
 
 	ret = poll_select_copy_remaining(&end_time, tsp, PT_OLD_TIMESPEC, ret);
@@ -1324,7 +1326,7 @@ static long do_compat_pselect(int n, com
 {
 	sigset_t ksigmask, sigsaved;
 	struct timespec64 ts, end_time, *to = NULL;
-	int ret;
+	int ret, signal_detected;
 
 	if (tsp) {
 		switch (type) {
@@ -1352,7 +1354,10 @@ static long do_compat_pselect(int n, com
 	ret = compat_core_sys_select(n, inp, outp, exp, to);
 	ret = poll_select_copy_remaining(&end_time, tsp, type, ret);
 
-	restore_user_sigmask(sigmask, &sigsaved);
+	signal_detected = restore_user_sigmask(sigmask, &sigsaved);
+
+	if (signal_detected && !ret)
+		ret = -EINTR;
 
 	return ret;
 }
@@ -1408,7 +1413,7 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time32, str
 {
 	sigset_t ksigmask, sigsaved;
 	struct timespec64 ts, end_time, *to = NULL;
-	int ret;
+	int ret, signal_detected;
 
 	if (tsp) {
 		if (get_old_timespec32(&ts, tsp))
@@ -1425,10 +1430,10 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time32, str
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	restore_user_sigmask(sigmask, &sigsaved);
+	signal_detected = restore_user_sigmask(sigmask, &sigsaved);
 
 	/* We can restart this syscall, usually */
-	if (ret == -EINTR)
+	if (ret == -EINTR || (signal_detected && !ret))
 		ret = -ERESTARTNOHAND;
 
 	ret = poll_select_copy_remaining(&end_time, tsp, PT_OLD_TIMESPEC, ret);
@@ -1444,7 +1449,7 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time64, str
 {
 	sigset_t ksigmask, sigsaved;
 	struct timespec64 ts, end_time, *to = NULL;
-	int ret;
+	int ret, signal_detected;
 
 	if (tsp) {
 		if (get_timespec64(&ts, tsp))
@@ -1461,10 +1466,10 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time64, str
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	restore_user_sigmask(sigmask, &sigsaved);
+	signal_detected = restore_user_sigmask(sigmask, &sigsaved);
 
 	/* We can restart this syscall, usually */
-	if (ret == -EINTR)
+	if (ret == -EINTR || (signal_detected && !ret))
 		ret = -ERESTARTNOHAND;
 
 	ret = poll_select_copy_remaining(&end_time, tsp, PT_TIMESPEC, ret);
--- a/include/linux/signal.h~signal-adjust-error-codes-according-to-restore_user_sigmask
+++ a/include/linux/signal.h
@@ -275,7 +275,7 @@ extern int __group_send_sig_info(int, st
 extern int sigprocmask(int, sigset_t *, sigset_t *);
 extern int set_user_sigmask(const sigset_t __user *usigmask, sigset_t *set,
 	sigset_t *oldset, size_t sigsetsize);
-extern void restore_user_sigmask(const void __user *usigmask,
+extern int restore_user_sigmask(const void __user *usigmask,
 				 sigset_t *sigsaved);
 extern void set_current_blocked(sigset_t *);
 extern void __set_current_blocked(const sigset_t *);
--- a/kernel/signal.c~signal-adjust-error-codes-according-to-restore_user_sigmask
+++ a/kernel/signal.c
@@ -2906,15 +2906,21 @@ EXPORT_SYMBOL(set_compat_user_sigmask);
  * usigmask: sigmask passed in from userland.
  * sigsaved: saved sigmask when the syscall started and changed the sigmask to
  *           usigmask.
+ * returns 1 in case a pending signal is detected.
+ *
+ * Users of the api need to adjust their return values based on whether the
+ * signal was detected here. If a signal is detected, it is delivered to the
+ * userspace. So without an error like -ETINR, userspace might fail to
+ * adjust the flow of execution.
  *
  * This is useful for syscalls such as ppoll, pselect, io_pgetevents and
  * epoll_pwait where a new sigmask is passed in from userland for the syscalls.
  */
-void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved)
+int restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved)
 {
 
 	if (!usigmask)
-		return;
+		return 0;
 	/*
 	 * When signals are pending, do not restore them here.
 	 * Restoring sigmask here can lead to delivering signals that the above
@@ -2923,7 +2929,7 @@ void restore_user_sigmask(const void __u
 	if (signal_pending(current)) {
 		current->saved_sigmask = *sigsaved;
 		set_restore_sigmask();
-		return;
+		return 1;
 	}
 
 	/*
@@ -2931,6 +2937,7 @@ void restore_user_sigmask(const void __u
 	 * saved_sigmask when signals are not pending.
 	 */
 	set_current_blocked(sigsaved);
+	return 0;
 }
 EXPORT_SYMBOL(restore_user_sigmask);
 
_

Patches currently in -mm which might be from deepa.kernel@gmail.com are


