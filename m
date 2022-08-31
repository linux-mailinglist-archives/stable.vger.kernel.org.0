Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370505A8327
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 18:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbiHaQ1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 12:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbiHaQ0n (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 12:26:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7981BA832D;
        Wed, 31 Aug 2022 09:26:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C59AB821E7;
        Wed, 31 Aug 2022 16:26:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A17AC433D6;
        Wed, 31 Aug 2022 16:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661963196;
        bh=pVN/3l1oxMEYH2E6auo5MEUHX04imm75OgTp+CsqFpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vVT8piwJAXRjkrGEqITMWzFdJ1ZXZ92mBOCjaCIYAmGjAnPIZiFOg5oOfZuS0iUrv
         nbjZeen+M1pGUe6SpdD4D9GEXq5wZdicnkCn3F3CvFC8w03Pgncckxyde0z0E5F21e
         HaTk49EIABYDlmWmjrBwLA8LPty+nHvlryU2ER+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.64
Date:   Wed, 31 Aug 2022 18:26:23 +0200
Message-Id: <1661963182244244@kroah.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <166196318220670@kroah.com>
References: <166196318220670@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index eda519519f12..a7362b1096c4 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -521,6 +521,7 @@ What:		/sys/devices/system/cpu/vulnerabilities
 		/sys/devices/system/cpu/vulnerabilities/tsx_async_abort
 		/sys/devices/system/cpu/vulnerabilities/itlb_multihit
 		/sys/devices/system/cpu/vulnerabilities/mmio_stale_data
+		/sys/devices/system/cpu/vulnerabilities/retbleed
 Date:		January 2018
 Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
 Description:	Information about CPU vulnerabilities
diff --git a/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst b/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst
index 9393c50b5afc..c98fd11907cc 100644
--- a/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst
+++ b/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst
@@ -230,6 +230,20 @@ The possible values in this file are:
      * - 'Mitigation: Clear CPU buffers'
        - The processor is vulnerable and the CPU buffer clearing mitigation is
          enabled.
+     * - 'Unknown: No mitigations'
+       - The processor vulnerability status is unknown because it is
+	 out of Servicing period. Mitigation is not attempted.
+
+Definitions:
+------------
+
+Servicing period: The process of providing functional and security updates to
+Intel processors or platforms, utilizing the Intel Platform Update (IPU)
+process or other similar mechanisms.
+
+End of Servicing Updates (ESU): ESU is the date at which Intel will no
+longer provide Servicing, such as through IPU or other similar update
+processes. ESU dates will typically be aligned to end of quarter.
 
 If the processor is vulnerable then the following information is appended to
 the above information:
diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index 4150f74c521a..5310f398794c 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -271,7 +271,7 @@ poll cycle or the number of packets processed reaches netdev_budget.
 netdev_max_backlog
 ------------------
 
-Maximum number  of  packets,  queued  on  the  INPUT  side, when the interface
+Maximum number of packets, queued on the INPUT side, when the interface
 receives packets faster than kernel can process them.
 
 netdev_rss_key
diff --git a/Makefile b/Makefile
index ea669530ec86..b2b65f7c168c 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 63
+SUBLEVEL = 64
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index c67c19d70159..292a3091b5de 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -208,6 +208,8 @@ static const struct arm64_cpu_capabilities arm64_repeat_tlbi_list[] = {
 #ifdef CONFIG_ARM64_ERRATUM_1286807
 	{
 		ERRATA_MIDR_RANGE(MIDR_CORTEX_A76, 0, 0, 3, 0),
+	},
+	{
 		/* Kryo4xx Gold (rcpe to rfpe) => (r0p0 to r3p0) */
 		ERRATA_MIDR_RANGE(MIDR_QCOM_KRYO_4XX_GOLD, 0xc, 0xe, 0xf, 0xe),
 	},
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 5dccf01a9e17..e6542e44cade 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -142,10 +142,10 @@ menu "Processor type and features"
 
 choice
 	prompt "Processor type"
-	default PA7000
+	default PA7000 if "$(ARCH)" = "parisc"
 
 config PA7000
-	bool "PA7000/PA7100"
+	bool "PA7000/PA7100" if "$(ARCH)" = "parisc"
 	help
 	  This is the processor type of your CPU.  This information is
 	  used for optimizing purposes.  In order to compile a kernel
@@ -156,21 +156,21 @@ config PA7000
 	  which is required on some machines.
 
 config PA7100LC
-	bool "PA7100LC"
+	bool "PA7100LC" if "$(ARCH)" = "parisc"
 	help
 	  Select this option for the PCX-L processor, as used in the
 	  712, 715/64, 715/80, 715/100, 715/100XC, 725/100, 743, 748,
 	  D200, D210, D300, D310 and E-class
 
 config PA7200
-	bool "PA7200"
+	bool "PA7200" if "$(ARCH)" = "parisc"
 	help
 	  Select this option for the PCX-T' processor, as used in the
 	  C100, C110, J100, J110, J210XC, D250, D260, D350, D360,
 	  K100, K200, K210, K220, K400, K410 and K420
 
 config PA7300LC
-	bool "PA7300LC"
+	bool "PA7300LC" if "$(ARCH)" = "parisc"
 	help
 	  Select this option for the PCX-L2 processor, as used in the
 	  744, A180, B132L, B160L, B180L, C132L, C160L, C180L,
@@ -220,17 +220,8 @@ config MLONGCALLS
 	  Enabling this option will probably slow down your kernel.
 
 config 64BIT
-	bool "64-bit kernel"
+	def_bool "$(ARCH)" = "parisc64"
 	depends on PA8X00
-	help
-	  Enable this if you want to support 64bit kernel on PA-RISC platform.
-
-	  At the moment, only people willing to use more than 2GB of RAM,
-	  or having a 64bit-only capable PA-RISC machine should say Y here.
-
-	  Since there is no 64bit userland on PA-RISC, there is no point to
-	  enable this option otherwise. The 64bit kernel is significantly bigger
-	  and slower than the 32bit one.
 
 choice
 	prompt "Kernel page size"
diff --git a/arch/parisc/kernel/unaligned.c b/arch/parisc/kernel/unaligned.c
index 286cec4d86d7..cc6ed7496050 100644
--- a/arch/parisc/kernel/unaligned.c
+++ b/arch/parisc/kernel/unaligned.c
@@ -107,7 +107,7 @@
 #define R1(i) (((i)>>21)&0x1f)
 #define R2(i) (((i)>>16)&0x1f)
 #define R3(i) ((i)&0x1f)
-#define FR3(i) ((((i)<<1)&0x1f)|(((i)>>6)&1))
+#define FR3(i) ((((i)&0x1f)<<1)|(((i)>>6)&1))
 #define IM(i,n) (((i)>>1&((1<<(n-1))-1))|((i)&1?((0-1L)<<(n-1)):0))
 #define IM5_2(i) IM((i)>>16,5)
 #define IM5_3(i) IM((i),5)
diff --git a/arch/riscv/include/asm/thread_info.h b/arch/riscv/include/asm/thread_info.h
index 74d888c8d631..e3866ffa06c5 100644
--- a/arch/riscv/include/asm/thread_info.h
+++ b/arch/riscv/include/asm/thread_info.h
@@ -42,6 +42,8 @@
 
 #ifndef __ASSEMBLY__
 
+extern long shadow_stack[SHADOW_OVERFLOW_STACK_SIZE / sizeof(long)];
+
 #include <asm/processor.h>
 #include <asm/csr.h>
 
diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index b938ffe129d6..8c58aa5d2b36 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -20,9 +20,10 @@
 
 #include <asm/asm-prototypes.h>
 #include <asm/bug.h>
+#include <asm/csr.h>
 #include <asm/processor.h>
 #include <asm/ptrace.h>
-#include <asm/csr.h>
+#include <asm/thread_info.h>
 
 int show_unhandled_signals = 1;
 
diff --git a/arch/riscv/lib/uaccess.S b/arch/riscv/lib/uaccess.S
index 63bc691cff91..2c7c1c5026af 100644
--- a/arch/riscv/lib/uaccess.S
+++ b/arch/riscv/lib/uaccess.S
@@ -173,6 +173,13 @@ ENTRY(__asm_copy_from_user)
 	csrc CSR_STATUS, t6
 	li	a0, 0
 	ret
+
+	/* Exception fixup code */
+10:
+	/* Disable access to user memory */
+	csrc CSR_STATUS, t6
+	mv a0, t5
+	ret
 ENDPROC(__asm_copy_to_user)
 ENDPROC(__asm_copy_from_user)
 EXPORT_SYMBOL(__asm_copy_to_user)
@@ -218,19 +225,12 @@ ENTRY(__clear_user)
 	addi a0, a0, 1
 	bltu a0, a3, 5b
 	j 3b
-ENDPROC(__clear_user)
-EXPORT_SYMBOL(__clear_user)
 
-	.section .fixup,"ax"
-	.balign 4
-	/* Fixup code for __copy_user(10) and __clear_user(11) */
-10:
-	/* Disable access to user memory */
-	csrs CSR_STATUS, t6
-	mv a0, t5
-	ret
+	/* Exception fixup code */
 11:
-	csrs CSR_STATUS, t6
+	/* Disable access to user memory */
+	csrc CSR_STATUS, t6
 	mv a0, a1
 	ret
-	.previous
+ENDPROC(__clear_user)
+EXPORT_SYMBOL(__clear_user)
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 350e94d0cac2..d015cb1027fa 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -91,6 +91,18 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 
 	memcpy(dst, src, arch_task_struct_size);
 	dst->thread.fpu.regs = dst->thread.fpu.fprs;
+
+	/*
+	 * Don't transfer over the runtime instrumentation or the guarded
+	 * storage control block pointers. These fields are cleared here instead
+	 * of in copy_thread() to avoid premature freeing of associated memory
+	 * on fork() failure. Wait to clear the RI flag because ->stack still
+	 * refers to the source thread.
+	 */
+	dst->thread.ri_cb = NULL;
+	dst->thread.gs_cb = NULL;
+	dst->thread.gs_bc_cb = NULL;
+
 	return 0;
 }
 
@@ -149,13 +161,11 @@ int copy_thread(unsigned long clone_flags, unsigned long new_stackp,
 	frame->childregs.flags = 0;
 	if (new_stackp)
 		frame->childregs.gprs[15] = new_stackp;
-
-	/* Don't copy runtime instrumentation info */
-	p->thread.ri_cb = NULL;
+	/*
+	 * Clear the runtime instrumentation flag after the above childregs
+	 * copy. The CB pointer was already cleared in arch_dup_task_struct().
+	 */
 	frame->childregs.psw.mask &= ~PSW_MASK_RI;
-	/* Don't copy guarded storage control block */
-	p->thread.gs_cb = NULL;
-	p->thread.gs_bc_cb = NULL;
 
 	/* Set a new TLS ?  */
 	if (clone_flags & CLONE_SETTLS) {
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 212632d57db9..c930dff312df 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -397,7 +397,9 @@ static inline vm_fault_t do_exception(struct pt_regs *regs, int access)
 	flags = FAULT_FLAG_DEFAULT;
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
-	if (access == VM_WRITE || is_write)
+	if (is_write)
+		access = VM_WRITE;
+	if (access == VM_WRITE)
 		flags |= FAULT_FLAG_WRITE;
 	mmap_read_lock(mm);
 
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 763ff243aeca..a3af2a9159b1 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -373,6 +373,7 @@ SYM_CODE_END(xen_error_entry)
 SYM_CODE_START(\asmsym)
 	UNWIND_HINT_IRET_REGS offset=\has_error_code*8
 	ASM_CLAC
+	cld
 
 	.if \has_error_code == 0
 		pushq	$-1			/* ORIG_RAX: no syscall to restart */
@@ -440,6 +441,7 @@ SYM_CODE_END(\asmsym)
 SYM_CODE_START(\asmsym)
 	UNWIND_HINT_IRET_REGS
 	ASM_CLAC
+	cld
 
 	pushq	$-1			/* ORIG_RAX: no syscall to restart */
 
@@ -495,6 +497,7 @@ SYM_CODE_END(\asmsym)
 SYM_CODE_START(\asmsym)
 	UNWIND_HINT_IRET_REGS
 	ASM_CLAC
+	cld
 
 	/*
 	 * If the entry is from userspace, switch stacks and treat it as
@@ -557,6 +560,7 @@ SYM_CODE_END(\asmsym)
 SYM_CODE_START(\asmsym)
 	UNWIND_HINT_IRET_REGS offset=8
 	ASM_CLAC
+	cld
 
 	/* paranoid_entry returns GS information for paranoid_exit in EBX. */
 	call	paranoid_entry
@@ -876,7 +880,6 @@ SYM_CODE_END(xen_failsafe_callback)
  */
 SYM_CODE_START_LOCAL(paranoid_entry)
 	UNWIND_HINT_FUNC
-	cld
 	PUSH_AND_CLEAR_REGS save_ret=1
 	ENCODE_FRAME_POINTER 8
 
@@ -1012,7 +1015,6 @@ SYM_CODE_END(paranoid_exit)
  */
 SYM_CODE_START_LOCAL(error_entry)
 	UNWIND_HINT_FUNC
-	cld
 
 	PUSH_AND_CLEAR_REGS save_ret=1
 	ENCODE_FRAME_POINTER 8
@@ -1155,6 +1157,7 @@ SYM_CODE_START(asm_exc_nmi)
 	 */
 
 	ASM_CLAC
+	cld
 
 	/* Use %rdx as our temp variable throughout */
 	pushq	%rdx
@@ -1174,7 +1177,6 @@ SYM_CODE_START(asm_exc_nmi)
 	 */
 
 	swapgs
-	cld
 	FENCE_SWAPGS_USER_ENTRY
 	SWITCH_TO_KERNEL_CR3 scratch_reg=%rdx
 	movq	%rsp, %rdx
diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 4dbb55a43dad..266ac8263696 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -236,6 +236,7 @@ static u64 load_latency_data(u64 status)
 static u64 store_latency_data(u64 status)
 {
 	union intel_x86_pebs_dse dse;
+	union perf_mem_data_src src;
 	u64 val;
 
 	dse.val = status;
@@ -263,7 +264,14 @@ static u64 store_latency_data(u64 status)
 
 	val |= P(BLK, NA);
 
-	return val;
+	/*
+	 * the pebs_data_source table is only for loads
+	 * so override the mem_op to say STORE instead
+	 */
+	src.val = val;
+	src.mem_op = P(OP,STORE);
+
+	return src.val;
 }
 
 struct pebs_record_core {
diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index f455dd93f921..673721387391 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1114,6 +1114,14 @@ static int intel_pmu_setup_hw_lbr_filter(struct perf_event *event)
 
 	if (static_cpu_has(X86_FEATURE_ARCH_LBR)) {
 		reg->config = mask;
+
+		/*
+		 * The Arch LBR HW can retrieve the common branch types
+		 * from the LBR_INFO. It doesn't require the high overhead
+		 * SW disassemble.
+		 * Enable the branch type by default for the Arch LBR.
+		 */
+		reg->reg |= X86_BR_TYPE_SAVE;
 		return 0;
 	}
 
diff --git a/arch/x86/events/intel/uncore_snb.c b/arch/x86/events/intel/uncore_snb.c
index 0f63706cdadf..dc3ae55f79e0 100644
--- a/arch/x86/events/intel/uncore_snb.c
+++ b/arch/x86/events/intel/uncore_snb.c
@@ -788,6 +788,22 @@ int snb_pci2phy_map_init(int devid)
 	return 0;
 }
 
+static u64 snb_uncore_imc_read_counter(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	/*
+	 * SNB IMC counters are 32-bit and are laid out back to back
+	 * in MMIO space. Therefore we must use a 32-bit accessor function
+	 * using readq() from uncore_mmio_read_counter() causes problems
+	 * because it is reading 64-bit at a time. This is okay for the
+	 * uncore_perf_event_update() function because it drops the upper
+	 * 32-bits but not okay for plain uncore_read_counter() as invoked
+	 * in uncore_pmu_event_start().
+	 */
+	return (u64)readl(box->io_addr + hwc->event_base);
+}
+
 static struct pmu snb_uncore_imc_pmu = {
 	.task_ctx_nr	= perf_invalid_context,
 	.event_init	= snb_uncore_imc_event_init,
@@ -807,7 +823,7 @@ static struct intel_uncore_ops snb_uncore_imc_ops = {
 	.disable_event	= snb_uncore_imc_disable_event,
 	.enable_event	= snb_uncore_imc_enable_event,
 	.hw_config	= snb_uncore_imc_hw_config,
-	.read_counter	= uncore_mmio_read_counter,
+	.read_counter	= snb_uncore_imc_read_counter,
 };
 
 static struct intel_uncore_type snb_uncore_imc = {
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index be744fa10004..2b56bfef9917 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -446,7 +446,8 @@
 #define X86_BUG_ITLB_MULTIHIT		X86_BUG(23) /* CPU may incur MCE during certain page attribute changes */
 #define X86_BUG_SRBDS			X86_BUG(24) /* CPU may leak RNG bits if not mitigated */
 #define X86_BUG_MMIO_STALE_DATA		X86_BUG(25) /* CPU is affected by Processor MMIO Stale Data vulnerabilities */
-#define X86_BUG_RETBLEED		X86_BUG(26) /* CPU is affected by RETBleed */
-#define X86_BUG_EIBRS_PBRSB		X86_BUG(27) /* EIBRS is vulnerable to Post Barrier RSB Predictions */
+#define X86_BUG_MMIO_UNKNOWN		X86_BUG(26) /* CPU is too old and its MMIO Stale Data status is unknown */
+#define X86_BUG_RETBLEED		X86_BUG(27) /* CPU is affected by RETBleed */
+#define X86_BUG_EIBRS_PBRSB		X86_BUG(28) /* EIBRS is vulnerable to Post Barrier RSB Predictions */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 6a59b2d58a3a..f5ce9a0ab233 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -35,33 +35,56 @@
 #define RSB_CLEAR_LOOPS		32	/* To forcibly overwrite all entries */
 
 /*
+ * Common helper for __FILL_RETURN_BUFFER and __FILL_ONE_RETURN.
+ */
+#define __FILL_RETURN_SLOT			\
+	ANNOTATE_INTRA_FUNCTION_CALL;		\
+	call	772f;				\
+	int3;					\
+772:
+
+/*
+ * Stuff the entire RSB.
+ *
  * Google experimented with loop-unrolling and this turned out to be
  * the optimal version - two calls, each with their own speculation
  * trap should their return address end up getting used, in a loop.
  */
-#define __FILL_RETURN_BUFFER(reg, nr, sp)	\
-	mov	$(nr/2), reg;			\
-771:						\
-	ANNOTATE_INTRA_FUNCTION_CALL;		\
-	call	772f;				\
-773:	/* speculation trap */			\
-	UNWIND_HINT_EMPTY;			\
-	pause;					\
-	lfence;					\
-	jmp	773b;				\
-772:						\
-	ANNOTATE_INTRA_FUNCTION_CALL;		\
-	call	774f;				\
-775:	/* speculation trap */			\
-	UNWIND_HINT_EMPTY;			\
-	pause;					\
-	lfence;					\
-	jmp	775b;				\
-774:						\
-	add	$(BITS_PER_LONG/8) * 2, sp;	\
-	dec	reg;				\
-	jnz	771b;				\
-	/* barrier for jnz misprediction */	\
+#ifdef CONFIG_X86_64
+#define __FILL_RETURN_BUFFER(reg, nr)			\
+	mov	$(nr/2), reg;				\
+771:							\
+	__FILL_RETURN_SLOT				\
+	__FILL_RETURN_SLOT				\
+	add	$(BITS_PER_LONG/8) * 2, %_ASM_SP;	\
+	dec	reg;					\
+	jnz	771b;					\
+	/* barrier for jnz misprediction */		\
+	lfence;
+#else
+/*
+ * i386 doesn't unconditionally have LFENCE, as such it can't
+ * do a loop.
+ */
+#define __FILL_RETURN_BUFFER(reg, nr)			\
+	.rept nr;					\
+	__FILL_RETURN_SLOT;				\
+	.endr;						\
+	add	$(BITS_PER_LONG/8) * nr, %_ASM_SP;
+#endif
+
+/*
+ * Stuff a single RSB slot.
+ *
+ * To mitigate Post-Barrier RSB speculation, one CALL instruction must be
+ * forced to retire before letting a RET instruction execute.
+ *
+ * On PBRSB-vulnerable CPUs, it is not safe for a RET to be executed
+ * before this point.
+ */
+#define __FILL_ONE_RETURN				\
+	__FILL_RETURN_SLOT				\
+	add	$(BITS_PER_LONG/8), %_ASM_SP;		\
 	lfence;
 
 #ifdef __ASSEMBLY__
@@ -120,28 +143,15 @@
 #endif
 .endm
 
-.macro ISSUE_UNBALANCED_RET_GUARD
-	ANNOTATE_INTRA_FUNCTION_CALL
-	call .Lunbalanced_ret_guard_\@
-	int3
-.Lunbalanced_ret_guard_\@:
-	add $(BITS_PER_LONG/8), %_ASM_SP
-	lfence
-.endm
-
  /*
   * A simpler FILL_RETURN_BUFFER macro. Don't make people use the CPP
   * monstrosity above, manually.
   */
-.macro FILL_RETURN_BUFFER reg:req nr:req ftr:req ftr2
-.ifb \ftr2
-	ALTERNATIVE "jmp .Lskip_rsb_\@", "", \ftr
-.else
-	ALTERNATIVE_2 "jmp .Lskip_rsb_\@", "", \ftr, "jmp .Lunbalanced_\@", \ftr2
-.endif
-	__FILL_RETURN_BUFFER(\reg,\nr,%_ASM_SP)
-.Lunbalanced_\@:
-	ISSUE_UNBALANCED_RET_GUARD
+.macro FILL_RETURN_BUFFER reg:req nr:req ftr:req ftr2=ALT_NOT(X86_FEATURE_ALWAYS)
+	ALTERNATIVE_2 "jmp .Lskip_rsb_\@", \
+		__stringify(__FILL_RETURN_BUFFER(\reg,\nr)), \ftr, \
+		__stringify(__FILL_ONE_RETURN), \ftr2
+
 .Lskip_rsb_\@:
 .endm
 
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 977d9d75e3ad..7b15f7ef760d 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -433,7 +433,8 @@ static void __init mmio_select_mitigation(void)
 	u64 ia32_cap;
 
 	if (!boot_cpu_has_bug(X86_BUG_MMIO_STALE_DATA) ||
-	    cpu_mitigations_off()) {
+	     boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN) ||
+	     cpu_mitigations_off()) {
 		mmio_mitigation = MMIO_MITIGATION_OFF;
 		return;
 	}
@@ -538,6 +539,8 @@ static void __init md_clear_update_mitigation(void)
 		pr_info("TAA: %s\n", taa_strings[taa_mitigation]);
 	if (boot_cpu_has_bug(X86_BUG_MMIO_STALE_DATA))
 		pr_info("MMIO Stale Data: %s\n", mmio_strings[mmio_mitigation]);
+	else if (boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN))
+		pr_info("MMIO Stale Data: Unknown: No mitigations\n");
 }
 
 static void __init md_clear_select_mitigation(void)
@@ -2268,6 +2271,9 @@ static ssize_t tsx_async_abort_show_state(char *buf)
 
 static ssize_t mmio_stale_data_show_state(char *buf)
 {
+	if (boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN))
+		return sysfs_emit(buf, "Unknown: No mitigations\n");
+
 	if (mmio_mitigation == MMIO_MITIGATION_OFF)
 		return sysfs_emit(buf, "%s\n", mmio_strings[mmio_mitigation]);
 
@@ -2414,6 +2420,7 @@ static ssize_t cpu_show_common(struct device *dev, struct device_attribute *attr
 		return srbds_show_state(buf);
 
 	case X86_BUG_MMIO_STALE_DATA:
+	case X86_BUG_MMIO_UNKNOWN:
 		return mmio_stale_data_show_state(buf);
 
 	case X86_BUG_RETBLEED:
@@ -2473,7 +2480,10 @@ ssize_t cpu_show_srbds(struct device *dev, struct device_attribute *attr, char *
 
 ssize_t cpu_show_mmio_stale_data(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	return cpu_show_common(dev, attr, buf, X86_BUG_MMIO_STALE_DATA);
+	if (boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN))
+		return cpu_show_common(dev, attr, buf, X86_BUG_MMIO_UNKNOWN);
+	else
+		return cpu_show_common(dev, attr, buf, X86_BUG_MMIO_STALE_DATA);
 }
 
 ssize_t cpu_show_retbleed(struct device *dev, struct device_attribute *attr, char *buf)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4a538ec413b8..9c1df6222df9 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1027,7 +1027,8 @@ static void identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
 #define NO_SWAPGS		BIT(6)
 #define NO_ITLB_MULTIHIT	BIT(7)
 #define NO_SPECTRE_V2		BIT(8)
-#define NO_EIBRS_PBRSB		BIT(9)
+#define NO_MMIO			BIT(9)
+#define NO_EIBRS_PBRSB		BIT(10)
 
 #define VULNWL(vendor, family, model, whitelist)	\
 	X86_MATCH_VENDOR_FAM_MODEL(vendor, family, model, whitelist)
@@ -1048,6 +1049,11 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 	VULNWL(NSC,	5, X86_MODEL_ANY,	NO_SPECULATION),
 
 	/* Intel Family 6 */
+	VULNWL_INTEL(TIGERLAKE,			NO_MMIO),
+	VULNWL_INTEL(TIGERLAKE_L,		NO_MMIO),
+	VULNWL_INTEL(ALDERLAKE,			NO_MMIO),
+	VULNWL_INTEL(ALDERLAKE_L,		NO_MMIO),
+
 	VULNWL_INTEL(ATOM_SALTWELL,		NO_SPECULATION | NO_ITLB_MULTIHIT),
 	VULNWL_INTEL(ATOM_SALTWELL_TABLET,	NO_SPECULATION | NO_ITLB_MULTIHIT),
 	VULNWL_INTEL(ATOM_SALTWELL_MID,		NO_SPECULATION | NO_ITLB_MULTIHIT),
@@ -1066,9 +1072,9 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 	VULNWL_INTEL(ATOM_AIRMONT_MID,		NO_L1TF | MSBDS_ONLY | NO_SWAPGS | NO_ITLB_MULTIHIT),
 	VULNWL_INTEL(ATOM_AIRMONT_NP,		NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
 
-	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
-	VULNWL_INTEL(ATOM_GOLDMONT_D,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
-	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_EIBRS_PBRSB),
+	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
+	VULNWL_INTEL(ATOM_GOLDMONT_D,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
+	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_EIBRS_PBRSB),
 
 	/*
 	 * Technically, swapgs isn't serializing on AMD (despite it previously
@@ -1083,18 +1089,18 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 	VULNWL_INTEL(ATOM_TREMONT_D,		NO_ITLB_MULTIHIT | NO_EIBRS_PBRSB),
 
 	/* AMD Family 0xf - 0x12 */
-	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
-	VULNWL_AMD(0x10,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
-	VULNWL_AMD(0x11,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
-	VULNWL_AMD(0x12,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
+	VULNWL_AMD(0x10,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
+	VULNWL_AMD(0x11,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
+	VULNWL_AMD(0x12,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
 
 	/* FAMILY_ANY must be last, otherwise 0x0f - 0x12 matches won't work */
-	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
-	VULNWL_HYGON(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
+	VULNWL_HYGON(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
 
 	/* Zhaoxin Family 7 */
-	VULNWL(CENTAUR,	7, X86_MODEL_ANY,	NO_SPECTRE_V2 | NO_SWAPGS),
-	VULNWL(ZHAOXIN,	7, X86_MODEL_ANY,	NO_SPECTRE_V2 | NO_SWAPGS),
+	VULNWL(CENTAUR,	7, X86_MODEL_ANY,	NO_SPECTRE_V2 | NO_SWAPGS | NO_MMIO),
+	VULNWL(ZHAOXIN,	7, X86_MODEL_ANY,	NO_SPECTRE_V2 | NO_SWAPGS | NO_MMIO),
 	{}
 };
 
@@ -1248,10 +1254,16 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 	 * Affected CPU list is generally enough to enumerate the vulnerability,
 	 * but for virtualization case check for ARCH_CAP MSR bits also, VMM may
 	 * not want the guest to enumerate the bug.
+	 *
+	 * Set X86_BUG_MMIO_UNKNOWN for CPUs that are neither in the blacklist,
+	 * nor in the whitelist and also don't enumerate MSR ARCH_CAP MMIO bits.
 	 */
-	if (cpu_matches(cpu_vuln_blacklist, MMIO) &&
-	    !arch_cap_mmio_immune(ia32_cap))
-		setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);
+	if (!arch_cap_mmio_immune(ia32_cap)) {
+		if (cpu_matches(cpu_vuln_blacklist, MMIO))
+			setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);
+		else if (!cpu_matches(cpu_vuln_whitelist, NO_MMIO))
+			setup_force_cpu_bug(X86_BUG_MMIO_UNKNOWN);
+	}
 
 	if (!cpu_has(c, X86_FEATURE_BTC_NO)) {
 		if (cpu_matches(cpu_vuln_blacklist, RETBLEED) || (ia32_cap & ARCH_CAP_RSBA))
diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index a1202536fc57..3423aaea4ad8 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -93,22 +93,27 @@ static struct orc_entry *orc_find(unsigned long ip);
 static struct orc_entry *orc_ftrace_find(unsigned long ip)
 {
 	struct ftrace_ops *ops;
-	unsigned long caller;
+	unsigned long tramp_addr, offset;
 
 	ops = ftrace_ops_trampoline(ip);
 	if (!ops)
 		return NULL;
 
+	/* Set tramp_addr to the start of the code copied by the trampoline */
 	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS)
-		caller = (unsigned long)ftrace_regs_call;
+		tramp_addr = (unsigned long)ftrace_regs_caller;
 	else
-		caller = (unsigned long)ftrace_call;
+		tramp_addr = (unsigned long)ftrace_caller;
+
+	/* Now place tramp_addr to the location within the trampoline ip is at */
+	offset = ip - ops->trampoline;
+	tramp_addr += offset;
 
 	/* Prevent unlikely recursion */
-	if (ip == caller)
+	if (ip == tramp_addr)
 		return NULL;
 
-	return orc_find(caller);
+	return orc_find(tramp_addr);
 }
 #else
 static struct orc_entry *orc_ftrace_find(unsigned long ip)
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 95993c4efa49..1a28ba9017ed 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1400,7 +1400,8 @@ bool blk_mq_dispatch_rq_list(struct blk_mq_hw_ctx *hctx, struct list_head *list,
 	/* If we didn't flush the entire list, we could have told the driver
 	 * there was more coming, but that turned out to be a lie.
 	 */
-	if ((!list_empty(list) || errors) && q->mq_ops->commit_rqs && queued)
+	if ((!list_empty(list) || errors || needs_resource ||
+	     ret == BLK_STS_DEV_RESOURCE) && q->mq_ops->commit_rqs && queued)
 		q->mq_ops->commit_rqs(hctx);
 	/*
 	 * Any items that need requeuing? Stuff them into hctx->dispatch,
@@ -2111,6 +2112,7 @@ void blk_mq_try_issue_list_directly(struct blk_mq_hw_ctx *hctx,
 		list_del_init(&rq->queuelist);
 		ret = blk_mq_request_issue_directly(rq, list_empty(list));
 		if (ret != BLK_STS_OK) {
+			errors++;
 			if (ret == BLK_STS_RESOURCE ||
 					ret == BLK_STS_DEV_RESOURCE) {
 				blk_mq_request_bypass_insert(rq, false,
@@ -2118,7 +2120,6 @@ void blk_mq_try_issue_list_directly(struct blk_mq_hw_ctx *hctx,
 				break;
 			}
 			blk_mq_end_request(rq, ret);
-			errors++;
 		} else
 			queued++;
 	}
diff --git a/drivers/acpi/processor_thermal.c b/drivers/acpi/processor_thermal.c
index a3d34e3f9f94..921a0b5a58e5 100644
--- a/drivers/acpi/processor_thermal.c
+++ b/drivers/acpi/processor_thermal.c
@@ -144,7 +144,7 @@ void acpi_thermal_cpufreq_exit(struct cpufreq_policy *policy)
 	unsigned int cpu;
 
 	for_each_cpu(cpu, policy->related_cpus) {
-		struct acpi_processor *pr = per_cpu(processors, policy->cpu);
+		struct acpi_processor *pr = per_cpu(processors, cpu);
 
 		if (pr)
 			freq_qos_remove_request(&pr->thermal_req);
diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index b398909fda36..bd827533e7e8 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -395,12 +395,15 @@ static struct binder_buffer *binder_alloc_new_buf_locked(
 	size_t size, data_offsets_size;
 	int ret;
 
+	mmap_read_lock(alloc->vma_vm_mm);
 	if (!binder_alloc_get_vma(alloc)) {
+		mmap_read_unlock(alloc->vma_vm_mm);
 		binder_alloc_debug(BINDER_DEBUG_USER_ERROR,
 				   "%d: binder_alloc_buf, no vma\n",
 				   alloc->pid);
 		return ERR_PTR(-ESRCH);
 	}
+	mmap_read_unlock(alloc->vma_vm_mm);
 
 	data_offsets_size = ALIGN(data_size, sizeof(void *)) +
 		ALIGN(offsets_size, sizeof(void *));
@@ -922,17 +925,25 @@ void binder_alloc_print_pages(struct seq_file *m,
 	 * Make sure the binder_alloc is fully initialized, otherwise we might
 	 * read inconsistent state.
 	 */
-	if (binder_alloc_get_vma(alloc) != NULL) {
-		for (i = 0; i < alloc->buffer_size / PAGE_SIZE; i++) {
-			page = &alloc->pages[i];
-			if (!page->page_ptr)
-				free++;
-			else if (list_empty(&page->lru))
-				active++;
-			else
-				lru++;
-		}
+
+	mmap_read_lock(alloc->vma_vm_mm);
+	if (binder_alloc_get_vma(alloc) == NULL) {
+		mmap_read_unlock(alloc->vma_vm_mm);
+		goto uninitialized;
 	}
+
+	mmap_read_unlock(alloc->vma_vm_mm);
+	for (i = 0; i < alloc->buffer_size / PAGE_SIZE; i++) {
+		page = &alloc->pages[i];
+		if (!page->page_ptr)
+			free++;
+		else if (list_empty(&page->lru))
+			active++;
+		else
+			lru++;
+	}
+
+uninitialized:
 	mutex_unlock(&alloc->mutex);
 	seq_printf(m, "  pages: %d:%d:%d\n", active, lru, free);
 	seq_printf(m, "  pages high watermark: %zu\n", alloc->pages_high);
diff --git a/drivers/base/node.c b/drivers/base/node.c
index 0f5319b79fad..5366d1b5359c 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -45,7 +45,7 @@ static inline ssize_t cpumap_read(struct file *file, struct kobject *kobj,
 	return n;
 }
 
-static BIN_ATTR_RO(cpumap, 0);
+static BIN_ATTR_RO(cpumap, CPUMAP_FILE_MAX_BYTES);
 
 static inline ssize_t cpulist_read(struct file *file, struct kobject *kobj,
 				   struct bin_attribute *attr, char *buf,
@@ -66,7 +66,7 @@ static inline ssize_t cpulist_read(struct file *file, struct kobject *kobj,
 	return n;
 }
 
-static BIN_ATTR_RO(cpulist, 0);
+static BIN_ATTR_RO(cpulist, CPULIST_FILE_MAX_BYTES);
 
 /**
  * struct node_access_nodes - Access class device to hold user visible
diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index 43c0940643f5..5df6d861bc21 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -52,39 +52,39 @@ define_id_show_func(core_id);
 static DEVICE_ATTR_RO(core_id);
 
 define_siblings_read_func(thread_siblings, sibling_cpumask);
-static BIN_ATTR_RO(thread_siblings, 0);
-static BIN_ATTR_RO(thread_siblings_list, 0);
+static BIN_ATTR_RO(thread_siblings, CPUMAP_FILE_MAX_BYTES);
+static BIN_ATTR_RO(thread_siblings_list, CPULIST_FILE_MAX_BYTES);
 
 define_siblings_read_func(core_cpus, sibling_cpumask);
-static BIN_ATTR_RO(core_cpus, 0);
-static BIN_ATTR_RO(core_cpus_list, 0);
+static BIN_ATTR_RO(core_cpus, CPUMAP_FILE_MAX_BYTES);
+static BIN_ATTR_RO(core_cpus_list, CPULIST_FILE_MAX_BYTES);
 
 define_siblings_read_func(core_siblings, core_cpumask);
-static BIN_ATTR_RO(core_siblings, 0);
-static BIN_ATTR_RO(core_siblings_list, 0);
+static BIN_ATTR_RO(core_siblings, CPUMAP_FILE_MAX_BYTES);
+static BIN_ATTR_RO(core_siblings_list, CPULIST_FILE_MAX_BYTES);
 
 define_siblings_read_func(die_cpus, die_cpumask);
-static BIN_ATTR_RO(die_cpus, 0);
-static BIN_ATTR_RO(die_cpus_list, 0);
+static BIN_ATTR_RO(die_cpus, CPUMAP_FILE_MAX_BYTES);
+static BIN_ATTR_RO(die_cpus_list, CPULIST_FILE_MAX_BYTES);
 
 define_siblings_read_func(package_cpus, core_cpumask);
-static BIN_ATTR_RO(package_cpus, 0);
-static BIN_ATTR_RO(package_cpus_list, 0);
+static BIN_ATTR_RO(package_cpus, CPUMAP_FILE_MAX_BYTES);
+static BIN_ATTR_RO(package_cpus_list, CPULIST_FILE_MAX_BYTES);
 
 #ifdef CONFIG_SCHED_BOOK
 define_id_show_func(book_id);
 static DEVICE_ATTR_RO(book_id);
 define_siblings_read_func(book_siblings, book_cpumask);
-static BIN_ATTR_RO(book_siblings, 0);
-static BIN_ATTR_RO(book_siblings_list, 0);
+static BIN_ATTR_RO(book_siblings, CPUMAP_FILE_MAX_BYTES);
+static BIN_ATTR_RO(book_siblings_list, CPULIST_FILE_MAX_BYTES);
 #endif
 
 #ifdef CONFIG_SCHED_DRAWER
 define_id_show_func(drawer_id);
 static DEVICE_ATTR_RO(drawer_id);
 define_siblings_read_func(drawer_siblings, drawer_cpumask);
-static BIN_ATTR_RO(drawer_siblings, 0);
-static BIN_ATTR_RO(drawer_siblings_list, 0);
+static BIN_ATTR_RO(drawer_siblings, CPUMAP_FILE_MAX_BYTES);
+static BIN_ATTR_RO(drawer_siblings_list, CPULIST_FILE_MAX_BYTES);
 #endif
 
 static struct bin_attribute *bin_attrs[] = {
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 8cba10aafadb..79e485949b60 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1154,6 +1154,11 @@ loop_set_status_from_info(struct loop_device *lo,
 
 	lo->lo_offset = info->lo_offset;
 	lo->lo_sizelimit = info->lo_sizelimit;
+
+	/* loff_t vars have been assigned __u64 */
+	if (lo->lo_offset < 0 || lo->lo_sizelimit < 0)
+		return -EOVERFLOW;
+
 	memcpy(lo->lo_file_name, info->lo_file_name, LO_NAME_SIZE);
 	memcpy(lo->lo_crypt_name, info->lo_crypt_name, LO_NAME_SIZE);
 	lo->lo_file_name[LO_NAME_SIZE-1] = 0;
diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index c58bcdba2c7a..511fb8dfb4c4 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -820,6 +820,15 @@ nouveau_bo_move_m2mf(struct ttm_buffer_object *bo, int evict,
 		if (ret == 0) {
 			ret = nouveau_fence_new(chan, false, &fence);
 			if (ret == 0) {
+				/* TODO: figure out a better solution here
+				 *
+				 * wait on the fence here explicitly as going through
+				 * ttm_bo_move_accel_cleanup somehow doesn't seem to do it.
+				 *
+				 * Without this the operation can timeout and we'll fallback to a
+				 * software copy, which might take several minutes to finish.
+				 */
+				nouveau_fence_wait(fence, false, false);
 				ret = ttm_bo_move_accel_cleanup(bo,
 								&fence->base,
 								evict, false,
diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 148a7c5fd0e2..4b0201cf71f5 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -67,612 +67,767 @@ static inline void i8042_write_command(int val)
 
 #include <linux/dmi.h>
 
-static const struct dmi_system_id __initconst i8042_dmi_noloop_table[] = {
+#define SERIO_QUIRK_NOKBD		BIT(0)
+#define SERIO_QUIRK_NOAUX		BIT(1)
+#define SERIO_QUIRK_NOMUX		BIT(2)
+#define SERIO_QUIRK_FORCEMUX		BIT(3)
+#define SERIO_QUIRK_UNLOCK		BIT(4)
+#define SERIO_QUIRK_PROBE_DEFER		BIT(5)
+#define SERIO_QUIRK_RESET_ALWAYS	BIT(6)
+#define SERIO_QUIRK_RESET_NEVER		BIT(7)
+#define SERIO_QUIRK_DIECT		BIT(8)
+#define SERIO_QUIRK_DUMBKBD		BIT(9)
+#define SERIO_QUIRK_NOLOOP		BIT(10)
+#define SERIO_QUIRK_NOTIMEOUT		BIT(11)
+#define SERIO_QUIRK_KBDRESET		BIT(12)
+#define SERIO_QUIRK_DRITEK		BIT(13)
+#define SERIO_QUIRK_NOPNP		BIT(14)
+
+/* Quirk table for different mainboards. Options similar or identical to i8042
+ * module parameters.
+ * ORDERING IS IMPORTANT! The first match will be apllied and the rest ignored.
+ * This allows entries to overwrite vendor wide quirks on a per device basis.
+ * Where this is irrelevant, entries are sorted case sensitive by DMI_SYS_VENDOR
+ * and/or DMI_BOARD_VENDOR to make it easier to avoid dublicate entries.
+ */
+static const struct dmi_system_id i8042_dmi_quirk_table[] __initconst = {
 	{
-		/*
-		 * Arima-Rioworks HDAMB -
-		 * AUX LOOP command does not raise AUX IRQ
-		 */
 		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "RIOWORKS"),
-			DMI_MATCH(DMI_BOARD_NAME, "HDAMB"),
-			DMI_MATCH(DMI_BOARD_VERSION, "Rev E"),
+			DMI_MATCH(DMI_SYS_VENDOR, "ALIENWARE"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Sentia"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
-		/* ASUS G1S */
 		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer Inc."),
-			DMI_MATCH(DMI_BOARD_NAME, "G1S"),
-			DMI_MATCH(DMI_BOARD_VERSION, "1.0"),
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "X750LN"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOLOOP)
 	},
 	{
-		/* ASUS P65UP5 - AUX LOOP command does not raise AUX IRQ */
+		/* Asus X450LCP */
 		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
-			DMI_MATCH(DMI_BOARD_NAME, "P/I-P65UP5"),
-			DMI_MATCH(DMI_BOARD_VERSION, "REV 2.X"),
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "X450LCP"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_NEVER)
 	},
 	{
+		/* ASUS ZenBook UX425UA */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "X750LN"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX425UA"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_PROBE_DEFER | SERIO_QUIRK_RESET_NEVER)
 	},
 	{
+		/* ASUS ZenBook UM325UA */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Compaq"),
-			DMI_MATCH(DMI_PRODUCT_NAME , "ProLiant"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "8500"),
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX325UA_UM325UA"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_PROBE_DEFER | SERIO_QUIRK_RESET_NEVER)
 	},
+	/*
+	 * On some Asus laptops, just running self tests cause problems.
+	 */
 	{
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Compaq"),
-			DMI_MATCH(DMI_PRODUCT_NAME , "ProLiant"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "DL760"),
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_CHASSIS_TYPE, "10"), /* Notebook */
 		},
+		.driver_data = (void *)(SERIO_QUIRK_RESET_NEVER)
 	},
 	{
-		/* Dell Embedded Box PC 3000 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Embedded Box PC 3000"),
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_CHASSIS_TYPE, "31"), /* Convertible Notebook */
 		},
+		.driver_data = (void *)(SERIO_QUIRK_RESET_NEVER)
 	},
 	{
-		/* OQO Model 01 */
+		/* ASUS P65UP5 - AUX LOOP command does not raise AUX IRQ */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "OQO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ZEPTO"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "00"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "P/I-P65UP5"),
+			DMI_MATCH(DMI_BOARD_VERSION, "REV 2.X"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOLOOP)
 	},
 	{
-		/* ULI EV4873 - AUX LOOP does not work properly */
+		/* ASUS G1S */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ULI"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "EV4873"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "5a"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer Inc."),
+			DMI_MATCH(DMI_BOARD_NAME, "G1S"),
+			DMI_MATCH(DMI_BOARD_VERSION, "1.0"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOLOOP)
 	},
 	{
-		/* Microsoft Virtual Machine */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Virtual Machine"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "VS2005R2"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 1360"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
-		/* Medion MAM 2070 */
+		/* Acer Aspire 5710 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Notebook"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MAM 2070"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "5a"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5710"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
-		/* Medion Akoya E7225 */
+		/* Acer Aspire 7738 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Medion"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Akoya E7225"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "1.0"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 7738"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
-		/* Blue FB5601 */
+		/* Acer Aspire 5536 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "blue"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "FB5601"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "M606"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5536"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "0100"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
-		/* Gigabyte M912 */
+		/*
+		 * Acer Aspire 5738z
+		 * Touchpad stops working in mux mode when dis- + re-enabled
+		 * with the touchpad enable/disable toggle hotkey
+		 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "M912"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "01"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5738"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
-		/* Gigabyte M1022M netbook */
+		/* Acer Aspire One 150 */
 		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "Gigabyte Technology Co.,Ltd."),
-			DMI_MATCH(DMI_BOARD_NAME, "M1022E"),
-			DMI_MATCH(DMI_BOARD_VERSION, "1.02"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AOA150"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)
 	},
 	{
-		/* Gigabyte Spring Peak - defines wrong chassis type */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Spring Peak"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire A114-31"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)
 	},
 	{
-		/* Gigabyte T1005 - defines wrong chassis type ("Other") */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "T1005"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire A314-31"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)
 	},
 	{
-		/* Gigabyte T1005M/P - defines wrong chassis type ("Other") */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "T1005M/P"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire A315-31"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)
 	},
 	{
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv9700"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "Rev 1"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire ES1-132"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)
 	},
 	{
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "PEGATRON CORPORATION"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "C15B"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire ES1-332"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)
 	},
 	{
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ByteSpeed LLC"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ByteSpeed Laptop C15B"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire ES1-432"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)
 	},
-	{ }
-};
-
-/*
- * Some Fujitsu notebooks are having trouble with touchpads if
- * active multiplexing mode is activated. Luckily they don't have
- * external PS/2 ports so we can safely disable it.
- * ... apparently some Toshibas don't like MUX mode either and
- * die horrible death on reboot.
- */
-static const struct dmi_system_id __initconst i8042_dmi_nomux_table[] = {
 	{
-		/* Fujitsu Lifebook P7010/P7010D */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "P7010"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate Spin B118-RN"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)
 	},
+	/*
+	 * Some Wistron based laptops need us to explicitly enable the 'Dritek
+	 * keyboard extension' to make their extra keys start generating scancodes.
+	 * Originally, this was just confined to older laptops, but a few Acer laptops
+	 * have turned up in 2007 that also need this again.
+	 */
 	{
-		/* Fujitsu Lifebook P7010 */
+		/* Acer Aspire 5100 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "0000000000"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5100"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_DRITEK)
 	},
 	{
-		/* Fujitsu Lifebook P5020D */
+		/* Acer Aspire 5610 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook P Series"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5610"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_DRITEK)
 	},
 	{
-		/* Fujitsu Lifebook S2000 */
+		/* Acer Aspire 5630 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook S Series"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5630"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_DRITEK)
 	},
 	{
-		/* Fujitsu Lifebook S6230 */
+		/* Acer Aspire 5650 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook S6230"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5650"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_DRITEK)
 	},
 	{
-		/* Fujitsu Lifebook T725 laptop */
+		/* Acer Aspire 5680 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK T725"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5680"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_DRITEK)
 	},
 	{
-		/* Fujitsu Lifebook U745 */
+		/* Acer Aspire 5720 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK U745"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5720"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_DRITEK)
 	},
 	{
-		/* Fujitsu T70H */
+		/* Acer Aspire 9110 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "FMVLT70H"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 9110"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_DRITEK)
 	},
 	{
-		/* Fujitsu-Siemens Lifebook T3010 */
+		/* Acer TravelMate 660 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK T3010"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 660"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_DRITEK)
 	},
 	{
-		/* Fujitsu-Siemens Lifebook E4010 */
+		/* Acer TravelMate 2490 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK E4010"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 2490"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_DRITEK)
 	},
 	{
-		/* Fujitsu-Siemens Amilo Pro 2010 */
+		/* Acer TravelMate 4280 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Pro V2010"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 4280"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_DRITEK)
 	},
 	{
-		/* Fujitsu-Siemens Amilo Pro 2030 */
+		/* Amoi M636/A737 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO PRO V2030"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Amoi Electronics CO.,LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "M636/A737 platform"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
-		/*
-		 * No data is coming from the touchscreen unless KBC
-		 * is in legacy mode.
-		 */
-		/* Panasonic CF-29 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Matsushita"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "CF-29"),
+			DMI_MATCH(DMI_SYS_VENDOR, "ByteSpeed LLC"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ByteSpeed Laptop C15B"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOLOOP)
 	},
 	{
-		/*
-		 * HP Pavilion DV4017EA -
-		 * errors on MUX ports are reported without raising AUXDATA
-		 * causing "spurious NAK" messages.
-		 */
+		/* Compal HEL80I */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Pavilion dv4000 (EA032EA#ABF)"),
+			DMI_MATCH(DMI_SYS_VENDOR, "COMPAL"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HEL80I"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
-		/*
-		 * HP Pavilion ZT1000 -
-		 * like DV4017EA does not raise AUXERR for errors on MUX ports.
-		 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion Notebook PC"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "HP Pavilion Notebook ZT1000"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Compaq"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "8500"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOLOOP)
 	},
 	{
-		/*
-		 * HP Pavilion DV4270ca -
-		 * like DV4017EA does not raise AUXERR for errors on MUX ports.
-		 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Pavilion dv4000 (EH476UA#ABL)"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Compaq"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "DL760"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOLOOP)
 	},
 	{
+		/* Advent 4211 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Satellite P10"),
+			DMI_MATCH(DMI_SYS_VENDOR, "DIXONSXP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Advent 4211"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)
 	},
 	{
+		/* Dell Embedded Box PC 3000 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "EQUIUM A110"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Embedded Box PC 3000"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOLOOP)
 	},
 	{
+		/* Dell XPS M1530 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "SATELLITE C850D"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "XPS M1530"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
+		/* Dell Vostro 1510 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ALIENWARE"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Sentia"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro1510"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
-		/* Sharp Actius MM20 */
+		/* Dell Vostro V13 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "SHARP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PC-MM20 Series"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro V13"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_NOTIMEOUT)
 	},
 	{
-		/* Sony Vaio FS-115b */
+		/* Dell Vostro 1320 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FS115B"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 1320"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)
 	},
 	{
-		/*
-		 * Sony Vaio FZ-240E -
-		 * reset and GET ID commands issued via KBD port are
-		 * sometimes being delivered to AUX3.
-		 */
+		/* Dell Vostro 1520 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FZ240E"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 1520"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)
 	},
 	{
-		/*
-		 * Most (all?) VAIOs do not have external PS/2 ports nor
-		 * they implement active multiplexing properly, and
-		 * MUX discovery usually messes up keyboard/touchpad.
-		 */
+		/* Dell Vostro 1720 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-			DMI_MATCH(DMI_BOARD_NAME, "VAIO"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 1720"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)
 	},
 	{
-		/* Amoi M636/A737 */
+		/* Entroware Proteus */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Amoi Electronics CO.,LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "M636/A737 platform"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Entroware"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Proteus"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "EL07R4"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS)
 	},
+	/*
+	 * Some Fujitsu notebooks are having trouble with touchpads if
+	 * active multiplexing mode is activated. Luckily they don't have
+	 * external PS/2 ports so we can safely disable it.
+	 * ... apparently some Toshibas don't like MUX mode either and
+	 * die horrible death on reboot.
+	 */
 	{
-		/* Lenovo 3000 n100 */
+		/* Fujitsu Lifebook P7010/P7010D */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "076804U"),
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "P7010"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
-		/* Lenovo XiaoXin Air 12 */
+		/* Fujitsu Lifebook P5020D */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "80UN"),
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook P Series"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
+		/* Fujitsu Lifebook S2000 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 1360"),
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook S Series"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
-		/* Acer Aspire 5710 */
+		/* Fujitsu Lifebook S6230 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5710"),
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook S6230"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
-		/* Acer Aspire 7738 */
+		/* Fujitsu Lifebook T725 laptop */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 7738"),
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK T725"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_NOTIMEOUT)
 	},
 	{
-		/* Gericom Bellagio */
+		/* Fujitsu Lifebook U745 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Gericom"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "N34AS6"),
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK U745"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
-		/* IBM 2656 */
+		/* Fujitsu T70H */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "2656"),
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "FMVLT70H"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
-		/* Dell XPS M1530 */
+		/* Fujitsu A544 laptop */
+		/* https://bugzilla.redhat.com/show_bug.cgi?id=1111138 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "XPS M1530"),
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK A544"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOTIMEOUT)
 	},
 	{
-		/* Compal HEL80I */
+		/* Fujitsu AH544 laptop */
+		/* https://bugzilla.kernel.org/show_bug.cgi?id=69731 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "COMPAL"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HEL80I"),
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK AH544"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOTIMEOUT)
 	},
 	{
-		/* Dell Vostro 1510 */
+		/* Fujitsu U574 laptop */
+		/* https://bugzilla.kernel.org/show_bug.cgi?id=69731 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro1510"),
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK U574"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOTIMEOUT)
 	},
 	{
-		/* Acer Aspire 5536 */
+		/* Fujitsu UH554 laptop */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5536"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "0100"),
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK UH544"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOTIMEOUT)
 	},
 	{
-		/* Dell Vostro V13 */
+		/* Fujitsu Lifebook P7010 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro V13"),
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "0000000000"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
-		/* Newer HP Pavilion dv4 models */
+		/* Fujitsu-Siemens Lifebook T3010 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv4 Notebook PC"),
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK T3010"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
-		/* Asus X450LCP */
+		/* Fujitsu-Siemens Lifebook E4010 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "X450LCP"),
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK E4010"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
-		/* Avatar AVIU-145A6 */
+		/* Fujitsu-Siemens Amilo Pro 2010 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Intel"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "IC4I"),
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Pro V2010"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
-		/* TUXEDO BU1406 */
+		/* Fujitsu-Siemens Amilo Pro 2030 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Notebook"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "N24_25BU"),
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO PRO V2030"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
-		/* Lenovo LaVie Z */
+		/* Gigabyte M912 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo LaVie Z"),
+			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "M912"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "01"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOLOOP)
 	},
 	{
-		/*
-		 * Acer Aspire 5738z
-		 * Touchpad stops working in mux mode when dis- + re-enabled
-		 * with the touchpad enable/disable toggle hotkey
-		 */
+		/* Gigabyte Spring Peak - defines wrong chassis type */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5738"),
+			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Spring Peak"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOLOOP)
 	},
 	{
-		/* Entroware Proteus */
+		/* Gigabyte T1005 - defines wrong chassis type ("Other") */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Entroware"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Proteus"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "EL07R4"),
+			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "T1005"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOLOOP)
+	},
+	{
+		/* Gigabyte T1005M/P - defines wrong chassis type ("Other") */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "T1005M/P"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOLOOP)
+	},
+	/*
+	 * Some laptops need keyboard reset before probing for the trackpad to get
+	 * it detected, initialised & finally work.
+	 */
+	{
+		/* Gigabyte P35 v2 - Elantech touchpad */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "P35V2"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_KBDRESET)
+	},
+		{
+		/* Aorus branded Gigabyte X3 Plus - Elantech touchpad */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "X3"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_KBDRESET)
+	},
+	{
+		/* Gigabyte P34 - Elantech touchpad */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "P34"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_KBDRESET)
+	},
+	{
+		/* Gigabyte P57 - Elantech touchpad */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "P57"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_KBDRESET)
+	},
+	{
+		/* Gericom Bellagio */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Gericom"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "N34AS6"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
+	},
+	{
+		/* Gigabyte M1022M netbook */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Gigabyte Technology Co.,Ltd."),
+			DMI_MATCH(DMI_BOARD_NAME, "M1022E"),
+			DMI_MATCH(DMI_BOARD_VERSION, "1.02"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOLOOP)
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv9700"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "Rev 1"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOLOOP)
 	},
