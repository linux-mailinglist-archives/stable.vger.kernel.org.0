Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29E6A1D86ED
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbgERRkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:40:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729148AbgERRks (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:40:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 339EC20849;
        Mon, 18 May 2020 17:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823647;
        bh=IczQH/TtXU98bDp5k7ZWYNUFzCIb147wj2CPbCzb4QQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z385pTEQQSacawaL/uSVRTzNfOc0G2+xynwZg7FsekDAvr2Sc+YZRguAfVL4hqpjr
         UUoTS0oTi+UoQBF6kYFSLIO3dkr+/f9jGwISAGrzWD4xBTInvNGwV/McbM0nG/SUZ5
         AKoizO8pHE0Ow8OcLYkPw9u0Szx/CIyF989NwhGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Borislav Petkov <bp@alien8.de>,
        Brian Gerst <brgerst@gmail.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, david.vrabel@citrix.com,
        konrad.wilk@oracle.com, virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.4 67/86] x86/paravirt: Remove the unused irq_enable_sysexit pv op
Date:   Mon, 18 May 2020 19:36:38 +0200
Message-Id: <20200518173503.889676448@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
References: <20200518173450.254571947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Ostrovsky <boris.ostrovsky@oracle.com>

commit 88c15ec90ff16880efab92b519436ee17b198477 upstream.

As result of commit "x86/xen: Avoid fast syscall path for Xen PV
guests", the irq_enable_sysexit pv op is not called by Xen PV guests
anymore and since they were the only ones who used it we can
safely remove it.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Reviewed-by: Borislav Petkov <bp@suse.de>
Acked-by: Andy Lutomirski <luto@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: david.vrabel@citrix.com
Cc: konrad.wilk@oracle.com
Cc: virtualization@lists.linux-foundation.org
Cc: xen-devel@lists.xenproject.org
Link: http://lkml.kernel.org/r/1447970147-1733-3-git-send-email-boris.ostrovsky@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/entry/entry_32.S             |    8 ++------
 arch/x86/include/asm/paravirt.h       |    7 -------
 arch/x86/include/asm/paravirt_types.h |    9 ---------
 arch/x86/kernel/asm-offsets.c         |    3 ---
 arch/x86/kernel/paravirt.c            |    7 -------
 arch/x86/kernel/paravirt_patch_32.c   |    2 --
 arch/x86/kernel/paravirt_patch_64.c   |    1 -
 arch/x86/xen/enlighten.c              |    3 ---
 arch/x86/xen/xen-asm_32.S             |   14 --------------
 arch/x86/xen/xen-ops.h                |    3 ---
 10 files changed, 2 insertions(+), 55 deletions(-)

--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -331,7 +331,8 @@ sysenter_past_esp:
 	 * Return back to the vDSO, which will pop ecx and edx.
 	 * Don't bother with DS and ES (they already contain __USER_DS).
 	 */
-	ENABLE_INTERRUPTS_SYSEXIT
+	sti
+	sysexit
 
 .pushsection .fixup, "ax"
 2:	movl	$0, PT_FS(%esp)
@@ -554,11 +555,6 @@ ENTRY(native_iret)
 	iret
 	_ASM_EXTABLE(native_iret, iret_exc)
 END(native_iret)
-
-ENTRY(native_irq_enable_sysexit)
-	sti
-	sysexit
-END(native_irq_enable_sysexit)
 #endif
 
 ENTRY(overflow)
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -938,13 +938,6 @@ extern void default_banner(void);
 	push %ecx; push %edx;				\
 	call PARA_INDIRECT(pv_cpu_ops+PV_CPU_read_cr0);	\
 	pop %edx; pop %ecx
-
-#define ENABLE_INTERRUPTS_SYSEXIT					\
-	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_irq_enable_sysexit),	\
-		  CLBR_NONE,						\
-		  jmp PARA_INDIRECT(pv_cpu_ops+PV_CPU_irq_enable_sysexit))
-
-
 #else	/* !CONFIG_X86_32 */
 
 /*
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -162,15 +162,6 @@ struct pv_cpu_ops {
 
 	u64 (*read_pmc)(int counter);
 
-#ifdef CONFIG_X86_32
-	/*
-	 * Atomically enable interrupts and return to userspace.  This
-	 * is only used in 32-bit kernels.  64-bit kernels use
-	 * usergs_sysret32 instead.
-	 */
-	void (*irq_enable_sysexit)(void);
-#endif
-
 	/*
 	 * Switch to usermode gs and return to 64-bit usermode using
 	 * sysret.  Only used in 64-bit kernels to return to 64-bit
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -65,9 +65,6 @@ void common(void) {
 	OFFSET(PV_IRQ_irq_disable, pv_irq_ops, irq_disable);
 	OFFSET(PV_IRQ_irq_enable, pv_irq_ops, irq_enable);
 	OFFSET(PV_CPU_iret, pv_cpu_ops, iret);
-#ifdef CONFIG_X86_32
-	OFFSET(PV_CPU_irq_enable_sysexit, pv_cpu_ops, irq_enable_sysexit);
-#endif
 	OFFSET(PV_CPU_read_cr0, pv_cpu_ops, read_cr0);
 	OFFSET(PV_MMU_read_cr2, pv_mmu_ops, read_cr2);
 #endif
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -168,9 +168,6 @@ unsigned paravirt_patch_default(u8 type,
 		ret = paravirt_patch_ident_64(insnbuf, len);
 
 	else if (type == PARAVIRT_PATCH(pv_cpu_ops.iret) ||
-#ifdef CONFIG_X86_32
-		 type == PARAVIRT_PATCH(pv_cpu_ops.irq_enable_sysexit) ||
-#endif
 		 type == PARAVIRT_PATCH(pv_cpu_ops.usergs_sysret32) ||
 		 type == PARAVIRT_PATCH(pv_cpu_ops.usergs_sysret64))
 		/* If operation requires a jmp, then jmp */
