Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC2E627B2D
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 11:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235836AbiKNK6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 05:58:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235758AbiKNK6N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 05:58:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1861AF0D
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 02:58:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 260B460C96
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 10:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D96EC433C1;
        Mon, 14 Nov 2022 10:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668423491;
        bh=LVSFRH3UQPb7wwmFPNmumE8R0dhiezGdPDEktTJGtdM=;
        h=Subject:To:Cc:From:Date:From;
        b=Hgq/YCOj3xPKCbuGdYZdfFhkZyfsJOgAjGhni90Bckg3txvbS9s8UTqfwLt6Jqstt
         ccjq1ZUFxxI8wbUAEKrJvkEkqU+PIKCFF1WDLov7YJKAuVUa39PFse10Wk716N88hO
         N+VBy8FHyeYTLgqK88StY8fNMNB0cJUn9v15okdI=
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Block all page faults during" failed to apply to 5.15-stable tree
To:     seanjc@google.com, chao.p.peng@linux.intel.com,
        mlevitsk@redhat.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Nov 2022 11:58:08 +0100
Message-ID: <166842348814479@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

6d3085e4d89a ("KVM: x86/mmu: Block all page faults during kvm_zap_gfn_range()")
20ec3ebd707c ("KVM: Rename mmu_notifier_* to mmu_invalidate_*")
65e3b446bcce ("KVM: x86/mmu: Document the "rules" for using host_pfn_mapping_level()")
a8ac499bb6ab ("KVM: x86/mmu: Don't require refcounted "struct page" to create huge SPTEs")
9202aee816c8 ("KVM: x86/mmu: Rename pte_list_{destroy,remove}() to show they zap SPTEs")
a42989e7fbb0 ("KVM: x86/mmu: Directly "destroy" PTE list when recycling rmaps")
2ff9039a75a8 ("KVM: x86/mmu: Decouple rmap_add() and link_shadow_page() from kvm_vcpu")
6ec6509eea39 ("KVM: x86/mmu: Pass const memslot to rmap_add()")
5d49f08c2e08 ("KVM: x86/mmu: Shove refcounted page dependency into host_pfn_mapping_level()")
b14b2690c50e ("KVM: Rename/refactor kvm_is_reserved_pfn() to kvm_pfn_to_refcounted_page()")
284dc4930773 ("KVM: Take a 'struct page', not a pfn in kvm_is_zone_device_page()")
b1624f99aa8f ("KVM: Remove kvm_vcpu_gfn_to_page() and kvm_vcpu_gpa_to_page()")
6573a6910ce4 ("KVM: Don't WARN if kvm_pfn_to_page() encounters a "reserved" pfn")
8e1c69149f27 ("KVM: Avoid pfn_to_page() and vice versa when releasing pages")
a1040b0d42ac ("KVM: Don't set Accessed/Dirty bits for ZERO_PAGE")
b31455e96f00 ("Merge branch 'kvm-5.20-early-patches' into HEAD")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6d3085e4d89ad7e6c7f1c6cf929d903393565861 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 11 Nov 2022 00:18:41 +0000
Subject: [PATCH] KVM: x86/mmu: Block all page faults during
 kvm_zap_gfn_range()

When zapping a GFN range, pass 0 => ALL_ONES for the to-be-invalidated
range to effectively block all page faults while the zap is in-progress.
The invalidation helpers take a host virtual address, whereas zapping a
GFN obviously provides a guest physical address and with the wrong unit
of measurement (frame vs. byte).

Alternatively, KVM could walk all memslots to get the associated HVAs,
but thanks to SMM, that would require multiple lookups.  And practically
speaking, kvm_zap_gfn_range() usage is quite rare and not a hot path,
e.g. MTRR and CR0.CD are almost guaranteed to be done only on vCPU0
during boot, and APICv inhibits are similarly infrequent operations.

Fixes: edb298c663fc ("KVM: x86/mmu: bump mmu notifier count in kvm_zap_gfn_range")
Reported-by: Chao Peng <chao.p.peng@linux.intel.com>
Cc: stable@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20221111001841.2412598-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6f81539061d6..1ccb769f62af 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6056,7 +6056,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
 	write_lock(&kvm->mmu_lock);
 
-	kvm_mmu_invalidate_begin(kvm, gfn_start, gfn_end);
+	kvm_mmu_invalidate_begin(kvm, 0, -1ul);
 
 	flush = kvm_rmap_zap_gfn_range(kvm, gfn_start, gfn_end);
 
@@ -6070,7 +6070,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 		kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
 						   gfn_end - gfn_start);
 
-	kvm_mmu_invalidate_end(kvm, gfn_start, gfn_end);
+	kvm_mmu_invalidate_end(kvm, 0, -1ul);
 
 	write_unlock(&kvm->mmu_lock);
 }

