Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9263941BFD2
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 09:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244619AbhI2HZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 03:25:55 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13390 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244620AbhI2HZy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Sep 2021 03:25:54 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HK76Y2sKcz8yht;
        Wed, 29 Sep 2021 15:19:33 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 15:24:11 +0800
Received: from huawei.com (10.175.113.32) by kwepemm600003.china.huawei.com
 (7.193.23.202) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Wed, 29 Sep
 2021 15:24:10 +0800
From:   Nanyong Sun <sunnanyong@huawei.com>
To:     <catalin.marinas@arm.com>, <will@kernel.org>
CC:     <suzuki.poulose@arm.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <james.morse@arm.com>, <hayashi.kunihiko@socionext.com>
Subject: [PATCH v4.4 v4.9 v4.14] arm64: Extend workaround for erratum 1024718 to all versions of Cortex-A55
Date:   Wed, 29 Sep 2021 15:52:10 +0800
Message-ID: <20210929075210.819396-1-sunnanyong@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.32]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

commit c0b15c25d25171db4b70cc0b7dbc1130ee94017d upstream.

The erratum 1024718 affects Cortex-A55 r0p0 to r2p0. However
we apply the work around for r0p0 - r1p0. Unfortunately this
won't be fixed for the future revisions for the CPU. Thus
extend the work around for all versions of A55, to cover
for r2p0 and any future revisions.

Cc: stable@vger.kernel.org #v4.4 v4.9 v4.14
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20210203230057.3961239-1-suzuki.poulose@arm.com
[will: Update Kconfig help text]
Signed-off-by: Will Deacon <will@kernel.org>
[Nanyon: adjust for stable version below v4.16, which set TCR_HD earlier
in assembly code]
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
---
 arch/arm64/Kconfig   | 2 +-
 arch/arm64/mm/proc.S | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e296ae3e20f4..e76f74874a42 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -450,7 +450,7 @@ config ARM64_ERRATUM_1024718
 	help
 	  This option adds work around for Arm Cortex-A55 Erratum 1024718.
 
-	  Affected Cortex-A55 cores (r0p0, r0p1, r1p0) could cause incorrect
+	  Affected Cortex-A55 cores (all revisions) could cause incorrect
 	  update of the hardware dirty bit when the DBM/AP bits are updated
 	  without a break-before-make. The work around is to disable the usage
 	  of hardware DBM locally on the affected cores. CPUs not affected by
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index ecbc060807d2..a9ff7fb41832 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -455,8 +455,8 @@ ENTRY(__cpu_setup)
 	cmp	x9, #2
 	b.lt	1f
 #ifdef CONFIG_ARM64_ERRATUM_1024718
-	/* Disable hardware DBM on Cortex-A55 r0p0, r0p1 & r1p0 */
-	cpu_midr_match MIDR_CORTEX_A55, MIDR_CPU_VAR_REV(0, 0), MIDR_CPU_VAR_REV(1, 0), x1, x2, x3, x4
+	/* Disable hardware DBM on Cortex-A55 all versions */
+	cpu_midr_match MIDR_CORTEX_A55, MIDR_CPU_VAR_REV(0, 0), MIDR_CPU_VAR_REV(0xf, 0xf), x1, x2, x3, x4
 	cbnz	x1, 1f
 #endif
 	orr	x10, x10, #TCR_HD		// hardware Dirty flag update
-- 
2.17.1

