Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F4225D968
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 15:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730380AbgIDNQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 09:16:30 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:32966 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730010AbgIDNQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Sep 2020 09:16:09 -0400
Date:   Fri, 04 Sep 2020 13:16:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1599225365;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Es7kHZK0Eo28IQNSUBBHHsbtPlWNGr7Tpf2tIcQxS0g=;
        b=iDTziRLhAIkeFq6bQ3kBttmY9QeeQJrgclBK5Wjg1ypgUfkMupnggjpKFsAYuAfpFcfIrO
        6HjKhXnvzVfYVcSV+Y6iL+GLVWg62GLnMWjtPngFIlwZr7btegLsBpNRBPJrrEtvOiXlhG
        N+WMjk6EWy09FvE3VfzSlYHqzEsXO0ez86N58cWerkRJ/mcL1Di2QSc1H8Nb9SLBD8Z7t3
        lf7J4GFsuXp4XpZso9jNlMgELGZuPHB3Y3igvJ6fDz0AvuwCd0U0uLdH27JwT7PB77zC2E
        VIrPRfL8yTVCp2MNzDmhOydxa46DPoiKF5pWUgZE9u4dUI8exIU5XMTic24zbg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1599225365;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Es7kHZK0Eo28IQNSUBBHHsbtPlWNGr7Tpf2tIcQxS0g=;
        b=0DxZEIYhbXNL5g0BzoNNIuhW2QT7gTY2CjdRX8+gZhdTjXmpw/densJ6mK+QhkE/QuSlFX
        w1EHXJ5148I8OLDA==
From:   "tip-bot2 for Andy Lutomirski" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/debug: Allow a single level of #DB recursion
Cc:     Kyle Huey <me@kylehuey.com>, Andy Lutomirski <luto@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        stable@vger.kernel.org, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <8b9bd05f187231df008d48cf818a6a311cbd5c98.1597882384.git.luto@kernel.org>
References: <8b9bd05f187231df008d48cf818a6a311cbd5c98.1597882384.git.luto@kernel.org>
MIME-Version: 1.0
Message-ID: <159922536430.20229.12103217775800419498.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     d5c678aed5eddb944b8e7ce451b107b39245962d
Gitweb:        https://git.kernel.org/tip/d5c678aed5eddb944b8e7ce451b107b39245962d
Author:        Andy Lutomirski <luto@kernel.org>
AuthorDate:    Wed, 02 Sep 2020 15:25:51 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Fri, 04 Sep 2020 15:09:29 +02:00

x86/debug: Allow a single level of #DB recursion

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

---
 arch/x86/kernel/traps.c | 65 +++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 1f66d2d..81a2fb7 100644
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
@@ -755,15 +744,12 @@ static __always_inline void debug_enter(unsigned long *dr6, unsigned long *dr7)
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
@@ -863,6 +849,18 @@ out:
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
 	bool irq_state = idtentry_enter_nmi(regs);
 	instrumentation_begin();
 
@@ -883,6 +881,8 @@ static __always_inline void exc_debug_kernel(struct pt_regs *regs,
 
 	instrumentation_end();
 	idtentry_exit_nmi(regs, irq_state);
+
+	local_db_restore(dr7);
 }
 
 static __always_inline void exc_debug_user(struct pt_regs *regs,
@@ -894,6 +894,15 @@ static __always_inline void exc_debug_user(struct pt_regs *regs,
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
 
@@ -907,36 +916,24 @@ static __always_inline void exc_debug_user(struct pt_regs *regs,
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
 
