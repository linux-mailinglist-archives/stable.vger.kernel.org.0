Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9597B4B4BB7
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347144AbiBNKZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:25:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346765AbiBNKYb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:24:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A08986A047;
        Mon, 14 Feb 2022 01:56:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FF47B80D6D;
        Mon, 14 Feb 2022 09:56:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A26C340E9;
        Mon, 14 Feb 2022 09:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832598;
        bh=St+wTmNgQ1QtlSDwVf5nx7/fOXNFZrqz9ag6wMv9RjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qJzCT2kmuXiETf8BBd6u53BU2H3ZFzFiN74Bckjfxi833AkyDMNE5NEghPLwEQ49q
         xG+ulW3vCO8gx+vk+XOpsrXGhQAKtEDE8HS+441ytDpu9+PwVBbMdXv7Cst7katIUj
         PU/y3xx20n5l5T/wv7MCapqkjs7BReBRNvlqHdnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 065/203] arm64: cpufeature: List early Cortex-A510 parts as having broken dbm
Date:   Mon, 14 Feb 2022 10:25:09 +0100
Message-Id: <20220214092512.465638916@linuxfoundation.org>
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



