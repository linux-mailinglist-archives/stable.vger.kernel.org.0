Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C46CD157B34
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbgBJN2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:28:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:55826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728388AbgBJMg1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:27 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 187CD215A4;
        Mon, 10 Feb 2020 12:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338187;
        bh=6zItTiCpc9oCGp4fkMlEtJddP9GZYoAhQWpUekeAWos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tctkKaZH7AHiICDoeeUgZoCk1+cxac60v1XbTuI6UfMiRxd24e086wt8/M0HFrDyo
         e06oykDfFka854zUil85NlxiNFkDdHlwkQFfrC4gVh83O7JnIFZyCaam2C1oL3YTuX
         QufnudV/lB7LiWHkz8oJzwh7ibQxu2gyak2G5Nzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 186/195] KVM: Use vcpu-specific gva->hva translation when querying host page size
Date:   Mon, 10 Feb 2020 04:34:04 -0800
Message-Id: <20200210122323.415710561@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
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
 arch/x86/kvm/mmu.c       | 6 +++---
 include/linux/kvm_host.h | 2 +-
 virt/kvm/kvm_main.c      | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index e878b4cc8359d..62f1e4663bc3c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1184,12 +1184,12 @@ static bool mmu_gfn_lpage_is_disallowed(struct kvm_vcpu *vcpu, gfn_t gfn,
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
@@ -1239,7 +1239,7 @@ static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn,
 	if (unlikely(*force_pt_level))
 		return PT_PAGE_TABLE_LEVEL;
 
-	host_level = host_mapping_level(vcpu->kvm, large_gfn);
+	host_level = host_mapping_level(vcpu, large_gfn);
 
 	if (host_level == PT_PAGE_TABLE_LEVEL)
 		return host_level;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f6394fd4b284b..0f99ecc01bc7d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -704,7 +704,7 @@ int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len);
 int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
-unsigned long kvm_host_page_size(struct kvm *kvm, gfn_t gfn);
+unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 
 struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9502b1a44232c..df7ece0bfcbd3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1294,14 +1294,14 @@ bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
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



