Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C14EF10BD60
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730677AbfK0U5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:57:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:48774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730942AbfK0U5j (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:57:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5DB4217AB;
        Wed, 27 Nov 2019 20:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888259;
        bh=j6BAQHCSeUvTzCnq7OjgDnls3hqn4lnWjWlJ6zYEes8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQxjkJ/gSze9rUKfH0oLnMQ8+Dk213WcKC13e1pchcczI1LsRAoxEIsBXlLhCHqhf
         zBLzjr5iOFIhJfYy13/oiYh/yVgnoaZE/OhGqTlq0D6V7g0Vud9veKZ2u4pJRxdOYM
         IVMfbkM98W7CNITAy+NBKjnsnx9PWkXnqW45JQiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 066/306] KVM: nVMX: reset cache/shadows when switching loaded VMCS
Date:   Wed, 27 Nov 2019 21:28:36 +0100
Message-Id: <20191127203119.599052282@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

[ Upstream commit b7031fd40fcc741b0f9b0c04c8d844e445858b84 ]

Reset the vm_{entry,exit}_controls_shadow variables as well as the
segment cache after loading a new VMCS in vmx_switch_vmcs().  The
shadows/cache track VMCS data, i.e. they're stale every time we
switch to a new VMCS regardless of reason.

This fixes a bug where stale control shadows would be consumed after
a nested VMExit due to a failed consistency check.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 1ab4bb3d6a040..fe7fdd666f091 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -11013,6 +11013,10 @@ static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
 	vmx->loaded_vmcs = vmcs;
 	vmx_vcpu_load(vcpu, cpu);
 	put_cpu();
+
+	vm_entry_controls_reset_shadow(vmx);
+	vm_exit_controls_reset_shadow(vmx);
+	vmx_segment_cache_clear(vmx);
 }
 
 /*
@@ -12699,7 +12703,6 @@ static int enter_vmx_non_root_mode(struct kvm_vcpu *vcpu, u32 *exit_qual)
 		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
 
 	vmx_switch_vmcs(vcpu, &vmx->nested.vmcs02);
-	vmx_segment_cache_clear(vmx);
 
 	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETING)
 		vcpu->arch.tsc_offset += vmcs12->tsc_offset;
@@ -13530,9 +13533,6 @@ static void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 	}
 
 	vmx_switch_vmcs(vcpu, &vmx->vmcs01);
-	vm_entry_controls_reset_shadow(vmx);
-	vm_exit_controls_reset_shadow(vmx);
-	vmx_segment_cache_clear(vmx);
 
 	/* Update any VMCS fields that might have changed while L2 ran */
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
-- 
2.20.1



