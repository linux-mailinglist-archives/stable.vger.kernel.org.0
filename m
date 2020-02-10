Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9968A1578E7
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgBJNLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:11:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:36012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729310AbgBJMjF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:05 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B09520838;
        Mon, 10 Feb 2020 12:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338345;
        bh=stNVyTyhlw4K7NxlfNMtoqGcTC9wLRXZt5AH3WVXlRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pRACD6TWSgov1+RXFIRni+8vdODdv+hkxwcgtFz0XG4rsPPkV+azvhIAeqUj9jkhI
         Yqdd3W+ZQRorp7/LVVJkpMbYk0CZ/iZF8yCyD0HQVrKJJqxwiHC9hzcso/tH/jPf4j
         yJWsJZ1UuKLYDwqP1D/2B/tOT3b7cx5Ty8K+hkG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 300/309] KVM: Use vcpu-specific gva->hva translation when querying host page size
Date:   Mon, 10 Feb 2020 04:34:16 -0800
Message-Id: <20200210122435.696054911@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

[ Upstream commit f9b84e19221efc5f493156ee0329df3142085f28 ]

Use kvm_vcpu_gfn_to_hva() when retrieving the host page size so that the
correct set of memslots is used when handling x86 page faults in SMM.

Fixes: 54bf36aac520 ("KVM: x86: use vcpu-specific functions to read/write/translate GFNs")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_xive_native.c | 2 +-
 arch/x86/kvm/mmu.c                    | 6 +++---
 include/linux/kvm_host.h              | 2 +-
 virt/kvm/kvm_main.c                   | 4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index 5a3373e06e60b..235d57d6c205e 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -638,7 +638,7 @@ static int kvmppc_xive_native_set_queue_config(struct kvmppc_xive *xive,
 	srcu_idx = srcu_read_lock(&kvm->srcu);
 	gfn = gpa_to_gfn(kvm_eq.qaddr);
 
-	page_size = kvm_host_page_size(kvm, gfn);
+	page_size = kvm_host_page_size(vcpu, gfn);
 	if (1ull << kvm_eq.qshift > page_size) {
 		srcu_read_unlock(&kvm->srcu, srcu_idx);
 		pr_warn("Incompatible host page size %lx!\n", page_size);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 46070da9e08f8..518100ea5ef47 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1286,12 +1286,12 @@ static bool mmu_gfn_lpage_is_disallowed(struct kvm_vcpu *vcpu, gfn_t gfn,
 	return __mmu_gfn_lpage_is_disallowed(gfn, level, slot);
 }
 
-static int host_mapping_level(struct kvm *kvm, gfn_t gfn)
+static int host_mapping_level(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
 	unsigned long page_size;
 	int i, ret = 0;
 
-	page_size = kvm_host_page_size(kvm, gfn);
+	page_size = kvm_host_page_size(vcpu, gfn);
 
 	for (i = PT_PAGE_TABLE_LEVEL; i <= PT_MAX_HUGEPAGE_LEVEL; ++i) {
 		if (page_size >= KVM_HPAGE_SIZE(i))
@@ -1341,7 +1341,7 @@ static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn,
 	if (unlikely(*force_pt_level))
 		return PT_PAGE_TABLE_LEVEL;
 
-	host_level = host_mapping_level(vcpu->kvm, large_gfn);
+	host_level = host_mapping_level(vcpu, large_gfn);
 
 	if (host_level == PT_PAGE_TABLE_LEVEL)
 		return host_level;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7d1564c408972..b81f0f1ded5f9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -751,7 +751,7 @@ int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len);
 int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
-unsigned long kvm_host_page_size(struct kvm *kvm, gfn_t gfn);
+unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 
 struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6f0287ad927ee..877ce955b99cf 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1394,14 +1394,14 @@ bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(kvm_is_visible_gfn);
 
-unsigned long kvm_host_page_size(struct kvm *kvm, gfn_t gfn)
+unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
 	struct vm_area_struct *vma;
 	unsigned long addr, size;
 
 	size = PAGE_SIZE;
 
-	addr = gfn_to_hva(kvm, gfn);
+	addr = kvm_vcpu_gfn_to_hva(vcpu, gfn);
 	if (kvm_is_error_hva(addr))
 		return PAGE_SIZE;
 
-- 
2.20.1