@@ -226,7 +223,6 @@ static u64 native_steal_clock(int cpu)
 
 /* These are in entry.S */
 extern void native_iret(void);
-extern void native_irq_enable_sysexit(void);
 extern void native_usergs_sysret32(void);
 extern void native_usergs_sysret64(void);
 
@@ -385,9 +381,6 @@ __visible struct pv_cpu_ops pv_cpu_ops =
 
 	.load_sp0 = native_load_sp0,
 
-#if defined(CONFIG_X86_32)
-	.irq_enable_sysexit = native_irq_enable_sysexit,
-#endif
 #ifdef CONFIG_X86_64
 #ifdef CONFIG_IA32_EMULATION
 	.usergs_sysret32 = native_usergs_sysret32,
--- a/arch/x86/kernel/paravirt_patch_32.c
+++ b/arch/x86/kernel/paravirt_patch_32.c
@@ -5,7 +5,6 @@ DEF_NATIVE(pv_irq_ops, irq_enable, "sti"
 DEF_NATIVE(pv_irq_ops, restore_fl, "push %eax; popf");
 DEF_NATIVE(pv_irq_ops, save_fl, "pushf; pop %eax");
 DEF_NATIVE(pv_cpu_ops, iret, "iret");
-DEF_NATIVE(pv_cpu_ops, irq_enable_sysexit, "sti; sysexit");
 DEF_NATIVE(pv_mmu_ops, read_cr2, "mov %cr2, %eax");
 DEF_NATIVE(pv_mmu_ops, write_cr3, "mov %eax, %cr3");
 DEF_NATIVE(pv_mmu_ops, read_cr3, "mov %cr3, %eax");
@@ -46,7 +45,6 @@ unsigned native_patch(u8 type, u16 clobb
 		PATCH_SITE(pv_irq_ops, restore_fl);
 		PATCH_SITE(pv_irq_ops, save_fl);
 		PATCH_SITE(pv_cpu_ops, iret);
-		PATCH_SITE(pv_cpu_ops, irq_enable_sysexit);
 		PATCH_SITE(pv_mmu_ops, read_cr2);
 		PATCH_SITE(pv_mmu_ops, read_cr3);
 		PATCH_SITE(pv_mmu_ops, write_cr3);
--- a/arch/x86/kernel/paravirt_patch_64.c
+++ b/arch/x86/kernel/paravirt_patch_64.c
@@ -12,7 +12,6 @@ DEF_NATIVE(pv_mmu_ops, write_cr3, "movq
 DEF_NATIVE(pv_cpu_ops, clts, "clts");
 DEF_NATIVE(pv_cpu_ops, wbinvd, "wbinvd");
 
-DEF_NATIVE(pv_cpu_ops, irq_enable_sysexit, "swapgs; sti; sysexit");
 DEF_NATIVE(pv_cpu_ops, usergs_sysret64, "swapgs; sysretq");
 DEF_NATIVE(pv_cpu_ops, usergs_sysret32, "swapgs; sysretl");
 DEF_NATIVE(pv_cpu_ops, swapgs, "swapgs");
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1240,10 +1240,7 @@ static const struct pv_cpu_ops xen_cpu_o
 
 	.iret = xen_iret,
 #ifdef CONFIG_X86_64
-	.usergs_sysret32 = xen_sysret32,
 	.usergs_sysret64 = xen_sysret64,
-#else
-	.irq_enable_sysexit = xen_sysexit,
 #endif
 
 	.load_tr_desc = paravirt_nop,
--- a/arch/x86/xen/xen-asm_32.S
+++ b/arch/x86/xen/xen-asm_32.S
@@ -35,20 +35,6 @@ check_events:
 	ret
 
 /*
- * We can't use sysexit directly, because we're not running in ring0.
- * But we can easily fake it up using iret.  Assuming xen_sysexit is
- * jumped to with a standard stack frame, we can just strip it back to
- * a standard iret frame and use iret.
- */
-ENTRY(xen_sysexit)
-	movl PT_EAX(%esp), %eax			/* Shouldn't be necessary? */
-	orl $X86_EFLAGS_IF, PT_EFLAGS(%esp)
-	lea PT_EIP(%esp), %esp
-
-	jmp xen_iret
-ENDPROC(xen_sysexit)
-
-/*
  * This is run where a normal iret would be run, with the same stack setup:
  *	8: eflags
  *	4: cs
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -139,9 +139,6 @@ DECL_ASM(void, xen_restore_fl_direct, un
 
 /* These are not functions, and cannot be called normally */
 __visible void xen_iret(void);
-#ifdef CONFIG_X86_32
-__visible void xen_sysexit(void);
-#endif
 __visible void xen_sysret32(void);
 __visible void xen_sysret64(void);
 __visible void xen_adjust_exception_frame(void);


