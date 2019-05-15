Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93A7C1F1B5
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfEOLRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:17:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730641AbfEOLRP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:17:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7445920644;
        Wed, 15 May 2019 11:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919034;
        bh=xFiCKmtsOvgoT4wK1Uqxsoxvd2pdKj+Zjdqq4SnKHgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LO/beIkktyGom5i/y9W4mkJMx+PgeSCqk9+r3VeE5bIjqhWHr0cOPSSi1tRFmLwac
         KoEPW9okYpvYP6xjotdSRcfuUq2rNhXe1y7eFh5y8LClwdFYYMiPezf4XUCr4VLPwz
         vT7vdrp7VijHkGEaIOG6ibBNMgvZ79EUWQGShd8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 041/115] sparc64: Make corrupted user stacks more debuggable.
Date:   Wed, 15 May 2019 12:55:21 +0200
Message-Id: <20190515090702.483620383@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5b4fc3882a649c9411dd0dcad2ddb78e911d340e ]

Right now if we get a corrupted user stack frame we do a
do_exit(SIGILL) which is not helpful.

If under a debugger, this behavior causes the inferior process to
exit.  So the register and other state cannot be examined at the time
of the event.

Instead, conditionally log a rate limited kernel log message and then
force a SIGSEGV.

With bits and ideas borrowed (as usual) from powerpc.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 arch/sparc/include/asm/switch_to_64.h |  3 ++-
 arch/sparc/kernel/process_64.c        | 25 +++++++++++++++++++------
 arch/sparc/kernel/rtrap_64.S          |  1 +
 arch/sparc/kernel/signal32.c          | 12 ++++++++++--
 arch/sparc/kernel/signal_64.c         |  6 +++++-
 5 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/arch/sparc/include/asm/switch_to_64.h b/arch/sparc/include/asm/switch_to_64.h
index 4ff29b1406a9b..b1d4e2e3210fb 100644
--- a/arch/sparc/include/asm/switch_to_64.h
+++ b/arch/sparc/include/asm/switch_to_64.h
@@ -67,6 +67,7 @@ do {	save_and_clear_fpu();						\
 } while(0)
 
 void synchronize_user_stack(void);
-void fault_in_user_windows(void);
+struct pt_regs;
+void fault_in_user_windows(struct pt_regs *);
 
 #endif /* __SPARC64_SWITCH_TO_64_H */
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index 318efd784a0b3..5640131e2abf3 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -36,6 +36,7 @@
 #include <linux/sysrq.h>
 #include <linux/nmi.h>
 #include <linux/context_tracking.h>
+#include <linux/signal.h>
 
 #include <linux/uaccess.h>
 #include <asm/page.h>
@@ -528,7 +529,12 @@ static void stack_unaligned(unsigned long sp)
 	force_sig_info(SIGBUS, &info, current);
 }
 
-void fault_in_user_windows(void)
+static const char uwfault32[] = KERN_INFO \
+	"%s[%d]: bad register window fault: SP %08lx (orig_sp %08lx) TPC %08lx O7 %08lx\n";
+static const char uwfault64[] = KERN_INFO \
+	"%s[%d]: bad register window fault: SP %016lx (orig_sp %016lx) TPC %08lx O7 %016lx\n";
+
+void fault_in_user_windows(struct pt_regs *regs)
 {
 	struct thread_info *t = current_thread_info();
 	unsigned long window;
@@ -541,9 +547,9 @@ void fault_in_user_windows(void)
 		do {
 			struct reg_window *rwin = &t->reg_window[window];
 			int winsize = sizeof(struct reg_window);
-			unsigned long sp;
+			unsigned long sp, orig_sp;
 
-			sp = t->rwbuf_stkptrs[window];
+			orig_sp = sp = t->rwbuf_stkptrs[window];
 
 			if (test_thread_64bit_stack(sp))
 				sp += STACK_BIAS;
@@ -554,8 +560,16 @@ void fault_in_user_windows(void)
 				stack_unaligned(sp);
 
 			if (unlikely(copy_to_user((char __user *)sp,
-						  rwin, winsize)))
+						  rwin, winsize))) {
+				if (show_unhandled_signals)
+					printk_ratelimited(is_compat_task() ?
+							   uwfault32 : uwfault64,
+							   current->comm, current->pid,
+							   sp, orig_sp,
+							   regs->tpc,
+							   regs->u_regs[UREG_I7]);
 				goto barf;
+			}
 		} while (window--);
 	}
 	set_thread_wsaved(0);
