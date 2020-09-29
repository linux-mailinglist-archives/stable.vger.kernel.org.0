Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8467B27C694
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730841AbgI2Lqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:46:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730823AbgI2Lp7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:45:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBFCD206E5;
        Tue, 29 Sep 2020 11:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379953;
        bh=m4XZgdRnetvr/TBujqFj3i9yQ9RUo+GPbys/yKow/TE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sEPFQ0iD02p0XVFybbS71B1Fp5fKnpO826vaqirRMd4JFB+XJMTdsFOh9DFDGs1CS
         hj8lGaQE5LhMaNT0Kbg+NkIngA6RZFrDYT9DhNNtPxqAG2v9CJD+gq5Ys+/YsQQI5h
         NOZuf+dXEvEVkXWfrtZ8viTBP2x41CQGc/9PJA/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.4 383/388] KVM: arm64: Assume write fault on S1PTW permission fault on instruction fetch
Date:   Tue, 29 Sep 2020 13:01:54 +0200
Message-Id: <20200929110029.005392112@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit c4ad98e4b72cb5be30ea282fce935248f2300e62 upstream.

KVM currently assumes that an instruction abort can never be a write.
This is in general true, except when the abort is triggered by
a S1PTW on instruction fetch that tries to update the S1 page tables
(to set AF, for example).

This can happen if the page tables have been paged out and brought
back in without seeing a direct write to them (they are thus marked
read only), and the fault handling code will make the PT executable(!)
instead of writable. The guest gets stuck forever.

In these conditions, the permission fault must be considered as
a write so that the Stage-1 update can take place. This is essentially
the I-side equivalent of the problem fixed by 60e21a0ef54c ("arm64: KVM:
Take S1 walks into account when determining S2 write faults").

Update kvm_is_write_fault() to return true on IABT+S1PTW, and introduce
kvm_vcpu_trap_is_exec_fault() that only return true when no faulting
on a S1 fault. Additionally, kvm_vcpu_dabt_iss1tw() is renamed to
kvm_vcpu_abt_iss1tw(), as the above makes it plain that it isn't
specific to data abort.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Will Deacon <will@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200915104218.1284701-2-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/kvm_emulate.h   |   11 ++++++++---
 arch/arm64/include/asm/kvm_emulate.h |   12 ++++++++++--
 arch/arm64/kvm/hyp/switch.c          |    2 +-
 virt/kvm/arm/mmio.c                  |    2 +-
 virt/kvm/arm/mmu.c                   |    2 +-
 5 files changed, 21 insertions(+), 8 deletions(-)

--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -204,7 +204,7 @@ static inline int kvm_vcpu_dabt_get_rd(s
 	return (kvm_vcpu_get_hsr(vcpu) & HSR_SRT_MASK) >> HSR_SRT_SHIFT;
 }
 
-static inline bool kvm_vcpu_dabt_iss1tw(struct kvm_vcpu *vcpu)
+static inline bool kvm_vcpu_abt_iss1tw(const struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_get_hsr(vcpu) & HSR_DABT_S1PTW;
 }
@@ -236,16 +236,21 @@ static inline bool kvm_vcpu_trap_il_is32
 	return kvm_vcpu_get_hsr(vcpu) & HSR_IL;
 }
 
-static inline u8 kvm_vcpu_trap_get_class(struct kvm_vcpu *vcpu)
+static inline u8 kvm_vcpu_trap_get_class(const struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_get_hsr(vcpu) >> HSR_EC_SHIFT;
 }
 
-static inline bool kvm_vcpu_trap_is_iabt(struct kvm_vcpu *vcpu)
+static inline bool kvm_vcpu_trap_is_iabt(const struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_trap_get_class(vcpu) == HSR_EC_IABT;
 }
 
+static inline bool kvm_vcpu_trap_is_exec_fault(const struct kvm_vcpu *vcpu)
+{
+	return kvm_vcpu_trap_is_iabt(vcpu) && !kvm_vcpu_abt_iss1tw(vcpu);
+}
+
 static inline u8 kvm_vcpu_trap_get_fault(struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_get_hsr(vcpu) & HSR_FSC;
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -299,7 +299,7 @@ static inline int kvm_vcpu_dabt_get_rd(c
 	return (kvm_vcpu_get_hsr(vcpu) & ESR_ELx_SRT_MASK) >> ESR_ELx_SRT_SHIFT;
 }
 
-static inline bool kvm_vcpu_dabt_iss1tw(const struct kvm_vcpu *vcpu)
+static __always_inline bool kvm_vcpu_abt_iss1tw(const struct kvm_vcpu *vcpu)
 {
 	return !!(kvm_vcpu_get_hsr(vcpu) & ESR_ELx_S1PTW);
 }
@@ -307,7 +307,7 @@ static inline bool kvm_vcpu_dabt_iss1tw(
 static inline bool kvm_vcpu_dabt_iswrite(const struct kvm_vcpu *vcpu)
 {
 	return !!(kvm_vcpu_get_hsr(vcpu) & ESR_ELx_WNR) ||
-		kvm_vcpu_dabt_iss1tw(vcpu); /* AF/DBM update */
+		kvm_vcpu_abt_iss1tw(vcpu); /* AF/DBM update */
 }
 
 static inline bool kvm_vcpu_dabt_is_cm(const struct kvm_vcpu *vcpu)
@@ -336,6 +336,11 @@ static inline bool kvm_vcpu_trap_is_iabt
 	return kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_IABT_LOW;
 }
 
+static inline bool kvm_vcpu_trap_is_exec_fault(const struct kvm_vcpu *vcpu)
+{
+	return kvm_vcpu_trap_is_iabt(vcpu) && !kvm_vcpu_abt_iss1tw(vcpu);
+}
+
 static inline u8 kvm_vcpu_trap_get_fault(const struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_get_hsr(vcpu) & ESR_ELx_FSC;
@@ -373,6 +378,9 @@ static inline int kvm_vcpu_sys_get_rt(st
 
 static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
 {
+	if (kvm_vcpu_abt_iss1tw(vcpu))
+		return true;
+
 	if (kvm_vcpu_trap_is_iabt(vcpu))
 		return false;
 
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -496,7 +496,7 @@ static bool __hyp_text fixup_guest_exit(
 			kvm_vcpu_trap_get_fault_type(vcpu) == FSC_FAULT &&
 			kvm_vcpu_dabt_isvalid(vcpu) &&
 			!kvm_vcpu_dabt_isextabt(vcpu) &&
-			!kvm_vcpu_dabt_iss1tw(vcpu);
+			!kvm_vcpu_abt_iss1tw(vcpu);
 
 		if (valid) {
 			int ret = __vgic_v2_perform_cpuif_access(vcpu);
--- a/virt/kvm/arm/mmio.c
+++ b/virt/kvm/arm/mmio.c
@@ -130,7 +130,7 @@ static int decode_hsr(struct kvm_vcpu *v
 	bool sign_extend;
 	bool sixty_four;
 
-	if (kvm_vcpu_dabt_iss1tw(vcpu)) {
+	if (kvm_vcpu_abt_iss1tw(vcpu)) {
 		/* page table accesses IO mem: tell guest to fix its TTBR */
 		kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
 		return 1;
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1690,7 +1690,7 @@ static int user_mem_abort(struct kvm_vcp
 	unsigned long vma_pagesize, flags = 0;
 
 	write_fault = kvm_is_write_fault(vcpu);
-	exec_fault = kvm_vcpu_trap_is_iabt(vcpu);
+	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
 	VM_BUG_ON(write_fault && exec_fault);
 
 	if (fault_status == FSC_PERM && !write_fault && !exec_fault) {


