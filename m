Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE32DB2039
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389314AbfIMNSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:18:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389668AbfIMNSh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:18:37 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3EE4206A5;
        Fri, 13 Sep 2019 13:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380715;
        bh=XVYIv0Ox5JA7Fj2C5eqS00irDiXQLvRnc/N5P47Pxok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hd6kEE2AuBEJwhZvWY0xVc8C7mATJCwtMGH4Se2h2BqLQdYz6RnbGVWuvaJc6rqqF
         tgbK5Z47t/8K9zi+Oj4jFY1RV3wGuNgUqP3KpI33G/YZIxF7gPqsaHxTDwpLyUR+Az
         60xpKYGNFs4pwBQMnvLDCktB8x4O5YPxvvRzEVlI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 154/190] KVM: VMX: Fix handling of #MC that occurs during VM-Entry
Date:   Fri, 13 Sep 2019 14:06:49 +0100
Message-Id: <20190913130612.227146438@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit beb8d93b3e423043e079ef3dda19dad7b28467a8 ]

A previous fix to prevent KVM from consuming stale VMCS state after a
failed VM-Entry inadvertantly blocked KVM's handling of machine checks
that occur during VM-Entry.

Per Intel's SDM, a #MC during VM-Entry is handled in one of three ways,
depending on when the #MC is recognoized.  As it pertains to this bug
fix, the third case explicitly states EXIT_REASON_MCE_DURING_VMENTRY
is handled like any other VM-Exit during VM-Entry, i.e. sets bit 31 to
indicate the VM-Entry failed.

If a machine-check event occurs during a VM entry, one of the following occurs:
 - The machine-check event is handled as if it occurred before the VM entry:
        ...
 - The machine-check event is handled after VM entry completes:
        ...
 - A VM-entry failure occurs as described in Section 26.7. The basic
   exit reason is 41, for "VM-entry failure due to machine-check event".

Explicitly handle EXIT_REASON_MCE_DURING_VMENTRY as a one-off case in
vmx_vcpu_run() instead of binning it into vmx_complete_atomic_exit().
Doing so allows vmx_vcpu_run() to handle VMX_EXIT_REASONS_FAILED_VMENTRY
in a sane fashion and also simplifies vmx_complete_atomic_exit() since
VMCS.VM_EXIT_INTR_INFO is guaranteed to be fresh.

Fixes: b060ca3b2e9e7 ("kvm: vmx: Handle VMLAUNCH/VMRESUME failure properly")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index e4bba840a0708..82253d31842a2 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -10438,28 +10438,21 @@ static void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 
 static void vmx_complete_atomic_exit(struct vcpu_vmx *vmx)
 {
-	u32 exit_intr_info = 0;
-	u16 basic_exit_reason = (u16)vmx->exit_reason;
-
-	if (!(basic_exit_reason == EXIT_REASON_MCE_DURING_VMENTRY
-	      || basic_exit_reason == EXIT_REASON_EXCEPTION_NMI))
+	if (vmx->exit_reason != EXIT_REASON_EXCEPTION_NMI)
 		return;
 
-	if (!(vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
-		exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
-	vmx->exit_intr_info = exit_intr_info;
+	vmx->exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 
 	/* if exit due to PF check for async PF */
-	if (is_page_fault(exit_intr_info))
+	if (is_page_fault(vmx->exit_intr_info))
 		vmx->vcpu.arch.apf.host_apf_reason = kvm_read_and_reset_pf_reason();
 
 	/* Handle machine checks before interrupts are enabled */
-	if (basic_exit_reason == EXIT_REASON_MCE_DURING_VMENTRY ||
-	    is_machine_check(exit_intr_info))
+	if (is_machine_check(vmx->exit_intr_info))
 		kvm_machine_check();
 
 	/* We need to handle NMIs before interrupts are enabled */
-	if (is_nmi(exit_intr_info)) {
+	if (is_nmi(vmx->exit_intr_info)) {
 		kvm_before_interrupt(&vmx->vcpu);
 		asm("int $2");
 		kvm_after_interrupt(&vmx->vcpu);
@@ -10980,6 +10973,9 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	vmx->idt_vectoring_info = 0;
 
 	vmx->exit_reason = vmx->fail ? 0xdead : vmcs_read32(VM_EXIT_REASON);
+	if ((u16)vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY)
+		kvm_machine_check();
+
 	if (vmx->fail || (vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
 		return;
 
-- 
2.20.1



