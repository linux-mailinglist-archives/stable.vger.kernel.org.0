Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0700F73FC7
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388151AbfGXT17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:27:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:45990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727795AbfGXT17 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:27:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A2D620659;
        Wed, 24 Jul 2019 19:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996477;
        bh=SA+G07viadBKMt3hQ1A3/CmvBLMCBOrDuYqhRjrokoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5vV+v6ORJUoRMiXiLwhnj0m17hWTPZOOlEBo72DcAAg/oVt/FTGXTsJ0xywSGrTG
         w0L+z7TxNSrV2J6V2kRHY/CGxJs6pgEWZUAD99vJ4kqi6QnorgoVIZmnWzfheQw6aV
         M1sG59N89LUAkknaMb9BByMA3aOSvKUK+9nxNjbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, bp@alien8.de,
        qiuxu.zhuo@intel.com, rui.zhang@intel.com, tony.luck@intel.com,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 109/413] perf/x86/intel: Add more Icelake CPUIDs
Date:   Wed, 24 Jul 2019 21:16:40 +0200
Message-Id: <20190724191743.118327550@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



