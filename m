Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B501D0F29
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732738AbgEMJqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:46:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732730AbgEMJqv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:46:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FE96206F5;
        Wed, 13 May 2020 09:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363210;
        bh=8Mj3jZCsTb7GPdBb8D/nuu08H/0MOu2Z00t6vvgURMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NtFLR64xr2wQVt5lm7d8ZFTi2ESnksREOZ1JRHjL7zaVnNxdRpqUseXS2EGPfJLxb
         vdkDUooyqDErk5wfXtiMgLZdLx0IU5a26vnNiAFhu8M6/UQHuP+btT2wLUdidGLdrv
         Z4XlXmrTD9Uq81FkludZ9AtVB0jrZwiC0MH1rrKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 31/48] KVM: VMX: Explicitly reference RCX as the vmx_vcpu pointer in asm blobs
Date:   Wed, 13 May 2020 11:44:57 +0200
Message-Id: <20200513094359.369566125@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094351.100352960@linuxfoundation.org>
References: <20200513094351.100352960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 051a2d3e59e51ae49fd56aef34e472832897ce46 upstream.

Use '%% " _ASM_CX"' instead of '%0' to dereference RCX, i.e. the
'struct vcpu_vmx' pointer, in the VM-Enter asm blobs of vmx_vcpu_run()
and nested_vmx_check_vmentry_hw().  Using the symbolic name means that
adding/removing an output parameter(s) requires "rewriting" almost all
of the asm blob, which makes it nearly impossible to understand what's
being changed in even the most minor patches.

