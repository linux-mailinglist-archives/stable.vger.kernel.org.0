Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B523ACEF3
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 17:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235433AbhFRPbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 11:31:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:7117 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235441AbhFRPbD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Jun 2021 11:31:03 -0400
IronPort-SDR: 2RNbvj99O3fWnnxCr2Lr+cDh0DiVYYS7ZDsi0DDukEKrHkuwh79OncyvZuvhcbtfwcMAM4FLUU
 G2Or2UOgO2bg==
X-IronPort-AV: E=McAfee;i="6200,9189,10019"; a="228099637"
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="228099637"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 08:27:38 -0700
IronPort-SDR: aJNqamVDDtaY37t3WVh+Y+edICyczRVVKg1PY4L/gXNPzIwCUAIpZUKs0FoBUXcbTa61IN7yc2
 b/Z64a9EiaZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="405004817"
Received: from otc-lr-04.jf.intel.com ([10.54.39.41])
  by orsmga006.jf.intel.com with ESMTP; 18 Jun 2021 08:27:34 -0700
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Cc:     acme@kernel.org, jolsa@redhat.com, namhyung@kernel.org,
        ak@linux.intel.com, Kan Liang <kan.liang@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 3/3] perf/x86/intel: Fix instructions:ppp support in Sapphire Rapids
Date:   Fri, 18 Jun 2021 08:12:54 -0700
Message-Id: <1624029174-122219-4-git-send-email-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1624029174-122219-1-git-send-email-kan.liang@linux.intel.com>
References: <1624029174-122219-1-git-send-email-kan.liang@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

Perf errors out when sampling instructions:ppp.

$ perf record -e instructions:ppp -- true
Error:
The sys_perf_event_open() syscall returned with 22 (Invalid argument)
for event (instructions:ppp).

The instruction PDIR is only available on the fixed counter 0. The event
constraint has been updated to fixed0_constraint in
icl_get_event_constraints(). The Sapphire Rapids codes unconditionally
error out for the event which is not available on the GP counter 0.

Make the instructions:ppp an exception.

Fixes: 61b985e3e775 ("perf/x86/intel: Add perf core PMU support for Sapphire Rapids")
Reported-by: Yasin, Ahmad <ahmad.yasin@intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/events/intel/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index e442b55..e355db5 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4032,8 +4032,10 @@ spr_get_event_constraints(struct cpu_hw_events *cpuc, int idx,
 	 * The :ppp indicates the Precise Distribution (PDist) facility, which
 	 * is only supported on the GP counter 0. If a :ppp event which is not
 	 * available on the GP counter 0, error out.
+	 * Exception: Instruction PDIR is only available on the fixed counter 0.
 	 */
-	if (event->attr.precise_ip == 3) {
+	if ((event->attr.precise_ip == 3) &&
+	    !constraint_match(&fixed0_constraint, event->hw.config)) {
 		if (c->idxmsk64 & BIT_ULL(0))
 			return &counter0_constraint;
 
-- 
2.7.4

