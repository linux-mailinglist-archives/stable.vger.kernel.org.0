Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9086E35A4AE
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 19:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234303AbhDIRdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 13:33:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234268AbhDIRdR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 13:33:17 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94D8B6103E;
        Fri,  9 Apr 2021 17:33:04 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lUv0A-006ahk-HY; Fri, 09 Apr 2021 18:33:02 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Will Deacon <will@kernel.org>, kernel-team@android.com,
        stable@vger.kernel.org
Subject: [PATCH v2] KVM: arm64: Fully zero the vcpu state on reset
Date:   Fri,  9 Apr 2021 18:32:57 +0100
Message-Id: <20210409173257.3031729-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, will@kernel.org, kernel-team@android.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On vcpu reset, we expect all the registers to be brought back
to their initial state, which happens to be a bunch of zeroes.

However, some recent commit broke this, and is now leaving a bunch
of registers (such as the FP state) with whatever was left by the
guest. My bad.

Zero the reset of the state (32bit SPSRs and FPSIMD state).

Cc: stable@vger.kernel.org
Fixes: e47c2055c68e ("KVM: arm64: Make struct kvm_regs userspace-only")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---

Notes:
    v2: Only reset the FPSIMD state and the AArch32 SPSRs to avoid
    corrupting CNTVOFF in creative ways.

 arch/arm64/kvm/reset.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index bd354cd45d28..4b5acd84b8c8 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -242,6 +242,11 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	/* Reset core registers */
 	memset(vcpu_gp_regs(vcpu), 0, sizeof(*vcpu_gp_regs(vcpu)));
+	memset(&vcpu->arch.ctxt.fp_regs, 0, sizeof(vcpu->arch.ctxt.fp_regs));
+	vcpu->arch.ctxt.spsr_abt = 0;
+	vcpu->arch.ctxt.spsr_und = 0;
+	vcpu->arch.ctxt.spsr_irq = 0;
+	vcpu->arch.ctxt.spsr_fiq = 0;
 	vcpu_gp_regs(vcpu)->pstate = pstate;
 
 	/* Reset system registers */
-- 
2.30.2

