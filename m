Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF5A24ABF9
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 02:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgHTAPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 20:15:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726786AbgHTAPq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 20:15:46 -0400
Received: from localhost (c-67-180-165-146.hsd1.ca.comcast.net [67.180.165.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76FA8207DA;
        Thu, 20 Aug 2020 00:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597882545;
        bh=sk+S3Fr21tKJgcwY1YXzpsiM/9GAWEGKg/lYjMSui+4=;
        h=From:To:Cc:Subject:Date:From;
        b=1l7z5wvibXgXvTSEJvgDjsKkdtIW7G0UBv7pTYBqzxxj0CAReCzMLu3M/pIJ1cFlQ
         c8iZM5tGhGTSPgSKrQUN4czMkXQkCCGhh0tJZxhic+A3M8iSLQN1U/sqCnsE1u19Mp
         Ha4qbTBTnGr7DI4byNKS8SSMTZEOk4rxczFlCBgo=
From:   Andy Lutomirski <luto@kernel.org>
To:     x86@kernel.org
Cc:     Kyle Huey <me@kylehuey.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Robert O'Callahan <rocallahan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Brian Gerst <brgerst@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Will Deacon <will@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] x86/debug: Allow a single level of #DB recursion
Date:   Wed, 19 Aug 2020 17:15:43 -0700
Message-Id: <8b9bd05f187231df008d48cf818a6a311cbd5c98.1597882384.git.luto@kernel.org>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Trying to clear DR7 around a #DB from usermode malfunctions if we
schedule when delivering SIGTRAP.  Rather than trying to define a
special no-recursion region, just allow a single level of recursion.
We do the same thing for NMI, and it hasn't caused any problems yet.

Reported-by: Kyle Huey <me@kylehuey.com>
Debugged-by: Josh Poimboeuf <jpoimboe@redhat.com>
Fixes: 9f58fdde95c9 ("x86/db: Split out dr6/7 handling")
Cc: stable@vger.kernel.org
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/kernel/traps.c | 69 +++++++++++++++++++++++------------------
 1 file changed, 38 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 1f66d2d1e998..bf852b72f15c 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -729,20 +729,9 @@ static bool is_sysenter_singlestep(struct pt_regs *regs)
 #endif
 }
 
-static __always_inline void debug_enter(unsigned long *dr6, unsigned long *dr7)
+static __always_inline unsigned long debug_read_clear_dr6(void)
 {
-	/*
-	 * Disable breakpoints during exception handling; recursive exceptions
-	 * are exceedingly 'fun'.
-	 *
-	 * Since this function is NOKPROBE, and that also applies to
-	 * HW_BREAKPOINT_X, we can't hit a breakpoint before this (XXX except a
-	 * HW_BREAKPOINT_W on our stack)
-	 *
-	 * Entry text is excluded for HW_BP_X and cpu_entry_area, which
-	 * includes the entry stack is excluded for everything.
-	 */
-	*dr7 = local_db_save();
+	unsigned long dr6;
 
 	/*
 	 * The Intel SDM says:
@@ -755,15 +744,21 @@ static __always_inline void debug_enter(unsigned long *dr6, unsigned long *dr7)
 	 *
 	 * Keep it simple: clear DR6 immediately.
 	 */
-	get_debugreg(*dr6, 6);
+	get_debugreg(dr6, 6);
 	set_debugreg(0, 6);
 	/* Filter out all the reserved bits which are preset to 1 */
-	*dr6 &= ~DR6_RESERVED;
+	dr6 &= ~DR6_RESERVED;
+
+	return dr6;
+}
+
+static __always_inline void debug_enter(unsigned long *dr6, unsigned long *dr7)
+{
+	*dr6 = debug_read_clear_dr6();
 }
 
 static __always_inline void debug_exit(unsigned long dr7)
 {
-	local_db_restore(dr7);
 }
 
 /*
@@ -863,6 +858,19 @@ static void handle_debug(struct pt_regs *regs, unsigned long dr6, bool user)
 static __always_inline void exc_debug_kernel(struct pt_regs *regs,
 					     unsigned long dr6)
 {
+	/*
+	 * Disable breakpoints during exception handling; recursive exceptions
+	 * are exceedingly 'fun'.
+	 *
+	 * Since this function is NOKPROBE, and that also applies to
+	 * HW_BREAKPOINT_X, we can't hit a breakpoint before this (XXX except a
+	 * HW_BREAKPOINT_W on our stack)
+	 *
+	 * Entry text is excluded for HW_BP_X and cpu_entry_area, which
+	 * includes the entry stack is excluded for everything.
+	 */
+	unsigned long dr7 = local_db_save();
+
 	bool irq_state = idtentry_enter_nmi(regs);
 	instrumentation_begin();
 
@@ -883,6 +891,8 @@ static __always_inline void exc_debug_kernel(struct pt_regs *regs,
 
 	instrumentation_end();
 	idtentry_exit_nmi(regs, irq_state);
+
+	local_db_restore(dr7);
 }
 
 static __always_inline void exc_debug_user(struct pt_regs *regs,
@@ -894,6 +904,15 @@ static __always_inline void exc_debug_user(struct pt_regs *regs,
 	 */
 	WARN_ON_ONCE(!user_mode(regs));
 
+	/*
+	 * NB: We can't easily clear DR7 here because
+	 * idtentry_exit_to_usermode() can invoke ptrace, schedule, access
+	 * user memory, etc.  This means that a recursive #DB is possible.  If
+	 * this happens, that #DB will hit exc_debug_kernel() and clear DR7.
+	 * Since we're not on the IST stack right now, everything will be
+	 * fine.
+	 */
+
 	irqentry_enter_from_user_mode(regs);
 	instrumentation_begin();
 
@@ -907,36 +926,24 @@ static __always_inline void exc_debug_user(struct pt_regs *regs,
 /* IST stack entry */
 DEFINE_IDTENTRY_DEBUG(exc_debug)
 {
-	unsigned long dr6, dr7;
-
-	debug_enter(&dr6, &dr7);
-	exc_debug_kernel(regs, dr6);
-	debug_exit(dr7);
+	exc_debug_kernel(regs, debug_read_clear_dr6());
 }
 
 /* User entry, runs on regular task stack */
 DEFINE_IDTENTRY_DEBUG_USER(exc_debug)
 {
-	unsigned long dr6, dr7;
-
-	debug_enter(&dr6, &dr7);
-	exc_debug_user(regs, dr6);
-	debug_exit(dr7);
+	exc_debug_user(regs, debug_read_clear_dr6());
 }
 #else
 /* 32 bit does not have separate entry points. */
 DEFINE_IDTENTRY_RAW(exc_debug)
 {
-	unsigned long dr6, dr7;
-
-	debug_enter(&dr6, &dr7);
+	unsigned long dr6 = debug_read_clear_dr6();
 
 	if (user_mode(regs))
 		exc_debug_user(regs, dr6);
 	else
 		exc_debug_kernel(regs, dr6);
-
-	debug_exit(dr7);
 }
 #endif
 
-- 
2.25.4

