Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1374F305ABB
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 13:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235101AbhA0MEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 07:04:00 -0500
Received: from foss.arm.com ([217.140.110.172]:42336 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237445AbhA0MBi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 07:01:38 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2891B1042;
        Wed, 27 Jan 2021 04:00:51 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0B5B43F68F;
        Wed, 27 Jan 2021 04:00:49 -0800 (PST)
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     coresight@lists.linaro.org, linux-kernel@vger.kernel.org,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Leo Yan <leo.yan@linaro.org>,
        Mike Leach <mike.leach@linaro.org>
Subject: [PATCH v2] coresight: etm4x: Handle accesses to TRCSTALLCTLR
Date:   Wed, 27 Jan 2021 12:00:32 +0000
Message-Id: <20210127120032.3611851-1-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210126145614.3607093-1-suzuki.poulose@arm.com>
References: <20210126145614.3607093-1-suzuki.poulose@arm.com>
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
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mike Leach <mike.leach@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v1:
  - No change to the patch, fixed the stable email address and
    added usual reviewers.
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c  | 9 ++++++---
 drivers/hwtracing/coresight/coresight-etm4x-sysfs.c | 3 +++
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index b40e3c2bf818..814b49dae0c7 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -367,7 +367,8 @@ static int etm4_enable_hw(struct etmv4_drvdata *drvdata)
 	etm4x_relaxed_write32(csa, 0x0, TRCAUXCTLR);
 	etm4x_relaxed_write32(csa, config->eventctrl0, TRCEVENTCTL0R);
 	etm4x_relaxed_write32(csa, config->eventctrl1, TRCEVENTCTL1R);
-	etm4x_relaxed_write32(csa, config->stall_ctrl, TRCSTALLCTLR);
+	if (drvdata->stallctl)
+		etm4x_relaxed_write32(csa, config->stall_ctrl, TRCSTALLCTLR);
 	etm4x_relaxed_write32(csa, config->ts_ctrl, TRCTSCTLR);
 	etm4x_relaxed_write32(csa, config->syncfreq, TRCSYNCPR);
 	etm4x_relaxed_write32(csa, config->ccctlr, TRCCCCTLR);
@@ -1545,7 +1546,8 @@ static int etm4_cpu_save(struct etmv4_drvdata *drvdata)
 	state->trcauxctlr = etm4x_read32(csa, TRCAUXCTLR);
 	state->trceventctl0r = etm4x_read32(csa, TRCEVENTCTL0R);
 	state->trceventctl1r = etm4x_read32(csa, TRCEVENTCTL1R);
-	state->trcstallctlr = etm4x_read32(csa, TRCSTALLCTLR);
+	if (drvdata->stallctl)
+		state->trcstallctlr = etm4x_read32(csa, TRCSTALLCTLR);
 	state->trctsctlr = etm4x_read32(csa, TRCTSCTLR);
 	state->trcsyncpr = etm4x_read32(csa, TRCSYNCPR);
 	state->trcccctlr = etm4x_read32(csa, TRCCCCTLR);
@@ -1657,7 +1659,8 @@ static void etm4_cpu_restore(struct etmv4_drvdata *drvdata)
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
index 1c490bcef3ad..cd9249fbf913 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
@@ -296,6 +296,9 @@ static ssize_t mode_store(struct device *dev,
 	if (kstrtoul(buf, 16, &val))
 		return -EINVAL;
 
+	if ((val & ETM_MODE_ISTALL_EN) && !drvdata->stallctl)
+		return -EINVAL;
+
 	spin_lock(&drvdata->spinlock);
 	config->mode = val & ETMv4_MODE_ALL;
 
-- 
2.24.1

