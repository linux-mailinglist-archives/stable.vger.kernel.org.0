Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 526BB594675
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352133AbiHOW5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352545AbiHOW4R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:56:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E47B642F4;
        Mon, 15 Aug 2022 12:55:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1A586CE12C1;
        Mon, 15 Aug 2022 19:55:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD13C433D6;
        Mon, 15 Aug 2022 19:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593331;
        bh=ZlP02CErwL5spOOFP0xeXrsrG3wjZ7Udqm4opyEYMgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sjqt+fXFbu7n72+t+wSS9hyR7M41BqkXSA7WnsXIL557RrgSBvkx4AqhNQu/ZewpZ
         l+jxqyQQQNxD/jCe6zVnjA0IvMM9Oo8Cb3upAa7T9QhfGoaoWe476RRiE3zqVqNzJv
         VNRpYqq+oReAzH8xy9LxMUqzqHTZDNQcclsF9VGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0252/1157] perf/x86/intel: Fix PEBS data source encoding for ADL
Date:   Mon, 15 Aug 2022 19:53:28 +0200
Message-Id: <20220815180449.680431529@linuxfoundation.org>
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

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit ccf170e9d8fdacfe435bbe3749c897c7d86d32f8 ]

The PEBS data source encoding for the e-core is different from the
p-core.

Add the pebs_data_source[] in the struct x86_hybrid_pmu to store the
data source encoding for each type of the core.

Add intel_pmu_pebs_data_source_grt() for the e-core.
There is nothing changed for the data source encoding of the p-core,
which still reuse the intel_pmu_pebs_data_source_skl().

Fixes: f83d2f91d259 ("perf/x86/intel: Add Alder Lake Hybrid support")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Link: https://lkml.kernel.org/r/20220629150840.2235741-2-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c |  2 +-
 arch/x86/events/intel/ds.c   | 51 +++++++++++++++++++++++++++---------
 arch/x86/events/perf_event.h |  6 +++++
 3 files changed, 45 insertions(+), 14 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 07d4a5f20321..bd8b98857609 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6241,7 +6241,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.flags |= PMU_FL_INSTR_LATENCY;
 		x86_pmu.flags |= PMU_FL_MEM_LOADS_AUX;
 		x86_pmu.lbr_pt_coexist = true;
-		intel_pmu_pebs_data_source_skl(false);
+		intel_pmu_pebs_data_source_adl();
 		x86_pmu.pebs_latency_data = adl_latency_data_small;
 		x86_pmu.num_topdown_events = 8;
 		x86_pmu.update_topdown_event = adl_update_topdown_event;
diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index de84385de414..ba60427caa6d 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -94,15 +94,40 @@ void __init intel_pmu_pebs_data_source_nhm(void)
 	pebs_data_source[0x07] = OP_LH | P(LVL, L3) | LEVEL(L3) | P(SNOOP, HITM);
 }
 
-void __init intel_pmu_pebs_data_source_skl(bool pmem)
+static void __init __intel_pmu_pebs_data_source_skl(bool pmem, u64 *data_source)
 {
 	u64 pmem_or_l4 = pmem ? LEVEL(PMEM) : LEVEL(L4);
 
-	pebs_data_source[0x08] = OP_LH | pmem_or_l4 | P(SNOOP, HIT);
-	pebs_data_source[0x09] = OP_LH | pmem_or_l4 | REM | P(SNOOP, HIT);
-	pebs_data_source[0x0b] = OP_LH | LEVEL(RAM) | REM | P(SNOOP, NONE);
-	pebs_data_source[0x0c] = OP_LH | LEVEL(ANY_CACHE) | REM | P(SNOOPX, FWD);
-	pebs_data_source[0x0d] = OP_LH | LEVEL(ANY_CACHE) | REM | P(SNOOP, HITM);
+	data_source[0x08] = OP_LH | pmem_or_l4 | P(SNOOP, HIT);
+	data_source[0x09] = OP_LH | pmem_or_l4 | REM | P(SNOOP, HIT);
+	data_source[0x0b] = OP_LH | LEVEL(RAM) | REM | P(SNOOP, NONE);
+	data_source[0x0c] = OP_LH | LEVEL(ANY_CACHE) | REM | P(SNOOPX, FWD);
+	data_source[0x0d] = OP_LH | LEVEL(ANY_CACHE) | REM | P(SNOOP, HITM);
+}
+
+void __init intel_pmu_pebs_data_source_skl(bool pmem)
+{
+	__intel_pmu_pebs_data_source_skl(pmem, pebs_data_source);
+}
+
+static void __init intel_pmu_pebs_data_source_grt(u64 *data_source)
+{
+	data_source[0x05] = OP_LH | P(LVL, L3) | LEVEL(L3) | P(SNOOP, HIT);
+	data_source[0x06] = OP_LH | P(LVL, L3) | LEVEL(L3) | P(SNOOP, HITM);
+	data_source[0x08] = OP_LH | P(LVL, L3) | LEVEL(L3) | P(SNOOPX, FWD);
+}
+
+void __init intel_pmu_pebs_data_source_adl(void)
+{
+	u64 *data_source;
+
+	data_source = x86_pmu.hybrid_pmu[X86_HYBRID_PMU_CORE_IDX].pebs_data_source;
+	memcpy(data_source, pebs_data_source, sizeof(pebs_data_source));
+	__intel_pmu_pebs_data_source_skl(false, data_source);
+
+	data_source = x86_pmu.hybrid_pmu[X86_HYBRID_PMU_ATOM_IDX].pebs_data_source;
+	memcpy(data_source, pebs_data_source, sizeof(pebs_data_source));
+	intel_pmu_pebs_data_source_grt(data_source);
 }
 
 static u64 precise_store_data(u64 status)
