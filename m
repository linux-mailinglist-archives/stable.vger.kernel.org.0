Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFDC57ED60
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 11:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237324AbiGWJ4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 05:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237312AbiGWJ4c (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 05:56:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4B0FD1F;
        Sat, 23 Jul 2022 02:56:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FA70B82C1B;
        Sat, 23 Jul 2022 09:56:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E58C341CA;
        Sat, 23 Jul 2022 09:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570189;
        bh=xgz+phWSzPt31Ph3dA4Jf3eDUzJaXACYi/OnM6XS898=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xKdtpuExy5uBnx7ze+RV2XlGLtfiVhHT2DaYKAp7Brbn/8a3XusUJ/7Q21i2O8qLd
         9u+TqT8vJ6npBFHeIP+fn93VMyC3G6BrR3EMymL4MElpQK82LdaQYe4Tjy1gGr+6zh
         GjzU6jHBzpUECv6YaSXOpkdoJYhe2s24FE+QBnME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 002/148] KVM/nVMX: Use __vmx_vcpu_run in nested_vmx_check_vmentry_hw
Date:   Sat, 23 Jul 2022 11:53:34 +0200
Message-Id: <20220723095225.031469615@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uros Bizjak <ubizjak@gmail.com>

commit 150f17bfab37e981ba03b37440638138ff2aa9ec upstream.

Replace inline assembly in nested_vmx_check_vmentry_hw
with a call to __vmx_vcpu_run.  The function is not
performance critical, so (double) GPR save/restore
in __vmx_vcpu_run can be tolerated, as far as performance
effects are concerned.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Reviewed-and-tested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
[sean: dropped versioning info from changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20201231002702.2223707-5-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c  |   32 +++-----------------------------
 arch/x86/kvm/vmx/vmenter.S |    2 +-
 arch/x86/kvm/vmx/vmx.c     |    2 --
 arch/x86/kvm/vmx/vmx.h     |    1 +
 4 files changed, 5 insertions(+), 32 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -12,6 +12,7 @@
 #include "nested.h"
 #include "pmu.h"
 #include "trace.h"
+#include "vmx.h"
 #include "x86.h"
 
 static bool __read_mostly enable_shadow_vmcs = 1;
@@ -3075,35 +3076,8 @@ static int nested_vmx_check_vmentry_hw(s
 		vmx->loaded_vmcs->host_state.cr4 = cr4;
 	}
 
-	asm(
-		"sub $%c[wordsize], %%" _ASM_SP "\n\t" /* temporarily adjust RSP for CALL */
-		"cmp %%" _ASM_SP ", %c[host_state_rsp](%[loaded_vmcs]) \n\t"
-		"je 1f \n\t"
-		__ex("vmwrite %%" _ASM_SP ", %[HOST_RSP]") "\n\t"
-		"mov %%" _ASM_SP ", %c[host_state_rsp](%[loaded_vmcs]) \n\t"
-		"1: \n\t"
-		"add $%c[wordsize], %%" _ASM_SP "\n\t" /* un-adjust RSP */
-
-		/* Check if vmlaunch or vmresume is needed */
-		"cmpb $0, %c[launched](%[loaded_vmcs])\n\t"
-
-		/*
-		 * VMLAUNCH and VMRESUME clear RFLAGS.{CF,ZF} on VM-Exit, set
-		 * RFLAGS.CF on VM-Fail Invalid and set RFLAGS.ZF on VM-Fail
-		 * Valid.  vmx_vmenter() directly "returns" RFLAGS, and so the
-		 * results of VM-Enter is captured via CC_{SET,OUT} to vm_fail.
-		 */
-		"call vmx_vmenter\n\t"
-
-		CC_SET(be)
-	      : ASM_CALL_CONSTRAINT, CC_OUT(be) (vm_fail)
-	      :	[HOST_RSP]"r"((unsigned long)HOST_RSP),
-		[loaded_vmcs]"r"(vmx->loaded_vmcs),
-		[launched]"i"(offsetof(struct loaded_vmcs, launched)),
-		[host_state_rsp]"i"(offsetof(struct loaded_vmcs, host_state.rsp)),
-		[wordsize]"i"(sizeof(ulong))
-	      : "memory"
-	);
+	vm_fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
+				 vmx->loaded_vmcs->launched);
 
 	if (vmx->msr_autoload.host.nr)
 		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -44,7 +44,7 @@
  * they VM-Fail, whereas a successful VM-Enter + VM-Exit will jump
  * to vmx_vmexit.
  */
-SYM_FUNC_START(vmx_vmenter)
+SYM_FUNC_START_LOCAL(vmx_vmenter)
 	/* EFLAGS.ZF is set if VMCS.LAUNCHED == 0 */
 	je 2f
 
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6687,8 +6687,6 @@ static fastpath_t vmx_exit_handlers_fast
 	}
 }
 
-bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
-
 static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 					struct vcpu_vmx *vmx)
 {
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -365,6 +365,7 @@ void vmx_set_virtual_apic_mode(struct kv
 struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
+bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
 int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr);
 void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu);
 


