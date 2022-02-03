Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA004A8DD5
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354624AbiBCUdh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:33:37 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38434 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354646AbiBCUca (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:32:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFCA461A60;
        Thu,  3 Feb 2022 20:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92C0C340EB;
        Thu,  3 Feb 2022 20:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920349;
        bh=zV5mVSHrLBiLshJorIhm2PR948GoEoOLENCUyAPJ+Ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bketYHsjzBFID8h3KiQHNHtLPBQJ45Ib2egyyqwIhao003sI35tM9m5FDDSHrW1Fn
         1LlWLT4xFnsmJ2dxgYc6MkSBcGSynQ/JcrFbOyhFATB7eSDTBT5vAdYPttXuaLPM3S
         y2RAIl+KgDKOKFes7Mw6H4UPlqRtYwrHoYEiE3NRfKx0qpaXS7NfZgiEQX3W4WkMGw
         Qmu7f1Ly2nN7148y5ah9/0SWQHkK+W2lCVrSnYXqg+e2oxDSM0VG09FcjFEXh+zNd2
         iMJxcAHspDYo2hhKQuoqG5kte6ssaCTQj9teq25ILaYXFj70+sC0Ti5nDOvy6ypmvi
         ARC6GARftaq5Q==
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
        mark.rutland@arm.com, rwiley@nvidia.com, broonie@kernel.org,
        vincenzo.frascino@arm.com
Subject: [PATCH AUTOSEL 5.16 48/52] arm64: errata: Add detection for TRBE invalid prohibited states
Date:   Thu,  3 Feb 2022 15:29:42 -0500
Message-Id: <20220203202947.2304-48-sashal@kernel.org>
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

[ Upstream commit 3bd94a8759de9b724b83a80942b0354acd7701eb ]

TRBE implementations affected by Arm erratum #2038923 might get TRBE into
an inconsistent view on whether trace is prohibited within the CPU. As a
result, the trace buffer or trace buffer state might be corrupted. This
happens after TRBE buffer has been enabled by setting TRBLIMITR_EL1.E,
followed by just a single context synchronization event before execution
changes from a context, in which trace is prohibited to one where it isn't,
or vice versa. In these mentioned conditions, the view of whether trace is
prohibited is inconsistent between parts of the CPU, and the trace buffer
or the trace buffer state might be corrupted. This adds a new errata
ARM64_ERRATUM_2038923 in arm64 errata framework.

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
Link: https://lore.kernel.org/r/1643120437-14352-4-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arm64/silicon-errata.rst |  2 ++
 arch/arm64/Kconfig                     | 23 +++++++++++++++++++++++
 arch/arm64/kernel/cpu_errata.c         |  9 +++++++++
 arch/arm64/tools/cpucaps               |  1 +
 4 files changed, 35 insertions(+)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 401a6e86c5084..d5c6befc44eb8 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -54,6 +54,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A510     | #2064142        | ARM64_ERRATUM_2064142       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A510     | #2038923        | ARM64_ERRATUM_2038923       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A53      | #826319         | ARM64_ERRATUM_826319        |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A53      | #827319         | ARM64_ERRATUM_827319        |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 30c07b0d6b5c9..2b75e8a9bf88c 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -796,6 +796,29 @@ config ARM64_ERRATUM_2064142
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_2038923
+	bool "Cortex-A510: 2038923: workaround TRBE corruption with enable"
+	depends on COMPILE_TEST # Until the CoreSight TRBE driver changes are in
+	default y
+	help
+	  This option adds the workaround for ARM Cortex-A510 erratum 2038923.
+
+	  Affected Cortex-A510 core might cause an inconsistent view on whether trace is
+	  prohibited within the CPU. As a result, the trace buffer or trace buffer state
+	  might be corrupted. This happens after TRBE buffer has been enabled by setting
+	  TRBLIMITR_EL1.E, followed by just a single context synchronization event before
+	  execution changes from a context, in which trace is prohibited to one where it
+	  isn't, or vice versa. In these mentioned conditions, the view of whether trace
+	  is prohibited is inconsistent between parts of the CPU, and the trace buffer or
+	  the trace buffer state might be corrupted.
+
+	  Work around this in the driver by preventing an inconsistent view of whether the
+	  trace is prohibited or not based on TRBLIMITR_EL1.E by immediately following a
+	  change to TRBLIMITR_EL1.E with at least one ISB instruction before an ERET, or
+	  two ISB instructions if no ERET is to take place.
+
+	  If unsure, say Y.
+
 config CAVIUM_ERRATUM_22375
 	bool "Cavium erratum 22375, 24313"
 	default y
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index a5456dd9a33f5..a64bf132c6336 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -609,6 +609,15 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A510, 0, 0, 2)
 	},
 #endif
+#ifdef CONFIG_ARM64_ERRATUM_2038923
+	{
+		.desc = "ARM erratum 2038923",
+		.capability = ARM64_WORKAROUND_2038923,
+
+		/* Cortex-A510 r0p0 - r0p2 */
+		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A510, 0, 0, 2)
+	},
+#endif
 	{
 	}
 };
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index fca3cb329e1db..45a06d36d0807 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -56,6 +56,7 @@ WORKAROUND_1463225
 WORKAROUND_1508412
 WORKAROUND_1542419
 WORKAROUND_2064142
+WORKAROUND_2038923
 WORKAROUND_TRBE_OVERWRITE_FILL_MODE
 WORKAROUND_TSB_FLUSH_FAILURE
 WORKAROUND_TRBE_WRITE_OUT_OF_RANGE
-- 
2.34.1