-	{ }
-};
-
-static const struct dmi_system_id i8042_dmi_forcemux_table[] __initconst = {
 	{
 		/*
-		 * Sony Vaio VGN-CS series require MUX or the touch sensor
-		 * buttons will disturb touchpad operation
+		 * HP Pavilion DV4017EA -
+		 * errors on MUX ports are reported without raising AUXDATA
+		 * causing "spurious NAK" messages.
 		 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-CS"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Pavilion dv4000 (EA032EA#ABF)"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
-	{ }
-};
-
-/*
- * On some Asus laptops, just running self tests cause problems.
- */
-static const struct dmi_system_id i8042_dmi_noselftest_table[] = {
 	{
+		/*
+		 * HP Pavilion ZT1000 -
+		 * like DV4017EA does not raise AUXERR for errors on MUX ports.
+		 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_CHASSIS_TYPE, "10"), /* Notebook */
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion Notebook PC"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "HP Pavilion Notebook ZT1000"),
 		},
-	}, {
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
+	},
+	{
+		/*
+		 * HP Pavilion DV4270ca -
+		 * like DV4017EA does not raise AUXERR for errors on MUX ports.
+		 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_CHASSIS_TYPE, "31"), /* Convertible Notebook */
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Pavilion dv4000 (EH476UA#ABL)"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
-	{ }
-};
-static const struct dmi_system_id __initconst i8042_dmi_reset_table[] = {
 	{
-		/* MSI Wind U-100 */
+		/* Newer HP Pavilion dv4 models */
 		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "U-100"),
-			DMI_MATCH(DMI_BOARD_VENDOR, "MICRO-STAR INTERNATIONAL CO., LTD"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv4 Notebook PC"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_NOTIMEOUT)
 	},
 	{
-		/* LG Electronics X110 */
+		/* IBM 2656 */
 		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "X110"),
-			DMI_MATCH(DMI_BOARD_VENDOR, "LG Electronics Inc."),
+			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "2656"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
-		/* Acer Aspire One 150 */
+		/* Avatar AVIU-145A6 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "AOA150"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Intel"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "IC4I"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
+		/* Intel MBO Desktop D845PESV */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire A114-31"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "D845PESV"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOPNP)
 	},
 	{
+		/*
+		 * Intel NUC D54250WYK - does not have i8042 controller but
+		 * declares PS/2 devices in DSDT.
+		 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire A314-31"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "D54250WYK"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOPNP)
 	},
 	{
+		/* Lenovo 3000 n100 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire A315-31"),
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "076804U"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
+		/* Lenovo XiaoXin Air 12 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire ES1-132"),
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "80UN"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
+		/* Lenovo LaVie Z */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire ES1-332"),
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo LaVie Z"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
+		/* Lenovo Ideapad U455 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire ES1-432"),
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "20046"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)
 	},
 	{
+		/* Lenovo ThinkPad L460 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate Spin B118-RN"),
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad L460"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)
 	},
 	{
-		/* Advent 4211 */
+		/* Lenovo ThinkPad Twist S230u */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "DIXONSXP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Advent 4211"),
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "33474HU"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)
+	},
+	{
+		/* LG Electronics X110 */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LG Electronics Inc."),
+			DMI_MATCH(DMI_BOARD_NAME, "X110"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)
 	},
 	{
 		/* Medion Akoya Mini E1210 */
@@ -680,6 +835,7 @@ static const struct dmi_system_id __initconst i8042_dmi_reset_table[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "MEDION"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "E1210"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)
 	},
 	{
 		/* Medion Akoya E1222 */
@@ -687,331 +843,434 @@ static const struct dmi_system_id __initconst i8042_dmi_reset_table[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "MEDION"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "E122X"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)
 	},
 	{
-		/* Mivvy M310 */
+		/* MSI Wind U-100 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "VIOOO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "N10"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "MICRO-STAR INTERNATIONAL CO., LTD"),
+			DMI_MATCH(DMI_BOARD_NAME, "U-100"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS | SERIO_QUIRK_NOPNP)
 	},
 	{
-		/* Dell Vostro 1320 */
+		/*
+		 * No data is coming from the touchscreen unless KBC
+		 * is in legacy mode.
+		 */
+		/* Panasonic CF-29 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 1320"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Matsushita"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "CF-29"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
-		/* Dell Vostro 1520 */
+		/* Medion Akoya E7225 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 1520"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Medion"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Akoya E7225"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "1.0"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOLOOP)
 	},
 	{
-		/* Dell Vostro 1720 */
+		/* Microsoft Virtual Machine */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 1720"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Virtual Machine"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "VS2005R2"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOLOOP)
 	},
 	{
-		/* Lenovo Ideapad U455 */
+		/* Medion MAM 2070 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "20046"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Notebook"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MAM 2070"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "5a"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOLOOP)
 	},
 	{
-		/* Lenovo ThinkPad L460 */
+		/* TUXEDO BU1406 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad L460"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Notebook"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "N24_25BU"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
+	},
+	{
+		/* OQO Model 01 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "OQO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ZEPTO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "00"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOLOOP)
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "PEGATRON CORPORATION"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "C15B"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOLOOP)
+	},
+	{
+		/* Acer Aspire 5 A515 */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "PK"),
+			DMI_MATCH(DMI_BOARD_NAME, "Grumpy_PK"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOPNP)
+	},
+	{
+		/* ULI EV4873 - AUX LOOP does not work properly */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ULI"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "EV4873"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "5a"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOLOOP)
+	},
+	{
+		/*
+		 * Arima-Rioworks HDAMB -
+		 * AUX LOOP command does not raise AUX IRQ
+		 */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "RIOWORKS"),
+			DMI_MATCH(DMI_BOARD_NAME, "HDAMB"),
+			DMI_MATCH(DMI_BOARD_VERSION, "Rev E"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOLOOP)
 	},
 	{
-		/* Clevo P650RS, 650RP6, Sager NP8152-S, and others */
+		/* Sharp Actius MM20 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Notebook"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "P65xRP"),
+			DMI_MATCH(DMI_SYS_VENDOR, "SHARP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PC-MM20 Series"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
-		/* Lenovo ThinkPad Twist S230u */
+		/*
+		 * Sony Vaio FZ-240E -
+		 * reset and GET ID commands issued via KBD port are
+		 * sometimes being delivered to AUX3.
+		 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "33474HU"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FZ240E"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
-		/* Entroware Proteus */
+		/*
+		 * Most (all?) VAIOs do not have external PS/2 ports nor
+		 * they implement active multiplexing properly, and
+		 * MUX discovery usually messes up keyboard/touchpad.
+		 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Entroware"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Proteus"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "EL07R4"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "VAIO"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
-	{ }
-};
-
-#ifdef CONFIG_PNP
-static const struct dmi_system_id __initconst i8042_dmi_nopnp_table[] = {
 	{
-		/* Intel MBO Desktop D845PESV */
+		/* Sony Vaio FS-115b */
 		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "D845PESV"),
-			DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FS115B"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
 		/*
-		 * Intel NUC D54250WYK - does not have i8042 controller but
-		 * declares PS/2 devices in DSDT.
+		 * Sony Vaio VGN-CS series require MUX or the touch sensor
+		 * buttons will disturb touchpad operation
 		 */
 		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "D54250WYK"),
-			DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-CS"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_FORCEMUX)
 	},
 	{
-		/* MSI Wind U-100 */
 		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "U-100"),
-			DMI_MATCH(DMI_BOARD_VENDOR, "MICRO-STAR INTERNATIONAL CO., LTD"),
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Satellite P10"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
-		/* Acer Aspire 5 A515 */
 		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "Grumpy_PK"),
