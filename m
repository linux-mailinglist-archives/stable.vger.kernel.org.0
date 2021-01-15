Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3232F7AE9
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732451AbhAOMeV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:34:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:41160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387460AbhAOMeS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:34:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C635923403;
        Fri, 15 Jan 2021 12:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714017;
        bh=9rfeQFWDLHpk0C5kvAXsSj+fHByNXU8h1esp9GMVos4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJilnvETzTR6t/cGoOdvtTLo0x5CAD0BRgjH0fHICycRGEH2MCAGqHzV65p3XZZsb
         MKqlhyyr66BMWmaScNXFuRN2xTIeKydT3pP/AWLLLKtUt7dle1Dl1Vwx81cCPyNEw9
         tREKzvsiJT8zSJfgca4o49kRXAmdnHX1Kc5CLz10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Len Brown <len.brown@intel.com>, linux-arch@vger.kernel.org,
        linux-pm@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Pingfan Liu <kernelfans@gmail.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        xen-devel@lists.xenproject.org, Sasha Levin <sashal@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 01/62] x86/asm/32: Add ENDs to some functions and relabel with SYM_CODE_*
Date:   Fri, 15 Jan 2021 13:27:23 +0100
Message-Id: <20210115121958.466877482@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121958.391610178@linuxfoundation.org>
References: <20210115121958.391610178@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

commit 78762b0e79bc1dd01347be061abdf505202152c9 upstream.

All these are functions which are invoked from elsewhere but they are
not typical C functions. So annotate them using the new SYM_CODE_START.
All these were not balanced with any END, so mark their ends by
SYM_CODE_END, appropriately.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com> [xen bits]
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com> [hibernate]
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Len Brown <len.brown@intel.com>
Cc: linux-arch@vger.kernel.org
Cc: linux-pm@vger.kernel.org
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Pingfan Liu <kernelfans@gmail.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>
Cc: xen-devel@lists.xenproject.org
Link: https://lkml.kernel.org/r/20191011115108.12392-26-jslaby@suse.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/entry_32.S            | 3 ++-
 arch/x86/kernel/acpi/wakeup_32.S     | 7 ++++---
 arch/x86/kernel/ftrace_32.S          | 3 ++-
 arch/x86/kernel/head_32.S            | 3 ++-
 arch/x86/power/hibernate_asm_32.S    | 6 ++++--
 arch/x86/realmode/rm/trampoline_32.S | 6 ++++--
 arch/x86/xen/xen-asm_32.S            | 7 ++++---
 7 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 390edb7638265..bde3e0f85425f 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -869,9 +869,10 @@ GLOBAL(__begin_SYSENTER_singlestep_region)
  * Xen doesn't set %esp to be precisely what the normal SYSENTER
  * entry point expects, so fix it up before using the normal path.
  */
-ENTRY(xen_sysenter_target)
+SYM_CODE_START(xen_sysenter_target)
 	addl	$5*4, %esp			/* remove xen-provided frame */
 	jmp	.Lsysenter_past_esp
+SYM_CODE_END(xen_sysenter_target)
 #endif
 
 /*
diff --git a/arch/x86/kernel/acpi/wakeup_32.S b/arch/x86/kernel/acpi/wakeup_32.S
index e95e95960156b..5b076cb79f5fb 100644
--- a/arch/x86/kernel/acpi/wakeup_32.S
+++ b/arch/x86/kernel/acpi/wakeup_32.S
@@ -9,8 +9,7 @@
 	.code32
 	ALIGN
 
-ENTRY(wakeup_pmode_return)
-wakeup_pmode_return:
+SYM_CODE_START(wakeup_pmode_return)
 	movw	$__KERNEL_DS, %ax
 	movw	%ax, %ss
 	movw	%ax, %fs
@@ -39,6 +38,7 @@ wakeup_pmode_return:
 	# jump to place where we left off
 	movl	saved_eip, %eax
 	jmp	*%eax
+SYM_CODE_END(wakeup_pmode_return)
 
 bogus_magic:
 	jmp	bogus_magic
@@ -72,7 +72,7 @@ restore_registers:
 	popfl
 	ret
 
-ENTRY(do_suspend_lowlevel)
+SYM_CODE_START(do_suspend_lowlevel)
 	call	save_processor_state
 	call	save_registers
 	pushl	$3
@@ -87,6 +87,7 @@ ret_point:
 	call	restore_registers
 	call	restore_processor_state
 	ret
+SYM_CODE_END(do_suspend_lowlevel)
 
 .data
 ALIGN
diff --git a/arch/x86/kernel/ftrace_32.S b/arch/x86/kernel/ftrace_32.S
index 073aab525d800..2cc0303522c99 100644
--- a/arch/x86/kernel/ftrace_32.S
+++ b/arch/x86/kernel/ftrace_32.S
@@ -89,7 +89,7 @@ WEAK(ftrace_stub)
 	ret
 END(ftrace_caller)
 
-ENTRY(ftrace_regs_caller)
+SYM_CODE_START(ftrace_regs_caller)
 	/*
 	 * We're here from an mcount/fentry CALL, and the stack frame looks like:
 	 *
@@ -163,6 +163,7 @@ GLOBAL(ftrace_regs_call)
 	popl	%eax
 
 	jmp	.Lftrace_ret
+SYM_CODE_END(ftrace_regs_caller)
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 ENTRY(ftrace_graph_caller)
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 2e6a0676c1f43..11a5d5ade52ce 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -64,7 +64,7 @@ RESERVE_BRK(pagetables, INIT_MAP_SIZE)
  * can.
  */
 __HEAD