Opportunistically improve the code comments.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx.c |   86 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 47 insertions(+), 39 deletions(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -10776,9 +10776,9 @@ static void __noclone vmx_vcpu_run(struc
 		"push %%" _ASM_DX "; push %%" _ASM_BP ";"
 		"push %%" _ASM_CX " \n\t" /* placeholder for guest rcx */
 		"push %%" _ASM_CX " \n\t"
-		"cmp %%" _ASM_SP ", %c[host_rsp](%0) \n\t"
+		"cmp %%" _ASM_SP ", %c[host_rsp](%%" _ASM_CX ") \n\t"
 		"je 1f \n\t"
-		"mov %%" _ASM_SP ", %c[host_rsp](%0) \n\t"
+		"mov %%" _ASM_SP ", %c[host_rsp](%%" _ASM_CX ") \n\t"
 		/* Avoid VMWRITE when Enlightened VMCS is in use */
 		"test %%" _ASM_SI ", %%" _ASM_SI " \n\t"
 		"jz 2f \n\t"
@@ -10788,32 +10788,33 @@ static void __noclone vmx_vcpu_run(struc
 		__ex(ASM_VMX_VMWRITE_RSP_RDX) "\n\t"
 		"1: \n\t"
 		/* Reload cr2 if changed */
-		"mov %c[cr2](%0), %%" _ASM_AX " \n\t"
+		"mov %c[cr2](%%" _ASM_CX "), %%" _ASM_AX " \n\t"
 		"mov %%cr2, %%" _ASM_DX " \n\t"
 		"cmp %%" _ASM_AX ", %%" _ASM_DX " \n\t"
 		"je 3f \n\t"
 		"mov %%" _ASM_AX", %%cr2 \n\t"
 		"3: \n\t"
 		/* Check if vmlaunch of vmresume is needed */
-		"cmpb $0, %c[launched](%0) \n\t"
+		"cmpb $0, %c[launched](%%" _ASM_CX ") \n\t"
 		/* Load guest registers.  Don't clobber flags. */
-		"mov %c[rax](%0), %%" _ASM_AX " \n\t"
-		"mov %c[rbx](%0), %%" _ASM_BX " \n\t"
-		"mov %c[rdx](%0), %%" _ASM_DX " \n\t"
-		"mov %c[rsi](%0), %%" _ASM_SI " \n\t"
-		"mov %c[rdi](%0), %%" _ASM_DI " \n\t"
-		"mov %c[rbp](%0), %%" _ASM_BP " \n\t"
+		"mov %c[rax](%%" _ASM_CX "), %%" _ASM_AX " \n\t"
+		"mov %c[rbx](%%" _ASM_CX "), %%" _ASM_BX " \n\t"
+		"mov %c[rdx](%%" _ASM_CX "), %%" _ASM_DX " \n\t"
+		"mov %c[rsi](%%" _ASM_CX "), %%" _ASM_SI " \n\t"
+		"mov %c[rdi](%%" _ASM_CX "), %%" _ASM_DI " \n\t"
+		"mov %c[rbp](%%" _ASM_CX "), %%" _ASM_BP " \n\t"
 #ifdef CONFIG_X86_64
-		"mov %c[r8](%0),  %%r8  \n\t"
-		"mov %c[r9](%0),  %%r9  \n\t"
-		"mov %c[r10](%0), %%r10 \n\t"
-		"mov %c[r11](%0), %%r11 \n\t"
-		"mov %c[r12](%0), %%r12 \n\t"
-		"mov %c[r13](%0), %%r13 \n\t"
-		"mov %c[r14](%0), %%r14 \n\t"
-		"mov %c[r15](%0), %%r15 \n\t"
+		"mov %c[r8](%%" _ASM_CX "),  %%r8  \n\t"
+		"mov %c[r9](%%" _ASM_CX "),  %%r9  \n\t"
+		"mov %c[r10](%%" _ASM_CX "), %%r10 \n\t"
+		"mov %c[r11](%%" _ASM_CX "), %%r11 \n\t"
+		"mov %c[r12](%%" _ASM_CX "), %%r12 \n\t"
+		"mov %c[r13](%%" _ASM_CX "), %%r13 \n\t"
+		"mov %c[r14](%%" _ASM_CX "), %%r14 \n\t"
+		"mov %c[r15](%%" _ASM_CX "), %%r15 \n\t"
 #endif
-		"mov %c[rcx](%0), %%" _ASM_CX " \n\t" /* kills %0 (ecx) */
+		/* Load guest RCX.  This kills the vmx_vcpu pointer! */
+		"mov %c[rcx](%%" _ASM_CX "), %%" _ASM_CX " \n\t"
 
 		/* Enter guest mode */
 		"jne 1f \n\t"
@@ -10821,26 +10822,33 @@ static void __noclone vmx_vcpu_run(struc
 		"jmp 2f \n\t"
 		"1: " __ex(ASM_VMX_VMRESUME) "\n\t"
 		"2: "
-		/* Save guest registers, load host registers, keep flags */
-		"mov %0, %c[wordsize](%%" _ASM_SP ") \n\t"
-		"pop %0 \n\t"
-		"setbe %c[fail](%0)\n\t"
-		"mov %%" _ASM_AX ", %c[rax](%0) \n\t"
-		"mov %%" _ASM_BX ", %c[rbx](%0) \n\t"
-		__ASM_SIZE(pop) " %c[rcx](%0) \n\t"
-		"mov %%" _ASM_DX ", %c[rdx](%0) \n\t"
-		"mov %%" _ASM_SI ", %c[rsi](%0) \n\t"
-		"mov %%" _ASM_DI ", %c[rdi](%0) \n\t"
-		"mov %%" _ASM_BP ", %c[rbp](%0) \n\t"
+
+		/* Save guest's RCX to the stack placeholder (see above) */
+		"mov %%" _ASM_CX ", %c[wordsize](%%" _ASM_SP ") \n\t"
+
+		/* Load host's RCX, i.e. the vmx_vcpu pointer */
+		"pop %%" _ASM_CX " \n\t"
+
+		/* Set vmx->fail based on EFLAGS.{CF,ZF} */
+		"setbe %c[fail](%%" _ASM_CX ")\n\t"
+
+		/* Save all guest registers, including RCX from the stack */
+		"mov %%" _ASM_AX ", %c[rax](%%" _ASM_CX ") \n\t"
+		"mov %%" _ASM_BX ", %c[rbx](%%" _ASM_CX ") \n\t"
+		__ASM_SIZE(pop) " %c[rcx](%%" _ASM_CX ") \n\t"
+		"mov %%" _ASM_DX ", %c[rdx](%%" _ASM_CX ") \n\t"
+		"mov %%" _ASM_SI ", %c[rsi](%%" _ASM_CX ") \n\t"
+		"mov %%" _ASM_DI ", %c[rdi](%%" _ASM_CX ") \n\t"
+		"mov %%" _ASM_BP ", %c[rbp](%%" _ASM_CX ") \n\t"
 #ifdef CONFIG_X86_64
-		"mov %%r8,  %c[r8](%0) \n\t"
-		"mov %%r9,  %c[r9](%0) \n\t"
-		"mov %%r10, %c[r10](%0) \n\t"
-		"mov %%r11, %c[r11](%0) \n\t"
-		"mov %%r12, %c[r12](%0) \n\t"
-		"mov %%r13, %c[r13](%0) \n\t"
-		"mov %%r14, %c[r14](%0) \n\t"
-		"mov %%r15, %c[r15](%0) \n\t"
+		"mov %%r8,  %c[r8](%%" _ASM_CX ") \n\t"
+		"mov %%r9,  %c[r9](%%" _ASM_CX ") \n\t"
+		"mov %%r10, %c[r10](%%" _ASM_CX ") \n\t"
+		"mov %%r11, %c[r11](%%" _ASM_CX ") \n\t"
+		"mov %%r12, %c[r12](%%" _ASM_CX ") \n\t"
+		"mov %%r13, %c[r13](%%" _ASM_CX ") \n\t"
+		"mov %%r14, %c[r14](%%" _ASM_CX ") \n\t"
+		"mov %%r15, %c[r15](%%" _ASM_CX ") \n\t"
 
 		/*
 		 * Clear all general purpose registers (except RSP, which is loaded by
@@ -10860,7 +10868,7 @@ static void __noclone vmx_vcpu_run(struc
 		"xor %%r15d, %%r15d \n\t"
 #endif
 		"mov %%cr2, %%" _ASM_AX "   \n\t"
-		"mov %%" _ASM_AX ", %c[cr2](%0) \n\t"
+		"mov %%" _ASM_AX ", %c[cr2](%%" _ASM_CX ") \n\t"
 
 		"xor %%eax, %%eax \n\t"
 		"xor %%ebx, %%ebx \n\t"


