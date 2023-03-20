Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2E966C1864
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbjCTPXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232784AbjCTPXd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:23:33 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67F030E93
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679325417; x=1710861417;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wEJa0GP3/V393lo37hu+c7/l6uvFaV1Uh+P3Q5auMJA=;
  b=SZmyNwBgu/AOIQsZ5Q84UFGVWn6ifryosb4iKcnofywMpXMebG78HdIu
   2HdhaUz74ja+0kPok9DrFYS/Cw29R24BpLYjGourp8J4kLw+4sPrQ1vA0
   9QovqTVfjJ2QJzE/zD2OaHtBEAmtZzg97xmFSNQln0Jv9WS77sD1wVigc
   dGVCfCgWWF5lhTYePRNF8zCnn16/+zaSxZjDpJ6TX6uS0UwVeDrm7N+XA
   cakkVg+rwIgVBvaX8gepPn9D1Ppy8o/n40Od7ToX7g8+hi1xypaM+vHVZ
   /GfhFtZ16gY2im/+zkfvYJTYgx7ImJMJSoU/vbFgFgRHLe9KthK4Uf4Ga
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="322529500"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="322529500"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 08:14:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="770231521"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="770231521"
Received: from sbrieffi-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.213.210.83])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 08:14:29 -0700
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
To:     Intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc:     Tvrtko Ursulin <tvrtko.ursulin@intel.com>, stable@vger.kernel.org
Subject: [PATCH] drm/i915: Fix context runtime accounting
Date:   Mon, 20 Mar 2023 15:14:23 +0000
Message-Id: <20230320151423.1708436-1-tvrtko.ursulin@linux.intel.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

When considering whether to mark one context as stopped and another as
started we need to look at whether the previous and new _contexts_ are
different and not just requests. Otherwise the software tracked context
start time was incorrectly updated to the most recent lite-restore time-
stamp, which was in some cases resulting in active time going backward,
until the context switch (typically the hearbeat pulse) would synchronise
with the hardware tracked context runtime. Easiest use case to observe
this behaviour was with a full screen clients with close to 100% engine
load.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Fixes: bb6287cb1886 ("drm/i915: Track context current active time")
Cc: <stable@vger.kernel.org> # v5.19+
---
 drivers/gpu/drm/i915/gt/intel_execlists_submission.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
index 1bbe6708d0a7..750326434677 100644
--- a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
+++ b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
@@ -2018,6 +2018,8 @@ process_csb(struct intel_engine_cs *engine, struct i915_request **inactive)
 	 * inspecting the queue to see if we need to resumbit.
 	 */
 	if (*prev != *execlists->active) { /* elide lite-restores */
+		struct intel_context *prev_ce = NULL, *active_ce = NULL;
+
 		/*
 		 * Note the inherent discrepancy between the HW runtime,
 		 * recorded as part of the context switch, and the CPU
@@ -2029,9 +2031,15 @@ process_csb(struct intel_engine_cs *engine, struct i915_request **inactive)
 		 * and correct overselves later when updating from HW.
 		 */
 		if (*prev)
-			lrc_runtime_stop((*prev)->context);
+			prev_ce = (*prev)->context;
 		if (*execlists->active)
-			lrc_runtime_start((*execlists->active)->context);
+			active_ce = (*execlists->active)->context;
+		if (prev_ce != active_ce) {
+			if (prev_ce)
+				lrc_runtime_stop(prev_ce);
+			if (active_ce)
+				lrc_runtime_start(active_ce);
+		}
 		new_timeslice(execlists);
 	}
 
-- 
2.37.2

