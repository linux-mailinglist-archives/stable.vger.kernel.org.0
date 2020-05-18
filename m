Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A460B1D842B
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732570AbgERSJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:09:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733087AbgERSGN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:06:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46E57207D3;
        Mon, 18 May 2020 18:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825172;
        bh=v2D+En1nhWCpIG+58dalIczcVQYoWdoRBY62R/ukpgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JzYY0Z+P55wUJBWLS39IG109L6J1mfuaWuLxbP6/+Pu6RhIuCRZvhEvBw1q85bO/S
         8cgHTNC5lJiSJnVyC2bi2ty2XRxviefw6Tlhm0UBr7affMRzJ4V99Saf8kN8EayPpA
         8q8TnQNRypGqYCpbx/9c3rkjNDkkUwCAiptF9sew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Babu Moger <babu.moger@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.6 157/194] KVM: x86: Fix pkru save/restore when guest CR4.PKE=0, move it to x86.c
Date:   Mon, 18 May 2020 19:37:27 +0200
Message-Id: <20200518173544.277402015@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/vmx/vmx.c          |   18 ------------------
 arch/x86/kvm/x86.c              |   17 +++++++++++++++++
 3 files changed, 18 insertions(+), 18 deletions(-)

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
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1380,7 +1380,6 @@ void vmx_vcpu_load(struct kvm_vcpu *vcpu
 
 	vmx_vcpu_pi_load(vcpu, cpu);
 
-	vmx->host_pkru = read_pkru();
 	vmx->host_debugctlmsr = get_debugctlmsr();
 }
 
@@ -6538,11 +6537,6 @@ static void vmx_vcpu_run(struct kvm_vcpu
 
 	kvm_load_guest_xsave_state(vcpu);
 
-	if (static_cpu_has(X86_FEATURE_PKU) &&
-	    kvm_read_cr4_bits(vcpu, X86_CR4_PKE) &&
-	    vcpu->arch.pkru != vmx->host_pkru)
-		__write_pkru(vcpu->arch.pkru);
-
 	pt_guest_enter(vmx);
 
 	atomic_switch_perf_msrs(vmx);
@@ -6631,18 +6625,6 @@ static void vmx_vcpu_run(struct kvm_vcpu
 
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
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -809,11 +809,25 @@ void kvm_load_guest_xsave_state(struct k
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
@@ -3529,6 +3543,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu
 
 	kvm_x86_ops->vcpu_load(vcpu, cpu);
 
+	/* Save host pkru register if supported */
+	vcpu->arch.host_pkru = read_pkru();
+
 	/* Apply any externally detected TSC adjustments (due to suspend) */
 	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
 		adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_adjustment);


