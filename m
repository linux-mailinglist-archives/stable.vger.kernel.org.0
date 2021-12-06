Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B52A469EB9
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358050AbhLFPnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357969AbhLFPiA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:38:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3E1C08EAED;
        Mon,  6 Dec 2021 07:23:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6345AB81132;
        Mon,  6 Dec 2021 15:23:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A01C341C2;
        Mon,  6 Dec 2021 15:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804234;
        bh=Bz8+jptFDIVkaOdFpM2e9rnrZqCplYpTPOZtBsUKvUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E0l6gaEyGx8AWjn/+IGcqaKTn4THBnFSchXGbLbZrxjr0wSZ+C24pRrKwthfsFXr+
         Z4sFL2Ma22D8NME+/ZY2Zqr40LTSo9p9qyLDHzebUOTemfkZ2wPjFZ1NlxVrKb7hyV
         SQ1BLnC9N5waFZrJL7Tujoi/qgWPkmfKX7+9GyfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lai Jiangshan <jiangshanlai+lkml@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 075/207] KVM: nVMX: Emulate guest TLB flush on nested VM-Enter with new vpid12
Date:   Mon,  6 Dec 2021 15:55:29 +0100
Message-Id: <20211206145612.828569863@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 712494de96f35f3e146b36b752c2afe0fdc0f0cc upstream.

Fully emulate a guest TLB flush on nested VM-Enter which changes vpid12,
i.e. L2's VPID, instead of simply doing INVVPID to flush real hardware's
TLB entries for vpid02.  From L1's perspective, changing L2's VPID is
effectively a TLB flush unless "hardware" has previously cached entries
for the new vpid12.  Because KVM tracks only a single vpid12, KVM doesn't
know if the new vpid12 has been used in the past and so must treat it as
a brand new, never been used VPID, i.e. must assume that the new vpid12
represents a TLB flush from L1's perspective.

For example, if L1 and L2 share a CR3, the first VM-Enter to L2 (with a
VPID) is effectively a TLB flush as hardware/KVM has never seen vpid12
and thus can't have cached entries in the TLB for vpid12.

Reported-by: Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Fixes: 5c614b3583e7 ("KVM: nVMX: nested VPID emulation")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211125014944.536398-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |   37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1180,29 +1180,26 @@ static void nested_vmx_transition_tlb_fl
 	WARN_ON(!enable_vpid);
 
 	/*
-	 * If VPID is enabled and used by vmc12, but L2 does not have a unique
-	 * TLB tag (ASID), i.e. EPT is disabled and KVM was unable to allocate
-	 * a VPID for L2, flush the current context as the effective ASID is
-	 * common to both L1 and L2.
-	 *
-	 * Defer the flush so that it runs after vmcs02.EPTP has been set by
-	 * KVM_REQ_LOAD_MMU_PGD (if nested EPT is enabled) and to avoid
-	 * redundant flushes further down the nested pipeline.
-	 *
-	 * If a TLB flush isn't required due to any of the above, and vpid12 is
-	 * changing then the new "virtual" VPID (vpid12) will reuse the same
-	 * "real" VPID (vpid02), and so needs to be flushed.  There's no direct
-	 * mapping between vpid02 and vpid12, vpid02 is per-vCPU and reused for
-	 * all nested vCPUs.  Remember, a flush on VM-Enter does not invalidate
-	 * guest-physical mappings, so there is no need to sync the nEPT MMU.
+	 * VPID is enabled and in use by vmcs12.  If vpid12 is changing, then
+	 * emulate a guest TLB flush as KVM does not track vpid12 history nor
+	 * is the VPID incorporated into the MMU context.  I.e. KVM must assume
+	 * that the new vpid12 has never been used and thus represents a new
+	 * guest ASID that cannot have entries in the TLB.
 	 */
-	if (!nested_has_guest_tlb_tag(vcpu)) {
-		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
-	} else if (is_vmenter &&
-		   vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
+	if (is_vmenter && vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
 		vmx->nested.last_vpid = vmcs12->virtual_processor_id;
-		vpid_sync_context(nested_get_vpid02(vcpu));
+		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
+		return;
 	}
+
+	/*
+	 * If VPID is enabled, used by vmc12, and vpid12 is not changing but
+	 * does not have a unique TLB tag (ASID), i.e. EPT is disabled and
+	 * KVM was unable to allocate a VPID for L2, flush the current context
+	 * as the effective ASID is common to both L1 and L2.
+	 */
+	if (!nested_has_guest_tlb_tag(vcpu))
+		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 }
 
 static bool is_bitwise_subset(u64 superset, u64 subset, u64 mask)


