Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE49D26A397
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 12:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgIOKtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 06:49:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726372AbgIOKmm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 06:42:42 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5855B2078D;
        Tue, 15 Sep 2020 10:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600166561;
        bh=wkKxKhlybGBntyOg1hln2NHkcNdtK4PSZdl0LvY4Ww0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cXqnxHVC/lNwsdNTXzNrQrUQ41aUYV5aTt9D/LVneBanDT+iQJ8Tjb8oidrX/Pq2a
         wV6fP6Pk9ZiH1lEghDHBiaetqE2r4ynVODp0mupOC7dhNCELdLeCvuwZUthDP3e7v3
         7YjKkhAzX/x++0pukuKXN80BlhOhPLYLgN6MitZ0=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kI8Q3-00ByDU-SC; Tue, 15 Sep 2020 11:42:40 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     kernel-team@android.com, Will Deacon <will@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/2] KVM: arm64: Assume write fault on S1PTW permission fault on instruction fetch
Date:   Tue, 15 Sep 2020 11:42:17 +0100
Message-Id: <20200915104218.1284701-2-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915104218.1284701-1-maz@kernel.org>
References: <20200915104218.1284701-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kernel-team@android.com, will@kernel.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h    | 12 ++++++++++--
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
 arch/arm64/kvm/mmu.c                    |  4 ++--
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 49a55be2b9a2..4f618af660ba 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -298,7 +298,7 @@ static __always_inline int kvm_vcpu_dabt_get_rd(const struct kvm_vcpu *vcpu)
 	return (kvm_vcpu_get_esr(vcpu) & ESR_ELx_SRT_MASK) >> ESR_ELx_SRT_SHIFT;
 }
 
-static __always_inline bool kvm_vcpu_dabt_iss1tw(const struct kvm_vcpu *vcpu)
+static __always_inline bool kvm_vcpu_abt_iss1tw(const struct kvm_vcpu *vcpu)
 {
 	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_S1PTW);
 }
@@ -306,7 +306,7 @@ static __always_inline bool kvm_vcpu_dabt_iss1tw(const struct kvm_vcpu *vcpu)
 static __always_inline bool kvm_vcpu_dabt_iswrite(const struct kvm_vcpu *vcpu)
 {
 	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_WNR) ||
-		kvm_vcpu_dabt_iss1tw(vcpu); /* AF/DBM update */
+		kvm_vcpu_abt_iss1tw(vcpu); /* AF/DBM update */
 }
 
 static inline bool kvm_vcpu_dabt_is_cm(const struct kvm_vcpu *vcpu)
@@ -335,6 +335,11 @@ static inline bool kvm_vcpu_trap_is_iabt(const struct kvm_vcpu *vcpu)
 	return kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_IABT_LOW;
 }
 
+static inline bool kvm_vcpu_trap_is_exec_fault(const struct kvm_vcpu *vcpu)
+{
+	return kvm_vcpu_trap_is_iabt(vcpu) && !kvm_vcpu_abt_iss1tw(vcpu);
+}
+
 static __always_inline u8 kvm_vcpu_trap_get_fault(const struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_FSC;
@@ -372,6 +377,9 @@ static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
 
 static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
 {
+	if (kvm_vcpu_abt_iss1tw(vcpu))
+		return true;
+
 	if (kvm_vcpu_trap_is_iabt(vcpu))
 		return false;
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 426ef65601dd..d64c5d56c860 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -445,7 +445,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 			kvm_vcpu_trap_get_fault_type(vcpu) == FSC_FAULT &&
 			kvm_vcpu_dabt_isvalid(vcpu) &&
 			!kvm_vcpu_abt_issea(vcpu) &&
-			!kvm_vcpu_dabt_iss1tw(vcpu);
+			!kvm_vcpu_abt_iss1tw(vcpu);
 
 		if (valid) {
 			int ret = __vgic_v2_perform_cpuif_access(vcpu);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index f58d657a898d..9aec1ce491d2 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1843,7 +1843,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	struct kvm_s2_mmu *mmu = vcpu->arch.hw_mmu;
 
 	write_fault = kvm_is_write_fault(vcpu);
-	exec_fault = kvm_vcpu_trap_is_iabt(vcpu);
+	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
 	VM_BUG_ON(write_fault && exec_fault);
 
 	if (fault_status == FSC_PERM && !write_fault && !exec_fault) {
@@ -2125,7 +2125,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 			goto out;
 		}
 
-		if (kvm_vcpu_dabt_iss1tw(vcpu)) {
+		if (kvm_vcpu_abt_iss1tw(vcpu)) {
 			kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
 			ret = 1;
 			goto out_unlock;
-- 
2.28.0

