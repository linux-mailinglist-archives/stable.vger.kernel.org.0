Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C53DFF36F
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbfKPQZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:25:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728120AbfKPPmD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:42:03 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8E5E2072D;
        Sat, 16 Nov 2019 15:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918922;
        bh=un9r7sRNLZ7S299X62Y3aZHtgoNfUKo5LaDG6M1obmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KvpvYMDK/UAoOyw/gKFbvBa2XwWC0o4bXF/qfMNQlUiX67+kJLg7R4I67l85nT/uX
         oH/Sgf8xVWLMdc3cdtLhVsSBT47UJPYPFl1Kcmv58efI20sAZG9Rr5e4e2tt8pXrF6
         vfELekbsc0YTSUij0rHbRHq12GGGE0RgeafESp3o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 047/237] KVM: nVMX: reset cache/shadows when switching loaded VMCS
Date:   Sat, 16 Nov 2019 10:38:02 -0500
Message-Id: <20191116154113.7417-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 4eda2a9c234a6..8c7554d7f0a80 100644
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
@@ -12700,7 +12704,6 @@ static int enter_vmx_non_root_mode(struct kvm_vcpu *vcpu, u32 *exit_qual)
 		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
 
 	vmx_switch_vmcs(vcpu, &vmx->nested.vmcs02);
-	vmx_segment_cache_clear(vmx);
 
 	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETING)
 		vcpu->arch.tsc_offset += vmcs12->tsc_offset;
@@ -13531,9 +13534,6 @@ static void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 	}
 
 	vmx_switch_vmcs(vcpu, &vmx->vmcs01);
-	vm_entry_controls_reset_shadow(vmx);
-	vm_exit_controls_reset_shadow(vmx);
-	vmx_segment_cache_clear(vmx);
 
 	/* Update any VMCS fields that might have changed while L2 ran */
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
-- 
2.20.1

