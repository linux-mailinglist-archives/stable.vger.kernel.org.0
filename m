Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDC469207D
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 15:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbjBJOGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 09:06:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbjBJOGq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 09:06:46 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B83174045
        for <stable@vger.kernel.org>; Fri, 10 Feb 2023 06:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676037998; x=1707573998;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OVozveDUHgfynAT+si9XRh9yxwW8TU+NAQ5WLXmDOMQ=;
  b=nasu6gv9kzXYtsXb3w73DqBJKfGDLK6zU8cGZq0aC+qcFGKdQPW7eu1W
   rxm9roS4MiWblwGVMQdGcG4XolZIUwFL8/F9Cd7Pgpy4hdi7+ZTiSsmV0
   hbrxrUSQnS5qDhYjRAwIMf04KxXCdJ4z6ehi0zIFfWIfGMPByRUu+s1l7
   W4+tC8TiTFN0dQqijJFEok3O5i812U1gXpCQHhxenyyKro3nIXr4RrUwG
   JVoFyqzC060+KWV8or6DduG4sRuYotONAckMEJnv3LumAZMO6n/5TiOtI
   WhCrJgw9O7GgCMC9yJCFYBYih40T0dmWlRJ3e70rJYefaap2KdJABsDAU
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="314072015"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="314072015"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 06:06:37 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="913539357"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="913539357"
Received: from mleshin-mobl1.ger.corp.intel.com (HELO intel.com) ([10.252.48.65])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 06:06:35 -0800
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc:     Chris Wilson <chris.p.wilson@linux.intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Andi Shyti <andi@etezian.org>,
        Matthew Auld <matthew.auld@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: [PATCH] drm/i915/gt: Make sure that errors are propagated through request chains
Date:   Fri, 10 Feb 2023 15:06:09 +0100
Message-Id: <20230210140609.988022-1-andi.shyti@linux.intel.com>
X-Mailer: git-send-email 2.39.1
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

Currently, for operations like memory clear or copy for big
chunks of memory, we generate multiple requests executed in a
chain.

But if one of the requests generated fails we would not know it
to unless it happens to the last request, because errors are not
properly propagated.

For this we need to keep propagating the chain of fence
notification in order to always reach the final fence associated
to the final request.

This way we would know that the memory operation has failed and
whether the memory is still invalid.

On copy and clear migration signal fences upon completion.

Fixes: cf586021642d80 ("drm/i915/gt: Pipelined page migration")
Reported-by: Matthew Auld <matthew.auld@intel.com>
Suggested-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/gt/intel_migrate.c | 31 +++++++++++++++++--------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_migrate.c b/drivers/gpu/drm/i915/gt/intel_migrate.c
index 3f638f1987968..8a293045a7b96 100644
--- a/drivers/gpu/drm/i915/gt/intel_migrate.c
+++ b/drivers/gpu/drm/i915/gt/intel_migrate.c
@@ -748,7 +748,7 @@ intel_context_migrate_copy(struct intel_context *ce,
 		rq = i915_request_create(ce);
 		if (IS_ERR(rq)) {
 			err = PTR_ERR(rq);
-			goto out_ce;
+			break;
 		}
 
 		if (deps) {
@@ -878,10 +878,14 @@ intel_context_migrate_copy(struct intel_context *ce,
 
 		/* Arbitration is re-enabled between requests. */
 out_rq:
-		if (*out)
-			i915_request_put(*out);
-		*out = i915_request_get(rq);
+		i915_sw_fence_await(&rq->submit);
+		i915_request_get(rq);
 		i915_request_add(rq);
+		if (*out) {
+			i915_sw_fence_complete(&(*out)->submit);
+			i915_request_put(*out);
+		}
+		*out = rq;
 
 		if (err)
 			break;
@@ -905,7 +909,8 @@ intel_context_migrate_copy(struct intel_context *ce,
 		cond_resched();
 	} while (1);
 
-out_ce:
+	if (*out)
+		i915_sw_fence_complete(&(*out)->submit);
 	return err;
 }
 
@@ -1005,7 +1010,7 @@ intel_context_migrate_clear(struct intel_context *ce,
 		rq = i915_request_create(ce);
 		if (IS_ERR(rq)) {
 			err = PTR_ERR(rq);
-			goto out_ce;
+			break;
 		}
 
 		if (deps) {
@@ -1056,17 +1061,23 @@ intel_context_migrate_clear(struct intel_context *ce,
 
 		/* Arbitration is re-enabled between requests. */
 out_rq:
-		if (*out)
-			i915_request_put(*out);
-		*out = i915_request_get(rq);
+		i915_sw_fence_await(&rq->submit);
+		i915_request_get(rq);
 		i915_request_add(rq);
+		if (*out) {
+			i915_sw_fence_complete(&(*out)->submit);
+			i915_request_put(*out);
+		}
+		*out = rq;
+
 		if (err || !it.sg || !sg_dma_len(it.sg))
 			break;
 
 		cond_resched();
 	} while (1);
 
-out_ce:
+	if (*out)
+		i915_sw_fence_complete(&(*out)->submit);
 	return err;
 }
 
-- 
2.39.1

