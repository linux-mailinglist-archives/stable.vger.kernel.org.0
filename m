Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD3F359BD8
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbhDIKVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:21:12 -0400
Received: from foss.arm.com ([217.140.110.172]:47450 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234250AbhDIKTb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:19:31 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B3EF11FB;
        Fri,  9 Apr 2021 03:19:17 -0700 (PDT)
Received: from e119884-lin.cambridge.arm.com (e119884-lin.cambridge.arm.com [10.1.196.72])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AD8B63F73D;
        Fri,  9 Apr 2021 03:19:16 -0700 (PDT)
From:   Vincenzo Frascino <vincenzo.frascino@arm.com>
To:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com
Cc:     Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2] arm64: mte: Move MTE TCF0 check in entry-common
Date:   Fri,  9 Apr 2021 11:19:02 +0100
Message-Id: <20210409101902.2800-1-vincenzo.frascino@arm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The check_mte_async_tcf macro sets the TIF flag non-atomically. This can
race with another CPU doing a set_tsk_thread_flag() and all the other flags
can be lost in the process.

Move the tcf0 check to enter_from_user_mode() and clear tcf0 in
exit_to_user_mode() to address the problem.

Note: Moving the check in entry-common allows to use set_thread_flag()
which is safe.

Fixes: 637ec831ea4f ("arm64: mte: Handle synchronous and asynchronous tag check faults")
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: stable@vger.kernel.org
Reported-by: Will Deacon <will@kernel.org>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
---
 arch/arm64/include/asm/mte.h     |  8 ++++++++
 arch/arm64/kernel/entry-common.c |  6 ++++++
 arch/arm64/kernel/entry.S        | 34 --------------------------------
 arch/arm64/kernel/mte.c          | 33 +++++++++++++++++++++++++++++--
 4 files changed, 45 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/include/asm/mte.h b/arch/arm64/include/asm/mte.h
index 9b557a457f24..2ecb2156dac1 100644
--- a/arch/arm64/include/asm/mte.h
+++ b/arch/arm64/include/asm/mte.h
@@ -31,6 +31,8 @@ void mte_invalidate_tags(int type, pgoff_t offset);
 void mte_invalidate_tags_area(int type);
 void *mte_allocate_tag_storage(void);
 void mte_free_tag_storage(char *storage);
+void noinstr check_mte_async_tcf0(void);
+void noinstr clear_mte_async_tcf0(void);
 
 #ifdef CONFIG_ARM64_MTE
 
