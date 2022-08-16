Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56CDB595C7E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 14:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiHPM5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 08:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbiHPM5C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 08:57:02 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD9B79569E;
        Tue, 16 Aug 2022 05:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660654587; x=1692190587;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2ihjIlPX6JjmDxqCOX9kWD6/gEsrQbsIvOIDX6hkyik=;
  b=HTc449DYX3N/md+dYtwVUZDWMXZZdUiSt6e4ygZyDNFqBZYtRrKy8nma
   32FJdDUrSY4+mhLczp9Ut0SVUAF3C7fYpPO3+C6C85JGsCqYnXdSChRCB
   +0LbC9ZiS/T9QY6Nd0kJnka9A0UqO95CSc6pqFWjJfeOL8w5+I4jks+X3
   BdrcA+TFcdcBHCRuwt0o2RVLZaVkKq5kAe5rLiL5i+gBTHeBd8eTe0yA6
   nCBmSJCgFTo8Ucb4Asiwc0etOKhlVIXW3vMcS77aCpb4k6OZ1ygPj5RWx
   Z7fHj/sfri9krYjqukKqulLYHALnpKqt9UT4IO5bWb/2wZ16clm1m4H1c
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="293004106"
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="293004106"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 05:56:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="557686019"
Received: from kanliang-dev.jf.intel.com ([10.165.154.102])
  by orsmga003.jf.intel.com with ESMTP; 16 Aug 2022 05:56:27 -0700
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, acme@redhat.com, linux-kernel@vger.kernel.org
Cc:     eranian@google.com, ak@linux.intel.com, namhyung@kernel.org,
        irogers@google.com, Kan Liang <kan.liang@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] perf/x86/lbr: Enable the branch type for the Arch LBR by default
Date:   Tue, 16 Aug 2022 05:56:11 -0700
Message-Id: <20220816125612.2042397-1-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

On the platform with Arch LBR, the HW raw branch type encoding may leak
to the perf tool when the SAVE_TYPE option is not set.

In the intel_pmu_store_lbr(), the HW raw branch type is stored in
lbr_entries[].type. If the SAVE_TYPE option is set, the
lbr_entries[].type will be converted into the generic PERF_BR_* type
in the intel_pmu_lbr_filter() and exposed to the user tools.
But if the SAVE_TYPE option is NOT set by the user, the current perf
kernel doesn't clear the field. The HW raw branch type leaks.

There are two solutions to fix the issue for the Arch LBR.
One is to clear the field if the SAVE_TYPE option is NOT set.
The other solution is to unconditionally convert the branch type and
expose the generic type to the user tools.

The latter is implemented here, because
- The branch type is valuable information. I don't see a case where
  you would not benefit from the branch type. (Stephane Eranian)
- Not having the branch type DOES NOT save any space in the
  branch record (Stephane Eranian)
- The Arch LBR HW can retrieve the common branch types from the
  LBR_INFO. It doesn't require the high overhead SW disassemble.

Fixes: 47125db27e47 ("perf/x86/intel/lbr: Support Architectural LBR")
Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/events/intel/lbr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index a4a36d482b21..247d36825474 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1149,6 +1149,14 @@ static int intel_pmu_setup_hw_lbr_filter(struct perf_event *event)
 
 	if (static_cpu_has(X86_FEATURE_ARCH_LBR)) {
 		reg->config = mask;
+
+		/*
+		 * The Arch LBR HW can retrieve the common branch types
+		 * from the LBR_INFO. It doesn't require the high overhead
+		 * SW disassemble.
+		 * Enable the branch type by default for the Arch LBR.
+		 */
+		reg->reg |= X86_BR_TYPE_SAVE;
 		return 0;
 	}
 
-- 
2.35.1

