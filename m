Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C9C6BF6D4
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 01:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjCRAQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 20:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjCRAQx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 20:16:53 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8F9D0E51
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 17:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679098605; x=1710634605;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+ONo8XIc0U1AZTiCJ9+NmtvbnONr4XN5ITIYV9FotKU=;
  b=EuJMgq3M3jByuthcTHi1IVEZDsdbK7JyPe8vEFNHQ+cFaAzd2jkRnRKo
   up/h+pn6wBUloztppkRY1dIoBBQiYjT/1zEC1DGtws5FF5ku0jomu1tbY
   qGVNJwjWnJ9fBZ46bbRFx6ShTgCAX4jLM9D8p3RT0ZVGi8w1wEj0FCRp4
   cHOU28PDh/J+RUeHWC3tjbwU54Ualr1kijj18rxQ+atsnLVFTkkHRICoj
   UshOVILLXHHRuLBPhvdEIq3sQtbJa3srRJD5/PSM4+KWVgcLKS/6OA5ew
   uZyWvfNYTtl1kp9e76VzmHnG3yAWc9eEgElCjaspt5NIn3v+RKeU0tGP8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="337095153"
X-IronPort-AV: E=Sophos;i="5.98,270,1673942400"; 
   d="scan'208";a="337095153"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 17:16:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="680470618"
X-IronPort-AV: E=Sophos;i="5.98,270,1673942400"; 
   d="scan'208";a="680470618"
Received: from relo-linux-5.jf.intel.com ([10.165.21.152])
  by orsmga002.jf.intel.com with ESMTP; 17 Mar 2023 17:16:44 -0700
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
Subject: [PATCH 4.19.y] drm/i915: Don't use stolen memory for ring buffers with LLC
Date:   Fri, 17 Mar 2023 17:15:53 -0700
Message-Id: <20230318001553.564934-1-John.C.Harrison@Intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <16782053932851@kroah.com>
References: <16782053932851@kroah.com>
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
 drivers/gpu/drm/i915/intel_ringbuffer.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 979d130b24c4..16eec72f0fed 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -1132,10 +1132,11 @@ static struct i915_vma *
 intel_ring_create_vma(struct drm_i915_private *dev_priv, int size)
 {
 	struct i915_address_space *vm = &dev_priv->ggtt.vm;
-	struct drm_i915_gem_object *obj;
+	struct drm_i915_gem_object *obj = NULL;
 	struct i915_vma *vma;
 
-	obj = i915_gem_object_create_stolen(dev_priv, size);
+	if (!HAS_LLC(dev_priv))
+		obj = i915_gem_object_create_stolen(dev_priv, size);
 	if (!obj)
 		obj = i915_gem_object_create_internal(dev_priv, size);
 	if (IS_ERR(obj))
-- 
2.39.1

