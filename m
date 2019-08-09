Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE12587BD3
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 15:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436617AbfHINrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 09:47:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436610AbfHINrf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 09:47:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EE7A2171F;
        Fri,  9 Aug 2019 13:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565358453;
        bh=p/4xwpgrZuT6q8fvaxHR7cf0bzeVGoZXrrFyuzABWEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zaS0iCuMkpGpC6d3gZB0Ia5fhxGU47yE6BpRTaLMZqmdvNUfZp3zyalTylOOmpzto
         lf7UIIjNVJnF5ztoU7fLt5G3qMR2F/aZPaVNhiXoIYvLlkXEcy4gEog/v7pAUNQ+yX
         X87rJ3Dqe5CH35+Kt+c7Db8LU8n0jdi187IYyphw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 29/32] x86/speculation: Prepare entry code for Spectre v1 swapgs mitigations
Date:   Fri,  9 Aug 2019 15:45:32 +0200
Message-Id: <20190809133923.865538682@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809133922.945349906@linuxfoundation.org>
References: <20190809133922.945349906@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit 18ec54fdd6d18d92025af097cd042a75cf0ea24c upstream.

Spectre v1 isn't only about array bounds checks.  It can affect any
conditional checks.  The kernel entry code interrupt, exception, and NMI
handlers all have conditional swapgs checks.  Those may be problematic in
the context of Spectre v1, as kernel code can speculatively run with a user
GS.

For example:

	if (coming from user space)
		swapgs
	mov %gs:<percpu_offset>, %reg
	mov (%reg), %reg1

When coming from user space, the CPU can speculatively skip the swapgs, and
then do a speculative percpu load using the user GS value.  So the user can
speculatively force a read of any kernel value.  If a gadget exists which
uses the percpu value as an address in another load/store, then the
contents of the kernel value may become visible via an L1 side channel
attack.

A similar attack exists when coming from kernel space.  The CPU can
speculatively do the swapgs, causing the user GS to get used for the rest
of the speculative window.

The mitigation is similar to a traditional Spectre v1 mitigation, except:

  a) index masking isn't possible; because the index (percpu offset)
     isn't user-controlled; and

  b) an lfence is needed in both the "from user" swapgs path and the
     "from kernel" non-swapgs path (because of the two attacks described
     above).

The user entry swapgs paths already have SWITCH_TO_KERNEL_CR3, which has a
CR3 write when PTI is enabled.  Since CR3 writes are serializing, the
lfences can be skipped in those cases.

On the other hand, the kernel entry swapgs paths don't depend on PTI.

To avoid unnecessary lfences for the user entry case, create two separate
features for alternative patching:

  X86_FEATURE_FENCE_SWAPGS_USER
  X86_FEATURE_FENCE_SWAPGS_KERNEL

Use these features in entry code to patch in lfences where needed.

