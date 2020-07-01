Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 365F7211684
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 01:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgGAXRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 19:17:17 -0400
Received: from foss.arm.com ([217.140.110.172]:59200 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbgGAXRR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 19:17:17 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4FB8631B;
        Wed,  1 Jul 2020 16:17:16 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 661783F73C;
        Wed,  1 Jul 2020 16:17:15 -0700 (PDT)
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     stable@vger.kernel.org, mathieu.poirier@linaro.org,
        coresight@lists.linaro.org,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>
Subject: [PATCH] coresight: etm4x: Fix save/restore during cpu idle
Date:   Thu,  2 Jul 2020 00:17:01 +0100
Message-Id: <20200701231701.91029-1-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The ETM state save/restore incorrectly reads/writes some of the 64bit
registers (e.g, address comparators, vmid/cid comparators etc.) using
32bit accesses. Ensure we use the appropriate width accessors for
the registers.

Fixes: f188b5e76aae ("coresight: etm4x: Save/restore state across CPU low power states")
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Mike Leach <mike.leach@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 drivers/hwtracing/coresight/coresight-etm4x.c | 16 ++++++++--------
 drivers/hwtracing/coresight/coresight-etm4x.h |  2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x.c b/drivers/hwtracing/coresight/coresight-etm4x.c
index 82fc2fab072a..be990457a8ea 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x.c
@@ -1206,8 +1206,8 @@ static int etm4_cpu_save(struct etmv4_drvdata *drvdata)
 	}
 
 	for (i = 0; i < drvdata->nr_addr_cmp * 2; i++) {
-		state->trcacvr[i] = readl(drvdata->base + TRCACVRn(i));
-		state->trcacatr[i] = readl(drvdata->base + TRCACATRn(i));
+		state->trcacvr[i] = readq(drvdata->base + TRCACVRn(i));
+		state->trcacatr[i] = readq(drvdata->base + TRCACATRn(i));
 	}
 
 	/*
@@ -1218,10 +1218,10 @@ static int etm4_cpu_save(struct etmv4_drvdata *drvdata)
 	 */
 
 	for (i = 0; i < drvdata->numcidc; i++)
-		state->trccidcvr[i] = readl(drvdata->base + TRCCIDCVRn(i));
+		state->trccidcvr[i] = readq(drvdata->base + TRCCIDCVRn(i));
 
 	for (i = 0; i < drvdata->numvmidc; i++)
-		state->trcvmidcvr[i] = readl(drvdata->base + TRCVMIDCVRn(i));
+		state->trcvmidcvr[i] = readq(drvdata->base + TRCVMIDCVRn(i));
 
 	state->trccidcctlr0 = readl(drvdata->base + TRCCIDCCTLR0);
 	state->trccidcctlr1 = readl(drvdata->base + TRCCIDCCTLR1);
@@ -1319,18 +1319,18 @@ static void etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 	}
 
 	for (i = 0; i < drvdata->nr_addr_cmp * 2; i++) {
-		writel_relaxed(state->trcacvr[i],
+		writeq_relaxed(state->trcacvr[i],
 			       drvdata->base + TRCACVRn(i));
-		writel_relaxed(state->trcacatr[i],
+		writeq_relaxed(state->trcacatr[i],
 			       drvdata->base + TRCACATRn(i));
 	}
 
 	for (i = 0; i < drvdata->numcidc; i++)
-		writel_relaxed(state->trccidcvr[i],
+		writeq_relaxed(state->trccidcvr[i],
 			       drvdata->base + TRCCIDCVRn(i));
 
 	for (i = 0; i < drvdata->numvmidc; i++)
-		writel_relaxed(state->trcvmidcvr[i],
+		writeq_relaxed(state->trcvmidcvr[i],
 			       drvdata->base + TRCVMIDCVRn(i));
 
 	writel_relaxed(state->trccidcctlr0, drvdata->base + TRCCIDCCTLR0);
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.h b/drivers/hwtracing/coresight/coresight-etm4x.h
index 7da022e87218..b8283e1d6d88 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.h
+++ b/drivers/hwtracing/coresight/coresight-etm4x.h
@@ -334,7 +334,7 @@ struct etmv4_save_state {
 	u64	trcacvr[ETM_MAX_SINGLE_ADDR_CMP];
 	u64	trcacatr[ETM_MAX_SINGLE_ADDR_CMP];
 	u64	trccidcvr[ETMv4_MAX_CTXID_CMP];
-	u32	trcvmidcvr[ETM_MAX_VMID_CMP];
+	u64	trcvmidcvr[ETM_MAX_VMID_CMP];
 	u32	trccidcctlr0;
 	u32	trccidcctlr1;
 	u32	trcvmidcctlr0;
-- 
2.24.1

