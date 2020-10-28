Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7EE929DFB0
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 02:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731406AbgJ2BDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 21:03:55 -0400
Received: from foss.arm.com ([217.140.110.172]:39014 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730416AbgJ1WKD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Oct 2020 18:10:03 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3706E1762;
        Wed, 28 Oct 2020 15:10:02 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2E1543F73C;
        Wed, 28 Oct 2020 15:10:01 -0700 (PDT)
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     mathieu.poirier@linaro.org, mike.leach@linaro.org,
        coresight@lists.linaro.org, linux-kernel@vger.kernel.org,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        stable@vger.kernel.org
Subject: [PATCH v3 01/26] coresight: etm4x: Fix accesses to TRCVMIDCTLR1
Date:   Wed, 28 Oct 2020 22:09:20 +0000
Message-Id: <20201028220945.3826358-3-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201028220945.3826358-1-suzuki.poulose@arm.com>
References: <20201028220945.3826358-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

TRCVMIDCTRL1 is only implemented only if the TRCIDR4.NUMVMIDC > 4.
We must not touch the register otherwise.

Cc: stable@vger.kernel.org
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Mike Leach <mike.leach@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 6096d7abf80d..e67365d1ce28 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -193,7 +193,8 @@ static int etm4_enable_hw(struct etmv4_drvdata *drvdata)
 		writeq_relaxed(config->vmid_val[i],
 			       drvdata->base + TRCVMIDCVRn(i));
 	writel_relaxed(config->vmid_mask0, drvdata->base + TRCVMIDCCTLR0);
-	writel_relaxed(config->vmid_mask1, drvdata->base + TRCVMIDCCTLR1);
+	if (drvdata->numvmidc > 4)
+		writel_relaxed(config->vmid_mask1, drvdata->base + TRCVMIDCCTLR1);
 
 	if (!drvdata->skip_power_up) {
 		/*
@@ -1243,7 +1244,8 @@ static int etm4_cpu_save(struct etmv4_drvdata *drvdata)
 	state->trccidcctlr1 = readl(drvdata->base + TRCCIDCCTLR1);
 
 	state->trcvmidcctlr0 = readl(drvdata->base + TRCVMIDCCTLR0);
-	state->trcvmidcctlr1 = readl(drvdata->base + TRCVMIDCCTLR1);
+	if (drvdata->numvmidc > 4)
+		state->trcvmidcctlr1 = readl(drvdata->base + TRCVMIDCCTLR1);
 
 	state->trcclaimset = readl(drvdata->base + TRCCLAIMCLR);
 
@@ -1353,7 +1355,8 @@ static void etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 	writel_relaxed(state->trccidcctlr1, drvdata->base + TRCCIDCCTLR1);
 
 	writel_relaxed(state->trcvmidcctlr0, drvdata->base + TRCVMIDCCTLR0);
-	writel_relaxed(state->trcvmidcctlr1, drvdata->base + TRCVMIDCCTLR1);
+	if (drvdata->numvmidc > 4)
+		writel_relaxed(state->trcvmidcctlr1, drvdata->base + TRCVMIDCCTLR1);
 
 	writel_relaxed(state->trcclaimset, drvdata->base + TRCCLAIMSET);
 
-- 
2.24.1

