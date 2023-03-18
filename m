Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38A7E6BF6F0
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 01:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjCRAby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 20:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjCRAbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 20:31:53 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83ED83E083
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 17:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679099511; x=1710635511;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dUbb0D8nIGbiK2hrj1ZUu/Cioymyc/u5PLY952ZNUAg=;
  b=JiddYYUHr/VzaGg/4mV0rLpDQtTdFo8Dg7eipwNTIyKiksChfWJyoNU9
   3mh+L/fyqv+eVnSPLkr48yttBHYz8dlo1ubCs2W7atqXpycwpnEcTWF0r
   fjrXYXGWKRIkOFsn+ydHtCIU0mj6NggNxHiOX4QVrUysV+ypsEvmJwRkm
   WcAt5nw+BSjRANrbqoUv1rIYtngAVS9VIxSIiLIQKa9zK0Q9AVJ8FZ7/Z
   U+NcCJYynKU/u/Cs6WdCBfC5/mv/Pe1MYITt79qOPY0fsxBGPzgTdBa9W
   xhGWvtdE74k8DzUPhTBBohEYsW5R81mjEc5eYoiVMHmTJoBjLe4bJFqwy
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="322239321"
X-IronPort-AV: E=Sophos;i="5.98,270,1673942400"; 
   d="scan'208";a="322239321"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 17:31:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="630467392"
X-IronPort-AV: E=Sophos;i="5.98,270,1673942400"; 
   d="scan'208";a="630467392"
Received: from relo-linux-5.jf.intel.com ([10.165.21.152])
  by orsmga003.jf.intel.com with ESMTP; 17 Mar 2023 17:31:49 -0700
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
Subject: [PATCH 5.4.y] drm/i915: Don't use stolen memory for ring buffers with LLC
Date:   Fri, 17 Mar 2023 17:30:57 -0700
Message-Id: <20230318003057.689847-1-John.C.Harrison@Intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <167820538475156@kroah.com>
References: <167820538475156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/gpu/drm/i915/gt/intel_ringbuffer.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_ringbuffer.c b/drivers/gpu/drm/i915/gt/intel_ringbuffer.c
index 808269b2108f..125f7bb67bee 100644
--- a/drivers/gpu/drm/i915/gt/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/gt/intel_ringbuffer.c
@@ -1268,10 +1268,11 @@ static struct i915_vma *create_ring_vma(struct i915_ggtt *ggtt, int size)
 {
 	struct i915_address_space *vm = &ggtt->vm;
 	struct drm_i915_private *i915 = vm->i915;
-	struct drm_i915_gem_object *obj;
+	struct drm_i915_gem_object *obj = NULL;
 	struct i915_vma *vma;
 
-	obj = i915_gem_object_create_stolen(i915, size);
+	if (!HAS_LLC(i915))
+		obj = i915_gem_object_create_stolen(i915, size);
 	if (!obj)
 		obj = i915_gem_object_create_internal(i915, size);
 	if (IS_ERR(obj))
-- 
2.39.1

