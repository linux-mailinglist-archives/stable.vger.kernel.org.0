Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3FF21C4B7C
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 03:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbgEEBXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 21:23:55 -0400
Received: from mga07.intel.com ([134.134.136.100]:22407 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726449AbgEEBXv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 21:23:51 -0400
IronPort-SDR: Fsg5d56X0KLiEcNqhZdidXSh1Gl7k8SaHUcwAOnqqzf529rrU9ej9+9iWvZC87bh8S2AuGOcb5
 agrMjzaJ56PA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2020 18:23:50 -0700
IronPort-SDR: hvHTab6HWhKVa/K1wnn99uu0iRukuvOYaaS2dEM5FyGTjIUx0G3aQZsc906lP5Zch8nGJyM1az
 vOUFdqbNszJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,354,1583222400"; 
   d="scan'208";a="406663376"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga004.jf.intel.com with ESMTP; 04 May 2020 18:23:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        Tobias Urdin <tobias.urdin@binero.com>
Subject: [PATCH 4.19 STABLE 1/2] KVM: VMX: Explicitly reference RCX as the vmx_vcpu pointer in asm blobs
Date:   Mon,  4 May 2020 18:23:47 -0700
Message-Id: <20200505012348.17099-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200505012348.17099-1-sean.j.christopherson@intel.com>
References: <20200505012348.17099-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit 051a2d3e59e51ae49fd56aef34e472832897ce46.

Use '%% " _ASM_CX"' instead of '%0' to dereference RCX, i.e. the
'struct vcpu_vmx' pointer, in the VM-Enter asm blobs of vmx_vcpu_run()
and nested_vmx_check_vmentry_hw().  Using the symbolic name means that
adding/removing an output parameter(s) requires "rewriting" almost all
of the asm blob, which makes it nearly impossible to understand what's
being changed in even the most minor patches.

Opportunistically improve the code comments.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx.c | 86 +++++++++++++++++++++++++---------------------
 1 file changed, 47 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index fe5036641c59..5b06a98ffd4c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -10776,9 +10776,9 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
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
@@ -10788,32 +10788,33 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
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
@@ -10821,26 +10822,33 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
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
@@ -10860,7 +10868,7 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		"xor %%r15d, %%r15d \n\t"
 #endif
 		"mov %%cr2, %%" _ASM_AX "   \n\t"
-		"mov %%" _ASM_AX ", %c[cr2](%0) \n\t"
+		"mov %%" _ASM_AX ", %c[cr2](%%" _ASM_CX ") \n\t"
 
 		"xor %%eax, %%eax \n\t"
 		"xor %%ebx, %%ebx \n\t"
-- 
2.26.0

