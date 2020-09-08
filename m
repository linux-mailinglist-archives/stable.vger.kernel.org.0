Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C599726163C
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731831AbgIHRGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:06:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731786AbgIHQTU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:19:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9481524198;
        Tue,  8 Sep 2020 15:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579539;
        bh=3NIQKpGrIJmYovO0SrwS3UNQX7Lij3S5tXy78o/NcTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e4VQrO5i3Qk8uEZZfz5Y/3h1d/ndgLyGTnKvU9EPiVsyPnFRQTuqK80vnirCC9JfR
         3gU8KR3BbAPFeBNJOj0+WjDoj2w5ADslhGyq7TuhlaXjXcAjSMzYmBrUb2SV1J5SoI
         F5NE6uVz4s7usE16ePMDW9MSmd1Tyx1u3fObYrdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kyle Huey <me@kylehuey.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH 5.8 120/186] x86/debug: Allow a single level of #DB recursion
Date:   Tue,  8 Sep 2020 17:24:22 +0200
Message-Id: <20200908152247.452358994@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

commit d5c678aed5eddb944b8e7ce451b107b39245962d upstream.

Trying to clear DR7 around a #DB from usermode malfunctions if the tasks
schedules when delivering SIGTRAP.

Rather than trying to define a special no-recursion region, just allow a
single level of recursion.  The same mechanism is used for NMI, and it
hasn't caused any problems yet.

Fixes: 9f58fdde95c9 ("x86/db: Split out dr6/7 handling")
Reported-by: Kyle Huey <me@kylehuey.com>
Debugged-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/8b9bd05f187231df008d48cf818a6a311cbd5c98.1597882384.git.luto@kernel.org
Link: https://lore.kernel.org/r/20200902133200.726584153@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/traps.c |   66 +++++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 34 deletions(-)

--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -733,20 +733,9 @@ static bool is_sysenter_singlestep(struc
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
@@ -759,15 +748,12 @@ static __always_inline void debug_enter(
 	 *
 	 * Keep it simple: clear DR6 immediately.
 	 */
-	get_debugreg(*dr6, 6);
+	get_debugreg(dr6, 6);
 	set_debugreg(0, 6);
 	/* Filter out all the reserved bits which are preset to 1 */
-	*dr6 &= ~DR6_RESERVED;
-}
+	dr6 &= ~DR6_RESERVED;
 
-static __always_inline void debug_exit(unsigned long dr7)
-{
-	local_db_restore(dr7);
+	return dr6;
 }
 
 /*
@@ -867,6 +853,19 @@ out:
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
 	nmi_enter();
 	instrumentation_begin();
 	trace_hardirqs_off_finish();
@@ -890,6 +889,8 @@ static __always_inline void exc_debug_ke
 		trace_hardirqs_on_prepare();
 	instrumentation_end();
 	nmi_exit();
+
+	local_db_restore(dr7);
 }
 
 static __always_inline void exc_debug_user(struct pt_regs *regs,
@@ -901,6 +902,15 @@ static __always_inline void exc_debug_us
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
 	idtentry_enter_user(regs);
 	instrumentation_begin();
 
@@ -913,36 +923,24 @@ static __always_inline void exc_debug_us
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
 


