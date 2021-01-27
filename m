Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437B230638B
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 19:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234876AbhA0Sr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 13:47:29 -0500
Received: from foss.arm.com ([217.140.110.172]:60380 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233791AbhA0SrO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 13:47:14 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 56C021042;
        Wed, 27 Jan 2021 10:46:28 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1E45B3F68F;
        Wed, 27 Jan 2021 10:46:27 -0800 (PST)
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org, coresight@lists.linaro.org,
        anshuman.khandual@arm.com,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Leo Yan <leo.yan@linaro.org>
Subject: [PATCH v3] coresight: etm4x: Handle accesses to TRCSTALLCTLR
Date:   Wed, 27 Jan 2021 18:46:17 +0000
Message-Id: <20210127184617.3684379-1-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

TRCSTALLCTLR register is only implemented if

   TRCIDR3.STALLCTL == 0b1

Make sure the driver touches the register only it is implemented.

Cc: stable@vger.kernel.org
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Leo Yan <leo.yan@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v2:
 - Ignore STALLCTL for sysfs mode
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c  | 9 ++++++---
 drivers/hwtracing/coresight/coresight-etm4x-sysfs.c | 2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 473ab7480a36..5017d33ba4f5 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -306,7 +306,8 @@ static int etm4_enable_hw(struct etmv4_drvdata *drvdata)
 	etm4x_relaxed_write32(csa, 0x0, TRCAUXCTLR);
 	etm4x_relaxed_write32(csa, config->eventctrl0, TRCEVENTCTL0R);
 	etm4x_relaxed_write32(csa, config->eventctrl1, TRCEVENTCTL1R);
-	etm4x_relaxed_write32(csa, config->stall_ctrl, TRCSTALLCTLR);
+	if (drvdata->stallctl)
+		etm4x_relaxed_write32(csa, config->stall_ctrl, TRCSTALLCTLR);
 	etm4x_relaxed_write32(csa, config->ts_ctrl, TRCTSCTLR);
 	etm4x_relaxed_write32(csa, config->syncfreq, TRCSYNCPR);
 	etm4x_relaxed_write32(csa, config->ccctlr, TRCCCCTLR);
@@ -1463,7 +1464,8 @@ static int etm4_cpu_save(struct etmv4_drvdata *drvdata)
 	state->trcauxctlr = etm4x_read32(csa, TRCAUXCTLR);
 	state->trceventctl0r = etm4x_read32(csa, TRCEVENTCTL0R);
 	state->trceventctl1r = etm4x_read32(csa, TRCEVENTCTL1R);
-	state->trcstallctlr = etm4x_read32(csa, TRCSTALLCTLR);
+	if (drvdata->stallctl)
+		state->trcstallctlr = etm4x_read32(csa, TRCSTALLCTLR);
 	state->trctsctlr = etm4x_read32(csa, TRCTSCTLR);
 	state->trcsyncpr = etm4x_read32(csa, TRCSYNCPR);
 	state->trcccctlr = etm4x_read32(csa, TRCCCCTLR);
@@ -1575,7 +1577,8 @@ static void etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 	etm4x_relaxed_write32(csa, state->trcauxctlr, TRCAUXCTLR);
 	etm4x_relaxed_write32(csa, state->trceventctl0r, TRCEVENTCTL0R);
 	etm4x_relaxed_write32(csa, state->trceventctl1r, TRCEVENTCTL1R);
-	etm4x_relaxed_write32(csa, state->trcstallctlr, TRCSTALLCTLR);
+	if (drvdata->stallctl)
+		etm4x_relaxed_write32(csa, state->trcstallctlr, TRCSTALLCTLR);
 	etm4x_relaxed_write32(csa, state->trctsctlr, TRCTSCTLR);
 	etm4x_relaxed_write32(csa, state->trcsyncpr, TRCSYNCPR);
 	etm4x_relaxed_write32(csa, state->trcccctlr, TRCCCCTLR);
diff --git a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
index b646d53a3133..0995a10790f4 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
@@ -389,7 +389,7 @@ static ssize_t mode_store(struct device *dev,
 		config->eventctrl1 &= ~BIT(12);
 
 	/* bit[8], Instruction stall bit */
-	if (config->mode & ETM_MODE_ISTALL_EN)
+	if ((config->mode & ETM_MODE_ISTALL_EN) && (drvdata->stallctl == true))
 		config->stall_ctrl |= BIT(8);
 	else
 		config->stall_ctrl &= ~BIT(8);
-- 
2.24.1

