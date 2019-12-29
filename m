Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49DA412C8F6
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387586AbfL2R6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:58:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:49872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387580AbfL2R6m (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:58:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4A03208C4;
        Sun, 29 Dec 2019 17:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642321;
        bh=0muCiBuOOlJaovfLwFWGxQFz4txbwFrvfXyRzNKQnvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e3T7R/SKD7Tu3vxEgwFos5McIyFBeDcWnuf7/ycmDE8KrL5Tw+W7V4e4KA7XoWFWX
         FZv30AmbdhbiAdc4QpUT/fYCIXfLIjpMKHFi50OlOsw0cKFeFjsyWbk2K6r05E6vo4
         UKff3yOX4WtKyg5yJwqOAHwMZOC32aaXEhcbYQdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.4 418/434] KVM: arm/arm64: Properly handle faulting of device mappings
Date:   Sun, 29 Dec 2019 18:27:51 +0100
Message-Id: <20191229172730.752949737@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 6d674e28f642e3ff676fbae2d8d1b872814d32b6 upstream.

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

Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: James Morse <james.morse@arm.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191211165651.7889-2-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/arm/mmu.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

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
@@ -1698,6 +1703,7 @@ static int user_mem_abort(struct kvm_vcp
 
 	vma_pagesize = vma_kernel_pagesize(vma);
 	if (logging_active ||
+	    (vma->vm_flags & VM_PFNMAP) ||
 	    !fault_supports_stage2_huge_mapping(memslot, hva, vma_pagesize)) {
 		force_pte = true;
 		vma_pagesize = PAGE_SIZE;
@@ -1760,6 +1766,9 @@ static int user_mem_abort(struct kvm_vcp
 			writable = false;
 	}
 
+	if (exec_fault && is_iomap(flags))
+		return -ENOEXEC;
+
 	spin_lock(&kvm->mmu_lock);
 	if (mmu_notifier_retry(kvm, mmu_seq))
 		goto out_unlock;
@@ -1781,7 +1790,7 @@ static int user_mem_abort(struct kvm_vcp
 	if (writable)
 		kvm_set_pfn_dirty(pfn);
 
-	if (fault_status != FSC_PERM)
+	if (fault_status != FSC_PERM && !is_iomap(flags))
 		clean_dcache_guest_page(pfn, vma_pagesize);
 
 	if (exec_fault)
@@ -1948,9 +1957,8 @@ int kvm_handle_guest_abort(struct kvm_vc
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
@@ -1992,6 +2000,11 @@ int kvm_handle_guest_abort(struct kvm_vc
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


