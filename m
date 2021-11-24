Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA9545C698
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354622AbhKXOKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:10:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:53874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351842AbhKXOGu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:06:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 281836112D;
        Wed, 24 Nov 2021 13:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759566;
        bh=xDedo8beySo+qNmph2/CbBjFcLJ1T6T1P0GhonDiygY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z/laL4PfKa4ZfWfi/imhBkQkvVJ/2bgWTIgm4EOfOql0UHA0qZ66iXqobbw5VaXdo
         iiP+XSlPMGpKi5rLkZJJFn1ltOqtGVqS4IGVKDTg6pj6xPBlK5FqPM6OR8snEdJA9M
         5dyCEplVVToi3egrGIN3Fy6Sat6RbswSIJbwbOy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kyle Huey <me@kylehuey.com>,
        kernel test robot <oliver.sang@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Kyle Huey <khuey@kylehuey.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Backlund <tmb@iki.fi>
Subject: [PATCH 5.15 265/279] signal: Dont always set SA_IMMUTABLE for forced signals
Date:   Wed, 24 Nov 2021 12:59:12 +0100
Message-Id: <20211124115727.859050254@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit e349d945fac76bddc78ae1cb92a0145b427a87ce upstream.

Recently to prevent issues with SECCOMP_RET_KILL and similar signals
being changed before they are delivered SA_IMMUTABLE was added.

Unfortunately this broke debuggers[1][2] which reasonably expect to be
able to trap synchronous SIGTRAP and SIGSEGV even when the target
process is not configured to handle those signals.

Update force_sig_to_task to support both the case when we can allow
the debugger to intercept and possibly ignore the signal and the case
when it is not safe to let userspace know about the signal until the
process has exited.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Kyle Huey <me@kylehuey.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Cc: stable@vger.kernel.org
[1] https://lkml.kernel.org/r/CAP045AoMY4xf8aC_4QU_-j7obuEPYgTcnQQP3Yxk=2X90jtpjw@mail.gmail.com
[2] https://lkml.kernel.org/r/20211117150258.GB5403@xsang-OptiPlex-9020
Fixes: 00b06da29cf9 ("signal: Add SA_IMMUTABLE to ensure forced siganls do not get changed")
Link: https://lkml.kernel.org/r/877dd5qfw5.fsf_-_@email.froward.int.ebiederm.org
Reviewed-by: Kees Cook <keescook@chromium.org>
Tested-by: Kees Cook <keescook@chromium.org>
Tested-by: Kyle Huey <khuey@kylehuey.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Backlund <tmb@iki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/signal.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1298,6 +1298,12 @@ int do_send_sig_info(int sig, struct ker
 	return ret;
 }
 
+enum sig_handler {
+	HANDLER_CURRENT, /* If reachable use the current handler */
+	HANDLER_SIG_DFL, /* Always use SIG_DFL handler semantics */
+	HANDLER_EXIT,	 /* Only visible as the process exit code */
+};
+
 /*
  * Force a signal that the process can't ignore: if necessary
  * we unblock the signal and change any SIG_IGN to SIG_DFL.
@@ -1310,7 +1316,8 @@ int do_send_sig_info(int sig, struct ker
  * that is why we also clear SIGNAL_UNKILLABLE.
  */
 static int
-force_sig_info_to_task(struct kernel_siginfo *info, struct task_struct *t, bool sigdfl)
+force_sig_info_to_task(struct kernel_siginfo *info, struct task_struct *t,
+	enum sig_handler handler)
 {
 	unsigned long int flags;
 	int ret, blocked, ignored;
@@ -1321,9 +1328,10 @@ force_sig_info_to_task(struct kernel_sig
 	action = &t->sighand->action[sig-1];
 	ignored = action->sa.sa_handler == SIG_IGN;
 	blocked = sigismember(&t->blocked, sig);
-	if (blocked || ignored || sigdfl) {
+	if (blocked || ignored || (handler != HANDLER_CURRENT)) {
 		action->sa.sa_handler = SIG_DFL;
-		action->sa.sa_flags |= SA_IMMUTABLE;
+		if (handler == HANDLER_EXIT)
+			action->sa.sa_flags |= SA_IMMUTABLE;
 		if (blocked) {
 			sigdelset(&t->blocked, sig);
 			recalc_sigpending_and_wake(t);
@@ -1343,7 +1351,7 @@ force_sig_info_to_task(struct kernel_sig
 
 int force_sig_info(struct kernel_siginfo *info)
 {
-	return force_sig_info_to_task(info, current, false);
+	return force_sig_info_to_task(info, current, HANDLER_CURRENT);
 }
 
 /*
@@ -1660,7 +1668,7 @@ void force_fatal_sig(int sig)
 	info.si_code = SI_KERNEL;
 	info.si_pid = 0;
 	info.si_uid = 0;
-	force_sig_info_to_task(&info, current, true);
+	force_sig_info_to_task(&info, current, HANDLER_SIG_DFL);
 }
 
 /*
@@ -1693,7 +1701,7 @@ int force_sig_fault_to_task(int sig, int
 	info.si_flags = flags;
 	info.si_isr = isr;
 #endif
-	return force_sig_info_to_task(&info, t, false);
+	return force_sig_info_to_task(&info, t, HANDLER_CURRENT);
 }
 
 int force_sig_fault(int sig, int code, void __user *addr
@@ -1813,7 +1821,8 @@ int force_sig_seccomp(int syscall, int r
 	info.si_errno = reason;
 	info.si_arch = syscall_get_arch(current);
 	info.si_syscall = syscall;
-	return force_sig_info_to_task(&info, current, force_coredump);
+	return force_sig_info_to_task(&info, current,
+		force_coredump ? HANDLER_EXIT : HANDLER_CURRENT);
 }
 
 /* For the crazy architectures that include trap information in


