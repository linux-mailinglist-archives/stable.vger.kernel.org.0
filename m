Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08E0810B992
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbfK0Uyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:54:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730872AbfK0Uys (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:54:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CD752084D;
        Wed, 27 Nov 2019 20:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888088;
        bh=hDH1Zy9U8JZXie6eLY52qgw5hOopUU4/RMvVlThUVIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fQKTieS10sYweQsy01UjUydpWWjHvJ/U7luBsG0MY3HoXegG47GxWFJkIrpRvyDnr
         hGijMeGRNi34PEFTdG9LgFXOZ3959UabUkHHaEmVp9TDdsQIo/NQcWtV5dj1jASVvQ
         8MBB93DhtYc6OIdb/HlHWqQ8Prp5YybMranm0+us=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Daniel Axtens <dja@axtens.net>
Subject: [PATCH 4.14 210/211] KVM: PPC: Book3S HV: Flush link stack on guest exit to host kernel
Date:   Wed, 27 Nov 2019 21:32:23 +0100
Message-Id: <20191127203113.373131048@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit af2e8c68b9c5403f77096969c516f742f5bb29e0 upstream.

On some systems that are vulnerable to Spectre v2, it is up to
software to flush the link stack (return address stack), in order to
protect against Spectre-RSB.

When exiting from a guest we do some house keeping and then
potentially exit to C code which is several stack frames deep in the
host kernel. We will then execute a series of returns without
preceeding calls, opening up the possiblity that the guest could have
poisoned the link stack, and direct speculative execution of the host
to a gadget of some sort.

To prevent this we add a flush of the link stack on exit from a guest.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
[dja: straightforward backport to v4.14]
Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/asm-prototypes.h |    2 ++
 arch/powerpc/kernel/security.c            |    9 +++++++++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S   |   27 +++++++++++++++++++++++++++
 3 files changed, 38 insertions(+)

--- a/arch/powerpc/include/asm/asm-prototypes.h
+++ b/arch/powerpc/include/asm/asm-prototypes.h
@@ -130,7 +130,9 @@ unsigned long prepare_ftrace_return(unsi
 extern s32 patch__call_flush_count_cache;
 extern s32 patch__flush_count_cache_return;
 extern s32 patch__flush_link_stack_return;
+extern s32 patch__call_kvm_flush_link_stack;
 
 extern long flush_count_cache;
+extern long kvm_flush_link_stack;
 
 #endif /* _ASM_POWERPC_ASM_PROTOTYPES_H */
--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -392,6 +392,9 @@ static void toggle_count_cache_flush(boo
 
 	if (!enable) {
 		patch_instruction_site(&patch__call_flush_count_cache, PPC_INST_NOP);
+#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
+		patch_instruction_site(&patch__call_kvm_flush_link_stack, PPC_INST_NOP);
+#endif
 		pr_info("link-stack-flush: software flush disabled.\n");
 		link_stack_flush_enabled = false;
 		no_count_cache_flush();
@@ -402,6 +405,12 @@ static void toggle_count_cache_flush(boo
 	patch_branch_site(&patch__call_flush_count_cache,
 			  (u64)&flush_count_cache, BRANCH_SET_LINK);
 
+#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
+	// This enables the branch from guest_exit_cont to kvm_flush_link_stack
+	patch_branch_site(&patch__call_kvm_flush_link_stack,
+			  (u64)&kvm_flush_link_stack, BRANCH_SET_LINK);
+#endif
+
 	pr_info("link-stack-flush: software flush enabled.\n");
 	link_stack_flush_enabled = true;
 
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -18,6 +18,7 @@
  */
 
 #include <asm/ppc_asm.h>
+#include <asm/code-patching-asm.h>
 #include <asm/kvm_asm.h>
 #include <asm/reg.h>
 #include <asm/mmu.h>
@@ -1445,6 +1446,10 @@ mc_cont:
 1:
 #endif /* CONFIG_KVM_XICS */
 
+	/* Possibly flush the link stack here. */
+1:	nop
+	patch_site 1b patch__call_kvm_flush_link_stack
+
 	stw	r12, STACK_SLOT_TRAP(r1)
 	mr 	r3, r12
 	/* Increment exit count, poke other threads to exit */
@@ -1957,6 +1962,28 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_TYPE_R
 	mtlr	r0
 	blr
 
+.balign 32
+.global kvm_flush_link_stack
+kvm_flush_link_stack:
+	/* Save LR into r0 */
+	mflr	r0
+
+	/* Flush the link stack. On Power8 it's up to 32 entries in size. */
+	.rept 32
+	bl	.+4
+	.endr
+
+	/* And on Power9 it's up to 64. */
+BEGIN_FTR_SECTION
+	.rept 32
+	bl	.+4
+	.endr
+END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
+
+	/* Restore LR */
+	mtlr	r0
+	blr
+
 /*
  * Check whether an HDSI is an HPTE not found fault or something else.
  * If it is an HPTE not found fault that is due to the guest accessing


