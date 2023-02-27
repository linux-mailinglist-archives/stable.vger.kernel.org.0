Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7389A6A4CC2
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 22:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjB0VIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 16:08:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjB0VIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 16:08:52 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C62B76E
        for <stable@vger.kernel.org>; Mon, 27 Feb 2023 13:08:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677532131; x=1709068131;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RQP1V7phNoi9kxLvQc7zfV7/kBtqWl1sfDhMmrTbiNM=;
  b=dFTjRAwpdcl187xWyO5kL7YzWBhVbVsRMl8uUkj8dV+vJfBpaEuDkzfw
   gGQbVKVPbTJXQt09waZnWxwSJyLY5k39ZBsMOPzop7cWotyKSIEfQa/wU
   tq/XgICs+Le3GP/p7nU3pa1dh12nicDjjZILVnHbno4BRn/WWKlYSib19
   mE3GOIe7zC5m/5sUu7xDWUwP42qqc6c+nopYVVkzbZyX34eim6kiXeKGB
   MyptGG+oSayvv0+N4/vLku4RpM84ZdCJKRN7F70UufMWMol74Hgok3kYP
   v7lQ6kKCG+1YAsVPYjWzTOa31ZoFVzYfhnldvqz+NHUpPVPWdQBrYPtrf
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="317767924"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="317767924"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 13:08:49 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="623761625"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="623761625"
Received: from jrissane-mobl2.ger.corp.intel.com (HELO intel.com) ([10.249.41.42])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 13:08:34 -0800
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org
Cc:     Matthew Auld <matthew.auld@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Chris Wilson <chris.p.wilson@linux.intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Andi Shyti <andi@etezian.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH v2 1/2] drm/i915: Throttle for ringspace prior to taking the timeline mutex
Date:   Mon, 27 Feb 2023 22:08:17 +0100
Message-Id: <20230227210818.1731172-2-andi.shyti@linux.intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230227210818.1731172-1-andi.shyti@linux.intel.com>
References: <20230227210818.1731172-1-andi.shyti@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

Before taking exclusive ownership of the ring for emitting the request,
wait for space in the ring to become available. This allows others to
take the timeline->mutex to make forward progresses while userspace is
blocked.

In particular, this allows regular clients to issue requests on the
kernel context, potentially filling the ring, but allow the higher
priority heartbeats and pulses to still be submitted without being
blocked by the less critical work.

Fixes: cf586021642d80 ("drm/i915/gt: Pipelined page migration")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Maciej Patelczyk <maciej.patelczyk@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
---
Hi,

I'm not sure I need to add the Fixes tag here as this is more
preparatory for the next patch. Together, though, patch 1 and 2
make the fix with proper locking mechanism.

Andi

 drivers/gpu/drm/i915/gt/intel_context.c | 41 +++++++++++++++++++++++++
 drivers/gpu/drm/i915/gt/intel_context.h |  2 ++
 drivers/gpu/drm/i915/i915_request.c     |  3 ++
 3 files changed, 46 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/intel_context.c b/drivers/gpu/drm/i915/gt/intel_context.c
index 2aa63ec521b89..59cd612a23561 100644
--- a/drivers/gpu/drm/i915/gt/intel_context.c
+++ b/drivers/gpu/drm/i915/gt/intel_context.c
@@ -626,6 +626,47 @@ bool intel_context_revoke(struct intel_context *ce)
 	return ret;
 }
 
+int intel_context_throttle(const struct intel_context *ce)
+{
+	const struct intel_ring *ring = ce->ring;
+	const struct intel_timeline *tl = ce->timeline;
+	struct i915_request *rq;
+	int err = 0;
+
+	if (READ_ONCE(ring->space) >= SZ_1K)
+		return 0;
+
+	rcu_read_lock();
+	list_for_each_entry_reverse(rq, &tl->requests, link) {
+		if (__i915_request_is_complete(rq))
+			break;
+
+		if (rq->ring != ring)
+			continue;
+
+		/* Wait until there will be enough space following that rq */
+		if (__intel_ring_space(rq->postfix,
+				       ring->emit,
+				       ring->size) < ring->size / 2) {
+			if (i915_request_get_rcu(rq)) {
+				rcu_read_unlock();
+
+				if (i915_request_wait(rq,
+						      I915_WAIT_INTERRUPTIBLE,
+						      MAX_SCHEDULE_TIMEOUT) < 0)
+					err = -EINTR;
+
+				rcu_read_lock();
+				i915_request_put(rq);
+			}
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return err;
+}
+
 #if IS_ENABLED(CONFIG_DRM_I915_SELFTEST)
 #include "selftest_context.c"
 #endif
diff --git a/drivers/gpu/drm/i915/gt/intel_context.h b/drivers/gpu/drm/i915/gt/intel_context.h
index 0a8d553da3f43..f919a66cebf5b 100644
--- a/drivers/gpu/drm/i915/gt/intel_context.h
+++ b/drivers/gpu/drm/i915/gt/intel_context.h
@@ -226,6 +226,8 @@ static inline void intel_context_exit(struct intel_context *ce)
 		ce->ops->exit(ce);
 }
 
+int intel_context_throttle(const struct intel_context *ce);
+
 static inline struct intel_context *intel_context_get(struct intel_context *ce)
 {
 	kref_get(&ce->ref);
diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index 7503dcb9043bb..a1741c4a8cffd 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -1035,6 +1035,9 @@ i915_request_create(struct intel_context *ce)
 	struct i915_request *rq;
 	struct intel_timeline *tl;
 
+	if (intel_context_throttle(ce))
+		return ERR_PTR(-EINTR);
+
 	tl = intel_context_timeline_lock(ce);
 	if (IS_ERR(tl))
 		return ERR_CAST(tl);
-- 
2.39.1

