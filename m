Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40AA4657824
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbiL1OsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:48:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233081AbiL1Orn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:47:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E50255
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:47:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3A8AB8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:47:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6BADC433D2;
        Wed, 28 Dec 2022 14:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238843;
        bh=2lGhHWk8u5x7d9qoywlMLnayOXx8nQf16vodWZIxswU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NtmlbGUr7PrtBSe4d5UPxu0gxTTsZ4tBWuOOFoJwj0BJuayTAjMQ87HPGDiW2P7Iq
         mzrpy6HLX4VbRlOCB2MJ95w/2vYeTwK2Wl/4/wfLvtGBQhKJ1I+u1niuQqRQsFRfFJ
         yArcq9EPy3Br4Jgja0ucage4CDUzc1/MLUTBjcT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/731] arm64: Treat ESR_ELx as a 64-bit register
Date:   Wed, 28 Dec 2022 15:32:18 +0100
Message-Id: <20221228144257.453585223@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

[ Upstream commit 8d56e5c5a99ce1d17d39ce5a8260e42c2a2d7682 ]

In the initial release of the ARM Architecture Reference Manual for
ARMv8-A, the ESR_ELx registers were defined as 32-bit registers. This
changed in 2018 with version D.a (ARM DDI 0487D.a) of the architecture,
when they became 64-bit registers, with bits [63:32] defined as RES0. In
version G.a, a new field was added to ESR_ELx, ISS2, which covers bits
[36:32].  This field is used when the Armv8.7 extension FEAT_LS64 is
implemented.

As a result of the evolution of the register width, Linux stores it as
both a 64-bit value and a 32-bit value, which hasn't affected correctness
so far as Linux only uses the lower 32 bits of the register.

Make the register type consistent and always treat it as 64-bit wide. The
register is redefined as an "unsigned long", which is an unsigned
double-word (64-bit quantity) for the LP64 machine (aapcs64 [1], Table 1,
page 14). The type was chosen because "unsigned int" is the most frequent
type for ESR_ELx and because FAR_ELx, which is used together with ESR_ELx
in exception handling, is also declared as "unsigned long". The 64-bit type
also makes adding support for architectural features that use fields above
bit 31 easier in the future.

The KVM hypervisor will receive a similar update in a subsequent patch.

[1] https://github.com/ARM-software/abi-aa/releases/download/2021Q3/aapcs64.pdf

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220425114444.368693-4-alexandru.elisei@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Stable-dep-of: 0bb1fbffc631 ("arm64: mm: kfence: only handle translation faults")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/debug-monitors.h |  4 +-
 arch/arm64/include/asm/esr.h            |  6 +--
 arch/arm64/include/asm/exception.h      | 28 +++++-----
 arch/arm64/include/asm/system_misc.h    |  4 +-
 arch/arm64/include/asm/traps.h          | 12 ++---
 arch/arm64/kernel/debug-monitors.c      | 12 ++---
 arch/arm64/kernel/entry-common.c        |  6 +--
 arch/arm64/kernel/fpsimd.c              |  6 +--
 arch/arm64/kernel/hw_breakpoint.c       |  4 +-
 arch/arm64/kernel/kgdb.c                |  6 +--
 arch/arm64/kernel/probes/kprobes.c      |  4 +-
 arch/arm64/kernel/probes/uprobes.c      |  4 +-
 arch/arm64/kernel/traps.c               | 66 +++++++++++------------
 arch/arm64/mm/fault.c                   | 70 ++++++++++++-------------
 14 files changed, 116 insertions(+), 116 deletions(-)

diff --git a/arch/arm64/include/asm/debug-monitors.h b/arch/arm64/include/asm/debug-monitors.h
index 657c921fd784..e1e10a24519b 100644
--- a/arch/arm64/include/asm/debug-monitors.h
+++ b/arch/arm64/include/asm/debug-monitors.h
@@ -76,7 +76,7 @@ struct task_struct;
 
 struct step_hook {
 	struct list_head node;
-	int (*fn)(struct pt_regs *regs, unsigned int esr);
+	int (*fn)(struct pt_regs *regs, unsigned long esr);
 };
 
 void register_user_step_hook(struct step_hook *hook);
@@ -87,7 +87,7 @@ void unregister_kernel_step_hook(struct step_hook *hook);
 
 struct break_hook {
 	struct list_head node;
-	int (*fn)(struct pt_regs *regs, unsigned int esr);
+	int (*fn)(struct pt_regs *regs, unsigned long esr);
 	u16 imm;
 	u16 mask; /* These bits are ignored when comparing with imm */
 };
diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 8f59bbeba7a7..9f91c8906edd 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -324,14 +324,14 @@
 #ifndef __ASSEMBLY__
 #include <asm/types.h>
 
-static inline bool esr_is_data_abort(u32 esr)
+static inline bool esr_is_data_abort(unsigned long esr)
 {
-	const u32 ec = ESR_ELx_EC(esr);
+	const unsigned long ec = ESR_ELx_EC(esr);
 
 	return ec == ESR_ELx_EC_DABT_LOW || ec == ESR_ELx_EC_DABT_CUR;
 }
 
-const char *esr_get_class_string(u32 esr);
+const char *esr_get_class_string(unsigned long esr);
 #endif /* __ASSEMBLY */
 
 #endif /* __ASM_ESR_H */
diff --git a/arch/arm64/include/asm/exception.h b/arch/arm64/include/asm/exception.h
index 339477dca551..0e6535aa78c2 100644
--- a/arch/arm64/include/asm/exception.h
+++ b/arch/arm64/include/asm/exception.h
@@ -19,9 +19,9 @@
 #define __exception_irq_entry	__kprobes
 #endif
 
