Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB1A4F68D0
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 20:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240180AbiDFSKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 14:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240142AbiDFSIz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 14:08:55 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1073D1AA04D;
        Wed,  6 Apr 2022 09:46:39 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 927931516;
        Wed,  6 Apr 2022 09:46:39 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E55E43F73B;
        Wed,  6 Apr 2022 09:46:38 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [stable:PATCH v4.9.309 42/43] arm64: add ID_AA64ISAR2_EL1 sys register
Date:   Wed,  6 Apr 2022 17:45:45 +0100
Message-Id: <20220406164546.1888528-42-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406164546.1888528-1-james.morse@arm.com>
References: <0220406164217.1888053-1-james.morse@arm.com>
 <20220406164546.1888528-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 9e45365f1469ef2b934f9d035975dbc9ad352116 upstream.

This is a new ID register, introduced in 8.7.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Reiji Watanabe <reijiw@google.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211210165432.8106-3-joey.gouly@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/cpu.h    | 1 +
 arch/arm64/include/asm/sysreg.h | 1 +
 arch/arm64/kernel/cpufeature.c  | 9 +++++++++
 arch/arm64/kernel/cpuinfo.c     | 1 +
 4 files changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/cpu.h b/arch/arm64/include/asm/cpu.h
index 889226b4c6e1..c7f17e663e72 100644
--- a/arch/arm64/include/asm/cpu.h
+++ b/arch/arm64/include/asm/cpu.h
@@ -36,6 +36,7 @@ struct cpuinfo_arm64 {
 	u64		reg_id_aa64dfr1;
 	u64		reg_id_aa64isar0;
 	u64		reg_id_aa64isar1;
+	u64		reg_id_aa64isar2;
 	u64		reg_id_aa64mmfr0;
 	u64		reg_id_aa64mmfr1;
 	u64		reg_id_aa64mmfr2;
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index cc06bbabed22..dc03704ccc79 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -70,6 +70,7 @@
 
 #define SYS_ID_AA64ISAR0_EL1		sys_reg(3, 0, 0, 6, 0)
 #define SYS_ID_AA64ISAR1_EL1		sys_reg(3, 0, 0, 6, 1)
+#define SYS_ID_AA64ISAR2_EL1		sys_reg(3, 0, 0, 6, 2)
 
 #define SYS_ID_AA64MMFR0_EL1		sys_reg(3, 0, 0, 7, 0)
 #define SYS_ID_AA64MMFR1_EL1		sys_reg(3, 0, 0, 7, 1)
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index b4a6f881c3c0..82590761db64 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -98,6 +98,10 @@ static const struct arm64_ftr_bits ftr_id_aa64isar0[] = {
 	ARM64_FTR_END,
 };
 
+static const struct arm64_ftr_bits ftr_id_aa64isar2[] = {
+	ARM64_FTR_END,
+};
+
 static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
 	ARM64_FTR_BITS(FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_CSV3_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_CSV2_SHIFT, 4, 0),
@@ -332,6 +336,7 @@ static const struct __ftr_reg_entry {
 	/* Op1 = 0, CRn = 0, CRm = 6 */
 	ARM64_FTR_REG(SYS_ID_AA64ISAR0_EL1, ftr_id_aa64isar0),
 	ARM64_FTR_REG(SYS_ID_AA64ISAR1_EL1, ftr_aa64raz),
+	ARM64_FTR_REG(SYS_ID_AA64ISAR2_EL1, ftr_id_aa64isar2),
 
 	/* Op1 = 0, CRn = 0, CRm = 7 */
 	ARM64_FTR_REG(SYS_ID_AA64MMFR0_EL1, ftr_id_aa64mmfr0),
@@ -459,6 +464,7 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
 	init_cpu_ftr_reg(SYS_ID_AA64DFR1_EL1, info->reg_id_aa64dfr1);
 	init_cpu_ftr_reg(SYS_ID_AA64ISAR0_EL1, info->reg_id_aa64isar0);
 	init_cpu_ftr_reg(SYS_ID_AA64ISAR1_EL1, info->reg_id_aa64isar1);
+	init_cpu_ftr_reg(SYS_ID_AA64ISAR2_EL1, info->reg_id_aa64isar2);
 	init_cpu_ftr_reg(SYS_ID_AA64MMFR0_EL1, info->reg_id_aa64mmfr0);
 	init_cpu_ftr_reg(SYS_ID_AA64MMFR1_EL1, info->reg_id_aa64mmfr1);
 	init_cpu_ftr_reg(SYS_ID_AA64MMFR2_EL1, info->reg_id_aa64mmfr2);
@@ -570,6 +576,8 @@ void update_cpu_features(int cpu,
 				      info->reg_id_aa64isar0, boot->reg_id_aa64isar0);
 	taint |= check_update_ftr_reg(SYS_ID_AA64ISAR1_EL1, cpu,
 				      info->reg_id_aa64isar1, boot->reg_id_aa64isar1);
+	taint |= check_update_ftr_reg(SYS_ID_AA64ISAR2_EL1, cpu,
+				      info->reg_id_aa64isar2, boot->reg_id_aa64isar2);
 
 	/*
 	 * Differing PARange support is fine as long as all peripherals and
@@ -689,6 +697,7 @@ static u64 __raw_read_system_reg(u32 sys_id)
 	case SYS_ID_AA64MMFR2_EL1:	return read_cpuid(ID_AA64MMFR2_EL1);
 	case SYS_ID_AA64ISAR0_EL1:	return read_cpuid(ID_AA64ISAR0_EL1);
 	case SYS_ID_AA64ISAR1_EL1:	return read_cpuid(ID_AA64ISAR1_EL1);
+	case SYS_ID_AA64ISAR2_EL1:	return read_cpuid(ID_AA64ISAR2_EL1);
 
 	case SYS_CNTFRQ_EL0:		return read_cpuid(CNTFRQ_EL0);
 	case SYS_CTR_EL0:		return read_cpuid(CTR_EL0);
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index b3d5b3e8fbcb..4c09f87650f4 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -335,6 +335,7 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
 	info->reg_id_aa64dfr1 = read_cpuid(ID_AA64DFR1_EL1);
 	info->reg_id_aa64isar0 = read_cpuid(ID_AA64ISAR0_EL1);
 	info->reg_id_aa64isar1 = read_cpuid(ID_AA64ISAR1_EL1);
+	info->reg_id_aa64isar2 = read_cpuid(ID_AA64ISAR2_EL1);
 	info->reg_id_aa64mmfr0 = read_cpuid(ID_AA64MMFR0_EL1);
 	info->reg_id_aa64mmfr1 = read_cpuid(ID_AA64MMFR1_EL1);
 	info->reg_id_aa64mmfr2 = read_cpuid(ID_AA64MMFR2_EL1);
-- 
2.30.2

