Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6F831380C
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbhBHPgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:36:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:38212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233860AbhBHPaz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:30:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CC7A64EC8;
        Mon,  8 Feb 2021 15:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797428;
        bh=J4yZN4Vk7rqwCa3zYrhT73XisXw2Ex/gCvHQ1SsPsvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ydkWPVzvCmCnfFYwV9V8jXGpIE+SkLK0mImqCE8dGYS+yoL4PmObvEvmJuIWqguBl
         2BIKUQigwIB578vng/OJCXgwIhoCmj1Ga7WqqBHlGIw7h/lYvFI3TA3y5p6WDWp9dc
         Sl05fMBNHYt2ejsybZ7YeuEMYDPTtP0LhIkdsrMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom de Vries <tdevries@suse.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.10 107/120] x86/debug: Fix DR6 handling
Date:   Mon,  8 Feb 2021 16:01:34 +0100
Message-Id: <20210208145822.648585844@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 9ad22e165994ccb64d85b68499eaef97342c175b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/hw_breakpoint.c |   39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -491,15 +491,12 @@ static int hw_breakpoint_handler(struct
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
@@ -509,28 +506,29 @@ static int hw_breakpoint_handler(struct
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
 
@@ -538,11 +536,10 @@ static int hw_breakpoint_handler(struct
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


