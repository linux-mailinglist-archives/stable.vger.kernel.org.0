Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5A85907E0
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 23:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236535AbiHKVJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 17:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235097AbiHKVJ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 17:09:27 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DC5A1D34
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 14:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660252112; x=1691788112;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VNi1/5JGKDD2w03JIs2UoFJvnRyEt00JKmBug4Ih8IE=;
  b=nnnlQ6FrFC86rdwD/fw7e7hR32Uc3NTk2EVslYISwYUr+spOIo1mGqFF
   w5mEKgR96hhjjGg/ndjYTH/1Yi7FvhOM/srpXbdf1k/eocdin7vFB1NQx
   LR0l06RmRTWjv+3CHQ1k87HY9xFoJtU/0PLBKCiePLWeQl65BEisbUryn
   MQuj0/6LscERv2kg9GYToXi+LxFr0dbeuKV8xpOvYjZV8m/+WStmI+gfn
   KwG/n1DKxGMxuUzhLYe6Lbj1vMXlU7z49PP4Jq6+OZgsIFNFaYUvd75Bc
   +ekOz9BphtE+Qh5sBy4CsoFVrJ6LQsp1fw7Q43Rky1O5LSFePeavTWfKr
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="353203347"
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="353203347"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 14:08:31 -0700
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="708768758"
Received: from valcore-skull-1.fm.intel.com ([10.1.27.19])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 14:08:31 -0700
From:   Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     dri-devel@lists.freedesktop.org,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Matthew Brost <matthew.brost@intel.com>,
        John Harrison <john.c.harrison@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915/guc: clear stalled request after a reset
Date:   Thu, 11 Aug 2022 14:08:12 -0700
Message-Id: <20220811210812.3239621-1-daniele.ceraolospurio@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the GuC CTs are full and we need to stall the request submission
while waiting for space, we save the stalled request and where the stall
occurred; when the CTs have space again we pick up the request submission
from where we left off.

If a full GT reset occurs, the state of all contexts is cleared and all
non-guilty requests are unsubmitted, therefore we need to restart the
stalled request submission from scratch. To make sure that we do so,
clear the saved request after a reset.

Fixes note: the patch that introduced the bug is in 5.15, but no
officially supported platform had GuC submission enabled by default
in that kernel, so the backport to that particular version (and only
that one) can potentially be skipped.

Fixes: 925dc1cf58ed ("drm/i915/guc: Implement GuC submission tasklet")
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: John Harrison <john.c.harrison@intel.com>
Cc: <stable@vger.kernel.org> # v5.15+
---
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index 0d17da77e787..0d56b615bf78 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -4002,6 +4002,13 @@ static inline void guc_init_lrc_mapping(struct intel_guc *guc)
 	/* make sure all descriptors are clean... */
 	xa_destroy(&guc->context_lookup);
 
+	/*
+	 * A reset might have occurred while we had a pending stalled request,
+	 * so make sure we clean that up.
+	 */
+	guc->stalled_request = NULL;
+	guc->submission_stall_reason = STALL_NONE;
+
 	/*
 	 * Some contexts might have been pinned before we enabled GuC
 	 * submission, so we need to add them to the GuC bookeeping.
-- 
2.25.1

