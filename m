Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCC15F9991
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbiJJHOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232137AbiJJHNc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:13:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDBEDA;
        Mon, 10 Oct 2022 00:08:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D84E860E08;
        Mon, 10 Oct 2022 07:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21DDC433D6;
        Mon, 10 Oct 2022 07:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385639;
        bh=wECgCqn284g2WLAFZTD5CT6LRDXaFqK+ZymroE7rTwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lGL5u8/hucUCP+Gf4NgHBu9V6oOJwSIPgBWOcjAgDjCI35mSwGtKijqs9ZMS3Np1y
         llHM38NwDNJdPslPaSBZ/Mj565gBYTeCNaNYcd9XrmwDF8KrsqmfHKnM4NtArJURrM
         V1lvJZQdWeDSOqxnxKi9Qbm0FIjIP9BfpVJs/290=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianfeng Gao <jianfeng.gao@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 35/48] perf/x86/intel: Fix unchecked MSR access error for Alder Lake N
Date:   Mon, 10 Oct 2022 09:05:33 +0200
Message-Id: <20221010070334.605467137@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070333.676316214@linuxfoundation.org>
References: <20221010070333.676316214@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 24919fdea6f8b31d7cdf32ac291bc5dd0b023878 ]

For some Alder Lake N machine, the below unchecked MSR access error may be
triggered.

[ 0.088017] rcu: Hierarchical SRCU implementation.
[ 0.088017] unchecked MSR access error: WRMSR to 0x38f (tried to write
0x0001000f0000003f) at rIP: 0xffffffffb5684de8 (native_write_msr+0x8/0x30)
[ 0.088017] Call Trace:
[ 0.088017] <TASK>
[ 0.088017] __intel_pmu_enable_all.constprop.46+0x4a/0xa0

The Alder Lake N only has e-cores. The X86_FEATURE_HYBRID_CPU flag is
not set. The perf cannot retrieve the correct CPU type via
get_this_hybrid_cpu_type(). The model specific get_hybrid_cpu_type() is
hardcode to p-core. The wrong CPU type is given to the PMU of the
Alder Lake N.

Since Alder Lake N isn't in fact a hybrid CPU, remove ALDERLAKE_N from
the rest of {ALDER,RAPTOP}LAKE and create a non-hybrid PMU setup.

The differences between Gracemont and the previous Tremont are,
- Number of GP counters
- Load and store latency Events
- PEBS event_constraints
- Instruction Latency support
- Data source encoding
- Memory access latency encoding

Fixes: c2a960f7c574 ("perf/x86: Add new Alder Lake and Raptor Lake support")
Reported-by: Jianfeng Gao <jianfeng.gao@intel.com>
Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20220831142702.153110-1-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 40 +++++++++++++++++++++++++++++++++++-
 arch/x86/events/intel/ds.c   |  9 ++++++--
 arch/x86/events/perf_event.h |  2 ++
 3 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index bd8b98857609..8d6befb24b8e 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2101,6 +2101,15 @@ static struct extra_reg intel_tnt_extra_regs[] __read_mostly = {
 	EVENT_EXTRA_END
 };
 
+EVENT_ATTR_STR(mem-loads,	mem_ld_grt,	"event=0xd0,umask=0x5,ldlat=3");
+EVENT_ATTR_STR(mem-stores,	mem_st_grt,	"event=0xd0,umask=0x6");
+
+static struct attribute *grt_mem_attrs[] = {
+	EVENT_PTR(mem_ld_grt),
+	EVENT_PTR(mem_st_grt),
+	NULL
+};
+
 static struct extra_reg intel_grt_extra_regs[] __read_mostly = {
 	/* must define OFFCORE_RSP_X first, see intel_fixup_er() */
 	INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0x3fffffffffull, RSP_0),
@@ -5874,6 +5883,36 @@ __init int intel_pmu_init(void)
 		name = "Tremont";
 		break;
 
