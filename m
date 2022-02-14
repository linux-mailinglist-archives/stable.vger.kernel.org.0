Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6131D4B4B91
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346755AbiBNKZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:25:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346914AbiBNKYT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:24:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA0D6D191;
        Mon, 14 Feb 2022 01:56:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EFC460F25;
        Mon, 14 Feb 2022 09:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BBDC340E9;
        Mon, 14 Feb 2022 09:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832592;
        bh=zV5mVSHrLBiLshJorIhm2PR948GoEoOLENCUyAPJ+Ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jfI2pTkBdzHEta66o+nkK9rJDEznhWDV1hHqqUBoEDFyfXi3zkFMjXA2QJMACOy4J
         T3d+G1jYf4OwTsILR6HljiBS84mOZY332o3k/C0Ldr2bGBxBAf4L2xwdKm24AGXPfe
         B39ZYuO6L/j0yq5yx6lBO4R1ANMnbKtSmUdWLUPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki Poulose <suzuki.poulose@arm.com>,
        coresight@lists.linaro.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 063/203] arm64: errata: Add detection for TRBE invalid prohibited states
Date:   Mon, 14 Feb 2022 10:25:07 +0100
Message-Id: <20220214092512.395465562@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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



