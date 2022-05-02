Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55274517885
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 22:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347801AbiEBUwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 16:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiEBUwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 16:52:34 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C8660FD;
        Mon,  2 May 2022 13:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651524544; x=1683060544;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6fgOY4yRCD1pn9WhNnWd8R4cc1xx6y0cS6SMBeS9pjU=;
  b=ZoSBuk+ikOWl81WIdF8Ib0iM6DShTEN0VcF+EI26MoT2TXvuvi0LZXoA
   FgtCijuS0ecHYbycfrOgmssrn8yTYUn/d/JL72rPG2o/LEzf1NpI20SKT
   NZucph9Gn297DEZ/Z8gyLgUCDMXzcjqHvzZ1Ar9z+x4zhmt7hMTA0ynqY
   iWcmgwq0Ik0Az3LizBjWs3XBgmN2tzsoTTMf7fm0Ypn0jYufDqciSy8/T
   o4FOhfNHc9NzUA7UiAZfBjvsWBePTUtSFcA60ghMY8Di3+WwXsqbBdMYh
   ZakdjAJOBE1UQWuzePNm0EylawI4oPXdqG4XCXeHO5XBdIf8LcY29vVNK
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="267200832"
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="267200832"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 13:49:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="733617541"
Received: from kanliang-dev.jf.intel.com ([10.165.154.102])
  by orsmga005.jf.intel.com with ESMTP; 02 May 2022 13:49:02 -0700
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Cc:     ak@linux.intel.com, Kan Liang <kan.liang@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] perf/x86/intel: Update event constraints for ICL
Date:   Mon,  2 May 2022 13:48:49 -0700
Message-Id: <20220502204849.928128-1-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

According to the latest event list, the event encoding 0x55
INST_DECODED.DECODERS and 0x56 UOPS_DECODED.DEC0 are only available on
the first 4 counters. Add them into the event constraints table.

Fixes: 6017608936c1 ("perf/x86/intel: Add Icelake support")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/events/intel/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index ed70d04e2d62..80966acac525 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -276,7 +276,7 @@ static struct event_constraint intel_icl_event_constraints[] = {
 	INTEL_EVENT_CONSTRAINT_RANGE(0x03, 0x0a, 0xf),
 	INTEL_EVENT_CONSTRAINT_RANGE(0x1f, 0x28, 0xf),
 	INTEL_EVENT_CONSTRAINT(0x32, 0xf),	/* SW_PREFETCH_ACCESS.* */
-	INTEL_EVENT_CONSTRAINT_RANGE(0x48, 0x54, 0xf),
+	INTEL_EVENT_CONSTRAINT_RANGE(0x48, 0x56, 0xf),
 	INTEL_EVENT_CONSTRAINT_RANGE(0x60, 0x8b, 0xf),
 	INTEL_UEVENT_CONSTRAINT(0x04a3, 0xff),  /* CYCLE_ACTIVITY.STALLS_TOTAL */
 	INTEL_UEVENT_CONSTRAINT(0x10a3, 0xff),  /* CYCLE_ACTIVITY.CYCLES_MEM_ANY */
-- 
2.35.1

