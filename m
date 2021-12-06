Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 366FF46919A
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 09:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239531AbhLFIlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 03:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbhLFIlL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 03:41:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93170C061746
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 00:37:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C62DB81026
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 08:37:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A389FC341C2;
        Mon,  6 Dec 2021 08:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638779860;
        bh=fNfXzSPQ7yuPKVq+Hy7ULNZxTtFjCkquu3mGRaqXD60=;
        h=Subject:To:Cc:From:Date:From;
        b=xvtiZOYngzHycUnPv/RnNFg5n1u649wSMtJSiRzCSKvhcicnFbi604G2f9T4GZBTb
         YheVTaBmCfsh+HLzbWaPj0Uvsi3UJv4S9gQAkEd9X+EqD65TiRVXj8+ujXRB8bagVF
         OOV1snF78gijOetFrsJD0DFcCOIQyG7Q4g2KxI4Q=
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Retry page fault if root is invalidated by" failed to apply to 5.15-stable tree
To:     seanjc@google.com, bgardon@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Dec 2021 09:37:36 +0100
Message-ID: <1638779856233243@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a955cad84cdaffa282b3cf8f5ce69e9e5655e585 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Sat, 20 Nov 2021 04:50:22 +0000
Subject: [PATCH] KVM: x86/mmu: Retry page fault if root is invalidated by
 memslot update

Bail from the page fault handler if the root shadow page was obsoleted by
a memslot update.  Do the check _after_ acuiring mmu_lock, as the TDP MMU
doesn't rely on the memslot/MMU generation, and instead relies on the
root being explicit marked invalid by kvm_mmu_zap_all_fast(), which takes
mmu_lock for write.

For the TDP MMU, inserting a SPTE into an obsolete root can leak a SP if
kvm_tdp_mmu_zap_invalidated_roots() has already zapped the SP, i.e. has
moved past the gfn associated with the SP.

For other MMUs, the resulting behavior is far more convoluted, though
unlikely to be truly problematic.  Installing SPs/SPTEs into the obsolete
root isn't directly problematic, as the obsolete root will be unloaded
and dropped before the vCPU re-enters the guest.  But because the legacy
MMU tracks shadow pages by their role, any SP created by the fault can
can be reused in the new post-reload root.  Again, that _shouldn't_ be
problematic as any leaf child SPTEs will be created for the current/valid
memslot generation, and kvm_mmu_get_page() will not reuse child SPs from
the old generation as they will be flagged as obsolete.  But, given that
continuing with the fault is pointess (the root will be unloaded), apply
the check to all MMUs.

Fixes: b7cccd397f31 ("KVM: x86/mmu: Fast invalidation for TDP MMU")
Cc: stable@vger.kernel.org
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211120045046.3940942-5-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6354297e92ae..e2e1d012df22 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1936,7 +1936,11 @@ static void mmu_audit_disable(void) { }
 
 static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	return sp->role.invalid ||
+	if (sp->role.invalid)
+		return true;
+
+	/* TDP MMU pages due not use the MMU generation. */
+	return !sp->tdp_mmu_page &&
 	       unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
 }
 
@@ -3976,6 +3980,20 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	return true;
 }
 
+/*
+ * Returns true if the page fault is stale and needs to be retried, i.e. if the
+ * root was invalidated by a memslot update or a relevant mmu_notifier fired.
+ */
+static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
+				struct kvm_page_fault *fault, int mmu_seq)
+{
+	if (is_obsolete_sp(vcpu->kvm, to_shadow_page(vcpu->arch.mmu->root_hpa)))
+		return true;
+
+	return fault->slot &&
+	       mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, fault->hva);
+}
+
 static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
@@ -4013,8 +4031,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	else
 		write_lock(&vcpu->kvm->mmu_lock);
 
-	if (fault->slot && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, fault->hva))
+	if (is_page_fault_stale(vcpu, fault, mmu_seq))
 		goto out_unlock;
+
 	r = make_mmu_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index f87d36898c44..708a5d297fe1 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -911,7 +911,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 
 	r = RET_PF_RETRY;
 	write_lock(&vcpu->kvm->mmu_lock);
-	if (fault->slot && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, fault->hva))
+
+	if (is_page_fault_stale(vcpu, fault, mmu_seq))
 		goto out_unlock;
 
 	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);

