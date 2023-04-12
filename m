Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E18106DF3D6
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 13:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjDLLgD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 07:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbjDLLf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 07:35:58 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63882E0
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 04:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681299338; x=1712835338;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uq8gJA7UF9zY+Rnq5ZWEjTGMW1EI9UDFtX1lsG58moA=;
  b=X34NRppbtUceU4j6IhsckbxYLBkqVxn/Z/LXO+YPYH1ilqLrQY5cvMzC
   UD9N0x7uMjQoJUaZ/aQztoWKB7Wk7vz2O23mufGEp4O5u3olxPMry+P6q
   zG9WUeWBNzTpBgZirK0gC2Cm48ayGAacWpoH/8jDZ2wh0vHKgHLCucIUX
   L1ausIGfMrxglPsgild5CyDBZqsS+fyBW9XvjwT05h1pPXG+D/CUsLGrx
   HriFZDX+0Evm9zxWg5tC0nmXu3E68z9xMKpSgAiGWE6kZoWsLLpZLG3LA
   o3B0XrH0FlrBu/JFK0HRWr6n+bcpMrw0nJ3q2hqsPckDJC1NuO1jCYMMz
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="327978277"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="327978277"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 04:34:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="778268846"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="778268846"
Received: from zbiro-mobl.ger.corp.intel.com (HELO intel.com) ([10.251.212.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 04:34:14 -0700
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
Subject: [PATCH v5 3/5] drm/i915: Create the locked version of the request add
Date:   Wed, 12 Apr 2023 13:33:06 +0200
Message-Id: <20230412113308.812468-4-andi.shyti@linux.intel.com>
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

i915_request_add() assumes that the timeline is locked whtn the
function is called. Before exiting it releases the lock. But in
the next commit we have one case where releasing the timeline
mutex is not necessary and we don't want that.

Make a new i915_request_add_locked() version of the function
where the lock is not released.

Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/i915_request.c | 14 +++++++++++---
 drivers/gpu/drm/i915/i915_request.h |  1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index 58662360ac34e..21032b3b9d330 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -1852,13 +1852,13 @@ void __i915_request_queue(struct i915_request *rq,
 	local_bh_enable(); /* kick tasklets */
 }
 
-void i915_request_add(struct i915_request *rq)
+void i915_request_add_locked(struct i915_request *rq)
 {
 	struct intel_timeline * const tl = i915_request_timeline(rq);
 	struct i915_sched_attr attr = {};
 	struct i915_gem_context *ctx;
 
-	lockdep_assert_held(&tl->mutex);
+	intel_context_assert_timeline_is_locked(tl);
 	lockdep_unpin_lock(&tl->mutex, rq->cookie);
 
 	trace_i915_request_add(rq);
@@ -1873,7 +1873,15 @@ void i915_request_add(struct i915_request *rq)
 
 	__i915_request_queue(rq, &attr);
 
-	mutex_unlock(&tl->mutex);
+}
+
+void i915_request_add(struct i915_request *rq)
+{
+	struct intel_timeline * const tl = i915_request_timeline(rq);
+
+	i915_request_add_locked(rq);
+
+	intel_context_timeline_unlock(tl);
 }
 
 static unsigned long local_clock_ns(unsigned int *cpu)
diff --git a/drivers/gpu/drm/i915/i915_request.h b/drivers/gpu/drm/i915/i915_request.h
index bb48bd4605c03..29e3a37c300a7 100644
--- a/drivers/gpu/drm/i915/i915_request.h
+++ b/drivers/gpu/drm/i915/i915_request.h
@@ -425,6 +425,7 @@ int i915_request_await_deps(struct i915_request *rq, const struct i915_deps *dep
 int i915_request_await_execution(struct i915_request *rq,
 				 struct dma_fence *fence);
 
+void i915_request_add_locked(struct i915_request *rq);
 void i915_request_add(struct i915_request *rq);
 
 bool __i915_request_submit(struct i915_request *request);
-- 
2.39.2

