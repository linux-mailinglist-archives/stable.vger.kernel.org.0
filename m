Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8528469D0A
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347663AbhLFP2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:28:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41162 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357449AbhLFPWw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:22:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C675D61328;
        Mon,  6 Dec 2021 15:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5DAC341C1;
        Mon,  6 Dec 2021 15:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803962;
        bh=FHTR3z1hlCCiVEUTl7xPnMXARCbSoWM21Zct1CLhgH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GY5pSbUep9mlmOBXpfnHVCulRhYFkWWoQMuMby9LE/I/CzqDM9GXFCWzI9vA32Jgg
         DqaCxrLReO8pDlZkxeYXLMyQzUxRVLbl94yye1NurrZIh7yfwJ8LmbDkIOMIi2mQqY
         sQYtzzNJQxUGLydf5hJ0l4HxsQwgp2oD5dn6tiUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/130] x86/pv: Switch SWAPGS to ALTERNATIVE
Date:   Mon,  6 Dec 2021 15:57:06 +0100
Message-Id: <20211206145603.405037300@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 53c9d9240944088274aadbbbafc6138ca462db4f ]

SWAPGS is used only for interrupts coming from user mode or for
returning to user mode. So there is no reason to use the PARAVIRT
framework, as it can easily be replaced by an ALTERNATIVE depending
on X86_FEATURE_XENPV.

There are several instances using the PV-aware SWAPGS macro in paths
which are never executed in a Xen PV guest. Replace those with the
plain swapgs instruction. For SWAPGS_UNSAFE_STACK the same applies.

Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Andy Lutomirski <luto@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210120135555.32594-5-jgross@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/entry_64.S             | 10 +++++-----
 arch/x86/include/asm/irqflags.h       | 20 ++++++++------------
 arch/x86/include/asm/paravirt.h       | 20 --------------------
 arch/x86/include/asm/paravirt_types.h |  2 --
 arch/x86/kernel/asm-offsets_64.c      |  1 -
 arch/x86/kernel/paravirt.c            |  1 -
 arch/x86/kernel/paravirt_patch.c      |  3 ---
 arch/x86/xen/enlighten_pv.c           |  3 ---
 8 files changed, 13 insertions(+), 47 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index de541ea2788eb..166554a109aeb 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -673,7 +673,7 @@ native_irq_return_ldt:
 	 */
 
 	pushq	%rdi				/* Stash user RDI */
-	SWAPGS					/* to kernel GS */
+	swapgs					/* to kernel GS */
 	SWITCH_TO_KERNEL_CR3 scratch_reg=%rdi	/* to kernel CR3 */
 
 	movq	PER_CPU_VAR(espfix_waddr), %rdi
@@ -703,7 +703,7 @@ native_irq_return_ldt:
 	orq	PER_CPU_VAR(espfix_stack), %rax
 
 	SWITCH_TO_USER_CR3_STACK scratch_reg=%rdi
-	SWAPGS					/* to user GS */
+	swapgs					/* to user GS */
 	popq	%rdi				/* Restore user RDI */
 
 	movq	%rax, %rsp
@@ -947,7 +947,7 @@ SYM_CODE_START_LOCAL(paranoid_entry)
 	ret
 
 .Lparanoid_entry_swapgs:
-	SWAPGS
+	swapgs
 
 	/*
 	 * The above SAVE_AND_SWITCH_TO_KERNEL_CR3 macro doesn't do an
@@ -1005,7 +1005,7 @@ SYM_CODE_START_LOCAL(paranoid_exit)
 	jnz		restore_regs_and_return_to_kernel
 
 	/* We are returning to a context with user GSBASE */
-	SWAPGS_UNSAFE_STACK
+	swapgs
 	jmp		restore_regs_and_return_to_kernel
 SYM_CODE_END(paranoid_exit)
 
@@ -1431,7 +1431,7 @@ nmi_no_fsgsbase:
 	jnz	nmi_restore
 
 nmi_swapgs:
-	SWAPGS_UNSAFE_STACK
+	swapgs
 
 nmi_restore:
 	POP_REGS
diff --git a/arch/x86/include/asm/irqflags.h b/arch/x86/include/asm/irqflags.h
index 2dfc8d380dab1..8c86edefa1150 100644
--- a/arch/x86/include/asm/irqflags.h
+++ b/arch/x86/include/asm/irqflags.h
@@ -131,18 +131,6 @@ static __always_inline unsigned long arch_local_irq_save(void)
 #define SAVE_FLAGS(x)		pushfq; popq %rax
 #endif
 
-#define SWAPGS	swapgs
-/*
- * Currently paravirt can't handle swapgs nicely when we
- * don't have a stack we can rely on (such as a user space
- * stack).  So we either find a way around these or just fault
- * and emulate if a guest tries to call swapgs directly.
- *
- * Either way, this is a good way to document that we don't
- * have a reliable stack. x86_64 only.
- */
-#define SWAPGS_UNSAFE_STACK	swapgs
-
 #define INTERRUPT_RETURN	jmp native_iret
 #define USERGS_SYSRET64				\
 	swapgs;					\
@@ -170,6 +158,14 @@ static __always_inline int arch_irqs_disabled(void)
 
 	return arch_irqs_disabled_flags(flags);
 }
