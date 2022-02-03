Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112584A8DE7
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354899AbiBCUdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:33:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38566 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354190AbiBCUck (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:32:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D677E61A73;
        Thu,  3 Feb 2022 20:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC8CC340E8;
        Thu,  3 Feb 2022 20:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920359;
        bh=St+wTmNgQ1QtlSDwVf5nx7/fOXNFZrqz9ag6wMv9RjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cc4jMFGLNnI3kpqS9igBiIAGm6vlYJG09Xo7MkyDUy8Qut3XhfvJmDiB/XViel0tx
         RCbcztsl/l4VEPbtRT69r1t/I6NFIiimsYCETmv8fGIC8Ttr334dGnzjaT8NWWGWFP
         S6GdQwIZtEzU+nXflW8rd1zCrMgXxdlxlXsfK2VL/ALY7ncbqMc87ks3WTGWPOybEF
         t289JD7ls+8oszz6eEZkhjMvVYnF3R2QiY2PHvCMfmDnYkSUSnwgeqSocNoPIuCWbR
         Lm9jx8wAydBgG7aKWqO1jX1/kTfYHHphrZ83bI+1QIMPvv29OBw2Vgx96LxQk/i3tv
         a6IIWbJOXcNrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>, will@kernel.org,
        corbet@lwn.net, maz@kernel.org, suzuki.poulose@arm.com,
        mark.rutland@arm.com, joey.gouly@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 50/52] arm64: cpufeature: List early Cortex-A510 parts as having broken dbm
Date:   Thu,  3 Feb 2022 15:29:44 -0500
Message-Id: <20220203202947.2304-50-sashal@kernel.org>
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

From: James Morse <james.morse@arm.com>

[ Upstream commit 297ae1eb23b04c5a46111ab53c8d0f69af43f402 ]

Versions of Cortex-A510 before r0p3 are affected by a hardware erratum
where the hardware update of the dirty bit is not correctly ordered.

Add these cpus to the cpu_has_broken_dbm list.

Signed-off-by: James Morse <james.morse@arm.com>
Link: https://lore.kernel.org/r/20220125154040.549272-3-james.morse@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arm64/silicon-errata.rst |  2 ++
 arch/arm64/Kconfig                     | 10 ++++++++++
 arch/arm64/kernel/cpufeature.c         |  3 +++
 3 files changed, 15 insertions(+)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 1b0e53ececda9..0ec7b7f1524b1 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -98,6 +98,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A77      | #1508412        | ARM64_ERRATUM_1508412       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A510     | #2051678        | ARM64_ERRATUM_2051678       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A710     | #2119858        | ARM64_ERRATUM_2119858       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A710     | #2054223        | ARM64_ERRATUM_2054223       |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 7d710589e1818..38e7f19df14d4 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -670,6 +670,16 @@ config ARM64_ERRATUM_1508412
 config ARM64_WORKAROUND_TRBE_OVERWRITE_FILL_MODE
 	bool
 
+config ARM64_ERRATUM_2051678
+	bool "Cortex-A510: 2051678: disable Hardware Update of the page table dirty bit"
+	help
+	  This options adds the workaround for ARM Cortex-A510 erratum ARM64_ERRATUM_2051678.
+	  Affected Coretex-A510 might not respect the ordering rules for
+	  hardware update of the page table's dirty bit. The workaround
+	  is to not enable the feature on affected CPUs.
+
+	  If unsure, say Y.
+
 config ARM64_ERRATUM_2119858
 	bool "Cortex-A710/X2: 2119858: workaround TRBE overwriting trace data in FILL mode"
 	default y
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6f3e677d88f15..d18b953c078db 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1634,6 +1634,9 @@ static bool cpu_has_broken_dbm(void)
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A55),
 		/* Kryo4xx Silver (rdpe => r1p0) */
 		MIDR_REV(MIDR_QCOM_KRYO_4XX_SILVER, 0xd, 0xe),
+#endif
+#ifdef CONFIG_ARM64_ERRATUM_2051678
+		MIDR_REV_RANGE(MIDR_CORTEX_A510, 0, 0, 2),
 #endif
 		{},
 	};
-- 
2.34.1

