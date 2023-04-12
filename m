Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D324C6DF3E3
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 13:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjDLLjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 07:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbjDLLjI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 07:39:08 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E168C114
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 04:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681299527; x=1712835527;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4jsuxaOlQQhIILu8/DTGj4Auy5P5LrqrCa5YmCivzaQ=;
  b=LefQLe4XSN3Wm8h8U4KWYAX5rB0tliLB6LkrDcaf5gzxPs3uAInM5dDn
   haoakJIEjznKFbAWKjeK/h9595lP2D6qlKB1ck2jLNgVBCLWdxy4vjsC/
   DkMvyWwBlzhRJGrs2897tRgPTCSmAzodOy6npdYAtwEXAlI7hiFUwtTWa
   fVDTZBBBJwjbeadsHmNXTJJqWlBXxEMUJcgR4C4NcmoOuLu4VofVRjKbI
   L68pKt6+sp34hCze7O6u/CqX/8toVMqkJYosVZMV7YCqtdBFDu5QSsEIp
   XRDQaCABBmfBj8yOHFJ0YtybLt+xPYddmO9hqbmXz/KSXosOw0KUp/oZV
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="430152017"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="430152017"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 04:34:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="800275732"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="800275732"
Received: from zbiro-mobl.ger.corp.intel.com (HELO intel.com) ([10.251.212.144])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 04:34:22 -0700
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
Subject: [PATCH v5 4/5] drm/i915: Throttle for ringspace prior to taking the timeline mutex
Date:   Wed, 12 Apr 2023 13:33:07 +0200
Message-Id: <20230412113308.812468-5-andi.shyti@linux.intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412113308.812468-1-andi.shyti@linux.intel.com>
References: <20230412113308.812468-1-andi.shyti@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

Signed-off-by: Chris Wilson <chris.p.wilson@linux.intel.com>
Cc: Maciej Patelczyk <maciej.patelczyk@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
---
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
index f2f79ff0dfd1d..c0db00ac6b950 100644
--- a/drivers/gpu/drm/i915/gt/intel_context.h
+++ b/drivers/gpu/drm/i915/gt/intel_context.h
@@ -233,6 +233,8 @@ static inline void intel_context_exit(struct intel_context *ce)
 	ce->ops->exit(ce);
 }
 
+int intel_context_throttle(const struct intel_context *ce);
+
 static inline struct intel_context *intel_context_get(struct intel_context *ce)
 {
 	kref_get(&ce->ref);
diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index 21032b3b9d330..0b7c6aede0c6b 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -1057,6 +1057,9 @@ i915_request_create_locked(struct intel_context *ce)
 {
 	intel_context_assert_timeline_is_locked(ce->timeline);
 
+	if (intel_context_throttle(ce))
+		return ERR_PTR(-EINTR);
+
 	return __i915_request_create_locked(ce);
 }
 
-- 
2.39.2

