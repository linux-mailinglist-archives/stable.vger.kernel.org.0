Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37EB6156AB6
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbgBINnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:43:45 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45405 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727752AbgBINnp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:43:45 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 6A2AD21AD2;
        Sun,  9 Feb 2020 08:43:44 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:43:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=w8HZKs
        NAQdzZ/i7kGs1GoYR71ebzKsepwga9I7b1Ng0=; b=ICSNNXypl1V/ctfKTYhrYF
        7EMr1pE22VHYEKZCi/WWItXDaDFmdfJHcZtI/0jZHClrsMKEe/dcdGBPuQ/qEbEB
        Y84qHvlpGigookaVfin1m6RPfP+dKhbVijqRXg9qbX8rjwUr8JGNY+SpyzqLYNLI
        ZtTiGDQQ4dPTj/9aE1JFaemWLUkIYjm0qoJ1sMW6xJgUyLDrji5HsLxrFjWJRhTb
        quTjvnCQHcqeh3JkoaoHIC591PS+sxsgM4FxAlYTUJaN8r7qd0yqUwcyXEI6x31i
        LEVBIpX6XnLiIs2KWxHMGw25u4xzK3D7ztnTA/xTCawpsoy3rO2gDGVW9y8rDujA
        ==
X-ME-Sender: <xms:kAxAXubI_8DGiWRuggG4PTu4PssKL8ukxFwe_wtrT3ZLQ-SWl2Bxtg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepudegne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:kAxAXrDgA3_R9SKdLt7uhILcwDBXSJr1i0Xd4shMHfgtvC9a4ghdGQ>
    <xmx:kAxAXo_ClgRbBt_WHwsX-UVFSDdjY05R-kAamGPlE9LJ-sOZtktWnw>
    <xmx:kAxAXj9ZT_npib4h7vu3700mXGS3rnaMk7N4KxjBM5SV-alrdoilPA>
    <xmx:kAxAXlKij63FO23A7aPlYLzznJIFcfAyVHXfeomHY1UcZg9i5BYmwQ>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2AF9A3060272;
        Sun,  9 Feb 2020 08:43:43 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: Use vcpu-specific gva->hva translation when querying" failed to apply to 4.4-stable tree
To:     sean.j.christopherson@intel.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 13:36:42 +0100
Message-ID: <158125180212516@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f9b84e19221efc5f493156ee0329df3142085f28 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Wed, 8 Jan 2020 12:24:37 -0800
Subject: [PATCH] KVM: Use vcpu-specific gva->hva translation when querying
 host page size

Use kvm_vcpu_gfn_to_hva() when retrieving the host page size so that the
correct set of memslots is used when handling x86 page faults in SMM.

Fixes: 54bf36aac520 ("KVM: x86: use vcpu-specific functions to read/write/translate GFNs")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index d83adb1e1490..6ef0151ff70a 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -631,7 +631,7 @@ static int kvmppc_xive_native_set_queue_config(struct kvmppc_xive *xive,
 	srcu_idx = srcu_read_lock(&kvm->srcu);
 	gfn = gpa_to_gfn(kvm_eq.qaddr);
 
-	page_size = kvm_host_page_size(kvm, gfn);
+	page_size = kvm_host_page_size(vcpu, gfn);
 	if (1ull << kvm_eq.qshift > page_size) {
 		srcu_read_unlock(&kvm->srcu, srcu_idx);
 		pr_warn("Incompatible host page size %lx!\n", page_size);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7eb21a22cc13..e4458c9aec8c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
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
@@ -1362,7 +1362,7 @@ static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn,
 	 * So, do not propagate host_mapping_level() to max_level as KVM can
 	 * still promote the guest mapping to a huge page in the THP case.
 	 */
-	host_level = host_mapping_level(vcpu->kvm, large_gfn);
+	host_level = host_mapping_level(vcpu, large_gfn);
 	return min(host_level, max_level);
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 46fdb7533678..6d5331b0d937 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -762,7 +762,7 @@ int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len);
 int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
-unsigned long kvm_host_page_size(struct kvm *kvm, gfn_t gfn);
+unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 
 struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 64e9e9d65ed4..f6f8ffc2e865 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1402,14 +1402,14 @@ bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
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
 

