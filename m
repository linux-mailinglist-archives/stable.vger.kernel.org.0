Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D524351AD05
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 20:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377101AbiEDSkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 14:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377353AbiEDSkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 14:40:24 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD9B1116
        for <stable@vger.kernel.org>; Wed,  4 May 2022 11:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651689323; x=1683225323;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EcxUBLseJ+fDiO5lzzM9N1CEV6AEVIFj97aU828rnv0=;
  b=Gbura0g1uO/3MaBVvFkV6z9P91COgGqDhrTNu6uulw+7hazaFlQSqg6a
   aYLB3QEQBQaIE/CNp0ImkV3eZA5inMtXv1kG+ECM7Oc4/GSMKlqHDILc2
   oRPuLpMGPAkWgiDpTajAoqL5CsBsfVA3mXdMhzqOnzE1mIrb+bIj3gkCO
   cyJGya8PF8gnMviVwJWrCf1L/cHE24Y2wJ/Wi8E9h2t2aj0E1crKFQO8e
   zfxNiJSY31kO0CTjphqhh0s2wV+9HTV3gKz1QCAjMNlsYMjS8tqr5Ywcj
   5E1K8XGDyi3tXbFPVPXe78/t0gT8gM7QdHNnwVFR3IeCl0Amv0XScM5tM
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="354297191"
X-IronPort-AV: E=Sophos;i="5.91,198,1647327600"; 
   d="scan'208";a="354297191"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 11:34:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,198,1647327600"; 
   d="scan'208";a="708587382"
Received: from aalteres-desk.fm.intel.com ([10.80.57.53])
  by fmsmga001.fm.intel.com with ESMTP; 04 May 2022 11:34:13 -0700
From:   Alan Previn <alan.previn.teres.alexis@intel.com>
To:     gfx-internal-devel@eclists.intel.com
Cc:     Alan Previn <alan.previn.teres.alexis@intel.com>,
        Jason Ekstrand <jason@jlekstrand.net>,
        Marcin Slusarz <marcin.slusarz@intel.com>,
        stable@vger.kernel.org, Jason Ekstrand <jason.ekstrand@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jon Bloomfield <jon.bloomfield@intel.com>
Subject: [PATCH 1/2] Revert "drm/i915: Propagate errors on awaiting already signaled fences"
Date:   Wed,  4 May 2022 11:34:09 -0700
Message-Id: <20220504183410.1283944-2-alan.previn.teres.alexis@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220504183410.1283944-1-alan.previn.teres.alexis@intel.com>
References: <20220504183410.1283944-1-alan.previn.teres.alexis@intel.com>
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

From: Jason Ekstrand <jason@jlekstrand.net>

This reverts commit 9e31c1fe45d555a948ff66f1f0e3fe1f83ca63f7.  Ever
since that commit, we've been having issues where a hang in one client
can propagate to another.  In particular, a hang in an app can propagate
to the X server which causes the whole desktop to lock up.

Error propagation along fences sound like a good idea, but as your bug
shows, surprising consequences, since propagating errors across security
boundaries is not a good thing.

What we do have is track the hangs on the ctx, and report information to
userspace using RESET_STATS. That's how arb_robustness works. Also, if my
understanding is still correct, the EIO from execbuf is when your context
is banned (because not recoverable or too many hangs). And in all these
cases it's up to userspace to figure out what is all impacted and should
be reported to the application, that's not on the kernel to guess and
automatically propagate.

What's more, we're also building more features on top of ctx error
reporting with RESET_STATS ioctl: Encrypted buffers use the same, and the
userspace fence wait also relies on that mechanism. So it is the path
going forward for reporting gpu hangs and resets to userspace.

So all together that's why I think we should just bury this idea again as
not quite the direction we want to go to, hence why I think the revert is
the right option here.

For backporters: Please note that you _must_ have a backport of
https://lore.kernel.org/dri-devel/20210602164149.391653-2-jason@jlekstrand.net/
for otherwise backporting just this patch opens up a security bug.

v2: Augment commit message. Also restore Jason's sob that I
accidentally lost.

v3: Add a note for backporters

Signed-off-by: Jason Ekstrand <jason@jlekstrand.net>
Reported-by: Marcin Slusarz <marcin.slusarz@intel.com>
Cc: <stable@vger.kernel.org> # v5.6+
Cc: Jason Ekstrand <jason.ekstrand@intel.com>
Cc: Marcin Slusarz <marcin.slusarz@intel.com>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/3080
Fixes: 9e31c1fe45d5 ("drm/i915: Propagate errors on awaiting already signaled fences")
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Jon Bloomfield <jon.bloomfield@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210714193419.1459723-3-jason@jlekstrand.net
(cherry picked from commit 93a2711cddd5760e2f0f901817d71c93183c3b87)
---
 drivers/gpu/drm/i915/i915_request.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index 8e310b8dd91c..6a5070399c04 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -1297,10 +1297,8 @@ i915_request_await_execution(struct i915_request *rq,
 
 	do {
 		fence = *child++;
-		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
-			i915_sw_fence_set_error_once(&rq->submit, fence->error);
+		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
 			continue;
-		}
 
 		if (fence->context == rq->fence.context)
 			continue;
@@ -1398,10 +1396,8 @@ i915_request_await_dma_fence(struct i915_request *rq, struct dma_fence *fence)
 
 	do {
 		fence = *child++;
-		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
-			i915_sw_fence_set_error_once(&rq->submit, fence->error);
+		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
 			continue;
-		}
 
 		/*
 		 * Requests on the same timeline are explicitly ordered, along
