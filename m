Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68EC1FB8C3
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732948AbgFPPyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:54:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732939AbgFPPyE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:54:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EAA021527;
        Tue, 16 Jun 2020 15:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322843;
        bh=D9yr1XlJJZE4sCwWQfGJZumeH5LuhoRdpZObk6ppYp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s0bPNesk/21qLRn5V2iLB6ZNlzuBenxoA7Zvd5EDwzinNhbWUDs7MoPCKf6/sOeHF
         OP+RFWfntxgKFFwIS40O+B7DhAbf+p0LSP4gyTh0m/ERdErwaBzkA7HfL5zcrVcyWd
         lreqOVqZJ0Lv6du7tCIIgCWMp5fjq9n6cYDmBMSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        KarimAllah Raslan <karahmed@amazon.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.6 125/161] KVM: nVMX: Skip IBPB when switching between vmcs01 and vmcs02
Date:   Tue, 16 Jun 2020 17:35:15 +0200
Message-Id: <20200616153112.316849879@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 5c911beff20aa8639e7a1f28988736c13e03ed54 upstream.

Skip the Indirect Branch Prediction Barrier that is triggered on a VMCS
switch when running with spectre_v2_user=on/auto if the switch is
between two VMCSes in the same guest, i.e. between vmcs01 and vmcs02.
The IBPB is intended to prevent one guest from attacking another, which
is unnecessary in the nested case as it's the same guest from KVM's
perspective.

This all but eliminates the overhead observed for nested VMX transitions
when running with CONFIG_RETPOLINE=y and spectre_v2_user=on/auto, which
can be significant, e.g. roughly 3x on current systems.

Reported-by: Alexander Graf <graf@amazon.com>
Cc: KarimAllah Raslan <karahmed@amazon.de>
Cc: stable@vger.kernel.org
Fixes: 15d45071523d ("KVM/x86: Add IBPB support")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200501163117.4655-1-sean.j.christopherson@intel.com>
[Invert direction of bool argument. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx/nested.c |    2 +-
 arch/x86/kvm/vmx/vmx.c    |   18 ++++++++++++++----
 arch/x86/kvm/vmx/vmx.h    |    3 ++-
 3 files changed, 17 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -303,7 +303,7 @@ static void vmx_switch_vmcs(struct kvm_v
 	cpu = get_cpu();
 	prev = vmx->loaded_vmcs;
 	vmx->loaded_vmcs = vmcs;
-	vmx_vcpu_load_vmcs(vcpu, cpu);
+	vmx_vcpu_load_vmcs(vcpu, cpu, prev);
 	vmx_sync_vmcs_host_state(vmx, prev);
 	put_cpu();
 
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1314,10 +1314,12 @@ after_clear_sn:
 		pi_set_on(pi_desc);
 }
 
-void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu)
+void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
+			struct loaded_vmcs *buddy)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	bool already_loaded = vmx->loaded_vmcs->cpu == cpu;
+	struct vmcs *prev;
 
 	if (!already_loaded) {
 		loaded_vmcs_clear(vmx->loaded_vmcs);
@@ -1336,10 +1338,18 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu
 		local_irq_enable();
 	}
 
-	if (per_cpu(current_vmcs, cpu) != vmx->loaded_vmcs->vmcs) {
+	prev = per_cpu(current_vmcs, cpu);
+	if (prev != vmx->loaded_vmcs->vmcs) {
 		per_cpu(current_vmcs, cpu) = vmx->loaded_vmcs->vmcs;
 		vmcs_load(vmx->loaded_vmcs->vmcs);
-		indirect_branch_prediction_barrier();
+
+		/*
+		 * No indirect branch prediction barrier needed when switching
+		 * the active VMCS within a guest, e.g. on nested VM-Enter.
+		 * The L1 VMM can protect itself with retpolines, IBPB or IBRS.
+		 */
+		if (!buddy || WARN_ON_ONCE(buddy->vmcs != prev))
+			indirect_branch_prediction_barrier();
 	}
 
 	if (!already_loaded) {
@@ -1376,7 +1386,7 @@ void vmx_vcpu_load(struct kvm_vcpu *vcpu
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	vmx_vcpu_load_vmcs(vcpu, cpu);
+	vmx_vcpu_load_vmcs(vcpu, cpu, NULL);
 
 	vmx_vcpu_pi_load(vcpu, cpu);
 
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -320,7 +320,8 @@ struct kvm_vmx {
 };
 
 bool nested_vmx_allowed(struct kvm_vcpu *vcpu);
-void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu);
+void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
+			struct loaded_vmcs *buddy);
 void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 int allocate_vpid(void);
 void free_vpid(int vpid);


