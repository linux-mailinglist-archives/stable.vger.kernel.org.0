Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D4D1E781B
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 10:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbgE2IU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 04:20:26 -0400
Received: from mga18.intel.com ([134.134.136.126]:10357 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725681AbgE2IUZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 May 2020 04:20:25 -0400
IronPort-SDR: 0E6jCDEP29UeCS5iNShEdKuOgSegGqO8RA/KJ5CkRWz86NYi0NadZ7GLJcSbs+J/U7viSBMsQ4
 y6VNUT5rf8tQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 01:20:25 -0700
IronPort-SDR: v5ECh5y5UF2A5R3Z9YvqVBdZ8efVQ7k9j/ROPoNTU9qPtCeHv9EmEZdZhHCgp0SzvkQmBp0J20
 yIjnoiu6hPiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="376641782"
Received: from vtt.iind.intel.com ([10.145.162.194])
  by fmsmga001.fm.intel.com with ESMTP; 29 May 2020 01:20:23 -0700
From:   Prasad Nallani <prasad.nallani@intel.com>
To:     gfx-internal-devel@eclists.intel.com
Cc:     andi.shyti@intel.com, Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        stable@vger.kernel.org, Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 06/23] drm/i915: Actually emit the await_start
Date:   Fri, 29 May 2020 13:47:53 +0530
Message-Id: <20200529081810.10747-7-prasad.nallani@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200529081810.10747-1-prasad.nallani@intel.com>
References: <20200529081810.10747-1-prasad.nallani@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

Fix the inverted test to emit the wait on the end of the previous
request if we /haven't/ already.

Fixes: 6a79d848403d ("drm/i915: Lock signaler timeline while navigating")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.5+
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200305104210.2619967-1-chris@chris-wilson.co.uk
(cherry picked from commit 07e9c59d63df6a1c44c1975c01827ba18b69270a)
---
 drivers/gpu/drm/i915/i915_request.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index d5ab8054d5e5..4143d0c6b343 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -797,7 +797,7 @@ i915_request_await_start(struct i915_request *rq, struct i915_request *signal)
 		return 0;
 
 	err = 0;
-	if (intel_timeline_sync_is_later(i915_request_timeline(rq), fence))
+	if (!intel_timeline_sync_is_later(i915_request_timeline(rq), fence))
 		err = i915_sw_fence_await_dma_fence(&rq->submit,
 						    fence, 0,
 						    I915_FENCE_GFP);
