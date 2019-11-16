Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2376FF1AA
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730567AbfKPQNj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:13:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:54840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729879AbfKPPr6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:47:58 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA4E820815;
        Sat, 16 Nov 2019 15:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919278;
        bh=rDrhUhQSd49dcyLGwOTAa85ul3nGNRunIHroIySg1t0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qt4MDKNjDaXt65NSDjaBSGAwNcvD3qp31CNs3pE137Roc4ljfzmPjwa8dPP0D2nya
         c61Y/uWDa1EX1Xd/TpvBaOva0O59VaU+yifz7y8+/1QuQjQLyPKVVLYH+vrKlCcwkQ
         e11oCQmXq4Zwu+E3GWAK2Q22W1lkhD/mQ84LnfwY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 028/150] KVM: nVMX: reset cache/shadows when switching loaded VMCS
Date:   Sat, 16 Nov 2019 10:45:26 -0500
Message-Id: <20191116154729.9573-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
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
index cd5a8e888eb6b..bba42eb3cc124 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -10000,6 +10000,10 @@ static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
 	vmx_vcpu_load(vcpu, cpu);
 	vcpu->cpu = cpu;
 	put_cpu();
+
+	vm_entry_controls_reset_shadow(vmx);
+	vm_exit_controls_reset_shadow(vmx);
+	vmx_segment_cache_clear(vmx);
 }
 
 /*
@@ -11429,7 +11433,6 @@ static int enter_vmx_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 		vmx->nested.vmcs01_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
 
 	vmx_switch_vmcs(vcpu, &vmx->nested.vmcs02);
-	vmx_segment_cache_clear(vmx);
 
 	if (prepare_vmcs02(vcpu, vmcs12, from_vmentry, &exit_qual)) {
 		leave_guest_mode(vcpu);
@@ -12173,9 +12176,6 @@ static void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 	}
 
 	vmx_switch_vmcs(vcpu, &vmx->vmcs01);
-	vm_entry_controls_reset_shadow(vmx);
-	vm_exit_controls_reset_shadow(vmx);
-	vmx_segment_cache_clear(vmx);
 
 	/* Update any VMCS fields that might have changed while L2 ran */
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
-- 
2.20.1

