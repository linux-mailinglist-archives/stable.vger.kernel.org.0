Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2204423596
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391206AbfETMgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:36:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391200AbfETMgD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:36:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECB2B20815;
        Mon, 20 May 2019 12:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355762;
        bh=OY5qDbJG3cRSO+yxmiSW4AJSiJga1+mxbJUEfBPaWNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hoOAgfDhtUyLU0MHUy3Q/CyeTOzAc6oA4PhPlEM3NroGeRJMPnKpq3UzsZbk6hs++
         hsqFK02W34Ph0BzljOQfl4FT8hLCt9lyAxhRLwEwIT5bjBkwPp8Wm5aRfnhBSJu2Af
         HKOon2wQ7TID0E5jJ1q5bATo4URotlLJOTnM5nHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hill <hilld@binarystorm.net>,
        Saar Amar <saaramar@microsoft.com>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.1 115/128] Revert "KVM: nVMX: Expose RDPMC-exiting only when guest supports PMU"
Date:   Mon, 20 May 2019 14:15:02 +0200
Message-Id: <20190520115256.600424113@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit f93f7ede087f2edcc18e4b02310df5749a6b5a61 upstream.

The RDPMC-exiting control is dependent on the existence of the RDPMC
instruction itself, i.e. is not tied to the "Architectural Performance
Monitoring" feature.  For all intents and purposes, the control exists
on all CPUs with VMX support since RDPMC also exists on all VCPUs with
VMX supported.  Per Intel's SDM:

  The RDPMC instruction was introduced into the IA-32 Architecture in
  the Pentium Pro processor and the Pentium processor with MMX technology.
  The earlier Pentium processors have performance-monitoring counters, but
  they must be read with the RDMSR instruction.

Because RDPMC-exiting always exists, KVM requires the control and refuses
to load if it's not available.  As a result, hiding the PMU from a guest
breaks nested virtualization if the guest attemts to use KVM.

While it's not explicitly stated in the RDPMC pseudocode, the VM-Exit
check for RDPMC-exiting follows standard fault vs. VM-Exit prioritization
for privileged instructions, e.g. occurs after the CPL/CR0.PE/CR4.PCE
checks, but before the counter referenced in ECX is checked for validity.

In other words, the original KVM behavior of injecting a #GP was correct,
and the KVM unit test needs to be adjusted accordingly, e.g. eat the #GP
when the unit test guest (L3 in this case) executes RDPMC without
RDPMC-exiting set in the unit test host (L2).

This reverts commit e51bfdb68725dc052d16241ace40ea3140f938aa.

Fixes: e51bfdb68725 ("KVM: nVMX: Expose RDPMC-exiting only when guest supports PMU")
Reported-by: David Hill <hilld@binarystorm.net>
Cc: Saar Amar <saaramar@microsoft.com>
Cc: Mihai Carabas <mihai.carabas@oracle.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Liran Alon <liran.alon@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx/vmx.c |   25 -------------------------
 1 file changed, 25 deletions(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6856,30 +6856,6 @@ static void nested_vmx_entry_exit_ctls_u
 	}
 }
 
-static bool guest_cpuid_has_pmu(struct kvm_vcpu *vcpu)
-{
-	struct kvm_cpuid_entry2 *entry;
-	union cpuid10_eax eax;
-
-	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
-	if (!entry)
-		return false;
-
-	eax.full = entry->eax;
-	return (eax.split.version_id > 0);
-}
-
-static void nested_vmx_procbased_ctls_update(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	bool pmu_enabled = guest_cpuid_has_pmu(vcpu);
-
-	if (pmu_enabled)
-		vmx->nested.msrs.procbased_ctls_high |= CPU_BASED_RDPMC_EXITING;
-	else
-		vmx->nested.msrs.procbased_ctls_high &= ~CPU_BASED_RDPMC_EXITING;
-}
-
 static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -6968,7 +6944,6 @@ static void vmx_cpuid_update(struct kvm_
 	if (nested_vmx_allowed(vcpu)) {
 		nested_vmx_cr_fixed1_bits_update(vcpu);
 		nested_vmx_entry_exit_ctls_update(vcpu);
-		nested_vmx_procbased_ctls_update(vcpu);
 	}
 
 	if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&


