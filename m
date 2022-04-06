Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590F14F6B33
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 22:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234233AbiDFUVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 16:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbiDFUU1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 16:20:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D69220E6;
        Wed,  6 Apr 2022 11:26:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 607DEB8252B;
        Wed,  6 Apr 2022 18:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947C9C385A3;
        Wed,  6 Apr 2022 18:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649269616;
        bh=EG86lUMKTGds4UWGtqE3tllOSx9i5zBcjo9UGNZOtQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dAwaEtcT6NpXgrGL2ac1I7tjX5a0AhK1MwM+leBERA9a/dCL024gn7QEpQXd2Vpva
         vGca3RRPtsF8Pd2br0AOltk8xD88NX3oBzRf0CmCfxAEfALKFYJmu5LMI27WDkHZYY
         Aej9O+T7tZVfQdWvkPCsR6kZSDmvE4HQ3WRp5CWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Richter <rrichter@cavium.com>,
        Will Deacon <will.deacon@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.9 01/43] arm64: errata: Provide macro for major and minor cpu revisions
Date:   Wed,  6 Apr 2022 20:26:10 +0200
Message-Id: <20220406182436.719643148@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220406182436.675069715@linuxfoundation.org>
References: <20220406182436.675069715@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpu_errata.c |   15 +++++++++------
 arch/arm64/kernel/cpufeature.c |    8 +++-----
 2 files changed, 12 insertions(+), 11 deletions(-)

--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -408,8 +408,9 @@ const struct arm64_cpu_capabilities arm6
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
@@ -417,8 +418,9 @@ const struct arm64_cpu_capabilities arm6
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
@@ -442,8 +444,9 @@ const struct arm64_cpu_capabilities arm6
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
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -728,13 +728,11 @@ static bool has_useable_gicv3_cpuif(cons
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


