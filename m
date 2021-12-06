Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA517469C94
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243133AbhLFPXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:23:41 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53322 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346729AbhLFPTr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:19:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECB4EB8101C;
        Mon,  6 Dec 2021 15:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C26C341C2;
        Mon,  6 Dec 2021 15:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803775;
        bh=TzrBPBsGzAXOiSwJk2H2Hk2ZG6Ep75URO8rI4RVLqcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S5v1sQ9ETMMNfQ6Z02Mi2HPz4HrnXmZqFMTt32aUTJdAf8bpTuI82T8vpohDiYx+U
         HAoCfcAozhvDmy2IcTtoSksDkSZCON9KGV5fLYqdYvZCI/oFfIGg57xDCn8+7M4GM8
         6qHHmpOEg5pnFka23OSDiX+bLaEUZ/BFWDN7QUF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lai Jiangshan <jiangshanlai+lkml@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 043/130] KVM: nVMX: Flush current VPID (L1 vs. L2) for KVM_REQ_TLB_FLUSH_GUEST
Date:   Mon,  6 Dec 2021 15:56:00 +0100
Message-Id: <20211206145601.168519126@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 2b4a5a5d56881ece3c66b9a9a8943a6f41bd7349 upstream.

Flush the current VPID when handling KVM_REQ_TLB_FLUSH_GUEST instead of
always flushing vpid01.  Any TLB flush that is triggered when L2 is
active is scoped to L2's VPID (if it has one), e.g. if L2 toggles CR4.PGE
and L1 doesn't intercept PGE writes, then KVM's emulation of the TLB
flush needs to be applied to L2's VPID.

Reported-by: Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Fixes: 07ffaf343e34 ("KVM: nVMX: Sync all PGDs on nested transition with shadow paging")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211125014944.536398-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2908,6 +2908,13 @@ static void vmx_flush_tlb_all(struct kvm
 	}
 }
 
+static inline int vmx_get_current_vpid(struct kvm_vcpu *vcpu)
+{
+	if (is_guest_mode(vcpu))
+		return nested_get_vpid02(vcpu);
+	return to_vmx(vcpu)->vpid;
+}
+
 static void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
@@ -2920,31 +2927,29 @@ static void vmx_flush_tlb_current(struct
 	if (enable_ept)
 		ept_sync_context(construct_eptp(vcpu, root_hpa,
 						mmu->shadow_root_level));
-	else if (!is_guest_mode(vcpu))
-		vpid_sync_context(to_vmx(vcpu)->vpid);
 	else
-		vpid_sync_context(nested_get_vpid02(vcpu));
+		vpid_sync_context(vmx_get_current_vpid(vcpu));
 }
 
 static void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
 {
 	/*
-	 * vpid_sync_vcpu_addr() is a nop if vmx->vpid==0, see the comment in
+	 * vpid_sync_vcpu_addr() is a nop if vpid==0, see the comment in
 	 * vmx_flush_tlb_guest() for an explanation of why this is ok.
 	 */
-	vpid_sync_vcpu_addr(to_vmx(vcpu)->vpid, addr);
+	vpid_sync_vcpu_addr(vmx_get_current_vpid(vcpu), addr);
 }
 
 static void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu)
 {
 	/*
-	 * vpid_sync_context() is a nop if vmx->vpid==0, e.g. if enable_vpid==0
-	 * or a vpid couldn't be allocated for this vCPU.  VM-Enter and VM-Exit
-	 * are required to flush GVA->{G,H}PA mappings from the TLB if vpid is
+	 * vpid_sync_context() is a nop if vpid==0, e.g. if enable_vpid==0 or a
+	 * vpid couldn't be allocated for this vCPU.  VM-Enter and VM-Exit are
+	 * required to flush GVA->{G,H}PA mappings from the TLB if vpid is
 	 * disabled (VM-Enter with vpid enabled and vpid==0 is disallowed),
 	 * i.e. no explicit INVVPID is necessary.
 	 */
-	vpid_sync_context(to_vmx(vcpu)->vpid);
+	vpid_sync_context(vmx_get_current_vpid(vcpu));
 }
 
 void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu)


