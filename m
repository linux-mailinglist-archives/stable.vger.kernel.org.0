Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C357925C20
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 05:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbfEVDXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 23:23:14 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46192 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727733AbfEVDXO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 May 2019 23:23:14 -0400
Received: by mail-pf1-f196.google.com with SMTP id y11so519595pfm.13;
        Tue, 21 May 2019 20:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=f9SV2JcvDtU8EBcafbohbYmN8WXbfv8fLYa8edh2pO4=;
        b=Fs+HZ5yRw4ESpn9rs86DgOVGi3SbbOfQMZg4tolAIla2bVfXGxrih7Ex09Lb8Sg7Ky
         fp8gsEHPRvXscYgq4FP36zWqKSBcxfVlEGJANOrvNsyAeLtosK5+REro/Fi3Hurtdlud
         wlsmcT4CKP2ozeKMq0TF9UGOJB8a0QmUVl/eivyjCwLi+KheTcA6IHfEGmCu9cSCOlcY
         2FDTdgxyyI+Q6PWFv7haG02Wp81BfQfVgMmOQv1oWuYPS+t9VbdIQXC2FKtxiXldVqXp
         zLSSKJAlw9zy8eohm8YovOjJ4vXUMt3uG1nrN78npBHzopsbIYQa05BXQdu52lbTR7UM
         +6YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=f9SV2JcvDtU8EBcafbohbYmN8WXbfv8fLYa8edh2pO4=;
        b=CXVMWg/jxOs3aqvxGPhGnQQkpb0HyQjdaYPakbzs+G1z14/XP2BA+JaPcTya3+ROZv
         4TIMZ74KQpQb46NuupYI6eArvr8/x+Q2ZeRjhEBzsQ/JsF7R778i76fbYfP38Na0SHpN
         cROrVGQiRWJ2hKSD88qT2kPnjjTE663abzkI6idusETYVjlYMn87Kj6wXu88EwdjGwVM
         Dw1MZY/KZKHay2ItFpreioNjKhqxELl0oZ7SYbFr9h/fwC6LWv0Y7kA1qzO/T/k/VL9K
         JzY15QKNe0Qp7lpTE0zzS6zMYqxtKoQ/omUtjWocgDtsEfGNZ9msCR+qd9WhM7fH9Wdh
         6bjQ==
X-Gm-Message-State: APjAAAWwY+5j6nMDVfU0SE1oG4Dcmgk9dojyxaVc8phvA4xOPe+t5GBq
        HtXR82HQw214BvEE3bPkANEk9M5L
X-Google-Smtp-Source: APXvYqzVH/ezJYuxhC5L8+0wUKZVKSUfFlZck6HLsu4a8TFxhsw4gtHuD65gWlq6auSpWNAmsOWrug==
X-Received: by 2002:a62:6456:: with SMTP id y83mr28021130pfb.71.1558495393292;
        Tue, 21 May 2019 20:23:13 -0700 (PDT)
Received: from deepa-ubuntu.lan (c-98-234-52-230.hsd1.ca.comcast.net. [98.234.52.230])
        by smtp.gmail.com with ESMTPSA id x23sm24762976pfn.160.2019.05.21.20.23.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 20:23:12 -0700 (PDT)
From:   Deepa Dinamani <deepa.kernel@gmail.com>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc:     viro@zeniv.linux.org.uk, arnd@arndb.de, dbueso@suse.de,
        axboe@kernel.dk, dave@stgolabs.net, e@80x24.org, jbaron@akamai.com,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        omar.kilani@gmail.com, tglx@linutronix.de, oleg@redhat.com,
        stable@vger.kernel.org
Subject: [PATCH v2] signal: Adjust error codes according to restore_user_sigmask()
Date:   Tue, 21 May 2019 20:21:44 -0700
Message-Id: <20190522032144.10995-1-deepa.kernel@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A regression caused by 854a6ed56839 ("signal: Add restore_user_sigmask()")
caused users of epoll_pwait, io_pgetevents, and ppoll to notice a
latent problem in signal handling during these syscalls.

