Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B14B14E0C
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbfEFOnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:43:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727165AbfEFOnz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:43:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4895320C01;
        Mon,  6 May 2019 14:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153833;
        bh=Anbqk/0kGfZhabFXywOM8sZ195ri9Pr7rlLUW3zeX7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F3Ik2cqTWl5TAAW15I9JGA+6iSe8NRzDr6/yOm9t6fXT41Nw4ksPZlFmHCKnni2yL
         wmMZxNlggANeT1N00NXGe9Spq9jJDExcG8XK2Wf3TDep5k8HkUIgiNoIGFwg1TEXiS
         l7oBE72UB8bJxbrNJFZruFCfOYyVKrHo57c/zc8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Andrey Konovalov <andreyknvl@google.com>
Subject: [PATCH 4.14 14/75] arm64: Fix single stepping in kernel traps
Date:   Mon,  6 May 2019 16:32:22 +0200
Message-Id: <20190506143054.480275434@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.287515952@linuxfoundation.org>
References: <20190506143053.287515952@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julien Thierry <julien.thierry@arm.com>

commit 6436beeee5721a8e906e9eabf866f12d04470437 upstream.

Software Step exception is missing after stepping a trapped instruction.

Ensure SPSR.SS gets set to 0 after emulating/skipping a trapped instruction
before doing ERET.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
[will: replaced AARCH32_INSN_SIZE with 4]
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/traps.h       |    6 ++++++
 arch/arm64/kernel/armv8_deprecated.c |    8 ++++----
 arch/arm64/kernel/cpufeature.c       |    2 +-
 arch/arm64/kernel/traps.c            |   21 ++++++++++++++++-----
 4 files changed, 27 insertions(+), 10 deletions(-)

--- a/arch/arm64/include/asm/traps.h
+++ b/arch/arm64/include/asm/traps.h
@@ -37,6 +37,12 @@ void unregister_undef_hook(struct undef_
 
 void arm64_notify_segfault(struct pt_regs *regs, unsigned long addr);
 
+/*
+ * Move regs->pc to next instruction and do necessary setup before it
+ * is executed.
+ */
+void arm64_skip_faulting_instruction(struct pt_regs *regs, unsigned long size);
+
 static inline int __in_irqentry_text(unsigned long ptr)
 {
 	return ptr >= (unsigned long)&__irqentry_text_start &&
--- a/arch/arm64/kernel/armv8_deprecated.c
+++ b/arch/arm64/kernel/armv8_deprecated.c
@@ -431,7 +431,7 @@ ret:
 	pr_warn_ratelimited("\"%s\" (%ld) uses obsolete SWP{B} instruction at 0x%llx\n",
 			current->comm, (unsigned long)current->pid, regs->pc);
 
-	regs->pc += 4;
+	arm64_skip_faulting_instruction(regs, 4);
 	return 0;
 
 fault:
@@ -512,7 +512,7 @@ ret:
 	pr_warn_ratelimited("\"%s\" (%ld) uses deprecated CP15 Barrier instruction at 0x%llx\n",
 			current->comm, (unsigned long)current->pid, regs->pc);
 
-	regs->pc += 4;
+	arm64_skip_faulting_instruction(regs, 4);
 	return 0;
 }
 
@@ -586,14 +586,14 @@ static int compat_setend_handler(struct
 static int a32_setend_handler(struct pt_regs *regs, u32 instr)
 {
 	int rc = compat_setend_handler(regs, (instr >> 9) & 1);
-	regs->pc += 4;
+	arm64_skip_faulting_instruction(regs, 4);
 	return rc;
 }
 
 static int t16_setend_handler(struct pt_regs *regs, u32 instr)
 {
 	int rc = compat_setend_handler(regs, (instr >> 3) & 1);
-	regs->pc += 2;
+	arm64_skip_faulting_instruction(regs, 2);
 	return rc;
 }
 
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1398,7 +1398,7 @@ static int emulate_mrs(struct pt_regs *r
 	if (!rc) {
 		dst = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RT, insn);
 		pt_regs_write_reg(regs, dst, val);
-		regs->pc += 4;
+		arm64_skip_faulting_instruction(regs, AARCH64_INSN_SIZE);
 	}
 
 	return rc;
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -296,6 +296,17 @@ void arm64_notify_die(const char *str, s
 	}
 }
 
+void arm64_skip_faulting_instruction(struct pt_regs *regs, unsigned long size)
+{
+	regs->pc += size;
+
+	/*
+	 * If we were single stepping, we want to get the step exception after
+	 * we return from the trap.
+	 */
+	user_fastforward_single_step(current);
+}
+
 static LIST_HEAD(undef_hook);
 static DEFINE_RAW_SPINLOCK(undef_lock);
 
@@ -483,7 +494,7 @@ static void user_cache_maint_handler(uns
 	if (ret)
 		arm64_notify_segfault(regs, address);
 	else
-		regs->pc += 4;
+		arm64_skip_faulting_instruction(regs, AARCH64_INSN_SIZE);
 }
 
 static void ctr_read_handler(unsigned int esr, struct pt_regs *regs)
@@ -493,7 +504,7 @@ static void ctr_read_handler(unsigned in
 
 	pt_regs_write_reg(regs, rt, val);
 
-	regs->pc += 4;
+	arm64_skip_faulting_instruction(regs, AARCH64_INSN_SIZE);
 }
 
 static void cntvct_read_handler(unsigned int esr, struct pt_regs *regs)
@@ -501,7 +512,7 @@ static void cntvct_read_handler(unsigned
 	int rt = (esr & ESR_ELx_SYS64_ISS_RT_MASK) >> ESR_ELx_SYS64_ISS_RT_SHIFT;
 
 	pt_regs_write_reg(regs, rt, arch_counter_get_cntvct());
-	regs->pc += 4;
+	arm64_skip_faulting_instruction(regs, AARCH64_INSN_SIZE);
 }
 
 static void cntfrq_read_handler(unsigned int esr, struct pt_regs *regs)
@@ -509,7 +520,7 @@ static void cntfrq_read_handler(unsigned
 	int rt = (esr & ESR_ELx_SYS64_ISS_RT_MASK) >> ESR_ELx_SYS64_ISS_RT_SHIFT;
 
 	pt_regs_write_reg(regs, rt, arch_timer_get_rate());
-	regs->pc += 4;
+	arm64_skip_faulting_instruction(regs, AARCH64_INSN_SIZE);
 }
 
 struct sys64_hook {
@@ -756,7 +767,7 @@ static int bug_handler(struct pt_regs *r
 	}
 
 	/* If thread survives, skip over the BUG instruction and continue: */
-	regs->pc += AARCH64_INSN_SIZE;	/* skip BRK and resume */
+	arm64_skip_faulting_instruction(regs, AARCH64_INSN_SIZE);
 	return DBG_HOOK_HANDLED;
 }
 


