Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D96769893B
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 01:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjBPAYS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 19:24:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjBPAYR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 19:24:17 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4644F457D5
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 16:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676507039; x=1708043039;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LcjKVTpoWBOuZ3g30E8RAn5BLgh5Z5qL91JvI7+YNlk=;
  b=YfKBupBMuGwVktBo+7rhXSLTISXjADoH6SJ93hGUCkMTIWF1q2LXrDOt
   ubQK5yDg5nyOdTeKjkcP760jJaBK+I/4z5Fy7ld/YvHtsaRCjzc8cVAk0
   Vo4UxB5rKPQZE3tWI1kNV1L2sbZMKPRwzbZnlGYsMoTdc2DJqqn6yBa4I
   HiOUa0oLe+Wrv8ngluE3roQQozsFQaFq1sPE5L8ObON0tLmXCw3oUw8No
   rr/8zHDqP8sAgY2hSuTUWO6xgqSz2R/QKHLbwOWdrsumYTHFFgJYl0CCq
   fZF8DekHqbJMHQ+praQeEGma5POgEjzHPQgop3Lj+HhwZ0TGcOyzTxw76
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="311945704"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="311945704"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 16:23:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="843928662"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="843928662"
Received: from relo-linux-5.jf.intel.com ([10.165.21.152])
  by orsmga005.jf.intel.com with ESMTP; 15 Feb 2023 16:23:32 -0800
From:   John.C.Harrison@Intel.com
To:     Intel-GFX@Lists.FreeDesktop.Org
Cc:     DRI-Devel@Lists.FreeDesktop.Org,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        John Harrison <John.C.Harrison@Intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: [PATCH v2 2/2] drm/i915: Don't use BAR mappings for ring buffers with LLC
Date:   Wed, 15 Feb 2023 16:22:48 -0800
Message-Id: <20230216002248.1851966-3-John.C.Harrison@Intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230216002248.1851966-1-John.C.Harrison@Intel.com>
References: <20230216002248.1851966-1-John.C.Harrison@Intel.com>
MIME-Version: 1.0
Organization: Intel Corporation (UK) Ltd. - Co. Reg. #1134945 - Pipers Way, Swindon SN3 1RJ
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

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
---
 drivers/gpu/drm/i915/gt/intel_ring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_ring.c b/drivers/gpu/drm/i915/gt/intel_ring.c
index fb1d2595392ed..8675ec8ead353 100644
--- a/drivers/gpu/drm/i915/gt/intel_ring.c
+++ b/drivers/gpu/drm/i915/gt/intel_ring.c
@@ -53,7 +53,7 @@ int intel_ring_pin(struct intel_ring *ring, struct i915_gem_ww_ctx *ww)
 	if (unlikely(ret))
 		goto err_unpin;
 
-	if (i915_vma_is_map_and_fenceable(vma)) {
+	if (i915_vma_is_map_and_fenceable(vma) && !HAS_LLC(vma->vm->i915)) {
 		addr = (void __force *)i915_vma_pin_iomap(vma);
 	} else {
 		int type = i915_coherent_map_type(vma->vm->i915, vma->obj, false);
@@ -98,7 +98,7 @@ void intel_ring_unpin(struct intel_ring *ring)
 		return;
 
 	i915_vma_unset_ggtt_write(vma);
-	if (i915_vma_is_map_and_fenceable(vma))
+	if (i915_vma_is_map_and_fenceable(vma) && !HAS_LLC(vma->vm->i915)) {
 		i915_vma_unpin_iomap(vma);
 	else
 		i915_gem_object_unpin_map(vma->obj);
-- 
2.39.1

