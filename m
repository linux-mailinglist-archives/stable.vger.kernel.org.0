Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA1268CBC
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 15:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731128AbfGONxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:53:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730275AbfGONxh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:53:37 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3DC0206B8;
        Mon, 15 Jul 2019 13:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198816;
        bh=ju8EwWbUdlkvh6yIuani2m8b6x88i0mWbtMMgHlQqF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fglsENIYRDEVlAyijr12W8pGKlXuRhDAlML2lG3Jj6WXgTan6DALuzEpuJRh6+oqh
         JMRbrsuNBdX54X7ypKDC9sSvwYSG4yzs/UhjhpK3Ife+e82RKy0rk9EwH/V9EkKzMM
         wH4IZXD7nsoX3mWET/1/0fpwHDXlS60pkPK5UT8w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, bp@alien8.de,
        qiuxu.zhuo@intel.com, rui.zhang@intel.com, tony.luck@intel.com,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 112/249] perf/x86/intel: Add more Icelake CPUIDs
Date:   Mon, 15 Jul 2019 09:44:37 -0400
Message-Id: <20190715134655.4076-112-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit faaeff98666c24376cebd0b106504d05a36881d1 ]

Add new model number for Icelake desktop and server to perf.

The data source encoding for Icelake server is the same as Skylake
server.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: bp@alien8.de
Cc: qiuxu.zhuo@intel.com
Cc: rui.zhang@intel.com
Cc: tony.luck@intel.com
Link: https://lkml.kernel.org/r/20190603134122.13853-2-kan.liang@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index a5436cee20b1..b6cae65aa7ef 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4439,6 +4439,7 @@ __init int intel_pmu_init(void)
 	struct event_constraint *c;
 	unsigned int unused;
 	struct extra_reg *er;
+	bool pmem = false;
 	int version, i;
 	char *name;
 
@@ -4890,9 +4891,10 @@ __init int intel_pmu_init(void)
 		name = "knights-landing";
 		break;
 
+	case INTEL_FAM6_SKYLAKE_X:
+		pmem = true;
 	case INTEL_FAM6_SKYLAKE_MOBILE:
 	case INTEL_FAM6_SKYLAKE_DESKTOP:
-	case INTEL_FAM6_SKYLAKE_X:
 	case INTEL_FAM6_KABYLAKE_MOBILE:
 	case INTEL_FAM6_KABYLAKE_DESKTOP:
 		x86_add_quirk(intel_pebs_isolation_quirk);
@@ -4925,8 +4927,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.cpu_events = hsw_events_attrs;
 		mem_attr = hsw_mem_events_attrs;
 		tsx_attr = hsw_tsx_events_attrs;
-		intel_pmu_pebs_data_source_skl(
-			boot_cpu_data.x86_model == INTEL_FAM6_SKYLAKE_X);
+		intel_pmu_pebs_data_source_skl(pmem);
 
 		if (boot_cpu_has(X86_FEATURE_TSX_FORCE_ABORT)) {
 			x86_pmu.flags |= PMU_FL_TFA;
@@ -4940,7 +4941,11 @@ __init int intel_pmu_init(void)
 		name = "skylake";
 		break;
 
+	case INTEL_FAM6_ICELAKE_X:
+	case INTEL_FAM6_ICELAKE_XEON_D:
+		pmem = true;
 	case INTEL_FAM6_ICELAKE_MOBILE:
+	case INTEL_FAM6_ICELAKE_DESKTOP:
 		x86_pmu.late_ack = true;
 		memcpy(hw_cache_event_ids, skl_hw_cache_event_ids, sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, skl_hw_cache_extra_regs, sizeof(hw_cache_extra_regs));
@@ -4963,7 +4968,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.cpu_events = get_icl_events_attrs();
 		x86_pmu.rtm_abort_event = X86_CONFIG(.event=0xca, .umask=0x02);
 		x86_pmu.lbr_pt_coexist = true;
-		intel_pmu_pebs_data_source_skl(false);
+		intel_pmu_pebs_data_source_skl(pmem);
 		pr_cont("Icelake events, ");
 		name = "icelake";
 		break;
-- 
2.20.1