That patch (854a6ed56839) moved the signal_pending() check closer
to restoring of the user sigmask. But, it failed to update the error
code accordingly.  From the userspace perspective, the patch increased
the time window for the signal discovery and subsequent delivery to the
userspace, but did not always adjust the errno afterwards. The behavior
before 854a6ed56839a was that the signals were dropped after the error
code was decided. This resulted in lost signals but the userspace did not
notice it as the syscalls had finished executing the core functionality
and the error codes returned notified success.

For all the syscalls that receive a sigmask from the userland,
the user sigmask is to be in effect through the syscall execution.
At the end of syscall, sigmask of the current process is restored
to what it was before the switch over to user sigmask.
But, for this to be true in practice, the sigmask should be restored
only at the the point we change the saved_sigmask. Anything before
that loses signals. And, anything after is just pointless as the
signal is already lost by restoring the sigmask.

Detailed issue discussion permalink:
https://lore.kernel.org/linux-fsdevel/20190427093319.sgicqik2oqkez3wk@dcvr/

Note that this patch returns interrupted errors (EINTR, ERESTARTNOHAND,
etc) only when there is no other error. If there is a signal and an error
like EINVAL, the syscalls return -EINVAL rather than the interrupted
error codes.

Reported-by: Eric Wong <e@80x24.org>
Fixes: 854a6ed56839a40f6b5d02a2962f48841482eec4 ("signal: Add restore_user_sigmask()")
Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: <stable@vger.kernel.org> # 5.0.x
Cc: <stable@vger.kernel.org> # 5.1.x
---
Changes since v1:
* updated the commit text for more context of the pre-existing condition
* added stable tags as requested

 fs/aio.c               | 24 ++++++++++++------------
 fs/eventpoll.c         | 14 ++++++++++----
 fs/io_uring.c          |  7 +++++--
 fs/select.c            | 37 +++++++++++++++++++++----------------
 include/linux/signal.h |  2 +-
 kernel/signal.c        | 13 ++++++++++---
 6 files changed, 59 insertions(+), 38 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 3490d1fa0e16..ebd2b1980161 100644
--- a/fs/aio.c
+++ b/fs/aio.c
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
@@ -2226,7 +2226,7 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents_time64,
 	struct __compat_aio_sigset ksig = { NULL, };
 	sigset_t ksigmask, sigsaved;
 	struct timespec64 t;
-	int ret;
+	int ret, signal_detected;
 
 	if (timeout && get_timespec64(&t, timeout))
 		return -EFAULT;
@@ -2239,8 +2239,8 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents_time64,
 		return ret;
 
 	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &t : NULL);
