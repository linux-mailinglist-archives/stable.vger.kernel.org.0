Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78C0A5A6975
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiH3RSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbiH3RSo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:18:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3CCD6BB7;
        Tue, 30 Aug 2022 10:18:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC1556172F;
        Tue, 30 Aug 2022 17:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28BCC433C1;
        Tue, 30 Aug 2022 17:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661879921;
        bh=DPpbkP2lFMPQDukymNsUNw6LZGndApTSvx4rsplIZp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GAJrHU1NGEdQq284WLXcBAl28m6ykn/Iqd+GGAEwBNBspl/Fz34zctfBoy2gLpd7U
         dPbc1sI/xKZUVC3ekdhMP8k0OivjhR/Zgb4h+LFoEtgyJ+ue2OE8fjtvtcymAu0XFr
         P/3MrQuC0RfCnzmJqF38L91tQwR/P7wR+GNAGp4RPqN2qZSL93sGBx6k0gfnwzXdRC
         ds/xhNCk1Hzncr7QZqnGWq1IDpN1mdAfrYtEnTPK8INZJOBB87x4Z5ns/WN1QB+CLy
         NUJxd9Vhus2XzK4XNDUZVfJ5drQOIq5szxokGdKnX4htewLBRl3fYZeZJK+M0aZNaO
         REq16EGlhwF3w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Like Xu <likexu@tencent.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        acme@kernel.org, tglx@linutronix.de, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 08/33] perf/x86/core: Set pebs_capable and PMU_FL_PEBS_ALL for the Baseline
Date:   Tue, 30 Aug 2022 13:17:59 -0400
Message-Id: <20220830171825.580603-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830171825.580603-1-sashal@kernel.org>
References: <20220830171825.580603-1-sashal@kernel.org>
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
index bd8b988576097..7333f505d790e 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6192,7 +6192,6 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_block = true;
 		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
-		x86_pmu.flags |= PMU_FL_PEBS_ALL;
 		x86_pmu.flags |= PMU_FL_INSTR_LATENCY;
 		x86_pmu.flags |= PMU_FL_MEM_LOADS_AUX;
 
@@ -6237,7 +6236,6 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_block = true;
 		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
-		x86_pmu.flags |= PMU_FL_PEBS_ALL;
 		x86_pmu.flags |= PMU_FL_INSTR_LATENCY;
 		x86_pmu.flags |= PMU_FL_MEM_LOADS_AUX;
 		x86_pmu.lbr_pt_coexist = true;
diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index ba60427caa6d3..ac6dd4c96dbc1 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -2262,6 +2262,7 @@ void __init intel_ds_init(void)
 					PERF_SAMPLE_BRANCH_STACK |
 					PERF_SAMPLE_TIME;
 				x86_pmu.flags |= PMU_FL_PEBS_ALL;
+				x86_pmu.pebs_capable = ~0ULL;
 				pebs_qual = "-baseline";
 				x86_get_pmu(smp_processor_id())->capabilities |= PERF_PMU_CAP_EXTENDED_REGS;
 			} else {
-- 
2.35.1

