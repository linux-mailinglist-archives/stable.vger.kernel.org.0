Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66E58594766
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241419AbiHOXH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353145AbiHOXHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:07:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401761423EE;
        Mon, 15 Aug 2022 12:59:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A7294CE12C1;
        Mon, 15 Aug 2022 19:59:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EBBBC433C1;
        Mon, 15 Aug 2022 19:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593559;
        bh=LVHA3YzYWEMPoW5ZgxNE0Ccb4/VJ6WQwYu7SWqFJdg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kN3kpXkiNwb6SjPq6wtXPCoU1dDf2GkoBOsggcc4f4qOY06hVlv06IMck93YBObnm
         cxcF3ejTvkS3J8jN9qYWyHyi1ialOBNs5ktM4FrFrS8MBfeT8usCrapsTyPRpgMwyI
         yqBaGaY3W58VfgQk2C1oO83EZ6wSTrsLWozhFkxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org,
        German Gomez <german.gomez@arm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0288/1157] drivers/perf: arm_spe: Fix consistency of SYS_PMSCR_EL1.CX
Date:   Mon, 15 Aug 2022 19:54:04 +0200
Message-Id: <20220815180451.138467006@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>

[ Upstream commit 92f2b8bafa3d6e89c750e9d301a8b7ab76aaa8b6 ]

The arm_spe_pmu driver will enable SYS_PMSCR_EL1.CX in order to add CONTEXT
packets into the traces, if the owner of the perf event runs with required
capabilities i.e CAP_PERFMON or CAP_SYS_ADMIN via perfmon_capable() helper.

The value of this bit is computed in the arm_spe_event_to_pmscr() function
but the check for capabilities happens in the pmu event init callback i.e
arm_spe_pmu_event_init(). This suggests that the value of the CX bit should
remain consistent for the duration of the perf session.

However, the function arm_spe_event_to_pmscr() may be called later during
the event start callback i.e arm_spe_pmu_start() when the "current" process
is not the owner of the perf session, hence the CX bit setting is currently
not consistent.

One way to fix this, is by caching the required value of the CX bit during
the initialization of the PMU event, so that it remains consistent for the
duration of the session. It uses currently unused 'event->hw.flags' element
to cache perfmon_capable() value, which can be referred during event start
callback to compute SYS_PMSCR_EL1.CX. This ensures consistent availability
of context packets in the trace as per event owner capabilities.

Drop BIT(SYS_PMSCR_EL1_CX_SHIFT) check in arm_spe_pmu_event_init(), because
now CX bit cannot be set in arm_spe_event_to_pmscr() with perfmon_capable()
disabled.

Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexey Budankov <alexey.budankov@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Fixes: d5d9696b0380 ("drivers/perf: Add support for ARMv8.2 Statistical Profiling Extension")
Reported-by: German Gomez <german.gomez@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20220714061302.2715102-1-anshuman.khandual@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_spe_pmu.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index db670b265897..b65a7d9640e1 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -39,6 +39,24 @@
 #include <asm/mmu.h>
 #include <asm/sysreg.h>
 
+/*
+ * Cache if the event is allowed to trace Context information.
+ * This allows us to perform the check, i.e, perfmon_capable(),
+ * in the context of the event owner, once, during the event_init().
+ */
+#define SPE_PMU_HW_FLAGS_CX			BIT(0)
+
+static void set_spe_event_has_cx(struct perf_event *event)
+{
+	if (IS_ENABLED(CONFIG_PID_IN_CONTEXTIDR) && perfmon_capable())
+		event->hw.flags |= SPE_PMU_HW_FLAGS_CX;
+}
+
+static bool get_spe_event_has_cx(struct perf_event *event)
+{
+	return !!(event->hw.flags & SPE_PMU_HW_FLAGS_CX);
+}
+
 #define ARM_SPE_BUF_PAD_BYTE			0
 
 struct arm_spe_pmu_buf {
@@ -272,7 +290,7 @@ static u64 arm_spe_event_to_pmscr(struct perf_event *event)
 	if (!attr->exclude_kernel)
 		reg |= BIT(SYS_PMSCR_EL1_E1SPE_SHIFT);
 
-	if (IS_ENABLED(CONFIG_PID_IN_CONTEXTIDR) && perfmon_capable())
+	if (get_spe_event_has_cx(event))
 		reg |= BIT(SYS_PMSCR_EL1_CX_SHIFT);
 
 	return reg;
@@ -709,10 +727,10 @@ static int arm_spe_pmu_event_init(struct perf_event *event)
 	    !(spe_pmu->features & SPE_PMU_FEAT_FILT_LAT))
 		return -EOPNOTSUPP;
 
+	set_spe_event_has_cx(event);
 	reg = arm_spe_event_to_pmscr(event);
 	if (!perfmon_capable() &&
 	    (reg & (BIT(SYS_PMSCR_EL1_PA_SHIFT) |
-		    BIT(SYS_PMSCR_EL1_CX_SHIFT) |
 		    BIT(SYS_PMSCR_EL1_PCT_SHIFT))))
 		return -EACCES;
 
-- 
2.35.1



