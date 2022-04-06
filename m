Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B887D4F68E3
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 20:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240357AbiDFSJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 14:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240002AbiDFSIO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 14:08:14 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C48713316D;
        Wed,  6 Apr 2022 09:46:33 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5369F1516;
        Wed,  6 Apr 2022 09:46:33 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A66783F73B;
        Wed,  6 Apr 2022 09:46:32 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [stable:PATCH v4.9.309 35/43] arm64: Move arm64_update_smccc_conduit() out of SSBD ifdef
Date:   Wed,  6 Apr 2022 17:45:38 +0100
Message-Id: <20220406164546.1888528-35-james.morse@arm.com>
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

arm64_update_smccc_conduit() is an alternative callback that patches
HVC/SMC. Currently the only user is SSBD. To use this for Spectre-BHB,
it needs to be moved out of the SSBD #ifdef region.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/kernel/cpu_errata.c | 44 +++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 37cb8c23ccc6..0d08249cbdab 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -204,6 +204,28 @@ enable_smccc_arch_workaround_1(const struct arm64_cpu_capabilities *entry)
 }
 #endif	/* CONFIG_HARDEN_BRANCH_PREDICTOR */
 
+void __init arm64_update_smccc_conduit(struct alt_instr *alt,
+				       __le32 *origptr, __le32 *updptr,
+				       int nr_inst)
+{
+	u32 insn;
+
+	BUG_ON(nr_inst != 1);
+
+	switch (psci_ops.conduit) {
+	case PSCI_CONDUIT_HVC:
+		insn = aarch64_insn_get_hvc_value();
+		break;
+	case PSCI_CONDUIT_SMC:
+		insn = aarch64_insn_get_smc_value();
+		break;
+	default:
+		return;
+	}
+
+	*updptr = cpu_to_le32(insn);
+}
+
 #ifdef CONFIG_ARM64_SSBD
 DEFINE_PER_CPU_READ_MOSTLY(u64, arm64_ssbd_callback_required);
 
@@ -239,28 +261,6 @@ static int __init ssbd_cfg(char *buf)
 }
 early_param("ssbd", ssbd_cfg);
 
-void __init arm64_update_smccc_conduit(struct alt_instr *alt,
-				       __le32 *origptr, __le32 *updptr,
-				       int nr_inst)
-{
-	u32 insn;
-
-	BUG_ON(nr_inst != 1);
-
-	switch (psci_ops.conduit) {
-	case PSCI_CONDUIT_HVC:
-		insn = aarch64_insn_get_hvc_value();
-		break;
-	case PSCI_CONDUIT_SMC:
-		insn = aarch64_insn_get_smc_value();
-		break;
-	default:
-		return;
-	}
-
-	*updptr = cpu_to_le32(insn);
-}
-
 void __init arm64_enable_wa2_handling(struct alt_instr *alt,
 				      __le32 *origptr, __le32 *updptr,
 				      int nr_inst)
-- 
2.30.2

