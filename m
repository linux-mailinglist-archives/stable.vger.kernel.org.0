Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACAC11B959
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730510AbfLKQ5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:57:10 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:36508 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726444AbfLKQ5K (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 11:57:10 -0500
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1if5IO-00076q-HF; Wed, 11 Dec 2019 17:57:04 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/3] KVM: arm/arm64: Properly handle faulting of device mappings
Date:   Wed, 11 Dec 2019 16:56:48 +0000
Message-Id: <20191211165651.7889-2-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211165651.7889-1-maz@kernel.org>
References: <20191211165651.7889-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, Christoffer.Dall@arm.com, alexandru.elisei@arm.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A device mapping is normally always mapped at Stage-2, since there
is very little gain in having it faulted in.

Nonetheless, it is possible to end-up in a situation where the device
mapping has been removed from Stage-2 (userspace munmaped the VFIO
region, and the MMU notifier did its job), but present in a userspace
mapping (userpace has mapped it back at the same address). In such
a situation, the device mapping will be demand-paged as the guest
performs memory accesses.

This requires to be careful when dealing with mapping size, cache
management, and to handle potential execution of a device mapping.

Cc: stable@vger.kernel.org
Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/mmu.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index a48994af70b8..0b32a904a1bb 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -38,6 +38,11 @@ static unsigned long io_map_base;
 #define KVM_S2PTE_FLAG_IS_IOMAP		(1UL << 0)
 #define KVM_S2_FLAG_LOGGING_ACTIVE	(1UL << 1)
 
+static bool is_iomap(unsigned long flags)
+{
+	return flags & KVM_S2PTE_FLAG_IS_IOMAP;
+}
+
 static bool memslot_is_logging(struct kvm_memory_slot *memslot)
 {
 	return memslot->dirty_bitmap && !(memslot->flags & KVM_MEM_READONLY);
@@ -1698,6 +1703,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	vma_pagesize = vma_kernel_pagesize(vma);
 	if (logging_active ||
+	    (vma->vm_flags & VM_PFNMAP) ||
 	    !fault_supports_stage2_huge_mapping(memslot, hva, vma_pagesize)) {
 		force_pte = true;
 		vma_pagesize = PAGE_SIZE;
@@ -1760,6 +1766,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			writable = false;
 	}
 
+	if (exec_fault && is_iomap(flags))
+		return -ENOEXEC;
+
 	spin_lock(&kvm->mmu_lock);
 	if (mmu_notifier_retry(kvm, mmu_seq))
 		goto out_unlock;
@@ -1781,7 +1790,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (writable)
 		kvm_set_pfn_dirty(pfn);
 
-	if (fault_status != FSC_PERM)
+	if (fault_status != FSC_PERM && !is_iomap(flags))
 		clean_dcache_guest_page(pfn, vma_pagesize);
 
 	if (exec_fault)
@@ -1948,9 +1957,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
 		if (is_iabt) {
 			/* Prefetch Abort on I/O address */
-			kvm_inject_pabt(vcpu, kvm_vcpu_get_hfar(vcpu));
-			ret = 1;
-			goto out_unlock;
+			ret = -ENOEXEC;
+			goto out;
 		}
 
 		/*
@@ -1992,6 +2000,11 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	ret = user_mem_abort(vcpu, fault_ipa, memslot, hva, fault_status);
 	if (ret == 0)
 		ret = 1;
+out:
+	if (ret == -ENOEXEC) {
+		kvm_inject_pabt(vcpu, kvm_vcpu_get_hfar(vcpu));
+		ret = 1;
+	}
 out_unlock:
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	return ret;
-- 
2.20.1

