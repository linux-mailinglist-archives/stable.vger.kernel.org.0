Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2314F69A6
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 21:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiDFTR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 15:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiDFTPy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 15:15:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9C127FCBB;
        Wed,  6 Apr 2022 11:28:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63DB461B89;
        Wed,  6 Apr 2022 18:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F89C385A1;
        Wed,  6 Apr 2022 18:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649269692;
        bh=01v3XoePHGzw/UoYUpx/8ppu8DorS5rqyoT218B2w50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZ/R4KHDgbKeWe6kh88kEdEts6m7DMHcPtdDc1lfN5WcsbJCTbs2zKuPBqckQGIyg
         bLvGXTJK7NGiwjq0wMsM4CEAQmp88hbIIGh8b7Cd2ZWZpjmp+TseiV1YcixTqK5GLV
         3n8VCBj5iVPuEPCXqkaXfD6IuyEAtBj4HPfGi8ow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dave Martin <dave.martin@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.9 09/43] arm64: capabilities: Clean up midr range helpers
Date:   Wed,  6 Apr 2022 20:26:18 +0200
Message-Id: <20220406182436.955249794@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220406182436.675069715@linuxfoundation.org>
References: <20220406182436.675069715@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 5e7951ce19abf4113645ae789c033917356ee96f ]

We are about to introduce generic MIDR range helpers. Clean
up the existing helpers in erratum handling, preparing them
to use generic version.

Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpu_errata.c |   82 +++++++++++++++++++++++++----------------
 1 file changed, 50 insertions(+), 32 deletions(-)

--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -368,20 +368,38 @@ static bool has_ssbd_mitigation(const st
 }
 #endif	/* CONFIG_ARM64_SSBD */
 
-#define MIDR_RANGE(model, min, max) \
-	.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM, \
-	.matches = is_affected_midr_range, \
-	.midr_model = model, \
-	.midr_range_min = min, \
-	.midr_range_max = max
-
-#define MIDR_ALL_VERSIONS(model) \
-	.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM, \
-	.matches = is_affected_midr_range, \
-	.midr_model = model, \
-	.midr_range_min = 0, \
+#define CAP_MIDR_RANGE(model, v_min, r_min, v_max, r_max)	\
+	.matches = is_affected_midr_range,			\
+	.midr_model = model,					\
+	.midr_range_min = MIDR_CPU_VAR_REV(v_min, r_min),	\
+	.midr_range_max = MIDR_CPU_VAR_REV(v_max, r_max)
+
+#define CAP_MIDR_ALL_VERSIONS(model)					\
+	.matches = is_affected_midr_range,				\
+	.midr_model = model,						\
+	.midr_range_min = MIDR_CPU_VAR_REV(0, 0),			\
 	.midr_range_max = (MIDR_VARIANT_MASK | MIDR_REVISION_MASK)
 
+#define MIDR_FIXED(rev, revidr_mask) \
+	.fixed_revs = (struct arm64_midr_revidr[]){{ (rev), (revidr_mask) }, {}}
+
+#define ERRATA_MIDR_RANGE(model, v_min, r_min, v_max, r_max)		\
+	.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,				\
+	CAP_MIDR_RANGE(model, v_min, r_min, v_max, r_max)
+
+/* Errata affecting a range of revisions of  given model variant */
+#define ERRATA_MIDR_REV_RANGE(m, var, r_min, r_max)	 \
+	ERRATA_MIDR_RANGE(m, var, r_min, var, r_max)
+
+/* Errata affecting a single variant/revision of a model */
+#define ERRATA_MIDR_REV(model, var, rev)	\
+	ERRATA_MIDR_RANGE(model, var, rev, var, rev)
+
+/* Errata affecting all variants/revisions of a given a model */
+#define ERRATA_MIDR_ALL_VERSIONS(model)				\
+	.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,			\
+	CAP_MIDR_ALL_VERSIONS(model)
+
 const struct arm64_cpu_capabilities arm64_errata[] = {
 #if	defined(CONFIG_ARM64_ERRATUM_826319) || \
 	defined(CONFIG_ARM64_ERRATUM_827319) || \
@@ -390,7 +408,7 @@ const struct arm64_cpu_capabilities arm6
 	/* Cortex-A53 r0p[012] */
 		.desc = "ARM errata 826319, 827319, 824069",
 		.capability = ARM64_WORKAROUND_CLEAN_CACHE,
-		MIDR_RANGE(MIDR_CORTEX_A53, 0x00, 0x02),
+		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A53, 0, 0, 2),
 		.cpu_enable = cpu_enable_cache_maint_trap,
 	},
 #endif
@@ -399,7 +417,7 @@ const struct arm64_cpu_capabilities arm6
 	/* Cortex-A53 r0p[01] */
 		.desc = "ARM errata 819472",
 		.capability = ARM64_WORKAROUND_CLEAN_CACHE,
