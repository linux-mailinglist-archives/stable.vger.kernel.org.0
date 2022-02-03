Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 195934A8DE3
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354667AbiBCUdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354475AbiBCUci (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:32:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D960C0613E4;
        Thu,  3 Feb 2022 12:32:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16D32B835A3;
        Thu,  3 Feb 2022 20:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B23AC340E8;
        Thu,  3 Feb 2022 20:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920342;
        bh=CvrnKzfGiFqdvtJF/lFdhAZT7jrKvco/zQIMZOZYKAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iY20OPbUH0RFCp3hxcdRMw34HSpvy8zYWRVITJAm/4Pqu44S692fXoPh1ACXXw8Ld
         vItkjLk6GZRtjqsNqAryNfM1k4fLyzNSp39Fsnz8X0Sq/W3D5aHScQwQQSpF1sZzzw
         M6V3mo+Qu/w94UhJDyEhS/gTicLutdWvq0epDN6/U9YrXGS0yYEmSLinYGbcm7dgd2
         FNZMXVMrwaiEhcIrW2W2mB6/MJWoIZfumAVpjaztKklyn/ICacoJmgZjKEaThc4M+B
         9MYFIEr0lTyc+gCtYqGqRX4i2cK+X554SlHrvGb/h3CzF0puG3sP0qyt+FulhiXuD+
         B1coFepOv5umg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anshuman Khandual <anshuman.khandual@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki Poulose <suzuki.poulose@arm.com>,
        coresight@lists.linaro.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sasha Levin <sashal@kernel.org>, corbet@lwn.net,
        mark.rutland@arm.com, rwiley@nvidia.com, maz@kernel.org,
        vincenzo.frascino@arm.com, broonie@kernel.org
Subject: [PATCH AUTOSEL 5.16 47/52] arm64: errata: Add detection for TRBE ignored system register writes
Date:   Thu,  3 Feb 2022 15:29:41 -0500
Message-Id: <20220203202947.2304-47-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203202947.2304-1-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>

[ Upstream commit 607a9afaae09cde21ece458a8f10cb99d3f94f14 ]

TRBE implementations affected by Arm erratum #2064142 might fail to write
into certain system registers after the TRBE has been disabled. Under some
conditions after TRBE has been disabled, writes into certain TRBE registers
TRBLIMITR_EL1, TRBPTR_EL1, TRBBASER_EL1, TRBSR_EL1 and TRBTRG_EL1 will be
ignored and not be effected. This adds a new errata ARM64_ERRATUM_2064142
in arm64 errata framework.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Suzuki Poulose <suzuki.poulose@arm.com>
Cc: coresight@lists.linaro.org
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/1643120437-14352-3-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arm64/silicon-errata.rst |  2 ++
 arch/arm64/Kconfig                     | 18 ++++++++++++++++++
 arch/arm64/kernel/cpu_errata.c         |  9 +++++++++
 arch/arm64/tools/cpucaps               |  1 +
 4 files changed, 30 insertions(+)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 8789c79310bbd..401a6e86c5084 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -52,6 +52,8 @@ stable kernels.
 | Allwinner      | A64/R18         | UNKNOWN1        | SUN50I_ERRATUM_UNKNOWN1     |
 +----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A510     | #2064142        | ARM64_ERRATUM_2064142       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A53      | #826319         | ARM64_ERRATUM_826319        |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A53      | #827319         | ARM64_ERRATUM_827319        |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index d8046c832225c..30c07b0d6b5c9 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -778,6 +778,24 @@ config ARM64_ERRATUM_2224489
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_2064142
+	bool "Cortex-A510: 2064142: workaround TRBE register writes while disabled"
+	depends on COMPILE_TEST # Until the CoreSight TRBE driver changes are in
+	default y
+	help
+	  This option adds the workaround for ARM Cortex-A510 erratum 2064142.
+
+	  Affected Cortex-A510 core might fail to write into system registers after the
+	  TRBE has been disabled. Under some conditions after the TRBE has been disabled
+	  writes into TRBE registers TRBLIMITR_EL1, TRBPTR_EL1, TRBBASER_EL1, TRBSR_EL1,
+	  and TRBTRG_EL1 will be ignored and will not be effected.
+
+	  Work around this in the driver by executing TSB CSYNC and DSB after collection
+	  is stopped and before performing a system register write to one of the affected
+	  registers.
+
+	  If unsure, say Y.
+
 config CAVIUM_ERRATUM_22375
 	bool "Cavium erratum 22375, 24313"
 	default y
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 29cc062a4153c..a5456dd9a33f5 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -599,6 +599,15 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.type = ARM64_CPUCAP_WEAK_LOCAL_CPU_FEATURE,
 		CAP_MIDR_RANGE_LIST(trbe_write_out_of_range_cpus),
 	},
+#endif
+#ifdef CONFIG_ARM64_ERRATUM_2064142
+	{
+		.desc = "ARM erratum 2064142",
+		.capability = ARM64_WORKAROUND_2064142,
+
+		/* Cortex-A510 r0p0 - r0p2 */
+		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A510, 0, 0, 2)
+	},
 #endif
 	{
 	}
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 870c39537dd09..fca3cb329e1db 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -55,6 +55,7 @@ WORKAROUND_1418040
 WORKAROUND_1463225
 WORKAROUND_1508412
 WORKAROUND_1542419
+WORKAROUND_2064142
 WORKAROUND_TRBE_OVERWRITE_FILL_MODE
 WORKAROUND_TSB_FLUSH_FAILURE
 WORKAROUND_TRBE_WRITE_OUT_OF_RANGE
-- 
2.34.1