@@ -198,7 +223,7 @@ u64 adl_latency_data_small(struct perf_event *event, u64 status)
 
 	dse.val = status;
 
-	val = pebs_data_source[dse.ld_dse];
+	val = hybrid_var(event->pmu, pebs_data_source)[dse.ld_dse];
 
 	/*
 	 * For the atom core on ADL,
@@ -214,7 +239,7 @@ u64 adl_latency_data_small(struct perf_event *event, u64 status)
 	return val;
 }
 
-static u64 load_latency_data(u64 status)
+static u64 load_latency_data(struct perf_event *event, u64 status)
 {
 	union intel_x86_pebs_dse dse;
 	u64 val;
@@ -224,7 +249,7 @@ static u64 load_latency_data(u64 status)
 	/*
 	 * use the mapping table for bit 0-3
 	 */
-	val = pebs_data_source[dse.ld_dse];
+	val = hybrid_var(event->pmu, pebs_data_source)[dse.ld_dse];
 
 	/*
 	 * Nehalem models do not support TLB, Lock infos
@@ -263,7 +288,7 @@ static u64 load_latency_data(u64 status)
 	return val;
 }
 
-static u64 store_latency_data(u64 status)
+static u64 store_latency_data(struct perf_event *event, u64 status)
 {
 	union intel_x86_pebs_dse dse;
 	u64 val;
@@ -273,7 +298,7 @@ static u64 store_latency_data(u64 status)
 	/*
 	 * use the mapping table for bit 0-3
 	 */
-	val = pebs_data_source[dse.st_lat_dse];
+	val = hybrid_var(event->pmu, pebs_data_source)[dse.st_lat_dse];
 
 	pebs_set_tlb_lock(&val, dse.st_lat_stlb_miss, dse.st_lat_locked);
 
@@ -1459,9 +1484,9 @@ static u64 get_data_src(struct perf_event *event, u64 aux)
 	bool fst = fl & (PERF_X86_EVENT_PEBS_ST | PERF_X86_EVENT_PEBS_HSW_PREC);
 
 	if (fl & PERF_X86_EVENT_PEBS_LDLAT)
-		val = load_latency_data(aux);
+		val = load_latency_data(event, aux);
 	else if (fl & PERF_X86_EVENT_PEBS_STLAT)
-		val = store_latency_data(aux);
+		val = store_latency_data(event, aux);
 	else if (fl & PERF_X86_EVENT_PEBS_LAT_HYBRID)
 		val = x86_pmu.pebs_latency_data(event, aux);
 	else if (fst && (fl & PERF_X86_EVENT_PEBS_HSW_PREC))
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index ff6dd189739e..821098aebf78 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -643,6 +643,8 @@ enum {
 	x86_lbr_exclusive_max,
 };
 
+#define PERF_PEBS_DATA_SOURCE_MAX	0x10
+
 struct x86_hybrid_pmu {
 	struct pmu			pmu;
 	const char			*name;
@@ -670,6 +672,8 @@ struct x86_hybrid_pmu {
 	unsigned int			late_ack	:1,
 					mid_ack		:1,
 					enabled_ack	:1;
+
+	u64				pebs_data_source[PERF_PEBS_DATA_SOURCE_MAX];
 };
 
 static __always_inline struct x86_hybrid_pmu *hybrid_pmu(struct pmu *pmu)
@@ -1507,6 +1511,8 @@ void intel_pmu_pebs_data_source_nhm(void);
 
 void intel_pmu_pebs_data_source_skl(bool pmem);
 
+void intel_pmu_pebs_data_source_adl(void);
+
 int intel_pmu_setup_lbr_filter(struct perf_event *event);
 
 void intel_pt_interrupt(void);
-- 
2.35.1



