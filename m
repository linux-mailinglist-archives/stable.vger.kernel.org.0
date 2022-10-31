Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24AF8613A62
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 16:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbiJaPl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 11:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiJaPly (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 11:41:54 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA65811A33;
        Mon, 31 Oct 2022 08:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667230913; x=1698766913;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fTYm3rkOP9dWwuKYIR/Bm8FEaxFo518yuML15faWha4=;
  b=QF0DhHpJHJzafuYXn9rF2lOpFwvOnonihkt/Sbak8fms9lMLbSNsBLIi
   6GYZF0a4KAsNt94LAw+VmvI4L7VuYtUgRG8EgT9sNjyd03HzG2FwQ2all
   m2RWPQtvCgdlXeoDw46Htm8EtRx5sZneh7DWGwtDRDQqrkn0Fg/7yeQLp
   B0JYgFix52oM9gjaxtKTikrCPWWpsk6LOl144nWlyJQcSD4sREqsZ2Iwn
   v10Q4wGOM7YOCOqKBuZjh720wOGGqI4jNeA/HYu88Zsa9v6Q26u675Gm/
   sRbvHy+5nVjrXoEuSLdRySpV+yMD2KaK93xcbmBKsu86qcOIaAAztLDau
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="306546328"
X-IronPort-AV: E=Sophos;i="5.95,228,1661842800"; 
   d="scan'208";a="306546328"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2022 08:41:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="633568906"
X-IronPort-AV: E=Sophos;i="5.95,228,1661842800"; 
   d="scan'208";a="633568906"
Received: from kanliang-dev.jf.intel.com ([10.165.154.102])
  by orsmga002.jf.intel.com with ESMTP; 31 Oct 2022 08:41:24 -0700
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Cc:     eranian@google.com, namhyung@kernel.org, ak@linux.intel.com,
        Kan Liang <kan.liang@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH 2/2] perf/x86/intel: Fix pebs event constraints for SPR
Date:   Mon, 31 Oct 2022 08:41:19 -0700
Message-Id: <20221031154119.571386-2-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221031154119.571386-1-kan.liang@linux.intel.com>
References: <20221031154119.571386-1-kan.liang@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

According to the latest event list, update the MEM_INST_RETIRED events
which support the DataLA facility for SPR.

Fixes: 61b985e3e775 ("perf/x86/intel: Add perf core PMU support for Sapphire Rapids")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/events/intel/ds.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 26323fea3a65..88e58b6ee73c 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -1009,8 +1009,13 @@ struct event_constraint intel_spr_pebs_event_constraints[] = {
 	INTEL_FLAGS_EVENT_CONSTRAINT(0xc0, 0xfe),
 	INTEL_PLD_CONSTRAINT(0x1cd, 0xfe),
 	INTEL_PSD_CONSTRAINT(0x2cd, 0x1),
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x1d0, 0xf),
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x2d0, 0xf),
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x11d0, 0xf),	/* MEM_INST_RETIRED.STLB_MISS_LOADS */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x12d0, 0xf),	/* MEM_INST_RETIRED.STLB_MISS_STORES */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x21d0, 0xf),	/* MEM_INST_RETIRED.LOCK_LOADS */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x41d0, 0xf),	/* MEM_INST_RETIRED.SPLIT_LOADS */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x42d0, 0xf),	/* MEM_INST_RETIRED.SPLIT_STORES */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x81d0, 0xf),	/* MEM_INST_RETIRED.ALL_LOADS */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x82d0, 0xf),	/* MEM_INST_RETIRED.ALL_STORES */
 
 	INTEL_FLAGS_EVENT_CONSTRAINT_DATALA_LD_RANGE(0xd1, 0xd4, 0xf),
 
-- 
2.35.1

