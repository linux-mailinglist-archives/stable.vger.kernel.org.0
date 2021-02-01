Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0001D30AA8B
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 16:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbhBAPIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 10:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbhBAPGr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 10:06:47 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB00C061573;
        Mon,  1 Feb 2021 06:56:35 -0800 (PST)
Date:   Mon, 01 Feb 2021 14:56:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1612191391;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mBvRYf8ghUpAX/hQt85pG8vGXvaOvOBz5RhndbXyuIY=;
        b=gEaQYhOJCq50gCHjFjjrk3ilMsoNH1XnEznaCT6JGSfYT7RgiKFIklXg5Cj2F03qXAn4J2
        rASmWwxDDFPfOfpiogMnHd9W3ZIfECgfOXaZI6E5LdwGA022CU4km8JV5BXvystUGEpiZj
        jggSgdAMUwX6KulCqpURuUGp48kM9FJAKv7561tLrpb8e6pRmZM4HNkOkm0cElboApuf58
        Xx67qnawOD1Rnc1jQAUIBt7mNPJ2ExIrJuBPwVyGElcfcz3QgFE9bbm+sQ7L8+oYZimt7Z
        kutdjnIs6ROmsurf90pTAyyfJWDmkSWSkC+P0mqNwkQafsri2nSdHkIflAolEg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1612191391;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mBvRYf8ghUpAX/hQt85pG8vGXvaOvOBz5RhndbXyuIY=;
        b=oz/T+0RxiRMw4PtEgFQ3DAvy9oxXbRFz5UMtcuz7lsxwZ4ptldxlRi9+LfJvhj4hfJKvcQ
        s1qShodRZ1itYOCQ==
From:   "tip-bot2 for Peter Zijlstra" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/debug: Fix DR6 handling
Cc:     Tom de Vries <tdevries@suse.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <YBMAbQGACujjfz%2Bi@hirez.programming.kicks-ass.net>
References: <YBMAbQGACujjfz%2Bi@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Message-ID: <161219139027.23325.9791858719126543800.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     9ad22e165994ccb64d85b68499eaef97342c175b
Gitweb:        https://git.kernel.org/tip/9ad22e165994ccb64d85b68499eaef97342c175b
Author:        Peter Zijlstra <peterz@infradead.org>
AuthorDate:    Thu, 28 Jan 2021 22:16:27 +01:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Mon, 01 Feb 2021 15:49:02 +01:00

x86/debug: Fix DR6 handling

Tom reported that one of the GDB test-cases failed, and Boris bisected
it to commit:

  d53d9bc0cf78 ("x86/debug: Change thread.debugreg6 to thread.virtual_dr6")

The debugging session led us to commit:

  6c0aca288e72 ("x86: Ignore trap bits on single step exceptions")

It turns out that TF and data breakpoints are both traps and will be
merged, while instruction breakpoints are faults and will not be merged.
This means 6c0aca288e72 is wrong, only TF and instruction breakpoints
need to be excluded while TF and data breakpoints can be merged.

 [ bp: Massage commit message. ]

Fixes: d53d9bc0cf78 ("x86/debug: Change thread.debugreg6 to thread.virtual_dr6")
Fixes: 6c0aca288e72 ("x86: Ignore trap bits on single step exceptions")
Reported-by: Tom de Vries <tdevries@suse.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/YBMAbQGACujjfz%2Bi@hirez.programming.kicks-ass.net
Link: https://lkml.kernel.org/r/20210128211627.GB4348@worktop.programming.kicks-ass.net
---
 arch/x86/kernel/hw_breakpoint.c | 39 ++++++++++++++------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 03aa33b..6694c0f 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -491,15 +491,12 @@ static int hw_breakpoint_handler(struct die_args *args)
 	struct perf_event *bp;
 	unsigned long *dr6_p;
 	unsigned long dr6;
+	bool bpx;
 
 	/* The DR6 value is pointed by args->err */
 	dr6_p = (unsigned long *)ERR_PTR(args->err);
 	dr6 = *dr6_p;
 
-	/* If it's a single step, TRAP bits are random */
-	if (dr6 & DR_STEP)
-		return NOTIFY_DONE;
-
 	/* Do an early return if no trap bits are set in DR6 */
 	if ((dr6 & DR_TRAP_BITS) == 0)
 		return NOTIFY_DONE;
@@ -509,28 +506,29 @@ static int hw_breakpoint_handler(struct die_args *args)
 		if (likely(!(dr6 & (DR_TRAP0 << i))))
 			continue;
 
+		bp = this_cpu_read(bp_per_reg[i]);
+		if (!bp)
+			continue;
+
+		bpx = bp->hw.info.type == X86_BREAKPOINT_EXECUTE;
+
 		/*
-		 * The counter may be concurrently released but that can only
-		 * occur from a call_rcu() path. We can then safely fetch
-		 * the breakpoint, use its callback, touch its counter
-		 * while we are in an rcu_read_lock() path.
+		 * TF and data breakpoints are traps and can be merged, however
+		 * instruction breakpoints are faults and will be raised
+		 * separately.
+		 *
+		 * However DR6 can indicate both TF and instruction
+		 * breakpoints. In that case take TF as that has precedence and
+		 * delay the instruction breakpoint for the next exception.
 		 */
-		rcu_read_lock();
+		if (bpx && (dr6 & DR_STEP))
+			continue;
 
-		bp = this_cpu_read(bp_per_reg[i]);
 		/*
 		 * Reset the 'i'th TRAP bit in dr6 to denote completion of
 		 * exception handling
 		 */
 		(*dr6_p) &= ~(DR_TRAP0 << i);
-		/*
-		 * bp can be NULL due to lazy debug register switching
-		 * or due to concurrent perf counter removing.
-		 */
-		if (!bp) {
-			rcu_read_unlock();
-			break;
-		}
 
 		perf_bp_event(bp, args->regs);
 
@@ -538,11 +536,10 @@ static int hw_breakpoint_handler(struct die_args *args)
 		 * Set up resume flag to avoid breakpoint recursion when
 		 * returning back to origin.
 		 */
-		if (bp->hw.info.type == X86_BREAKPOINT_EXECUTE)
+		if (bpx)
 			args->regs->flags |= X86_EFLAGS_RF;
-
-		rcu_read_unlock();
 	}
+
 	/*
 	 * Further processing in do_debug() is needed for a) user-space
 	 * breakpoints (to generate signals) and b) when the system has
