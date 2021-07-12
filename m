Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473A03C4914
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238673AbhGLGlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:41:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235525AbhGLGke (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:40:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93E7161008;
        Mon, 12 Jul 2021 06:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071865;
        bh=3uwHj5ZvFV2+QnoSrzJdCqBrKsdO6ouUtOuHwHd5OWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EbaHCMpwlZWeMqa0q4hms0qF6Z+BOtqJ1ktwvld92ALlOxbyVi5mzNTNmPm6WsBGG
         HzbhcadjVUFhFrWeuAVg1eOM4M69M6DCPMjjuzLngjKeTQYEuS3bF0G61fGYScQ2M8
         oTVXBW1AmBm6NoFhWaC3PhIXqr/ZqVPk+Gtp4Qw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 254/593] KVM: nVMX: Sync all PGDs on nested transition with shadow paging
Date:   Mon, 12 Jul 2021 08:06:54 +0200
Message-Id: <20210712060910.950212439@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 07ffaf343e34b555c9e7ea39a9c81c439a706f13 ]

Trigger a full TLB flush on behalf of the guest on nested VM-Enter and
VM-Exit when VPID is disabled for L2.  kvm_mmu_new_pgd() syncs only the
current PGD, which can theoretically leave stale, unsync'd entries in a
previous guest PGD, which could be consumed if L2 is allowed to load CR3
with PCID_NOFLUSH=1.

Rename KVM_REQ_HV_TLB_FLUSH to KVM_REQ_TLB_FLUSH_GUEST so that it can
be utilized for its obvious purpose of emulating a guest TLB flush.

Note, there is no change the actual TLB flush executed by KVM, even
though the fast PGD switch uses KVM_REQ_TLB_FLUSH_CURRENT.  When VPID is
disabled for L2, vpid02 is guaranteed to be '0', and thus
nested_get_vpid02() will return the VPID that is shared by L1 and L2.

Generate the request outside of kvm_mmu_new_pgd(), as getting the common
helper to correctly identify which requested is needed is quite painful.
E.g. using KVM_REQ_TLB_FLUSH_GUEST when nested EPT is in play is wrong as
a TLB flush from the L1 kernel's perspective does not invalidate EPT
mappings.  And, by using KVM_REQ_TLB_FLUSH_GUEST, nVMX can do future
simplification by moving the logic into nested_vmx_transition_tlb_flush().

Fixes: 41fab65e7c44 ("KVM: nVMX: Skip MMU sync on nested VMX transition when possible")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210609234235.1244004-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/hyperv.c           |  2 +-
 arch/x86/kvm/vmx/nested.c       | 17 ++++++++++++-----
 arch/x86/kvm/x86.c              |  2 +-
 4 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d1ac2de41ea8..b1cd8334db11 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -84,7 +84,7 @@
 #define KVM_REQ_APICV_UPDATE \
 	KVM_ARCH_REQ_FLAGS(25, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_TLB_FLUSH_CURRENT	KVM_ARCH_REQ(26)
-#define KVM_REQ_HV_TLB_FLUSH \
+#define KVM_REQ_TLB_FLUSH_GUEST \
 	KVM_ARCH_REQ_FLAGS(27, KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_APF_READY		KVM_ARCH_REQ(28)
 #define KVM_REQ_MSR_FILTER_CHANGED	KVM_ARCH_REQ(29)
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 5c7c4060b45c..bb39f493447c 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1564,7 +1564,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *current_vcpu, u64 ingpa,
 	 * vcpu->arch.cr3 may not be up-to-date for running vCPUs so we can't
 	 * analyze it here, flush TLB regardless of the specified address space.
 	 */
-	kvm_make_vcpus_request_mask(kvm, KVM_REQ_HV_TLB_FLUSH,
+	kvm_make_vcpus_request_mask(kvm, KVM_REQ_TLB_FLUSH_GUEST,
 				    NULL, vcpu_mask, &hv_vcpu->tlb_flush);
 
 ret_success:
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ec8803bdc575..4cd998bb1f0a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1142,12 +1142,19 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
 
 	/*
 	 * Unconditionally skip the TLB flush on fast CR3 switch, all TLB
-	 * flushes are handled by nested_vmx_transition_tlb_flush().  See
-	 * nested_vmx_transition_mmu_sync for details on skipping the MMU sync.
+	 * flushes are handled by nested_vmx_transition_tlb_flush().
 	 */
-	if (!nested_ept)
-		kvm_mmu_new_pgd(vcpu, cr3, true,
-				!nested_vmx_transition_mmu_sync(vcpu));
+	if (!nested_ept) {
+		kvm_mmu_new_pgd(vcpu, cr3, true, true);
+
+		/*
+		 * A TLB flush on VM-Enter/VM-Exit flushes all linear mappings
+		 * across all PCIDs, i.e. all PGDs need to be synchronized.
+		 * See nested_vmx_transition_mmu_sync() for more details.
+		 */
+		if (nested_vmx_transition_mmu_sync(vcpu))
+			kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
+	}
 
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d3372cb97307..7bf88e6cbd0e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8852,7 +8852,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		}
 		if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
 			kvm_vcpu_flush_tlb_current(vcpu);
-		if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu))
+		if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu))
 			kvm_vcpu_flush_tlb_guest(vcpu);
 
 		if (kvm_check_request(KVM_REQ_REPORT_TPR_ACCESS, vcpu)) {
-- 
2.30.2



