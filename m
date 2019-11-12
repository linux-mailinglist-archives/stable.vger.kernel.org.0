Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 022B9F9E78
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 00:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfKLXuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 18:50:35 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57278 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726912AbfKLXue (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 18:50:34 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iUfvc-0008Hz-SO; Tue, 12 Nov 2019 23:50:32 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iUfvc-00056Q-CW; Tue, 12 Nov 2019 23:50:32 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>
Date:   Tue, 12 Nov 2019 23:47:58 +0000
Message-ID: <lsq.1573602477.270388076@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 01/25] KVM: Introduce kvm_get_arch_capabilities()
In-Reply-To: <lsq.1573602477.548403712@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.77-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

Extracted from commit 5b76a3cff011 "KVM: VMX: Tell the nested
hypervisor to skip L1D flush on vmentry".  We will need this to let a
nested hypervisor know that we have applied the mitigation for TAA.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 13 +++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1062,6 +1062,7 @@ int kvm_arch_interrupt_allowed(struct kv
 int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu);
 
+u64 kvm_get_arch_capabilities(void);
 void kvm_define_shared_msr(unsigned index, u32 msr);
 int kvm_set_shared_msr(unsigned index, u64 val, u64 mask);
 
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -911,6 +911,16 @@ static u32 emulated_msrs[] = {
 
 static unsigned num_emulated_msrs;
 
+u64 kvm_get_arch_capabilities(void)
+{
+	u64 data;
+
+	rdmsrl_safe(MSR_IA32_ARCH_CAPABILITIES, &data);
+
+	return data;
+}
+EXPORT_SYMBOL_GPL(kvm_get_arch_capabilities);
+
 bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
 	if (efer & efer_reserved_bits)
@@ -6969,8 +6979,7 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu
 	int r;
 
 	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
-		rdmsrl(MSR_IA32_ARCH_CAPABILITIES,
-		       vcpu->arch.arch_capabilities);
+		vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
 	vcpu->arch.mtrr_state.have_fixed = 1;
 	r = vcpu_load(vcpu);
 	if (r)