+	case INTEL_FAM6_ALDERLAKE_N:
+		x86_pmu.mid_ack = true;
+		memcpy(hw_cache_event_ids, glp_hw_cache_event_ids,
+		       sizeof(hw_cache_event_ids));
+		memcpy(hw_cache_extra_regs, tnt_hw_cache_extra_regs,
+		       sizeof(hw_cache_extra_regs));
+		hw_cache_event_ids[C(ITLB)][C(OP_READ)][C(RESULT_ACCESS)] = -1;
+
+		x86_pmu.event_constraints = intel_slm_event_constraints;
+		x86_pmu.pebs_constraints = intel_grt_pebs_event_constraints;
+		x86_pmu.extra_regs = intel_grt_extra_regs;
+
+		x86_pmu.pebs_aliases = NULL;
+		x86_pmu.pebs_prec_dist = true;
+		x86_pmu.pebs_block = true;
+		x86_pmu.lbr_pt_coexist = true;
+		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
+		x86_pmu.flags |= PMU_FL_INSTR_LATENCY;
+
+		intel_pmu_pebs_data_source_grt();
+		x86_pmu.pebs_latency_data = adl_latency_data_small;
+		x86_pmu.get_event_constraints = tnt_get_event_constraints;
+		x86_pmu.limit_period = spr_limit_period;
+		td_attr = tnt_events_attrs;
+		mem_attr = grt_mem_attrs;
+		extra_attr = nhm_format_attr;
+		pr_cont("Gracemont events, ");
+		name = "gracemont";
+		break;
+
 	case INTEL_FAM6_WESTMERE:
 	case INTEL_FAM6_WESTMERE_EP:
 	case INTEL_FAM6_WESTMERE_EX:
@@ -6216,7 +6255,6 @@ __init int intel_pmu_init(void)
 
 	case INTEL_FAM6_ALDERLAKE:
 	case INTEL_FAM6_ALDERLAKE_L:
-	case INTEL_FAM6_ALDERLAKE_N:
 	case INTEL_FAM6_RAPTORLAKE:
 	case INTEL_FAM6_RAPTORLAKE_P:
 		/*
diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 9b48d957d2b3..139204aea94e 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -110,13 +110,18 @@ void __init intel_pmu_pebs_data_source_skl(bool pmem)
 	__intel_pmu_pebs_data_source_skl(pmem, pebs_data_source);
 }
 
-static void __init intel_pmu_pebs_data_source_grt(u64 *data_source)
+static void __init __intel_pmu_pebs_data_source_grt(u64 *data_source)
 {
 	data_source[0x05] = OP_LH | P(LVL, L3) | LEVEL(L3) | P(SNOOP, HIT);
 	data_source[0x06] = OP_LH | P(LVL, L3) | LEVEL(L3) | P(SNOOP, HITM);
 	data_source[0x08] = OP_LH | P(LVL, L3) | LEVEL(L3) | P(SNOOPX, FWD);
 }
 
+void __init intel_pmu_pebs_data_source_grt(void)
+{
+	__intel_pmu_pebs_data_source_grt(pebs_data_source);
+}
+
 void __init intel_pmu_pebs_data_source_adl(void)
 {
 	u64 *data_source;
@@ -127,7 +132,7 @@ void __init intel_pmu_pebs_data_source_adl(void)
 
 	data_source = x86_pmu.hybrid_pmu[X86_HYBRID_PMU_ATOM_IDX].pebs_data_source;
 	memcpy(data_source, pebs_data_source, sizeof(pebs_data_source));
-	intel_pmu_pebs_data_source_grt(data_source);
+	__intel_pmu_pebs_data_source_grt(data_source);
 }
 
 static u64 precise_store_data(u64 status)
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 821098aebf78..84f6f947ddef 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -1513,6 +1513,8 @@ void intel_pmu_pebs_data_source_skl(bool pmem);
 
 void intel_pmu_pebs_data_source_adl(void);
 
+void intel_pmu_pebs_data_source_grt(void);
+
 int intel_pmu_setup_lbr_filter(struct perf_event *event);
 
 void intel_pt_interrupt(void);
-- 
2.35.1



