Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5551F2C4A25
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 22:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732338AbgKYViu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 16:38:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:15611 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731952AbgKYViu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 16:38:50 -0500
IronPort-SDR: iPgQ0isC+LaaZVMbvPMji93wwFRPnYfO6mwTCqGxc24n7uzxXjQBRlV1ARxfon5NgWPlzyDyq6
 GI+3Cm7+iP9g==
X-IronPort-AV: E=McAfee;i="6000,8403,9816"; a="159250090"
X-IronPort-AV: E=Sophos;i="5.78,370,1599548400"; 
   d="scan'208";a="159250090"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2020 13:38:50 -0800
IronPort-SDR: pfDaB0yPYSPUxFXcE4H46Og9zdfbzURSUZ7l7RlH+Ri8nM6zQdb6mDUIENwDy6eUWKKKY9FrK1
 S5vyezWe636w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,370,1599548400"; 
   d="scan'208";a="365579842"
Received: from unknown (HELO labuser-Ice-Lake-Client-Platform.jf.intel.com) ([10.54.55.65])
  by fmsmga002.fm.intel.com with ESMTP; 25 Nov 2020 13:38:49 -0800
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     eranian@google.com, ak@linux.intel.com,
        Kan Liang <kan.liang@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] perf/x86/intel: Fix rtm_abort_event encoding on Ice Lake
Date:   Wed, 25 Nov 2020 13:37:19 -0800
Message-Id: <20201125213720.15692-1-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

According to the event list from icelake_core_v1.09.json, the encoding
of the RTM_RETIRED.ABORTED event on Ice Lake should be,
    "EventCode": "0xc9",
    "UMask": "0x04",
    "EventName": "RTM_RETIRED.ABORTED",

Correct the wrong encoding.

Fixes: 6017608936c1 ("perf/x86/intel: Add Icelake support")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/events/intel/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index ec503399c5df..c5aca399a46a 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -5321,7 +5321,7 @@ __init int intel_pmu_init(void)
 		mem_attr = icl_events_attrs;
 		td_attr = icl_td_events_attrs;
 		tsx_attr = icl_tsx_events_attrs;
-		x86_pmu.rtm_abort_event = X86_CONFIG(.event=0xca, .umask=0x02);
+		x86_pmu.rtm_abort_event = X86_CONFIG(.event=0xc9, .umask=0x04);
 		x86_pmu.lbr_pt_coexist = true;
 		intel_pmu_pebs_data_source_skl(pmem);
 		x86_pmu.update_topdown_event = icl_update_topdown_event;
-- 
2.17.1