@@ -563,8 +577,7 @@ void fault_in_user_windows(void)
 
 barf:
 	set_thread_wsaved(window + 1);
-	user_exit();
-	do_exit(SIGILL);
+	force_sig(SIGSEGV, current);
 }
 
 asmlinkage long sparc_do_fork(unsigned long clone_flags,
diff --git a/arch/sparc/kernel/rtrap_64.S b/arch/sparc/kernel/rtrap_64.S
index 0b21042ab181b..ad88d60bb740c 100644
--- a/arch/sparc/kernel/rtrap_64.S
+++ b/arch/sparc/kernel/rtrap_64.S
@@ -30,6 +30,7 @@ __handle_preemption:
 		 wrpr			%g0, RTRAP_PSTATE_IRQOFF, %pstate
 
 __handle_user_windows:
+		add			%sp, PTREGS_OFF, %o0
 		call			fault_in_user_windows
 		 wrpr			%g0, RTRAP_PSTATE, %pstate
 		ba,pt			%xcc, __handle_preemption_continue
diff --git a/arch/sparc/kernel/signal32.c b/arch/sparc/kernel/signal32.c
index 5c572de64c748..879f8d86bc21c 100644
--- a/arch/sparc/kernel/signal32.c
+++ b/arch/sparc/kernel/signal32.c
@@ -442,7 +442,11 @@ static int setup_frame32(struct ksignal *ksig, struct pt_regs *regs,
 		get_sigframe(ksig, regs, sigframe_size);
 	
 	if (invalid_frame_pointer(sf, sigframe_size)) {
-		do_exit(SIGILL);
+		if (show_unhandled_signals)
+			pr_info("%s[%d] bad frame in setup_frame32: %08lx TPC %08lx O7 %08lx\n",
+				current->comm, current->pid, (unsigned long)sf,
+				regs->tpc, regs->u_regs[UREG_I7]);
+		force_sigsegv(ksig->sig, current);
 		return -EINVAL;
 	}
 
@@ -573,7 +577,11 @@ static int setup_rt_frame32(struct ksignal *ksig, struct pt_regs *regs,
 		get_sigframe(ksig, regs, sigframe_size);
 	
 	if (invalid_frame_pointer(sf, sigframe_size)) {
-		do_exit(SIGILL);
+		if (show_unhandled_signals)
+			pr_info("%s[%d] bad frame in setup_rt_frame32: %08lx TPC %08lx O7 %08lx\n",
+				current->comm, current->pid, (unsigned long)sf,
+				regs->tpc, regs->u_regs[UREG_I7]);
+		force_sigsegv(ksig->sig, current);
 		return -EINVAL;
 	}
 
diff --git a/arch/sparc/kernel/signal_64.c b/arch/sparc/kernel/signal_64.c
index 20426a1c28f29..2d0a50bde3f96 100644
--- a/arch/sparc/kernel/signal_64.c
+++ b/arch/sparc/kernel/signal_64.c
@@ -373,7 +373,11 @@ setup_rt_frame(struct ksignal *ksig, struct pt_regs *regs)
 		get_sigframe(ksig, regs, sf_size);
 
 	if (invalid_frame_pointer (sf)) {
-		do_exit(SIGILL);	/* won't return, actually */
+		if (show_unhandled_signals)
+			pr_info("%s[%d] bad frame in setup_rt_frame: %016lx TPC %016lx O7 %016lx\n",
+				current->comm, current->pid, (unsigned long)sf,
+				regs->tpc, regs->u_regs[UREG_I7]);
+		force_sigsegv(ksig->sig, current);
 		return -EINVAL;
 	}
 
-- 
2.20.1



