Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B550446A9B6
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351025AbhLFVTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:19:38 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:47926 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350781AbhLFVTQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:19:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5E6DCCE1867;
        Mon,  6 Dec 2021 21:15:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F24C341C1;
        Mon,  6 Dec 2021 21:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825344;
        bh=vi5UnlwFaAsMltw2f/EZrq89g/w9jyCTRXA2jFOVkD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iff2RiqupaS/BkViyBDGbk8eaC9kBch5mf/4CTT9cnJnodGCjBKIkt7jxLK2Tts7w
         tSFDM53mtvpVr0woaVUAVCsQ1Un0IVJWkEbmRFfpHshN22Oo8WJWuuvbAFznwTtY8t
         6Vo0M9+OlVaViA0VjzEj1uj9XyEDFBWQT5XqqBTZlzfrst0XG+B9l0JZsnG8XEEbNF
         BoCFzpt1ndz4T0HcSr6ttUMiAhoOIoMJa4/cvr+rUMNgpHFFSU2AQ6MunrMmf6ojNx
         zuW75rr25FfM8dodJwWrM0ZH5aZCqrs+0zOzodDtWAT1dURhejX3LLTZX10O6H7I+2
         ltutRny15b2SA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, Fuad Tabba <tabba@google.com>,
        Sasha Levin <sashal@kernel.org>, catalin.marinas@arm.com,
        will@kernel.org, ardb@kernel.org, alexandru.elisei@arm.com,
        qperret@google.com, ascull@google.com, mark.rutland@arm.com,
        steven.price@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu
Subject: [PATCH AUTOSEL 5.10 02/15] KVM: arm64: Save PSTATE early on exit
Date:   Mon,  6 Dec 2021 16:15:02 -0500
Message-Id: <20211206211520.1660478-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206211520.1660478-1-sashal@kernel.org>
References: <20211206211520.1660478-1-sashal@kernel.org>
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
index 1f875a8f20c47..8116ae1e636a2 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -406,6 +406,12 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
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
index cce43bfe158fa..0eacfb9d17b02 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -54,7 +54,12 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
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

