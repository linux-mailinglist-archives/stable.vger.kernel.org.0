Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F21D4598BD0
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 20:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345292AbiHRSpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 14:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344894AbiHRSow (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 14:44:52 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBFD5006A;
        Thu, 18 Aug 2022 11:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660848291; x=1692384291;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PcJSuTWQKI6vhkJPHzCTeOrD3iyfAi8gQ3nIEL/zRHc=;
  b=GBuKz0nnp4X2cZcUuiOBgaB48LTG73L6vcR7qN6NRD4RCvLCqxyNyq8G
   II6OFqNrLAdBIx/XH3uZrXzDG7fLieEOXgkfBqqLsD/brrEW/PAoZz9fI
   NPqGIZl9sAC3xBvcuw3wVllAcuNrDCNJhMAG8v5DsqsnRUbuAukbJTH/A
   sYVi/zXq1p1uOdnZSwGO6gnwbuAUlDbVQ4x93xUAt8GSrDTbppZB4EHNC
   TyrdFpiUhANwP+fHV63ZWjBhn80KuqO7hzwab1uF0MERvawcndPiKry+o
   mpY2GGzDh8aDeFnnubWAfJkhZMLQJXa+DAEDLFQW+tQ8lLdnv87k8K9Ok
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="279804943"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="279804943"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 11:44:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="853514448"
Received: from kanliang-dev.jf.intel.com ([10.165.154.102])
  by fmsmga006.fm.intel.com with ESMTP; 18 Aug 2022 11:44:50 -0700
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, acme@redhat.com, linux-kernel@vger.kernel.org
Cc:     alexander.shishkin@linux.intel.com, ak@linux.intel.com,
        Kan Liang <kan.liang@linux.intel.com>,
        Ammy Yi <ammy.yi@intel.com>, stable@vger.kernel.org
Subject: [PATCH] perf/x86/intel: Fix pebs event constraints for ADL
Date:   Thu, 18 Aug 2022 11:44:29 -0700
Message-Id: <20220818184429.2355857-1-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

According to the latest event list, the LOAD_LATENCY PEBS event only
works on the GP counter 0 and 1 for ADL and RPL.

Update the pebs event constraints table.

Fixes: f83d2f91d259 ("perf/x86/intel: Add Alder Lake Hybrid support")
Reported-by: Ammy Yi <ammy.yi@intel.com> 
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/events/intel/ds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 629a18403e35..578adf861b98 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -822,7 +822,7 @@ struct event_constraint intel_glm_pebs_event_constraints[] = {
 
 struct event_constraint intel_grt_pebs_event_constraints[] = {
 	/* Allow all events as PEBS with no flags */
-	INTEL_HYBRID_LAT_CONSTRAINT(0x5d0, 0xf),
+	INTEL_HYBRID_LAT_CONSTRAINT(0x5d0, 0x3),
 	INTEL_HYBRID_LAT_CONSTRAINT(0x6d0, 0xf),
 	EVENT_CONSTRAINT_END
 };
-- 
2.35.1

