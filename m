Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F1F6B7686
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 12:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjCMLsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 07:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbjCMLso (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 07:48:44 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5F317CCB
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 04:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678708092; x=1710244092;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1bKhz2APsQ7pRCrgFQeTk+KExMU/Pn7W1lroGbmk+Pc=;
  b=bo+UV3l07nu4lfaGXdkLZ2B6GKYLfpkamY/zX6hh30GXsvutQ4ftjJC6
   a2df9FwL9tiCrwqDuUMknO990ZvGXwAaqOB6GU96ejxtNXF5zDmdvG21e
   m6Dbn/FF0iRLBdnme2mu2DCQ+8+E1GsIUB/FPpPe6sJwmDfHSGixrQsfq
   MBbUus8LhlvvBRuSgM3jV1QJE3iL7xFjz4/91GgaOmAxR5Nyb231tr/YL
   a2c1vunWDuOC81fwRyyLgjiwV5a5/suxswbtGgqnUeT3iIJviG10eZbAt
   zJlnNz3QSxN3RVDw0ZyETUfe/GmfuyvUmTK4Fblq/W8MnSHZhJjLe4y/W
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="337146654"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="337146654"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 04:46:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="681009991"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="681009991"
Received: from nirmoyda-desk.igk.intel.com ([10.102.42.231])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 04:46:23 -0700
From:   Nirmoy Das <nirmoy.das@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Nirmoy Das <nirmoy.das@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915/active: Fix missing debug object activation
Date:   Mon, 13 Mar 2023 12:46:13 +0100
Message-Id: <20230313114613.9874-1-nirmoy.das@intel.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230313103045.8906-1-nirmoy.das@intel.com>
References: <20230313103045.8906-1-nirmoy.das@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Deutschland GmbH, Registered Address: Am Campeon 10, 85579 Neubiberg, Germany, Commercial Register: Amtsgericht Muenchen HRB 186928 
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

References: https://gitlab.freedesktop.org/drm/intel/-/issues/6733
Fixes: 04240e30ed06 ("drm/i915: Skip taking acquire mutex for no ref->active callback")
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@intel.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: intel-gfx@lists.freedesktop.org
Cc: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
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

