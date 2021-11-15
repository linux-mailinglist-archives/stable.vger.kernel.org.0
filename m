Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E5E4521C5
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345896AbhKPBGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:06:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:44628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245406AbhKOTUa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37FA661BD2;
        Mon, 15 Nov 2021 18:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001231;
        bh=hO7b727CngfcRpWAE/ecy1It6ZEntiZBzdLMSTEj4T8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nt3kLiXiNAyCFhHM2lT784mDOwjdVFOK5YRuLWYKuLLTcQ/1BXpNRqQTvNs1UeKMR
         xsRRMl4AEJ0eg21d1fNCgvs7XCaHWIjWZ4779dVTMaZE6lbVvOH4LADFXJd9fxASWy
         Hrmyo2a/C7UbwL+/cCj7mpSahAzCkURwpW27eKHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Righi <andrea.righi@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.15 111/917] signal: Add SA_IMMUTABLE to ensure forced siganls do not get changed
Date:   Mon, 15 Nov 2021 17:53:26 +0100
Message-Id: <20211115165432.515240362@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit 00b06da29cf9dc633cdba87acd3f57f4df3fd5c7 upstream.

As Andy pointed out that there are races between
force_sig_info_to_task and sigaction[1] when force_sig_info_task.  As
Kees discovered[2] ptrace is also able to change these signals.

In the case of seeccomp killing a process with a signal it is a
security violation to allow the signal to be caught or manipulated.

Solve this problem by introducing a new flag SA_IMMUTABLE that
prevents sigaction and ptrace from modifying these forced signals.
This flag is carefully made kernel internal so that no new ABI is
introduced.

Longer term I think this can be solved by guaranteeing short circuit
delivery of signals in this case.  Unfortunately reliable and
guaranteed short circuit delivery of these signals is still a ways off
from being implemented, tested, and merged.  So I have implemented a much
simpler alternative for now.

[1] https://lkml.kernel.org/r/b5d52d25-7bde-4030-a7b1-7c6f8ab90660@www.fastmail.com
[2] https://lkml.kernel.org/r/202110281136.5CE65399A7@keescook
Cc: stable@vger.kernel.org
Fixes: 307d522f5eb8 ("signal/seccomp: Refactor seccomp signal and coredump generation")
Tested-by: Andrea Righi <andrea.righi@canonical.com>
Tested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/signal_types.h           |    3 +++
 include/uapi/asm-generic/signal-defs.h |    1 +
 kernel/signal.c                        |    8 +++++++-
 3 files changed, 11 insertions(+), 1 deletion(-)

--- a/include/linux/signal_types.h
+++ b/include/linux/signal_types.h
@@ -70,6 +70,9 @@ struct ksignal {
 	int sig;
 };
 
+/* Used to kill the race between sigaction and forced signals */
+#define SA_IMMUTABLE		0x00800000
+
 #ifndef __ARCH_UAPI_SA_FLAGS
 #ifdef SA_RESTORER
 #define __ARCH_UAPI_SA_FLAGS	SA_RESTORER
--- a/include/uapi/asm-generic/signal-defs.h
+++ b/include/uapi/asm-generic/signal-defs.h
@@ -45,6 +45,7 @@
 #define SA_UNSUPPORTED	0x00000400
 #define SA_EXPOSE_TAGBITS	0x00000800
 /* 0x00010000 used on mips */
+/* 0x00800000 used for internal SA_IMMUTABLE */
 /* 0x01000000 used on x86 */
 /* 0x02000000 used on x86 */
 /*
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1323,6 +1323,7 @@ force_sig_info_to_task(struct kernel_sig
 	blocked = sigismember(&t->blocked, sig);
 	if (blocked || ignored || sigdfl) {
 		action->sa.sa_handler = SIG_DFL;
+		action->sa.sa_flags |= SA_IMMUTABLE;
 		if (blocked) {
 			sigdelset(&t->blocked, sig);
 			recalc_sigpending_and_wake(t);
@@ -2729,7 +2730,8 @@ relock:
 		if (!signr)
 			break; /* will return 0 */
 
-		if (unlikely(current->ptrace) && signr != SIGKILL) {
+		if (unlikely(current->ptrace) && (signr != SIGKILL) &&
+		    !(sighand->action[signr -1].sa.sa_flags & SA_IMMUTABLE)) {
 			signr = ptrace_signal(signr, &ksig->info);
 			if (!signr)
 				continue;
@@ -4079,6 +4081,10 @@ int do_sigaction(int sig, struct k_sigac
 	k = &p->sighand->action[sig-1];
 
 	spin_lock_irq(&p->sighand->siglock);
+	if (k->sa.sa_flags & SA_IMMUTABLE) {
+		spin_unlock_irq(&p->sighand->siglock);
+		return -EINVAL;
+	}
 	if (oact)
 		*oact = *k;
 


