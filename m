Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A6830E6A4
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 00:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbhBCXEa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 18:04:30 -0500
Received: from foss.arm.com ([217.140.110.172]:48370 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233450AbhBCXE3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Feb 2021 18:04:29 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 181B0D6E;
        Wed,  3 Feb 2021 15:03:43 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0CD643F694;
        Wed,  3 Feb 2021 15:03:41 -0800 (PST)
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     will@kernel.org, catalin.marinas@arm.com,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Subject: [PATCH] arm64: Extend workaround for erratum 1024718 to all versions of Cortex-A55
Date:   Wed,  3 Feb 2021 23:00:57 +0000
Message-Id: <20210203230057.3961239-1-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The erratum 1024718 affects Cortex-A55 r0p0 to r2p0. However
we apply the work around for r0p0 - r1p0. Unfortunately this
won't be fixed for the future revisions for the CPU. Thus
extend the work around for all versions of A55, to cover
for r2p0 and any future revisions.

Cc: stable@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/kernel/cpufeature.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index e99eddec0a46..db400ca77427 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1455,7 +1455,7 @@ static bool cpu_has_broken_dbm(void)
 	/* List of CPUs which have broken DBM support. */
 	static const struct midr_range cpus[] = {
 #ifdef CONFIG_ARM64_ERRATUM_1024718
-		MIDR_RANGE(MIDR_CORTEX_A55, 0, 0, 1, 0),  // A55 r0p0 -r1p0
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A55),
 		/* Kryo4xx Silver (rdpe => r1p0) */
 		MIDR_REV(MIDR_QCOM_KRYO_4XX_SILVER, 0xd, 0xe),
 #endif
-- 
2.24.1

