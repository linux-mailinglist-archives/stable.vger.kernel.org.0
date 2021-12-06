Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258BF46A951
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350329AbhLFVQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:16:50 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51782 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350365AbhLFVQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:16:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89EBBB8110F;
        Mon,  6 Dec 2021 21:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEDACC341C1;
        Mon,  6 Dec 2021 21:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825196;
        bh=RmUvLN5TUsfm8pWXxTp9zCUEG8c60QbEHR/Zn0rbyT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cgg9odRuEe83+xIaAy+fPGS36EcMX+UcpiZz22ZrPMkkn9AFugNhm8sOutefWG+pr
         O0yNbtwPKhUNmqOSsGhXSlYi0H/LEOzrk9V9OSDtEhH6pbaH9y+2sZFhQMfYKyT4Fu
         TTnSI01X0ZjJwLEsGf0iJufP9mw6DaVJqRJsnmLxqRWa3JlAd+SytwnyhJBAzBPz/k
         Zf36EtQnjy60gO7YuFHufF+T/0j9uJpL6WsoUEo60WRbXnVkSEWdzS2n9lcCRLTdy+
         sXGt5gMbBRPojbFntA6YcHDibrCTkHSzqT2J33u5BcB2uZrLzg9n1ejUFisyJXpsYd
         9pjwqBAvc0fCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, Fuad Tabba <tabba@google.com>,
        Sasha Levin <sashal@kernel.org>, catalin.marinas@arm.com,
        will@kernel.org, ardb@kernel.org, pbonzini@redhat.com,
        dbrazdil@google.com, mark.rutland@arm.com, qperret@google.com,
        steven.price@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu
Subject: [PATCH AUTOSEL 5.15 05/24] KVM: arm64: Save PSTATE early on exit
Date:   Mon,  6 Dec 2021 16:12:10 -0500
Message-Id: <20211206211230.1660072-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206211230.1660072-1-sashal@kernel.org>
References: <20211206211230.1660072-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 83bb2c1a01d7127d5adc7d69d7aaa3f7072de2b4 ]

In order to be able to use primitives such as vcpu_mode_is_32bit(),
we need to synchronize the guest PSTATE. However, this is currently
done deep into the bowels of the world-switch code, and we do have
helpers evaluating this much earlier (__vgic_v3_perform_cpuif_access
and handle_aarch32_guest, for example).

Move the saving of the guest pstate into the early fixups, which
cures the first issue. The second one will be addressed separately.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h    | 6 ++++++
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 7 ++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index a0e78a6027be0..c75e84489f57b 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -416,6 +416,12 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
  */
 static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
+	/*
+	 * Save PSTATE early so that we can evaluate the vcpu mode
+	 * early on.
+	 */
+	vcpu->arch.ctxt.regs.pstate = read_sysreg_el2(SYS_SPSR);
+
 	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
 		vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index de7e14c862e6c..7ecca8b078519 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -70,7 +70,12 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 static inline void __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt->regs.pc			= read_sysreg_el2(SYS_ELR);
-	ctxt->regs.pstate		= read_sysreg_el2(SYS_SPSR);
+	/*
+	 * Guest PSTATE gets saved at guest fixup time in all
+	 * cases. We still need to handle the nVHE host side here.
+	 */
+	if (!has_vhe() && ctxt->__hyp_running_vcpu)
+		ctxt->regs.pstate	= read_sysreg_el2(SYS_SPSR);
 
 	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
 		ctxt_sys_reg(ctxt, DISR_EL1) = read_sysreg_s(SYS_VDISR_EL2);
-- 
2.33.0

