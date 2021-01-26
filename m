Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5593033AF
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 06:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbhAZFDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:03:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:38156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729848AbhAYSv7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:51:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A102D224D1;
        Mon, 25 Jan 2021 18:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600698;
        bh=AAomyl85rXx114TCv58M6dyxkbPkueGS0A2a+lYRGp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sb9N0a5EVxnzJUZz17RKSKsCARXMdeYZxzTqAR4qrnt2l8sp4kPd2HrGknHGRN+hi
         seRiAhFjRBpAQSaGK7Mx97WNz5hFmMwjDezl2s7wlE9KQud2GxO1CJcYcTDdkqYoMO
         fDLbkrtzLliigTCsgKImZRp3baTl2FmDzLpV3JcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tulio Magno Quites Machado Filho <tuliom@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 116/199] powerpc/64s: fix scv entry fallback flush vs interrupt
Date:   Mon, 25 Jan 2021 19:38:58 +0100
Message-Id: <20210125183221.127953320@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit 08685be7761d69914f08c3d6211c543a385a5b9c upstream.

The L1D flush fallback functions are not recoverable vs interrupts,
yet the scv entry flush runs with MSR[EE]=1. This can result in a
timer (soft-NMI) or MCE or SRESET interrupt hitting here and overwriting
the EXRFI save area, which ends up corrupting userspace registers for
scv return.

Fix this by disabling RI and EE for the scv entry fallback flush.

Fixes: f79643787e0a0 ("powerpc/64s: flush L1D on kernel entry")
Cc: stable@vger.kernel.org # 5.9+ which also have flush L1D patch backport
Reported-by: Tulio Magno Quites Machado Filho <tuliom@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210111062408.287092-1-npiggin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/exception-64s.h  |   13 +++++++++++++
 arch/powerpc/include/asm/feature-fixups.h |   10 ++++++++++
 arch/powerpc/kernel/entry_64.S            |    2 +-
 arch/powerpc/kernel/exceptions-64s.S      |   19 +++++++++++++++++++
 arch/powerpc/kernel/vmlinux.lds.S         |    7 +++++++
 arch/powerpc/lib/feature-fixups.c         |   24 +++++++++++++++++++++---
 6 files changed, 71 insertions(+), 4 deletions(-)

--- a/arch/powerpc/include/asm/exception-64s.h
+++ b/arch/powerpc/include/asm/exception-64s.h
@@ -63,6 +63,12 @@
 	nop;								\
 	nop;
 
+#define SCV_ENTRY_FLUSH_SLOT						\
+	SCV_ENTRY_FLUSH_FIXUP_SECTION;					\
+	nop;								\
+	nop;								\
+	nop;
+
 /*
  * r10 must be free to use, r13 must be paca
  */
@@ -71,6 +77,13 @@
 	ENTRY_FLUSH_SLOT
 
 /*
+ * r10, ctr must be free to use, r13 must be paca
+ */
+#define SCV_INTERRUPT_TO_KERNEL						\
+	STF_ENTRY_BARRIER_SLOT;						\
+	SCV_ENTRY_FLUSH_SLOT
+
+/*
  * Macros for annotating the expected destination of (h)rfid
  *
  * The nop instructions allow us to insert one or more instructions to flush the
--- a/arch/powerpc/include/asm/feature-fixups.h
+++ b/arch/powerpc/include/asm/feature-fixups.h
@@ -221,6 +221,14 @@ label##3:					       	\
 	FTR_ENTRY_OFFSET 957b-958b;			\
 	.popsection;
 
+#define SCV_ENTRY_FLUSH_FIXUP_SECTION			\
+957:							\
+	.pushsection __scv_entry_flush_fixup,"a";	\
+	.align 2;					\
+958:							\
+	FTR_ENTRY_OFFSET 957b-958b;			\
+	.popsection;
+
 #define RFI_FLUSH_FIXUP_SECTION				\
 951:							\
 	.pushsection __rfi_flush_fixup,"a";		\
@@ -254,10 +262,12 @@ label##3:					       	\
 
 extern long stf_barrier_fallback;
 extern long entry_flush_fallback;
+extern long scv_entry_flush_fallback;
 extern long __start___stf_entry_barrier_fixup, __stop___stf_entry_barrier_fixup;
 extern long __start___stf_exit_barrier_fixup, __stop___stf_exit_barrier_fixup;
 extern long __start___uaccess_flush_fixup, __stop___uaccess_flush_fixup;
 extern long __start___entry_flush_fixup, __stop___entry_flush_fixup;
+extern long __start___scv_entry_flush_fixup, __stop___scv_entry_flush_fixup;
 extern long __start___rfi_flush_fixup, __stop___rfi_flush_fixup;
 extern long __start___barrier_nospec_fixup, __stop___barrier_nospec_fixup;
 extern long __start__btb_flush_fixup, __stop__btb_flush_fixup;
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -75,7 +75,7 @@ BEGIN_FTR_SECTION
 	bne	.Ltabort_syscall
 END_FTR_SECTION_IFSET(CPU_FTR_TM)
 #endif
-	INTERRUPT_TO_KERNEL
+	SCV_INTERRUPT_TO_KERNEL
 	mr	r10,r1
 	ld	r1,PACAKSAVE(r13)
 	std	r10,0(r1)
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -2993,6 +2993,25 @@ TRAMP_REAL_BEGIN(entry_flush_fallback)
 	ld	r11,PACA_EXRFI+EX_R11(r13)
 	blr
 
+/*
+ * The SCV entry flush happens with interrupts enabled, so it must disable
+ * to prevent EXRFI being clobbered by NMIs (e.g., soft_nmi_common). r10
+ * (containing LR) does not need to be preserved here because scv entry
+ * puts 0 in the pt_regs, CTR can be clobbered for the same reason.
+ */
+TRAMP_REAL_BEGIN(scv_entry_flush_fallback)
+	li	r10,0
+	mtmsrd	r10,1
+	lbz	r10,PACAIRQHAPPENED(r13)
+	ori	r10,r10,PACA_IRQ_HARD_DIS
+	stb	r10,PACAIRQHAPPENED(r13)
+	std	r11,PACA_EXRFI+EX_R11(r13)
+	L1D_DISPLACEMENT_FLUSH
+	ld	r11,PACA_EXRFI+EX_R11(r13)
+	li	r10,MSR_RI
+	mtmsrd	r10,1
+	blr
+
 TRAMP_REAL_BEGIN(rfi_flush_fallback)
 	SET_SCRATCH0(r13);
 	GET_PACA(r13);
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -146,6 +146,13 @@ SECTIONS
 	}
 
 	. = ALIGN(8);
