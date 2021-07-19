Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8B73CE3D4
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235900AbhGSPko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239374AbhGSPeS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:34:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EEE2610D2;
        Mon, 19 Jul 2021 16:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711078;
        bh=Pl8cp7jRomLnKLuKhWza8TFWetl7gldRVpk+enwgbMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ticHigCajxf2Ip5XjFr/Ejv/NYDg2uRsTYdv49Ar+g3KdCJKHf9F7MsVTFv8mW9oz
         Dpag9HlhictJXjw+NRLLDDgpKTU76+S0D5BmNThZjwUve45fgBFXtl5kcxeiM+6L4W
         KmQQbK72/kDqMjDxFL1oc+5lbdEQd4zLkWre9RLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Weimer <fweimer@redhat.com>,
        Jann Horn <jannh@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Borislav Petkov <bp@suse.de>, Len Brown <len.brown@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 202/351] x86/signal: Detect and prevent an alternate signal stack overflow
Date:   Mon, 19 Jul 2021 16:52:28 +0200
Message-Id: <20210719144951.644260709@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chang S. Bae <chang.seok.bae@intel.com>

[ Upstream commit 2beb4a53fc3f1081cedc1c1a198c7f56cc4fc60c ]

The kernel pushes context on to the userspace stack to prepare for the
user's signal handler. When the user has supplied an alternate signal
stack, via sigaltstack(2), it is easy for the kernel to verify that the
stack size is sufficient for the current hardware context.

Check if writing the hardware context to the alternate stack will exceed
it's size. If yes, then instead of corrupting user-data and proceeding with
the original signal handler, an immediate SIGSEGV signal is delivered.

Refactor the stack pointer check code from on_sig_stack() and use the new
helper.

While the kernel allows new source code to discover and use a sufficient
alternate signal stack size, this check is still necessary to protect
binaries with insufficient alternate signal stack size from data
corruption.

Fixes: c2bc11f10a39 ("x86, AVX-512: Enable AVX-512 States Context Switch")
Reported-by: Florian Weimer <fweimer@redhat.com>
Suggested-by: Jann Horn <jannh@google.com>
Suggested-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Len Brown <len.brown@intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20210518200320.17239-6-chang.seok.bae@intel.com
Link: https://bugzilla.kernel.org/show_bug.cgi?id=153531
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/signal.c     | 24 ++++++++++++++++++++----
 include/linux/sched/signal.h | 19 ++++++++++++-------
 2 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index a06cb107c0e8..ca3ab89be5cc 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -234,10 +234,11 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 	     void __user **fpstate)
 {
 	/* Default to using normal stack */
+	bool nested_altstack = on_sig_stack(regs->sp);
+	bool entering_altstack = false;
 	unsigned long math_size = 0;
 	unsigned long sp = regs->sp;
 	unsigned long buf_fx = 0;
-	int onsigstack = on_sig_stack(sp);
 	int ret;
 
 	/* redzone */
@@ -246,15 +247,23 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 
 	/* This is the X/Open sanctioned signal stack switching.  */
 	if (ka->sa.sa_flags & SA_ONSTACK) {
-		if (sas_ss_flags(sp) == 0)
+		/*
+		 * This checks nested_altstack via sas_ss_flags(). Sensible
+		 * programs use SS_AUTODISARM, which disables that check, and
+		 * programs that don't use SS_AUTODISARM get compatible.
+		 */
+		if (sas_ss_flags(sp) == 0) {
 			sp = current->sas_ss_sp + current->sas_ss_size;
+			entering_altstack = true;
+		}
 	} else if (IS_ENABLED(CONFIG_X86_32) &&
-		   !onsigstack &&
+		   !nested_altstack &&
 		   regs->ss != __USER_DS &&
 		   !(ka->sa.sa_flags & SA_RESTORER) &&
 		   ka->sa.sa_restorer) {
 		/* This is the legacy signal stack switching. */
 		sp = (unsigned long) ka->sa.sa_restorer;
+		entering_altstack = true;
 	}
 
 	sp = fpu__alloc_mathframe(sp, IS_ENABLED(CONFIG_X86_32),
@@ -267,8 +276,15 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 	 * If we are on the alternate signal stack and would overflow it, don't.
 	 * Return an always-bogus address instead so we will die with SIGSEGV.
 	 */
-	if (onsigstack && !likely(on_sig_stack(sp)))
+	if (unlikely((nested_altstack || entering_altstack) &&
+		     !__on_sig_stack(sp))) {
+
+		if (show_unhandled_signals && printk_ratelimit())
+			pr_info("%s[%d] overflowed sigaltstack\n",
+				current->comm, task_pid_nr(current));
+
 		return (void __user *)-1L;
+	}
 
 	/* save i387 and extended state */
 	ret = copy_fpstate_to_sigframe(*fpstate, (void __user *)buf_fx, math_size);
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 7f4278fa21fe..0d7fec79d28f 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -538,6 +538,17 @@ static inline int kill_cad_pid(int sig, int priv)
 #define SEND_SIG_NOINFO ((struct kernel_siginfo *) 0)
 #define SEND_SIG_PRIV	((struct kernel_siginfo *) 1)
 
+static inline int __on_sig_stack(unsigned long sp)
+{
+#ifdef CONFIG_STACK_GROWSUP
+	return sp >= current->sas_ss_sp &&
+		sp - current->sas_ss_sp < current->sas_ss_size;
+#else
+	return sp > current->sas_ss_sp &&
+		sp - current->sas_ss_sp <= current->sas_ss_size;
+#endif
+}
+
 /*
  * True if we are on the alternate signal stack.
  */
@@ -555,13 +566,7 @@ static inline int on_sig_stack(unsigned long sp)
 	if (current->sas_ss_flags & SS_AUTODISARM)
 		return 0;
 
-#ifdef CONFIG_STACK_GROWSUP
-	return sp >= current->sas_ss_sp &&
-		sp - current->sas_ss_sp < current->sas_ss_size;
-#else
-	return sp > current->sas_ss_sp &&
-		sp - current->sas_ss_sp <= current->sas_ss_size;
-#endif
+	return __on_sig_stack(sp);
 }
 
 static inline int sas_ss_flags(unsigned long sp)
-- 
2.30.2



