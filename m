Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C2C1AC44A
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504597AbgDPN5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:57:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409333AbgDPN5a (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:57:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA5402076D;
        Thu, 16 Apr 2020 13:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045449;
        bh=Mnur4y7Z3DG/U51267RRZUuGvk/ACYGL1HqBmKdp/bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MTcFhdsU33x9sTFej8QDcQr7KHT0YCDeCtjRIYtnHgU33myNWyqgCMr5Q7mpuvcyl
         83K20eayS24SlWiPPuoGO1SxjgAUz1LbH/tfTMV0/A22TvdNiyoYASmUcWIPzb7EZL
         sFMMe1JamRDJkbW+p8Tloue5BhXcnYOc8iTNX89c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.6 137/254] KVM: VMX: Add a trampoline to fix VMREAD error handling
Date:   Thu, 16 Apr 2020 15:23:46 +0200
Message-Id: <20200416131343.616193615@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 842f4be95899df22b5843ba1a7c8cf37e831a6e8 upstream.

Add a hand coded assembly trampoline to preserve volatile registers
across vmread_error(), and to handle the calling convention differences
between 64-bit and 32-bit due to asmlinkage on vmread_error().  Pass
@field and @fault on the stack when invoking the trampoline to avoid
clobbering volatile registers in the context of the inline assembly.

Calling vmread_error() directly from inline assembly is partially broken
on 64-bit, and completely broken on 32-bit.  On 64-bit, it will clobber
%rdi and %rsi (used to pass @field and @fault) and any volatile regs
written by vmread_error().  On 32-bit, asmlinkage means vmread_error()
expects the parameters to be passed on the stack, not via regs.

Opportunistically zero out the result in the trampoline to save a few
bytes of code for every VMREAD.  A happy side effect of the trampoline
is that the inline code footprint is reduced by three bytes on 64-bit
due to PUSH/POP being more efficent (in terms of opcode bytes) than MOV.

Fixes: 6e2020977e3e6 ("KVM: VMX: Add error handling to VMREAD helper")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200326160712.28803-1-sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx/ops.h     |   28 ++++++++++++++++-----
 arch/x86/kvm/vmx/vmenter.S |   58 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/vmx/ops.h
+++ b/arch/x86/kvm/vmx/ops.h
@@ -12,7 +12,8 @@
 
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
-asmlinkage void vmread_error(unsigned long field, bool fault);
+__attribute__((regparm(0))) void vmread_error_trampoline(unsigned long field,
+							 bool fault);
 void vmwrite_error(unsigned long field, unsigned long value);
 void vmclear_error(struct vmcs *vmcs, u64 phys_addr);
 void vmptrld_error(struct vmcs *vmcs, u64 phys_addr);
@@ -70,15 +71,28 @@ static __always_inline unsigned long __v
 	asm volatile("1: vmread %2, %1\n\t"
 		     ".byte 0x3e\n\t" /* branch taken hint */
 		     "ja 3f\n\t"
-		     "mov %2, %%" _ASM_ARG1 "\n\t"
-		     "xor %%" _ASM_ARG2 ", %%" _ASM_ARG2 "\n\t"
-		     "2: call vmread_error\n\t"
-		     "xor %k1, %k1\n\t"
+
+		     /*
+		      * VMREAD failed.  Push '0' for @fault, push the failing
+		      * @field, and bounce through the trampoline to preserve
+		      * volatile registers.
+		      */
+		     "push $0\n\t"
+		     "push %2\n\t"
+		     "2:call vmread_error_trampoline\n\t"
+
+		     /*
+		      * Unwind the stack.  Note, the trampoline zeros out the
+		      * memory for @fault so that the result is '0' on error.
+		      */
+		     "pop %2\n\t"
+		     "pop %1\n\t"
 		     "3:\n\t"
 
+		     /* VMREAD faulted.  As above, except push '1' for @fault. */
 		     ".pushsection .fixup, \"ax\"\n\t"
-		     "4: mov %2, %%" _ASM_ARG1 "\n\t"
-		     "mov $1, %%" _ASM_ARG2 "\n\t"
+		     "4: push $1\n\t"
+		     "push %2\n\t"
 		     "jmp 2b\n\t"
 		     ".popsection\n\t"
 		     _ASM_EXTABLE(1b, 4b)
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -234,3 +234,61 @@ SYM_FUNC_START(__vmx_vcpu_run)
 2:	mov $1, %eax
 	jmp 1b
 SYM_FUNC_END(__vmx_vcpu_run)
+
+/**
+ * vmread_error_trampoline - Trampoline from inline asm to vmread_error()
+ * @field:	VMCS field encoding that failed
+ * @fault:	%true if the VMREAD faulted, %false if it failed
+
+ * Save and restore volatile registers across a call to vmread_error().  Note,
+ * all parameters are passed on the stack.
+ */
+SYM_FUNC_START(vmread_error_trampoline)
+	push %_ASM_BP
+	mov  %_ASM_SP, %_ASM_BP
+
+	push %_ASM_AX
+	push %_ASM_CX
+	push %_ASM_DX
+#ifdef CONFIG_X86_64
+	push %rdi
+	push %rsi
+	push %r8
+	push %r9
+	push %r10
+	push %r11
+#endif
+#ifdef CONFIG_X86_64
+	/* Load @field and @fault to arg1 and arg2 respectively. */
+	mov 3*WORD_SIZE(%rbp), %_ASM_ARG2
+	mov 2*WORD_SIZE(%rbp), %_ASM_ARG1
+#else
+	/* Parameters are passed on the stack for 32-bit (see asmlinkage). */
+	push 3*WORD_SIZE(%ebp)
+	push 2*WORD_SIZE(%ebp)
+#endif
+
+	call vmread_error
+
+#ifndef CONFIG_X86_64
+	add $8, %esp
+#endif
+
+	/* Zero out @fault, which will be popped into the result register. */
+	_ASM_MOV $0, 3*WORD_SIZE(%_ASM_BP)
+
+#ifdef CONFIG_X86_64
+	pop %r11
+	pop %r10
+	pop %r9
+	pop %r8
+	pop %rsi
+	pop %rdi
+#endif
+	pop %_ASM_DX
+	pop %_ASM_CX
+	pop %_ASM_AX
+	pop %_ASM_BP
+
+	ret
+SYM_FUNC_END(vmread_error_trampoline)


