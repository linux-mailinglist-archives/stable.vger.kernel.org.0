Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE5C292BD2
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 18:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730700AbgJSQuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 12:50:03 -0400
Received: from mga05.intel.com ([192.55.52.43]:62796 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730322AbgJSQuC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Oct 2020 12:50:02 -0400
IronPort-SDR: 5hs9Qtbm8sL6Nmaaez0x9vOQrLqsfeuBJeydMkZQjf/XWxPUUFZeH8dQ17bzFNK/RitmF1pHF/
 6V/tlKRwtPCw==
X-IronPort-AV: E=McAfee;i="6000,8403,9779"; a="251758321"
X-IronPort-AV: E=Sophos;i="5.77,395,1596524400"; 
   d="scan'208";a="251758321"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2020 09:49:54 -0700
IronPort-SDR: Z+PIeKAUWC+25XMMMDJbHgCoUIxiMFJvImhBW7CPRY4azvfgB5Rx6fsHrggDEhBeL95yfpayFl
 ozlSgqzKL6Tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,395,1596524400"; 
   d="scan'208";a="331941422"
Received: from ssp-icl-u-210.jf.intel.com ([10.54.55.52])
  by orsmga002.jf.intel.com with ESMTP; 19 Oct 2020 09:49:54 -0700
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Cc:     ak@linux.intel.com, Kan Liang <kan.liang@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH V2] perf/x86/intel: Add event constraint for CYCLE_ACTIVITY.STALLS_MEM_ANY
Date:   Mon, 19 Oct 2020 09:45:29 -0700
Message-Id: <20201019164529.32154-1-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

The event CYCLE_ACTIVITY.STALLS_MEM_ANY (0x14a3) should be available on
all 8 GP counters on ICL, but it's only scheduled on the first four
counters due to the current ICL constraint table.

Add a line for the CYCLE_ACTIVITY.STALLS_MEM_ANY event in the ICL
constraint table.
Correct the comments for the CYCLE_ACTIVITY.CYCLES_MEM_ANY event.

Fixes: 6017608936c1 ("perf/x86/intel: Add Icelake support")
Reported-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/events/intel/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index c72e4904e056..b31ebb5f7fc4 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -257,7 +257,8 @@ static struct event_constraint intel_icl_event_constraints[] = {
 	INTEL_EVENT_CONSTRAINT_RANGE(0x48, 0x54, 0xf),
 	INTEL_EVENT_CONSTRAINT_RANGE(0x60, 0x8b, 0xf),
 	INTEL_UEVENT_CONSTRAINT(0x04a3, 0xff),  /* CYCLE_ACTIVITY.STALLS_TOTAL */
-	INTEL_UEVENT_CONSTRAINT(0x10a3, 0xff),  /* CYCLE_ACTIVITY.STALLS_MEM_ANY */
+	INTEL_UEVENT_CONSTRAINT(0x10a3, 0xff),  /* CYCLE_ACTIVITY.CYCLES_MEM_ANY */
+	INTEL_UEVENT_CONSTRAINT(0x14a3, 0xff),  /* CYCLE_ACTIVITY.STALLS_MEM_ANY */
 	INTEL_EVENT_CONSTRAINT(0xa3, 0xf),      /* CYCLE_ACTIVITY.* */
 	INTEL_EVENT_CONSTRAINT_RANGE(0xa8, 0xb0, 0xf),
 	INTEL_EVENT_CONSTRAINT_RANGE(0xb7, 0xbd, 0xf),
-- 
2.17.1