+	__scv_entry_flush_fixup : AT(ADDR(__scv_entry_flush_fixup) - LOAD_OFFSET) {
+		__start___scv_entry_flush_fixup = .;
+		*(__scv_entry_flush_fixup)
+		__stop___scv_entry_flush_fixup = .;
+	}
+
+	. = ALIGN(8);
 	__stf_exit_barrier_fixup : AT(ADDR(__stf_exit_barrier_fixup) - LOAD_OFFSET) {
 		__start___stf_exit_barrier_fixup = .;
 		*(__stf_exit_barrier_fixup)
--- a/arch/powerpc/lib/feature-fixups.c
+++ b/arch/powerpc/lib/feature-fixups.c
@@ -290,9 +290,6 @@ void do_entry_flush_fixups(enum l1d_flus
 	long *start, *end;
 	int i;
 
-	start = PTRRELOC(&__start___entry_flush_fixup);
-	end = PTRRELOC(&__stop___entry_flush_fixup);
-
 	instrs[0] = 0x60000000; /* nop */
 	instrs[1] = 0x60000000; /* nop */
 	instrs[2] = 0x60000000; /* nop */
@@ -312,6 +309,8 @@ void do_entry_flush_fixups(enum l1d_flus
 	if (types & L1D_FLUSH_MTTRIG)
 		instrs[i++] = 0x7c12dba6; /* mtspr TRIG2,r0 (SPR #882) */
 
+	start = PTRRELOC(&__start___entry_flush_fixup);
+	end = PTRRELOC(&__stop___entry_flush_fixup);
 	for (i = 0; start < end; start++, i++) {
 		dest = (void *)start + *start;
 
@@ -328,6 +327,25 @@ void do_entry_flush_fixups(enum l1d_flus
 		patch_instruction((struct ppc_inst *)(dest + 2), ppc_inst(instrs[2]));
 	}
 
+	start = PTRRELOC(&__start___scv_entry_flush_fixup);
+	end = PTRRELOC(&__stop___scv_entry_flush_fixup);
+	for (; start < end; start++, i++) {
+		dest = (void *)start + *start;
+
+		pr_devel("patching dest %lx\n", (unsigned long)dest);
+
+		patch_instruction((struct ppc_inst *)dest, ppc_inst(instrs[0]));
+
+		if (types == L1D_FLUSH_FALLBACK)
+			patch_branch((struct ppc_inst *)(dest + 1), (unsigned long)&scv_entry_flush_fallback,
+				     BRANCH_SET_LINK);
+		else
+			patch_instruction((struct ppc_inst *)(dest + 1), ppc_inst(instrs[1]));
+
+		patch_instruction((struct ppc_inst *)(dest + 2), ppc_inst(instrs[2]));
+	}
+
+
 	printk(KERN_DEBUG "entry-flush: patched %d locations (%s flush)\n", i,
 		(types == L1D_FLUSH_NONE)       ? "no" :
 		(types == L1D_FLUSH_FALLBACK)   ? "fallback displacement" :


