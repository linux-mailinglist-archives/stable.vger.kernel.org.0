Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6747A6DF3D8
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 13:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbjDLLgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 07:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbjDLLf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 07:35:57 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6897D9C
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 04:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681299337; x=1712835337;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aEIb9Mq/7D1tsIdAe1YAywtVS++LBAWPYPNIcRYan0c=;
  b=m6Af/uIuIFld6EUvflcZHuXP6jfJlqO4J6TSw54aY15HiA1K7WDzdwht
   G5ZgDTBmZBnVNSotxHoSiwb7BKOCJeECBwP7yYOoZzwi8+1Q4vL+h9Qws
   kch1A5wFb9x2FsykB0zX6rsFmmwedAm5xBLb4EiujU58k7OrO3MfJxaDu
   uZHJK7uLy0HmzIDeUNgqHo3L3HNvb2/Dm16mrC4Etuu50XqSjcz84i0/a
   P26lIAo/wKEJATaW5Pdmm5y2SjJQwTUDxo9I/yPmg1DbWcwo0EMDqR3HV
   UTUCAP/+IlgAzNKafu73vqVZcG88ziHTHZ1XT4k0LQkuBF+0ZfqcFJadz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="327978246"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="327978246"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 04:34:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="778268808"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="778268808"
Received: from zbiro-mobl.ger.corp.intel.com (HELO intel.com) ([10.251.212.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 04:34:06 -0700
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org
Cc:     Matthew Auld <matthew.auld@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Chris Wilson <chris.p.wilson@linux.intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Nirmoy Das <nirmoy.das@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH v5 2/5] drm/i915: Create the locked version of the request create
Date:   Wed, 12 Apr 2023 13:33:05 +0200
Message-Id: <20230412113308.812468-3-andi.shyti@linux.intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412113308.812468-1-andi.shyti@linux.intel.com>
References: <20230412113308.812468-1-andi.shyti@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make version of the request creation that doesn't hold any
lock.

Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
---
 drivers/gpu/drm/i915/i915_request.c | 38 +++++++++++++++++++++--------
 drivers/gpu/drm/i915/i915_request.h |  2 ++
 2 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index 630a732aaecca..58662360ac34e 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -1028,15 +1028,11 @@ __i915_request_create(struct intel_context *ce, gfp_t gfp)
 	return ERR_PTR(ret);
 }
 
-struct i915_request *
-i915_request_create(struct intel_context *ce)
+static struct i915_request *
+__i915_request_create_locked(struct intel_context *ce)
 {
+	struct intel_timeline *tl = ce->timeline;
 	struct i915_request *rq;
-	struct intel_timeline *tl;
-
-	tl = intel_context_timeline_lock(ce);
-	if (IS_ERR(tl))
-		return ERR_CAST(tl);
 
 	/* Move our oldest request to the slab-cache (if not in use!) */
 	rq = list_first_entry(&tl->requests, typeof(*rq), link);
@@ -1046,16 +1042,38 @@ i915_request_create(struct intel_context *ce)
 	intel_context_enter(ce);
 	rq = __i915_request_create(ce, GFP_KERNEL);
 	intel_context_exit(ce); /* active reference transferred to request */
+
 	if (IS_ERR(rq))
-		goto err_unlock;
+		return rq;
 
 	/* Check that we do not interrupt ourselves with a new request */
 	rq->cookie = lockdep_pin_lock(&tl->mutex);
 
 	return rq;
+}
+
+struct i915_request *
+i915_request_create_locked(struct intel_context *ce)
+{
+	intel_context_assert_timeline_is_locked(ce->timeline);
+
+	return __i915_request_create_locked(ce);
+}
+
+struct i915_request *
+i915_request_create(struct intel_context *ce)
+{
+	struct i915_request *rq;
+	struct intel_timeline *tl;
+
+	tl = intel_context_timeline_lock(ce);
+	if (IS_ERR(tl))
+		return ERR_CAST(tl);
+
+	rq = __i915_request_create_locked(ce);
+	if (IS_ERR(rq))
+		intel_context_timeline_unlock(tl);
 
-err_unlock:
-	intel_context_timeline_unlock(tl);
 	return rq;
 }
 
diff --git a/drivers/gpu/drm/i915/i915_request.h b/drivers/gpu/drm/i915/i915_request.h
index f5e1bb5e857aa..bb48bd4605c03 100644
--- a/drivers/gpu/drm/i915/i915_request.h
+++ b/drivers/gpu/drm/i915/i915_request.h
@@ -374,6 +374,8 @@ struct i915_request * __must_check
 __i915_request_create(struct intel_context *ce, gfp_t gfp);
 struct i915_request * __must_check
 i915_request_create(struct intel_context *ce);
+struct i915_request * __must_check
+i915_request_create_locked(struct intel_context *ce);
 
 void __i915_request_skip(struct i915_request *rq);
 bool i915_request_set_error_once(struct i915_request *rq, int error);
-- 
2.39.2

