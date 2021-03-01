Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02836327E13
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 13:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbhCAMQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 07:16:45 -0500
Received: from foss.arm.com ([217.140.110.172]:56498 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233594AbhCAMQm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 07:16:42 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A146C1FB;
        Mon,  1 Mar 2021 04:15:56 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B87FA3F70D;
        Mon,  1 Mar 2021 04:15:55 -0800 (PST)
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
To:     stable@vger.kernel.org
Cc:     suzuki.poulose@arm.com, gregkh@linuxfoundation.org,
        mathieu.poirier@linaro.org, mike.leach@linaro.org,
        leo.yan@linaro.org
Subject: [PATCH] coresight: etm4x: Handle accesses to TRCSTALLCTLR
Date:   Mon,  1 Mar 2021 12:15:49 +0000
Message-Id: <20210301121549.2994673-1-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <161452028074223@kroah.com>
References: <161452028074223@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit f72896063396b0cb205cbf0fd76ec6ab3ca11c8a upstream

TRCSTALLCTLR register is only implemented if

   TRCIDR3.STALLCTL == 0b1

Make sure the driver touches the register only it is implemented.

Link: https://lore.kernel.org/r/20210127184617.3684379-1-suzuki.poulose@arm.com
Cc: stable@vger.kernel.org # v5.11-
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Leo Yan <leo.yan@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c  | 9 ++++++---
 drivers/hwtracing/coresight/coresight-etm4x-sysfs.c | 2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index b20b6ff17cf6..8ff35b9397da 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -226,7 +226,8 @@ static int etm4_enable_hw(struct etmv4_drvdata *drvdata)
 	writel_relaxed(0x0, drvdata->base + TRCAUXCTLR);
 	writel_relaxed(config->eventctrl0, drvdata->base + TRCEVENTCTL0R);
 	writel_relaxed(config->eventctrl1, drvdata->base + TRCEVENTCTL1R);
-	writel_relaxed(config->stall_ctrl, drvdata->base + TRCSTALLCTLR);
+	if (drvdata->stallctl)
+		writel_relaxed(config->stall_ctrl, drvdata->base + TRCSTALLCTLR);
 	writel_relaxed(config->ts_ctrl, drvdata->base + TRCTSCTLR);
 	writel_relaxed(config->syncfreq, drvdata->base + TRCSYNCPR);
 	writel_relaxed(config->ccctlr, drvdata->base + TRCCCCTLR);
@@ -1288,7 +1289,8 @@ static int etm4_cpu_save(struct etmv4_drvdata *drvdata)
 	state->trcauxctlr = readl(drvdata->base + TRCAUXCTLR);
 	state->trceventctl0r = readl(drvdata->base + TRCEVENTCTL0R);
 	state->trceventctl1r = readl(drvdata->base + TRCEVENTCTL1R);
-	state->trcstallctlr = readl(drvdata->base + TRCSTALLCTLR);
+	if (drvdata->stallctl)
+		state->trcstallctlr = readl(drvdata->base + TRCSTALLCTLR);
 	state->trctsctlr = readl(drvdata->base + TRCTSCTLR);
 	state->trcsyncpr = readl(drvdata->base + TRCSYNCPR);
 	state->trcccctlr = readl(drvdata->base + TRCCCCTLR);
@@ -1397,7 +1399,8 @@ static void etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 	writel_relaxed(state->trcauxctlr, drvdata->base + TRCAUXCTLR);
 	writel_relaxed(state->trceventctl0r, drvdata->base + TRCEVENTCTL0R);
 	writel_relaxed(state->trceventctl1r, drvdata->base + TRCEVENTCTL1R);
-	writel_relaxed(state->trcstallctlr, drvdata->base + TRCSTALLCTLR);
+	if (drvdata->stallctl)
+		writel_relaxed(state->trcstallctlr, drvdata->base + TRCSTALLCTLR);
 	writel_relaxed(state->trctsctlr, drvdata->base + TRCTSCTLR);
 	writel_relaxed(state->trcsyncpr, drvdata->base + TRCSYNCPR);
 	writel_relaxed(state->trcccctlr, drvdata->base + TRCCCCTLR);
diff --git a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
index 989ce7b8ade7..4682f2613996 100644
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

