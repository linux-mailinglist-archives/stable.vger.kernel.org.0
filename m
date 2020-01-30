Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4463B14DBDE
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 14:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbgA3N3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 08:29:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:48694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727446AbgA3N3g (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 08:29:36 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A23D20CC7;
        Thu, 30 Jan 2020 13:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580390975;
        bh=o7G3kM47bUlmvtGkyWDkQWRUlKus1kYJNw4ec+txEpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c04A+aCnBEU7IBY5ySLtj+5qq+caVh/+xDkZ8cUM5mtjUHW+q76978QBgbs5HoVme
         PBolggohk9SUP3TIf/8WHEvaqYvjwXRpx151JQ0YNN6aRGXT0lKjBVJx9zjEmBjfOv
         rre7cRCKGBYtc96GR5Y5emEDpj/YiRHWB6KxBo0M=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1ix9pq-002BmW-Db; Thu, 30 Jan 2020 13:26:18 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Beata Michalska <beata.michalska@linaro.org>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Haibin Wang <wanghaibin.wang@huawei.com>,
        James Morse <james.morse@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Shannon Zhao <shannon.zhao@linux.alibaba.com>,
        Steven Price <steven.price@arm.com>,
        Will Deacon <will@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 10/23] KVM: arm/arm64: Correct AArch32 SPSR on exception entry
Date:   Thu, 30 Jan 2020 13:25:45 +0000
Message-Id: <20200130132558.10201-11-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200130132558.10201-1-maz@kernel.org>
References: <20200130132558.10201-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, drjones@redhat.com, andrew.murray@arm.com, beata.michalska@linaro.org, christoffer.dall@arm.com, eric.auger@redhat.com, gshan@redhat.com, wanghaibin.wang@huawei.com, james.morse@arm.com, broonie@kernel.org, mark.rutland@arm.com, rmk+kernel@armlinux.org.uk, shannon.zhao@linux.alibaba.com, steven.price@arm.com, will@kernel.org, yuehaibing@huawei.com, yuzenghui@huawei.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

Confusingly, there are three SPSR layouts that a kernel may need to deal
with:

(1) An AArch64 SPSR_ELx view of an AArch64 pstate
(2) An AArch64 SPSR_ELx view of an AArch32 pstate
(3) An AArch32 SPSR_* view of an AArch32 pstate

When the KVM AArch32 support code deals with SPSR_{EL2,HYP}, it's either
dealing with #2 or #3 consistently. On arm64 the PSR_AA32_* definitions
match the AArch64 SPSR_ELx view, and on arm the PSR_AA32_* definitions
match the AArch32 SPSR_* view.

However, when we inject an exception into an AArch32 guest, we have to
synthesize the AArch32 SPSR_* that the guest will see. Thus, an AArch64
host needs to synthesize layout #3 from layout #2.

This patch adds a new host_spsr_to_spsr32() helper for this, and makes
use of it in the KVM AArch32 support code. For arm64 we need to shuffle
the DIT bit around, and remove the SS bit, while for arm we can use the
value as-is.

I've open-coded the bit manipulation for now to avoid having to rework
the existing PSR_* definitions into PSR64_AA32_* and PSR32_AA32_*
definitions. I hope to perform a more thorough refactoring in future so
that we can handle pstate view manipulation more consistently across the
kernel tree.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200108134324.46500-4-mark.rutland@arm.com
---
 arch/arm/include/asm/kvm_emulate.h   |  5 +++++
 arch/arm64/include/asm/kvm_emulate.h | 32 ++++++++++++++++++++++++++++
 virt/kvm/arm/aarch32.c               |  6 +++---
 3 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index c488c629e6c8..08d9805f613b 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -53,6 +53,11 @@ static inline void vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long v)
 	*__vcpu_spsr(vcpu) = v;
 }
 
+static inline unsigned long host_spsr_to_spsr32(unsigned long spsr)
+{
+	return spsr;
+}
+
 static inline unsigned long vcpu_get_reg(struct kvm_vcpu *vcpu,
 					 u8 reg_num)
 {
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index f407b6bdad2e..53ea7637b7b2 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -219,6 +219,38 @@ static inline void vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long v)
 		vcpu_gp_regs(vcpu)->spsr[KVM_SPSR_EL1] = v;
 }
 
+/*
+ * The layout of SPSR for an AArch32 state is different when observed from an
+ * AArch64 SPSR_ELx or an AArch32 SPSR_*. This function generates the AArch32
+ * view given an AArch64 view.
+ *
+ * In ARM DDI 0487E.a see:
+ *
+ * - The AArch64 view (SPSR_EL2) in section C5.2.18, page C5-426
+ * - The AArch32 view (SPSR_abt) in section G8.2.126, page G8-6256
+ * - The AArch32 view (SPSR_und) in section G8.2.132, page G8-6280
+ *
+ * Which show the following differences:
+ *
+ * | Bit | AA64 | AA32 | Notes                       |
+ * +-----+------+------+-----------------------------|
+ * | 24  | DIT  | J    | J is RES0 in ARMv8          |
+ * | 21  | SS   | DIT  | SS doesn't exist in AArch32 |
+ *
+ * ... and all other bits are (currently) common.
+ */
+static inline unsigned long host_spsr_to_spsr32(unsigned long spsr)
+{
+	const unsigned long overlap = BIT(24) | BIT(21);
+	unsigned long dit = !!(spsr & PSR_AA32_DIT_BIT);
+
+	spsr &= ~overlap;
+
+	spsr |= dit << 21;
+
+	return spsr;
+}
+
 static inline bool vcpu_mode_priv(const struct kvm_vcpu *vcpu)
 {
 	u32 mode;
diff --git a/virt/kvm/arm/aarch32.c b/virt/kvm/arm/aarch32.c
index 773cf1439081..631d397ac81b 100644
--- a/virt/kvm/arm/aarch32.c
+++ b/virt/kvm/arm/aarch32.c
@@ -129,15 +129,15 @@ static unsigned long get_except32_cpsr(struct kvm_vcpu *vcpu, u32 mode)
 
 static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
 {
-	unsigned long new_spsr_value = *vcpu_cpsr(vcpu);
-	bool is_thumb = (new_spsr_value & PSR_AA32_T_BIT);
+	unsigned long spsr = *vcpu_cpsr(vcpu);
+	bool is_thumb = (spsr & PSR_AA32_T_BIT);
 	u32 return_offset = return_offsets[vect_offset >> 2][is_thumb];
 	u32 sctlr = vcpu_cp15(vcpu, c1_SCTLR);
 
 	*vcpu_cpsr(vcpu) = get_except32_cpsr(vcpu, mode);
 
 	/* Note: These now point to the banked copies */
-	vcpu_write_spsr(vcpu, new_spsr_value);
+	vcpu_write_spsr(vcpu, host_spsr_to_spsr32(spsr));
 	*vcpu_reg32(vcpu, 14) = *vcpu_pc(vcpu) + return_offset;
 
 	/* Branch to exception vector */
-- 
2.20.1

