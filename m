Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 731AA4E9BA4
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 17:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237866AbiC1PwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 11:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234752AbiC1PwJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 11:52:09 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E428D6;
        Mon, 28 Mar 2022 08:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648482628; x=1680018628;
  h=from:to:cc:subject:date:message-id;
  bh=tlMl6mWTjEgCjjBZ7AIYF8HCdwTMIlqr2UAHIAdUy+E=;
  b=jmX/BqMqumzzial2Cc1UZTbssWr0sgw9KkoxerHY1Dm2VV/f//5RBZkF
   PZhMEELE2Z1MVquAP6wJLHgvOXlVZHy+HxXySjJCVcK1eHd3Vt1kGKiUW
   1jl/hV5vDTF9RQ0fp3eHF3HUA4WrXqx6L5rdJtr8RkCsqoy2Uom1uGm1M
   VcBNMs+8urQKOGGgdwFZHgo3Z4KAB0jrjor+mHKGPNix5VqUCfP0ZRcBD
   XYB0ds//Yq6P0BkYR2807fOqwTrZrAzo6OTe85di+Ohtx5xwhFD47YUMF
   dYHuduf8lVG+3zZYgq0rnTFl2kynj3npH7rmVkaJmaL6VlVJXWSbhokDZ
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10300"; a="257863535"
X-IronPort-AV: E=Sophos;i="5.90,217,1643702400"; 
   d="scan'208";a="257863535"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 08:50:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,217,1643702400"; 
   d="scan'208";a="617824927"
Received: from otc-lr-04.jf.intel.com ([10.54.39.41])
  by fmsmga004.fm.intel.com with ESMTP; 28 Mar 2022 08:50:19 -0700
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Cc:     eranian@google.com, Kan Liang <kan.liang@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] perf/x86/intel: Don't extend the pseudo-encoding to GP counters
Date:   Mon, 28 Mar 2022 08:49:02 -0700
Message-Id: <1648482543-14923-1-git-send-email-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

The INST_RETIRED.PREC_DIST event (0x0100) doesn't count on SPR.
perf stat -e cpu/event=0xc0,umask=0x0/,cpu/event=0x0,umask=0x1/ -C0

 Performance counter stats for 'CPU(s) 0':

           607,246      cpu/event=0xc0,umask=0x0/
                 0      cpu/event=0x0,umask=0x1/

The encoding for INST_RETIRED.PREC_DIST is pseudo-encoding, which
doesn't work on the generic counters. However, current perf extends its
mask to the generic counters.

The pseudo event-code for a fixed counter must be 0x00. Check and avoid
extending the mask for the fixed counter event which using the
pseudo-encoding, e.g., ref-cycles and PREC_DIST event.

With the patch,
perf stat -e cpu/event=0xc0,umask=0x0/,cpu/event=0x0,umask=0x1/ -C0

 Performance counter stats for 'CPU(s) 0':

           583,184      cpu/event=0xc0,umask=0x0/
           583,048      cpu/event=0x0,umask=0x1/

Fixes: 2de71ee153ef ("perf/x86/intel: Fix ICL/SPR INST_RETIRED.PREC_DIST encodings")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/events/intel/core.c      | 6 +++++-
 arch/x86/include/asm/perf_event.h | 5 +++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index db32ef6..1d2e49d 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -5668,7 +5668,11 @@ static void intel_pmu_check_event_constraints(struct event_constraint *event_con
 			/* Disabled fixed counters which are not in CPUID */
 			c->idxmsk64 &= intel_ctrl;
 
-			if (c->idxmsk64 != INTEL_PMC_MSK_FIXED_REF_CYCLES)
+			/*
+			 * Don't extend the pseudo-encoding to the
+			 * generic counters
+			 */
+			if (!use_fixed_pseudo_encoding(c->code))
 				c->idxmsk64 |= (1ULL << num_counters) - 1;
 		}
 		c->idxmsk64 &=
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 48e6ef56..cd85f03 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -242,6 +242,11 @@ struct x86_pmu_capability {
 #define INTEL_PMC_IDX_FIXED_SLOTS	(INTEL_PMC_IDX_FIXED + 3)
 #define INTEL_PMC_MSK_FIXED_SLOTS	(1ULL << INTEL_PMC_IDX_FIXED_SLOTS)
 
+static inline bool use_fixed_pseudo_encoding(u64 code)
+{
+	return !(code & 0xff);
+}
+
 /*
  * We model BTS tracing as another fixed-mode PMC.
  *
-- 
2.7.4

