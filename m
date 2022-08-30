Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8155A69EC
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbiH3RYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbiH3RYR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:24:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949A083F26;
        Tue, 30 Aug 2022 10:22:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DFE1B81C55;
        Tue, 30 Aug 2022 17:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7736BC433D6;
        Tue, 30 Aug 2022 17:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880111;
        bh=IcePTnMHihrsUWlbeyVz9D8TRa7GQlmOaSor87kg+Os=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=URMp7UB+PHx09AM4ii0lQZWw3KVMyYnQgmqXi13tsT0O1ZmejMzT/zVudxNO54YNC
         06Bi5HY+WQz9qk03TYD1qWrVI/2emqbeGKqqq0PYgM8vb6QhX/63c76WyhkhtmYlD9
         AvyOE/tuT+PVeZQrB3R3zRt7Om/JeH5OA7SW/44TNAnGqNuKfRQv/VS7bBcglAdUrf
         M/oBMU8Lc55fD/HmabXam0+D4i3MXosabyhujALajLItbh5mG/ipgE/Ve436eKlz5r
         gM0wkGV+TV54u6UFfTU0vH7WfQtG//T4fUUesdZx0uaK1ZAa3AINiKc9+oIpljAEHM
         BjiGyr2PDKQow==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Like Xu <likexu@tencent.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        acme@kernel.org, tglx@linutronix.de, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 05/23] perf/x86/core: Set pebs_capable and PMU_FL_PEBS_ALL for the Baseline
Date:   Tue, 30 Aug 2022 13:21:22 -0400
Message-Id: <20220830172141.581086-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830172141.581086-1-sashal@kernel.org>
References: <20220830172141.581086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 7d3598868aaee05eb738d1c3115616b867e7530a ]

The SDM explicitly states that PEBS Baseline implies Extended PEBS.
For cpu model forward compatibility (e.g. on ICX, SPR, ADL), it's
safe to stop doing FMS table thing such as setting pebs_capable and
PMU_FL_PEBS_ALL since it's already set in the intel_ds_init().

The Goldmont Plus is the only platform which supports extended PEBS
but doesn't have Baseline. Keep the status quo.

Reported-by: Like Xu <likexu@tencent.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lkml.kernel.org/r/20220816114057.51307-1-likexu@tencent.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 2 --
 arch/x86/events/intel/ds.c   | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 588b83cc730d3..4fa4ee7fa6076 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6122,7 +6122,6 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_block = true;
 		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
-		x86_pmu.flags |= PMU_FL_PEBS_ALL;
 		x86_pmu.flags |= PMU_FL_INSTR_LATENCY;
 		x86_pmu.flags |= PMU_FL_MEM_LOADS_AUX;
 
@@ -6164,7 +6163,6 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_block = true;
 		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
-		x86_pmu.flags |= PMU_FL_PEBS_ALL;
 		x86_pmu.flags |= PMU_FL_INSTR_LATENCY;
 		x86_pmu.flags |= PMU_FL_MEM_LOADS_AUX;
 		x86_pmu.lbr_pt_coexist = true;
diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 4dbb55a43dad2..78d3050fbfb88 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -2211,6 +2211,7 @@ void __init intel_ds_init(void)
 					PERF_SAMPLE_BRANCH_STACK |
 					PERF_SAMPLE_TIME;
 				x86_pmu.flags |= PMU_FL_PEBS_ALL;
+				x86_pmu.pebs_capable = ~0ULL;
 				pebs_qual = "-baseline";
 				x86_get_pmu(smp_processor_id())->capabilities |= PERF_PMU_CAP_EXTENDED_REGS;
 			} else {
-- 
2.35.1

