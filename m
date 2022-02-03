Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDDA54A8DEF
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354896AbiBCUdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354498AbiBCUcj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:32:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6DAC0617AD;
        Thu,  3 Feb 2022 12:32:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5953361A6A;
        Thu,  3 Feb 2022 20:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1173BC340E8;
        Thu,  3 Feb 2022 20:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920355;
        bh=kWOgTfx40X8rEWQMQ0Dg3JPmDTKX9nTV5Sw50vDlTxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HOV+Hqtr5bjbCZBvKauqsPVL9tBwYu6t0xbSIrSm2r/RKGRwnQl0y+KMJ7lfj6bQO
         SaYh21OWhMWOw7Mr8pYbSl31NFvfC7RLw75siJLIBTADFd7sPLDht20aTibfHMfIa4
         pocjmkkdv56K9x8cjVhqKnkzR+8XH6cNvtL4NzTvFTsrrTQ0+VmsnwPJVrYAn2U29U
         YokrKVyaZtW/8DD9U7UDO1iSdwzagWvZjKBVqHycn8Y9UVXxFVqJHuNmrO4Za3Zxve
         mZfcItYLoCYd2JDw+0QwLsIzHe0pAz1/7n1uSPP+vP03V8NYANJ9V5zjLHbtjtu9VO
         pVGTaGuTPOavA==
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
        rwiley@nvidia.com, mark.rutland@arm.com, maz@kernel.org,
        vincenzo.frascino@arm.com, broonie@kernel.org
Subject: [PATCH AUTOSEL 5.16 49/52] arm64: errata: Add detection for TRBE trace data corruption
Date:   Thu,  3 Feb 2022 15:29:43 -0500
Message-Id: <20220203202947.2304-49-sashal@kernel.org>
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

[ Upstream commit 708e8af4924ec2fdd5b81fe09192c6bac2f86935 ]

TRBE implementations affected by Arm erratum #1902691 might corrupt trace
data or deadlock, when it's being written into the memory. So effectively
TRBE is broken and hence cannot be used to capture trace data. This adds
a new errata ARM64_ERRATUM_1902691 in arm64 errata framework.

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
Link: https://lore.kernel.org/r/1643120437-14352-5-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arm64/silicon-errata.rst |  2 ++
 arch/arm64/Kconfig                     | 18 ++++++++++++++++++
 arch/arm64/kernel/cpu_errata.c         |  9 +++++++++
 arch/arm64/tools/cpucaps               |  1 +
 4 files changed, 30 insertions(+)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index d5c6befc44eb8..1b0e53ececda9 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -56,6 +56,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A510     | #2038923        | ARM64_ERRATUM_2038923       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A510     | #1902691        | ARM64_ERRATUM_1902691       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A53      | #826319         | ARM64_ERRATUM_826319        |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A53      | #827319         | ARM64_ERRATUM_827319        |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 2b75e8a9bf88c..7d710589e1818 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -819,6 +819,24 @@ config ARM64_ERRATUM_2038923
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_1902691
+	bool "Cortex-A510: 1902691: workaround TRBE trace corruption"
+	depends on COMPILE_TEST # Until the CoreSight TRBE driver changes are in
+	default y
+	help
+	  This option adds the workaround for ARM Cortex-A510 erratum 1902691.
+
+	  Affected Cortex-A510 core might cause trace data corruption, when being written
+	  into the memory. Effectively TRBE is broken and hence cannot be used to capture
+	  trace data.
+
+	  Work around this problem in the driver by just preventing TRBE initialization on
+	  affected cpus. The firmware must have disabled the access to TRBE for the kernel
+	  on such implementations. This will cover the kernel for any firmware that doesn't
+	  do this already.
+
+	  If unsure, say Y.
+
 config CAVIUM_ERRATUM_22375
 	bool "Cavium erratum 22375, 24313"
 	default y
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index a64bf132c6336..066098198c248 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -617,6 +617,15 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		/* Cortex-A510 r0p0 - r0p2 */
 		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A510, 0, 0, 2)
 	},
+#endif
+#ifdef CONFIG_ARM64_ERRATUM_1902691
+	{
+		.desc = "ARM erratum 1902691",
+		.capability = ARM64_WORKAROUND_1902691,
+
+		/* Cortex-A510 r0p0 - r0p1 */
+		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A510, 0, 0, 1)
+	},
 #endif
 	{
 	}
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 45a06d36d0807..e7719e8f18def 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -57,6 +57,7 @@ WORKAROUND_1508412
 WORKAROUND_1542419
 WORKAROUND_2064142
 WORKAROUND_2038923
+WORKAROUND_1902691
 WORKAROUND_TRBE_OVERWRITE_FILL_MODE
 WORKAROUND_TSB_FLUSH_FAILURE
 WORKAROUND_TRBE_WRITE_OUT_OF_RANGE
-- 
2.34.1

