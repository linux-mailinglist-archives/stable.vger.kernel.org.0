Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470ED32C80E
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbhCDAdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:33:47 -0500
Received: from mga18.intel.com ([134.134.136.126]:25320 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242317AbhCCNwK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Mar 2021 08:52:10 -0500
IronPort-SDR: wC4pn15P/Rve+Ihi0RpJZQ48ZMUfppHQ8o8M3sfHlg22qZQrHIP5gsO2nsvRunV+3zNC94W9pv
 Gm9kzHEERrxQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9911"; a="174835367"
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="174835367"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 05:47:29 -0800
IronPort-SDR: kW6FgmkA7MBBHETZicJVqQovPVtm+iV1UQE0fnSOR1gBtEqLNdMtGFLrEJX7qDiv5xjh7CLF1c
 wuOsOUXY0Dtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="383988777"
Received: from otc-lr-04.jf.intel.com ([10.54.39.41])
  by orsmga002.jf.intel.com with ESMTP; 03 Mar 2021 05:47:29 -0800
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Cc:     acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, eranian@google.com, ak@linux.intel.com,
        Kan Liang <kan.liang@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH] Revert "perf/x86: Allow zero PEBS status with only single active event"
Date:   Wed,  3 Mar 2021 05:42:18 -0800
Message-Id: <1614778938-93092-1-git-send-email-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

This reverts commit 01330d7288e0 ("perf/x86: Allow zero PEBS status with
only single active event")

A repeatable crash can be triggered by the perf_fuzzer on some Haswell
system.
https://lore.kernel.org/lkml/7170d3b-c17f-1ded-52aa-cc6d9ae999f4@maine.edu/

For some old CPUs (HSW and earlier), the PEBS status in a PEBS record
may be mistakenly set to 0. To minimize the impact of the defect, the
commit was introduced to try to avoid dropping the PEBS record for some
cases. It adds a check in the intel_pmu_drain_pebs_nhm(), and updates
the local pebs_status accordingly. However, it doesn't correct the PEBS
status in the PEBS record, which may trigger the crash, especially for
the large PEBS.

It's possible that all the PEBS records in a large PEBS have the PEBS
status 0. If so, the first get_next_pebs_record_by_bit() in the
__intel_pmu_pebs_event() returns NULL. The at = NULL. Since it's a large
PEBS, the 'count' parameter must > 1. The second
get_next_pebs_record_by_bit() will crash.

Two solutions were considered to fix the crash.
- Keep the SW workaround and add extra checks in the
  get_next_pebs_record_by_bit() to workaround the issue. The
  get_next_pebs_record_by_bit() is a critical path. The extra checks
  will bring extra overhead for the latest CPUs which don't have the
  defect. Also, the defect can only be observed on some old CPUs
  (For example, the issue can be reproduced on an HSW client, but I
  didn't observe the issue on my Haswell server machine.). The impact
  of the defect should be limit.
  This solution is dropped.
- Drop the SW workaround and revert the commit.
  It seems that the commit never works, because the PEBS status in the
  PEBS record never be changed. The get_next_pebs_record_by_bit() only
  checks the PEBS status in the PEBS record. The record is dropped
  eventually. Reverting the commit should not change the current
  behavior.

Fixes: 01330d7288e0 ("perf/x86: Allow zero PEBS status with only single active event")
Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/events/intel/ds.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 7ebae18..9c90d1e 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -2000,18 +2000,6 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs, struct perf_sample_d
 			continue;
 		}
 
-		/*
-		 * On some CPUs the PEBS status can be zero when PEBS is
-		 * racing with clearing of GLOBAL_STATUS.
-		 *
-		 * Normally we would drop that record, but in the
-		 * case when there is only a single active PEBS event
-		 * we can assume it's for that event.
-		 */
-		if (!pebs_status && cpuc->pebs_enabled &&
-			!(cpuc->pebs_enabled & (cpuc->pebs_enabled-1)))
-			pebs_status = cpuc->pebs_enabled;
-
 		bit = find_first_bit((unsigned long *)&pebs_status,
 					x86_pmu.max_pebs_events);
 		if (bit >= x86_pmu.max_pebs_events)
-- 
2.7.4

