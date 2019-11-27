Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4970210B80A
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbfK0UjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:39:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:43120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728043AbfK0UjI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:39:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B215321781;
        Wed, 27 Nov 2019 20:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887147;
        bh=KiNTpBqQjZufNQVSxZpZkenyg2xSVpIVaX9A/Vr/FdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NmPtAM1dC89GLpxHDJCTC7GwVpLVDnv9fe/1kbVNy5o1dC69x8rh+HCaCI17+22zR
         bJC0GIRx6spQuhwBB0fLjEA0t9FzIeSVabK9tQb0/e8sj9fDHJ7/eTWRE+sQ54P4+S
         m/gXsq6FTfFXwzmogWOoBtIgE0YOsEQAKw4OTfR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Daniel Axtens <dja@axtens.net>
Subject: [PATCH 4.4 132/132] KVM: PPC: Book3S HV: Flush link stack on guest exit to host kernel
Date:   Wed, 27 Nov 2019 21:32:03 +0100
Message-Id: <20191127203034.541297082@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
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
[dja: backport to v4.4, drop P9 support]
Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/asm-prototypes.h |    2 ++
 arch/powerpc/kernel/security.c            |    9 +++++++++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S   |   20 ++++++++++++++++++++
 3 files changed, 31 insertions(+)

--- a/arch/powerpc/include/asm/asm-prototypes.h
+++ b/arch/powerpc/include/asm/asm-prototypes.h
@@ -16,7 +16,9 @@
 extern s32 patch__call_flush_count_cache;
 extern s32 patch__flush_count_cache_return;
 extern s32 patch__flush_link_stack_return;
+extern s32 patch__call_kvm_flush_link_stack;
 
 extern long flush_count_cache;
+extern long kvm_flush_link_stack;
 
 #endif /* _ASM_POWERPC_ASM_PROTOTYPES_H */
--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -391,6 +391,9 @@ static void toggle_count_cache_flush(boo
 
 	if (!enable) {
 		patch_instruction_site(&patch__call_flush_count_cache, PPC_INST_NOP);
+#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
+		patch_instruction_site(&patch__call_kvm_flush_link_stack, PPC_INST_NOP);
+#endif
 		pr_info("link-stack-flush: software flush disabled.\n");
 		link_stack_flush_enabled = false;
 		no_count_cache_flush();
@@ -401,6 +404,12 @@ static void toggle_count_cache_flush(boo
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
@@ -1169,6 +1170,10 @@ mc_cont:
 	bl	kvmhv_accumulate_time
 #endif
 
+	/* Possibly flush the link stack here. */
+1:	nop
+	patch_site 1b patch__call_kvm_flush_link_stack
+
 	mr 	r3, r12
 	/* Increment exit count, poke other threads to exit */
 	bl	kvmhv_commence_exit
@@ -1564,6 +1569,21 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
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
+	/* Restore LR */
+	mtlr	r0
+	blr
+
 /*
  * Check whether an HDSI is an HPTE not found fault or something else.
  * If it is an HPTE not found fault that is due to the guest accessing


