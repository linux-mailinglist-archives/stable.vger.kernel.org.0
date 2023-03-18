Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83E836BF70B
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 01:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjCRAr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 20:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCRAr5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 20:47:57 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220045D89D
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 17:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679100476; x=1710636476;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Msi1NikWIi16Ei2S1R8vvyEju2cIcpebbUpp3VinUKQ=;
  b=iy3N+XDFE/uFOeIMR8PiHsplVQUYkB4opZ0oAJKcVnDgwpZvt2hXKe7+
   PaQErs0Qk5WawVeO8Xv/NndM2WHJrb86iO5HZGa3rtiAZdEiC9tiRBbiR
   X6gwp4n4BOvme/d4VWU8LW3740az7nWyHQCTXaEwG+yGPfUYXciKpHb3Q
   iiy/skVs+B7XOocF8tHtOh6PPhd44dd6ESUAGB84SGCn/46HVCAZhqCoA
   3C85it0GbLP6tzAn30mIdo7POmUJ4M+se2JCoekAjqczAXCIxgKXj3fyA
   gEsxcjBWqrHrh48vpEwmyQ5Pz3iZeAhccOho/1RydAnumDsfipltiGrlI
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="318792386"
X-IronPort-AV: E=Sophos;i="5.98,270,1673942400"; 
   d="scan'208";a="318792386"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 17:47:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="790942111"
X-IronPort-AV: E=Sophos;i="5.98,270,1673942400"; 
   d="scan'208";a="790942111"
Received: from relo-linux-5.jf.intel.com ([10.165.21.152])
  by fmsmga002.fm.intel.com with ESMTP; 17 Mar 2023 17:47:50 -0700
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
Subject: [PATCH 5.10.y] drm/i915: Don't use stolen memory for ring buffers with LLC
Date:   Fri, 17 Mar 2023 17:46:59 -0700
Message-Id: <20230318004659.817361-1-John.C.Harrison@Intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <167820537619158@kroah.com>
References: <167820537619158@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Harrison <John.C.Harrison@Intel.com>

Direction from hardware is that stolen memory should never be used for
ring buffer allocations on platforms with LLC. There are too many
caching pitfalls due to the way stolen memory accesses are routed. So
it is safest to just not use it.

Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Fixes: c58b735fc762 ("drm/i915: Allocate rings from stolen")
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: intel-gfx@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v4.9+
Tested-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230216011101.1909009-2-John.C.Harrison@Intel.com
(cherry picked from commit f54c1f6c697c4297f7ed94283c184acc338a5cf8)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 690e0ec8e63da9a29b39fedc6ed5da09c7c82651)
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
---
 drivers/gpu/drm/i915/gt/intel_ring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_ring.c b/drivers/gpu/drm/i915/gt/intel_ring.c
index 69b2e5509d67..de67b2745258 100644
--- a/drivers/gpu/drm/i915/gt/intel_ring.c
+++ b/drivers/gpu/drm/i915/gt/intel_ring.c
@@ -108,7 +108,7 @@ static struct i915_vma *create_ring_vma(struct i915_ggtt *ggtt, int size)
 	struct i915_vma *vma;
 
 	obj = ERR_PTR(-ENODEV);
-	if (i915_ggtt_has_aperture(ggtt))
+	if (i915_ggtt_has_aperture(ggtt) && !HAS_LLC(i915))
 		obj = i915_gem_object_create_stolen(i915, size);
 	if (IS_ERR(obj))
 		obj = i915_gem_object_create_internal(i915, size);
-- 
2.39.1