-		MIDR_RANGE(MIDR_CORTEX_A53, 0x00, 0x01),
+		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A53, 0, 0, 1),
 		.cpu_enable = cpu_enable_cache_maint_trap,
 	},
 #endif
@@ -408,9 +426,9 @@ const struct arm64_cpu_capabilities arm6
 	/* Cortex-A57 r0p0 - r1p2 */
 		.desc = "ARM erratum 832075",
 		.capability = ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE,
-		MIDR_RANGE(MIDR_CORTEX_A57,
-			   MIDR_CPU_VAR_REV(0, 0),
-			   MIDR_CPU_VAR_REV(1, 2)),
+		ERRATA_MIDR_RANGE(MIDR_CORTEX_A57,
+				  0, 0,
+				  1, 2),
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_834220
@@ -418,9 +436,9 @@ const struct arm64_cpu_capabilities arm6
 	/* Cortex-A57 r0p0 - r1p2 */
 		.desc = "ARM erratum 834220",
 		.capability = ARM64_WORKAROUND_834220,
-		MIDR_RANGE(MIDR_CORTEX_A57,
-			   MIDR_CPU_VAR_REV(0, 0),
-			   MIDR_CPU_VAR_REV(1, 2)),
+		ERRATA_MIDR_RANGE(MIDR_CORTEX_A57,
+				  0, 0,
+				  1, 2),
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_845719
@@ -428,7 +446,7 @@ const struct arm64_cpu_capabilities arm6
 	/* Cortex-A53 r0p[01234] */
 		.desc = "ARM erratum 845719",
 		.capability = ARM64_WORKAROUND_845719,
-		MIDR_RANGE(MIDR_CORTEX_A53, 0x00, 0x04),
+		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A53, 0, 0, 4),
 	},
 #endif
 #ifdef CONFIG_CAVIUM_ERRATUM_23154
@@ -436,7 +454,7 @@ const struct arm64_cpu_capabilities arm6
 	/* Cavium ThunderX, pass 1.x */
 		.desc = "Cavium erratum 23154",
 		.capability = ARM64_WORKAROUND_CAVIUM_23154,
-		MIDR_RANGE(MIDR_THUNDERX, 0x00, 0x01),
+		ERRATA_MIDR_REV_RANGE(MIDR_THUNDERX, 0, 0, 1),
 	},
 #endif
 #ifdef CONFIG_CAVIUM_ERRATUM_27456
@@ -444,15 +462,15 @@ const struct arm64_cpu_capabilities arm6
 	/* Cavium ThunderX, T88 pass 1.x - 2.1 */
 		.desc = "Cavium erratum 27456",
 		.capability = ARM64_WORKAROUND_CAVIUM_27456,
-		MIDR_RANGE(MIDR_THUNDERX,
-			   MIDR_CPU_VAR_REV(0, 0),
-			   MIDR_CPU_VAR_REV(1, 1)),
+		ERRATA_MIDR_RANGE(MIDR_THUNDERX,
+				  0, 0,
+				  1, 1),
 	},
 	{
 	/* Cavium ThunderX, T81 pass 1.0 */
 		.desc = "Cavium erratum 27456",
 		.capability = ARM64_WORKAROUND_CAVIUM_27456,
-		MIDR_RANGE(MIDR_THUNDERX_81XX, 0x00, 0x00),
+		ERRATA_MIDR_REV(MIDR_THUNDERX_81XX, 0, 0),
 	},
 #endif
 	{
@@ -472,32 +490,32 @@ const struct arm64_cpu_capabilities arm6
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
+		ERRATA_MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
 		.cpu_enable = enable_smccc_arch_workaround_1,
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
+		ERRATA_MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
 		.cpu_enable = enable_smccc_arch_workaround_1,
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
+		ERRATA_MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
 		.cpu_enable = enable_smccc_arch_workaround_1,
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		MIDR_ALL_VERSIONS(MIDR_CORTEX_A75),
+		ERRATA_MIDR_ALL_VERSIONS(MIDR_CORTEX_A75),
 		.cpu_enable = enable_smccc_arch_workaround_1,
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		MIDR_ALL_VERSIONS(MIDR_BRCM_VULCAN),
+		ERRATA_MIDR_ALL_VERSIONS(MIDR_BRCM_VULCAN),
 		.cpu_enable = enable_smccc_arch_workaround_1,
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		MIDR_ALL_VERSIONS(MIDR_CAVIUM_THUNDERX2),
+		ERRATA_MIDR_ALL_VERSIONS(MIDR_CAVIUM_THUNDERX2),
 		.cpu_enable = enable_smccc_arch_workaround_1,
 	},
 #endif


