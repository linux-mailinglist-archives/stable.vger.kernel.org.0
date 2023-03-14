Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B31936B8876
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 03:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjCNCX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 22:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjCNCXZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 22:23:25 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F96943BC
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 19:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678760589; x=1710296589;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ol/yRHgVSLLsAyoppnxVwKbo+WcKNJSFWGI6ODNz2BA=;
  b=Xqe5OdfNBqjqWVNubv7llugBQ25S9PY+mN18smobCdjhPHMw6C7qbBWC
   jCO5cy0nO+VnB/ej22Knz4Y/L0ouzM8NN76ZRfIy/7k/hogEXjQIUi2N/
   eY+ygPoPVlA1/jNRdsblf8gIZy4/ixga38xA+2MTwPcdrSV9og1ri+t4i
   0MKztqIbIcNszPyO3cu8laTi/mUC9zcrLHb3lVQUYvFmdaB3zcimo9n2P
   0PrczSJbJ0bcCKo1fYkSsVNCgTSt2rcZVi3Zp8rQPWersxvyLwn+BWOJ9
   14D25bDbYNLk9nkSgDhmnS25WzO9vsKi/wZw8DloXXVv3oVtYW728bBu8
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="325674335"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="325674335"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 19:23:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="822185289"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="822185289"
Received: from relo-linux-5.jf.intel.com ([10.165.21.152])
  by fmsmga001.fm.intel.com with ESMTP; 13 Mar 2023 19:23:08 -0700
From:   John.C.Harrison@Intel.com
To:     stable@vger.kernel.org
Cc:     John Harrison <John.C.Harrison@Intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        intel-gfx@lists.freedesktop.org,
        =?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.4.y] drm/i915: Don't use BAR mappings for ring buffers with LLC
Date:   Mon, 13 Mar 2023 19:22:11 -0700
Message-Id: <20230314022211.1393031-1-John.C.Harrison@Intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <167820543971229@kroah.com>
References: <167820543971229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Harrison <John.C.Harrison@Intel.com>

Direction from hardware is that ring buffers should never be mapped
via the BAR on systems with LLC. There are too many caching pitfalls
due to the way BAR accesses are routed. So it is safest to just not
use it.

Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Fixes: 9d80841ea4c9 ("drm/i915: Allow ringbuffers to be bound anywhere")
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: intel-gfx@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v4.9+
Tested-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230216011101.1909009-3-John.C.Harrison@Intel.com
(cherry picked from commit 65c08339db1ada87afd6cfe7db8e60bb4851d919)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 85636167e3206c3fbd52254fc432991cc4e90194)
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
---
 drivers/gpu/drm/i915/gt/intel_ringbuffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_ringbuffer.c b/drivers/gpu/drm/i915/gt/intel_ringbuffer.c
index eee9fcbe0434..808269b2108f 100644
--- a/drivers/gpu/drm/i915/gt/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/gt/intel_ringbuffer.c
@@ -1208,7 +1208,7 @@ int intel_ring_pin(struct intel_ring *ring)
 	if (unlikely(ret))
 		goto err_unpin;
 
-	if (i915_vma_is_map_and_fenceable(vma))
+	if (i915_vma_is_map_and_fenceable(vma) && !HAS_LLC(vma->vm->i915))
 		addr = (void __force *)i915_vma_pin_iomap(vma);
 	else
 		addr = i915_gem_object_pin_map(vma->obj,
@@ -1252,7 +1252,7 @@ void intel_ring_unpin(struct intel_ring *ring)
 	intel_ring_reset(ring, ring->emit);
 
 	i915_vma_unset_ggtt_write(vma);
-	if (i915_vma_is_map_and_fenceable(vma))
+	if (i915_vma_is_map_and_fenceable(vma) && !HAS_LLC(vma->vm->i915))
 		i915_vma_unpin_iomap(vma);
 	else
 		i915_gem_object_unpin_map(vma->obj);
-- 
2.39.1

