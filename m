Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 492A56B033E
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 10:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjCHJmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 04:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbjCHJmI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 04:42:08 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558A7B8622
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 01:41:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678268512; x=1709804512;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RXpl7rgjUz4etReUygnpSrvSrOVxxmXELSv4rNfUQlA=;
  b=IBko78n+RDD2xLvluzfVtulJZuOJssmcEmd7lwLKHb07LI1GOmqb5CFA
   3iY3TXVRBa1m/Bv3hkV7xX8bpdZ8Hegf7tOXik5xCJbK8EPtdNWS4vY+N
   BeQK7hTpRLK4tLBmA/F919PvLKuxRta2nEgmhHm7X4eM+M75fY/O7ucdO
   ZHje7MihAUMQoeYdAMqAm9Sr5Iy+rj+ON9o3gGw6V+uZURnu2Dh2ouKpR
   kc5jMFGjhb9j87Hd05lSJUQPAQORkYLV2GOnbuMjRjs/p6mUH6Ufw7roF
   R6KOz8+4eTjexetNwhwZY5ji8ecIGsD0FifedcjyfjQMnXDNK6m5vCcTW
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="315772837"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="315772837"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 01:41:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="709362519"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="709362519"
Received: from gbain-mobl1.ger.corp.intel.com (HELO intel.com) ([10.252.47.108])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 01:41:49 -0800
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org
Cc:     Matthew Auld <matthew.auld@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Chris Wilson <chris.p.wilson@linux.intel.com>,
        Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH v4 4/5] drm/i915: Create the locked version of the request add
Date:   Wed,  8 Mar 2023 10:41:05 +0100
Message-Id: <20230308094106.203686-5-andi.shyti@linux.intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230308094106.203686-1-andi.shyti@linux.intel.com>
References: <20230308094106.203686-1-andi.shyti@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
index 5ddb0e02b06b7..a4af16e25d966 100644
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

