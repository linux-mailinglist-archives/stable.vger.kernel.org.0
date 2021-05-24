Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67E438F206
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 19:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbhEXRJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 13:09:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232543AbhEXRJc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 13:09:32 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03D4B61404;
        Mon, 24 May 2021 17:08:04 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1llE3d-003IXQ-Us; Mon, 24 May 2021 18:08:02 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com, Steven Price <steven.price@arm.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] KVM: arm64: Prevent mixed-width VM creation
Date:   Mon, 24 May 2021 18:07:52 +0100
Message-Id: <20210524170752.1549797-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, mark.rutland@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com, steven.price@arm.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It looks like we have tolerated creating mixed-width VMs since...
forever. However, that was never the intention, and we'd rather
not have to support that pointless complexity.

Forbid such a setup by making sure all the vcpus have the same
register width.

Reported-by: Steven Price <steven.price@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---

Notes:
    v2: Fix missing check against ARM64_HAS_32BIT_EL1 (Mark)

 arch/arm64/include/asm/kvm_emulate.h |  5 +++++
 arch/arm64/kvm/reset.c               | 28 ++++++++++++++++++++++++----
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index f612c090f2e4..01b9857757f2 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -463,4 +463,9 @@ static __always_inline void kvm_incr_pc(struct kvm_vcpu *vcpu)
 	vcpu->arch.flags |= KVM_ARM64_INCREMENT_PC;
 }
 
+static inline bool vcpu_has_feature(struct kvm_vcpu *vcpu, int feature)
+{
+	return test_bit(feature, vcpu->arch.features);
+}
+
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 956cdc240148..d37ebee085cf 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -166,6 +166,25 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu *tmp;
+	bool is32bit;
+	int i;
+
+	is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
+	if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1) && is32bit)
+		return false;
+
+	/* Check that the vcpus are either all 32bit or all 64bit */
+	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
+		if (vcpu_has_feature(tmp, KVM_ARM_VCPU_EL1_32BIT) != is32bit)
+			return false;
+	}
+
+	return true;
+}
+
 /**
  * kvm_reset_vcpu - sets core registers and sys_regs to reset value
  * @vcpu: The VCPU pointer
@@ -217,13 +236,14 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		}
 	}
 
+	if (!vcpu_allowed_register_width(vcpu)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	switch (vcpu->arch.target) {
 	default:
 		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
-			if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1)) {
-				ret = -EINVAL;
-				goto out;
-			}
 			pstate = VCPU_RESET_PSTATE_SVC;
 		} else {
 			pstate = VCPU_RESET_PSTATE_EL1;
-- 
2.30.2

