Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670404E28BB
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348486AbiCUOAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348924AbiCUN6k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:58:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6384160149;
        Mon, 21 Mar 2022 06:56:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F65FB81675;
        Mon, 21 Mar 2022 13:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19C5C340E8;
        Mon, 21 Mar 2022 13:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647870992;
        bh=P4ItllVK1Q99xOMEu8UZUZ1sPP00zrEDI+e/7a0d0jM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrsLlycvX/83IosmDWalpTCccMwKV6vhf3wnOyAJb7Me9ok85/f9eFZ4b59ctsMD3
         edrP8RhpB2y4zrC46/mr3Xmu1rKjVYJ6T00TexvG8mVmxdRARlzZZqgBTyJv7N5H1K
         idkxcq4Lm0VbyugJOjr9BdpMW0MI9habMULav/I4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joey Gouly <joey.gouly@arm.com>, Will Deacon <will@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Reiji Watanabe <reijiw@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 4.19 43/57] arm64: add ID_AA64ISAR2_EL1 sys register
Date:   Mon, 21 Mar 2022 14:52:24 +0100
Message-Id: <20220321133223.241904559@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133221.984120927@linuxfoundation.org>
References: <20220321133221.984120927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cpu.h    |    1 +
 arch/arm64/include/asm/sysreg.h |    1 +
 arch/arm64/kernel/cpufeature.c  |    9 +++++++++
 arch/arm64/kernel/cpuinfo.c     |    1 +
 arch/arm64/kvm/sys_regs.c       |    2 +-
 5 files changed, 13 insertions(+), 1 deletion(-)

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
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -161,6 +161,7 @@
 
 #define SYS_ID_AA64ISAR0_EL1		sys_reg(3, 0, 0, 6, 0)
 #define SYS_ID_AA64ISAR1_EL1		sys_reg(3, 0, 0, 6, 1)
+#define SYS_ID_AA64ISAR2_EL1		sys_reg(3, 0, 0, 6, 2)
 
 #define SYS_ID_AA64MMFR0_EL1		sys_reg(3, 0, 0, 7, 0)
 #define SYS_ID_AA64MMFR1_EL1		sys_reg(3, 0, 0, 7, 1)
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -150,6 +150,10 @@ static const struct arm64_ftr_bits ftr_i
 	ARM64_FTR_END,
 };
 
+static const struct arm64_ftr_bits ftr_id_aa64isar2[] = {
+	ARM64_FTR_END,
+};
+
 static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_CSV3_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_CSV2_SHIFT, 4, 0),
@@ -396,6 +400,7 @@ static const struct __ftr_reg_entry {
 	/* Op1 = 0, CRn = 0, CRm = 6 */
 	ARM64_FTR_REG(SYS_ID_AA64ISAR0_EL1, ftr_id_aa64isar0),
 	ARM64_FTR_REG(SYS_ID_AA64ISAR1_EL1, ftr_id_aa64isar1),
+	ARM64_FTR_REG(SYS_ID_AA64ISAR2_EL1, ftr_id_aa64isar2),
 
 	/* Op1 = 0, CRn = 0, CRm = 7 */
 	ARM64_FTR_REG(SYS_ID_AA64MMFR0_EL1, ftr_id_aa64mmfr0),
@@ -544,6 +549,7 @@ void __init init_cpu_features(struct cpu
 	init_cpu_ftr_reg(SYS_ID_AA64DFR1_EL1, info->reg_id_aa64dfr1);
 	init_cpu_ftr_reg(SYS_ID_AA64ISAR0_EL1, info->reg_id_aa64isar0);
 	init_cpu_ftr_reg(SYS_ID_AA64ISAR1_EL1, info->reg_id_aa64isar1);
+	init_cpu_ftr_reg(SYS_ID_AA64ISAR2_EL1, info->reg_id_aa64isar2);
 	init_cpu_ftr_reg(SYS_ID_AA64MMFR0_EL1, info->reg_id_aa64mmfr0);
 	init_cpu_ftr_reg(SYS_ID_AA64MMFR1_EL1, info->reg_id_aa64mmfr1);
 	init_cpu_ftr_reg(SYS_ID_AA64MMFR2_EL1, info->reg_id_aa64mmfr2);
@@ -661,6 +667,8 @@ void update_cpu_features(int cpu,
 				      info->reg_id_aa64isar0, boot->reg_id_aa64isar0);
 	taint |= check_update_ftr_reg(SYS_ID_AA64ISAR1_EL1, cpu,
 				      info->reg_id_aa64isar1, boot->reg_id_aa64isar1);
+	taint |= check_update_ftr_reg(SYS_ID_AA64ISAR2_EL1, cpu,
+				      info->reg_id_aa64isar2, boot->reg_id_aa64isar2);
 
 	/*
 	 * Differing PARange support is fine as long as all peripherals and
@@ -794,6 +802,7 @@ static u64 __read_sysreg_by_encoding(u32
 	read_sysreg_case(SYS_ID_AA64MMFR2_EL1);
 	read_sysreg_case(SYS_ID_AA64ISAR0_EL1);
 	read_sysreg_case(SYS_ID_AA64ISAR1_EL1);
+	read_sysreg_case(SYS_ID_AA64ISAR2_EL1);
 
 	read_sysreg_case(SYS_CNTFRQ_EL0);
 	read_sysreg_case(SYS_CTR_EL0);
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -334,6 +334,7 @@ static void __cpuinfo_store_cpu(struct c
 	info->reg_id_aa64dfr1 = read_cpuid(ID_AA64DFR1_EL1);
 	info->reg_id_aa64isar0 = read_cpuid(ID_AA64ISAR0_EL1);
 	info->reg_id_aa64isar1 = read_cpuid(ID_AA64ISAR1_EL1);
+	info->reg_id_aa64isar2 = read_cpuid(ID_AA64ISAR2_EL1);
 	info->reg_id_aa64mmfr0 = read_cpuid(ID_AA64MMFR0_EL1);
 	info->reg_id_aa64mmfr1 = read_cpuid(ID_AA64MMFR1_EL1);
 	info->reg_id_aa64mmfr2 = read_cpuid(ID_AA64MMFR2_EL1);
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1289,7 +1289,7 @@ static const struct sys_reg_desc sys_reg
 	/* CRm=6 */
 	ID_SANITISED(ID_AA64ISAR0_EL1),
 	ID_SANITISED(ID_AA64ISAR1_EL1),
-	ID_UNALLOCATED(6,2),
+	ID_SANITISED(ID_AA64ISAR2_EL1),
 	ID_UNALLOCATED(6,3),
 	ID_UNALLOCATED(6,4),
 	ID_UNALLOCATED(6,5),


