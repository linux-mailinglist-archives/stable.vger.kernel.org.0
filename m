Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470FE27BE49
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 09:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725535AbgI2Hnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 03:43:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbgI2Hnm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 03:43:42 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45BC4206DC;
        Tue, 29 Sep 2020 07:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601365421;
        bh=s4ebJqZqeW4GbfFBqchKMkYV3IJ7qtmycrt2m08fzL0=;
        h=From:To:Cc:Subject:Date:From;
        b=b40dzn0oeBLGtcQ1ZlnjjMJwWafzGXaTcHg49M7WyXBv+Mk13Y2WlEAn8fe04Teyd
         PKAsYG1Xr14ft1P70I237UaRHkwmA318XqNySd1VZhaPrX1sF6nzQNBhiPCQqh8G7n
         0DMdAPdkKCeITpPQB+dwYDrSxIelzlXVTMXSaLvM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kNAIV-00Fi2H-Gu; Tue, 29 Sep 2020 08:43:39 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     stable@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, gregkh@linuxfoundation.org,
        kernel-team@android.com
Subject: [PATCH stable-4.19 v2] KVM: arm64: Assume write fault on S1PTW permission fault on instruction fetch
Date:   Tue, 29 Sep 2020 08:43:23 +0100
Message-Id: <20200929074323.744700-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: stable@vger.kernel.org, will@kernel.org, gregkh@linuxfoundation.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit c4ad98e4b72cb5be30ea282fce935248f2300e62 upstream.

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
---
 arch/arm/include/asm/kvm_emulate.h   | 11 ++++++++---
 arch/arm64/include/asm/kvm_emulate.h |  9 +++++++--
 arch/arm64/kvm/hyp/switch.c          |  2 +-
 virt/kvm/arm/mmio.c                  |  2 +-
 virt/kvm/arm/mmu.c                   |  5 ++++-
 5 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 7d2ca035d6c8..11d4ff9f3e4d 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -216,7 +216,7 @@ static inline int kvm_vcpu_dabt_get_rd(struct kvm_vcpu *vcpu)
 	return (kvm_vcpu_get_hsr(vcpu) & HSR_SRT_MASK) >> HSR_SRT_SHIFT;
 }
 
-static inline bool kvm_vcpu_dabt_iss1tw(struct kvm_vcpu *vcpu)
+static inline bool kvm_vcpu_abt_iss1tw(const struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_get_hsr(vcpu) & HSR_DABT_S1PTW;
 }
@@ -248,16 +248,21 @@ static inline bool kvm_vcpu_trap_il_is32bit(struct kvm_vcpu *vcpu)
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
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 778cb4f868d9..669c960dd069 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -303,7 +303,7 @@ static inline int kvm_vcpu_dabt_get_rd(const struct kvm_vcpu *vcpu)
 	return (kvm_vcpu_get_hsr(vcpu) & ESR_ELx_SRT_MASK) >> ESR_ELx_SRT_SHIFT;
 }
 
-static inline bool kvm_vcpu_dabt_iss1tw(const struct kvm_vcpu *vcpu)
+static inline bool kvm_vcpu_abt_iss1tw(const struct kvm_vcpu *vcpu)
 {
 	return !!(kvm_vcpu_get_hsr(vcpu) & ESR_ELx_S1PTW);
 }
@@ -311,7 +311,7 @@ static inline bool kvm_vcpu_dabt_iss1tw(const struct kvm_vcpu *vcpu)
 static inline bool kvm_vcpu_dabt_iswrite(const struct kvm_vcpu *vcpu)
 {
 	return !!(kvm_vcpu_get_hsr(vcpu) & ESR_ELx_WNR) ||
-		kvm_vcpu_dabt_iss1tw(vcpu); /* AF/DBM update */
+		kvm_vcpu_abt_iss1tw(vcpu); /* AF/DBM update */
 }
 
 static inline bool kvm_vcpu_dabt_is_cm(const struct kvm_vcpu *vcpu)
@@ -340,6 +340,11 @@ static inline bool kvm_vcpu_trap_is_iabt(const struct kvm_vcpu *vcpu)
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
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index f146bff53edf..15312e429b7d 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -430,7 +430,7 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 			kvm_vcpu_trap_get_fault_type(vcpu) == FSC_FAULT &&
 			kvm_vcpu_dabt_isvalid(vcpu) &&
 			!kvm_vcpu_dabt_isextabt(vcpu) &&
-			!kvm_vcpu_dabt_iss1tw(vcpu);
+			!kvm_vcpu_abt_iss1tw(vcpu);
 
 		if (valid) {
 			int ret = __vgic_v2_perform_cpuif_access(vcpu);
diff --git a/virt/kvm/arm/mmio.c b/virt/kvm/arm/mmio.c
index 878e0edb2e1b..ff0a1c608371 100644
--- a/virt/kvm/arm/mmio.c
+++ b/virt/kvm/arm/mmio.c
@@ -142,7 +142,7 @@ static int decode_hsr(struct kvm_vcpu *vcpu, bool *is_write, int *len)
 	bool sign_extend;
 	bool sixty_four;
 
-	if (kvm_vcpu_dabt_iss1tw(vcpu)) {
+	if (kvm_vcpu_abt_iss1tw(vcpu)) {
 		/* page table accesses IO mem: tell guest to fix its TTBR */
 		kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
 		return 1;
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 41d6285c3da9..787f7329d1b7 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1282,6 +1282,9 @@ static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap)
 
 static bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
 {
+	if (kvm_vcpu_abt_iss1tw(vcpu))
+		return true;
+
 	if (kvm_vcpu_trap_is_iabt(vcpu))
 		return false;
 
@@ -1496,7 +1499,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	unsigned long flags = 0;
 
 	write_fault = kvm_is_write_fault(vcpu);
-	exec_fault = kvm_vcpu_trap_is_iabt(vcpu);
+	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
 	VM_BUG_ON(write_fault && exec_fault);
 
 	if (fault_status == FSC_PERM && !write_fault && !exec_fault) {
-- 
2.28.0