-ENTRY(startup_32)
+SYM_CODE_START(startup_32)
 	movl pa(initial_stack),%ecx
 	
 	/* test KEEP_SEGMENTS flag to see if the bootloader is asking
@@ -172,6 +172,7 @@ num_subarch_entries = (. - subarch_entries) / 4
 #else
 	jmp .Ldefault_entry
 #endif /* CONFIG_PARAVIRT */
+SYM_CODE_END(startup_32)
 
 #ifdef CONFIG_HOTPLUG_CPU
 /*
diff --git a/arch/x86/power/hibernate_asm_32.S b/arch/x86/power/hibernate_asm_32.S
index 6fe383002125f..a19ed3d231853 100644
--- a/arch/x86/power/hibernate_asm_32.S
+++ b/arch/x86/power/hibernate_asm_32.S
@@ -35,7 +35,7 @@ ENTRY(swsusp_arch_suspend)
 	ret
 ENDPROC(swsusp_arch_suspend)
 
-ENTRY(restore_image)
+SYM_CODE_START(restore_image)
 	/* prepare to jump to the image kernel */
 	movl	restore_jump_address, %ebx
 	movl	restore_cr3, %ebp
@@ -45,9 +45,10 @@ ENTRY(restore_image)
 	/* jump to relocated restore code */
 	movl	relocated_restore_code, %eax
 	jmpl	*%eax
+SYM_CODE_END(restore_image)
 
 /* code below has been relocated to a safe page */
-ENTRY(core_restore_code)
+SYM_CODE_START(core_restore_code)
 	movl	temp_pgt, %eax
 	movl	%eax, %cr3
 
@@ -77,6 +78,7 @@ copy_loop:
 
 done:
 	jmpl	*%ebx
+SYM_CODE_END(core_restore_code)
 
 	/* code below belongs to the image kernel */
 	.align PAGE_SIZE
diff --git a/arch/x86/realmode/rm/trampoline_32.S b/arch/x86/realmode/rm/trampoline_32.S
index 1868b158480d4..3a0ef0d577344 100644
--- a/arch/x86/realmode/rm/trampoline_32.S
+++ b/arch/x86/realmode/rm/trampoline_32.S
@@ -29,7 +29,7 @@
 	.code16
 
 	.balign	PAGE_SIZE
-ENTRY(trampoline_start)
+SYM_CODE_START(trampoline_start)
 	wbinvd			# Needed for NUMA-Q should be harmless for others
 
 	LJMPW_RM(1f)
@@ -54,11 +54,13 @@ ENTRY(trampoline_start)
 	lmsw	%dx			# into protected mode
 
 	ljmpl	$__BOOT_CS, $pa_startup_32
+SYM_CODE_END(trampoline_start)
 
 	.section ".text32","ax"
 	.code32
-ENTRY(startup_32)			# note: also used from wakeup_asm.S
+SYM_CODE_START(startup_32)			# note: also used from wakeup_asm.S
 	jmp	*%eax
+SYM_CODE_END(startup_32)
 
 	.bss
 	.balign 8
diff --git a/arch/x86/xen/xen-asm_32.S b/arch/x86/xen/xen-asm_32.S
index cd177772fe4d5..2712e91553063 100644
--- a/arch/x86/xen/xen-asm_32.S
+++ b/arch/x86/xen/xen-asm_32.S
@@ -56,7 +56,7 @@
 	_ASM_EXTABLE(1b,2b)
 .endm
 
-ENTRY(xen_iret)
+SYM_CODE_START(xen_iret)
 	/* test eflags for special cases */
 	testl $(X86_EFLAGS_VM | XEN_EFLAGS_NMI), 8(%esp)
 	jnz hyper_iret
@@ -122,6 +122,7 @@ xen_iret_end_crit:
 hyper_iret:
 	/* put this out of line since its very rarely used */
 	jmp hypercall_page + __HYPERVISOR_iret * 32
+SYM_CODE_END(xen_iret)
 
 	.globl xen_iret_start_crit, xen_iret_end_crit
 
@@ -152,7 +153,7 @@ hyper_iret:
  * The only caveat is that if the outer eax hasn't been restored yet (i.e.
  * it's still on stack), we need to restore its value here.
  */
-ENTRY(xen_iret_crit_fixup)
+SYM_CODE_START(xen_iret_crit_fixup)
 	/*
 	 * Paranoia: Make sure we're really coming from kernel space.
 	 * One could imagine a case where userspace jumps into the
@@ -179,4 +180,4 @@ ENTRY(xen_iret_crit_fixup)
 
 2:
 	ret
-END(xen_iret_crit_fixup)
+SYM_CODE_END(xen_iret_crit_fixup)
-- 
2.27.0



