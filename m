Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361F14DC64B
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 13:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234017AbiCQMu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 08:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbiCQMuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 08:50:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7001F42E4;
        Thu, 17 Mar 2022 05:48:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A073361463;
        Thu, 17 Mar 2022 12:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFDB4C340EF;
        Thu, 17 Mar 2022 12:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647521319;
        bh=7BSRLWehvSlpu2iwl0pNbaMSxnfolR33fdkmLc5+jQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YTkhBSiNgxWoLlRQcB7jWcqTmnpwt13XaCKAV3qzhQLkbxTbLbbnZiObSnI8RhBVw
         x9YaBktDqZWoQimvsYo/KCxL7/nAQeHr/2ijKP/NplIaJ3qdkvciaogdF0II4HKuSP
         Qa3bKVsppyaELypBckfRhL0xjFmbGwJTGYadwJuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Reiji Watanabe <reijiw@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 05/43] arm64: add ID_AA64ISAR2_EL1 sys register
Date:   Thu, 17 Mar 2022 13:45:16 +0100
Message-Id: <20220317124527.825733305@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317124527.672236844@linuxfoundation.org>
References: <20220317124527.672236844@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joey Gouly <joey.gouly@arm.com>

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cpu.h    |  1 +
 arch/arm64/include/asm/sysreg.h | 15 +++++++++++++++
 arch/arm64/kernel/cpufeature.c  |  9 +++++++++
 arch/arm64/kernel/cpuinfo.c     |  1 +
 arch/arm64/kvm/sys_regs.c       |  2 +-
 5 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpu.h b/arch/arm64/include/asm/cpu.h
index d72d995b7e25..85cc06380e93 100644
--- a/arch/arm64/include/asm/cpu.h
+++ b/arch/arm64/include/asm/cpu.h
@@ -25,6 +25,7 @@ struct cpuinfo_arm64 {
 	u64		reg_id_aa64dfr1;
 	u64		reg_id_aa64isar0;
 	u64		reg_id_aa64isar1;
+	u64		reg_id_aa64isar2;
 	u64		reg_id_aa64mmfr0;
 	u64		reg_id_aa64mmfr1;
 	u64		reg_id_aa64mmfr2;
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 9b68f1b3915e..50ed2747c572 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -165,6 +165,7 @@
 
 #define SYS_ID_AA64ISAR0_EL1		sys_reg(3, 0, 0, 6, 0)
 #define SYS_ID_AA64ISAR1_EL1		sys_reg(3, 0, 0, 6, 1)
+#define SYS_ID_AA64ISAR2_EL1		sys_reg(3, 0, 0, 6, 2)
 
 #define SYS_ID_AA64MMFR0_EL1		sys_reg(3, 0, 0, 7, 0)
 #define SYS_ID_AA64MMFR1_EL1		sys_reg(3, 0, 0, 7, 1)
@@ -575,6 +576,20 @@
 #define ID_AA64ISAR1_GPI_NI		0x0
 #define ID_AA64ISAR1_GPI_IMP_DEF	0x1
 
+/* id_aa64isar2 */
+#define ID_AA64ISAR2_RPRES_SHIFT	4
+#define ID_AA64ISAR2_WFXT_SHIFT		0
+
+#define ID_AA64ISAR2_RPRES_8BIT		0x0
+#define ID_AA64ISAR2_RPRES_12BIT	0x1
+/*
+ * Value 0x1 has been removed from the architecture, and is
+ * reserved, but has not yet been removed from the ARM ARM
+ * as of ARM DDI 0487G.b.
+ */
+#define ID_AA64ISAR2_WFXT_NI		0x0
+#define ID_AA64ISAR2_WFXT_SUPPORTED	0x2
+
 /* id_aa64pfr0 */
 #define ID_AA64PFR0_CSV3_SHIFT		60
 #define ID_AA64PFR0_CSV2_SHIFT		56
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index acdef8d76c64..6b77e4942495 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -150,6 +150,10 @@ static const struct arm64_ftr_bits ftr_id_aa64isar1[] = {
 	ARM64_FTR_END,
 };
 
+static const struct arm64_ftr_bits ftr_id_aa64isar2[] = {
+	ARM64_FTR_END,
+};
+
 static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_CSV3_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_CSV2_SHIFT, 4, 0),
