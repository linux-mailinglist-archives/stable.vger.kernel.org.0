Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61E064B492E
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346890AbiBNK1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:27:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347021AbiBNKZl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:25:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6664F6E558;
        Mon, 14 Feb 2022 01:57:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 005186146F;
        Mon, 14 Feb 2022 09:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91E7C340E9;
        Mon, 14 Feb 2022 09:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832622;
        bh=j1g3Ine8G433kS6IRoLdXKc+ZFe8y8VI1aADr+jnjJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P1AyOqL6gXKwID/xrGmVRaQ1kVOLNgaaeziq9ITI9fKilpmr0ZB6iUS3wtlwcPZJp
         louqKsPq032l/D3TroWmKWI2BIW8S/dvKUmrQ4GgfQ2RdZZ4U0as+GCPPc7AdHIEEk
         YQ3UsSSBjMh+BXDkk31RD4pxz700VhBYtPYK58us=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki Poulose <suzuki.poulose@arm.com>,
        coresight@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 042/203] arm64: errata: Update ARM64_ERRATUM_[2119858|2224489] with Cortex-X2 ranges
Date:   Mon, 14 Feb 2022 10:24:46 +0100
Message-Id: <20220214092511.634829233@linuxfoundation.org>
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

[ Upstream commit eb30d838a44c9e59a2a106884f536119859c7257 ]

Errata ARM64_ERRATUM_[2119858|2224489] also affect some Cortex-X2 ranges as
well. Lets update these errata definition and detection to accommodate all
new Cortex-X2 based cpu MIDR ranges.

Cc: Will Deacon <will@kernel.org>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Suzuki Poulose <suzuki.poulose@arm.com>
Cc: coresight@lists.linaro.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/1642994138-25887-3-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arm64/silicon-errata.rst |  4 ++++
 arch/arm64/Kconfig                     | 12 ++++++------
 arch/arm64/kernel/cpu_errata.c         |  2 ++
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 5342e895fb604..8789c79310bbd 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -98,6 +98,10 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A710     | #2224489        | ARM64_ERRATUM_2224489       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-X2       | #2119858        | ARM64_ERRATUM_2119858       |
++----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-X2       | #2224489        | ARM64_ERRATUM_2224489       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #1188873,1418040| ARM64_ERRATUM_1418040       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #1349291        | N/A                         |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index c4207cf9bb17f..d8046c832225c 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -671,14 +671,14 @@ config ARM64_WORKAROUND_TRBE_OVERWRITE_FILL_MODE
 	bool
 
 config ARM64_ERRATUM_2119858
-	bool "Cortex-A710: 2119858: workaround TRBE overwriting trace data in FILL mode"
+	bool "Cortex-A710/X2: 2119858: workaround TRBE overwriting trace data in FILL mode"
 	default y
 	depends on CORESIGHT_TRBE
 	select ARM64_WORKAROUND_TRBE_OVERWRITE_FILL_MODE
 	help
-	  This option adds the workaround for ARM Cortex-A710 erratum 2119858.
+	  This option adds the workaround for ARM Cortex-A710/X2 erratum 2119858.
 
-	  Affected Cortex-A710 cores could overwrite up to 3 cache lines of trace
+	  Affected Cortex-A710/X2 cores could overwrite up to 3 cache lines of trace
 	  data at the base of the buffer (pointed to by TRBASER_EL1) in FILL mode in
 	  the event of a WRAP event.
 
@@ -761,14 +761,14 @@ config ARM64_ERRATUM_2253138
 	  If unsure, say Y.
 
 config ARM64_ERRATUM_2224489
-	bool "Cortex-A710: 2224489: workaround TRBE writing to address out-of-range"
+	bool "Cortex-A710/X2: 2224489: workaround TRBE writing to address out-of-range"
 	depends on CORESIGHT_TRBE
 	default y
 	select ARM64_WORKAROUND_TRBE_WRITE_OUT_OF_RANGE
 	help
-	  This option adds the workaround for ARM Cortex-A710 erratum 2224489.
+	  This option adds the workaround for ARM Cortex-A710/X2 erratum 2224489.
 
-	  Affected Cortex-A710 cores might write to an out-of-range address, not reserved
+	  Affected Cortex-A710/X2 cores might write to an out-of-range address, not reserved
 	  for TRBE. Under some conditions, the TRBE might generate a write to the next
 	  virtually addressed page following the last page of the TRBE address space
 	  (i.e., the TRBLIMITR_EL1.LIMIT), instead of wrapping around to the base.
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 9e1c1aef9ebd6..29cc062a4153c 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -347,6 +347,7 @@ static const struct midr_range trbe_overwrite_fill_mode_cpus[] = {
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_2119858
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A710),
+	MIDR_RANGE(MIDR_CORTEX_X2, 0, 0, 2, 0),
 #endif
 	{},
 };
@@ -371,6 +372,7 @@ static struct midr_range trbe_write_out_of_range_cpus[] = {
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_2224489
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A710),
+	MIDR_RANGE(MIDR_CORTEX_X2, 0, 0, 2, 0),
 #endif
 	{},
 };
-- 
2.34.1



