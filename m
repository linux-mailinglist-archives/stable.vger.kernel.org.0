Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686A2338EC1
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 14:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbhCLN17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 08:27:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:56991 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230388AbhCLN1g (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 08:27:36 -0500
IronPort-SDR: sH2XBGAnXNphbWcieO4+z+eSXt8cI75jgYzuOLtzzuzQGhvKuXZKnlj8QlhA6LaaphlNHACqZH
 HuOuNZQl0GZw==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="188925747"
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="188925747"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 05:27:35 -0800
IronPort-SDR: k9+PmAGg1ubcHuwmIH54K9R+X9P+V2MHQAguIyx9iRNNEuSFikCNVIKuyt5nDVLhJrI+id3OGK
 NZsP5kuK+DdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="409848764"
Received: from otc-lr-04.jf.intel.com ([10.54.39.41])
  by orsmga007.jf.intel.com with ESMTP; 12 Mar 2021 05:27:35 -0800
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     vincent.weaver@maine.edu, eranian@google.com, ak@linux.intel.com,
        Kan Liang <kan.liang@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] perf/x86/intel: Fix a crash caused by zero PEBS status
Date:   Fri, 12 Mar 2021 05:21:37 -0800
Message-Id: <1615555298-140216-1-git-send-email-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

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

Besides the local pebs_status, correct the PEBS status in the PEBS
record as well.

Fixes: 01330d7288e0 ("perf/x86: Allow zero PEBS status with only single active event")
Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/events/intel/ds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 7ebae18..bcf4fa5 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -2010,7 +2010,7 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs, struct perf_sample_d
 		 */
 		if (!pebs_status && cpuc->pebs_enabled &&
 			!(cpuc->pebs_enabled & (cpuc->pebs_enabled-1)))
-			pebs_status = cpuc->pebs_enabled;
+			pebs_status = p->status = cpuc->pebs_enabled;
 
 		bit = find_first_bit((unsigned long *)&pebs_status,
 					x86_pmu.max_pebs_events);
-- 
2.7.4

