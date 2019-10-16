Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58A2CDA12B
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbfJPWUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:20:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394903AbfJPVxu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:53:50 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E1F221925;
        Wed, 16 Oct 2019 21:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262829;
        bh=wtk5x1/IBjLHnQsTUzkF8JGFi44DTecZI8E2VRCEmU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ej6Nis/cMgtHBwAe8865Z5++NIIz0tmc68biHebUUsgatGGOQyRaV49KW7NJBpu2G
         DCBBy33K06+I+7KNehn524NhvkC1E6sDN0lXe1RoJBGv4JRJSi95ewbT0bd0t1tDfn
         IQ7lN1XTTZ7tZwKx+K1sQ1JhArwhHpqp41moVX6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Suzuki K. Poulose" <suzuki.poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 72/79] arm64: Rename cpuid_feature field extract routines
Date:   Wed, 16 Oct 2019 14:50:47 -0700
Message-Id: <20191016214829.594553571@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214729.758892904@linuxfoundation.org>
References: <20191016214729.758892904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

commit 28c5dcb22f90113dea101b0421bc6971bccb7a74 upstream

Now that we have a clear understanding of the sign of a feature,
rename the routines to reflect the sign, so that it is not misused.
The cpuid_feature_extract_field() now accepts a 'sign' parameter.

This makes sure that the arm64_ftr_value() extracts the feature
field properly for signed fields.

Cc: stable@vger.kernel.org # v4.4
Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cpufeature.h | 22 ++++++++++++++--------
 arch/arm64/kernel/cpufeature.c      |  2 +-
 arch/arm64/kernel/debug-monitors.c  |  2 +-
 arch/arm64/kvm/sys_regs.c           |  2 +-
 arch/arm64/mm/context.c             |  3 ++-
 5 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 690961a749da1..518eaa63e633e 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -121,15 +121,15 @@ static inline void cpus_set_cap(unsigned int num)
 }
 
 static inline int __attribute_const__
-cpuid_feature_extract_field_width(u64 features, int field, int width)
+cpuid_feature_extract_signed_field_width(u64 features, int field, int width)
 {
 	return (s64)(features << (64 - width - field)) >> (64 - width);
 }
 
 static inline int __attribute_const__
-cpuid_feature_extract_field(u64 features, int field)
+cpuid_feature_extract_signed_field(u64 features, int field)
 {
-	return cpuid_feature_extract_field_width(features, field, 4);
+	return cpuid_feature_extract_signed_field_width(features, field, 4);
 }
 
 static inline unsigned int __attribute_const__
@@ -149,17 +149,23 @@ static inline u64 arm64_ftr_mask(struct arm64_ftr_bits *ftrp)
 	return (u64)GENMASK(ftrp->shift + ftrp->width - 1, ftrp->shift);
 }
 
+static inline int __attribute_const__
+cpuid_feature_extract_field(u64 features, int field, bool sign)
+{
+	return (sign) ?
+		cpuid_feature_extract_signed_field(features, field) :
+		cpuid_feature_extract_unsigned_field(features, field);
+}
+
 static inline s64 arm64_ftr_value(struct arm64_ftr_bits *ftrp, u64 val)
 {
-	return ftrp->sign ?
-		cpuid_feature_extract_field_width(val, ftrp->shift, ftrp->width) :
-		cpuid_feature_extract_unsigned_field_width(val, ftrp->shift, ftrp->width);
+	return (s64)cpuid_feature_extract_field(val, ftrp->shift, ftrp->sign);
 }
 
 static inline bool id_aa64mmfr0_mixed_endian_el0(u64 mmfr0)
 {
-	return cpuid_feature_extract_field(mmfr0, ID_AA64MMFR0_BIGENDEL_SHIFT) == 0x1 ||
-		cpuid_feature_extract_field(mmfr0, ID_AA64MMFR0_BIGENDEL0_SHIFT) == 0x1;
+	return cpuid_feature_extract_unsigned_field(mmfr0, ID_AA64MMFR0_BIGENDEL_SHIFT) == 0x1 ||
+		cpuid_feature_extract_unsigned_field(mmfr0, ID_AA64MMFR0_BIGENDEL0_SHIFT) == 0x1;
 }
 
 void __init setup_cpu_features(void);
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 3949991e544bf..a0118a07a4a5f 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -600,7 +600,7 @@ u64 read_system_reg(u32 id)
 static bool
 feature_matches(u64 reg, const struct arm64_cpu_capabilities *entry)
 {
-	int val = cpuid_feature_extract_field(reg, entry->field_pos);
+	int val = cpuid_feature_extract_field(reg, entry->field_pos, entry->sign);
 
 	return val >= entry->min_field_value;
 }
diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
index c8875b64be909..8e7675e5ce4a5 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -34,7 +34,7 @@
 /* Determine debug architecture. */
 u8 debug_monitors_arch(void)
 {
-	return cpuid_feature_extract_field(read_system_reg(SYS_ID_AA64DFR0_EL1),
+	return cpuid_feature_extract_unsigned_field(read_system_reg(SYS_ID_AA64DFR0_EL1),
 						ID_AA64DFR0_DEBUGVER_SHIFT);
 }
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c2489f62c4fb1..0a587e7b9b6eb 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -687,7 +687,7 @@ static bool trap_dbgidr(struct kvm_vcpu *vcpu,
 	} else {
 		u64 dfr = read_system_reg(SYS_ID_AA64DFR0_EL1);
 		u64 pfr = read_system_reg(SYS_ID_AA64PFR0_EL1);
-		u32 el3 = !!cpuid_feature_extract_field(pfr, ID_AA64PFR0_EL3_SHIFT);
+		u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL3_SHIFT);
 
 		p->regval = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
 			     (((dfr >> ID_AA64DFR0_BRPS_SHIFT) & 0xf) << 24) |
diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index e87f53ff5f583..5c8759cd66f15 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -187,7 +187,8 @@ void check_and_switch_context(struct mm_struct *mm, unsigned int cpu)
 
 static int asids_init(void)
 {
-	int fld = cpuid_feature_extract_field(read_cpuid(ID_AA64MMFR0_EL1), 4);
+	int fld = cpuid_feature_extract_unsigned_field(read_cpuid(ID_AA64MMFR0_EL1),
+						       ID_AA64MMFR0_ASID_SHIFT);
 
 	switch (fld) {
 	default:
-- 
2.20.1



