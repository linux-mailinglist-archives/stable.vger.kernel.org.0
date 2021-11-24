Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C8A45C612
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344962AbhKXOFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:05:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:46102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349207AbhKXN7f (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:59:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45676619E4;
        Wed, 24 Nov 2021 13:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759331;
        bh=4MohZ0tkpORSdi48wLzrYH21RQPumjic1qnmj+1jeD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WUqvGoIWKdzWm7EthBTMInaxSC3xBGRM3RLy3PUzGE3ZNRWebBpXbKmtaueWeU9z1
         sK0V9TMB9dfyMQV0WT4naPwnndYwPn/mBTL783Tu5ZABLxtELMNsxkruvfs0RWqIFQ
         emlgcCFlfrOkALWd/m2bn+k90IH2o1quXd27PWEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 206/279] KVM: x86/mmu: include EFER.LMA in extended mmu role
Date:   Wed, 24 Nov 2021 12:58:13 +0100
Message-Id: <20211124115725.860869620@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

commit b8453cdcf26020030da182f0156d7bf59ae5719f upstream.

Incorporate EFER.LMA into kvm_mmu_extended_role, as it used to compute the
guest root level and is not reflected in kvm_mmu_page_role.level when TDP
is in use.  When simply running the guest, it is impossible for EFER.LMA
and kvm_mmu.root_level to get out of sync, as the guest cannot transition
from PAE paging to 64-bit paging without toggling CR0.PG, i.e. without
first bouncing through a different MMU context.  And stuffing guest state
via KVM_SET_SREGS{,2} also ensures a full MMU context reset.

However, if KVM_SET_SREGS{,2} is followed by KVM_SET_NESTED_STATE, e.g. to
set guest state when migrating the VM while L2 is active, the vCPU state
will reflect L2, not L1.  If L1 is using TDP for L2, then root_mmu will
have been configured using L2's state, despite not being used for L2.  If
L2.EFER.LMA != L1.EFER.LMA, and L2 is using PAE paging, then root_mmu will
be configured for guest PAE paging, but will match the mmu_role for 64-bit
paging and cause KVM to not reconfigure root_mmu on the next nested VM-Exit.

Alternatively, the root_mmu's role could be invalidated after a successful
KVM_SET_NESTED_STATE that yields vcpu->arch.mmu != vcpu->arch.root_mmu,
i.e. that switches the active mmu to guest_mmu, but doing so is unnecessarily
tricky, and not even needed if L1 and L2 do have the same role (e.g., they
are both 64-bit guests and run with the same CR4).

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20211115131837.195527-3-mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu/mmu.c          |    1 +
 2 files changed, 2 insertions(+)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -364,6 +364,7 @@ union kvm_mmu_extended_role {
 		unsigned int cr4_smap:1;
 		unsigned int cr4_smep:1;
 		unsigned int cr4_la57:1;
+		unsigned int efer_lma:1;
 	};
 };
 
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4679,6 +4679,7 @@ static union kvm_mmu_extended_role kvm_c
 		/* PKEY and LA57 are active iff long mode is active. */
 		ext.cr4_pke = ____is_efer_lma(regs) && ____is_cr4_pke(regs);
 		ext.cr4_la57 = ____is_efer_lma(regs) && ____is_cr4_la57(regs);
+		ext.efer_lma = ____is_efer_lma(regs);
 	}
 
 	ext.valid = 1;