The features aren't enabled yet, so there's no functional change.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Dave Hansen <dave.hansen@intel.com>
[bwh: Backported to 4.9:
 - Assign the CPU feature bits from word 7
 - Add FENCE_SWAPGS_KERNEL_ENTRY to NMI entry, since it does not
   use paranoid_entry
 - Include <asm/cpufeatures.h> in calling.h
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/calling.h           |   18 ++++++++++++++++++
 arch/x86/entry/entry_64.S          |   21 +++++++++++++++++++--
 arch/x86/include/asm/cpufeatures.h |    3 ++-
 3 files changed, 39 insertions(+), 3 deletions(-)

--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -1,4 +1,5 @@
 #include <linux/jump_label.h>
+#include <asm/cpufeatures.h>
 
 /*
 
@@ -201,6 +202,23 @@ For 32-bit we have the following convent
 	.byte 0xf1
 	.endm
 
+/*
+ * Mitigate Spectre v1 for conditional swapgs code paths.
+ *
+ * FENCE_SWAPGS_USER_ENTRY is used in the user entry swapgs code path, to
+ * prevent a speculative swapgs when coming from kernel space.
+ *
+ * FENCE_SWAPGS_KERNEL_ENTRY is used in the kernel entry non-swapgs code path,
+ * to prevent the swapgs from getting speculatively skipped when coming from
+ * user space.
+ */
+.macro FENCE_SWAPGS_USER_ENTRY
+	ALTERNATIVE "", "lfence", X86_FEATURE_FENCE_SWAPGS_USER
+.endm
+.macro FENCE_SWAPGS_KERNEL_ENTRY
+	ALTERNATIVE "", "lfence", X86_FEATURE_FENCE_SWAPGS_KERNEL
+.endm
+
 #endif /* CONFIG_X86_64 */
 
 /*
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -420,6 +420,7 @@ END(irq_entries_start)
 	 * tracking that we're in kernel mode.
 	 */
 	SWAPGS
+	FENCE_SWAPGS_USER_ENTRY
 	SWITCH_KERNEL_CR3
 
 	/*
@@ -433,8 +434,10 @@ END(irq_entries_start)
 	TRACE_IRQS_OFF
 
 	CALL_enter_from_user_mode
-
+	jmpq	2f
 1:
+	FENCE_SWAPGS_KERNEL_ENTRY
+2:
 	/*
 	 * Save previous stack pointer, optionally switch to interrupt stack.
 	 * irq_count is used to check if a CPU is already on an interrupt stack
@@ -1004,6 +1007,13 @@ ENTRY(paranoid_entry)
 	movq	%rax, %cr3
 2:
 #endif
+	/*
+	 * The above doesn't do an unconditional CR3 write, even in the PTI
+	 * case.  So do an lfence to prevent GS speculation, regardless of
+	 * whether PTI is enabled.
+	 */
+	FENCE_SWAPGS_KERNEL_ENTRY
+
 	ret
 END(paranoid_entry)
 
@@ -1065,6 +1075,7 @@ ENTRY(error_entry)
 	 * from user mode due to an IRET fault.
 	 */
 	SWAPGS
+	FENCE_SWAPGS_USER_ENTRY
 
 .Lerror_entry_from_usermode_after_swapgs:
 	/*
@@ -1076,6 +1087,8 @@ ENTRY(error_entry)
 	CALL_enter_from_user_mode
 	ret
 
+.Lerror_entry_done_lfence:
+	FENCE_SWAPGS_KERNEL_ENTRY
 .Lerror_entry_done:
 	TRACE_IRQS_OFF
 	ret
@@ -1094,7 +1107,7 @@ ENTRY(error_entry)
 	cmpq	%rax, RIP+8(%rsp)
 	je	.Lbstep_iret
 	cmpq	$.Lgs_change, RIP+8(%rsp)
-	jne	.Lerror_entry_done
+	jne	.Lerror_entry_done_lfence
 
 	/*
 	 * hack: .Lgs_change can fail with user gsbase.  If this happens, fix up
@@ -1102,6 +1115,7 @@ ENTRY(error_entry)
 	 * .Lgs_change's error handler with kernel gsbase.
 	 */
 	SWAPGS
+	FENCE_SWAPGS_USER_ENTRY
 	jmp .Lerror_entry_done
 
 .Lbstep_iret:
@@ -1115,6 +1129,7 @@ ENTRY(error_entry)
 	 * Switch to kernel gsbase:
 	 */
 	SWAPGS
+	FENCE_SWAPGS_USER_ENTRY
 
 	/*
 	 * Pretend that the exception came from user mode: set up pt_regs
@@ -1211,6 +1226,7 @@ ENTRY(nmi)
 	 * to switch CR3 here.
 	 */
 	cld
+	FENCE_SWAPGS_USER_ENTRY
 	movq	%rsp, %rdx
 	movq	PER_CPU_VAR(cpu_current_top_of_stack), %rsp
 	pushq	5*8(%rdx)	/* pt_regs->ss */
@@ -1499,6 +1515,7 @@ end_repeat_nmi:
 	movq	%rax, %cr3
 2:
 #endif
+	FENCE_SWAPGS_KERNEL_ENTRY
 
 	/* paranoidentry do_nmi, 0; without TRACE_IRQS_OFF */
 	call	do_nmi
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -192,7 +192,8 @@
 
 #define X86_FEATURE_HW_PSTATE	( 7*32+ 8) /* AMD HW-PState */
 #define X86_FEATURE_PROC_FEEDBACK ( 7*32+ 9) /* AMD ProcFeedbackInterface */
-
+#define X86_FEATURE_FENCE_SWAPGS_USER	( 7*32+10) /* "" LFENCE in user entry SWAPGS path */
+#define X86_FEATURE_FENCE_SWAPGS_KERNEL	( 7*32+11) /* "" LFENCE in kernel entry SWAPGS path */
 #define X86_FEATURE_RETPOLINE	( 7*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
 #define X86_FEATURE_RETPOLINE_AMD ( 7*32+13) /* "" AMD Retpoline mitigation for Spectre variant 2 */
 