@@ -410,6 +414,7 @@ static const struct __ftr_reg_entry {
 	/* Op1 = 0, CRn = 0, CRm = 6 */
 	ARM64_FTR_REG(SYS_ID_AA64ISAR0_EL1, ftr_id_aa64isar0),
 	ARM64_FTR_REG(SYS_ID_AA64ISAR1_EL1, ftr_id_aa64isar1),
+	ARM64_FTR_REG(SYS_ID_AA64ISAR2_EL1, ftr_id_aa64isar2),
 
 	/* Op1 = 0, CRn = 0, CRm = 7 */
 	ARM64_FTR_REG(SYS_ID_AA64MMFR0_EL1, ftr_id_aa64mmfr0),
@@ -581,6 +586,7 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
 	init_cpu_ftr_reg(SYS_ID_AA64DFR1_EL1, info->reg_id_aa64dfr1);
 	init_cpu_ftr_reg(SYS_ID_AA64ISAR0_EL1, info->reg_id_aa64isar0);
 	init_cpu_ftr_reg(SYS_ID_AA64ISAR1_EL1, info->reg_id_aa64isar1);
+	init_cpu_ftr_reg(SYS_ID_AA64ISAR2_EL1, info->reg_id_aa64isar2);
 	init_cpu_ftr_reg(SYS_ID_AA64MMFR0_EL1, info->reg_id_aa64mmfr0);
 	init_cpu_ftr_reg(SYS_ID_AA64MMFR1_EL1, info->reg_id_aa64mmfr1);
 	init_cpu_ftr_reg(SYS_ID_AA64MMFR2_EL1, info->reg_id_aa64mmfr2);
@@ -704,6 +710,8 @@ void update_cpu_features(int cpu,
 				      info->reg_id_aa64isar0, boot->reg_id_aa64isar0);
 	taint |= check_update_ftr_reg(SYS_ID_AA64ISAR1_EL1, cpu,
 				      info->reg_id_aa64isar1, boot->reg_id_aa64isar1);
+	taint |= check_update_ftr_reg(SYS_ID_AA64ISAR2_EL1, cpu,
+				      info->reg_id_aa64isar2, boot->reg_id_aa64isar2);
 
 	/*
 	 * Differing PARange support is fine as long as all peripherals and
@@ -838,6 +846,7 @@ static u64 __read_sysreg_by_encoding(u32 sys_id)
 	read_sysreg_case(SYS_ID_AA64MMFR2_EL1);
 	read_sysreg_case(SYS_ID_AA64ISAR0_EL1);
 	read_sysreg_case(SYS_ID_AA64ISAR1_EL1);
+	read_sysreg_case(SYS_ID_AA64ISAR2_EL1);
 
 	read_sysreg_case(SYS_CNTFRQ_EL0);
 	read_sysreg_case(SYS_CTR_EL0);
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 05933c065732..90b35011a22f 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -344,6 +344,7 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
 	info->reg_id_aa64dfr1 = read_cpuid(ID_AA64DFR1_EL1);
 	info->reg_id_aa64isar0 = read_cpuid(ID_AA64ISAR0_EL1);
 	info->reg_id_aa64isar1 = read_cpuid(ID_AA64ISAR1_EL1);
+	info->reg_id_aa64isar2 = read_cpuid(ID_AA64ISAR2_EL1);
 	info->reg_id_aa64mmfr0 = read_cpuid(ID_AA64MMFR0_EL1);
 	info->reg_id_aa64mmfr1 = read_cpuid(ID_AA64MMFR1_EL1);
 	info->reg_id_aa64mmfr2 = read_cpuid(ID_AA64MMFR2_EL1);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index da649e90240c..a25f737dfa0b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1454,7 +1454,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	/* CRm=6 */
 	ID_SANITISED(ID_AA64ISAR0_EL1),
 	ID_SANITISED(ID_AA64ISAR1_EL1),
-	ID_UNALLOCATED(6,2),
+	ID_SANITISED(ID_AA64ISAR2_EL1),
 	ID_UNALLOCATED(6,3),
 	ID_UNALLOCATED(6,4),
 	ID_UNALLOCATED(6,5),
-- 
2.34.1