-			DMI_MATCH(DMI_BOARD_VENDOR, "PK"),
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "EQUIUM A110"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
-	{ }
-};
-
-static const struct dmi_system_id __initconst i8042_dmi_laptop_table[] = {
 	{
 		.matches = {
-			DMI_MATCH(DMI_CHASSIS_TYPE, "8"), /* Portable */
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "SATELLITE C850D"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
+	/*
+	 * A lot of modern Clevo barebones have touchpad and/or keyboard issues
+	 * after suspend fixable with nomux + reset + noloop + nopnp. Luckily,
+	 * none of them have an external PS/2 port so this can safely be set for
+	 * all of them. These two are based on a Clevo design, but have the
+	 * board_name changed.
+	 */
 	{
 		.matches = {
-			DMI_MATCH(DMI_CHASSIS_TYPE, "9"), /* Laptop */
+			DMI_MATCH(DMI_BOARD_VENDOR, "TUXEDO"),
+			DMI_MATCH(DMI_BOARD_NAME, "AURA1501"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
 	{
 		.matches = {
-			DMI_MATCH(DMI_CHASSIS_TYPE, "10"), /* Notebook */
+			DMI_MATCH(DMI_BOARD_VENDOR, "TUXEDO"),
+			DMI_MATCH(DMI_BOARD_NAME, "EDUBOOK1502"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
 	{
+		/* Mivvy M310 */
 		.matches = {
-			DMI_MATCH(DMI_CHASSIS_TYPE, "14"), /* Sub-Notebook */
+			DMI_MATCH(DMI_SYS_VENDOR, "VIOOO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "N10"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)
 	},
-	{ }
-};
-#endif
-
-static const struct dmi_system_id __initconst i8042_dmi_notimeout_table[] = {
+	/*
+	 * Some laptops need keyboard reset before probing for the trackpad to get
+	 * it detected, initialised & finally work.
+	 */
 	{
-		/* Dell Vostro V13 */
+		/* Schenker XMG C504 - Elantech touchpad */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro V13"),
+			DMI_MATCH(DMI_SYS_VENDOR, "XMG"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "C504"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_KBDRESET)
 	},
 	{
-		/* Newer HP Pavilion dv4 models */
+		/* Blue FB5601 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv4 Notebook PC"),
+			DMI_MATCH(DMI_SYS_VENDOR, "blue"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "FB5601"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "M606"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOLOOP)
 	},
+	/*
+	 * A lot of modern Clevo barebones have touchpad and/or keyboard issues
+	 * after suspend fixable with nomux + reset + noloop + nopnp. Luckily,
+	 * none of them have an external PS/2 port so this can safely be set for
+	 * all of them.
+	 * Clevo barebones come with board_vendor and/or system_vendor set to
+	 * either the very generic string "Notebook" and/or a different value
+	 * for each individual reseller. The only somewhat universal way to
+	 * identify them is by board_name.
+	 */
 	{
-		/* Fujitsu A544 laptop */
-		/* https://bugzilla.redhat.com/show_bug.cgi?id=1111138 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK A544"),
+			DMI_MATCH(DMI_BOARD_NAME, "LAPQC71A"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
 	{
-		/* Fujitsu AH544 laptop */
-		/* https://bugzilla.kernel.org/show_bug.cgi?id=69731 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK AH544"),
+			DMI_MATCH(DMI_BOARD_NAME, "LAPQC71B"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
 	{
-		/* Fujitsu Lifebook T725 laptop */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK T725"),
+			DMI_MATCH(DMI_BOARD_NAME, "N140CU"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
 	{
-		/* Fujitsu U574 laptop */
-		/* https://bugzilla.kernel.org/show_bug.cgi?id=69731 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK U574"),
+			DMI_MATCH(DMI_BOARD_NAME, "N141CU"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
 	{
-		/* Fujitsu UH554 laptop */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK UH544"),
+			DMI_MATCH(DMI_BOARD_NAME, "NH5xAx"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
-	{ }
-};
-
-/*
- * Some Wistron based laptops need us to explicitly enable the 'Dritek
- * keyboard extension' to make their extra keys start generating scancodes.
- * Originally, this was just confined to older laptops, but a few Acer laptops
- * have turned up in 2007 that also need this again.
- */
-static const struct dmi_system_id __initconst i8042_dmi_dritek_table[] = {
 	{
-		/* Acer Aspire 5100 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5100"),
+			DMI_MATCH(DMI_BOARD_NAME, "NL5xRU"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
+	/*
+	 * At least one modern Clevo barebone has the touchpad connected both
+	 * via PS/2 and i2c interface. This causes a race condition between the
+	 * psmouse and i2c-hid driver. Since the full capability of the touchpad
+	 * is available via the i2c interface and the device has no external
+	 * PS/2 port, it is safe to just ignore all ps2 mouses here to avoid
+	 * this issue. The known affected device is the
+	 * TUXEDO InfinityBook S17 Gen6 / Clevo NS70MU which comes with one of
+	 * the two different dmi strings below. NS50MU is not a typo!
+	 */
 	{
-		/* Acer Aspire 5610 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5610"),
+			DMI_MATCH(DMI_BOARD_NAME, "NS50MU"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOAUX | SERIO_QUIRK_NOMUX |
+					SERIO_QUIRK_RESET_ALWAYS | SERIO_QUIRK_NOLOOP |
+					SERIO_QUIRK_NOPNP)
 	},
 	{
-		/* Acer Aspire 5630 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5630"),
+			DMI_MATCH(DMI_BOARD_NAME, "NS50_70MU"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOAUX | SERIO_QUIRK_NOMUX |
+					SERIO_QUIRK_RESET_ALWAYS | SERIO_QUIRK_NOLOOP |
+					SERIO_QUIRK_NOPNP)
 	},
 	{
-		/* Acer Aspire 5650 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5650"),
+			DMI_MATCH(DMI_BOARD_NAME, "NJ50_70CU"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
 	{
-		/* Acer Aspire 5680 */
+		/*
+		 * This is only a partial board_name and might be followed by
+		 * another letter or number. DMI_MATCH however does do partial
+		 * matching.
+		 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5680"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "P65xH"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
 	{
-		/* Acer Aspire 5720 */
+		/* Clevo P650RS, 650RP6, Sager NP8152-S, and others */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5720"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "P65xRP"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
 	{
-		/* Acer Aspire 9110 */
+		/*
+		 * This is only a partial board_name and might be followed by
+		 * another letter or number. DMI_MATCH however does do partial
+		 * matching.
+		 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 9110"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "P65_P67H"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
 	{
-		/* Acer TravelMate 660 */
+		/*
+		 * This is only a partial board_name and might be followed by
+		 * another letter or number. DMI_MATCH however does do partial
+		 * matching.
+		 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 660"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "P65_67RP"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
 	{
-		/* Acer TravelMate 2490 */
+		/*
+		 * This is only a partial board_name and might be followed by
+		 * another letter or number. DMI_MATCH however does do partial
+		 * matching.
+		 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 2490"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "P65_67RS"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
 	{
-		/* Acer TravelMate 4280 */
+		/*
+		 * This is only a partial board_name and might be followed by
+		 * another letter or number. DMI_MATCH however does do partial
+		 * matching.
+		 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 4280"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "P67xRP"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
-	{ }
-};
-
-/*
- * Some laptops need keyboard reset before probing for the trackpad to get
- * it detected, initialised & finally work.
- */
-static const struct dmi_system_id __initconst i8042_dmi_kbdreset_table[] = {
 	{
-		/* Gigabyte P35 v2 - Elantech touchpad */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "P35V2"),
+			DMI_MATCH(DMI_BOARD_NAME, "PB50_70DFx,DDx"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
-		{
-		/* Aorus branded Gigabyte X3 Plus - Elantech touchpad */
+	{
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "X3"),
+			DMI_MATCH(DMI_BOARD_NAME, "X170SM"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
 	{
-		/* Gigabyte P34 - Elantech touchpad */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "P34"),
+			DMI_MATCH(DMI_BOARD_NAME, "X170KM-G"),
 		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
+	{ }
+};
+
+#ifdef CONFIG_PNP
+static const struct dmi_system_id i8042_dmi_laptop_table[] __initconst = {
 	{
-		/* Gigabyte P57 - Elantech touchpad */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "P57"),
+			DMI_MATCH(DMI_CHASSIS_TYPE, "8"), /* Portable */
 		},
 	},
 	{
-		/* Schenker XMG C504 - Elantech touchpad */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "XMG"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "C504"),
+			DMI_MATCH(DMI_CHASSIS_TYPE, "9"), /* Laptop */
 		},
 	},
-	{ }
-};
-
-static const struct dmi_system_id i8042_dmi_probe_defer_table[] __initconst = {
 	{
-		/* ASUS ZenBook UX425UA */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX425UA"),
+			DMI_MATCH(DMI_CHASSIS_TYPE, "10"), /* Notebook */
 		},
 	},
 	{
-		/* ASUS ZenBook UM325UA */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX325UA_UM325UA"),
+			DMI_MATCH(DMI_CHASSIS_TYPE, "14"), /* Sub-Notebook */
 		},
 	},
 	{ }
 };
+#endif
 
 #endif /* CONFIG_X86 */
 
@@ -1167,11 +1426,6 @@ static int __init i8042_pnp_init(void)
 	bool pnp_data_busted = false;
 	int err;
 
-#ifdef CONFIG_X86
-	if (dmi_check_system(i8042_dmi_nopnp_table))
-		i8042_nopnp = true;
-#endif
-
 	if (i8042_nopnp) {
 		pr_info("PNP detection disabled\n");
 		return 0;
@@ -1275,6 +1529,59 @@ static inline int i8042_pnp_init(void) { return 0; }
 static inline void i8042_pnp_exit(void) { }
 #endif /* CONFIG_PNP */
 
+
+#ifdef CONFIG_X86
+static void __init i8042_check_quirks(void)
+{
+	const struct dmi_system_id *device_quirk_info;
+	uintptr_t quirks;
+
+	device_quirk_info = dmi_first_match(i8042_dmi_quirk_table);
+	if (!device_quirk_info)
+		return;
+
+	quirks = (uintptr_t)device_quirk_info->driver_data;
+
+	if (quirks & SERIO_QUIRK_NOKBD)
+		i8042_nokbd = true;
+	if (quirks & SERIO_QUIRK_NOAUX)
+		i8042_noaux = true;
+	if (quirks & SERIO_QUIRK_NOMUX)
+		i8042_nomux = true;
+	if (quirks & SERIO_QUIRK_FORCEMUX)
+		i8042_nomux = false;
+	if (quirks & SERIO_QUIRK_UNLOCK)
+		i8042_unlock = true;
+	if (quirks & SERIO_QUIRK_PROBE_DEFER)
+		i8042_probe_defer = true;
+	/* Honor module parameter when value is not default */
+	if (i8042_reset == I8042_RESET_DEFAULT) {
+		if (quirks & SERIO_QUIRK_RESET_ALWAYS)
+			i8042_reset = I8042_RESET_ALWAYS;
+		if (quirks & SERIO_QUIRK_RESET_NEVER)
+			i8042_reset = I8042_RESET_NEVER;
+	}
+	if (quirks & SERIO_QUIRK_DIECT)
+		i8042_direct = true;
+	if (quirks & SERIO_QUIRK_DUMBKBD)
+		i8042_dumbkbd = true;
+	if (quirks & SERIO_QUIRK_NOLOOP)
+		i8042_noloop = true;
+	if (quirks & SERIO_QUIRK_NOTIMEOUT)
+		i8042_notimeout = true;
+	if (quirks & SERIO_QUIRK_KBDRESET)
+		i8042_kbdreset = true;
+	if (quirks & SERIO_QUIRK_DRITEK)
+		i8042_dritek = true;
+#ifdef CONFIG_PNP
+	if (quirks & SERIO_QUIRK_NOPNP)
+		i8042_nopnp = true;
+#endif
+}
+#else
+static inline void i8042_check_quirks(void) {}
+#endif
+
 static int __init i8042_platform_init(void)
 {
 	int retval;
@@ -1297,45 +1604,17 @@ static int __init i8042_platform_init(void)
 	i8042_kbd_irq = I8042_MAP_IRQ(1);
 	i8042_aux_irq = I8042_MAP_IRQ(12);
 
-	retval = i8042_pnp_init();
-	if (retval)
-		return retval;
-
 #if defined(__ia64__)
-        i8042_reset = I8042_RESET_ALWAYS;
+	i8042_reset = I8042_RESET_ALWAYS;
 #endif
 
-#ifdef CONFIG_X86
-	/* Honor module parameter when value is not default */
-	if (i8042_reset == I8042_RESET_DEFAULT) {
-		if (dmi_check_system(i8042_dmi_reset_table))
-			i8042_reset = I8042_RESET_ALWAYS;
-
-		if (dmi_check_system(i8042_dmi_noselftest_table))
-			i8042_reset = I8042_RESET_NEVER;
-	}
-
-	if (dmi_check_system(i8042_dmi_noloop_table))
-		i8042_noloop = true;
-
-	if (dmi_check_system(i8042_dmi_nomux_table))
-		i8042_nomux = true;
-
-	if (dmi_check_system(i8042_dmi_forcemux_table))
-		i8042_nomux = false;
-
-	if (dmi_check_system(i8042_dmi_notimeout_table))
-		i8042_notimeout = true;
-
-	if (dmi_check_system(i8042_dmi_dritek_table))
-		i8042_dritek = true;
-
-	if (dmi_check_system(i8042_dmi_kbdreset_table))
-		i8042_kbdreset = true;
+	i8042_check_quirks();
 
-	if (dmi_check_system(i8042_dmi_probe_defer_table))
-		i8042_probe_defer = true;
+	retval = i8042_pnp_init();
+	if (retval)
+		return retval;
 
+#ifdef CONFIG_X86
 	/*
 	 * A20 was already enabled during early kernel init. But some buggy
 	 * BIOSes (in MSI Laptops) require A20 to be enabled using 8042 to
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 33946adb0d6f..c8f2e8524bfb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6251,11 +6251,11 @@ static void mddev_detach(struct mddev *mddev)
 static void __md_stop(struct mddev *mddev)
 {
 	struct md_personality *pers = mddev->pers;
+	md_bitmap_destroy(mddev);
 	mddev_detach(mddev);
 	/* Ensure ->event_work is done */
 	if (mddev->event_work.func)
 		flush_workqueue(md_misc_wq);
-	md_bitmap_destroy(mddev);
 	spin_lock(&mddev->lock);
 	mddev->pers = NULL;
 	spin_unlock(&mddev->lock);
@@ -6272,6 +6272,7 @@ void md_stop(struct mddev *mddev)
 	/* stop the array and free an attached data structures.
 	 * This is called from dm-raid
 	 */
+	__md_stop_writes(mddev);
 	__md_stop(mddev);
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index d7fb33c078e8..1f0120cbe9e8 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -2007,30 +2007,24 @@ void bond_3ad_initiate_agg_selection(struct bonding *bond, int timeout)
  */
 void bond_3ad_initialize(struct bonding *bond, u16 tick_resolution)
 {
-	/* check that the bond is not initialized yet */
-	if (!MAC_ADDRESS_EQUAL(&(BOND_AD_INFO(bond).system.sys_mac_addr),
-				bond->dev->dev_addr)) {
-
-		BOND_AD_INFO(bond).aggregator_identifier = 0;
-
-		BOND_AD_INFO(bond).system.sys_priority =
-			bond->params.ad_actor_sys_prio;
-		if (is_zero_ether_addr(bond->params.ad_actor_system))
-			BOND_AD_INFO(bond).system.sys_mac_addr =
-			    *((struct mac_addr *)bond->dev->dev_addr);
-		else
-			BOND_AD_INFO(bond).system.sys_mac_addr =
-			    *((struct mac_addr *)bond->params.ad_actor_system);
+	BOND_AD_INFO(bond).aggregator_identifier = 0;
+	BOND_AD_INFO(bond).system.sys_priority =
+		bond->params.ad_actor_sys_prio;
+	if (is_zero_ether_addr(bond->params.ad_actor_system))
+		BOND_AD_INFO(bond).system.sys_mac_addr =
+		    *((struct mac_addr *)bond->dev->dev_addr);
+	else
+		BOND_AD_INFO(bond).system.sys_mac_addr =
+		    *((struct mac_addr *)bond->params.ad_actor_system);
 
-		/* initialize how many times this module is called in one
-		 * second (should be about every 100ms)
-		 */
-		ad_ticks_per_sec = tick_resolution;
+	/* initialize how many times this module is called in one
+	 * second (should be about every 100ms)
+	 */
+	ad_ticks_per_sec = tick_resolution;
 
-		bond_3ad_initiate_agg_selection(bond,
-						AD_AGGREGATOR_SELECTION_TIMER *
-						ad_ticks_per_sec);
-	}
+	bond_3ad_initiate_agg_selection(bond,
+					AD_AGGREGATOR_SELECTION_TIMER *
+					ad_ticks_per_sec);
 }
 
 /**
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index 70d8ca3039dc..78763f5027d1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -623,7 +623,7 @@ static int bnxt_hwrm_func_vf_resc_cfg(struct bnxt *bp, int num_vfs, bool reset)
 		hw_resc->max_stat_ctxs -= le16_to_cpu(req->min_stat_ctx) * n;
 		hw_resc->max_vnics -= le16_to_cpu(req->min_vnics) * n;
 		if (bp->flags & BNXT_FLAG_CHIP_P5)
-			hw_resc->max_irqs -= vf_msix * n;
+			hw_resc->max_nqs -= vf_msix;
 
 		rc = pf->active_vfs;
 	}
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 0e13ce9b4d00..669ae53f4c72 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -4385,7 +4385,7 @@ static int i40e_check_fdir_input_set(struct i40e_vsi *vsi,
 				    (struct in6_addr *)&ipv6_full_mask))
 			new_mask |= I40E_L3_V6_DST_MASK;
 		else if (ipv6_addr_any((struct in6_addr *)
-				       &usr_ip6_spec->ip6src))
+				       &usr_ip6_spec->ip6dst))
 			new_mask &= ~I40E_L3_V6_DST_MASK;
 		else
 			return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 5581747947e5..60d8ef0c8859 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -321,6 +321,19 @@ int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
 	bool if_running, pool_present = !!pool;
 	int ret = 0, pool_failure = 0;
 
+	if (qid >= vsi->num_rxq || qid >= vsi->num_txq) {
+		netdev_err(vsi->netdev, "Please use queue id in scope of combined queues count\n");
+		pool_failure = -EINVAL;
+		goto failure;
+	}
+
+	if (!is_power_of_2(vsi->rx_rings[qid]->count) ||
+	    !is_power_of_2(vsi->tx_rings[qid]->count)) {
+		netdev_err(vsi->netdev, "Please align ring sizes to power of 2\n");
+		pool_failure = -EINVAL;
+		goto failure;
+	}
+
 	if_running = netif_running(vsi->netdev) && ice_is_xdp_ena_vsi(vsi);
 
 	if (if_running) {
@@ -343,6 +356,7 @@ int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
 			netdev_err(vsi->netdev, "ice_qp_ena error = %d\n", ret);
 	}
 
+failure:
 	if (pool_failure) {
 		netdev_err(vsi->netdev, "Could not %sable buffer pool, error = %d\n",
 			   pool_present ? "en" : "dis", pool_failure);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
index 23ddfd79fc8b..29be1d6eca43 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
@@ -1212,7 +1212,6 @@ void ixgbe_ptp_start_cyclecounter(struct ixgbe_adapter *adapter)
 	struct cyclecounter cc;
 	unsigned long flags;
 	u32 incval = 0;
-	u32 tsauxc = 0;
 	u32 fuse0 = 0;
 
 	/* For some of the boards below this mask is technically incorrect.
@@ -1247,18 +1246,6 @@ void ixgbe_ptp_start_cyclecounter(struct ixgbe_adapter *adapter)
 	case ixgbe_mac_x550em_a:
 	case ixgbe_mac_X550:
 		cc.read = ixgbe_ptp_read_X550;
-
-		/* enable SYSTIME counter */
-		IXGBE_WRITE_REG(hw, IXGBE_SYSTIMR, 0);
-		IXGBE_WRITE_REG(hw, IXGBE_SYSTIML, 0);
-		IXGBE_WRITE_REG(hw, IXGBE_SYSTIMH, 0);
-		tsauxc = IXGBE_READ_REG(hw, IXGBE_TSAUXC);
-		IXGBE_WRITE_REG(hw, IXGBE_TSAUXC,
-				tsauxc & ~IXGBE_TSAUXC_DISABLE_SYSTIME);
-		IXGBE_WRITE_REG(hw, IXGBE_TSIM, IXGBE_TSIM_TXTS);
-		IXGBE_WRITE_REG(hw, IXGBE_EIMS, IXGBE_EIMS_TIMESYNC);
-
-		IXGBE_WRITE_FLUSH(hw);
 		break;
 	case ixgbe_mac_X540:
 		cc.read = ixgbe_ptp_read_82599;
@@ -1290,6 +1277,50 @@ void ixgbe_ptp_start_cyclecounter(struct ixgbe_adapter *adapter)
 	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
 }
 
+/**
+ * ixgbe_ptp_init_systime - Initialize SYSTIME registers
+ * @adapter: the ixgbe private board structure
+ *
+ * Initialize and start the SYSTIME registers.
+ */
+static void ixgbe_ptp_init_systime(struct ixgbe_adapter *adapter)
+{
+	struct ixgbe_hw *hw = &adapter->hw;
+	u32 tsauxc;
+
+	switch (hw->mac.type) {
+	case ixgbe_mac_X550EM_x:
+	case ixgbe_mac_x550em_a:
+	case ixgbe_mac_X550:
+		tsauxc = IXGBE_READ_REG(hw, IXGBE_TSAUXC);
+
+		/* Reset SYSTIME registers to 0 */
+		IXGBE_WRITE_REG(hw, IXGBE_SYSTIMR, 0);
+		IXGBE_WRITE_REG(hw, IXGBE_SYSTIML, 0);
+		IXGBE_WRITE_REG(hw, IXGBE_SYSTIMH, 0);
+
+		/* Reset interrupt settings */
+		IXGBE_WRITE_REG(hw, IXGBE_TSIM, IXGBE_TSIM_TXTS);
+		IXGBE_WRITE_REG(hw, IXGBE_EIMS, IXGBE_EIMS_TIMESYNC);
+
+		/* Activate the SYSTIME counter */
+		IXGBE_WRITE_REG(hw, IXGBE_TSAUXC,
+				tsauxc & ~IXGBE_TSAUXC_DISABLE_SYSTIME);
+		break;
+	case ixgbe_mac_X540:
+	case ixgbe_mac_82599EB:
+		/* Reset SYSTIME registers to 0 */
+		IXGBE_WRITE_REG(hw, IXGBE_SYSTIML, 0);
+		IXGBE_WRITE_REG(hw, IXGBE_SYSTIMH, 0);
+		break;
+	default:
+		/* Other devices aren't supported */
+		return;
+	};
+
+	IXGBE_WRITE_FLUSH(hw);
+}
+
 /**
  * ixgbe_ptp_reset
  * @adapter: the ixgbe private board structure
@@ -1316,6 +1347,8 @@ void ixgbe_ptp_reset(struct ixgbe_adapter *adapter)
 
 	ixgbe_ptp_start_cyclecounter(adapter);
 
+	ixgbe_ptp_init_systime(adapter);
+
 	spin_lock_irqsave(&adapter->tmreg_lock, flags);
 	timecounter_init(&adapter->hw_tc, &adapter->hw_cc,
 			 ktime_to_ns(ktime_get_real()));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index e00648094fc2..c1c4f380803a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3325,7 +3325,9 @@ static int set_feature_hw_tc(struct net_device *netdev, bool enable)
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 
 #if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
-	if (!enable && mlx5e_tc_num_filters(priv, MLX5_TC_FLAG(NIC_OFFLOAD))) {
+	int tc_flag = mlx5e_is_uplink_rep(priv) ? MLX5_TC_FLAG(ESW_OFFLOAD) :
+						  MLX5_TC_FLAG(NIC_OFFLOAD);
+	if (!enable && mlx5e_tc_num_filters(priv, tc_flag)) {
 		netdev_err(netdev,
 			   "Active offloaded tc filters, can't turn hw_tc_offload off\n");
 		return -EINVAL;
@@ -4350,14 +4352,6 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
 	/* RQ */
 	mlx5e_build_rq_params(mdev, params);
 
-	/* HW LRO */
-	if (MLX5_CAP_ETH(mdev, lro_cap) &&
-	    params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
-		/* No XSK params: checking the availability of striding RQ in general. */
-		if (!mlx5e_rx_mpwqe_is_linear_skb(mdev, params, NULL))
-			params->packet_merge.type = slow_pci_heuristic(mdev) ?
-				MLX5E_PACKET_MERGE_NONE : MLX5E_PACKET_MERGE_LRO;
-	}
 	params->packet_merge.timeout = mlx5e_choose_lro_timeout(mdev, MLX5E_DEFAULT_LRO_TIMEOUT);
 
 	/* CQ moderation params */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 161b60e1139b..3d614bf5cff9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -618,6 +618,8 @@ static void mlx5e_build_rep_params(struct net_device *netdev)
 
 	params->mqprio.num_tc       = 1;
 	params->tunneled_offload_en = false;
+	if (rep->vport != MLX5_VPORT_UPLINK)
+		params->vlan_strip_disable = true;
 
 	/* Set an initial non-zero value, so that mlx5e_select_queue won't
 	 * divide by zero if called before first activating channels.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 5a6606c843ed..740065e21181 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1427,7 +1427,9 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	memcpy(&dev->profile, &profile[profile_idx], sizeof(dev->profile));
 	INIT_LIST_HEAD(&priv->ctx_list);
 	spin_lock_init(&priv->ctx_lock);
+	lockdep_register_key(&dev->lock_key);
 	mutex_init(&dev->intf_state_mutex);
+	lockdep_set_class(&dev->intf_state_mutex, &dev->lock_key);
 
 	mutex_init(&priv->bfregs.reg_head.lock);
 	mutex_init(&priv->bfregs.wc_head.lock);
@@ -1474,6 +1476,7 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	mutex_destroy(&priv->bfregs.wc_head.lock);
 	mutex_destroy(&priv->bfregs.reg_head.lock);
 	mutex_destroy(&dev->intf_state_mutex);
+	lockdep_unregister_key(&dev->lock_key);
 	return err;
 }
 
@@ -1491,6 +1494,7 @@ void mlx5_mdev_uninit(struct mlx5_core_dev *dev)
 	mutex_destroy(&priv->bfregs.wc_head.lock);
 	mutex_destroy(&priv->bfregs.reg_head.lock);
 	mutex_destroy(&dev->intf_state_mutex);
+	lockdep_unregister_key(&dev->lock_key);
 }
 
 static int probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index 54a91d2b33b5..fa4c596e6ec6 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -74,11 +74,6 @@ static int moxart_set_mac_address(struct net_device *ndev, void *addr)
 static void moxart_mac_free_memory(struct net_device *ndev)
 {
 	struct moxart_mac_priv_t *priv = netdev_priv(ndev);
-	int i;
-
-	for (i = 0; i < RX_DESC_NUM; i++)
-		dma_unmap_single(&priv->pdev->dev, priv->rx_mapping[i],
-				 priv->rx_buf_size, DMA_FROM_DEVICE);
 
 	if (priv->tx_desc_base)
 		dma_free_coherent(&priv->pdev->dev,
@@ -193,6 +188,7 @@ static int moxart_mac_open(struct net_device *ndev)
 static int moxart_mac_stop(struct net_device *ndev)
 {
 	struct moxart_mac_priv_t *priv = netdev_priv(ndev);
+	int i;
 
 	napi_disable(&priv->napi);
 
@@ -204,6 +200,11 @@ static int moxart_mac_stop(struct net_device *ndev)
 	/* disable all functions */
 	writel(0, priv->base + REG_MAC_CTRL);
 
+	/* unmap areas mapped in moxart_mac_setup_desc_ring() */
+	for (i = 0; i < RX_DESC_NUM; i++)
+		dma_unmap_single(&priv->pdev->dev, priv->rx_mapping[i],
+				 priv->rx_buf_size, DMA_FROM_DEVICE);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 781313dbd04f..c713a3ee6571 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1692,8 +1692,67 @@ static int ionic_set_features(struct net_device *netdev,
 	return err;
 }
 
+static int ionic_set_attr_mac(struct ionic_lif *lif, u8 *mac)
+{
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.lif_setattr = {
+			.opcode = IONIC_CMD_LIF_SETATTR,
+			.index = cpu_to_le16(lif->index),
+			.attr = IONIC_LIF_ATTR_MAC,
+		},
+	};
+
+	ether_addr_copy(ctx.cmd.lif_setattr.mac, mac);
+	return ionic_adminq_post_wait(lif, &ctx);
+}
+
+static int ionic_get_attr_mac(struct ionic_lif *lif, u8 *mac_addr)
+{
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.lif_getattr = {
+			.opcode = IONIC_CMD_LIF_GETATTR,
+			.index = cpu_to_le16(lif->index),
+			.attr = IONIC_LIF_ATTR_MAC,
+		},
+	};
+	int err;
+
+	err = ionic_adminq_post_wait(lif, &ctx);
+	if (err)
+		return err;
+
+	ether_addr_copy(mac_addr, ctx.comp.lif_getattr.mac);
+	return 0;
+}
+
+static int ionic_program_mac(struct ionic_lif *lif, u8 *mac)
+{
+	u8  get_mac[ETH_ALEN];
+	int err;
+
+	err = ionic_set_attr_mac(lif, mac);
+	if (err)
+		return err;
+
+	err = ionic_get_attr_mac(lif, get_mac);
+	if (err)
+		return err;
+
+	/* To deal with older firmware that silently ignores the set attr mac:
+	 * doesn't actually change the mac and doesn't return an error, so we
+	 * do the get attr to verify whether or not the set actually happened
+	 */
+	if (!ether_addr_equal(get_mac, mac))
+		return 1;
+
+	return 0;
+}
+
 static int ionic_set_mac_address(struct net_device *netdev, void *sa)
 {
+	struct ionic_lif *lif = netdev_priv(netdev);
 	struct sockaddr *addr = sa;
 	u8 *mac;
 	int err;
@@ -1702,6 +1761,14 @@ static int ionic_set_mac_address(struct net_device *netdev, void *sa)
 	if (ether_addr_equal(netdev->dev_addr, mac))
 		return 0;
 
+	err = ionic_program_mac(lif, mac);
+	if (err < 0)
+		return err;
+
+	if (err > 0)
+		netdev_dbg(netdev, "%s: SET and GET ATTR Mac are not equal-due to old FW running\n",
+			   __func__);
+
 	err = eth_prepare_mac_addr_change(netdev, addr);
 	if (err)
 		return err;
@@ -2974,11 +3041,10 @@ static void ionic_lif_handle_fw_down(struct ionic_lif *lif)
 
 	netif_device_detach(lif->netdev);
 
+	mutex_lock(&lif->queue_lock);
 	if (test_bit(IONIC_LIF_F_UP, lif->state)) {
 		dev_info(ionic->dev, "Surprise FW stop, stopping queues\n");
-		mutex_lock(&lif->queue_lock);
 		ionic_stop_queues(lif);
-		mutex_unlock(&lif->queue_lock);
 	}
 
 	if (netif_running(lif->netdev)) {
@@ -2989,6 +3055,8 @@ static void ionic_lif_handle_fw_down(struct ionic_lif *lif)
 	ionic_reset(ionic);
 	ionic_qcqs_free(lif);
 
+	mutex_unlock(&lif->queue_lock);
+
 	dev_info(ionic->dev, "FW Down: LIFs stopped\n");
 }
 
@@ -3012,9 +3080,15 @@ static void ionic_lif_handle_fw_up(struct ionic_lif *lif)
 	err = ionic_port_init(ionic);
 	if (err)
 		goto err_out;
+
+	mutex_lock(&lif->queue_lock);
+
+	if (test_and_clear_bit(IONIC_LIF_F_BROKEN, lif->state))
+		dev_info(ionic->dev, "FW Up: clearing broken state\n");
+
 	err = ionic_qcqs_alloc(lif);
 	if (err)
-		goto err_out;
+		goto err_unlock;
 
 	err = ionic_lif_init(lif);
 	if (err)
@@ -3035,6 +3109,8 @@ static void ionic_lif_handle_fw_up(struct ionic_lif *lif)
 			goto err_txrx_free;
 	}
 
+	mutex_unlock(&lif->queue_lock);
+
 	clear_bit(IONIC_LIF_F_FW_RESET, lif->state);
 	ionic_link_status_check_request(lif, CAN_SLEEP);
 	netif_device_attach(lif->netdev);
@@ -3051,6 +3127,8 @@ static void ionic_lif_handle_fw_up(struct ionic_lif *lif)
 	ionic_lif_deinit(lif);
 err_qcqs_free:
 	ionic_qcqs_free(lif);
+err_unlock:
+	mutex_unlock(&lif->queue_lock);
 err_out:
 	dev_err(ionic->dev, "FW Up: LIFs restart failed - err %d\n", err);
 }
@@ -3215,6 +3293,7 @@ static int ionic_station_set(struct ionic_lif *lif)
 			.attr = IONIC_LIF_ATTR_MAC,
 		},
 	};
+	u8 mac_address[ETH_ALEN];
 	struct sockaddr addr;
 	int err;
 
@@ -3223,8 +3302,23 @@ static int ionic_station_set(struct ionic_lif *lif)
 		return err;
 	netdev_dbg(lif->netdev, "found initial MAC addr %pM\n",
 		   ctx.comp.lif_getattr.mac);
-	if (is_zero_ether_addr(ctx.comp.lif_getattr.mac))
-		return 0;
+	ether_addr_copy(mac_address, ctx.comp.lif_getattr.mac);
+
+	if (is_zero_ether_addr(mac_address)) {
+		eth_hw_addr_random(netdev);
+		netdev_dbg(netdev, "Random Mac generated: %pM\n", netdev->dev_addr);
+		ether_addr_copy(mac_address, netdev->dev_addr);
+
+		err = ionic_program_mac(lif, mac_address);
+		if (err < 0)
+			return err;
+
+		if (err > 0) {
+			netdev_dbg(netdev, "%s:SET/GET ATTR Mac are not same-due to old FW running\n",
+				   __func__);
+			return 0;
+		}
+	}
 
 	if (!is_zero_ether_addr(netdev->dev_addr)) {
 		/* If the netdev mac is non-zero and doesn't match the default
@@ -3232,12 +3326,11 @@ static int ionic_station_set(struct ionic_lif *lif)
 		 * likely here again after a fw-upgrade reset.  We need to be
 		 * sure the netdev mac is in our filter list.
 		 */
-		if (!ether_addr_equal(ctx.comp.lif_getattr.mac,
-				      netdev->dev_addr))
+		if (!ether_addr_equal(mac_address, netdev->dev_addr))
 			ionic_lif_addr_add(lif, netdev->dev_addr);
 	} else {
 		/* Update the netdev mac with the device's mac */
-		memcpy(addr.sa_data, ctx.comp.lif_getattr.mac, netdev->addr_len);
+		ether_addr_copy(addr.sa_data, mac_address);
 		addr.sa_family = AF_INET;
 		err = eth_prepare_mac_addr_change(netdev, &addr);
 		if (err) {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 480f85bc17f9..9ede66842118 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -395,8 +395,8 @@ int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
 				ionic_opcode_to_str(opcode), opcode,
 				ionic_error_to_str(err), err);
 
-			msleep(1000);
 			iowrite32(0, &idev->dev_cmd_regs->done);
+			msleep(1000);
 			iowrite32(1, &idev->dev_cmd_regs->doorbell);
 			goto try_again;
 		}
@@ -409,6 +409,8 @@ int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
 		return ionic_error_to_errno(err);
 	}
 
+	ionic_dev_cmd_clean(ionic);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
index d1c31200bb91..01d0a14f6752 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
@@ -258,14 +258,18 @@ EXPORT_SYMBOL_GPL(stmmac_set_mac_addr);
 /* Enable disable MAC RX/TX */
 void stmmac_set_mac(void __iomem *ioaddr, bool enable)
 {
-	u32 value = readl(ioaddr + MAC_CTRL_REG);
+	u32 old_val, value;
+
+	old_val = readl(ioaddr + MAC_CTRL_REG);
+	value = old_val;
 
 	if (enable)
 		value |= MAC_ENABLE_RX | MAC_ENABLE_TX;
 	else
 		value &= ~(MAC_ENABLE_TX | MAC_ENABLE_RX);
 
-	writel(value, ioaddr + MAC_CTRL_REG);
+	if (value != old_val)
+		writel(value, ioaddr + MAC_CTRL_REG);
 }
 
 void stmmac_get_mac_addr(void __iomem *ioaddr, unsigned char *addr,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index b4f83c865568..2569673559df 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1083,10 +1083,10 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 			       bool tx_pause, bool rx_pause)
 {
 	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
-	u32 ctrl;
+	u32 old_ctrl, ctrl;
 
-	ctrl = readl(priv->ioaddr + MAC_CTRL_REG);
-	ctrl &= ~priv->hw->link.speed_mask;
+	old_ctrl = readl(priv->ioaddr + MAC_CTRL_REG);
+	ctrl = old_ctrl & ~priv->hw->link.speed_mask;
 
 	if (interface == PHY_INTERFACE_MODE_USXGMII) {
 		switch (speed) {
@@ -1161,7 +1161,8 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 	if (tx_pause && rx_pause)
 		stmmac_mac_flow_ctrl(priv, duplex);
 
-	writel(ctrl, priv->ioaddr + MAC_CTRL_REG);
+	if (ctrl != old_ctrl)
+		writel(ctrl, priv->ioaddr + MAC_CTRL_REG);
 
 	stmmac_mac_set(priv, priv->ioaddr, true);
 	if (phy && priv->dma_cap.eee) {
diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 287ae4c538aa..6472425539e1 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -1325,7 +1325,7 @@ static void cas_init_rx_dma(struct cas *cp)
 	writel(val, cp->regs + REG_RX_PAGE_SIZE);
 
 	/* enable the header parser if desired */
-	if (CAS_HP_FIRMWARE == cas_prog_null)
+	if (&CAS_HP_FIRMWARE[0] == &cas_prog_null[0])
 		return;
 
 	val = CAS_BASE(HP_CFG_NUM_CPU, CAS_NCPUS > 63 ? 0 : CAS_NCPUS);
@@ -3794,7 +3794,7 @@ static void cas_reset(struct cas *cp, int blkflag)
 
 	/* program header parser */
 	if ((cp->cas_flags & CAS_FLAG_TARGET_ABORT) ||
-	    (CAS_HP_ALT_FIRMWARE == cas_prog_null)) {
+	    (&CAS_HP_ALT_FIRMWARE[0] == &cas_prog_null[0])) {
 		cas_load_firmware(cp, CAS_HP_FIRMWARE);
 	} else {
 		cas_load_firmware(cp, CAS_HP_ALT_FIRMWARE);
diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index 4337b0920d3d..cad0798985a1 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -570,7 +570,7 @@ static int ipa_smem_init(struct ipa *ipa, u32 item, size_t size)
 	}
 
 	/* Align the address down and the size up to a page boundary */
-	addr = qcom_smem_virt_to_phys(virt) & PAGE_MASK;
+	addr = qcom_smem_virt_to_phys(virt);
 	phys = addr & PAGE_MASK;
 	size = PAGE_ALIGN(size + addr - phys);
 	iova = phys;	/* We just want a direct mapping */
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index c0b21a5580d5..3f43c253adac 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -787,7 +787,7 @@ static int ipvlan_device_event(struct notifier_block *unused,
 
 	case NETDEV_CHANGEADDR:
 		list_for_each_entry(ipvlan, &port->ipvlans, pnode) {
-			ether_addr_copy(ipvlan->dev->dev_addr, dev->dev_addr);
+			eth_hw_addr_set(ipvlan->dev, dev->dev_addr);
 			call_netdevice_notifiers(NETDEV_CHANGEADDR, ipvlan->dev);
 		}
 		break;
diff --git a/drivers/net/ipvlan/ipvtap.c b/drivers/net/ipvlan/ipvtap.c
index 1cedb634f4f7..f01078b2581c 100644
--- a/drivers/net/ipvlan/ipvtap.c
+++ b/drivers/net/ipvlan/ipvtap.c
@@ -194,7 +194,7 @@ static struct notifier_block ipvtap_notifier_block __read_mostly = {
 	.notifier_call	= ipvtap_device_event,
 };
 
-static int ipvtap_init(void)
+static int __init ipvtap_init(void)
 {
 	int err;
 
@@ -228,7 +228,7 @@ static int ipvtap_init(void)
 }
 module_init(ipvtap_init);
 
-static void ipvtap_exit(void)
+static void __exit ipvtap_exit(void)
 {
 	rtnl_link_unregister(&ipvtap_link_ops);
 	unregister_netdevice_notifier(&ipvtap_notifier_block);
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 354890948f8a..71700f279278 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -447,11 +447,6 @@ static struct macsec_eth_header *macsec_ethhdr(struct sk_buff *skb)
 	return (struct macsec_eth_header *)skb_mac_header(skb);
 }
 
-static sci_t dev_to_sci(struct net_device *dev, __be16 port)
-{
-	return make_sci(dev->dev_addr, port);
-}
-
 static void __macsec_pn_wrapped(struct macsec_secy *secy,
 				struct macsec_tx_sa *tx_sa)
 {
@@ -3616,8 +3611,7 @@ static int macsec_set_mac_address(struct net_device *dev, void *p)
 	dev_uc_del(real_dev, dev->dev_addr);
 
 out:
-	ether_addr_copy(dev->dev_addr, addr->sa_data);
-	macsec->secy.sci = dev_to_sci(dev, MACSEC_PORT_ES);
+	eth_hw_addr_set(dev, addr->sa_data);
 
 	/* If h/w offloading is available, propagate to the device */
 	if (macsec_is_offloaded(macsec)) {
@@ -3953,6 +3947,11 @@ static bool sci_exists(struct net_device *dev, sci_t sci)
 	return false;
 }
 
+static sci_t dev_to_sci(struct net_device *dev, __be16 port)
+{
+	return make_sci(dev->dev_addr, port);
+}
+
 static int macsec_add_dev(struct net_device *dev, sci_t sci, u8 icv_len)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index a9a515cf5a46..6363459ba1d0 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -711,7 +711,7 @@ static int macvlan_sync_address(struct net_device *dev, unsigned char *addr)
 
 	if (!(dev->flags & IFF_UP)) {
 		/* Just copy in the new address */
-		ether_addr_copy(dev->dev_addr, addr);
+		eth_hw_addr_set(dev, addr);
 	} else {
 		/* Rehash and update the device filters */
 		if (macvlan_addr_busy(vlan->port, addr))
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 834a68d75832..b616f55ea222 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -315,11 +315,11 @@ static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
 
 	phydev->suspended_by_mdio_bus = 0;
 
-	/* If we managed to get here with the PHY state machine in a state other
-	 * than PHY_HALTED this is an indication that something went wrong and
-	 * we should most likely be using MAC managed PM and we are not.
+	/* If we manged to get here with the PHY state machine in a state neither
+	 * PHY_HALTED nor PHY_READY this is an indication that something went wrong
+	 * and we should most likely be using MAC managed PM and we are not.
 	 */
-	WARN_ON(phydev->state != PHY_HALTED && !phydev->mac_managed_pm);
+	WARN_ON(phydev->state != PHY_HALTED && phydev->state != PHY_READY);
 
 	ret = phy_init_hw(phydev);
 	if (ret < 0)
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 0d1d92ef7909..7e821bed91ce 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -5904,6 +5904,11 @@ static void r8153_enter_oob(struct r8152 *tp)
 	ocp_data &= ~NOW_IS_OOB;
 	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
 
+	/* RX FIFO settings for OOB */
+	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL0, RXFIFO_THR1_OOB);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL1, RXFIFO_THR2_OOB);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL2, RXFIFO_THR3_OOB);
+
 	rtl_disable(tp);
 	rtl_reset_bmu(tp);
 
@@ -6429,21 +6434,8 @@ static void r8156_fc_parameter(struct r8152 *tp)
 	u32 pause_on = tp->fc_pause_on ? tp->fc_pause_on : fc_pause_on_auto(tp);
 	u32 pause_off = tp->fc_pause_off ? tp->fc_pause_off : fc_pause_off_auto(tp);
 
-	switch (tp->version) {
-	case RTL_VER_10:
-	case RTL_VER_11:
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_RX_FIFO_FULL, pause_on / 8);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_RX_FIFO_EMPTY, pause_off / 8);
-		break;
-	case RTL_VER_12:
-	case RTL_VER_13:
-	case RTL_VER_15:
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_RX_FIFO_FULL, pause_on / 16);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_RX_FIFO_EMPTY, pause_off / 16);
-		break;
-	default:
-		break;
-	}
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RX_FIFO_FULL, pause_on / 16);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RX_FIFO_EMPTY, pause_off / 16);
 }
 
 static void rtl8156_change_mtu(struct r8152 *tp)
@@ -6555,6 +6547,11 @@ static void rtl8156_down(struct r8152 *tp)
 	ocp_data &= ~NOW_IS_OOB;
 	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
 
+	/* RX FIFO settings for OOB */
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RXFIFO_FULL, 64 / 16);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RX_FIFO_FULL, 1024 / 16);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RX_FIFO_EMPTY, 4096 / 16);
+
 	rtl_disable(tp);
 	rtl_reset_bmu(tp);
 
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 460e90eb528f..7cf9206638c3 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -18,8 +18,6 @@
 #include <linux/usb/usbnet.h>
 #include <linux/slab.h>
 #include <linux/of_net.h>
-#include <linux/irq.h>
-#include <linux/irqdomain.h>
 #include <linux/mdio.h>
 #include <linux/phy.h>
 #include "smsc95xx.h"
@@ -53,9 +51,6 @@
 #define SUSPEND_ALLMODES		(SUSPEND_SUSPEND0 | SUSPEND_SUSPEND1 | \
 					 SUSPEND_SUSPEND2 | SUSPEND_SUSPEND3)
 
-#define SMSC95XX_NR_IRQS		(1) /* raise to 12 for GPIOs */
-#define PHY_HWIRQ			(SMSC95XX_NR_IRQS - 1)
-
 struct smsc95xx_priv {
 	u32 mac_cr;
 	u32 hash_hi;
@@ -64,12 +59,8 @@ struct smsc95xx_priv {
 	spinlock_t mac_cr_lock;
 	u8 features;
 	u8 suspend_flags;
-	struct irq_chip irqchip;
-	struct irq_domain *irqdomain;
-	struct fwnode_handle *irqfwnode;
 	struct mii_bus *mdiobus;
 	struct phy_device *phydev;
-	struct task_struct *pm_task;
 };
 
 static bool turbo_mode = true;
@@ -79,14 +70,13 @@ MODULE_PARM_DESC(turbo_mode, "Enable multiple frames per Rx transaction");
 static int __must_check __smsc95xx_read_reg(struct usbnet *dev, u32 index,
 					    u32 *data, int in_pm)
 {
-	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 buf;
 	int ret;
 	int (*fn)(struct usbnet *, u8, u8, u16, u16, void *, u16);
 
 	BUG_ON(!dev);
 
-	if (current != pdata->pm_task)
+	if (!in_pm)
 		fn = usbnet_read_cmd;
 	else
 		fn = usbnet_read_cmd_nopm;
@@ -110,14 +100,13 @@ static int __must_check __smsc95xx_read_reg(struct usbnet *dev, u32 index,
 static int __must_check __smsc95xx_write_reg(struct usbnet *dev, u32 index,
 					     u32 data, int in_pm)
 {
-	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 buf;
 	int ret;
 	int (*fn)(struct usbnet *, u8, u8, u16, u16, const void *, u16);
 
 	BUG_ON(!dev);
 
-	if (current != pdata->pm_task)
+	if (!in_pm)
 		fn = usbnet_write_cmd;
 	else
 		fn = usbnet_write_cmd_nopm;
@@ -606,8 +595,6 @@ static void smsc95xx_mac_update_fullduplex(struct usbnet *dev)
 
 static void smsc95xx_status(struct usbnet *dev, struct urb *urb)
 {
-	struct smsc95xx_priv *pdata = dev->driver_priv;
-	unsigned long flags;
 	u32 intdata;
 
 	if (urb->actual_length != 4) {
@@ -619,15 +606,11 @@ static void smsc95xx_status(struct usbnet *dev, struct urb *urb)
 	intdata = get_unaligned_le32(urb->transfer_buffer);
 	netif_dbg(dev, link, dev->net, "intdata: 0x%08X\n", intdata);
 
-	local_irq_save(flags);
-
 	if (intdata & INT_ENP_PHY_INT_)
-		generic_handle_domain_irq(pdata->irqdomain, PHY_HWIRQ);
+		;
 	else
 		netdev_warn(dev->net, "unexpected interrupt, intdata=0x%08X\n",
 			    intdata);
-
-	local_irq_restore(flags);
 }
 
 /* Enable or disable Tx & Rx checksum offload engines */
@@ -1089,9 +1072,8 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 {
 	struct smsc95xx_priv *pdata;
 	bool is_internal_phy;
-	char usb_path[64];
-	int ret, phy_irq;
 	u32 val;
+	int ret;
 
 	printk(KERN_INFO SMSC_CHIPNAME " v" SMSC_DRIVER_VERSION "\n");
 
@@ -1131,38 +1113,10 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	if (ret)
 		goto free_pdata;
 
-	/* create irq domain for use by PHY driver and GPIO consumers */
-	usb_make_path(dev->udev, usb_path, sizeof(usb_path));
-	pdata->irqfwnode = irq_domain_alloc_named_fwnode(usb_path);
-	if (!pdata->irqfwnode) {
-		ret = -ENOMEM;
-		goto free_pdata;
-	}
-
-	pdata->irqdomain = irq_domain_create_linear(pdata->irqfwnode,
-						    SMSC95XX_NR_IRQS,
-						    &irq_domain_simple_ops,
-						    pdata);
-	if (!pdata->irqdomain) {
-		ret = -ENOMEM;
-		goto free_irqfwnode;
-	}
-
-	phy_irq = irq_create_mapping(pdata->irqdomain, PHY_HWIRQ);
-	if (!phy_irq) {
-		ret = -ENOENT;
-		goto remove_irqdomain;
-	}
-
-	pdata->irqchip = dummy_irq_chip;
-	pdata->irqchip.name = SMSC_CHIPNAME;
-	irq_set_chip_and_handler_name(phy_irq, &pdata->irqchip,
-				      handle_simple_irq, "phy");
-
 	pdata->mdiobus = mdiobus_alloc();
 	if (!pdata->mdiobus) {
 		ret = -ENOMEM;
-		goto dispose_irq;
+		goto free_pdata;
 	}
 
 	ret = smsc95xx_read_reg(dev, HW_CFG, &val);
@@ -1195,7 +1149,6 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 		goto unregister_mdio;
 	}
 
-	pdata->phydev->irq = phy_irq;
 	pdata->phydev->is_internal = is_internal_phy;
 
 	/* detect device revision as different features may be available */
@@ -1238,15 +1191,6 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 free_mdio:
 	mdiobus_free(pdata->mdiobus);
 
-dispose_irq:
-	irq_dispose_mapping(phy_irq);
-
-remove_irqdomain:
-	irq_domain_remove(pdata->irqdomain);
-
-free_irqfwnode:
-	irq_domain_free_fwnode(pdata->irqfwnode);
-
 free_pdata:
 	kfree(pdata);
 	return ret;
@@ -1259,9 +1203,6 @@ static void smsc95xx_unbind(struct usbnet *dev, struct usb_interface *intf)
 	phy_disconnect(dev->net->phydev);
 	mdiobus_unregister(pdata->mdiobus);
 	mdiobus_free(pdata->mdiobus);
-	irq_dispose_mapping(irq_find_mapping(pdata->irqdomain, PHY_HWIRQ));
-	irq_domain_remove(pdata->irqdomain);
-	irq_domain_free_fwnode(pdata->irqfwnode);
 	netif_dbg(dev, ifdown, dev->net, "free pdata\n");
 	kfree(pdata);
 }
@@ -1286,6 +1227,29 @@ static u32 smsc_crc(const u8 *buffer, size_t len, int filter)
 	return crc << ((filter % 2) * 16);
 }
 
+static int smsc95xx_enable_phy_wakeup_interrupts(struct usbnet *dev, u16 mask)
+{
+	int ret;
+
+	netdev_dbg(dev->net, "enabling PHY wakeup interrupts\n");
+
+	/* read to clear */
+	ret = smsc95xx_mdio_read_nopm(dev, PHY_INT_SRC);
+	if (ret < 0)
+		return ret;
+
+	/* enable interrupt source */
+	ret = smsc95xx_mdio_read_nopm(dev, PHY_INT_MASK);
+	if (ret < 0)
+		return ret;
+
+	ret |= mask;
+
+	smsc95xx_mdio_write_nopm(dev, PHY_INT_MASK, ret);
+
+	return 0;
+}
+
 static int smsc95xx_link_ok_nopm(struct usbnet *dev)
 {
 	int ret;
@@ -1452,6 +1416,7 @@ static int smsc95xx_enter_suspend3(struct usbnet *dev)
 static int smsc95xx_autosuspend(struct usbnet *dev, u32 link_up)
 {
 	struct smsc95xx_priv *pdata = dev->driver_priv;
+	int ret;
 
 	if (!netif_running(dev->net)) {
 		/* interface is ifconfig down so fully power down hw */
@@ -1470,10 +1435,27 @@ static int smsc95xx_autosuspend(struct usbnet *dev, u32 link_up)
 		}
 
 		netdev_dbg(dev->net, "autosuspend entering SUSPEND1\n");
+
+		/* enable PHY wakeup events for if cable is attached */
+		ret = smsc95xx_enable_phy_wakeup_interrupts(dev,
+			PHY_INT_MASK_ANEG_COMP_);
+		if (ret < 0) {
+			netdev_warn(dev->net, "error enabling PHY wakeup ints\n");
+			return ret;
+		}
+
 		netdev_info(dev->net, "entering SUSPEND1 mode\n");
 		return smsc95xx_enter_suspend1(dev);
 	}
 
+	/* enable PHY wakeup events so we remote wakeup if cable is pulled */
+	ret = smsc95xx_enable_phy_wakeup_interrupts(dev,
+		PHY_INT_MASK_LINK_DOWN_);
+	if (ret < 0) {
+		netdev_warn(dev->net, "error enabling PHY wakeup ints\n");
+		return ret;
+	}
+
 	netdev_dbg(dev->net, "autosuspend entering SUSPEND3\n");
 	return smsc95xx_enter_suspend3(dev);
 }
@@ -1485,12 +1467,9 @@ static int smsc95xx_suspend(struct usb_interface *intf, pm_message_t message)
 	u32 val, link_up;
 	int ret;
 
-	pdata->pm_task = current;
-
 	ret = usbnet_suspend(intf, message);
 	if (ret < 0) {
 		netdev_warn(dev->net, "usbnet_suspend error\n");
-		pdata->pm_task = NULL;
 		return ret;
 	}
 
@@ -1542,6 +1521,13 @@ static int smsc95xx_suspend(struct usb_interface *intf, pm_message_t message)
 	}
 
 	if (pdata->wolopts & WAKE_PHY) {
+		ret = smsc95xx_enable_phy_wakeup_interrupts(dev,
+			(PHY_INT_MASK_ANEG_COMP_ | PHY_INT_MASK_LINK_DOWN_));
+		if (ret < 0) {
+			netdev_warn(dev->net, "error enabling PHY wakeup ints\n");
+			goto done;
+		}
+
 		/* if link is down then configure EDPD and enter SUSPEND1,
 		 * otherwise enter SUSPEND0 below
 		 */
@@ -1730,7 +1716,6 @@ static int smsc95xx_suspend(struct usb_interface *intf, pm_message_t message)
 	if (ret && PMSG_IS_AUTO(message))
 		usbnet_resume(intf);
 
-	pdata->pm_task = NULL;
 	return ret;
 }
 
@@ -1751,53 +1736,45 @@ static int smsc95xx_resume(struct usb_interface *intf)
 	/* do this first to ensure it's cleared even in error case */
 	pdata->suspend_flags = 0;
 
-	pdata->pm_task = current;
-
 	if (suspend_flags & SUSPEND_ALLMODES) {
 		/* clear wake-up sources */
 		ret = smsc95xx_read_reg_nopm(dev, WUCSR, &val);
 		if (ret < 0)
-			goto done;
+			return ret;
 
 		val &= ~(WUCSR_WAKE_EN_ | WUCSR_MPEN_);
 
 		ret = smsc95xx_write_reg_nopm(dev, WUCSR, val);
 		if (ret < 0)
-			goto done;
+			return ret;
 
 		/* clear wake-up status */
 		ret = smsc95xx_read_reg_nopm(dev, PM_CTRL, &val);
 		if (ret < 0)
-			goto done;
+			return ret;
 
 		val &= ~PM_CTL_WOL_EN_;
 		val |= PM_CTL_WUPS_;
 
 		ret = smsc95xx_write_reg_nopm(dev, PM_CTRL, val);
 		if (ret < 0)
-			goto done;
+			return ret;
 	}
 
-	phy_init_hw(pdata->phydev);
-
 	ret = usbnet_resume(intf);
 	if (ret < 0)
 		netdev_warn(dev->net, "usbnet_resume error\n");
 
-done:
-	pdata->pm_task = NULL;
+	phy_init_hw(pdata->phydev);
 	return ret;
 }
 
 static int smsc95xx_reset_resume(struct usb_interface *intf)
 {
 	struct usbnet *dev = usb_get_intfdata(intf);
-	struct smsc95xx_priv *pdata = dev->driver_priv;
 	int ret;
 
-	pdata->pm_task = current;
 	ret = smsc95xx_reset(dev);
-	pdata->pm_task = NULL;
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index 9b83c710c9b8..743e38a1aa51 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -2386,10 +2386,7 @@ void rtl92d_phy_reload_iqk_setting(struct ieee80211_hw *hw, u8 channel)
 			rtl_dbg(rtlpriv, COMP_SCAN, DBG_LOUD,
 				"Just Read IQK Matrix reg for channel:%d....\n",
 				channel);
-			if ((rtlphy->iqk_matrix[indexforchannel].
-			     value[0] != NULL)
-				/*&&(regea4 != 0) */)
-				_rtl92d_phy_patha_fill_iqk_matrix(hw, true,
+			_rtl92d_phy_patha_fill_iqk_matrix(hw, true,
 					rtlphy->iqk_matrix[
 					indexforchannel].value,	0,
 					(rtlphy->iqk_matrix[
diff --git a/drivers/nfc/pn533/uart.c b/drivers/nfc/pn533/uart.c
index 7bdaf8263070..7ad98973648c 100644
--- a/drivers/nfc/pn533/uart.c
+++ b/drivers/nfc/pn533/uart.c
@@ -310,6 +310,7 @@ static void pn532_uart_remove(struct serdev_device *serdev)
 	pn53x_unregister_nfc(pn532->priv);
 	serdev_device_close(serdev);
 	pn53x_common_clean(pn532->priv);
+	del_timer_sync(&pn532->cmd_timeout);
 	kfree_skb(pn532->recv_skb);
 	kfree(pn532);
 }
diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index 46bc30fe85d2..235553337fb2 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -34,8 +34,7 @@ static int validate_conv_zones_cb(struct blk_zone *z,
 
 bool nvmet_bdev_zns_enable(struct nvmet_ns *ns)
 {
-	struct request_queue *q = ns->bdev->bd_disk->queue;
-	u8 zasl = nvmet_zasl(queue_max_zone_append_sectors(q));
+	u8 zasl = nvmet_zasl(bdev_max_zone_append_sectors(ns->bdev));
 	struct gendisk *bd_disk = ns->bdev->bd_disk;
 	int ret;
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 2a6d613a76cf..f82e4a348330 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -192,6 +192,8 @@ extern int ql2xfulldump_on_mpifail;
 extern int ql2xsecenable;
 extern int ql2xenforce_iocb_limit;
 extern int ql2xabts_wait_nvme;
+extern int ql2xrspq_follow_inptr;
+extern int ql2xrspq_follow_inptr_legacy;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index b218f9739619..59f5918dca95 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3707,12 +3707,11 @@ void qla24xx_nvme_ls4_iocb(struct scsi_qla_host *vha,
  * Return: 0 all iocbs has arrived, xx- all iocbs have not arrived.
  */
 static int qla_chk_cont_iocb_avail(struct scsi_qla_host *vha,
-	struct rsp_que *rsp, response_t *pkt)
+	struct rsp_que *rsp, response_t *pkt, u32 rsp_q_in)
 {
-	int start_pkt_ring_index, end_pkt_ring_index, n_ring_index;
-	response_t *end_pkt;
+	int start_pkt_ring_index;
+	u32 iocb_cnt = 0;
 	int rc = 0;
-	u32 rsp_q_in;
 
 	if (pkt->entry_count == 1)
 		return rc;
@@ -3723,34 +3722,18 @@ static int qla_chk_cont_iocb_avail(struct scsi_qla_host *vha,
 	else
 		start_pkt_ring_index = rsp->ring_index - 1;
 
-	if ((start_pkt_ring_index + pkt->entry_count) >= rsp->length)
-		end_pkt_ring_index = start_pkt_ring_index + pkt->entry_count -
-			rsp->length - 1;
+	if (rsp_q_in < start_pkt_ring_index)
+		/* q in ptr is wrapped */
+		iocb_cnt = rsp->length - start_pkt_ring_index + rsp_q_in;
 	else
-		end_pkt_ring_index = start_pkt_ring_index + pkt->entry_count - 1;
+		iocb_cnt = rsp_q_in - start_pkt_ring_index;
 
-	end_pkt = rsp->ring + end_pkt_ring_index;
-
-	/*  next pkt = end_pkt + 1 */
-	n_ring_index = end_pkt_ring_index + 1;
-	if (n_ring_index >= rsp->length)
-		n_ring_index = 0;
-
-	rsp_q_in = rsp->qpair->use_shadow_reg ? *rsp->in_ptr :
-		rd_reg_dword(rsp->rsp_q_in);
-
-	/* rsp_q_in is either wrapped or pointing beyond endpkt */
-	if ((rsp_q_in < start_pkt_ring_index && rsp_q_in < n_ring_index) ||
-			rsp_q_in >= n_ring_index)
-		/* all IOCBs arrived. */
-		rc = 0;
-	else
+	if (iocb_cnt < pkt->entry_count)
 		rc = -EIO;
 
-	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x5091,
-	    "%s - ring %p pkt %p end pkt %p entry count %#x rsp_q_in %d rc %d\n",
-	    __func__, rsp->ring, pkt, end_pkt, pkt->entry_count,
-	    rsp_q_in, rc);
+	ql_dbg(ql_dbg_init, vha, 0x5091,
+	       "%s - ring %p pkt %p entry count %d iocb_cnt %d rsp_q_in %d rc %d\n",
+	       __func__, rsp->ring, pkt, pkt->entry_count, iocb_cnt, rsp_q_in, rc);
 
 	return rc;
 }
@@ -3767,6 +3750,8 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 	struct qla_hw_data *ha = vha->hw;
 	struct purex_entry_24xx *purex_entry;
 	struct purex_item *pure_item;
+	u16 rsp_in = 0, cur_ring_index;
+	int follow_inptr, is_shadow_hba;
 
 	if (!ha->flags.fw_started)
 		return;
@@ -3776,8 +3761,27 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 		qla_cpu_update(rsp->qpair, smp_processor_id());
 	}
 
-	while (rsp->ring_ptr->signature != RESPONSE_PROCESSED) {
+#define __update_rsp_in(_update, _is_shadow_hba, _rsp, _rsp_in)		\
+	do {								\
+		if (_update) {						\
+			_rsp_in = _is_shadow_hba ? *(_rsp)->in_ptr :	\
+				rd_reg_dword_relaxed((_rsp)->rsp_q_in);	\
+		}							\
+	} while (0)
+
+	is_shadow_hba = IS_SHADOW_REG_CAPABLE(ha);
+	follow_inptr = is_shadow_hba ? ql2xrspq_follow_inptr :
+				ql2xrspq_follow_inptr_legacy;
+
+	__update_rsp_in(follow_inptr, is_shadow_hba, rsp, rsp_in);
+
+	while ((likely(follow_inptr &&
+		       rsp->ring_index != rsp_in &&
+		       rsp->ring_ptr->signature != RESPONSE_PROCESSED)) ||
+		       (!follow_inptr &&
+			rsp->ring_ptr->signature != RESPONSE_PROCESSED)) {
 		pkt = (struct sts_entry_24xx *)rsp->ring_ptr;
+		cur_ring_index = rsp->ring_index;
 
 		rsp->ring_index++;
 		if (rsp->ring_index == rsp->length) {
@@ -3889,6 +3893,8 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 				}
 				pure_item = qla27xx_copy_fpin_pkt(vha,
 							  (void **)&pkt, &rsp);
+				__update_rsp_in(follow_inptr, is_shadow_hba,
+						rsp, rsp_in);
 				if (!pure_item)
 					break;
 				qla24xx_queue_purex_item(vha, pure_item,
@@ -3896,7 +3902,17 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 				break;
 
 			case ELS_AUTH_ELS:
-				if (qla_chk_cont_iocb_avail(vha, rsp, (response_t *)pkt)) {
+				if (qla_chk_cont_iocb_avail(vha, rsp, (response_t *)pkt, rsp_in)) {
+					/*
+					 * ring_ptr and ring_index were
+					 * pre-incremented above. Reset them
+					 * back to current. Wait for next
+					 * interrupt with all IOCBs to arrive
+					 * and re-process.
+					 */
+					rsp->ring_ptr = (response_t *)pkt;
+					rsp->ring_index = cur_ring_index;
+
 					ql_dbg(ql_dbg_init, vha, 0x5091,
 					    "Defer processing ELS opcode %#x...\n",
 					    purex_entry->els_frame_payload[3]);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 6542a258cb75..00e97f0a07eb 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -338,6 +338,16 @@ module_param(ql2xdelay_before_pci_error_handling, uint, 0644);
 MODULE_PARM_DESC(ql2xdelay_before_pci_error_handling,
 	"Number of seconds delayed before qla begin PCI error self-handling (default: 5).\n");
 
+int ql2xrspq_follow_inptr = 1;
+module_param(ql2xrspq_follow_inptr, int, 0644);
+MODULE_PARM_DESC(ql2xrspq_follow_inptr,
+		 "Follow RSP IN pointer for RSP updates for HBAs 27xx and newer (default: 1).");
+
+int ql2xrspq_follow_inptr_legacy = 1;
+module_param(ql2xrspq_follow_inptr_legacy, int, 0644);
+MODULE_PARM_DESC(ql2xrspq_follow_inptr_legacy,
+		 "Follow RSP IN pointer for RSP updates for HBAs older than 27XX. (default: 1).");
+
 static void qla2x00_clear_drv_active(struct qla_hw_data *);
 static void qla2x00_free_device(scsi_qla_host_t *);
 static int qla2xxx_map_queues(struct Scsi_Host *shost);
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 71c7f7b435c4..3d03e1ca5820 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -2093,7 +2093,7 @@ static int storvsc_probe(struct hv_device *device,
 	 */
 	host_dev->handle_error_wq =
 			alloc_ordered_workqueue("storvsc_error_wq_%d",
-						WQ_MEM_RECLAIM,
+						0,
 						host->host_no);
 	if (!host_dev->handle_error_wq) {
 		ret = -ENOMEM;
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 3ed60068c4ea..8dbe9866ea6c 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -133,11 +133,7 @@ static inline u32 ufshci_version(u32 major, u32 minor)
 
 #define UFSHCD_UIC_MASK		(UIC_COMMAND_COMPL | UFSHCD_UIC_PWR_MASK)
 
-#define UFSHCD_ERROR_MASK	(UIC_ERROR |\
-				DEVICE_FATAL_ERROR |\
-				CONTROLLER_FATAL_ERROR |\
-				SYSTEM_BUS_FATAL_ERROR |\
-				CRYPTO_ENGINE_FATAL_ERROR)
+#define UFSHCD_ERROR_MASK	(UIC_ERROR | INT_FATAL_ERRORS)
 
 #define INT_FATAL_ERRORS	(DEVICE_FATAL_ERROR |\
 				CONTROLLER_FATAL_ERROR |\
diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index fb02105d6337..e035a63bbe5b 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2413,15 +2413,21 @@ static int fbcon_do_set_font(struct vc_data *vc, int w, int h, int charcount,
 	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
 	struct fbcon_ops *ops = info->fbcon_par;
 	struct fbcon_display *p = &fb_display[vc->vc_num];
-	int resize;
+	int resize, ret, old_userfont, old_width, old_height, old_charcount;
 	char *old_data = NULL;
 
 	resize = (w != vc->vc_font.width) || (h != vc->vc_font.height);
 	if (p->userfont)
 		old_data = vc->vc_font.data;
 	vc->vc_font.data = (void *)(p->fontdata = data);
+	old_userfont = p->userfont;
 	if ((p->userfont = userfont))
 		REFCOUNT(data)++;
+
+	old_width = vc->vc_font.width;
+	old_height = vc->vc_font.height;
+	old_charcount = vc->vc_font.charcount;
+
 	vc->vc_font.width = w;
 	vc->vc_font.height = h;
 	vc->vc_font.charcount = charcount;
@@ -2437,7 +2443,9 @@ static int fbcon_do_set_font(struct vc_data *vc, int w, int h, int charcount,
 		rows = FBCON_SWAP(ops->rotate, info->var.yres, info->var.xres);
 		cols /= w;
 		rows /= h;
-		vc_resize(vc, cols, rows);
+		ret = vc_resize(vc, cols, rows);
+		if (ret)
+			goto err_out;
 	} else if (con_is_visible(vc)
 		   && vc->vc_mode == KD_TEXT) {
 		fbcon_clear_margins(vc, 0);
@@ -2447,6 +2455,21 @@ static int fbcon_do_set_font(struct vc_data *vc, int w, int h, int charcount,
 	if (old_data && (--REFCOUNT(old_data) == 0))
 		kfree(old_data - FONT_EXTRA_WORDS * sizeof(int));
 	return 0;
+
+err_out:
+	p->fontdata = old_data;
+	vc->vc_font.data = (void *)old_data;
+
+	if (userfont) {
+		p->userfont = old_userfont;
+		REFCOUNT(data)--;
+	}
+
+	vc->vc_font.width = old_width;
+	vc->vc_font.height = old_height;
+	vc->vc_font.charcount = old_charcount;
+
+	return ret;
 }
 
 /*
diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index 3369734108af..e88e8f6f0a33 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -581,27 +581,30 @@ static int lock_pages(
 	struct privcmd_dm_op_buf kbufs[], unsigned int num,
 	struct page *pages[], unsigned int nr_pages, unsigned int *pinned)
 {
-	unsigned int i;
+	unsigned int i, off = 0;
 
-	for (i = 0; i < num; i++) {
+	for (i = 0; i < num; ) {
 		unsigned int requested;
 		int page_count;
 
 		requested = DIV_ROUND_UP(
 			offset_in_page(kbufs[i].uptr) + kbufs[i].size,
-			PAGE_SIZE);
+			PAGE_SIZE) - off;
 		if (requested > nr_pages)
 			return -ENOSPC;
 
 		page_count = pin_user_pages_fast(
-			(unsigned long) kbufs[i].uptr,
+			(unsigned long)kbufs[i].uptr + off * PAGE_SIZE,
 			requested, FOLL_WRITE, pages);
-		if (page_count < 0)
-			return page_count;
+		if (page_count <= 0)
+			return page_count ? : -EFAULT;
 
 		*pinned += page_count;
 		nr_pages -= page_count;
 		pages += page_count;
+
+		off = (requested == page_count) ? 0 : off + page_count;
+		i += !off;
 	}
 
 	return 0;
@@ -677,10 +680,8 @@ static long privcmd_ioctl_dm_op(struct file *file, void __user *udata)
 	}
 
 	rc = lock_pages(kbufs, kdata.num, pages, nr_pages, &pinned);
-	if (rc < 0) {
-		nr_pages = pinned;
+	if (rc < 0)
 		goto out;
-	}
 
 	for (i = 0; i < kdata.num; i++) {
 		set_xen_guest_handle(xbufs[i].h, kbufs[i].uptr);
@@ -692,7 +693,7 @@ static long privcmd_ioctl_dm_op(struct file *file, void __user *udata)
 	xen_preemptible_hcall_end();
 
 out:
-	unlock_pages(pages, nr_pages);
+	unlock_pages(pages, pinned);
 	kfree(xbufs);
 	kfree(pages);
 	kfree(kbufs);
diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 76ee1452c57b..37ceea85b871 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -13,6 +13,13 @@
 #include "ordered-data.h"
 #include "delayed-inode.h"
 
+/*
+ * Since we search a directory based on f_pos (struct dir_context::pos) we have
+ * to start at 2 since '.' and '..' have f_pos of 0 and 1 respectively, so
+ * everybody else has to start at 2 (see btrfs_real_readdir() and dir_emit_dots()).
+ */
+#define BTRFS_DIR_START_INDEX 2
+
 /*
  * ordered_data_close is set by truncate when a file that used
  * to have good data has been truncated to zero.  When it is set
@@ -164,8 +171,9 @@ struct btrfs_inode {
 	u64 disk_i_size;
 
 	/*
-	 * if this is a directory then index_cnt is the counter for the index
-	 * number for new files that are created
+	 * If this is a directory then index_cnt is the counter for the index
+	 * number for new files that are created. For an empty directory, this
+	 * must be initialized to BTRFS_DIR_START_INDEX.
 	 */
 	u64 index_cnt;
 
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index d1838de0b39c..1831135fef1a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -105,14 +105,6 @@ struct btrfs_ref;
 #define BTRFS_STAT_CURR		0
 #define BTRFS_STAT_PREV		1
 
-/*
- * Count how many BTRFS_MAX_EXTENT_SIZE cover the @size
- */
-static inline u32 count_max_extents(u64 size)
-{
-	return div_u64(size + BTRFS_MAX_EXTENT_SIZE - 1, BTRFS_MAX_EXTENT_SIZE);
-}
-
 static inline unsigned long btrfs_chunk_item_size(int num_stripes)
 {
 	BUG_ON(num_stripes == 0);
@@ -999,6 +991,12 @@ struct btrfs_fs_info {
 	u32 csums_per_leaf;
 	u32 stripesize;
 
+	/*
+	 * Maximum size of an extent. BTRFS_MAX_EXTENT_SIZE on regular
+	 * filesystem, on zoned it depends on the device constraints.
+	 */
+	u64 max_extent_size;
+
 	/* Block groups and devices containing active swapfiles. */
 	spinlock_t swapfile_pins_lock;
 	struct rb_root swapfile_pins;
@@ -1017,6 +1015,8 @@ struct btrfs_fs_info {
 		u64 zoned;
 	};
 
+	/* Max size to emit ZONE_APPEND write command */
+	u64 max_zone_append_size;
 	struct mutex zoned_meta_io_lock;
 	spinlock_t treelog_bg_lock;
 	u64 treelog_bg;
@@ -3870,6 +3870,19 @@ static inline bool btrfs_is_zoned(const struct btrfs_fs_info *fs_info)
 	return fs_info->zoned != 0;
 }
 
+/*
+ * Count how many fs_info->max_extent_size cover the @size
+ */
+static inline u32 count_max_extents(struct btrfs_fs_info *fs_info, u64 size)
+{
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+	if (!fs_info)
+		return div_u64(size + BTRFS_MAX_EXTENT_SIZE - 1, BTRFS_MAX_EXTENT_SIZE);
+#endif
+
+	return div_u64(size + fs_info->max_extent_size - 1, fs_info->max_extent_size);
+}
+
 static inline bool btrfs_is_data_reloc_root(const struct btrfs_root *root)
 {
 	return root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID;
diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
index 40c4d6ba3fb9..b934429c2435 100644
--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -273,7 +273,7 @@ static void calc_inode_reservations(struct btrfs_fs_info *fs_info,
 				    u64 num_bytes, u64 *meta_reserve,
 				    u64 *qgroup_reserve)
 {
-	u64 nr_extents = count_max_extents(num_bytes);
+	u64 nr_extents = count_max_extents(fs_info, num_bytes);
 	u64 csum_leaves = btrfs_csum_bytes_to_leaves(fs_info, num_bytes);
 	u64 inode_update = btrfs_calc_metadata_size(fs_info, 1);
 
@@ -347,7 +347,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 	 * needs to free the reservation we just made.
 	 */
 	spin_lock(&inode->lock);
-	nr_extents = count_max_extents(num_bytes);
+	nr_extents = count_max_extents(fs_info, num_bytes);
 	btrfs_mod_outstanding_extents(inode, nr_extents);
 	inode->csum_bytes += num_bytes;
 	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
@@ -410,7 +410,7 @@ void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes)
 	unsigned num_extents;
 
 	spin_lock(&inode->lock);
-	num_extents = count_max_extents(num_bytes);
+	num_extents = count_max_extents(fs_info, num_bytes);
 	btrfs_mod_outstanding_extents(inode, -num_extents);
 	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
 	spin_unlock(&inode->lock);
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 781556e2a37f..03d8a2d49bf4 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -165,7 +165,7 @@ int btrfs_init_dev_replace(struct btrfs_fs_info *fs_info)
 		 */
 		if (btrfs_find_device(fs_info->fs_devices, &args)) {
 			btrfs_err(fs_info,
-			"replace devid present without an active replace item");
+"replace without active item, run 'device scan --forget' on the target device");
 			ret = -EUCLEAN;
 		} else {
 			dev_replace->srcdev = NULL;
@@ -1151,8 +1151,7 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 		up_write(&dev_replace->rwsem);
 
 		/* Scrub for replace must not be running in suspended state */
-		ret = btrfs_scrub_cancel(fs_info);
-		ASSERT(ret != -ENOTCONN);
+		btrfs_scrub_cancel(fs_info);
 
 		trans = btrfs_start_transaction(root, 0);
 		if (IS_ERR(trans)) {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e65c3039caf1..247d7f9ced3b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3006,6 +3006,8 @@ void btrfs_init_fs_info(struct btrfs_fs_info *fs_info)
 	fs_info->sectorsize_bits = ilog2(4096);
 	fs_info->stripesize = 4096;
 
+	fs_info->max_extent_size = BTRFS_MAX_EXTENT_SIZE;
+
 	spin_lock_init(&fs_info->swapfile_pins_lock);
 	fs_info->swapfile_pins = RB_ROOT;
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a90546b3107c..a72a8d4d4a72 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1985,8 +1985,10 @@ noinline_for_stack bool find_lock_delalloc_range(struct inode *inode,
 				    struct page *locked_page, u64 *start,
 				    u64 *end)
 {
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
-	u64 max_bytes = BTRFS_MAX_EXTENT_SIZE;
+	/* The sanity tests may not set a valid fs_info. */
+	u64 max_bytes = fs_info ? fs_info->max_extent_size : BTRFS_MAX_EXTENT_SIZE;
 	u64 delalloc_start;
 	u64 delalloc_end;
 	bool found;
@@ -3778,10 +3780,11 @@ static void update_nr_written(struct writeback_control *wbc,
  */
 static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 		struct page *page, struct writeback_control *wbc,
-		u64 delalloc_start, unsigned long *nr_written)
+		unsigned long *nr_written)
 {
-	u64 page_end = delalloc_start + PAGE_SIZE - 1;
+	u64 page_end = page_offset(page) + PAGE_SIZE - 1;
 	bool found;
+	u64 delalloc_start = page_offset(page);
 	u64 delalloc_to_write = 0;
 	u64 delalloc_end = 0;
 	int ret;
@@ -4066,8 +4069,8 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 			      struct extent_page_data *epd)
 {
 	struct inode *inode = page->mapping->host;
-	u64 start = page_offset(page);
-	u64 page_end = start + PAGE_SIZE - 1;
+	const u64 page_start = page_offset(page);
+	const u64 page_end = page_start + PAGE_SIZE - 1;
 	int ret;
 	int nr = 0;
 	size_t pg_offset;
@@ -4102,8 +4105,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	}
 
 	if (!epd->extent_locked) {
-		ret = writepage_delalloc(BTRFS_I(inode), page, wbc, start,
-					 &nr_written);
+		ret = writepage_delalloc(BTRFS_I(inode), page, wbc, &nr_written);
 		if (ret == 1)
 			return 0;
 		if (ret)
@@ -4153,7 +4155,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	 * capable of that.
 	 */
 	if (PageError(page))
-		end_extent_writepage(page, ret, start, page_end);
+		end_extent_writepage(page, ret, page_start, page_end);
 	unlock_page(page);
 	ASSERT(ret <= 0);
 	return ret;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 20d0dea1d0c4..428a56f248bb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2032,6 +2032,7 @@ int btrfs_run_delalloc_range(struct btrfs_inode *inode, struct page *locked_page
 void btrfs_split_delalloc_extent(struct inode *inode,
 				 struct extent_state *orig, u64 split)
 {
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	u64 size;
 
 	/* not delalloc, ignore it */
@@ -2039,7 +2040,7 @@ void btrfs_split_delalloc_extent(struct inode *inode,
 		return;
 
 	size = orig->end - orig->start + 1;
-	if (size > BTRFS_MAX_EXTENT_SIZE) {
+	if (size > fs_info->max_extent_size) {
 		u32 num_extents;
 		u64 new_size;
 
@@ -2048,10 +2049,10 @@ void btrfs_split_delalloc_extent(struct inode *inode,
 		 * applies here, just in reverse.
 		 */
 		new_size = orig->end - split + 1;
-		num_extents = count_max_extents(new_size);
+		num_extents = count_max_extents(fs_info, new_size);
 		new_size = split - orig->start;
-		num_extents += count_max_extents(new_size);
-		if (count_max_extents(size) >= num_extents)
+		num_extents += count_max_extents(fs_info, new_size);
+		if (count_max_extents(fs_info, size) >= num_extents)
 			return;
 	}
 
@@ -2068,6 +2069,7 @@ void btrfs_split_delalloc_extent(struct inode *inode,
 void btrfs_merge_delalloc_extent(struct inode *inode, struct extent_state *new,
 				 struct extent_state *other)
 {
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	u64 new_size, old_size;
 	u32 num_extents;
 
@@ -2081,7 +2083,7 @@ void btrfs_merge_delalloc_extent(struct inode *inode, struct extent_state *new,
 		new_size = other->end - new->start + 1;
 
 	/* we're not bigger than the max, unreserve the space and go */
-	if (new_size <= BTRFS_MAX_EXTENT_SIZE) {
+	if (new_size <= fs_info->max_extent_size) {
 		spin_lock(&BTRFS_I(inode)->lock);
 		btrfs_mod_outstanding_extents(BTRFS_I(inode), -1);
 		spin_unlock(&BTRFS_I(inode)->lock);
@@ -2107,10 +2109,10 @@ void btrfs_merge_delalloc_extent(struct inode *inode, struct extent_state *new,
 	 * this case.
 	 */
 	old_size = other->end - other->start + 1;
-	num_extents = count_max_extents(old_size);
+	num_extents = count_max_extents(fs_info, old_size);
 	old_size = new->end - new->start + 1;
-	num_extents += count_max_extents(old_size);
-	if (count_max_extents(new_size) >= num_extents)
+	num_extents += count_max_extents(fs_info, old_size);
+	if (count_max_extents(fs_info, new_size) >= num_extents)
 		return;
 
 	spin_lock(&BTRFS_I(inode)->lock);
@@ -2189,7 +2191,7 @@ void btrfs_set_delalloc_extent(struct inode *inode, struct extent_state *state,
 	if (!(state->state & EXTENT_DELALLOC) && (*bits & EXTENT_DELALLOC)) {
 		struct btrfs_root *root = BTRFS_I(inode)->root;
 		u64 len = state->end + 1 - state->start;
-		u32 num_extents = count_max_extents(len);
+		u32 num_extents = count_max_extents(fs_info, len);
 		bool do_list = !btrfs_is_free_space_inode(BTRFS_I(inode));
 
 		spin_lock(&BTRFS_I(inode)->lock);
@@ -2231,7 +2233,7 @@ void btrfs_clear_delalloc_extent(struct inode *vfs_inode,
 	struct btrfs_inode *inode = BTRFS_I(vfs_inode);
 	struct btrfs_fs_info *fs_info = btrfs_sb(vfs_inode->i_sb);
 	u64 len = state->end + 1 - state->start;
-	u32 num_extents = count_max_extents(len);
+	u32 num_extents = count_max_extents(fs_info, len);
 
 	if ((state->state & EXTENT_DEFRAG) && (*bits & EXTENT_DEFRAG)) {
 		spin_lock(&inode->lock);
@@ -6394,14 +6396,8 @@ static int btrfs_set_inode_index_count(struct btrfs_inode *inode)
 		goto out;
 	ret = 0;
 
-	/*
-	 * MAGIC NUMBER EXPLANATION:
-	 * since we search a directory based on f_pos we have to start at 2
-	 * since '.' and '..' have f_pos of 0 and 1 respectively, so everybody
-	 * else has to start at 2
-	 */
 	if (path->slots[0] == 0) {
-		inode->index_cnt = 2;
+		inode->index_cnt = BTRFS_DIR_START_INDEX;
 		goto out;
 	}
 
@@ -6412,7 +6408,7 @@ static int btrfs_set_inode_index_count(struct btrfs_inode *inode)
 
 	if (found_key.objectid != btrfs_ino(inode) ||
 	    found_key.type != BTRFS_DIR_INDEX_KEY) {
-		inode->index_cnt = 2;
+		inode->index_cnt = BTRFS_DIR_START_INDEX;
 		goto out;
 	}
 
@@ -6956,7 +6952,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 				goto fail;
 		}
 		d_instantiate(dentry, inode);
-		btrfs_log_new_name(trans, BTRFS_I(inode), NULL, parent);
+		btrfs_log_new_name(trans, old_dentry, NULL, parent);
 	}
 
 fail:
@@ -9625,13 +9621,13 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 		BTRFS_I(new_inode)->dir_index = new_idx;
 
 	if (root_log_pinned) {
-		btrfs_log_new_name(trans, BTRFS_I(old_inode), BTRFS_I(old_dir),
+		btrfs_log_new_name(trans, old_dentry, BTRFS_I(old_dir),
 				   new_dentry->d_parent);
 		btrfs_end_log_trans(root);
 		root_log_pinned = false;
 	}
 	if (dest_log_pinned) {
-		btrfs_log_new_name(trans, BTRFS_I(new_inode), BTRFS_I(new_dir),
+		btrfs_log_new_name(trans, new_dentry, BTRFS_I(new_dir),
 				   old_dentry->d_parent);
 		btrfs_end_log_trans(dest);
 		dest_log_pinned = false;
@@ -9912,7 +9908,7 @@ static int btrfs_rename(struct user_namespace *mnt_userns,
 		BTRFS_I(old_inode)->dir_index = index;
 
 	if (log_pinned) {
-		btrfs_log_new_name(trans, BTRFS_I(old_inode), BTRFS_I(old_dir),
+		btrfs_log_new_name(trans, old_dentry, BTRFS_I(old_dir),
 				   new_dentry->d_parent);
 		btrfs_end_log_trans(root);
 		log_pinned = false;
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 1fa0e5e2e350..9328d87d9688 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -351,9 +351,10 @@ int btrfs_del_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
 	key.offset = ref_id;
 again:
 	ret = btrfs_search_slot(trans, tree_root, &key, path, -1, 1);
-	if (ret < 0)
+	if (ret < 0) {
+		err = ret;
 		goto out;
-	if (ret == 0) {
+	} else if (ret == 0) {
 		leaf = path->nodes[0];
 		ref = btrfs_item_ptr(leaf, path->slots[0],
 				     struct btrfs_root_ref);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index e9e1aae89030..1d7e9812f55e 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -6628,14 +6628,25 @@ void btrfs_record_snapshot_destroy(struct btrfs_trans_handle *trans,
 	mutex_unlock(&dir->log_mutex);
 }
 
-/*
- * Call this after adding a new name for a file and it will properly
- * update the log to reflect the new name.
+/**
+ * Update the log after adding a new name for an inode.
+ *
+ * @trans:              Transaction handle.
+ * @old_dentry:         The dentry associated with the old name and the old
+ *                      parent directory.
+ * @old_dir:            The inode of the previous parent directory for the case
+ *                      of a rename. For a link operation, it must be NULL.
+ * @parent:             The dentry associated with the directory under which the
+ *                      new name is located.
+ *
+ * Call this after adding a new name for an inode, as a result of a link or
+ * rename operation, and it will properly update the log to reflect the new name.
  */
 void btrfs_log_new_name(struct btrfs_trans_handle *trans,
-			struct btrfs_inode *inode, struct btrfs_inode *old_dir,
+			struct dentry *old_dentry, struct btrfs_inode *old_dir,
 			struct dentry *parent)
 {
+	struct btrfs_inode *inode = BTRFS_I(d_inode(old_dentry));
 	struct btrfs_log_ctx ctx;
 
 	/*
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index 731bd9c029f5..7ffcac8a8990 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -84,7 +84,7 @@ void btrfs_record_unlink_dir(struct btrfs_trans_handle *trans,
 void btrfs_record_snapshot_destroy(struct btrfs_trans_handle *trans,
 				   struct btrfs_inode *dir);
 void btrfs_log_new_name(struct btrfs_trans_handle *trans,
-			struct btrfs_inode *inode, struct btrfs_inode *old_dir,
+			struct dentry *old_dentry, struct btrfs_inode *old_dir,
 			struct dentry *parent);
 
 #endif
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2a93d80be9bf..0f22d91e2392 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2392,8 +2392,11 @@ int btrfs_get_dev_args_from_path(struct btrfs_fs_info *fs_info,
 
 	ret = btrfs_get_bdev_and_sb(path, FMODE_READ, fs_info->bdev_holder, 0,
 				    &bdev, &disk_super);
-	if (ret)
+	if (ret) {
+		btrfs_put_dev_args_from_path(args);
 		return ret;
+	}
+
 	args->devid = btrfs_stack_device_id(&disk_super->dev_item);
 	memcpy(args->uuid, disk_super->dev_item.uuid, BTRFS_UUID_SIZE);
 	if (btrfs_fs_incompat(fs_info, METADATA_UUID))
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index c5c5b97c2a85..43fe2c2a955e 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -391,6 +391,9 @@ static int btrfs_xattr_handler_set(const struct xattr_handler *handler,
 				   const char *name, const void *buffer,
 				   size_t size, int flags)
 {
+	if (btrfs_root_readonly(BTRFS_I(inode)->root))
+		return -EROFS;
+
 	name = xattr_full_name(handler, name);
 	return btrfs_setxattr_trans(inode, name, buffer, size, flags);
 }
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index fc791f7c7142..7a127d3c521f 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -386,6 +386,16 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 	nr_sectors = bdev_nr_sectors(bdev);
 	zone_info->zone_size_shift = ilog2(zone_info->zone_size);
 	zone_info->nr_zones = nr_sectors >> ilog2(zone_sectors);
+	/*
+	 * We limit max_zone_append_size also by max_segments *
+	 * PAGE_SIZE. Technically, we can have multiple pages per segment. But,
+	 * since btrfs adds the pages one by one to a bio, and btrfs cannot
+	 * increase the metadata reservation even if it increases the number of
+	 * extents, it is safe to stick with the limit.
+	 */
+	zone_info->max_zone_append_size =
+		min_t(u64, (u64)bdev_max_zone_append_sectors(bdev) << SECTOR_SHIFT,
+		      (u64)bdev_max_segments(bdev) << PAGE_SHIFT);
 	if (!IS_ALIGNED(nr_sectors, zone_sectors))
 		zone_info->nr_zones++;
 
@@ -570,6 +580,7 @@ int btrfs_check_zoned_mode(struct btrfs_fs_info *fs_info)
 	u64 zoned_devices = 0;
 	u64 nr_devices = 0;
 	u64 zone_size = 0;
+	u64 max_zone_append_size = 0;
 	const bool incompat_zoned = btrfs_fs_incompat(fs_info, ZONED);
 	int ret = 0;
 
@@ -605,6 +616,11 @@ int btrfs_check_zoned_mode(struct btrfs_fs_info *fs_info)
 				ret = -EINVAL;
 				goto out;
 			}
+			if (!max_zone_append_size ||
+			    (zone_info->max_zone_append_size &&
+			     zone_info->max_zone_append_size < max_zone_append_size))
+				max_zone_append_size =
+					zone_info->max_zone_append_size;
 		}
 		nr_devices++;
 	}
@@ -654,7 +670,11 @@ int btrfs_check_zoned_mode(struct btrfs_fs_info *fs_info)
 	}
 
 	fs_info->zone_size = zone_size;
+	fs_info->max_zone_append_size = ALIGN_DOWN(max_zone_append_size,
+						   fs_info->sectorsize);
 	fs_info->fs_devices->chunk_alloc_policy = BTRFS_CHUNK_ALLOC_ZONED;
+	if (fs_info->max_zone_append_size < fs_info->max_extent_size)
+		fs_info->max_extent_size = fs_info->max_zone_append_size;
 
 	/*
 	 * Check mount options here, because we might change fs_info->zoned
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 574490ea2cc8..1ef493fcd504 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -23,6 +23,7 @@ struct btrfs_zoned_device_info {
 	 */
 	u64 zone_size;
 	u8  zone_size_shift;
+	u64 max_zone_append_size;
 	u32 nr_zones;
 	unsigned long *seq_zones;
 	unsigned long *empty_zones;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 07895e9d537c..2d31860d56e9 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3599,7 +3599,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 			    loff_t offset, loff_t len)
 {
-	struct inode *inode;
+	struct inode *inode = file_inode(file);
 	struct cifsFileInfo *cfile = file->private_data;
 	struct file_zero_data_information fsctl_buf;
 	long rc;
@@ -3608,14 +3608,12 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 
 	xid = get_xid();
 
-	inode = d_inode(cfile->dentry);
-
+	inode_lock(inode);
 	/* Need to make file sparse, if not already, before freeing range. */
 	/* Consider adding equivalent for compressed since it could also work */
 	if (!smb2_set_sparse(xid, tcon, cfile, inode, set_sparse)) {
 		rc = -EOPNOTSUPP;
-		free_xid(xid);
-		return rc;
+		goto out;
 	}
 
 	filemap_invalidate_lock(inode->i_mapping);
@@ -3635,8 +3633,10 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 			true /* is_fctl */, (char *)&fsctl_buf,
 			sizeof(struct file_zero_data_information),
 			CIFSMaxBufSize, NULL, NULL);
-	free_xid(xid);
 	filemap_invalidate_unlock(inode->i_mapping);
+out:
+	inode_unlock(inode);
+	free_xid(xid);
 	return rc;
 }
 
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 1fd8d09416c4..9761470a7ecf 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -134,10 +134,10 @@ static bool inode_io_list_move_locked(struct inode *inode,
 
 static void wb_wakeup(struct bdi_writeback *wb)
 {
-	spin_lock_bh(&wb->work_lock);
+	spin_lock_irq(&wb->work_lock);
 	if (test_bit(WB_registered, &wb->state))
 		mod_delayed_work(bdi_wq, &wb->dwork, 0);
-	spin_unlock_bh(&wb->work_lock);
+	spin_unlock_irq(&wb->work_lock);
 }
 
 static void finish_writeback_work(struct bdi_writeback *wb,
@@ -164,7 +164,7 @@ static void wb_queue_work(struct bdi_writeback *wb,
 	if (work->done)
 		atomic_inc(&work->done->cnt);
 
-	spin_lock_bh(&wb->work_lock);
+	spin_lock_irq(&wb->work_lock);
 
 	if (test_bit(WB_registered, &wb->state)) {
 		list_add_tail(&work->list, &wb->work_list);
@@ -172,7 +172,7 @@ static void wb_queue_work(struct bdi_writeback *wb,
 	} else
 		finish_writeback_work(wb, work);
 
-	spin_unlock_bh(&wb->work_lock);
+	spin_unlock_irq(&wb->work_lock);
 }
 
 /**
@@ -2109,13 +2109,13 @@ static struct wb_writeback_work *get_next_work_item(struct bdi_writeback *wb)
 {
 	struct wb_writeback_work *work = NULL;
 
-	spin_lock_bh(&wb->work_lock);
+	spin_lock_irq(&wb->work_lock);
 	if (!list_empty(&wb->work_list)) {
 		work = list_entry(wb->work_list.next,
 				  struct wb_writeback_work, list);
 		list_del_init(&work->list);
 	}
-	spin_unlock_bh(&wb->work_lock);
+	spin_unlock_irq(&wb->work_lock);
 	return work;
 }
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 89f24b54fe5e..2680e9756b1d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3720,7 +3720,12 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 copy_iov:
 		iov_iter_restore(iter, state);
 		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
-		return ret ?: -EAGAIN;
+		if (!ret) {
+			if (kiocb->ki_flags & IOCB_WRITE)
+				kiocb_end_write(req);
+			return -EAGAIN;
+		}
+		return ret;
 	}
 out_free:
 	/* it's reportedly faster than delegating the null check to kfree() */
diff --git a/fs/namespace.c b/fs/namespace.c
index dc31ad6b370f..d946298691ed 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4168,6 +4168,13 @@ static int build_mount_idmapped(const struct mount_attr *attr, size_t usize,
 		err = -EPERM;
 		goto out_fput;
 	}
+
+	/* We're not controlling the target namespace. */
+	if (!ns_capable(mnt_userns, CAP_SYS_ADMIN)) {
+		err = -EPERM;
+		goto out_fput;
+	}
+
 	kattr->mnt_userns = get_user_ns(mnt_userns);
 
 out_fput:
diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index 4120e1cb3fee..14f2efdecc2f 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -319,7 +319,7 @@ static int read_name_gen = 1;
 static struct file *__nfs42_ssc_open(struct vfsmount *ss_mnt,
 		struct nfs_fh *src_fh, nfs4_stateid *stateid)
 {
-	struct nfs_fattr fattr;
+	struct nfs_fattr *fattr = nfs_alloc_fattr();
 	struct file *filep, *res;
 	struct nfs_server *server;
 	struct inode *r_ino = NULL;
@@ -330,14 +330,20 @@ static struct file *__nfs42_ssc_open(struct vfsmount *ss_mnt,
 
 	server = NFS_SERVER(ss_mnt->mnt_root->d_inode);
 
-	nfs_fattr_init(&fattr);
+	if (!fattr)
+		return ERR_PTR(-ENOMEM);
 
-	status = nfs4_proc_getattr(server, src_fh, &fattr, NULL, NULL);
+	status = nfs4_proc_getattr(server, src_fh, fattr, NULL, NULL);
 	if (status < 0) {
 		res = ERR_PTR(status);
 		goto out;
 	}
 
+	if (!S_ISREG(fattr->mode)) {
+		res = ERR_PTR(-EBADF);
+		goto out;
+	}
+
 	res = ERR_PTR(-ENOMEM);
 	len = strlen(SSC_READ_NAME_BODY) + 16;
 	read_name = kzalloc(len, GFP_NOFS);
@@ -345,7 +351,7 @@ static struct file *__nfs42_ssc_open(struct vfsmount *ss_mnt,
 		goto out;
 	snprintf(read_name, len, SSC_READ_NAME_BODY, read_name_gen++);
 
-	r_ino = nfs_fhget(ss_mnt->mnt_root->d_inode->i_sb, src_fh, &fattr,
+	r_ino = nfs_fhget(ss_mnt->mnt_root->d_inode->i_sb, src_fh, fattr,
 			NULL);
 	if (IS_ERR(r_ino)) {
 		res = ERR_CAST(r_ino);
@@ -356,6 +362,7 @@ static struct file *__nfs42_ssc_open(struct vfsmount *ss_mnt,
 				     r_ino->i_fop);
 	if (IS_ERR(filep)) {
 		res = ERR_CAST(filep);
+		iput(r_ino);
 		goto out_free_name;
 	}
 	filep->f_mode |= FMODE_READ;
@@ -390,6 +397,7 @@ static struct file *__nfs42_ssc_open(struct vfsmount *ss_mnt,
 out_free_name:
 	kfree(read_name);
 out:
+	nfs_free_fattr(fattr);
 	return res;
 out_stateowner:
 	nfs4_put_state_owner(sp);
diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index 872eb56bb170..e8bfa709270d 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -476,8 +476,7 @@ static noinline int ntfs_set_ea(struct inode *inode, const char *name,
 }
 
 #ifdef CONFIG_NTFS3_FS_POSIX_ACL
-static struct posix_acl *ntfs_get_acl_ex(struct user_namespace *mnt_userns,
-					 struct inode *inode, int type,
+static struct posix_acl *ntfs_get_acl_ex(struct inode *inode, int type,
 					 int locked)
 {
 	struct ntfs_inode *ni = ntfs_i(inode);
@@ -512,7 +511,7 @@ static struct posix_acl *ntfs_get_acl_ex(struct user_namespace *mnt_userns,
 
 	/* Translate extended attribute to acl. */
 	if (err >= 0) {
-		acl = posix_acl_from_xattr(mnt_userns, buf, err);
+		acl = posix_acl_from_xattr(&init_user_ns, buf, err);
 	} else if (err == -ENODATA) {
 		acl = NULL;
 	} else {
@@ -535,8 +534,7 @@ struct posix_acl *ntfs_get_acl(struct inode *inode, int type, bool rcu)
 	if (rcu)
 		return ERR_PTR(-ECHILD);
 
-	/* TODO: init_user_ns? */
-	return ntfs_get_acl_ex(&init_user_ns, inode, type, 0);
+	return ntfs_get_acl_ex(inode, type, 0);
 }
 
 static noinline int ntfs_set_acl_ex(struct user_namespace *mnt_userns,
@@ -588,7 +586,7 @@ static noinline int ntfs_set_acl_ex(struct user_namespace *mnt_userns,
 		value = kmalloc(size, GFP_NOFS);
 		if (!value)
 			return -ENOMEM;
-		err = posix_acl_to_xattr(mnt_userns, acl, value, size);
+		err = posix_acl_to_xattr(&init_user_ns, acl, value, size);
 		if (err < 0)
 			goto out;
 		flags = 0;
@@ -639,7 +637,7 @@ static int ntfs_xattr_get_acl(struct user_namespace *mnt_userns,
 	if (!acl)
 		return -ENODATA;
 
-	err = posix_acl_to_xattr(mnt_userns, acl, buffer, size);
+	err = posix_acl_to_xattr(&init_user_ns, acl, buffer, size);
 	posix_acl_release(acl);
 
 	return err;
@@ -663,12 +661,12 @@ static int ntfs_xattr_set_acl(struct user_namespace *mnt_userns,
 	if (!value) {
 		acl = NULL;
 	} else {
-		acl = posix_acl_from_xattr(mnt_userns, value, size);
+		acl = posix_acl_from_xattr(&init_user_ns, value, size);
 		if (IS_ERR(acl))
 			return PTR_ERR(acl);
 
 		if (acl) {
-			err = posix_acl_valid(mnt_userns, acl);
+			err = posix_acl_valid(&init_user_ns, acl);
 			if (err)
 				goto release_and_out;
 		}
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 79ca4d69dfd6..d9c07eecd787 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -503,10 +503,12 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 	struct vm_area_struct *vma = walk->vma;
 	bool locked = !!(vma->vm_flags & VM_LOCKED);
 	struct page *page = NULL;
-	bool migration = false;
+	bool migration = false, young = false, dirty = false;
 
 	if (pte_present(*pte)) {
 		page = vm_normal_page(vma, addr, *pte);
+		young = pte_young(*pte);
+		dirty = pte_dirty(*pte);
 	} else if (is_swap_pte(*pte)) {
 		swp_entry_t swpent = pte_to_swp_entry(*pte);
 
@@ -540,8 +542,7 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 	if (!page)
 		return;
 
-	smaps_account(mss, page, false, pte_young(*pte), pte_dirty(*pte),
-		      locked, migration);
+	smaps_account(mss, page, false, young, dirty, locked, migration);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index ecf564d150b3..f8feaed0b54d 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -723,13 +723,12 @@ static ssize_t zonefs_file_dio_append(struct kiocb *iocb, struct iov_iter *from)
 	struct inode *inode = file_inode(iocb->ki_filp);
 	struct zonefs_inode_info *zi = ZONEFS_I(inode);
 	struct block_device *bdev = inode->i_sb->s_bdev;
-	unsigned int max;
+	unsigned int max = bdev_max_zone_append_sectors(bdev);
 	struct bio *bio;
 	ssize_t size;
 	int nr_pages;
 	ssize_t ret;
 
-	max = queue_max_zone_append_sectors(bdev_get_queue(bdev));
 	max = ALIGN_DOWN(max << SECTOR_SHIFT, inode->i_sb->s_blocksize);
 	iov_iter_truncate(from, max);
 
diff --git a/include/asm-generic/sections.h b/include/asm-generic/sections.h
index d16302d3eb59..72f1e2a8c167 100644
--- a/include/asm-generic/sections.h
+++ b/include/asm-generic/sections.h
@@ -114,7 +114,7 @@ static inline bool memory_contains(void *begin, void *end, void *virt,
 /**
  * memory_intersects - checks if the region occupied by an object intersects
  *                     with another memory region
- * @begin: virtual address of the beginning of the memory regien
+ * @begin: virtual address of the beginning of the memory region
  * @end: virtual address of the end of the memory region
  * @virt: virtual address of the memory object
  * @size: size of the memory object
@@ -127,7 +127,10 @@ static inline bool memory_intersects(void *begin, void *end, void *virt,
 {
 	void *vend = virt + size;
 
-	return (virt >= begin && virt < end) || (vend >= begin && vend < end);
+	if (virt < end && vend > begin)
+		return true;
+
+	return false;
 }
 
 /**
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8863b4a378af..67344dfe07a7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1387,6 +1387,17 @@ static inline unsigned int queue_max_zone_append_sectors(const struct request_qu
 	return min(l->max_zone_append_sectors, l->max_sectors);
 }
 
+static inline unsigned int
+bdev_max_zone_append_sectors(struct block_device *bdev)
+{
+	return queue_max_zone_append_sectors(bdev_get_queue(bdev));
+}
+
+static inline unsigned int bdev_max_segments(struct block_device *bdev)
+{
+	return queue_max_segments(bdev_get_queue(bdev));
+}
+
 static inline unsigned queue_logical_block_size(const struct request_queue *q)
 {
 	int retval = 512;
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 1e7399fc69c0..054e654f06de 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -1045,4 +1045,22 @@ cpumap_print_list_to_buf(char *buf, const struct cpumask *mask,
 	[0] =  1UL							\
 } }
 
+/*
+ * Provide a valid theoretical max size for cpumap and cpulist sysfs files
+ * to avoid breaking userspace which may allocate a buffer based on the size
+ * reported by e.g. fstat.
+ *
+ * for cpumap NR_CPUS * 9/32 - 1 should be an exact length.
+ *
+ * For cpulist 7 is (ceil(log10(NR_CPUS)) + 1) allowing for NR_CPUS to be up
+ * to 2 orders of magnitude larger than 8192. And then we divide by 2 to
+ * cover a worst-case of every other cpu being on one of two nodes for a
+ * very large NR_CPUS.
+ *
+ *  Use PAGE_SIZE as a minimum for smaller configurations.
+ */
+#define CPUMAP_FILE_MAX_BYTES  ((((NR_CPUS * 9)/32 - 1) > PAGE_SIZE) \
+					? (NR_CPUS * 9)/32 - 1 : PAGE_SIZE)
+#define CPULIST_FILE_MAX_BYTES  (((NR_CPUS * 7)/2 > PAGE_SIZE) ? (NR_CPUS * 7)/2 : PAGE_SIZE)
+
 #endif /* __LINUX_CPUMASK_H */
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index d35439db047c..4f189b17dafc 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -966,19 +966,30 @@ static inline void mod_memcg_state(struct mem_cgroup *memcg,
 
 static inline unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
 {
-	return READ_ONCE(memcg->vmstats.state[idx]);
+	long x = READ_ONCE(memcg->vmstats.state[idx]);
+#ifdef CONFIG_SMP
+	if (x < 0)
+		x = 0;
+#endif
+	return x;
 }
 
 static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
 					      enum node_stat_item idx)
 {
 	struct mem_cgroup_per_node *pn;
+	long x;
 
 	if (mem_cgroup_disabled())
 		return node_page_state(lruvec_pgdat(lruvec), idx);
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	return READ_ONCE(pn->lruvec_stats.state[idx]);
+	x = READ_ONCE(pn->lruvec_stats.state[idx]);
+#ifdef CONFIG_SMP
+	if (x < 0)
+		x = 0;
+#endif
+	return x;
 }
 
 static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index f17d2101af7a..4c678de4608d 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -759,6 +759,7 @@ struct mlx5_core_dev {
 	enum mlx5_device_state	state;
 	/* sync interface state */
 	struct mutex		intf_state_mutex;
+	struct lock_class_key	lock_key;
 	unsigned long		intf_state;
 	struct mlx5_priv	priv;
 	struct mlx5_profile	profile;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index f8d46dc62d65..3b97438afe3e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -626,9 +626,23 @@ extern int sysctl_devconf_inherit_init_net;
  */
 static inline bool net_has_fallback_tunnels(const struct net *net)
 {
-	return !IS_ENABLED(CONFIG_SYSCTL) ||
-	       !sysctl_fb_tunnels_only_for_init_net ||
-	       (net == &init_net && sysctl_fb_tunnels_only_for_init_net == 1);
+#if IS_ENABLED(CONFIG_SYSCTL)
+	int fb_tunnels_only_for_init_net = READ_ONCE(sysctl_fb_tunnels_only_for_init_net);
+
+	return !fb_tunnels_only_for_init_net ||
+		(net_eq(net, &init_net) && fb_tunnels_only_for_init_net == 1);
+#else
+	return true;
+#endif
+}
+
+static inline int net_inherit_devconf(void)
+{
+#if IS_ENABLED(CONFIG_SYSCTL)
+	return READ_ONCE(sysctl_devconf_inherit_init_net);
+#else
+	return 0;
+#endif
 }
 
 static inline int netdev_queue_numa_node_read(const struct netdev_queue *q)
diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index 10a01978bc0d..bde9db771ae4 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -94,10 +94,6 @@ struct ebt_table {
 	struct ebt_replace_kernel *table;
 	unsigned int valid_hooks;
 	rwlock_t lock;
-	/* e.g. could be the table explicitly only allows certain
-	 * matches, targets, ... 0 == let it in */
-	int (*check)(const struct ebt_table_info *info,
-	   unsigned int valid_hooks);
 	/* the data used by the kernel */
 	struct ebt_table_info *private;
 	struct nf_hook_ops *ops;
diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index 40296ed976a9..3459a04a3d61 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -33,7 +33,7 @@ extern unsigned int sysctl_net_busy_poll __read_mostly;
 
 static inline bool net_busy_loop_on(void)
 {
-	return sysctl_net_busy_poll;
+	return READ_ONCE(sysctl_net_busy_poll);
 }
 
 static inline bool sk_can_busy_loop(const struct sock *sk)
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 9f927c44087d..aaa518e777e9 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -266,6 +266,7 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
 
 struct flow_offload_tuple_rhash *flow_offload_lookup(struct nf_flowtable *flow_table,
 						     struct flow_offload_tuple *tuple);
+void nf_flow_table_gc_run(struct nf_flowtable *flow_table);
 void nf_flow_table_gc_cleanup(struct nf_flowtable *flowtable,
 			      struct net_device *dev);
 void nf_flow_table_cleanup(struct net_device *dev);
@@ -302,6 +303,8 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
 			   struct flow_offload *flow);
 
 void nf_flow_table_offload_flush(struct nf_flowtable *flowtable);
+void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable);
+
 int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 				struct net_device *dev,
 				enum flow_block_command cmd);
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index f56a1071c005..53746494eb84 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -193,13 +193,18 @@ struct nft_ctx {
 	bool				report;
 };
 
+enum nft_data_desc_flags {
+	NFT_DATA_DESC_SETELEM	= (1 << 0),
+};
+
 struct nft_data_desc {
 	enum nft_data_types		type;
+	unsigned int			size;
 	unsigned int			len;
+	unsigned int			flags;
 };
 
-int nft_data_init(const struct nft_ctx *ctx,
-		  struct nft_data *data, unsigned int size,
+int nft_data_init(const struct nft_ctx *ctx, struct nft_data *data,
 		  struct nft_data_desc *desc, const struct nlattr *nla);
 void nft_data_hold(const struct nft_data *data, enum nft_data_types type);
 void nft_data_release(const struct nft_data *data, enum nft_data_types type);
@@ -1595,6 +1600,7 @@ struct nftables_pernet {
 	struct list_head	module_list;
 	struct list_head	notify_list;
 	struct mutex		commit_mutex;
+	u64			table_handle;
 	unsigned int		base_seq;
 	u8			validate_state;
 };
diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 0fa5a6d98a00..9dfa11d4224d 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -40,6 +40,14 @@ struct nft_cmp_fast_expr {
 	bool			inv;
 };
 
+struct nft_cmp16_fast_expr {
+	struct nft_data		data;
+	struct nft_data		mask;
+	u8			sreg;
+	u8			len;
+	bool			inv;
+};
+
 struct nft_immediate_expr {
 	struct nft_data		data;
 	u8			dreg;
@@ -57,6 +65,7 @@ static inline u32 nft_cmp_fast_mask(unsigned int len)
 }
 
 extern const struct nft_expr_ops nft_cmp_fast_ops;
+extern const struct nft_expr_ops nft_cmp16_fast_ops;
 
 struct nft_payload {
 	enum nft_payload_bases	base:8;
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 76b0d7f2b967..d3646645cb9e 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -571,6 +571,8 @@ __u32 cookie_v6_init_sequence(const struct sk_buff *skb, __u16 *mss);
 #endif
 /* tcp_output.c */
 
+void tcp_skb_entail(struct sock *sk, struct sk_buff *skb);
+void tcp_mark_push(struct tcp_sock *tp, struct sk_buff *skb);
 void __tcp_push_pending_frames(struct sock *sk, unsigned int cur_mss,
 			       int nonagle);
 int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs);
diff --git a/kernel/audit_fsnotify.c b/kernel/audit_fsnotify.c
index 60739d5e3373..c428312938e9 100644
--- a/kernel/audit_fsnotify.c
+++ b/kernel/audit_fsnotify.c
@@ -102,6 +102,7 @@ struct audit_fsnotify_mark *audit_alloc_mark(struct audit_krule *krule, char *pa
 
 	ret = fsnotify_add_inode_mark(&audit_mark->mark, inode, true);
 	if (ret < 0) {
+		audit_mark->path = NULL;
 		fsnotify_put_mark(&audit_mark->mark);
 		audit_mark = ERR_PTR(ret);
 	}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c8b534a498b3..5c9ebcbf6f5f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6096,8 +6096,7 @@ record_func_key(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
 	struct bpf_insn_aux_data *aux = &env->insn_aux_data[insn_idx];
 	struct bpf_reg_state *regs = cur_regs(env), *reg;
 	struct bpf_map *map = meta->map_ptr;
-	struct tnum range;
-	u64 val;
+	u64 val, max;
 	int err;
 
 	if (func_id != BPF_FUNC_tail_call)
@@ -6107,10 +6106,11 @@ record_func_key(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
 		return -EINVAL;
 	}
 
-	range = tnum_range(0, map->max_entries - 1);
 	reg = &regs[BPF_REG_3];
+	val = reg->var_off.value;
+	max = map->max_entries;
 
-	if (!register_is_const(reg) || !tnum_in(range, reg->var_off)) {
+	if (!(register_is_const(reg) && val < max)) {
 		bpf_map_key_store(aux, BPF_MAP_KEY_POISON);
 		return 0;
 	}
@@ -6118,8 +6118,6 @@ record_func_key(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
 	err = mark_chain_precision(env, BPF_REG_3);
 	if (err)
 		return err;
-
-	val = reg->var_off.value;
 	if (bpf_map_key_unseen(aux))
 		bpf_map_key_store(aux, val);
 	else if (!bpf_map_key_poisoned(aux) &&
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index e7c3b0e586f2..416dd7db3fb2 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1810,6 +1810,7 @@ int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
 
 		if (ss->css_rstat_flush) {
 			list_del_rcu(&css->rstat_css_node);
+			synchronize_rcu();
 			list_add_rcu(&css->rstat_css_node,
 				     &dcgrp->rstat_css_list);
 		}
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index f43d89d92860..126380696f9c 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -276,6 +276,7 @@ COND_SYSCALL(landlock_restrict_self);
 
 /* mm/fadvise.c */
 COND_SYSCALL(fadvise64_64);
+COND_SYSCALL_COMPAT(fadvise64_64);
 
 /* mm/, CONFIG_MMU only */
 COND_SYSCALL(swapon);
diff --git a/lib/ratelimit.c b/lib/ratelimit.c
index e01a93f46f83..ce945c17980b 100644
--- a/lib/ratelimit.c
+++ b/lib/ratelimit.c
@@ -26,10 +26,16 @@
  */
 int ___ratelimit(struct ratelimit_state *rs, const char *func)
 {
+	/* Paired with WRITE_ONCE() in .proc_handler().
+	 * Changing two values seperately could be inconsistent
+	 * and some message could be lost.  (See: net_ratelimit_state).
+	 */
+	int interval = READ_ONCE(rs->interval);
+	int burst = READ_ONCE(rs->burst);
 	unsigned long flags;
 	int ret;
 
-	if (!rs->interval)
+	if (!interval)
 		return 1;
 
 	/*
@@ -44,7 +50,7 @@ int ___ratelimit(struct ratelimit_state *rs, const char *func)
 	if (!rs->begin)
 		rs->begin = jiffies;
 
-	if (time_is_before_jiffies(rs->begin + rs->interval)) {
+	if (time_is_before_jiffies(rs->begin + interval)) {
 		if (rs->missed) {
 			if (!(rs->flags & RATELIMIT_MSG_ON_RELEASE)) {
 				printk_deferred(KERN_WARNING
@@ -56,7 +62,7 @@ int ___ratelimit(struct ratelimit_state *rs, const char *func)
 		rs->begin   = jiffies;
 		rs->printed = 0;
 	}
-	if (rs->burst && rs->burst > rs->printed) {
+	if (burst && burst > rs->printed) {
 		rs->printed++;
 		ret = 1;
 	} else {
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 02c9d5c7276e..142e118ade87 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -258,10 +258,10 @@ void wb_wakeup_delayed(struct bdi_writeback *wb)
 	unsigned long timeout;
 
 	timeout = msecs_to_jiffies(dirty_writeback_interval * 10);
-	spin_lock_bh(&wb->work_lock);
+	spin_lock_irq(&wb->work_lock);
 	if (test_bit(WB_registered, &wb->state))
 		queue_delayed_work(bdi_wq, &wb->dwork, timeout);
-	spin_unlock_bh(&wb->work_lock);
+	spin_unlock_irq(&wb->work_lock);
 }
 
 static void wb_update_bandwidth_workfn(struct work_struct *work)
@@ -337,12 +337,12 @@ static void cgwb_remove_from_bdi_list(struct bdi_writeback *wb);
 static void wb_shutdown(struct bdi_writeback *wb)
 {
 	/* Make sure nobody queues further work */
-	spin_lock_bh(&wb->work_lock);
+	spin_lock_irq(&wb->work_lock);
 	if (!test_and_clear_bit(WB_registered, &wb->state)) {
-		spin_unlock_bh(&wb->work_lock);
+		spin_unlock_irq(&wb->work_lock);
 		return;
 	}
-	spin_unlock_bh(&wb->work_lock);
+	spin_unlock_irq(&wb->work_lock);
 
 	cgwb_remove_from_bdi_list(wb);
 	/*
diff --git a/mm/bootmem_info.c b/mm/bootmem_info.c
index f03f42f426f6..8655492159a5 100644
--- a/mm/bootmem_info.c
+++ b/mm/bootmem_info.c
@@ -12,6 +12,7 @@
 #include <linux/memblock.h>
 #include <linux/bootmem_info.h>
 #include <linux/memory_hotplug.h>
+#include <linux/kmemleak.h>
 
 void get_page_bootmem(unsigned long info, struct page *page, unsigned long type)
 {
@@ -34,6 +35,7 @@ void put_page_bootmem(struct page *page)
 		ClearPagePrivate(page);
 		set_page_private(page, 0);
 		INIT_LIST_HEAD(&page->lru);
+		kmemleak_free_part(page_to_virt(page), PAGE_SIZE);
 		free_reserved_page(page);
 	}
 }
diff --git a/mm/damon/dbgfs.c b/mm/damon/dbgfs.c
index 36624990b577..70a5cb977ed0 100644
--- a/mm/damon/dbgfs.c
+++ b/mm/damon/dbgfs.c
@@ -376,6 +376,9 @@ static int dbgfs_mk_context(char *name)
 		return -ENOENT;
 
 	new_dir = debugfs_create_dir(name, root);
+	/* Below check is required for a potential duplicated name case */
+	if (IS_ERR(new_dir))
+		return PTR_ERR(new_dir);
 	dbgfs_dirs[dbgfs_nr_ctxs] = new_dir;
 
 	new_ctx = dbgfs_new_ctx();
diff --git a/mm/mmap.c b/mm/mmap.c
index 031fca1a7c65..b63336f6984c 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1684,8 +1684,12 @@ int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
 	    pgprot_val(vm_pgprot_modify(vm_page_prot, vm_flags)))
 		return 0;
 
-	/* Do we need to track softdirty? */
-	if (IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) && !(vm_flags & VM_SOFTDIRTY))
+	/*
+	 * Do we need to track softdirty? hugetlb does not support softdirty
+	 * tracking yet.
+	 */
+	if (IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) && !(vm_flags & VM_SOFTDIRTY) &&
+	    !is_vm_hugetlb_page(vma))
 		return 1;
 
 	/* Specialty mapping? */
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 4812a17b288c..8ca6617b2a72 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2755,6 +2755,7 @@ static void wb_inode_writeback_start(struct bdi_writeback *wb)
 
 static void wb_inode_writeback_end(struct bdi_writeback *wb)
 {
+	unsigned long flags;
 	atomic_dec(&wb->writeback_inodes);
 	/*
 	 * Make sure estimate of writeback throughput gets updated after
@@ -2763,7 +2764,10 @@ static void wb_inode_writeback_end(struct bdi_writeback *wb)
 	 * that if multiple inodes end writeback at a similar time, they get
 	 * batched into one bandwidth update.
 	 */
-	queue_delayed_work(bdi_wq, &wb->bw_dwork, BANDWIDTH_INTERVAL);
+	spin_lock_irqsave(&wb->work_lock, flags);
+	if (test_bit(WB_registered, &wb->state))
+		queue_delayed_work(bdi_wq, &wb->bw_dwork, BANDWIDTH_INTERVAL);
+	spin_unlock_irqrestore(&wb->work_lock, flags);
 }
 
 int test_clear_page_writeback(struct page *page)
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 8602885c8a8e..a54535cbcf4c 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -250,7 +250,7 @@ bool vlan_dev_inherit_address(struct net_device *dev,
 	if (dev->addr_assign_type != NET_ADDR_STOLEN)
 		return false;
 
-	ether_addr_copy(dev->dev_addr, real_dev->dev_addr);
+	eth_hw_addr_set(dev, real_dev->dev_addr);
 	call_netdevice_notifiers(NETDEV_CHANGEADDR, dev);
 	return true;
 }
@@ -349,7 +349,7 @@ static int vlan_dev_set_mac_address(struct net_device *dev, void *p)
 		dev_uc_del(real_dev, dev->dev_addr);
 
 out:
-	ether_addr_copy(dev->dev_addr, addr->sa_data);
+	eth_hw_addr_set(dev, addr->sa_data);
 	return 0;
 }
 
@@ -586,7 +586,7 @@ static int vlan_dev_init(struct net_device *dev)
 	dev->dev_id = real_dev->dev_id;
 
 	if (is_zero_ether_addr(dev->dev_addr)) {
-		ether_addr_copy(dev->dev_addr, real_dev->dev_addr);
+		eth_hw_addr_set(dev, real_dev->dev_addr);
 		dev->addr_assign_type = NET_ADDR_STOLEN;
 	}
 	if (is_zero_ether_addr(dev->broadcast))
diff --git a/net/bridge/netfilter/ebtable_broute.c b/net/bridge/netfilter/ebtable_broute.c
index a7af4eaff17d..3d4ea774d7e8 100644
--- a/net/bridge/netfilter/ebtable_broute.c
+++ b/net/bridge/netfilter/ebtable_broute.c
@@ -36,18 +36,10 @@ static struct ebt_replace_kernel initial_table = {
 	.entries	= (char *)&initial_chain,
 };
 
-static int check(const struct ebt_table_info *info, unsigned int valid_hooks)
-{
-	if (valid_hooks & ~(1 << NF_BR_BROUTING))
-		return -EINVAL;
-	return 0;
-}
-
 static const struct ebt_table broute_table = {
 	.name		= "broute",
 	.table		= &initial_table,
 	.valid_hooks	= 1 << NF_BR_BROUTING,
-	.check		= check,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebtable_filter.c b/net/bridge/netfilter/ebtable_filter.c
index c0b121df4a9a..257d63b5dec1 100644
--- a/net/bridge/netfilter/ebtable_filter.c
+++ b/net/bridge/netfilter/ebtable_filter.c
@@ -43,18 +43,10 @@ static struct ebt_replace_kernel initial_table = {
 	.entries	= (char *)initial_chains,
 };
 
-static int check(const struct ebt_table_info *info, unsigned int valid_hooks)
-{
-	if (valid_hooks & ~FILTER_VALID_HOOKS)
-		return -EINVAL;
-	return 0;
-}
-
 static const struct ebt_table frame_filter = {
 	.name		= "filter",
 	.table		= &initial_table,
 	.valid_hooks	= FILTER_VALID_HOOKS,
-	.check		= check,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebtable_nat.c b/net/bridge/netfilter/ebtable_nat.c
index 4078151c224f..39179c2cf87d 100644
--- a/net/bridge/netfilter/ebtable_nat.c
+++ b/net/bridge/netfilter/ebtable_nat.c
@@ -43,18 +43,10 @@ static struct ebt_replace_kernel initial_table = {
 	.entries	= (char *)initial_chains,
 };
 
-static int check(const struct ebt_table_info *info, unsigned int valid_hooks)
-{
-	if (valid_hooks & ~NAT_VALID_HOOKS)
-		return -EINVAL;
-	return 0;
-}
-
 static const struct ebt_table frame_nat = {
 	.name		= "nat",
 	.table		= &initial_table,
 	.valid_hooks	= NAT_VALID_HOOKS,
-	.check		= check,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index ba045f35114d..8905fe2fe023 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1040,8 +1040,7 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 		goto free_iterate;
 	}
 
-	/* the table doesn't like it */
-	if (t->check && (ret = t->check(newinfo, repl->valid_hooks)))
+	if (repl->valid_hooks != t->valid_hooks)
 		goto free_unlock;
 
 	if (repl->num_counters && repl->num_counters != t->private->nentries) {
@@ -1231,11 +1230,6 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
 	if (ret != 0)
 		goto free_chainstack;
 
-	if (table->check && table->check(newinfo, table->valid_hooks)) {
-		ret = -EINVAL;
-		goto free_chainstack;
-	}
-
 	table->private = newinfo;
 	rwlock_init(&table->lock);
 	mutex_lock(&ebt_mutex);
diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index d2745c54737e..910ca41cb9e6 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -305,11 +305,12 @@ BPF_CALL_2(bpf_sk_storage_delete, struct bpf_map *, map, struct sock *, sk)
 static int bpf_sk_storage_charge(struct bpf_local_storage_map *smap,
 				 void *owner, u32 size)
 {
+	int optmem_max = READ_ONCE(sysctl_optmem_max);
 	struct sock *sk = (struct sock *)owner;
 
 	/* same check as in sock_kmalloc() */
-	if (size <= sysctl_optmem_max &&
-	    atomic_read(&sk->sk_omem_alloc) + size < sysctl_optmem_max) {
+	if (size <= optmem_max &&
+	    atomic_read(&sk->sk_omem_alloc) + size < optmem_max) {
 		atomic_add(size, &sk->sk_omem_alloc);
 		return 0;
 	}
diff --git a/net/core/dev.c b/net/core/dev.c
index 12b1811cb488..276cca563325 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4589,7 +4589,7 @@ static bool skb_flow_limit(struct sk_buff *skb, unsigned int qlen)
 	struct softnet_data *sd;
 	unsigned int old_flow, new_flow;
 
-	if (qlen < (netdev_max_backlog >> 1))
+	if (qlen < (READ_ONCE(netdev_max_backlog) >> 1))
 		return false;
 
 	sd = this_cpu_ptr(&softnet_data);
@@ -4637,7 +4637,7 @@ static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
 	if (!netif_running(skb->dev))
 		goto drop;
 	qlen = skb_queue_len(&sd->input_pkt_queue);
-	if (qlen <= netdev_max_backlog && !skb_flow_limit(skb, qlen)) {
+	if (qlen <= READ_ONCE(netdev_max_backlog) && !skb_flow_limit(skb, qlen)) {
 		if (qlen) {
 enqueue:
 			__skb_queue_tail(&sd->input_pkt_queue, skb);
@@ -4893,7 +4893,7 @@ static int netif_rx_internal(struct sk_buff *skb)
 {
 	int ret;
 
-	net_timestamp_check(netdev_tstamp_prequeue, skb);
+	net_timestamp_check(READ_ONCE(netdev_tstamp_prequeue), skb);
 
 	trace_netif_rx(skb);
 
@@ -5253,7 +5253,7 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 	int ret = NET_RX_DROP;
 	__be16 type;
 
-	net_timestamp_check(!netdev_tstamp_prequeue, skb);
+	net_timestamp_check(!READ_ONCE(netdev_tstamp_prequeue), skb);
 
 	trace_netif_receive_skb(skb);
 
@@ -5634,7 +5634,7 @@ static int netif_receive_skb_internal(struct sk_buff *skb)
 {
 	int ret;
 
-	net_timestamp_check(netdev_tstamp_prequeue, skb);
+	net_timestamp_check(READ_ONCE(netdev_tstamp_prequeue), skb);
 
 	if (skb_defer_rx_timestamp(skb))
 		return NET_RX_SUCCESS;
@@ -5664,7 +5664,7 @@ static void netif_receive_skb_list_internal(struct list_head *head)
 
 	INIT_LIST_HEAD(&sublist);
 	list_for_each_entry_safe(skb, next, head, list) {
-		net_timestamp_check(netdev_tstamp_prequeue, skb);
+		net_timestamp_check(READ_ONCE(netdev_tstamp_prequeue), skb);
 		skb_list_del_init(skb);
 		if (!skb_defer_rx_timestamp(skb))
 			list_add_tail(&skb->list, &sublist);
@@ -6437,7 +6437,7 @@ static int process_backlog(struct napi_struct *napi, int quota)
 		net_rps_action_and_irq_enable(sd);
 	}
 
-	napi->weight = dev_rx_weight;
+	napi->weight = READ_ONCE(dev_rx_weight);
 	while (again) {
 		struct sk_buff *skb;
 
@@ -7137,8 +7137,8 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 {
 	struct softnet_data *sd = this_cpu_ptr(&softnet_data);
 	unsigned long time_limit = jiffies +
-		usecs_to_jiffies(netdev_budget_usecs);
-	int budget = netdev_budget;
+		usecs_to_jiffies(READ_ONCE(netdev_budget_usecs));
+	int budget = READ_ONCE(netdev_budget);
 	LIST_HEAD(list);
 	LIST_HEAD(repoll);
 
diff --git a/net/core/filter.c b/net/core/filter.c
index ac64395611ae..fb5b9dbf3bc0 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1213,10 +1213,11 @@ void sk_filter_uncharge(struct sock *sk, struct sk_filter *fp)
 static bool __sk_filter_charge(struct sock *sk, struct sk_filter *fp)
 {
 	u32 filter_size = bpf_prog_size(fp->prog->len);
+	int optmem_max = READ_ONCE(sysctl_optmem_max);
 
 	/* same check as in sock_kmalloc() */
-	if (filter_size <= sysctl_optmem_max &&
-	    atomic_read(&sk->sk_omem_alloc) + filter_size < sysctl_optmem_max) {
+	if (filter_size <= optmem_max &&
+	    atomic_read(&sk->sk_omem_alloc) + filter_size < optmem_max) {
 		atomic_add(filter_size, &sk->sk_omem_alloc);
 		return true;
 	}
@@ -1548,7 +1549,7 @@ int sk_reuseport_attach_filter(struct sock_fprog *fprog, struct sock *sk)
 	if (IS_ERR(prog))
 		return PTR_ERR(prog);
 
-	if (bpf_prog_size(prog->len) > sysctl_optmem_max)
+	if (bpf_prog_size(prog->len) > READ_ONCE(sysctl_optmem_max))
 		err = -ENOMEM;
 	else
 		err = reuseport_attach_prog(sk, prog);
@@ -1615,7 +1616,7 @@ int sk_reuseport_attach_bpf(u32 ufd, struct sock *sk)
 		}
 	} else {
 		/* BPF_PROG_TYPE_SOCKET_FILTER */
-		if (bpf_prog_size(prog->len) > sysctl_optmem_max) {
+		if (bpf_prog_size(prog->len) > READ_ONCE(sysctl_optmem_max)) {
 			err = -ENOMEM;
 			goto err_prog_put;
 		}
@@ -4744,14 +4745,14 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 		/* Only some socketops are supported */
 		switch (optname) {
 		case SO_RCVBUF:
-			val = min_t(u32, val, sysctl_rmem_max);
+			val = min_t(u32, val, READ_ONCE(sysctl_rmem_max));
 			val = min_t(int, val, INT_MAX / 2);
 			sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
 			WRITE_ONCE(sk->sk_rcvbuf,
 				   max_t(int, val * 2, SOCK_MIN_RCVBUF));
 			break;
 		case SO_SNDBUF:
-			val = min_t(u32, val, sysctl_wmem_max);
+			val = min_t(u32, val, READ_ONCE(sysctl_wmem_max));
 			val = min_t(int, val, INT_MAX / 2);
 			sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
 			WRITE_ONCE(sk->sk_sndbuf,
diff --git a/net/core/gro_cells.c b/net/core/gro_cells.c
index 6eb2e5ec2c50..2f66f3f29563 100644
--- a/net/core/gro_cells.c
+++ b/net/core/gro_cells.c
@@ -26,7 +26,7 @@ int gro_cells_receive(struct gro_cells *gcells, struct sk_buff *skb)
 
 	cell = this_cpu_ptr(gcells->cells);
 
-	if (skb_queue_len(&cell->napi_skbs) > netdev_max_backlog) {
+	if (skb_queue_len(&cell->napi_skbs) > READ_ONCE(netdev_max_backlog)) {
 drop:
 		atomic_long_inc(&dev->rx_dropped);
 		kfree_skb(skb);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 5ebef94e14dc..563848242ad3 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4892,7 +4892,7 @@ static bool skb_may_tx_timestamp(struct sock *sk, bool tsonly)
 {
 	bool ret;
 
-	if (likely(sysctl_tstamp_allow_data || tsonly))
+	if (likely(READ_ONCE(sysctl_tstamp_allow_data) || tsonly))
 		return true;
 
 	read_lock_bh(&sk->sk_callback_lock);
diff --git a/net/core/sock.c b/net/core/sock.c
index deaed1b20682..9bcffe1d5332 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1014,7 +1014,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		 * play 'guess the biggest size' games. RCVBUF/SNDBUF
 		 * are treated in BSD as hints
 		 */
-		val = min_t(u32, val, sysctl_wmem_max);
+		val = min_t(u32, val, READ_ONCE(sysctl_wmem_max));
 set_sndbuf:
 		/* Ensure val * 2 fits into an int, to prevent max_t()
 		 * from treating it as a negative value.
@@ -1046,7 +1046,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		 * play 'guess the biggest size' games. RCVBUF/SNDBUF
 		 * are treated in BSD as hints
 		 */
-		__sock_set_rcvbuf(sk, min_t(u32, val, sysctl_rmem_max));
+		__sock_set_rcvbuf(sk, min_t(u32, val, READ_ONCE(sysctl_rmem_max)));
 		break;
 
 	case SO_RCVBUFFORCE:
@@ -2368,7 +2368,7 @@ struct sk_buff *sock_omalloc(struct sock *sk, unsigned long size,
 
 	/* small safe race: SKB_TRUESIZE may differ from final skb->truesize */
 	if (atomic_read(&sk->sk_omem_alloc) + SKB_TRUESIZE(size) >
-	    sysctl_optmem_max)
+	    READ_ONCE(sysctl_optmem_max))
 		return NULL;
 
 	skb = alloc_skb(size, priority);
@@ -2386,8 +2386,10 @@ struct sk_buff *sock_omalloc(struct sock *sk, unsigned long size,
  */
 void *sock_kmalloc(struct sock *sk, int size, gfp_t priority)
 {
-	if ((unsigned int)size <= sysctl_optmem_max &&
-	    atomic_read(&sk->sk_omem_alloc) + size < sysctl_optmem_max) {
+	int optmem_max = READ_ONCE(sysctl_optmem_max);
+
+	if ((unsigned int)size <= optmem_max &&
+	    atomic_read(&sk->sk_omem_alloc) + size < optmem_max) {
 		void *mem;
 		/* First do the add, to avoid the race if kmalloc
 		 * might sleep.
@@ -3124,8 +3126,8 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 	timer_setup(&sk->sk_timer, NULL, 0);
 
 	sk->sk_allocation	=	GFP_KERNEL;
-	sk->sk_rcvbuf		=	sysctl_rmem_default;
-	sk->sk_sndbuf		=	sysctl_wmem_default;
+	sk->sk_rcvbuf		=	READ_ONCE(sysctl_rmem_default);
+	sk->sk_sndbuf		=	READ_ONCE(sysctl_wmem_default);
 	sk->sk_state		=	TCP_CLOSE;
 	sk_set_socket(sk, sock);
 
@@ -3180,7 +3182,7 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	sk->sk_napi_id		=	0;
-	sk->sk_ll_usec		=	sysctl_net_busy_read;
+	sk->sk_ll_usec		=	READ_ONCE(sysctl_net_busy_read);
 #endif
 
 	sk->sk_max_pacing_rate = ~0UL;
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 5f88526ad61c..ed20cbdd1931 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -236,14 +236,17 @@ static int set_default_qdisc(struct ctl_table *table, int write,
 static int proc_do_dev_weight(struct ctl_table *table, int write,
 			   void *buffer, size_t *lenp, loff_t *ppos)
 {
-	int ret;
+	static DEFINE_MUTEX(dev_weight_mutex);
+	int ret, weight;
 
+	mutex_lock(&dev_weight_mutex);
 	ret = proc_dointvec(table, write, buffer, lenp, ppos);
-	if (ret != 0)
-		return ret;
-
-	dev_rx_weight = weight_p * dev_weight_rx_bias;
-	dev_tx_weight = weight_p * dev_weight_tx_bias;
+	if (!ret && write) {
+		weight = READ_ONCE(weight_p);
+		WRITE_ONCE(dev_rx_weight, weight * dev_weight_rx_bias);
+		WRITE_ONCE(dev_tx_weight, weight * dev_weight_tx_bias);
+	}
+	mutex_unlock(&dev_weight_mutex);
 
 	return ret;
 }
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index a2bf2d8ac65b..11ec9e689589 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -174,7 +174,7 @@ static int dsa_slave_set_mac_address(struct net_device *dev, void *a)
 		dev_uc_del(master, dev->dev_addr);
 
 out:
-	ether_addr_copy(dev->dev_addr, addr->sa_data);
+	eth_hw_addr_set(dev, addr->sa_data);
 
 	return 0;
 }
@@ -1954,7 +1954,7 @@ int dsa_slave_create(struct dsa_port *port)
 
 	slave_dev->ethtool_ops = &dsa_slave_ethtool_ops;
 	if (!is_zero_ether_addr(port->mac))
-		ether_addr_copy(slave_dev->dev_addr, port->mac);
+		eth_hw_addr_set(slave_dev, port->mac);
 	else
 		eth_hw_addr_inherit(slave_dev, master);
 	slave_dev->priv_flags |= IFF_NO_QUEUE;
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index ea7b96e296ef..a1045c3d71b4 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -493,7 +493,7 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 	INIT_LIST_HEAD(&hsr->self_node_db);
 	spin_lock_init(&hsr->list_lock);
 
-	ether_addr_copy(hsr_dev->dev_addr, slave[0]->dev_addr);
+	eth_hw_addr_set(hsr_dev, slave[0]->dev_addr);
 
 	/* initialize protocol specific functions */
 	if (protocol_version == PRP_V1) {
diff --git a/net/hsr/hsr_main.c b/net/hsr/hsr_main.c
index f7e284f23b1f..b099c3150150 100644
--- a/net/hsr/hsr_main.c
+++ b/net/hsr/hsr_main.c
@@ -75,7 +75,7 @@ static int hsr_netdev_notify(struct notifier_block *nb, unsigned long event,
 		master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
 
 		if (port->type == HSR_PT_SLAVE_A) {
-			ether_addr_copy(master->dev->dev_addr, dev->dev_addr);
+			eth_hw_addr_set(master->dev, dev->dev_addr);
 			call_netdevice_notifiers(NETDEV_CHANGEADDR,
 						 master->dev);
 		}
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 4744c7839de5..9ac41ffdc634 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2673,23 +2673,27 @@ static __net_init int devinet_init_net(struct net *net)
 #endif
 
 	if (!net_eq(net, &init_net)) {
-		if (IS_ENABLED(CONFIG_SYSCTL) &&
-		    sysctl_devconf_inherit_init_net == 3) {
+		switch (net_inherit_devconf()) {
+		case 3:
 			/* copy from the current netns */
 			memcpy(all, current->nsproxy->net_ns->ipv4.devconf_all,
 			       sizeof(ipv4_devconf));
 			memcpy(dflt,
 			       current->nsproxy->net_ns->ipv4.devconf_dflt,
 			       sizeof(ipv4_devconf_dflt));
-		} else if (!IS_ENABLED(CONFIG_SYSCTL) ||
-			   sysctl_devconf_inherit_init_net != 2) {
-			/* inherit == 0 or 1: copy from init_net */
+			break;
+		case 0:
+		case 1:
+			/* copy from init_net */
 			memcpy(all, init_net.ipv4.devconf_all,
 			       sizeof(ipv4_devconf));
 			memcpy(dflt, init_net.ipv4.devconf_dflt,
 			       sizeof(ipv4_devconf_dflt));
+			break;
+		case 2:
+			/* use compiled values */
+			break;
 		}
-		/* else inherit == 2: use compiled values */
 	}
 
 #ifdef CONFIG_SYSCTL
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 131066d0319a..7aff0179b3c2 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1712,7 +1712,7 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
 
 	sk->sk_protocol = ip_hdr(skb)->protocol;
 	sk->sk_bound_dev_if = arg->bound_dev_if;
-	sk->sk_sndbuf = sysctl_wmem_default;
+	sk->sk_sndbuf = READ_ONCE(sysctl_wmem_default);
 	ipc.sockc.mark = fl4.flowi4_mark;
 	err = ip_append_data(sk, &fl4, ip_reply_glue_bits, arg->iov->iov_base,
 			     len, 0, &ipc, &rt, MSG_DONTWAIT);
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 38f296afb663..1e2af5f8822d 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -772,7 +772,7 @@ static int ip_set_mcast_msfilter(struct sock *sk, sockptr_t optval, int optlen)
 
 	if (optlen < GROUP_FILTER_SIZE(0))
 		return -EINVAL;
-	if (optlen > sysctl_optmem_max)
+	if (optlen > READ_ONCE(sysctl_optmem_max))
 		return -ENOBUFS;
 
 	gsf = memdup_sockptr(optval, optlen);
@@ -808,7 +808,7 @@ static int compat_ip_set_mcast_msfilter(struct sock *sk, sockptr_t optval,
 
 	if (optlen < size0)
 		return -EINVAL;
-	if (optlen > sysctl_optmem_max - 4)
+	if (optlen > READ_ONCE(sysctl_optmem_max) - 4)
 		return -ENOBUFS;
 
 	p = kmalloc(optlen + 4, GFP_KERNEL);
@@ -1231,7 +1231,7 @@ static int do_ip_setsockopt(struct sock *sk, int level, int optname,
 
 		if (optlen < IP_MSFILTER_SIZE(0))
 			goto e_inval;
-		if (optlen > sysctl_optmem_max) {
+		if (optlen > READ_ONCE(sysctl_optmem_max)) {
 			err = -ENOBUFS;
 			break;
 		}
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 2097eeaf30a6..0ebef2a5950c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -644,7 +644,7 @@ int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 }
 EXPORT_SYMBOL(tcp_ioctl);
 
-static inline void tcp_mark_push(struct tcp_sock *tp, struct sk_buff *skb)
+void tcp_mark_push(struct tcp_sock *tp, struct sk_buff *skb)
 {
 	TCP_SKB_CB(skb)->tcp_flags |= TCPHDR_PSH;
 	tp->pushed_seq = tp->write_seq;
@@ -655,7 +655,7 @@ static inline bool forced_push(const struct tcp_sock *tp)
 	return after(tp->write_seq, tp->pushed_seq + (tp->max_window >> 1));
 }
 
-static void skb_entail(struct sock *sk, struct sk_buff *skb)
+void tcp_skb_entail(struct sock *sk, struct sk_buff *skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_skb_cb *tcb = TCP_SKB_CB(skb);
@@ -982,7 +982,7 @@ struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
 #ifdef CONFIG_TLS_DEVICE
 		skb->decrypted = !!(flags & MSG_SENDPAGE_DECRYPTED);
 #endif
-		skb_entail(sk, skb);
+		tcp_skb_entail(sk, skb);
 		copy = size_goal;
 	}
 
@@ -991,7 +991,7 @@ struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
 
 	i = skb_shinfo(skb)->nr_frags;
 	can_coalesce = skb_can_coalesce(skb, i, page, offset);
-	if (!can_coalesce && i >= sysctl_max_skb_frags) {
+	if (!can_coalesce && i >= READ_ONCE(sysctl_max_skb_frags)) {
 		tcp_mark_push(tp, skb);
 		goto new_segment;
 	}
@@ -1312,7 +1312,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 			process_backlog++;
 			skb->ip_summed = CHECKSUM_PARTIAL;
 
-			skb_entail(sk, skb);
+			tcp_skb_entail(sk, skb);
 			copy = size_goal;
 
 			/* All packets are restored as if they have
@@ -1344,7 +1344,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 			if (!skb_can_coalesce(skb, i, pfrag->page,
 					      pfrag->offset)) {
-				if (i >= sysctl_max_skb_frags) {
+				if (i >= READ_ONCE(sysctl_max_skb_frags)) {
 					tcp_mark_push(tp, skb);
 					goto new_segment;
 				}
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 40c9da4bd03e..ed2e1836c0c0 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -239,7 +239,7 @@ void tcp_select_initial_window(const struct sock *sk, int __space, __u32 mss,
 	if (wscale_ok) {
 		/* Set window scaling on max possible window */
 		space = max_t(u32, space, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2]));
-		space = max_t(u32, space, sysctl_rmem_max);
+		space = max_t(u32, space, READ_ONCE(sysctl_rmem_max));
 		space = min_t(u32, space, *window_clamp);
 		*rcv_wscale = clamp_t(int, ilog2(space) - 15,
 				      0, TCP_MAX_WSCALE);
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 6dcf034835ec..8800987fdb40 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7128,9 +7128,8 @@ static int __net_init addrconf_init_net(struct net *net)
 	if (!dflt)
 		goto err_alloc_dflt;
 
-	if (IS_ENABLED(CONFIG_SYSCTL) &&
-	    !net_eq(net, &init_net)) {
-		switch (sysctl_devconf_inherit_init_net) {
+	if (!net_eq(net, &init_net)) {
+		switch (net_inherit_devconf()) {
 		case 1:  /* copy from init_net */
 			memcpy(all, init_net.ipv6.devconf_all,
 			       sizeof(ipv6_devconf));
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index e4bdb09c5586..8a1c78f38508 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -208,7 +208,7 @@ static int ipv6_set_mcast_msfilter(struct sock *sk, sockptr_t optval,
 
 	if (optlen < GROUP_FILTER_SIZE(0))
 		return -EINVAL;
-	if (optlen > sysctl_optmem_max)
+	if (optlen > READ_ONCE(sysctl_optmem_max))
 		return -ENOBUFS;
 
 	gsf = memdup_sockptr(optval, optlen);
@@ -242,7 +242,7 @@ static int compat_ipv6_set_mcast_msfilter(struct sock *sk, sockptr_t optval,
 
 	if (optlen < size0)
 		return -EINVAL;
-	if (optlen > sysctl_optmem_max - 4)
+	if (optlen > READ_ONCE(sysctl_optmem_max) - 4)
 		return -ENOBUFS;
 
 	p = kmalloc(optlen + 4, GFP_KERNEL);
diff --git a/net/key/af_key.c b/net/key/af_key.c
index d93bde657359..53cca9019158 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1697,9 +1697,12 @@ static int pfkey_register(struct sock *sk, struct sk_buff *skb, const struct sad
 		pfk->registered |= (1<<hdr->sadb_msg_satype);
 	}
 
+	mutex_lock(&pfkey_mutex);
 	xfrm_probe_algs();
 
 	supp_skb = compose_sadb_supported(hdr, GFP_KERNEL | __GFP_ZERO);
+	mutex_unlock(&pfkey_mutex);
+
 	if (!supp_skb) {
 		if (hdr->sadb_msg_satype != SADB_SATYPE_UNSPEC)
 			pfk->registered &= ~(1<<hdr->sadb_msg_satype);
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 7f96e0c42a09..47f359dac247 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1224,6 +1224,7 @@ static struct sk_buff *__mptcp_do_alloc_tx_skb(struct sock *sk, gfp_t gfp)
 		if (likely(__mptcp_add_ext(skb, gfp))) {
 			skb_reserve(skb, MAX_TCP_HEADER);
 			skb->reserved_tailroom = skb->end - skb->tail;
+			INIT_LIST_HEAD(&skb->tcp_tsorted_anchor);
 			return skb;
 		}
 		__kfree_skb(skb);
@@ -1233,31 +1234,24 @@ static struct sk_buff *__mptcp_do_alloc_tx_skb(struct sock *sk, gfp_t gfp)
 	return NULL;
 }
 
-static bool __mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk, gfp_t gfp)
+static struct sk_buff *__mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk, gfp_t gfp)
 {
 	struct sk_buff *skb;
 
-	if (ssk->sk_tx_skb_cache) {
-		skb = ssk->sk_tx_skb_cache;
-		if (unlikely(!skb_ext_find(skb, SKB_EXT_MPTCP) &&
-			     !__mptcp_add_ext(skb, gfp)))
-			return false;
-		return true;
-	}
-
 	skb = __mptcp_do_alloc_tx_skb(sk, gfp);
 	if (!skb)
-		return false;
+		return NULL;
 
 	if (likely(sk_wmem_schedule(ssk, skb->truesize))) {
-		ssk->sk_tx_skb_cache = skb;
-		return true;
+		tcp_skb_entail(ssk, skb);
+		return skb;
 	}
+	tcp_skb_tsorted_anchor_cleanup(skb);
 	kfree_skb(skb);
-	return false;
+	return NULL;
 }
 
-static bool mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk, bool data_lock_held)
+static struct sk_buff *mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk, bool data_lock_held)
 {
 	gfp_t gfp = data_lock_held ? GFP_ATOMIC : sk->sk_allocation;
 
@@ -1287,23 +1281,29 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 			      struct mptcp_sendmsg_info *info)
 {
 	u64 data_seq = dfrag->data_seq + info->sent;
+	int offset = dfrag->offset + info->sent;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	bool zero_window_probe = false;
 	struct mptcp_ext *mpext = NULL;
-	struct sk_buff *skb, *tail;
-	bool must_collapse = false;
-	int size_bias = 0;
-	int avail_size;
-	size_t ret = 0;
+	bool can_coalesce = false;
+	bool reuse_skb = true;
+	struct sk_buff *skb;
+	size_t copy;
+	int i;
 
 	pr_debug("msk=%p ssk=%p sending dfrag at seq=%llu len=%u already sent=%u",
 		 msk, ssk, dfrag->data_seq, dfrag->data_len, info->sent);
 
+	if (WARN_ON_ONCE(info->sent > info->limit ||
+			 info->limit > dfrag->data_len))
+		return 0;
+
 	/* compute send limit */
 	info->mss_now = tcp_send_mss(ssk, &info->size_goal, info->flags);
-	avail_size = info->size_goal;
+	copy = info->size_goal;
+
 	skb = tcp_write_queue_tail(ssk);
-	if (skb) {
+	if (skb && copy > skb->len) {
 		/* Limit the write to the size available in the
 		 * current skb, if any, so that we create at most a new skb.
 		 * Explicitly tells TCP internals to avoid collapsing on later
@@ -1316,62 +1316,80 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 			goto alloc_skb;
 		}
 
-		must_collapse = (info->size_goal > skb->len) &&
-				(skb_shinfo(skb)->nr_frags < sysctl_max_skb_frags);
-		if (must_collapse) {
-			size_bias = skb->len;
-			avail_size = info->size_goal - skb->len;
+		i = skb_shinfo(skb)->nr_frags;
+		can_coalesce = skb_can_coalesce(skb, i, dfrag->page, offset);
+		if (!can_coalesce && i >= READ_ONCE(sysctl_max_skb_frags)) {
+			tcp_mark_push(tcp_sk(ssk), skb);
+			goto alloc_skb;
 		}
-	}
 
+		copy -= skb->len;
+	} else {
 alloc_skb:
-	if (!must_collapse &&
-	    !mptcp_alloc_tx_skb(sk, ssk, info->data_lock_held))
-		return 0;
+		skb = mptcp_alloc_tx_skb(sk, ssk, info->data_lock_held);
+		if (!skb)
+			return -ENOMEM;
+
+		i = skb_shinfo(skb)->nr_frags;
+		reuse_skb = false;
+		mpext = skb_ext_find(skb, SKB_EXT_MPTCP);
+	}
 
 	/* Zero window and all data acked? Probe. */
-	avail_size = mptcp_check_allowed_size(msk, data_seq, avail_size);
-	if (avail_size == 0) {
+	copy = mptcp_check_allowed_size(msk, data_seq, copy);
+	if (copy == 0) {
 		u64 snd_una = READ_ONCE(msk->snd_una);
 
-		if (skb || snd_una != msk->snd_nxt)
+		if (snd_una != msk->snd_nxt) {
+			tcp_remove_empty_skb(ssk, tcp_write_queue_tail(ssk));
 			return 0;
+		}
+
 		zero_window_probe = true;
 		data_seq = snd_una - 1;
-		avail_size = 1;
-	}
+		copy = 1;
 
-	if (WARN_ON_ONCE(info->sent > info->limit ||
-			 info->limit > dfrag->data_len))
-		return 0;
+		/* all mptcp-level data is acked, no skbs should be present into the
+		 * ssk write queue
+		 */
+		WARN_ON_ONCE(reuse_skb);
+	}
 
-	ret = info->limit - info->sent;
-	tail = tcp_build_frag(ssk, avail_size + size_bias, info->flags,
-			      dfrag->page, dfrag->offset + info->sent, &ret);
-	if (!tail) {
-		tcp_remove_empty_skb(sk, tcp_write_queue_tail(ssk));
+	copy = min_t(size_t, copy, info->limit - info->sent);
+	if (!sk_wmem_schedule(ssk, copy)) {
+		tcp_remove_empty_skb(ssk, tcp_write_queue_tail(ssk));
 		return -ENOMEM;
 	}
 
-	/* if the tail skb is still the cached one, collapsing really happened.
-	 */
-	if (skb == tail) {
-		TCP_SKB_CB(tail)->tcp_flags &= ~TCPHDR_PSH;
-		mpext->data_len += ret;
+	if (can_coalesce) {
+		skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
+	} else {
+		get_page(dfrag->page);
+		skb_fill_page_desc(skb, i, dfrag->page, offset, copy);
+	}
+
+	skb->len += copy;
+	skb->data_len += copy;
+	skb->truesize += copy;
+	sk_wmem_queued_add(ssk, copy);
+	sk_mem_charge(ssk, copy);
+	skb->ip_summed = CHECKSUM_PARTIAL;
+	WRITE_ONCE(tcp_sk(ssk)->write_seq, tcp_sk(ssk)->write_seq + copy);
+	TCP_SKB_CB(skb)->end_seq += copy;
+	tcp_skb_pcount_set(skb, 0);
+
+	/* on skb reuse we just need to update the DSS len */
+	if (reuse_skb) {
+		TCP_SKB_CB(skb)->tcp_flags &= ~TCPHDR_PSH;
+		mpext->data_len += copy;
 		WARN_ON_ONCE(zero_window_probe);
 		goto out;
 	}
 
-	mpext = skb_ext_find(tail, SKB_EXT_MPTCP);
-	if (WARN_ON_ONCE(!mpext)) {
-		/* should never reach here, stream corrupted */
-		return -EINVAL;
-	}
-
 	memset(mpext, 0, sizeof(*mpext));
 	mpext->data_seq = data_seq;
 	mpext->subflow_seq = mptcp_subflow_ctx(ssk)->rel_write_seq;
-	mpext->data_len = ret;
+	mpext->data_len = copy;
 	mpext->use_map = 1;
 	mpext->dsn64 = 1;
 
@@ -1380,18 +1398,18 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 		 mpext->dsn64);
 
 	if (zero_window_probe) {
-		mptcp_subflow_ctx(ssk)->rel_write_seq += ret;
+		mptcp_subflow_ctx(ssk)->rel_write_seq += copy;
 		mpext->frozen = 1;
 		if (READ_ONCE(msk->csum_enabled))
-			mptcp_update_data_checksum(tail, ret);
+			mptcp_update_data_checksum(skb, copy);
 		tcp_push_pending_frames(ssk);
 		return 0;
 	}
 out:
 	if (READ_ONCE(msk->csum_enabled))
-		mptcp_update_data_checksum(tail, ret);
-	mptcp_subflow_ctx(ssk)->rel_write_seq += ret;
-	return ret;
+		mptcp_update_data_checksum(skb, copy);
+	mptcp_subflow_ctx(ssk)->rel_write_seq += copy;
+	return copy;
 }
 
 #define MPTCP_SEND_BURST_SIZE		((1 << 16) - \
diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 9d43277b8b4f..a56fd0b5a430 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -1280,12 +1280,12 @@ static void set_sock_size(struct sock *sk, int mode, int val)
 	lock_sock(sk);
 	if (mode) {
 		val = clamp_t(int, val, (SOCK_MIN_SNDBUF + 1) / 2,
-			      sysctl_wmem_max);
+			      READ_ONCE(sysctl_wmem_max));
 		sk->sk_sndbuf = val * 2;
 		sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
 	} else {
 		val = clamp_t(int, val, (SOCK_MIN_RCVBUF + 1) / 2,
-			      sysctl_rmem_max);
+			      READ_ONCE(sysctl_rmem_max));
 		sk->sk_rcvbuf = val * 2;
 		sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
 	}
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 9fb407084c50..4f61eb128283 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -436,12 +436,17 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 	}
 }
 
+void nf_flow_table_gc_run(struct nf_flowtable *flow_table)
+{
+	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
+}
+
 static void nf_flow_offload_work_gc(struct work_struct *work)
 {
 	struct nf_flowtable *flow_table;
 
 	flow_table = container_of(work, struct nf_flowtable, gc_work.work);
-	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
+	nf_flow_table_gc_run(flow_table);
 	queue_delayed_work(system_power_efficient_wq, &flow_table->gc_work, HZ);
 }
 
@@ -599,11 +604,11 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 	mutex_unlock(&flowtable_lock);
 
 	cancel_delayed_work_sync(&flow_table->gc_work);
-	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
-	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
 	nf_flow_table_offload_flush(flow_table);
-	if (nf_flowtable_hw_offload(flow_table))
-		nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
+	/* ... no more pending work after this stage ... */
+	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
+	nf_flow_table_gc_run(flow_table);
+	nf_flow_table_offload_flush_cleanup(flow_table);
 	rhashtable_destroy(&flow_table->rhashtable);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index b561e0a44a45..c4559fae8acd 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1050,6 +1050,14 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
 	flow_offload_queue_work(offload);
 }
 
+void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable)
+{
+	if (nf_flowtable_hw_offload(flowtable)) {
+		flush_workqueue(nf_flow_offload_del_wq);
+		nf_flow_table_gc_run(flowtable);
+	}
+}
+
 void nf_flow_table_offload_flush(struct nf_flowtable *flowtable)
 {
 	if (nf_flowtable_hw_offload(flowtable)) {
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2f22a172a27e..d8ca55d6be40 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -32,7 +32,6 @@ static LIST_HEAD(nf_tables_objects);
 static LIST_HEAD(nf_tables_flowtables);
 static LIST_HEAD(nf_tables_destroy_list);
 static DEFINE_SPINLOCK(nf_tables_destroy_list_lock);
-static u64 table_handle;
 
 enum {
 	NFT_VALIDATE_SKIP	= 0,
@@ -1156,7 +1155,7 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 	INIT_LIST_HEAD(&table->flowtables);
 	table->family = family;
 	table->flags = flags;
-	table->handle = ++table_handle;
+	table->handle = ++nft_net->table_handle;
 	if (table->flags & NFT_TABLE_F_OWNER)
 		table->nlpid = NETLINK_CB(skb).portid;
 
@@ -2102,9 +2101,9 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 			      struct netlink_ext_ack *extack)
 {
 	const struct nlattr * const *nla = ctx->nla;
+	struct nft_stats __percpu *stats = NULL;
 	struct nft_table *table = ctx->table;
 	struct nft_base_chain *basechain;
-	struct nft_stats __percpu *stats;
 	struct net *net = ctx->net;
 	char name[NFT_NAME_MAXLEN];
 	struct nft_trans *trans;
@@ -2141,7 +2140,6 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 				return PTR_ERR(stats);
 			}
 			rcu_assign_pointer(basechain->stats, stats);
-			static_branch_inc(&nft_counters_enabled);
 		}
 
 		err = nft_basechain_init(basechain, family, &hook, flags);
@@ -2224,6 +2222,9 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		goto err_unregister_hook;
 	}
 
+	if (stats)
+		static_branch_inc(&nft_counters_enabled);
+
 	table->use++;
 
 	return 0;
@@ -2479,6 +2480,9 @@ static int nf_tables_newchain(struct sk_buff *skb, const struct nfnl_info *info,
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, chain, nla);
 
 	if (chain != NULL) {
+		if (chain->flags & NFT_CHAIN_BINDING)
+			return -EINVAL;
+
 		if (info->nlh->nlmsg_flags & NLM_F_EXCL) {
 			NL_SET_BAD_ATTR(extack, attr);
 			return -EEXIST;
@@ -5116,19 +5120,13 @@ static int nft_setelem_parse_flags(const struct nft_set *set,
 static int nft_setelem_parse_key(struct nft_ctx *ctx, struct nft_set *set,
 				 struct nft_data *key, struct nlattr *attr)
 {
-	struct nft_data_desc desc;
-	int err;
-
-	err = nft_data_init(ctx, key, NFT_DATA_VALUE_MAXLEN, &desc, attr);
-	if (err < 0)
-		return err;
-
-	if (desc.type != NFT_DATA_VALUE || desc.len != set->klen) {
-		nft_data_release(key, desc.type);
-		return -EINVAL;
-	}
+	struct nft_data_desc desc = {
+		.type	= NFT_DATA_VALUE,
+		.size	= NFT_DATA_VALUE_MAXLEN,
+		.len	= set->klen,
+	};
 
-	return 0;
+	return nft_data_init(ctx, key, &desc, attr);
 }
 
 static int nft_setelem_parse_data(struct nft_ctx *ctx, struct nft_set *set,
@@ -5137,24 +5135,18 @@ static int nft_setelem_parse_data(struct nft_ctx *ctx, struct nft_set *set,
 				  struct nlattr *attr)
 {
 	u32 dtype;
-	int err;
-
-	err = nft_data_init(ctx, data, NFT_DATA_VALUE_MAXLEN, desc, attr);
-	if (err < 0)
-		return err;
 
 	if (set->dtype == NFT_DATA_VERDICT)
 		dtype = NFT_DATA_VERDICT;
 	else
 		dtype = NFT_DATA_VALUE;
 
-	if (dtype != desc->type ||
-	    set->dlen != desc->len) {
-		nft_data_release(data, desc->type);
-		return -EINVAL;
-	}
+	desc->type = dtype;
+	desc->size = NFT_DATA_VALUE_MAXLEN;
+	desc->len = set->dlen;
+	desc->flags = NFT_DATA_DESC_SETELEM;
 
-	return 0;
+	return nft_data_init(ctx, data, desc, attr);
 }
 
 static void *nft_setelem_catchall_get(const struct net *net,
@@ -9513,6 +9505,11 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 			return PTR_ERR(chain);
 		if (nft_is_base_chain(chain))
 			return -EOPNOTSUPP;
+		if (nft_chain_is_bound(chain))
+			return -EINVAL;
+		if (desc->flags & NFT_DATA_DESC_SETELEM &&
+		    chain->flags & NFT_CHAIN_BINDING)
+			return -EINVAL;
 
 		chain->use++;
 		data->verdict.chain = chain;
@@ -9520,7 +9517,7 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 	}
 
 	desc->len = sizeof(data->verdict);
-	desc->type = NFT_DATA_VERDICT;
+
 	return 0;
 }
 
@@ -9573,20 +9570,25 @@ int nft_verdict_dump(struct sk_buff *skb, int type, const struct nft_verdict *v)
 }
 
 static int nft_value_init(const struct nft_ctx *ctx,
-			  struct nft_data *data, unsigned int size,
-			  struct nft_data_desc *desc, const struct nlattr *nla)
+			  struct nft_data *data, struct nft_data_desc *desc,
+			  const struct nlattr *nla)
 {
 	unsigned int len;
 
 	len = nla_len(nla);
 	if (len == 0)
 		return -EINVAL;
-	if (len > size)
+	if (len > desc->size)
 		return -EOVERFLOW;
+	if (desc->len) {
+		if (len != desc->len)
+			return -EINVAL;
+	} else {
+		desc->len = len;
+	}
 
 	nla_memcpy(data->data, nla, len);
-	desc->type = NFT_DATA_VALUE;
-	desc->len  = len;
+
 	return 0;
 }
 
@@ -9606,7 +9608,6 @@ static const struct nla_policy nft_data_policy[NFTA_DATA_MAX + 1] = {
  *
  *	@ctx: context of the expression using the data
  *	@data: destination struct nft_data
- *	@size: maximum data length
  *	@desc: data description
  *	@nla: netlink attribute containing data
  *
@@ -9616,24 +9617,35 @@ static const struct nla_policy nft_data_policy[NFTA_DATA_MAX + 1] = {
  *	The caller can indicate that it only wants to accept data of type
  *	NFT_DATA_VALUE by passing NULL for the ctx argument.
  */
-int nft_data_init(const struct nft_ctx *ctx,
-		  struct nft_data *data, unsigned int size,
+int nft_data_init(const struct nft_ctx *ctx, struct nft_data *data,
 		  struct nft_data_desc *desc, const struct nlattr *nla)
 {
 	struct nlattr *tb[NFTA_DATA_MAX + 1];
 	int err;
 
+	if (WARN_ON_ONCE(!desc->size))
+		return -EINVAL;
+
 	err = nla_parse_nested_deprecated(tb, NFTA_DATA_MAX, nla,
 					  nft_data_policy, NULL);
 	if (err < 0)
 		return err;
 
-	if (tb[NFTA_DATA_VALUE])
-		return nft_value_init(ctx, data, size, desc,
-				      tb[NFTA_DATA_VALUE]);
-	if (tb[NFTA_DATA_VERDICT] && ctx != NULL)
-		return nft_verdict_init(ctx, data, desc, tb[NFTA_DATA_VERDICT]);
-	return -EINVAL;
+	if (tb[NFTA_DATA_VALUE]) {
+		if (desc->type != NFT_DATA_VALUE)
+			return -EINVAL;
+
+		err = nft_value_init(ctx, data, desc, tb[NFTA_DATA_VALUE]);
+	} else if (tb[NFTA_DATA_VERDICT] && ctx != NULL) {
+		if (desc->type != NFT_DATA_VERDICT)
+			return -EINVAL;
+
+		err = nft_verdict_init(ctx, data, desc, tb[NFTA_DATA_VERDICT]);
+	} else {
+		err = -EINVAL;
+	}
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(nft_data_init);
 
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index d4d8f613af51..2ab4216d2a90 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -67,6 +67,50 @@ static void nft_cmp_fast_eval(const struct nft_expr *expr,
 	regs->verdict.code = NFT_BREAK;
 }
 
+static void nft_cmp16_fast_eval(const struct nft_expr *expr,
+				struct nft_regs *regs)
+{
+	const struct nft_cmp16_fast_expr *priv = nft_expr_priv(expr);
+	const u64 *reg_data = (const u64 *)&regs->data[priv->sreg];
+	const u64 *mask = (const u64 *)&priv->mask;
+	const u64 *data = (const u64 *)&priv->data;
+
+	if (((reg_data[0] & mask[0]) == data[0] &&
+	    ((reg_data[1] & mask[1]) == data[1])) ^ priv->inv)
+		return;
+	regs->verdict.code = NFT_BREAK;
+}
+
+static noinline void __nft_trace_verdict(struct nft_traceinfo *info,
+					 const struct nft_chain *chain,
+					 const struct nft_regs *regs)
+{
+	enum nft_trace_types type;
+
+	switch (regs->verdict.code) {
+	case NFT_CONTINUE:
+	case NFT_RETURN:
+		type = NFT_TRACETYPE_RETURN;
+		break;
+	default:
+		type = NFT_TRACETYPE_RULE;
+		break;
+	}
+
+	__nft_trace_packet(info, chain, type);
+}
+
+static inline void nft_trace_verdict(struct nft_traceinfo *info,
+				     const struct nft_chain *chain,
+				     const struct nft_rule *rule,
+				     const struct nft_regs *regs)
+{
+	if (static_branch_unlikely(&nft_trace_enabled)) {
+		info->rule = rule;
+		__nft_trace_verdict(info, chain, regs);
+	}
+}
+
 static bool nft_payload_fast_eval(const struct nft_expr *expr,
 				  struct nft_regs *regs,
 				  const struct nft_pktinfo *pkt)
@@ -185,6 +229,8 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		nft_rule_for_each_expr(expr, last, rule) {
 			if (expr->ops == &nft_cmp_fast_ops)
 				nft_cmp_fast_eval(expr, &regs);
+			else if (expr->ops == &nft_cmp16_fast_ops)
+				nft_cmp16_fast_eval(expr, &regs);
 			else if (expr->ops == &nft_bitwise_fast_ops)
 				nft_bitwise_fast_eval(expr, &regs);
 			else if (expr->ops != &nft_payload_fast_ops ||
@@ -207,13 +253,13 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		break;
 	}
 
+	nft_trace_verdict(&info, chain, rule, &regs);
+
 	switch (regs.verdict.code & NF_VERDICT_MASK) {
 	case NF_ACCEPT:
 	case NF_DROP:
 	case NF_QUEUE:
 	case NF_STOLEN:
-		nft_trace_packet(&info, chain, rule,
-				 NFT_TRACETYPE_RULE);
 		return regs.verdict.code;
 	}
 
@@ -226,15 +272,10 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		stackptr++;
 		fallthrough;
 	case NFT_GOTO:
-		nft_trace_packet(&info, chain, rule,
-				 NFT_TRACETYPE_RULE);
-
 		chain = regs.verdict.chain;
 		goto do_chain;
 	case NFT_CONTINUE:
 	case NFT_RETURN:
-		nft_trace_packet(&info, chain, rule,
-				 NFT_TRACETYPE_RETURN);
 		break;
 	default:
 		WARN_ON(1);
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 47b0dba95054..d6ab7aa14adc 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -93,7 +93,16 @@ static const struct nla_policy nft_bitwise_policy[NFTA_BITWISE_MAX + 1] = {
 static int nft_bitwise_init_bool(struct nft_bitwise *priv,
 				 const struct nlattr *const tb[])
 {
-	struct nft_data_desc mask, xor;
+	struct nft_data_desc mask = {
+		.type	= NFT_DATA_VALUE,
+		.size	= sizeof(priv->mask),
+		.len	= priv->len,
+	};
+	struct nft_data_desc xor = {
+		.type	= NFT_DATA_VALUE,
+		.size	= sizeof(priv->xor),
+		.len	= priv->len,
+	};
 	int err;
 
 	if (tb[NFTA_BITWISE_DATA])
@@ -103,36 +112,30 @@ static int nft_bitwise_init_bool(struct nft_bitwise *priv,
 	    !tb[NFTA_BITWISE_XOR])
 		return -EINVAL;
 
-	err = nft_data_init(NULL, &priv->mask, sizeof(priv->mask), &mask,
-			    tb[NFTA_BITWISE_MASK]);
+	err = nft_data_init(NULL, &priv->mask, &mask, tb[NFTA_BITWISE_MASK]);
 	if (err < 0)
 		return err;
-	if (mask.type != NFT_DATA_VALUE || mask.len != priv->len) {
-		err = -EINVAL;
-		goto err1;
-	}
 
-	err = nft_data_init(NULL, &priv->xor, sizeof(priv->xor), &xor,
-			    tb[NFTA_BITWISE_XOR]);
+	err = nft_data_init(NULL, &priv->xor, &xor, tb[NFTA_BITWISE_XOR]);
 	if (err < 0)
-		goto err1;
-	if (xor.type != NFT_DATA_VALUE || xor.len != priv->len) {
-		err = -EINVAL;
-		goto err2;
-	}
+		goto err_xor_err;
 
 	return 0;
-err2:
-	nft_data_release(&priv->xor, xor.type);
-err1:
+
+err_xor_err:
 	nft_data_release(&priv->mask, mask.type);
+
 	return err;
 }
 
 static int nft_bitwise_init_shift(struct nft_bitwise *priv,
 				  const struct nlattr *const tb[])
 {
-	struct nft_data_desc d;
+	struct nft_data_desc desc = {
+		.type	= NFT_DATA_VALUE,
+		.size	= sizeof(priv->data),
+		.len	= sizeof(u32),
+	};
 	int err;
 
 	if (tb[NFTA_BITWISE_MASK] ||
@@ -142,13 +145,12 @@ static int nft_bitwise_init_shift(struct nft_bitwise *priv,
 	if (!tb[NFTA_BITWISE_DATA])
 		return -EINVAL;
 
-	err = nft_data_init(NULL, &priv->data, sizeof(priv->data), &d,
-			    tb[NFTA_BITWISE_DATA]);
+	err = nft_data_init(NULL, &priv->data, &desc, tb[NFTA_BITWISE_DATA]);
 	if (err < 0)
 		return err;
-	if (d.type != NFT_DATA_VALUE || d.len != sizeof(u32) ||
-	    priv->data.data[0] >= BITS_PER_TYPE(u32)) {
-		nft_data_release(&priv->data, d.type);
+
+	if (priv->data.data[0] >= BITS_PER_TYPE(u32)) {
+		nft_data_release(&priv->data, desc.type);
 		return -EINVAL;
 	}
 
@@ -290,22 +292,21 @@ static const struct nft_expr_ops nft_bitwise_ops = {
 static int
 nft_bitwise_extract_u32_data(const struct nlattr * const tb, u32 *out)
 {
-	struct nft_data_desc desc;
 	struct nft_data data;
-	int err = 0;
+	struct nft_data_desc desc = {
+		.type	= NFT_DATA_VALUE,
+		.size	= sizeof(data),
+		.len	= sizeof(u32),
+	};
+	int err;
 
-	err = nft_data_init(NULL, &data, sizeof(data), &desc, tb);
+	err = nft_data_init(NULL, &data, &desc, tb);
 	if (err < 0)
 		return err;
 
-	if (desc.type != NFT_DATA_VALUE || desc.len != sizeof(u32)) {
-		err = -EINVAL;
-		goto err;
-	}
 	*out = data.data[0];
-err:
-	nft_data_release(&data, desc.type);
-	return err;
+
+	return 0;
 }
 
 static int nft_bitwise_fast_init(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 47b6d05f1ae6..461763a571f2 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -73,20 +73,16 @@ static int nft_cmp_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 			const struct nlattr * const tb[])
 {
 	struct nft_cmp_expr *priv = nft_expr_priv(expr);
-	struct nft_data_desc desc;
+	struct nft_data_desc desc = {
+		.type	= NFT_DATA_VALUE,
+		.size	= sizeof(priv->data),
+	};
 	int err;
 
-	err = nft_data_init(NULL, &priv->data, sizeof(priv->data), &desc,
-			    tb[NFTA_CMP_DATA]);
+	err = nft_data_init(NULL, &priv->data, &desc, tb[NFTA_CMP_DATA]);
 	if (err < 0)
 		return err;
 
-	if (desc.type != NFT_DATA_VALUE) {
-		err = -EINVAL;
-		nft_data_release(&priv->data, desc.type);
-		return err;
-	}
-
 	err = nft_parse_register_load(tb[NFTA_CMP_SREG], &priv->sreg, desc.len);
 	if (err < 0)
 		return err;
@@ -201,12 +197,14 @@ static int nft_cmp_fast_init(const struct nft_ctx *ctx,
 			     const struct nlattr * const tb[])
 {
 	struct nft_cmp_fast_expr *priv = nft_expr_priv(expr);
-	struct nft_data_desc desc;
 	struct nft_data data;
+	struct nft_data_desc desc = {
+		.type	= NFT_DATA_VALUE,
+		.size	= sizeof(data),
+	};
 	int err;
 
-	err = nft_data_init(NULL, &data, sizeof(data), &desc,
-			    tb[NFTA_CMP_DATA]);
+	err = nft_data_init(NULL, &data, &desc, tb[NFTA_CMP_DATA]);
 	if (err < 0)
 		return err;
 
@@ -272,12 +270,108 @@ const struct nft_expr_ops nft_cmp_fast_ops = {
 	.offload	= nft_cmp_fast_offload,
 };
 
+static u32 nft_cmp_mask(u32 bitlen)
+{
+	return (__force u32)cpu_to_le32(~0U >> (sizeof(u32) * BITS_PER_BYTE - bitlen));
+}
+
+static void nft_cmp16_fast_mask(struct nft_data *data, unsigned int bitlen)
+{
+	int len = bitlen / BITS_PER_BYTE;
+	int i, words = len / sizeof(u32);
+
+	for (i = 0; i < words; i++) {
+		data->data[i] = 0xffffffff;
+		bitlen -= sizeof(u32) * BITS_PER_BYTE;
+	}
+
+	if (len % sizeof(u32))
+		data->data[i++] = nft_cmp_mask(bitlen);
+
+	for (; i < 4; i++)
+		data->data[i] = 0;
+}
+
+static int nft_cmp16_fast_init(const struct nft_ctx *ctx,
+			       const struct nft_expr *expr,
+			       const struct nlattr * const tb[])
+{
+	struct nft_cmp16_fast_expr *priv = nft_expr_priv(expr);
+	struct nft_data_desc desc = {
+		.type	= NFT_DATA_VALUE,
+		.size	= sizeof(priv->data),
+	};
+	int err;
+
+	err = nft_data_init(NULL, &priv->data, &desc, tb[NFTA_CMP_DATA]);
+	if (err < 0)
+		return err;
+
+	err = nft_parse_register_load(tb[NFTA_CMP_SREG], &priv->sreg, desc.len);
+	if (err < 0)
+		return err;
+
+	nft_cmp16_fast_mask(&priv->mask, desc.len * BITS_PER_BYTE);
+	priv->inv = ntohl(nla_get_be32(tb[NFTA_CMP_OP])) != NFT_CMP_EQ;
+	priv->len = desc.len;
+
+	return 0;
+}
+
+static int nft_cmp16_fast_offload(struct nft_offload_ctx *ctx,
+				  struct nft_flow_rule *flow,
+				  const struct nft_expr *expr)
+{
+	const struct nft_cmp16_fast_expr *priv = nft_expr_priv(expr);
+	struct nft_cmp_expr cmp = {
+		.data	= priv->data,
+		.sreg	= priv->sreg,
+		.len	= priv->len,
+		.op	= priv->inv ? NFT_CMP_NEQ : NFT_CMP_EQ,
+	};
+
+	return __nft_cmp_offload(ctx, flow, &cmp);
+}
+
+static int nft_cmp16_fast_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	const struct nft_cmp16_fast_expr *priv = nft_expr_priv(expr);
+	enum nft_cmp_ops op = priv->inv ? NFT_CMP_NEQ : NFT_CMP_EQ;
+
+	if (nft_dump_register(skb, NFTA_CMP_SREG, priv->sreg))
+		goto nla_put_failure;
+	if (nla_put_be32(skb, NFTA_CMP_OP, htonl(op)))
+		goto nla_put_failure;
+
+	if (nft_data_dump(skb, NFTA_CMP_DATA, &priv->data,
+			  NFT_DATA_VALUE, priv->len) < 0)
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+
+const struct nft_expr_ops nft_cmp16_fast_ops = {
+	.type		= &nft_cmp_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_cmp16_fast_expr)),
+	.eval		= NULL,	/* inlined */
+	.init		= nft_cmp16_fast_init,
+	.dump		= nft_cmp16_fast_dump,
+	.offload	= nft_cmp16_fast_offload,
+};
+
 static const struct nft_expr_ops *
 nft_cmp_select_ops(const struct nft_ctx *ctx, const struct nlattr * const tb[])
 {
-	struct nft_data_desc desc;
 	struct nft_data data;
+	struct nft_data_desc desc = {
+		.type	= NFT_DATA_VALUE,
+		.size	= sizeof(data),
+	};
 	enum nft_cmp_ops op;
+	u8 sreg;
 	int err;
 
 	if (tb[NFTA_CMP_SREG] == NULL ||
@@ -298,21 +392,21 @@ nft_cmp_select_ops(const struct nft_ctx *ctx, const struct nlattr * const tb[])
 		return ERR_PTR(-EINVAL);
 	}
 
-	err = nft_data_init(NULL, &data, sizeof(data), &desc,
-			    tb[NFTA_CMP_DATA]);
+	err = nft_data_init(NULL, &data, &desc, tb[NFTA_CMP_DATA]);
 	if (err < 0)
 		return ERR_PTR(err);
 
-	if (desc.type != NFT_DATA_VALUE)
-		goto err1;
-
-	if (desc.len <= sizeof(u32) && (op == NFT_CMP_EQ || op == NFT_CMP_NEQ))
-		return &nft_cmp_fast_ops;
+	sreg = ntohl(nla_get_be32(tb[NFTA_CMP_SREG]));
 
+	if (op == NFT_CMP_EQ || op == NFT_CMP_NEQ) {
+		if (desc.len <= sizeof(u32))
+			return &nft_cmp_fast_ops;
+		else if (desc.len <= sizeof(data) &&
+			 ((sreg >= NFT_REG_1 && sreg <= NFT_REG_4) ||
+			  (sreg >= NFT_REG32_00 && sreg <= NFT_REG32_12 && sreg % 2 == 0)))
+			return &nft_cmp16_fast_ops;
+	}
 	return &nft_cmp_ops;
-err1:
-	nft_data_release(&data, desc.type);
-	return ERR_PTR(-EINVAL);
 }
 
 struct nft_expr_type nft_cmp_type __read_mostly = {
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index d0f67d325bdf..fcdbc5ed3f36 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -29,20 +29,36 @@ static const struct nla_policy nft_immediate_policy[NFTA_IMMEDIATE_MAX + 1] = {
 	[NFTA_IMMEDIATE_DATA]	= { .type = NLA_NESTED },
 };
 
+static enum nft_data_types nft_reg_to_type(const struct nlattr *nla)
+{
+	enum nft_data_types type;
+	u8 reg;
+
+	reg = ntohl(nla_get_be32(nla));
+	if (reg == NFT_REG_VERDICT)
+		type = NFT_DATA_VERDICT;
+	else
+		type = NFT_DATA_VALUE;
+
+	return type;
+}
+
 static int nft_immediate_init(const struct nft_ctx *ctx,
 			      const struct nft_expr *expr,
 			      const struct nlattr * const tb[])
 {
 	struct nft_immediate_expr *priv = nft_expr_priv(expr);
-	struct nft_data_desc desc;
+	struct nft_data_desc desc = {
+		.size	= sizeof(priv->data),
+	};
 	int err;
 
 	if (tb[NFTA_IMMEDIATE_DREG] == NULL ||
 	    tb[NFTA_IMMEDIATE_DATA] == NULL)
 		return -EINVAL;
 
-	err = nft_data_init(ctx, &priv->data, sizeof(priv->data), &desc,
-			    tb[NFTA_IMMEDIATE_DATA]);
+	desc.type = nft_reg_to_type(tb[NFTA_IMMEDIATE_DREG]);
+	err = nft_data_init(ctx, &priv->data, &desc, tb[NFTA_IMMEDIATE_DATA]);
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index d82677e83400..720dc9fba6d4 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -115,9 +115,21 @@ static int nft_osf_validate(const struct nft_ctx *ctx,
 			    const struct nft_expr *expr,
 			    const struct nft_data **data)
 {
-	return nft_chain_validate_hooks(ctx->chain, (1 << NF_INET_LOCAL_IN) |
-						    (1 << NF_INET_PRE_ROUTING) |
-						    (1 << NF_INET_FORWARD));
+	unsigned int hooks;
+
+	switch (ctx->family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+	case NFPROTO_INET:
+		hooks = (1 << NF_INET_LOCAL_IN) |
+			(1 << NF_INET_PRE_ROUTING) |
+			(1 << NF_INET_FORWARD);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return nft_chain_validate_hooks(ctx->chain, hooks);
 }
 
 static struct nft_expr_type nft_osf_type;
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index b46e01365bd9..da652c21368e 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -712,17 +712,23 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 				const struct nlattr * const tb[])
 {
 	struct nft_payload_set *priv = nft_expr_priv(expr);
+	u32 csum_offset, csum_type = NFT_PAYLOAD_CSUM_NONE;
+	int err;
 
 	priv->base        = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_BASE]));
 	priv->offset      = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_OFFSET]));
 	priv->len         = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_LEN]));
 
 	if (tb[NFTA_PAYLOAD_CSUM_TYPE])
-		priv->csum_type =
-			ntohl(nla_get_be32(tb[NFTA_PAYLOAD_CSUM_TYPE]));
-	if (tb[NFTA_PAYLOAD_CSUM_OFFSET])
-		priv->csum_offset =
-			ntohl(nla_get_be32(tb[NFTA_PAYLOAD_CSUM_OFFSET]));
+		csum_type = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_CSUM_TYPE]));
+	if (tb[NFTA_PAYLOAD_CSUM_OFFSET]) {
+		err = nft_parse_u32_check(tb[NFTA_PAYLOAD_CSUM_OFFSET], U8_MAX,
+					  &csum_offset);
+		if (err < 0)
+			return err;
+
+		priv->csum_offset = csum_offset;
+	}
 	if (tb[NFTA_PAYLOAD_CSUM_FLAGS]) {
 		u32 flags;
 
@@ -733,7 +739,7 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 		priv->csum_flags = flags;
 	}
 
-	switch (priv->csum_type) {
+	switch (csum_type) {
 	case NFT_PAYLOAD_CSUM_NONE:
 	case NFT_PAYLOAD_CSUM_INET:
 		break;
@@ -747,6 +753,7 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 	default:
 		return -EOPNOTSUPP;
 	}
+	priv->csum_type = csum_type;
 
 	return nft_parse_register_load(tb[NFTA_PAYLOAD_SREG], &priv->sreg,
 				       priv->len);
@@ -785,6 +792,7 @@ nft_payload_select_ops(const struct nft_ctx *ctx,
 {
 	enum nft_payload_bases base;
 	unsigned int offset, len;
+	int err;
 
 	if (tb[NFTA_PAYLOAD_BASE] == NULL ||
 	    tb[NFTA_PAYLOAD_OFFSET] == NULL ||
@@ -811,8 +819,13 @@ nft_payload_select_ops(const struct nft_ctx *ctx,
 	if (tb[NFTA_PAYLOAD_DREG] == NULL)
 		return ERR_PTR(-EINVAL);
 
-	offset = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_OFFSET]));
-	len    = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_LEN]));
+	err = nft_parse_u32_check(tb[NFTA_PAYLOAD_OFFSET], U8_MAX, &offset);
+	if (err < 0)
+		return ERR_PTR(err);
+
+	err = nft_parse_u32_check(tb[NFTA_PAYLOAD_LEN], U8_MAX, &len);
+	if (err < 0)
+		return ERR_PTR(err);
 
 	if (len <= 4 && is_power_of_2(len) && IS_ALIGNED(offset, len) &&
 	    base != NFT_PAYLOAD_LL_HEADER && base != NFT_PAYLOAD_INNER_HEADER)
diff --git a/net/netfilter/nft_range.c b/net/netfilter/nft_range.c
index e4a1c44d7f51..e6bbe32c323d 100644
--- a/net/netfilter/nft_range.c
+++ b/net/netfilter/nft_range.c
@@ -51,7 +51,14 @@ static int nft_range_init(const struct nft_ctx *ctx, const struct nft_expr *expr
 			const struct nlattr * const tb[])
 {
 	struct nft_range_expr *priv = nft_expr_priv(expr);
-	struct nft_data_desc desc_from, desc_to;
+	struct nft_data_desc desc_from = {
+		.type	= NFT_DATA_VALUE,
+		.size	= sizeof(priv->data_from),
+	};
+	struct nft_data_desc desc_to = {
+		.type	= NFT_DATA_VALUE,
+		.size	= sizeof(priv->data_to),
+	};
 	int err;
 	u32 op;
 
@@ -61,26 +68,16 @@ static int nft_range_init(const struct nft_ctx *ctx, const struct nft_expr *expr
 	    !tb[NFTA_RANGE_TO_DATA])
 		return -EINVAL;
 
-	err = nft_data_init(NULL, &priv->data_from, sizeof(priv->data_from),
-			    &desc_from, tb[NFTA_RANGE_FROM_DATA]);
+	err = nft_data_init(NULL, &priv->data_from, &desc_from,
+			    tb[NFTA_RANGE_FROM_DATA]);
 	if (err < 0)
 		return err;
 
-	if (desc_from.type != NFT_DATA_VALUE) {
-		err = -EINVAL;
-		goto err1;
-	}
-
-	err = nft_data_init(NULL, &priv->data_to, sizeof(priv->data_to),
-			    &desc_to, tb[NFTA_RANGE_TO_DATA]);
+	err = nft_data_init(NULL, &priv->data_to, &desc_to,
+			    tb[NFTA_RANGE_TO_DATA]);
 	if (err < 0)
 		goto err1;
 
-	if (desc_to.type != NFT_DATA_VALUE) {
-		err = -EINVAL;
-		goto err2;
-	}
-
 	if (desc_from.len != desc_to.len) {
 		err = -EINVAL;
 		goto err2;
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 3b27926d5382..2ee50996da8c 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -133,6 +133,7 @@ static const struct nft_expr_ops nft_tunnel_get_ops = {
 
 static struct nft_expr_type nft_tunnel_type __read_mostly = {
 	.name		= "tunnel",
+	.family		= NFPROTO_NETDEV,
 	.ops		= &nft_tunnel_get_ops,
 	.policy		= nft_tunnel_policy,
 	.maxattr	= NFTA_TUNNEL_MAX,
diff --git a/net/rose/rose_loopback.c b/net/rose/rose_loopback.c
index 11c45c8c6c16..036d92c0ad79 100644
--- a/net/rose/rose_loopback.c
+++ b/net/rose/rose_loopback.c
@@ -96,7 +96,8 @@ static void rose_loopback_timer(struct timer_list *unused)
 		}
 
 		if (frametype == ROSE_CALL_REQUEST) {
-			if (!rose_loopback_neigh->dev) {
+			if (!rose_loopback_neigh->dev &&
+			    !rose_loopback_neigh->loopback) {
 				kfree_skb(skb);
 				continue;
 			}
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 25c9a2cbf048..d674d90e7031 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -285,8 +285,10 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 	_enter("%p,%lx", rx, p->user_call_ID);
 
 	limiter = rxrpc_get_call_slot(p, gfp);
-	if (!limiter)
+	if (!limiter) {
+		release_sock(&rx->sk);
 		return ERR_PTR(-ERESTARTSYS);
+	}
 
 	call = rxrpc_alloc_client_call(rx, srx, gfp, debug_id);
 	if (IS_ERR(call)) {
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 1d38e279e2ef..3c3a626459de 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -51,10 +51,7 @@ static int rxrpc_wait_for_tx_window_intr(struct rxrpc_sock *rx,
 			return sock_intr_errno(*timeo);
 
 		trace_rxrpc_transmit(call, rxrpc_transmit_wait);
-		mutex_unlock(&call->user_mutex);
 		*timeo = schedule_timeout(*timeo);
-		if (mutex_lock_interruptible(&call->user_mutex) < 0)
-			return sock_intr_errno(*timeo);
 	}
 }
 
@@ -290,37 +287,48 @@ static int rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
 static int rxrpc_send_data(struct rxrpc_sock *rx,
 			   struct rxrpc_call *call,
 			   struct msghdr *msg, size_t len,
-			   rxrpc_notify_end_tx_t notify_end_tx)
+			   rxrpc_notify_end_tx_t notify_end_tx,
+			   bool *_dropped_lock)
 {
 	struct rxrpc_skb_priv *sp;
 	struct sk_buff *skb;
 	struct sock *sk = &rx->sk;
+	enum rxrpc_call_state state;
 	long timeo;
-	bool more;
-	int ret, copied;
+	bool more = msg->msg_flags & MSG_MORE;
+	int ret, copied = 0;
 
 	timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 
 	/* this should be in poll */
 	sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
 
+reload:
+	ret = -EPIPE;
 	if (sk->sk_shutdown & SEND_SHUTDOWN)
-		return -EPIPE;
-
-	more = msg->msg_flags & MSG_MORE;
-
+		goto maybe_error;
+	state = READ_ONCE(call->state);
+	ret = -ESHUTDOWN;
+	if (state >= RXRPC_CALL_COMPLETE)
+		goto maybe_error;
+	ret = -EPROTO;
+	if (state != RXRPC_CALL_CLIENT_SEND_REQUEST &&
+	    state != RXRPC_CALL_SERVER_ACK_REQUEST &&
+	    state != RXRPC_CALL_SERVER_SEND_REPLY)
+		goto maybe_error;
+
+	ret = -EMSGSIZE;
 	if (call->tx_total_len != -1) {
-		if (len > call->tx_total_len)
-			return -EMSGSIZE;
-		if (!more && len != call->tx_total_len)
-			return -EMSGSIZE;
+		if (len - copied > call->tx_total_len)
+			goto maybe_error;
+		if (!more && len - copied != call->tx_total_len)
+			goto maybe_error;
 	}
 
 	skb = call->tx_pending;
 	call->tx_pending = NULL;
 	rxrpc_see_skb(skb, rxrpc_skb_seen);
 
-	copied = 0;
 	do {
 		/* Check to see if there's a ping ACK to reply to. */
 		if (call->ackr_reason == RXRPC_ACK_PING_RESPONSE)
@@ -331,16 +339,8 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 
 			_debug("alloc");
 
-			if (!rxrpc_check_tx_space(call, NULL)) {
-				ret = -EAGAIN;
-				if (msg->msg_flags & MSG_DONTWAIT)
-					goto maybe_error;
-				ret = rxrpc_wait_for_tx_window(rx, call,
-							       &timeo,
-							       msg->msg_flags & MSG_WAITALL);
-				if (ret < 0)
-					goto maybe_error;
-			}
+			if (!rxrpc_check_tx_space(call, NULL))
+				goto wait_for_space;
 
 			/* Work out the maximum size of a packet.  Assume that
 			 * the security header is going to be in the padded
@@ -468,6 +468,27 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 efault:
 	ret = -EFAULT;
 	goto out;
+
+wait_for_space:
+	ret = -EAGAIN;
+	if (msg->msg_flags & MSG_DONTWAIT)
+		goto maybe_error;
+	mutex_unlock(&call->user_mutex);
+	*_dropped_lock = true;
+	ret = rxrpc_wait_for_tx_window(rx, call, &timeo,
+				       msg->msg_flags & MSG_WAITALL);
+	if (ret < 0)
+		goto maybe_error;
+	if (call->interruptibility == RXRPC_INTERRUPTIBLE) {
+		if (mutex_lock_interruptible(&call->user_mutex) < 0) {
+			ret = sock_intr_errno(timeo);
+			goto maybe_error;
+		}
+	} else {
+		mutex_lock(&call->user_mutex);
+	}
+	*_dropped_lock = false;
+	goto reload;
 }
 
 /*
@@ -629,6 +650,7 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 	enum rxrpc_call_state state;
 	struct rxrpc_call *call;
 	unsigned long now, j;
+	bool dropped_lock = false;
 	int ret;
 
 	struct rxrpc_send_params p = {
@@ -737,21 +759,13 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 			ret = rxrpc_send_abort_packet(call);
 	} else if (p.command != RXRPC_CMD_SEND_DATA) {
 		ret = -EINVAL;
-	} else if (rxrpc_is_client_call(call) &&
-		   state != RXRPC_CALL_CLIENT_SEND_REQUEST) {
-		/* request phase complete for this client call */
-		ret = -EPROTO;
-	} else if (rxrpc_is_service_call(call) &&
-		   state != RXRPC_CALL_SERVER_ACK_REQUEST &&
-		   state != RXRPC_CALL_SERVER_SEND_REPLY) {
-		/* Reply phase not begun or not complete for service call. */
-		ret = -EPROTO;
 	} else {
-		ret = rxrpc_send_data(rx, call, msg, len, NULL);
+		ret = rxrpc_send_data(rx, call, msg, len, NULL, &dropped_lock);
 	}
 
 out_put_unlock:
-	mutex_unlock(&call->user_mutex);
+	if (!dropped_lock)
+		mutex_unlock(&call->user_mutex);
 error_put:
 	rxrpc_put_call(call, rxrpc_call_put);
 	_leave(" = %d", ret);
@@ -779,6 +793,7 @@ int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
 			   struct msghdr *msg, size_t len,
 			   rxrpc_notify_end_tx_t notify_end_tx)
 {
+	bool dropped_lock = false;
 	int ret;
 
 	_enter("{%d,%s},", call->debug_id, rxrpc_call_states[call->state]);
@@ -796,7 +811,7 @@ int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
 	case RXRPC_CALL_SERVER_ACK_REQUEST:
 	case RXRPC_CALL_SERVER_SEND_REPLY:
 		ret = rxrpc_send_data(rxrpc_sk(sock->sk), call, msg, len,
-				      notify_end_tx);
+				      notify_end_tx, &dropped_lock);
 		break;
 	case RXRPC_CALL_COMPLETE:
 		read_lock_bh(&call->state_lock);
@@ -810,7 +825,8 @@ int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
 		break;
 	}
 
-	mutex_unlock(&call->user_mutex);
+	if (!dropped_lock)
+		mutex_unlock(&call->user_mutex);
 	_leave(" = %d", ret);
 	return ret;
 }
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 30c29a9a2efd..250d87d993cb 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -409,7 +409,7 @@ static inline bool qdisc_restart(struct Qdisc *q, int *packets)
 
 void __qdisc_run(struct Qdisc *q)
 {
-	int quota = dev_tx_weight;
+	int quota = READ_ONCE(dev_tx_weight);
 	int packets;
 
 	while (qdisc_restart(q, &packets)) {
diff --git a/net/socket.c b/net/socket.c
index 5053eb0100e4..73666b878f2c 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1721,7 +1721,7 @@ int __sys_listen(int fd, int backlog)
 
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (sock) {
-		somaxconn = sock_net(sock->sk)->core.sysctl_somaxconn;
+		somaxconn = READ_ONCE(sock_net(sock->sk)->core.sysctl_somaxconn);
 		if ((unsigned int)backlog > somaxconn)
 			backlog = somaxconn;
 
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 6a035e9339d2..ca2a494d727b 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1881,7 +1881,7 @@ call_encode(struct rpc_task *task)
 			break;
 		case -EKEYEXPIRED:
 			if (!task->tk_cred_retry) {
-				rpc_exit(task, task->tk_status);
+				rpc_call_rpcerror(task, task->tk_status);
 			} else {
 				task->tk_action = call_refresh;
 				task->tk_cred_retry--;
diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index 1f08ebf7d80c..24ca49ecebea 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -170,7 +170,7 @@ int espintcp_queue_out(struct sock *sk, struct sk_buff *skb)
 {
 	struct espintcp_ctx *ctx = espintcp_getctx(sk);
 
-	if (skb_queue_len(&ctx->out_queue) >= netdev_max_backlog)
+	if (skb_queue_len(&ctx->out_queue) >= READ_ONCE(netdev_max_backlog))
 		return -ENOBUFS;
 
 	__skb_queue_tail(&ctx->out_queue, skb);
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 3df0861d4390..5f34bc378fdc 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -782,7 +782,7 @@ int xfrm_trans_queue_net(struct net *net, struct sk_buff *skb,
 
 	trans = this_cpu_ptr(&xfrm_trans_tasklet);
 
-	if (skb_queue_len(&trans->queue) >= netdev_max_backlog)
+	if (skb_queue_len(&trans->queue) >= READ_ONCE(netdev_max_backlog))
 		return -ENOBUFS;
 
 	BUILD_BUG_ON(sizeof(struct xfrm_trans_cb) > sizeof(skb->cb));
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index fb198f9490a0..ba58b963f482 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3162,7 +3162,7 @@ struct dst_entry *xfrm_lookup_with_ifid(struct net *net,
 	return dst;
 
 nopol:
-	if (!(dst_orig->dev->flags & IFF_LOOPBACK) &&
+	if ((!dst_orig->dev || !(dst_orig->dev->flags & IFF_LOOPBACK)) &&
 	    net->xfrm.policy_default[dir] == XFRM_USERPOLICY_BLOCK) {
 		err = -EPERM;
 		goto error;
@@ -3600,6 +3600,7 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		if (pols[1]) {
 			if (IS_ERR(pols[1])) {
 				XFRM_INC_STATS(net, LINUX_MIB_XFRMINPOLERROR);
+				xfrm_pol_put(pols[0]);
 				return 0;
 			}
 			pols[1]->curlft.use_time = ktime_get_real_seconds();
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index b1a04a22166f..15132b080614 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1591,6 +1591,7 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 	x->replay = orig->replay;
 	x->preplay = orig->preplay;
 	x->mapping_maxage = orig->mapping_maxage;
+	x->lastused = orig->lastused;
 	x->new_mapping = 0;
 	x->new_mapping_sport = 0;
 
diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index 1afc67047420..35e1f2a52435 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -263,7 +263,7 @@ endif
 # defined. get-executable-or-default fails with an error if the first argument is supplied but
 # doesn't exist.
 override PYTHON_CONFIG := $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON_AUTO))
-override PYTHON := $(call get-executable-or-default,PYTHON,$(subst -config,,$(PYTHON_AUTO)))
+override PYTHON := $(call get-executable-or-default,PYTHON,$(subst -config,,$(PYTHON_CONFIG)))
 
 grep-libs  = $(filter -l%,$(1))
 strip-libs  = $(filter-out -l%,$(1))
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 1a194edb5452..abf88a1ad455 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -807,6 +807,7 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 		return -1;
 
 	evlist__for_each_entry(evsel_list, counter) {
+		counter->reset_group = false;
 		if (bpf_counter__load(counter, &target))
 			return -1;
 		if (!evsel__is_bpf(counter))
