Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07652627B48
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 12:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235617AbiKNK77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 05:59:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236415AbiKNK7z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 05:59:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5571E73C
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 02:59:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7522EB80DE3
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 10:59:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C1EC433C1;
        Mon, 14 Nov 2022 10:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668423591;
        bh=Y/DwtQD44zZHoWgu1jC+57eRxNJNVjVN3oO2R9ELAxE=;
        h=Subject:To:Cc:From:Date:From;
        b=K8LLew5RTptg/WWyL1RvGHDxLM0Sz8fd4QZ6iSkmnzC9nzPxUOC/zW0XZjFjAqleL
         p0hiLrO3L3sbqHROhynpOuBHemFDth8QSU/s85NOR7aN+NcDcNoth2syb2Im/MRSL+
         PsSf/9aPDE8yKbjJr1KV+6cnbk+ufGtMGpjWFahs=
Subject: FAILED: patch "[PATCH] KVM: SVM: adjust register allocation for __svm_vcpu_run()" failed to apply to 5.15-stable tree
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Nov 2022 11:59:43 +0100
Message-ID: <166842358320194@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

f7ef280132f9 ("KVM: SVM: adjust register allocation for __svm_vcpu_run()")
16fdc1de169e ("KVM: SVM: replace regs argument of __svm_vcpu_run() with vcpu_svm")
debc5a1ec0d1 ("KVM: x86: use a separate asm-offsets.c file")
bb06650634d3 ("KVM: VMX: Convert launched argument to flags")
8bd200d23ec4 ("KVM: VMX: Flatten __vmx_vcpu_run()")
527a534c7326 ("x86/tdx: Provide common base for SEAMCALL and TDCALL C wrappers")
59bd54a84d15 ("x86/tdx: Detect running as a TDX guest in early boot")
6198311093da ("x86/cc: Move arch/x86/{kernel/cc_platform.c => coco/core.c}")
f94909ceb1ed ("x86: Prepare asm files for straight-line-speculation")
22da5a07c75e ("x86/lib/atomic64_386_32: Rename things")
1367afaa2ee9 ("x86/entry: Use the correct fence macro after swapgs in kernel CR3")
c07e45553da1 ("x86/entry: Add a fence for kernel entry SWAPGS in paranoid_entry()")
6e5772c8d9cf ("Merge tag 'x86_cc_for_v5.16_rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f7ef280132f9bf6f82acf5aa5c3c837206eef501 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 28 Oct 2022 17:30:07 -0400
Subject: [PATCH] KVM: SVM: adjust register allocation for __svm_vcpu_run()

32-bit ABI uses RAX/RCX/RDX as its argument registers, so they are in
the way of instructions that hardcode their operands such as RDMSR/WRMSR
or VMLOAD/VMRUN/VMSAVE.

In preparation for moving vmload/vmsave to __svm_vcpu_run(), keep
the pointer to the struct vcpu_svm in %rdi.  In particular, it is now
possible to load svm->vmcb01.pa in %rax without clobbering the struct
vcpu_svm pointer.

No functional change intended.

Cc: stable@vger.kernel.org
Fixes: a149180fbcf3 ("x86: Add magic AMD return-thunk")
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index f0ff41103e4c..531510ab6072 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -54,29 +54,29 @@ SYM_FUNC_START(__svm_vcpu_run)
 	/* Save @vmcb. */
 	push %_ASM_ARG1
 
-	/* Move @svm to RAX. */
-	mov %_ASM_ARG2, %_ASM_AX
+	/* Move @svm to RDI. */
+	mov %_ASM_ARG2, %_ASM_DI
+
+	/* "POP" @vmcb to RAX. */
+	pop %_ASM_AX
 
 	/* Load guest registers. */
-	mov VCPU_RCX(%_ASM_AX), %_ASM_CX
-	mov VCPU_RDX(%_ASM_AX), %_ASM_DX
-	mov VCPU_RBX(%_ASM_AX), %_ASM_BX
-	mov VCPU_RBP(%_ASM_AX), %_ASM_BP
-	mov VCPU_RSI(%_ASM_AX), %_ASM_SI
-	mov VCPU_RDI(%_ASM_AX), %_ASM_DI
+	mov VCPU_RCX(%_ASM_DI), %_ASM_CX
+	mov VCPU_RDX(%_ASM_DI), %_ASM_DX
+	mov VCPU_RBX(%_ASM_DI), %_ASM_BX
+	mov VCPU_RBP(%_ASM_DI), %_ASM_BP
+	mov VCPU_RSI(%_ASM_DI), %_ASM_SI
 #ifdef CONFIG_X86_64
-	mov VCPU_R8 (%_ASM_AX),  %r8
-	mov VCPU_R9 (%_ASM_AX),  %r9
-	mov VCPU_R10(%_ASM_AX), %r10
-	mov VCPU_R11(%_ASM_AX), %r11
-	mov VCPU_R12(%_ASM_AX), %r12
-	mov VCPU_R13(%_ASM_AX), %r13
-	mov VCPU_R14(%_ASM_AX), %r14
-	mov VCPU_R15(%_ASM_AX), %r15
+	mov VCPU_R8 (%_ASM_DI),  %r8
+	mov VCPU_R9 (%_ASM_DI),  %r9
+	mov VCPU_R10(%_ASM_DI), %r10
+	mov VCPU_R11(%_ASM_DI), %r11
+	mov VCPU_R12(%_ASM_DI), %r12
+	mov VCPU_R13(%_ASM_DI), %r13
+	mov VCPU_R14(%_ASM_DI), %r14
+	mov VCPU_R15(%_ASM_DI), %r15
 #endif
-
-	/* "POP" @vmcb to RAX. */
-	pop %_ASM_AX
+	mov VCPU_RDI(%_ASM_DI), %_ASM_DI
 
 	/* Enter guest mode */
 	sti

