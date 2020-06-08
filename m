Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE8E1F2325
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbgFHXNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:13:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729198AbgFHXNB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:13:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7222421501;
        Mon,  8 Jun 2020 23:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657980;
        bh=576Ow5ZT61zgY2FffwPpL3/kpHTlNTB4V+Udpiiiqq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kl9DaJ8Jud5+lA0O8Cw647Q1Yq4UG5neNJiSX5xdCu/aMCKfFl/e0BL/DUvlpqwvO
         T6u1ORcsg3Mx60qdG+UbF7pS5dcpSCTczakDVDWuQ/P75ihIf62PYItsm4Lrwmn5hp
         XNN416SO1EuIDkAVQU5ls+SsSf59w1fTECXG8dJI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Babu Moger <babu.moger@amd.com>, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 041/606] KVM: x86: Fix pkru save/restore when guest CR4.PKE=0, move it to x86.c
Date:   Mon,  8 Jun 2020 19:02:46 -0400
Message-Id: <20200608231211.3363633-41-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Babu Moger <babu.moger@amd.com>

commit 37486135d3a7b03acc7755b63627a130437f066a upstream.

Though rdpkru and wrpkru are contingent upon CR4.PKE, the PKRU
resource isn't. It can be read with XSAVE and written with XRSTOR.
So, if we don't set the guest PKRU value here(kvm_load_guest_xsave_state),
the guest can read the host value.

In case of kvm_load_host_xsave_state, guest with CR4.PKE clear could
potentially use XRSTOR to change the host PKRU value.

While at it, move pkru state save/restore to common code and the
host_pkru field to kvm_vcpu_arch.  This will let SVM support protection keys.

Cc: stable@vger.kernel.org
Reported-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Babu Moger <babu.moger@amd.com>
Message-Id: <158932794619.44260.14508381096663848853.stgit@naples-babu.amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/vmx.c          | 18 ------------------
 arch/x86/kvm/x86.c              | 17 +++++++++++++++++
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7ba99c0759cf..c121b8f24597 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -574,6 +574,7 @@ struct kvm_vcpu_arch {
 	unsigned long cr4;
 	unsigned long cr4_guest_owned_bits;
 	unsigned long cr8;
+	u32 host_pkru;
 	u32 pkru;
 	u32 hflags;
 	u64 efer;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c1ffe7d24f83..a83c94a971ee 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1380,7 +1380,6 @@ void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	vmx_vcpu_pi_load(vcpu, cpu);
 
-	vmx->host_pkru = read_pkru();
 	vmx->host_debugctlmsr = get_debugctlmsr();
 }
 
@@ -6538,11 +6537,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	kvm_load_guest_xsave_state(vcpu);
 
-	if (static_cpu_has(X86_FEATURE_PKU) &&
-	    kvm_read_cr4_bits(vcpu, X86_CR4_PKE) &&
-	    vcpu->arch.pkru != vmx->host_pkru)
-		__write_pkru(vcpu->arch.pkru);
-
 	pt_guest_enter(vmx);
 
 	atomic_switch_perf_msrs(vmx);
@@ -6631,18 +6625,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	pt_guest_exit(vmx);
 
-	/*
-	 * eager fpu is enabled if PKEY is supported and CR4 is switched
-	 * back on host, so it is safe to read guest PKRU from current
-	 * XSAVE.
-	 */
-	if (static_cpu_has(X86_FEATURE_PKU) &&
-	    kvm_read_cr4_bits(vcpu, X86_CR4_PKE)) {
-		vcpu->arch.pkru = rdpkru();
-		if (vcpu->arch.pkru != vmx->host_pkru)
-			__write_pkru(vmx->host_pkru);
-	}
-
 	kvm_load_host_xsave_state(vcpu);
 
 	vmx->nested.nested_run_pending = 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 17650bda4331..56a21dd7c1a0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -809,11 +809,25 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
 		    vcpu->arch.ia32_xss != host_xss)
 			wrmsrl(MSR_IA32_XSS, vcpu->arch.ia32_xss);
 	}
+
+	if (static_cpu_has(X86_FEATURE_PKU) &&
+	    (kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
+	     (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU)) &&
+	    vcpu->arch.pkru != vcpu->arch.host_pkru)
+		__write_pkru(vcpu->arch.pkru);
 }
 EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
 
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
 {
+	if (static_cpu_has(X86_FEATURE_PKU) &&
+	    (kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
+	     (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU))) {
+		vcpu->arch.pkru = rdpkru();
+		if (vcpu->arch.pkru != vcpu->arch.host_pkru)
+			__write_pkru(vcpu->arch.host_pkru);
+	}
+
 	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE)) {
 
 		if (vcpu->arch.xcr0 != host_xcr0)
@@ -3529,6 +3543,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	kvm_x86_ops->vcpu_load(vcpu, cpu);
 
+	/* Save host pkru register if supported */
+	vcpu->arch.host_pkru = read_pkru();
+
 	/* Apply any externally detected TSC adjustments (due to suspend) */
 	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
 		adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_adjustment);
-- 
2.25.1