-	restore_user_sigmask(ksig.sigmask, &sigsaved);
-	if (signal_pending(current) && !ret)
+	signal_detected = restore_user_sigmask(ksig.sigmask, &sigsaved);
+	if (signal_detected && !ret)
 		ret = -ERESTARTNOHAND;
 
 	return ret;
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 4a0e98d87fcc..fe5a0724b417 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2317,7 +2317,7 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
 		int, maxevents, int, timeout, const sigset_t __user *, sigmask,
 		size_t, sigsetsize)
 {
-	int error;
+	int error, signal_detected;
 	sigset_t ksigmask, sigsaved;
 
 	/*
@@ -2330,7 +2330,10 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
 
 	error = do_epoll_wait(epfd, events, maxevents, timeout);
 
-	restore_user_sigmask(sigmask, &sigsaved);
+	signal_detected = restore_user_sigmask(sigmask, &sigsaved);
+
+	if (signal_detected && !error)
+		error = -EINTR;
 
 	return error;
 }
@@ -2342,7 +2345,7 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 			const compat_sigset_t __user *, sigmask,
 			compat_size_t, sigsetsize)
 {
-	long err;
+	long err, signal_detected;
 	sigset_t ksigmask, sigsaved;
 
 	/*
@@ -2355,7 +2358,10 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 
 	err = do_epoll_wait(epfd, events, maxevents, timeout);
 
-	restore_user_sigmask(sigmask, &sigsaved);
+	signal_detected = restore_user_sigmask(sigmask, &sigsaved);
+
+	if (signal_detected && !err)
+		err = -EINTR;
 
 	return err;
 }
diff --git a/fs/io_uring.c b/fs/io_uring.c
index e11d77181398..b785c8d7efc4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2205,8 +2205,11 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
 
-	if (sig)
-		restore_user_sigmask(sig, &sigsaved);
+	if (sig) {
+		signal_detected = restore_user_sigmask(sig, &sigsaved);
+		if (signal_detected && !ret)
+			ret  = -EINTR;
+	}
 
 	return READ_ONCE(ring->r.head) == READ_ONCE(ring->r.tail) ? ret : 0;
 }
diff --git a/fs/select.c b/fs/select.c
index 6cbc9ff56ba0..da9cfea35159 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -732,7 +732,7 @@ static long do_pselect(int n, fd_set __user *inp, fd_set __user *outp,
 {
 	sigset_t ksigmask, sigsaved;
 	struct timespec64 ts, end_time, *to = NULL;
-	int ret;
+	int ret, signal_detected;
 
 	if (tsp) {
 		switch (type) {
@@ -760,7 +760,9 @@ static long do_pselect(int n, fd_set __user *inp, fd_set __user *outp,
 	ret = core_sys_select(n, inp, outp, exp, to);
 	ret = poll_select_copy_remaining(&end_time, tsp, type, ret);
 
-	restore_user_sigmask(sigmask, &sigsaved);
+	signal_detected = restore_user_sigmask(sigmask, &sigsaved);
+	if (signal_detected && !ret)
+		ret = -EINTR;
 
 	return ret;
 }
@@ -1089,7 +1091,7 @@ SYSCALL_DEFINE5(ppoll, struct pollfd __user *, ufds, unsigned int, nfds,
 {
 	sigset_t ksigmask, sigsaved;
 	struct timespec64 ts, end_time, *to = NULL;
-	int ret;
+	int ret, signal_detected;
 
 	if (tsp) {
 		if (get_timespec64(&ts, tsp))
@@ -1106,10 +1108,10 @@ SYSCALL_DEFINE5(ppoll, struct pollfd __user *, ufds, unsigned int, nfds,
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	restore_user_sigmask(sigmask, &sigsaved);
+	signal_detected = restore_user_sigmask(sigmask, &sigsaved);
 
 	/* We can restart this syscall, usually */
-	if (ret == -EINTR)
+	if (ret == -EINTR || (signal_detected && !ret))
 		ret = -ERESTARTNOHAND;
 
 	ret = poll_select_copy_remaining(&end_time, tsp, PT_TIMESPEC, ret);
@@ -1125,7 +1127,7 @@ SYSCALL_DEFINE5(ppoll_time32, struct pollfd __user *, ufds, unsigned int, nfds,
 {
 	sigset_t ksigmask, sigsaved;
 	struct timespec64 ts, end_time, *to = NULL;
-	int ret;
+	int ret, signal_detected;
 
 	if (tsp) {
 		if (get_old_timespec32(&ts, tsp))
@@ -1142,10 +1144,10 @@ SYSCALL_DEFINE5(ppoll_time32, struct pollfd __user *, ufds, unsigned int, nfds,
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	restore_user_sigmask(sigmask, &sigsaved);
+	signal_detected = restore_user_sigmask(sigmask, &sigsaved);
 
 	/* We can restart this syscall, usually */
-	if (ret == -EINTR)
+	if (ret == -EINTR || (signal_detected && !ret))
 		ret = -ERESTARTNOHAND;
 
 	ret = poll_select_copy_remaining(&end_time, tsp, PT_OLD_TIMESPEC, ret);
@@ -1324,7 +1326,7 @@ static long do_compat_pselect(int n, compat_ulong_t __user *inp,
 {
 	sigset_t ksigmask, sigsaved;
 	struct timespec64 ts, end_time, *to = NULL;
-	int ret;
+	int ret, signal_detected;
 
 	if (tsp) {
 		switch (type) {
@@ -1352,7 +1354,10 @@ static long do_compat_pselect(int n, compat_ulong_t __user *inp,
 	ret = compat_core_sys_select(n, inp, outp, exp, to);
 	ret = poll_select_copy_remaining(&end_time, tsp, type, ret);
 
-	restore_user_sigmask(sigmask, &sigsaved);
+	signal_detected = restore_user_sigmask(sigmask, &sigsaved);
+
+	if (signal_detected && !ret)
+		ret = -EINTR;
 
 	return ret;
 }
@@ -1408,7 +1413,7 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time32, struct pollfd __user *, ufds,
 {
 	sigset_t ksigmask, sigsaved;
 	struct timespec64 ts, end_time, *to = NULL;
-	int ret;
+	int ret, signal_detected;
 
 	if (tsp) {
 		if (get_old_timespec32(&ts, tsp))
@@ -1425,10 +1430,10 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time32, struct pollfd __user *, ufds,
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	restore_user_sigmask(sigmask, &sigsaved);
+	signal_detected = restore_user_sigmask(sigmask, &sigsaved);
 
 	/* We can restart this syscall, usually */
-	if (ret == -EINTR)
+	if (ret == -EINTR || (signal_detected && !ret))
 		ret = -ERESTARTNOHAND;
 
 	ret = poll_select_copy_remaining(&end_time, tsp, PT_OLD_TIMESPEC, ret);
@@ -1444,7 +1449,7 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time64, struct pollfd __user *, ufds,
 {
 	sigset_t ksigmask, sigsaved;
 	struct timespec64 ts, end_time, *to = NULL;
-	int ret;
+	int ret, signal_detected;
 
 	if (tsp) {
 		if (get_timespec64(&ts, tsp))
@@ -1461,10 +1466,10 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time64, struct pollfd __user *, ufds,
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	restore_user_sigmask(sigmask, &sigsaved);
+	signal_detected = restore_user_sigmask(sigmask, &sigsaved);
 
 	/* We can restart this syscall, usually */
-	if (ret == -EINTR)
+	if (ret == -EINTR || (signal_detected && !ret))
 		ret = -ERESTARTNOHAND;
 
 	ret = poll_select_copy_remaining(&end_time, tsp, PT_TIMESPEC, ret);
diff --git a/include/linux/signal.h b/include/linux/signal.h
index 9702016734b1..1d36e8629edf 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -275,7 +275,7 @@ extern int __group_send_sig_info(int, struct kernel_siginfo *, struct task_struc
 extern int sigprocmask(int, sigset_t *, sigset_t *);
 extern int set_user_sigmask(const sigset_t __user *usigmask, sigset_t *set,
 	sigset_t *oldset, size_t sigsetsize);
-extern void restore_user_sigmask(const void __user *usigmask,
+extern int restore_user_sigmask(const void __user *usigmask,
 				 sigset_t *sigsaved);
 extern void set_current_blocked(sigset_t *);
 extern void __set_current_blocked(const sigset_t *);
diff --git a/kernel/signal.c b/kernel/signal.c
index 1c86b78a7597..7cc33d23ee4b 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2916,15 +2916,21 @@ EXPORT_SYMBOL(set_compat_user_sigmask);
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
@@ -2933,7 +2939,7 @@ void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved)
 	if (signal_pending(current)) {
 		current->saved_sigmask = *sigsaved;
 		set_restore_sigmask();
-		return;
+		return 1;
 	}
 
 	/*
@@ -2941,6 +2947,7 @@ void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved)
 	 * saved_sigmask when signals are not pending.
 	 */
 	set_current_blocked(sigsaved);
+	return 0;
 }
 EXPORT_SYMBOL(restore_user_sigmask);
 
-- 
2.17.1