-static inline u32 disr_to_esr(u64 disr)
+static inline unsigned long disr_to_esr(u64 disr)
 {
-	unsigned int esr = ESR_ELx_EC_SERROR << ESR_ELx_EC_SHIFT;
+	unsigned long esr = ESR_ELx_EC_SERROR << ESR_ELx_EC_SHIFT;
 
 	if ((disr & DISR_EL1_IDS) == 0)
 		esr |= (disr & DISR_EL1_ESR_MASK);
@@ -57,23 +57,23 @@ asmlinkage void call_on_irq_stack(struct pt_regs *regs,
 				  void (*func)(struct pt_regs *));
 asmlinkage void asm_exit_to_user_mode(struct pt_regs *regs);
 
-void do_mem_abort(unsigned long far, unsigned int esr, struct pt_regs *regs);
+void do_mem_abort(unsigned long far, unsigned long esr, struct pt_regs *regs);
 void do_undefinstr(struct pt_regs *regs);
 void do_bti(struct pt_regs *regs);
-void do_debug_exception(unsigned long addr_if_watchpoint, unsigned int esr,
+void do_debug_exception(unsigned long addr_if_watchpoint, unsigned long esr,
 			struct pt_regs *regs);
-void do_fpsimd_acc(unsigned int esr, struct pt_regs *regs);
-void do_sve_acc(unsigned int esr, struct pt_regs *regs);
-void do_fpsimd_exc(unsigned int esr, struct pt_regs *regs);
-void do_sysinstr(unsigned int esr, struct pt_regs *regs);
-void do_sp_pc_abort(unsigned long addr, unsigned int esr, struct pt_regs *regs);
-void bad_el0_sync(struct pt_regs *regs, int reason, unsigned int esr);
-void do_cp15instr(unsigned int esr, struct pt_regs *regs);
+void do_fpsimd_acc(unsigned long esr, struct pt_regs *regs);
+void do_sve_acc(unsigned long esr, struct pt_regs *regs);
+void do_fpsimd_exc(unsigned long esr, struct pt_regs *regs);
+void do_sysinstr(unsigned long esr, struct pt_regs *regs);
+void do_sp_pc_abort(unsigned long addr, unsigned long esr, struct pt_regs *regs);
+void bad_el0_sync(struct pt_regs *regs, int reason, unsigned long esr);
+void do_cp15instr(unsigned long esr, struct pt_regs *regs);
 void do_el0_svc(struct pt_regs *regs);
 void do_el0_svc_compat(struct pt_regs *regs);
-void do_ptrauth_fault(struct pt_regs *regs, unsigned int esr);
-void do_serror(struct pt_regs *regs, unsigned int esr);
+void do_ptrauth_fault(struct pt_regs *regs, unsigned long esr);
+void do_serror(struct pt_regs *regs, unsigned long esr);
 void do_notify_resume(struct pt_regs *regs, unsigned long thread_flags);
 
-void panic_bad_stack(struct pt_regs *regs, unsigned int esr, unsigned long far);
+void panic_bad_stack(struct pt_regs *regs, unsigned long esr, unsigned long far);
 #endif	/* __ASM_EXCEPTION_H */
diff --git a/arch/arm64/include/asm/system_misc.h b/arch/arm64/include/asm/system_misc.h
index 305a7157c6a6..0eb7709422e2 100644
--- a/arch/arm64/include/asm/system_misc.h
+++ b/arch/arm64/include/asm/system_misc.h
@@ -23,9 +23,9 @@ void die(const char *msg, struct pt_regs *regs, int err);
 struct siginfo;
 void arm64_notify_die(const char *str, struct pt_regs *regs,
 		      int signo, int sicode, unsigned long far,
-		      int err);
+		      unsigned long err);
 
-void hook_debug_fault_code(int nr, int (*fn)(unsigned long, unsigned int,
+void hook_debug_fault_code(int nr, int (*fn)(unsigned long, unsigned long,
 					     struct pt_regs *),
 			   int sig, int code, const char *name);
 
diff --git a/arch/arm64/include/asm/traps.h b/arch/arm64/include/asm/traps.h
index 54f32a0675df..6e5826470bea 100644
--- a/arch/arm64/include/asm/traps.h
+++ b/arch/arm64/include/asm/traps.h
@@ -24,7 +24,7 @@ struct undef_hook {
 
 void register_undef_hook(struct undef_hook *hook);
 void unregister_undef_hook(struct undef_hook *hook);
-void force_signal_inject(int signal, int code, unsigned long address, unsigned int err);
+void force_signal_inject(int signal, int code, unsigned long address, unsigned long err);
 void arm64_notify_segfault(unsigned long addr);
 void arm64_force_sig_fault(int signo, int code, unsigned long far, const char *str);
 void arm64_force_sig_mceerr(int code, unsigned long far, short lsb, const char *str);
@@ -57,7 +57,7 @@ static inline int in_entry_text(unsigned long ptr)
  * errors share the same encoding as an all-zeros encoding from a CPU that
  * doesn't support RAS.
  */
-static inline bool arm64_is_ras_serror(u32 esr)
+static inline bool arm64_is_ras_serror(unsigned long esr)
 {
 	WARN_ON(preemptible());
 
@@ -77,9 +77,9 @@ static inline bool arm64_is_ras_serror(u32 esr)
  * We treat them as Uncontainable.
  * Non-RAS SError's are reported as Uncontained/Uncategorized.
  */
-static inline u32 arm64_ras_serror_get_severity(u32 esr)
+static inline unsigned long arm64_ras_serror_get_severity(unsigned long esr)
 {
-	u32 aet = esr & ESR_ELx_AET;
+	unsigned long aet = esr & ESR_ELx_AET;
 
 	if (!arm64_is_ras_serror(esr)) {
 		/* Not a RAS error, we can't interpret the ESR. */
@@ -98,6 +98,6 @@ static inline u32 arm64_ras_serror_get_severity(u32 esr)
 	return aet;
 }
 
-bool arm64_is_fatal_ras_serror(struct pt_regs *regs, unsigned int esr);
-void __noreturn arm64_serror_panic(struct pt_regs *regs, u32 esr);
+bool arm64_is_fatal_ras_serror(struct pt_regs *regs, unsigned long esr);
+void __noreturn arm64_serror_panic(struct pt_regs *regs, unsigned long esr);
 #endif
diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
index 4f3661eeb7ec..bf9fe71589bc 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -202,7 +202,7 @@ void unregister_kernel_step_hook(struct step_hook *hook)
  * So we call all the registered handlers, until the right handler is
  * found which returns zero.
  */
-static int call_step_hook(struct pt_regs *regs, unsigned int esr)
+static int call_step_hook(struct pt_regs *regs, unsigned long esr)
 {
 	struct step_hook *hook;
 	struct list_head *list;
@@ -238,7 +238,7 @@ static void send_user_sigtrap(int si_code)
 			      "User debug trap");
 }
 
-static int single_step_handler(unsigned long unused, unsigned int esr,
+static int single_step_handler(unsigned long unused, unsigned long esr,
 			       struct pt_regs *regs)
 {
 	bool handler_found = false;
@@ -299,11 +299,11 @@ void unregister_kernel_break_hook(struct break_hook *hook)
 	unregister_debug_hook(&hook->node);
 }
 
-static int call_break_hook(struct pt_regs *regs, unsigned int esr)
+static int call_break_hook(struct pt_regs *regs, unsigned long esr)
 {
 	struct break_hook *hook;
 	struct list_head *list;
-	int (*fn)(struct pt_regs *regs, unsigned int esr) = NULL;
+	int (*fn)(struct pt_regs *regs, unsigned long esr) = NULL;
 
 	list = user_mode(regs) ? &user_break_hook : &kernel_break_hook;
 
@@ -312,7 +312,7 @@ static int call_break_hook(struct pt_regs *regs, unsigned int esr)
 	 * entirely not preemptible, and we can use rcu list safely here.
 	 */
 	list_for_each_entry_rcu(hook, list, node) {
-		unsigned int comment = esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
+		unsigned long comment = esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
 
 		if ((comment & ~hook->mask) == hook->imm)
 			fn = hook->fn;
@@ -322,7 +322,7 @@ static int call_break_hook(struct pt_regs *regs, unsigned int esr)
 }
 NOKPROBE_SYMBOL(call_break_hook);
 
-static int brk_handler(unsigned long unused, unsigned int esr,
+static int brk_handler(unsigned long unused, unsigned long esr,
 		       struct pt_regs *regs)
 {
 	if (call_break_hook(regs, esr) == DBG_HOOK_HANDLED)
diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index 8ecca795aca0..fc91dad1579a 100644
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -273,13 +273,13 @@ extern void (*handle_arch_irq)(struct pt_regs *);
 extern void (*handle_arch_fiq)(struct pt_regs *);
 
 static void noinstr __panic_unhandled(struct pt_regs *regs, const char *vector,
-				      unsigned int esr)
+				      unsigned long esr)
 {
 	arm64_enter_nmi(regs);
 
 	console_verbose();
 
-	pr_crit("Unhandled %s exception on CPU%d, ESR 0x%08x -- %s\n",
+	pr_crit("Unhandled %s exception on CPU%d, ESR 0x%016lx -- %s\n",
 		vector, smp_processor_id(), esr,
 		esr_get_class_string(esr));
 
@@ -796,7 +796,7 @@ UNHANDLED(el0t, 32, error)
 #ifdef CONFIG_VMAP_STACK
 asmlinkage void noinstr handle_bad_stack(struct pt_regs *regs)
 {
-	unsigned int esr = read_sysreg(esr_el1);
+	unsigned long esr = read_sysreg(esr_el1);
 	unsigned long far = read_sysreg(far_el1);
 
 	arm64_enter_nmi(regs);
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index ff4962750b3d..7a3fcf21b18a 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -930,7 +930,7 @@ void fpsimd_release_task(struct task_struct *dead_task)
  * would have disabled the SVE access trap for userspace during
  * ret_to_user, making an SVE access trap impossible in that case.
  */
-void do_sve_acc(unsigned int esr, struct pt_regs *regs)
+void do_sve_acc(unsigned long esr, struct pt_regs *regs)
 {
 	/* Even if we chose not to use SVE, the hardware could still trap: */
 	if (unlikely(!system_supports_sve()) || WARN_ON(is_compat_task())) {
@@ -972,7 +972,7 @@ void do_sve_acc(unsigned int esr, struct pt_regs *regs)
 /*
  * Trapped FP/ASIMD access.
  */
-void do_fpsimd_acc(unsigned int esr, struct pt_regs *regs)
+void do_fpsimd_acc(unsigned long esr, struct pt_regs *regs)
 {
 	/* TODO: implement lazy context saving/restoring */
 	WARN_ON(1);
@@ -981,7 +981,7 @@ void do_fpsimd_acc(unsigned int esr, struct pt_regs *regs)
 /*
  * Raise a SIGFPE for the current process.
  */
-void do_fpsimd_exc(unsigned int esr, struct pt_regs *regs)
+void do_fpsimd_exc(unsigned long esr, struct pt_regs *regs)
 {
 	unsigned int si_code = FPE_FLTUNK;
 
diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw_breakpoint.c
index 712e97c03e54..2a7f21314cde 100644
--- a/arch/arm64/kernel/hw_breakpoint.c
+++ b/arch/arm64/kernel/hw_breakpoint.c
@@ -617,7 +617,7 @@ NOKPROBE_SYMBOL(toggle_bp_registers);
 /*
  * Debug exception handlers.
  */
-static int breakpoint_handler(unsigned long unused, unsigned int esr,
+static int breakpoint_handler(unsigned long unused, unsigned long esr,
 			      struct pt_regs *regs)
 {
 	int i, step = 0, *kernel_step;
@@ -751,7 +751,7 @@ static int watchpoint_report(struct perf_event *wp, unsigned long addr,
 	return step;
 }
 
-static int watchpoint_handler(unsigned long addr, unsigned int esr,
+static int watchpoint_handler(unsigned long addr, unsigned long esr,
 			      struct pt_regs *regs)
 {
 	int i, step = 0, *kernel_step, access, closest_match = 0;
diff --git a/arch/arm64/kernel/kgdb.c b/arch/arm64/kernel/kgdb.c
index 2aede780fb80..cda9c1e9864f 100644
--- a/arch/arm64/kernel/kgdb.c
+++ b/arch/arm64/kernel/kgdb.c
@@ -232,14 +232,14 @@ int kgdb_arch_handle_exception(int exception_vector, int signo,
 	return err;
 }
 
-static int kgdb_brk_fn(struct pt_regs *regs, unsigned int esr)
+static int kgdb_brk_fn(struct pt_regs *regs, unsigned long esr)
 {
 	kgdb_handle_exception(1, SIGTRAP, 0, regs);
 	return DBG_HOOK_HANDLED;
 }
 NOKPROBE_SYMBOL(kgdb_brk_fn)
 
-static int kgdb_compiled_brk_fn(struct pt_regs *regs, unsigned int esr)
+static int kgdb_compiled_brk_fn(struct pt_regs *regs, unsigned long esr)
 {
 	compiled_break = 1;
 	kgdb_handle_exception(1, SIGTRAP, 0, regs);
@@ -248,7 +248,7 @@ static int kgdb_compiled_brk_fn(struct pt_regs *regs, unsigned int esr)
 }
 NOKPROBE_SYMBOL(kgdb_compiled_brk_fn);
 
-static int kgdb_step_brk_fn(struct pt_regs *regs, unsigned int esr)
+static int kgdb_step_brk_fn(struct pt_regs *regs, unsigned long esr)
 {
 	if (!kgdb_single_step)
 		return DBG_HOOK_ERROR;
diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/kprobes.c
index 6dbcc89f6662..b7404dba0d62 100644
--- a/arch/arm64/kernel/probes/kprobes.c
+++ b/arch/arm64/kernel/probes/kprobes.c
@@ -332,7 +332,7 @@ static void __kprobes kprobe_handler(struct pt_regs *regs)
 }
 
 static int __kprobes
-kprobe_breakpoint_ss_handler(struct pt_regs *regs, unsigned int esr)
+kprobe_breakpoint_ss_handler(struct pt_regs *regs, unsigned long esr)
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 	unsigned long addr = instruction_pointer(regs);
@@ -356,7 +356,7 @@ static struct break_hook kprobes_break_ss_hook = {
 };
 
 static int __kprobes
-kprobe_breakpoint_handler(struct pt_regs *regs, unsigned int esr)
+kprobe_breakpoint_handler(struct pt_regs *regs, unsigned long esr)
 {
 	kprobe_handler(regs);
 	return DBG_HOOK_HANDLED;
diff --git a/arch/arm64/kernel/probes/uprobes.c b/arch/arm64/kernel/probes/uprobes.c
index 9be668f3f034..d49aef2657cd 100644
--- a/arch/arm64/kernel/probes/uprobes.c
+++ b/arch/arm64/kernel/probes/uprobes.c
@@ -166,7 +166,7 @@ int arch_uprobe_exception_notify(struct notifier_block *self,
 }
 
 static int uprobe_breakpoint_handler(struct pt_regs *regs,
-		unsigned int esr)
+				     unsigned long esr)
 {
 	if (uprobe_pre_sstep_notifier(regs))
 		return DBG_HOOK_HANDLED;
@@ -175,7 +175,7 @@ static int uprobe_breakpoint_handler(struct pt_regs *regs,
 }
 
 static int uprobe_single_step_handler(struct pt_regs *regs,
-		unsigned int esr)
+				      unsigned long esr)
 {
 	struct uprobe_task *utask = current->utask;
 
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index fe0cd0568813..f859cc870d5b 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -243,7 +243,7 @@ static void arm64_show_signal(int signo, const char *str)
 	static DEFINE_RATELIMIT_STATE(rs, DEFAULT_RATELIMIT_INTERVAL,
 				      DEFAULT_RATELIMIT_BURST);
 	struct task_struct *tsk = current;
-	unsigned int esr = tsk->thread.fault_code;
+	unsigned long esr = tsk->thread.fault_code;
 	struct pt_regs *regs = task_pt_regs(tsk);
 
 	/* Leave if the signal won't be shown */
@@ -254,7 +254,7 @@ static void arm64_show_signal(int signo, const char *str)
 
 	pr_info("%s[%d]: unhandled exception: ", tsk->comm, task_pid_nr(tsk));
 	if (esr)
-		pr_cont("%s, ESR 0x%08x, ", esr_get_class_string(esr), esr);
+		pr_cont("%s, ESR 0x%016lx, ", esr_get_class_string(esr), esr);
 
 	pr_cont("%s", str);
 	print_vma_addr(KERN_CONT " in ", regs->pc);
@@ -288,7 +288,7 @@ void arm64_force_sig_ptrace_errno_trap(int errno, unsigned long far,
 
 void arm64_notify_die(const char *str, struct pt_regs *regs,
 		      int signo, int sicode, unsigned long far,
-		      int err)
+		      unsigned long err)
 {
 	if (user_mode(regs)) {
 		WARN_ON(regs != current_pt_regs());
@@ -440,7 +440,7 @@ static int call_undef_hook(struct pt_regs *regs)
 	return fn ? fn(regs, instr) : 1;
 }
 
-void force_signal_inject(int signal, int code, unsigned long address, unsigned int err)
+void force_signal_inject(int signal, int code, unsigned long address, unsigned long err)
 {
 	const char *desc;
 	struct pt_regs *regs = current_pt_regs();
@@ -507,7 +507,7 @@ void do_bti(struct pt_regs *regs)
 }
 NOKPROBE_SYMBOL(do_bti);
 
-void do_ptrauth_fault(struct pt_regs *regs, unsigned int esr)
+void do_ptrauth_fault(struct pt_regs *regs, unsigned long esr)
 {
 	/*
 	 * Unexpected FPAC exception or pointer authentication failure in
@@ -538,7 +538,7 @@ NOKPROBE_SYMBOL(do_ptrauth_fault);
 		uaccess_ttbr0_disable();			\
 	}
 
-static void user_cache_maint_handler(unsigned int esr, struct pt_regs *regs)
+static void user_cache_maint_handler(unsigned long esr, struct pt_regs *regs)
 {
 	unsigned long tagged_address, address;
 	int rt = ESR_ELx_SYS64_ISS_RT(esr);
@@ -578,7 +578,7 @@ static void user_cache_maint_handler(unsigned int esr, struct pt_regs *regs)
 		arm64_skip_faulting_instruction(regs, AARCH64_INSN_SIZE);
 }
 
-static void ctr_read_handler(unsigned int esr, struct pt_regs *regs)
+static void ctr_read_handler(unsigned long esr, struct pt_regs *regs)
 {
 	int rt = ESR_ELx_SYS64_ISS_RT(esr);
 	unsigned long val = arm64_ftr_reg_user_value(&arm64_ftr_reg_ctrel0);
@@ -597,7 +597,7 @@ static void ctr_read_handler(unsigned int esr, struct pt_regs *regs)
 	arm64_skip_faulting_instruction(regs, AARCH64_INSN_SIZE);
 }
 
-static void cntvct_read_handler(unsigned int esr, struct pt_regs *regs)
+static void cntvct_read_handler(unsigned long esr, struct pt_regs *regs)
 {
 	int rt = ESR_ELx_SYS64_ISS_RT(esr);
 
@@ -605,7 +605,7 @@ static void cntvct_read_handler(unsigned int esr, struct pt_regs *regs)
 	arm64_skip_faulting_instruction(regs, AARCH64_INSN_SIZE);
 }
 
-static void cntfrq_read_handler(unsigned int esr, struct pt_regs *regs)
+static void cntfrq_read_handler(unsigned long esr, struct pt_regs *regs)
 {
 	int rt = ESR_ELx_SYS64_ISS_RT(esr);
 
@@ -613,7 +613,7 @@ static void cntfrq_read_handler(unsigned int esr, struct pt_regs *regs)
 	arm64_skip_faulting_instruction(regs, AARCH64_INSN_SIZE);
 }
 
-static void mrs_handler(unsigned int esr, struct pt_regs *regs)
+static void mrs_handler(unsigned long esr, struct pt_regs *regs)
 {
 	u32 sysreg, rt;
 
@@ -624,15 +624,15 @@ static void mrs_handler(unsigned int esr, struct pt_regs *regs)
 		force_signal_inject(SIGILL, ILL_ILLOPC, regs->pc, 0);
 }
 
-static void wfi_handler(unsigned int esr, struct pt_regs *regs)
+static void wfi_handler(unsigned long esr, struct pt_regs *regs)
 {
 	arm64_skip_faulting_instruction(regs, AARCH64_INSN_SIZE);
 }
 
 struct sys64_hook {
-	unsigned int esr_mask;
-	unsigned int esr_val;
-	void (*handler)(unsigned int esr, struct pt_regs *regs);
+	unsigned long esr_mask;
+	unsigned long esr_val;
+	void (*handler)(unsigned long esr, struct pt_regs *regs);
 };
 
 static const struct sys64_hook sys64_hooks[] = {
@@ -675,7 +675,7 @@ static const struct sys64_hook sys64_hooks[] = {
 };
 
 #ifdef CONFIG_COMPAT
-static bool cp15_cond_valid(unsigned int esr, struct pt_regs *regs)
+static bool cp15_cond_valid(unsigned long esr, struct pt_regs *regs)
 {
 	int cond;
 
@@ -695,7 +695,7 @@ static bool cp15_cond_valid(unsigned int esr, struct pt_regs *regs)
 	return aarch32_opcode_cond_checks[cond](regs->pstate);
 }
 
-static void compat_cntfrq_read_handler(unsigned int esr, struct pt_regs *regs)
+static void compat_cntfrq_read_handler(unsigned long esr, struct pt_regs *regs)
 {
 	int reg = (esr & ESR_ELx_CP15_32_ISS_RT_MASK) >> ESR_ELx_CP15_32_ISS_RT_SHIFT;
 
@@ -712,7 +712,7 @@ static const struct sys64_hook cp15_32_hooks[] = {
 	{},
 };
 
-static void compat_cntvct_read_handler(unsigned int esr, struct pt_regs *regs)
+static void compat_cntvct_read_handler(unsigned long esr, struct pt_regs *regs)
 {
 	int rt = (esr & ESR_ELx_CP15_64_ISS_RT_MASK) >> ESR_ELx_CP15_64_ISS_RT_SHIFT;
 	int rt2 = (esr & ESR_ELx_CP15_64_ISS_RT2_MASK) >> ESR_ELx_CP15_64_ISS_RT2_SHIFT;
@@ -732,7 +732,7 @@ static const struct sys64_hook cp15_64_hooks[] = {
 	{},
 };
 
-void do_cp15instr(unsigned int esr, struct pt_regs *regs)
+void do_cp15instr(unsigned long esr, struct pt_regs *regs)
 {
 	const struct sys64_hook *hook, *hook_base;
 
@@ -773,7 +773,7 @@ void do_cp15instr(unsigned int esr, struct pt_regs *regs)
 NOKPROBE_SYMBOL(do_cp15instr);
 #endif
 
-void do_sysinstr(unsigned int esr, struct pt_regs *regs)
+void do_sysinstr(unsigned long esr, struct pt_regs *regs)
 {
 	const struct sys64_hook *hook;
 
@@ -837,7 +837,7 @@ static const char *esr_class_str[] = {
 	[ESR_ELx_EC_BRK64]		= "BRK (AArch64)",
 };
 
-const char *esr_get_class_string(u32 esr)
+const char *esr_get_class_string(unsigned long esr)
 {
 	return esr_class_str[ESR_ELx_EC(esr)];
 }
@@ -846,7 +846,7 @@ const char *esr_get_class_string(u32 esr)
  * bad_el0_sync handles unexpected, but potentially recoverable synchronous
  * exceptions taken from EL0.
  */
-void bad_el0_sync(struct pt_regs *regs, int reason, unsigned int esr)
+void bad_el0_sync(struct pt_regs *regs, int reason, unsigned long esr)
 {
 	unsigned long pc = instruction_pointer(regs);
 
@@ -862,7 +862,7 @@ void bad_el0_sync(struct pt_regs *regs, int reason, unsigned int esr)
 DEFINE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack)
 	__aligned(16);
 
-void panic_bad_stack(struct pt_regs *regs, unsigned int esr, unsigned long far)
+void panic_bad_stack(struct pt_regs *regs, unsigned long esr, unsigned long far)
 {
 	unsigned long tsk_stk = (unsigned long)current->stack;
 	unsigned long irq_stk = (unsigned long)this_cpu_read(irq_stack_ptr);
@@ -871,7 +871,7 @@ void panic_bad_stack(struct pt_regs *regs, unsigned int esr, unsigned long far)
 	console_verbose();
 	pr_emerg("Insufficient stack space to handle exception!");
 
-	pr_emerg("ESR: 0x%08x -- %s\n", esr, esr_get_class_string(esr));
+	pr_emerg("ESR: 0x%016lx -- %s\n", esr, esr_get_class_string(esr));
 	pr_emerg("FAR: 0x%016lx\n", far);
 
 	pr_emerg("Task stack:     [0x%016lx..0x%016lx]\n",
@@ -892,11 +892,11 @@ void panic_bad_stack(struct pt_regs *regs, unsigned int esr, unsigned long far)
 }
 #endif
 
-void __noreturn arm64_serror_panic(struct pt_regs *regs, u32 esr)
+void __noreturn arm64_serror_panic(struct pt_regs *regs, unsigned long esr)
 {
 	console_verbose();
 
-	pr_crit("SError Interrupt on CPU%d, code 0x%08x -- %s\n",
+	pr_crit("SError Interrupt on CPU%d, code 0x%016lx -- %s\n",
 		smp_processor_id(), esr, esr_get_class_string(esr));
 	if (regs)
 		__show_regs(regs);
@@ -907,9 +907,9 @@ void __noreturn arm64_serror_panic(struct pt_regs *regs, u32 esr)
 	unreachable();
 }
 
-bool arm64_is_fatal_ras_serror(struct pt_regs *regs, unsigned int esr)
+bool arm64_is_fatal_ras_serror(struct pt_regs *regs, unsigned long esr)
 {
-	u32 aet = arm64_ras_serror_get_severity(esr);
+	unsigned long aet = arm64_ras_serror_get_severity(esr);
 
 	switch (aet) {
 	case ESR_ELx_AET_CE:	/* corrected error */
@@ -939,7 +939,7 @@ bool arm64_is_fatal_ras_serror(struct pt_regs *regs, unsigned int esr)
 	}
 }
 
-void do_serror(struct pt_regs *regs, unsigned int esr)
+void do_serror(struct pt_regs *regs, unsigned long esr)
 {
 	/* non-RAS errors are not containable */
 	if (!arm64_is_ras_serror(esr) || arm64_is_fatal_ras_serror(regs, esr))
@@ -960,7 +960,7 @@ int is_valid_bugaddr(unsigned long addr)
 	return 1;
 }
 
-static int bug_handler(struct pt_regs *regs, unsigned int esr)
+static int bug_handler(struct pt_regs *regs, unsigned long esr)
 {
 	switch (report_bug(regs->pc, regs)) {
 	case BUG_TRAP_TYPE_BUG:
@@ -985,7 +985,7 @@ static struct break_hook bug_break_hook = {
 	.imm = BUG_BRK_IMM,
 };
 
-static int reserved_fault_handler(struct pt_regs *regs, unsigned int esr)
+static int reserved_fault_handler(struct pt_regs *regs, unsigned long esr)
 {
 	pr_err("%s generated an invalid instruction at %pS!\n",
 		"Kernel text patching",
@@ -1007,7 +1007,7 @@ static struct break_hook fault_break_hook = {
 #define KASAN_ESR_SIZE_MASK	0x0f
 #define KASAN_ESR_SIZE(esr)	(1 << ((esr) & KASAN_ESR_SIZE_MASK))
 
-static int kasan_handler(struct pt_regs *regs, unsigned int esr)
+static int kasan_handler(struct pt_regs *regs, unsigned long esr)
 {
 	bool recover = esr & KASAN_ESR_RECOVER;
 	bool write = esr & KASAN_ESR_WRITE;
@@ -1050,11 +1050,11 @@ static struct break_hook kasan_break_hook = {
  * Initial handler for AArch64 BRK exceptions
  * This handler only used until debug_traps_init().
  */
-int __init early_brk64(unsigned long addr, unsigned int esr,
+int __init early_brk64(unsigned long addr, unsigned long esr,
 		struct pt_regs *regs)
 {
 #ifdef CONFIG_KASAN_SW_TAGS
-	unsigned int comment = esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
+	unsigned long comment = esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
 
 	if ((comment & ~KASAN_BRK_MASK) == KASAN_BRK_IMM)
 		return kasan_handler(regs, esr) != DBG_HOOK_HANDLED;
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 9ae24e3b72be..e38e7dc0f8f5 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -43,7 +43,7 @@
 #include <asm/traps.h>
 
 struct fault_info {
-	int	(*fn)(unsigned long far, unsigned int esr,
+	int	(*fn)(unsigned long far, unsigned long esr,
 		      struct pt_regs *regs);
 	int	sig;
 	int	code;
@@ -53,17 +53,17 @@ struct fault_info {
 static const struct fault_info fault_info[];
 static struct fault_info debug_fault_info[];
 
-static inline const struct fault_info *esr_to_fault_info(unsigned int esr)
+static inline const struct fault_info *esr_to_fault_info(unsigned long esr)
 {
 	return fault_info + (esr & ESR_ELx_FSC);
 }
 
-static inline const struct fault_info *esr_to_debug_fault_info(unsigned int esr)
+static inline const struct fault_info *esr_to_debug_fault_info(unsigned long esr)
 {
 	return debug_fault_info + DBG_ESR_EVT(esr);
 }
 
-static void data_abort_decode(unsigned int esr)
+static void data_abort_decode(unsigned long esr)
 {
 	pr_alert("Data abort info:\n");
 
@@ -85,11 +85,11 @@ static void data_abort_decode(unsigned int esr)
 		 (esr & ESR_ELx_WNR) >> ESR_ELx_WNR_SHIFT);
 }
 
-static void mem_abort_decode(unsigned int esr)
+static void mem_abort_decode(unsigned long esr)
 {
 	pr_alert("Mem abort info:\n");
 
-	pr_alert("  ESR = 0x%08x\n", esr);
+	pr_alert("  ESR = 0x%016lx\n", esr);
 	pr_alert("  EC = 0x%02lx: %s, IL = %u bits\n",
 		 ESR_ELx_EC(esr), esr_get_class_string(esr),
 		 (esr & ESR_ELx_IL) ? 32 : 16);
@@ -99,7 +99,7 @@ static void mem_abort_decode(unsigned int esr)
 	pr_alert("  EA = %lu, S1PTW = %lu\n",
 		 (esr & ESR_ELx_EA) >> ESR_ELx_EA_SHIFT,
 		 (esr & ESR_ELx_S1PTW) >> ESR_ELx_S1PTW_SHIFT);
-	pr_alert("  FSC = 0x%02x: %s\n", (esr & ESR_ELx_FSC),
+	pr_alert("  FSC = 0x%02lx: %s\n", (esr & ESR_ELx_FSC),
 		 esr_to_fault_info(esr)->name);
 
 	if (esr_is_data_abort(esr))
@@ -229,20 +229,20 @@ int ptep_set_access_flags(struct vm_area_struct *vma,
 	return 1;
 }
 
-static bool is_el1_instruction_abort(unsigned int esr)
+static bool is_el1_instruction_abort(unsigned long esr)
 {
 	return ESR_ELx_EC(esr) == ESR_ELx_EC_IABT_CUR;
 }
 
-static bool is_el1_data_abort(unsigned int esr)
+static bool is_el1_data_abort(unsigned long esr)
 {
 	return ESR_ELx_EC(esr) == ESR_ELx_EC_DABT_CUR;
 }
 
-static inline bool is_el1_permission_fault(unsigned long addr, unsigned int esr,
+static inline bool is_el1_permission_fault(unsigned long addr, unsigned long esr,
 					   struct pt_regs *regs)
 {
-	unsigned int fsc_type = esr & ESR_ELx_FSC_TYPE;
+	unsigned long fsc_type = esr & ESR_ELx_FSC_TYPE;
 
 	if (!is_el1_data_abort(esr) && !is_el1_instruction_abort(esr))
 		return false;
@@ -258,7 +258,7 @@ static inline bool is_el1_permission_fault(unsigned long addr, unsigned int esr,
 }
 
 static bool __kprobes is_spurious_el1_translation_fault(unsigned long addr,
-							unsigned int esr,
+							unsigned long esr,
 							struct pt_regs *regs)
 {
 	unsigned long flags;
@@ -290,7 +290,7 @@ static bool __kprobes is_spurious_el1_translation_fault(unsigned long addr,
 }
 
 static void die_kernel_fault(const char *msg, unsigned long addr,
-			     unsigned int esr, struct pt_regs *regs)
+			     unsigned long esr, struct pt_regs *regs)
 {
 	bust_spinlocks(1);
 
@@ -306,7 +306,7 @@ static void die_kernel_fault(const char *msg, unsigned long addr,
 }
 
 #ifdef CONFIG_KASAN_HW_TAGS
-static void report_tag_fault(unsigned long addr, unsigned int esr,
+static void report_tag_fault(unsigned long addr, unsigned long esr,
 			     struct pt_regs *regs)
 {
 	/*
@@ -318,11 +318,11 @@ static void report_tag_fault(unsigned long addr, unsigned int esr,
 }
 #else
 /* Tag faults aren't enabled without CONFIG_KASAN_HW_TAGS. */
-static inline void report_tag_fault(unsigned long addr, unsigned int esr,
+static inline void report_tag_fault(unsigned long addr, unsigned long esr,
 				    struct pt_regs *regs) { }
 #endif
 
-static void do_tag_recovery(unsigned long addr, unsigned int esr,
+static void do_tag_recovery(unsigned long addr, unsigned long esr,
 			   struct pt_regs *regs)
 {
 
@@ -337,9 +337,9 @@ static void do_tag_recovery(unsigned long addr, unsigned int esr,
 	isb();
 }
 
-static bool is_el1_mte_sync_tag_check_fault(unsigned int esr)
+static bool is_el1_mte_sync_tag_check_fault(unsigned long esr)
 {
-	unsigned int fsc = esr & ESR_ELx_FSC;
+	unsigned long fsc = esr & ESR_ELx_FSC;
 
 	if (!is_el1_data_abort(esr))
 		return false;
@@ -350,7 +350,7 @@ static bool is_el1_mte_sync_tag_check_fault(unsigned int esr)
 	return false;
 }
 
-static void __do_kernel_fault(unsigned long addr, unsigned int esr,
+static void __do_kernel_fault(unsigned long addr, unsigned long esr,
 			      struct pt_regs *regs)
 {
 	const char *msg;
@@ -391,7 +391,7 @@ static void __do_kernel_fault(unsigned long addr, unsigned int esr,
 	die_kernel_fault(msg, addr, esr, regs);
 }
 
-static void set_thread_esr(unsigned long address, unsigned int esr)
+static void set_thread_esr(unsigned long address, unsigned long esr)
 {
 	current->thread.fault_address = address;
 
@@ -439,7 +439,7 @@ static void set_thread_esr(unsigned long address, unsigned int esr)
 			 * exception level). Fail safe by not providing an ESR
 			 * context record at all.
 			 */
-			WARN(1, "ESR 0x%x is not DABT or IABT from EL0\n", esr);
+			WARN(1, "ESR 0x%lx is not DABT or IABT from EL0\n", esr);
 			esr = 0;
 			break;
 		}
@@ -448,7 +448,7 @@ static void set_thread_esr(unsigned long address, unsigned int esr)
 	current->thread.fault_code = esr;
 }
 
-static void do_bad_area(unsigned long far, unsigned int esr,
+static void do_bad_area(unsigned long far, unsigned long esr,
 			struct pt_regs *regs)
 {
 	unsigned long addr = untagged_addr(far);
@@ -499,7 +499,7 @@ static vm_fault_t __do_page_fault(struct mm_struct *mm, unsigned long addr,
 	return handle_mm_fault(vma, addr, mm_flags, regs);
 }
 
-static bool is_el0_instruction_abort(unsigned int esr)
+static bool is_el0_instruction_abort(unsigned long esr)
 {
 	return ESR_ELx_EC(esr) == ESR_ELx_EC_IABT_LOW;
 }
@@ -508,12 +508,12 @@ static bool is_el0_instruction_abort(unsigned int esr)
  * Note: not valid for EL1 DC IVAC, but we never use that such that it
  * should fault. EL0 cannot issue DC IVAC (undef).
  */
-static bool is_write_abort(unsigned int esr)
+static bool is_write_abort(unsigned long esr)
 {
 	return (esr & ESR_ELx_WNR) && !(esr & ESR_ELx_CM);
 }
 
-static int __kprobes do_page_fault(unsigned long far, unsigned int esr,
+static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
 				   struct pt_regs *regs)
 {
 	const struct fault_info *inf;
@@ -671,7 +671,7 @@ static int __kprobes do_page_fault(unsigned long far, unsigned int esr,
 }
 
 static int __kprobes do_translation_fault(unsigned long far,
-					  unsigned int esr,
+					  unsigned long esr,
 					  struct pt_regs *regs)
 {
 	unsigned long addr = untagged_addr(far);
@@ -683,19 +683,19 @@ static int __kprobes do_translation_fault(unsigned long far,
 	return 0;
 }
 
-static int do_alignment_fault(unsigned long far, unsigned int esr,
+static int do_alignment_fault(unsigned long far, unsigned long esr,
 			      struct pt_regs *regs)
 {
 	do_bad_area(far, esr, regs);
 	return 0;
 }
 
-static int do_bad(unsigned long far, unsigned int esr, struct pt_regs *regs)
+static int do_bad(unsigned long far, unsigned long esr, struct pt_regs *regs)
 {
 	return 1; /* "fault" */
 }
 
-static int do_sea(unsigned long far, unsigned int esr, struct pt_regs *regs)
+static int do_sea(unsigned long far, unsigned long esr, struct pt_regs *regs)
 {
 	const struct fault_info *inf;
 	unsigned long siaddr;
@@ -725,7 +725,7 @@ static int do_sea(unsigned long far, unsigned int esr, struct pt_regs *regs)
 	return 0;
 }
 
-static int do_tag_check_fault(unsigned long far, unsigned int esr,
+static int do_tag_check_fault(unsigned long far, unsigned long esr,
 			      struct pt_regs *regs)
 {
 	/*
@@ -805,7 +805,7 @@ static const struct fault_info fault_info[] = {
 	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 63"			},
 };
 
-void do_mem_abort(unsigned long far, unsigned int esr, struct pt_regs *regs)
+void do_mem_abort(unsigned long far, unsigned long esr, struct pt_regs *regs)
 {
 	const struct fault_info *inf = esr_to_fault_info(esr);
 	unsigned long addr = untagged_addr(far);
@@ -828,14 +828,14 @@ void do_mem_abort(unsigned long far, unsigned int esr, struct pt_regs *regs)
 }
 NOKPROBE_SYMBOL(do_mem_abort);
 
-void do_sp_pc_abort(unsigned long addr, unsigned int esr, struct pt_regs *regs)
+void do_sp_pc_abort(unsigned long addr, unsigned long esr, struct pt_regs *regs)
 {
 	arm64_notify_die("SP/PC alignment exception", regs, SIGBUS, BUS_ADRALN,
 			 addr, esr);
 }
 NOKPROBE_SYMBOL(do_sp_pc_abort);
 
-int __init early_brk64(unsigned long addr, unsigned int esr,
+int __init early_brk64(unsigned long addr, unsigned long esr,
 		       struct pt_regs *regs);
 
 /*
@@ -855,7 +855,7 @@ static struct fault_info __refdata debug_fault_info[] = {
 };
 
 void __init hook_debug_fault_code(int nr,
-				  int (*fn)(unsigned long, unsigned int, struct pt_regs *),
+				  int (*fn)(unsigned long, unsigned long, struct pt_regs *),
 				  int sig, int code, const char *name)
 {
 	BUG_ON(nr < 0 || nr >= ARRAY_SIZE(debug_fault_info));
@@ -888,7 +888,7 @@ static void debug_exception_exit(struct pt_regs *regs)
 }
 NOKPROBE_SYMBOL(debug_exception_exit);
 
-void do_debug_exception(unsigned long addr_if_watchpoint, unsigned int esr,
+void do_debug_exception(unsigned long addr_if_watchpoint, unsigned long esr,
 			struct pt_regs *regs)
 {
 	const struct fault_info *inf = esr_to_debug_fault_info(esr);
-- 
2.35.1



