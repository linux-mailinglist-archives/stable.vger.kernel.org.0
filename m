Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7886F4F6916
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 20:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239804AbiDFSIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 14:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240310AbiDFSHq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 14:07:46 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 300F1100A6D;
        Wed,  6 Apr 2022 09:45:57 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED41823A;
        Wed,  6 Apr 2022 09:45:56 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4AE5C3F73B;
        Wed,  6 Apr 2022 09:45:56 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [stable:PATCH v4.9.309 01/43] arm64: errata: Provide macro for major and minor cpu revisions
Date:   Wed,  6 Apr 2022 17:45:04 +0100
Message-Id: <20220406164546.1888528-1-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <0220406164217.1888053-1-james.morse@arm.com>
References: <0220406164217.1888053-1-james.morse@arm.com>
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

From: Robert Richter <rrichter@cavium.com>

commit fa5ce3d1928c441c3d241c34a00c07c8f5880b1a upstream

Definition of cpu ranges are hard to read if the cpu variant is not
zero. Provide MIDR_CPU_VAR_REV() macro to describe the full hardware
revision of a cpu including variant and (minor) revision.

Signed-off-by: Robert Richter <rrichter@cavium.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
[ morse: some parts of this patch were already backported as part of
  b8c320884eff003581ee61c5970a2e83f513eff1 ]
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/kernel/cpu_errata.c | 15 +++++++++------
 arch/arm64/kernel/cpufeature.c |  8 +++-----
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 3b680a32886b..bf4da33d77e3 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -408,8 +408,9 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 	/* Cortex-A57 r0p0 - r1p2 */
 		.desc = "ARM erratum 832075",
 		.capability = ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE,
-		MIDR_RANGE(MIDR_CORTEX_A57, 0x00,
-			   (1 << MIDR_VARIANT_SHIFT) | 2),
+		MIDR_RANGE(MIDR_CORTEX_A57,
+			   MIDR_CPU_VAR_REV(0, 0),
+			   MIDR_CPU_VAR_REV(1, 2)),
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_834220
@@ -417,8 +418,9 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 	/* Cortex-A57 r0p0 - r1p2 */
 		.desc = "ARM erratum 834220",
 		.capability = ARM64_WORKAROUND_834220,
-		MIDR_RANGE(MIDR_CORTEX_A57, 0x00,
-			   (1 << MIDR_VARIANT_SHIFT) | 2),
+		MIDR_RANGE(MIDR_CORTEX_A57,
+			   MIDR_CPU_VAR_REV(0, 0),
+			   MIDR_CPU_VAR_REV(1, 2)),
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_845719
@@ -442,8 +444,9 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 	/* Cavium ThunderX, T88 pass 1.x - 2.1 */
 		.desc = "Cavium erratum 27456",
 		.capability = ARM64_WORKAROUND_CAVIUM_27456,
-		MIDR_RANGE(MIDR_THUNDERX, 0x00,
-			   (1 << MIDR_VARIANT_SHIFT) | 1),
+		MIDR_RANGE(MIDR_THUNDERX,
+			   MIDR_CPU_VAR_REV(0, 0),
+			   MIDR_CPU_VAR_REV(1, 1)),
 	},
 	{
 	/* Cavium ThunderX, T81 pass 1.0 */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 8cf001baee21..4130a901ae0d 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -728,13 +728,11 @@ static bool has_useable_gicv3_cpuif(const struct arm64_cpu_capabilities *entry,
 static bool has_no_hw_prefetch(const struct arm64_cpu_capabilities *entry, int __unused)
 {
 	u32 midr = read_cpuid_id();
-	u32 rv_min, rv_max;
 
 	/* Cavium ThunderX pass 1.x and 2.x */
-	rv_min = 0;
-	rv_max = (1 << MIDR_VARIANT_SHIFT) | MIDR_REVISION_MASK;
-
-	return MIDR_IS_CPU_MODEL_RANGE(midr, MIDR_THUNDERX, rv_min, rv_max);
+	return MIDR_IS_CPU_MODEL_RANGE(midr, MIDR_THUNDERX,
+		MIDR_CPU_VAR_REV(0, 0),
+		MIDR_CPU_VAR_REV(1, MIDR_REVISION_MASK));
 }
 
 static bool runs_at_el2(const struct arm64_cpu_capabilities *entry, int __unused)
-- 
2.30.2