@@ -83,6 +85,12 @@ static inline int mte_ptrace_copy_tags(struct task_struct *child,
 {
 	return -EIO;
 }
+static inline void check_mte_async_tcf0(void)
+{
+}
+static inline void clear_mte_async_tcf0(void)
+{
+}
 
 static inline void mte_assign_mem_tag_range(void *addr, size_t size)
 {
diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index 9d3588450473..837d3624a1d5 100644
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -289,10 +289,16 @@ asmlinkage void noinstr enter_from_user_mode(void)
 	CT_WARN_ON(ct_state() != CONTEXT_USER);
 	user_exit_irqoff();
 	trace_hardirqs_off_finish();
+
+	/* Check for asynchronous tag check faults in user space */
+	check_mte_async_tcf0();
 }
 
 asmlinkage void noinstr exit_to_user_mode(void)
 {
+	/* Ignore asynchronous tag check faults in the uaccess routines */
+	clear_mte_async_tcf0();
+
 	trace_hardirqs_on_prepare();
 	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
 	user_enter_irqoff();
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index a31a0a713c85..fb57df0d453f 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -34,15 +34,11 @@
  * user and kernel mode.
  */
 	.macro user_exit_irqoff
-#if defined(CONFIG_CONTEXT_TRACKING) || defined(CONFIG_TRACE_IRQFLAGS)
 	bl	enter_from_user_mode
-#endif
 	.endm
 
 	.macro user_enter_irqoff
-#if defined(CONFIG_CONTEXT_TRACKING) || defined(CONFIG_TRACE_IRQFLAGS)
 	bl	exit_to_user_mode
-#endif
 	.endm
 
 	.macro	clear_gp_regs
@@ -147,32 +143,6 @@ alternative_cb_end
 .L__asm_ssbd_skip\@:
 	.endm
 
-	/* Check for MTE asynchronous tag check faults */
-	.macro check_mte_async_tcf, flgs, tmp
-#ifdef CONFIG_ARM64_MTE
-alternative_if_not ARM64_MTE
-	b	1f
-alternative_else_nop_endif
-	mrs_s	\tmp, SYS_TFSRE0_EL1
-	tbz	\tmp, #SYS_TFSR_EL1_TF0_SHIFT, 1f
-	/* Asynchronous TCF occurred for TTBR0 access, set the TI flag */
-	orr	\flgs, \flgs, #_TIF_MTE_ASYNC_FAULT
-	str	\flgs, [tsk, #TSK_TI_FLAGS]
-	msr_s	SYS_TFSRE0_EL1, xzr
-1:
-#endif
-	.endm
-
-	/* Clear the MTE asynchronous tag check faults */
-	.macro clear_mte_async_tcf
-#ifdef CONFIG_ARM64_MTE
-alternative_if ARM64_MTE
-	dsb	ish
-	msr_s	SYS_TFSRE0_EL1, xzr
-alternative_else_nop_endif
-#endif
-	.endm
-
 	.macro mte_set_gcr, tmp, tmp2
 #ifdef CONFIG_ARM64_MTE
 	/*
@@ -243,8 +213,6 @@ alternative_else_nop_endif
 	ldr	x19, [tsk, #TSK_TI_FLAGS]
 	disable_step_tsk x19, x20
 
-	/* Check for asynchronous tag check faults in user space */
-	check_mte_async_tcf x19, x22
 	apply_ssbd 1, x22, x23
 
 	ptrauth_keys_install_kernel tsk, x20, x22, x23
@@ -775,8 +743,6 @@ SYM_CODE_START_LOCAL(ret_to_user)
 	cbnz	x2, work_pending
 finish_ret_to_user:
 	user_enter_irqoff
-	/* Ignore asynchronous tag check faults in the uaccess routines */
-	clear_mte_async_tcf
 	enable_step_tsk x19, x2
 #ifdef CONFIG_GCC_PLUGIN_STACKLEAK
 	bl	stackleak_erase
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index b3c70a612c7a..84a942c25870 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -166,14 +166,43 @@ static void set_gcr_el1_excl(u64 excl)
 	 */
 }
 
-void flush_mte_state(void)
+void noinstr check_mte_async_tcf0(void)
+{
+	u64 tcf0;
+
+	if (!system_supports_mte())
+		return;
+
+	/*
+	 * dsb(ish) is not required before the register read
+	 * because the TFSRE0_EL1 is automatically synchronized
+	 * by the hardware on exception entry as SCTLR_EL1.ITFSB
+	 * is set.
+	 */
+	tcf0 = read_sysreg_s(SYS_TFSRE0_EL1);
+
+	if (tcf0 & SYS_TFSR_EL1_TF0)
+		set_thread_flag(TIF_MTE_ASYNC_FAULT);
+
+	write_sysreg_s(0, SYS_TFSRE0_EL1);
+}
+
+void noinstr clear_mte_async_tcf0(void)
 {
 	if (!system_supports_mte())
 		return;
 
-	/* clear any pending asynchronous tag fault */
 	dsb(ish);
 	write_sysreg_s(0, SYS_TFSRE0_EL1);
+}
+
+void flush_mte_state(void)
+{
+	if (!system_supports_mte())
+		return;
+
+	/* clear any pending asynchronous tag fault */
+	clear_mte_async_tcf0();
 	clear_thread_flag(TIF_MTE_ASYNC_FAULT);
 	/* disable tag checking */
 	set_sctlr_el1_tcf0(SCTLR_EL1_TCF0_NONE);
-- 
2.30.2

