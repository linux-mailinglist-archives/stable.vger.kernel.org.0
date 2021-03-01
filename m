Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DABF327EBC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 13:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235230AbhCAM7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 07:59:11 -0500
Received: from foss.arm.com ([217.140.110.172]:57486 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235117AbhCAM7G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 07:59:06 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7911B1FB;
        Mon,  1 Mar 2021 04:58:20 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A847C3F70D;
        Mon,  1 Mar 2021 04:58:19 -0800 (PST)
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
To:     stable@vger.kernel.org
Cc:     suzuki.poulose@arm.com, gregkh@linuxfoundation.org,
        will@kernel.org, catalin.marinas@arm.com
Subject: [PATCH v2] arm64: Extend workaround for erratum 1024718 to all versions of Cortex-A55
Date:   Mon,  1 Mar 2021 12:58:15 +0000
Message-Id: <20210301125815.3047065-1-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210301125459.3046861-1-suzuki.poulose@arm.com>
References: <20210301125459.3046861-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit c0b15c25d25171db4b70cc0b7dbc1130ee94017d upstream

The erratum 1024718 affects Cortex-A55 r0p0 to r2p0. However
we apply the work around for r0p0 - r1p0. Unfortunately this
won't be fixed for the future revisions for the CPU. Thus
extend the work around for all versions of A55, to cover
for r2p0 and any future revisions.

Cc: stable@vger.kernel.org # v5.4-
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20210203230057.3961239-1-suzuki.poulose@arm.com
[will: Update Kconfig help text]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes in v2:
 - Match the Kconfig text to the original commit
   "versions" => "revisions"

 arch/arm64/Kconfig             | 2 +-
 arch/arm64/kernel/cpufeature.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a0bc9bbb92f3..9c8ea5939865 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -489,7 +489,7 @@ config ARM64_ERRATUM_1024718
 	help
 	  This option adds a workaround for ARM Cortex-A55 Erratum 1024718.
 
-	  Affected Cortex-A55 cores (r0p0, r0p1, r1p0) could cause incorrect
+	  Affected Cortex-A55 cores (all revisions) could cause incorrect
 	  update of the hardware dirty bit when the DBM/AP bits are updated
 	  without a break-before-make. The workaround is to disable the usage
 	  of hardware DBM locally on the affected cores. CPUs not affected by
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index f2ec84540414..79caab15ccbf 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1092,7 +1092,7 @@ static bool cpu_has_broken_dbm(void)
 	/* List of CPUs which have broken DBM support. */
 	static const struct midr_range cpus[] = {
 #ifdef CONFIG_ARM64_ERRATUM_1024718
-		MIDR_RANGE(MIDR_CORTEX_A55, 0, 0, 1, 0),  // A55 r0p0 -r1p0
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A55),
 #endif
 		{},
 	};
-- 
2.24.1

