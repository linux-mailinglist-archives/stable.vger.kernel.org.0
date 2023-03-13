Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB07C6B740F
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 11:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbjCMKbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 06:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbjCMKax (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 06:30:53 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC962FCC5
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 03:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678703452; x=1710239452;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sMk0eO3EmOgEh9qjVHHQT+6MoVaryNzsDDU8Ds0R08s=;
  b=CT1RGNj4v+W2qlcB58wwcKz6/W6LWJFSOH2Eq2PoGCTFc/6YFRW67Oeo
   REi0U1+eqiOHnXpxLx/kEfdcK/JUR0iDz3/AgJjErnYNmQnrsuBonwqCH
   vlmbGZkYJax+e7jIE+rfQl2R/27+EaWJjZprWkpN78DZ6Kr8wjeMxmIUV
   qGFs4akaFjqfM2i8Vkvi6naYbdoiiO/xMKzPZBBu3fhBybvK+vcM44f2m
   m+Pe7uBFU0h6PyYFauZodBe1OY71+NhYx9Hmip1C8ZmRTgdofpiw+M+wK
   71Y/TC54jWSUaVWjkQgUh8DSQayZqRLh9MMLt8lmuR+lCHAILXE8k7Kwa
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="325469781"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="325469781"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 03:30:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="708835892"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="708835892"
Received: from nirmoyda-desk.igk.intel.com ([10.102.42.231])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 03:30:50 -0700
From:   Nirmoy Das <nirmoy.das@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Nirmoy Das <nirmoy.das@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] drm/i915/active: Fix missing debug object activation
Date:   Mon, 13 Mar 2023 11:30:45 +0100
Message-Id: <20230313103045.8906-1-nirmoy.das@intel.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Deutschland GmbH, Registered Address: Am Campeon 10, 85579 Neubiberg, Germany, Commercial Register: Amtsgericht Muenchen HRB 186928 
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

debug_active_activate() expected ref->count to be zero
which is not true anymore as __i915_active_activate() calls
debug_active_activate() after incrementing the count.

v2: No need to check for "ref->count == 1" as __i915_active_activate()
already make sure of that.

Fixes: 04240e30ed06 ("drm/i915: Skip taking acquire mutex for no ref->active callback")
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@intel.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: intel-gfx@lists.freedesktop.org
Cc: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
---
 drivers/gpu/drm/i915/i915_active.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_active.c b/drivers/gpu/drm/i915/i915_active.c
index a9fea115f2d2..8ef93889061a 100644
--- a/drivers/gpu/drm/i915/i915_active.c
+++ b/drivers/gpu/drm/i915/i915_active.c
@@ -92,8 +92,7 @@ static void debug_active_init(struct i915_active *ref)
 static void debug_active_activate(struct i915_active *ref)
 {
 	lockdep_assert_held(&ref->tree_lock);
-	if (!atomic_read(&ref->count)) /* before the first inc */
-		debug_object_activate(ref, &active_debug_desc);
+	debug_object_activate(ref, &active_debug_desc);
 }
 
 static void debug_active_deactivate(struct i915_active *ref)
-- 
2.39.0

