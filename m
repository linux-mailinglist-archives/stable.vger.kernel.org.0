Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC33533E0A
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 15:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiEYNkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 09:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244481AbiEYNkH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 09:40:07 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCEE6B7F9;
        Wed, 25 May 2022 06:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653486005; x=1685022005;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6fgOY4yRCD1pn9WhNnWd8R4cc1xx6y0cS6SMBeS9pjU=;
  b=Y1DJzx2Y6GhybEueCWSiqBKPdj+Fpx/m8b8Q02mMvGx3s6wQdRH/TNz6
   alvdmEzTWgZ244VeGo4yY2JmMiid8ZVJmJBAJRKnFudkUp0z2fXkHwWez
   0Mxxo+rzRinjThL1dejZMCVLy8FbHEe6Bzi8TL6jnFeolDfrFK7aH33Vs
   5ufdM3h4ol4JMylGv1TCfjuAcS7bBLJnidHkNvVHO0PD+mtuhKvmvPdEv
   VttLPQaf4s1xAwSARZP0zjt4VmY4mRdBllMvphjl+/w0Ad/GbKNLqpu2d
   IRY3Wc5s4SOVYzL7k7PenyuQiWEWGuw4QxtKoEvFyWuJsOPVsJyBqrkey
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10358"; a="299147798"
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="299147798"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2022 06:40:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="820740846"
Received: from kanliang-dev.jf.intel.com ([10.165.154.102])
  by fmsmga006.fm.intel.com with ESMTP; 25 May 2022 06:40:04 -0700
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Cc:     alexander.shishkin@linux.intel.com, ak@linux.intel.com,
        Kan Liang <kan.liang@linux.intel.com>, stable@vger.kernel.org
Subject: [RESEND PATCH] perf/x86/intel: Update event constraints for ICL
Date:   Wed, 25 May 2022 06:39:52 -0700
Message-Id: <20220525133952.1660658-1-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

