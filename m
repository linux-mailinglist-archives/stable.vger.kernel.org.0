Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C721613A61
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 16:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbiJaPlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 11:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbiJaPlx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 11:41:53 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A236598;
        Mon, 31 Oct 2022 08:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667230912; x=1698766912;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=68I6eDd/kFkeEi9Qy+k/XReDJcYVdmk7+tcPhvWo6hM=;
  b=IABGZubaNIMNPpmEpkjE+cMhDyp51rbMRXjQJa6LVhCZDFmvchoXUssZ
   xSlfUZElDBg7pYSXiHL/79bxCPpKcvPnlOH2+bKHAVrIoAd6r+C8p4IMK
   uJg4PVI+guxb9uCn7N9R0meO+YibIuGryEokykbuwDEPDS9HaxuVdKEAM
   bYkZL5v1zhoiEJRsSdNayNuDtvk/mBOr5xdVtApXXhkok7gkiVcF+dDjy
   DbPXzg9rHIBYSKWG2dSgFiwY5t5wZQrAVIz1cL8VcB4woGNvutdNkdwGE
   rAb2tBVhtkhXXl8tAiS+lepJQj3lDIaCTuMIYqWpa0plBWRbioI61UM9R
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="306546323"
X-IronPort-AV: E=Sophos;i="5.95,228,1661842800"; 
   d="scan'208";a="306546323"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2022 08:41:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="633568904"
X-IronPort-AV: E=Sophos;i="5.95,228,1661842800"; 
   d="scan'208";a="633568904"
Received: from kanliang-dev.jf.intel.com ([10.165.154.102])
  by orsmga002.jf.intel.com with ESMTP; 31 Oct 2022 08:41:23 -0700
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Cc:     eranian@google.com, namhyung@kernel.org, ak@linux.intel.com,
        Kan Liang <kan.liang@linux.intel.com>,
        Jannis Klinkenberg <jannis.klinkenberg@rwth-aachen.de>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] perf/x86/intel: Fix pebs event constraints for ICL
Date:   Mon, 31 Oct 2022 08:41:18 -0700
Message-Id: <20221031154119.571386-1-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,UPPERCASE_50_75 autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

According to the latest event list, update the MEM_INST_RETIRED events
which support the DataLA facility.

Fixes: 6017608936c1 ("perf/x86/intel: Add Icelake support")
Reported-by: Jannis Klinkenberg <jannis.klinkenberg@rwth-aachen.de>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/events/intel/ds.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index f141cc7b8847..26323fea3a65 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -982,8 +982,13 @@ struct event_constraint intel_icl_pebs_event_constraints[] = {
 	INTEL_FLAGS_UEVENT_CONSTRAINT(0x0400, 0x800000000ULL),	/* SLOTS */
 
 	INTEL_PLD_CONSTRAINT(0x1cd, 0xff),			/* MEM_TRANS_RETIRED.LOAD_LATENCY */
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x1d0, 0xf),	/* MEM_INST_RETIRED.LOAD */
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x2d0, 0xf),	/* MEM_INST_RETIRED.STORE */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x11d0, 0xf),	/* MEM_INST_RETIRED.STLB_MISS_LOADS */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x12d0, 0xf),	/* MEM_INST_RETIRED.STLB_MISS_STORES */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x21d0, 0xf),	/* MEM_INST_RETIRED.LOCK_LOADS */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x41d0, 0xf),	/* MEM_INST_RETIRED.SPLIT_LOADS */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x42d0, 0xf),	/* MEM_INST_RETIRED.SPLIT_STORES */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x81d0, 0xf),	/* MEM_INST_RETIRED.ALL_LOADS */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x82d0, 0xf),	/* MEM_INST_RETIRED.ALL_STORES */
 
 	INTEL_FLAGS_EVENT_CONSTRAINT_DATALA_LD_RANGE(0xd1, 0xd4, 0xf), /* MEM_LOAD_*_RETIRED.* */
 
-- 
2.35.1

