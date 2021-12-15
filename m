Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22475475EF7
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343576AbhLOR0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:26:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45698 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245584AbhLORZD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:25:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81B71619F2;
        Wed, 15 Dec 2021 17:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B28C36AE6;
        Wed, 15 Dec 2021 17:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589101;
        bh=vi5UnlwFaAsMltw2f/EZrq89g/w9jyCTRXA2jFOVkD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VsermUOLzL2Yg8AZEssfa79VteQQdXnrNlyEZFrLSToL5A521oiuVUrcbo6G/Z1Sc
         Yr3nPMlWhzPEQBuVUBnlm+mwglizJOBfU0vyOLZunSYAoP/AMw9ewe6AazLap6m0A7
         jgdJT0QCME5ZswONyRyzU/+V8FG00/uhfuOGM2xI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fuad Tabba <tabba@google.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 03/33] KVM: arm64: Save PSTATE early on exit
Date:   Wed, 15 Dec 2021 18:21:01 +0100
Message-Id: <20211215172024.900099232@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172024.787958154@linuxfoundation.org>
References: <20211215172024.787958154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