+#else
+#ifdef CONFIG_X86_64
+#ifdef CONFIG_XEN_PV
+#define SWAPGS	ALTERNATIVE "swapgs", "", X86_FEATURE_XENPV
+#else
+#define SWAPGS	swapgs
+#endif
+#endif
 #endif /* !__ASSEMBLY__ */
 
 #endif
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index d25cc6830e895..5647bcdba776e 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -776,26 +776,6 @@ extern void default_banner(void);
 
 #ifdef CONFIG_X86_64
 #ifdef CONFIG_PARAVIRT_XXL
-/*
- * If swapgs is used while the userspace stack is still current,
- * there's no way to call a pvop.  The PV replacement *must* be
- * inlined, or the swapgs instruction must be trapped and emulated.
- */
-#define SWAPGS_UNSAFE_STACK						\
-	PARA_SITE(PARA_PATCH(PV_CPU_swapgs), swapgs)
-
-/*
- * Note: swapgs is very special, and in practise is either going to be
- * implemented with a single "swapgs" instruction or something very
- * special.  Either way, we don't need to save any registers for
- * it.
- */
-#define SWAPGS								\
-	PARA_SITE(PARA_PATCH(PV_CPU_swapgs),				\
-		  ANNOTATE_RETPOLINE_SAFE;				\
-		  call PARA_INDIRECT(pv_ops+PV_CPU_swapgs);		\
-		 )
-
 #define USERGS_SYSRET64							\
 	PARA_SITE(PARA_PATCH(PV_CPU_usergs_sysret64),			\
 		  ANNOTATE_RETPOLINE_SAFE;				\
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 0fad9f61c76ab..903d71884fa25 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -169,8 +169,6 @@ struct pv_cpu_ops {
 	   frame set up. */
 	void (*iret)(void);
 
-	void (*swapgs)(void);
-
 	void (*start_context_switch)(struct task_struct *prev);
 	void (*end_context_switch)(struct task_struct *next);
 #endif
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index 828be792231e9..1354bc30614d7 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -15,7 +15,6 @@ int main(void)
 #ifdef CONFIG_PARAVIRT_XXL
 	OFFSET(PV_CPU_usergs_sysret64, paravirt_patch_template,
 	       cpu.usergs_sysret64);
-	OFFSET(PV_CPU_swapgs, paravirt_patch_template, cpu.swapgs);
 #ifdef CONFIG_DEBUG_ENTRY
 	OFFSET(PV_IRQ_save_fl, paravirt_patch_template, irq.save_fl);
 #endif
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 6c3407ba6ee98..5e5fcf5c376de 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -312,7 +312,6 @@ struct paravirt_patch_template pv_ops = {
 
 	.cpu.usergs_sysret64	= native_usergs_sysret64,
 	.cpu.iret		= native_iret,
-	.cpu.swapgs		= native_swapgs,
 
 #ifdef CONFIG_X86_IOPL_IOPERM
 	.cpu.invalidate_io_bitmap	= native_tss_invalidate_io_bitmap,
diff --git a/arch/x86/kernel/paravirt_patch.c b/arch/x86/kernel/paravirt_patch.c
index ace6e334cb393..7c518b08aa3c5 100644
--- a/arch/x86/kernel/paravirt_patch.c
+++ b/arch/x86/kernel/paravirt_patch.c
@@ -28,7 +28,6 @@ struct patch_xxl {
 	const unsigned char	irq_restore_fl[2];
 	const unsigned char	cpu_wbinvd[2];
 	const unsigned char	cpu_usergs_sysret64[6];
-	const unsigned char	cpu_swapgs[3];
 	const unsigned char	mov64[3];
 };
 
@@ -43,7 +42,6 @@ static const struct patch_xxl patch_data_xxl = {
 	.cpu_wbinvd		= { 0x0f, 0x09 },	// wbinvd
 	.cpu_usergs_sysret64	= { 0x0f, 0x01, 0xf8,
 				    0x48, 0x0f, 0x07 },	// swapgs; sysretq
-	.cpu_swapgs		= { 0x0f, 0x01, 0xf8 },	// swapgs
 	.mov64			= { 0x48, 0x89, 0xf8 },	// mov %rdi, %rax
 };
 
@@ -86,7 +84,6 @@ unsigned int native_patch(u8 type, void *insn_buff, unsigned long addr,
 	PATCH_CASE(mmu, write_cr3, xxl, insn_buff, len);
 
 	PATCH_CASE(cpu, usergs_sysret64, xxl, insn_buff, len);
-	PATCH_CASE(cpu, swapgs, xxl, insn_buff, len);
 	PATCH_CASE(cpu, wbinvd, xxl, insn_buff, len);
 #endif
 
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 5af0421ef74ba..16ff25d6935e7 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1083,9 +1083,6 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
 #endif
 	.io_delay = xen_io_delay,
 
-	/* Xen takes care of %gs when switching to usermode for us */
-	.swapgs = paravirt_nop,
-
 	.start_context_switch = paravirt_start_context_switch,
 	.end_context_switch = xen_end_context_switch,
 };
-- 
2.33.0



