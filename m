Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04ED96B0340
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 10:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjCHJm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 04:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjCHJmZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 04:42:25 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23F9B8F1D
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 01:41:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678268516; x=1709804516;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IOotfOVmg3pdiNQpQIdy/u1GE39m3M/0ofAz2lryi5Y=;
  b=cLmaQCowQG7opgMNi8dIqIoS3nQRApmc9iIyjDapu1UUxK3smdpkLWmC
   SLKJ5dfA6CslkDChhVWdML94y/W0gIyYzh3/E7E4G6DqRIOhBSkpS3Y8l
   40icnVCxq+XQLwtnlM+B207OW5/Z9nnuxxUL9tAfefncm0wDZX1COJhll
   Rg+t4S7enu86spIw+wdOszEEeQR34iSgce9PFGRfYv7VPRHnliN9J5vo8
   kZrDP3xBxyMvdvb/hspE1Saasqp86pX0SvqebxuZGchJ4OfSY2xj+dfuP
   YInDuJQn8hYtRV+NGXQwh253fXZ5suzhDa1c7MVUuBZvXSZlkPCdaSLL8
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="315772855"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="315772855"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 01:41:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="922712448"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="922712448"
Received: from gbain-mobl1.ger.corp.intel.com (HELO intel.com) ([10.252.47.108])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 01:41:54 -0800
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org
Cc:     Matthew Auld <matthew.auld@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Chris Wilson <chris.p.wilson@linux.intel.com>,
        Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH v4 5/5] drm/i915/gt: Make sure that errors are propagated through request chains
Date:   Wed,  8 Mar 2023 10:41:06 +0100
Message-Id: <20230308094106.203686-6-andi.shyti@linux.intel.com>
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

Currently, when we perform operations such as clearing or copying
large blocks of memory, we generate multiple requests that are
executed in a chain.

However, if one of these requests fails, we may not realize it
unless it happens to be the last request in the chain. This is
because errors are not properly propagated.

For this we need to keep propagating the chain of fence
notification in order to always reach the final fence associated
to the final request.

To address this issue, we need to ensure that the chain of fence
notifications is always propagated so that we can reach the final
fence associated with the last request. By doing so, we will be
able to detect any memory operation  failures and determine
whether the memory is still invalid.

On copy and clear migration signal fences upon completion.

On copy and clear migration, signal fences upon request
completion to ensure that we have a reliable perpetuation of the
operation outcome.

Fixes: cf586021642d80 ("drm/i915/gt: Pipelined page migration")
Reported-by: Matthew Auld <matthew.auld@intel.com>
Suggested-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
---
 drivers/gpu/drm/i915/gt/intel_migrate.c | 41 ++++++++++++++++++-------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_migrate.c b/drivers/gpu/drm/i915/gt/intel_migrate.c
index 3f638f1987968..0031e7b1b4704 100644
--- a/drivers/gpu/drm/i915/gt/intel_migrate.c
+++ b/drivers/gpu/drm/i915/gt/intel_migrate.c
@@ -742,13 +742,19 @@ intel_context_migrate_copy(struct intel_context *ce,
 			dst_offset = 2 * CHUNK_SZ;
 	}
 
+	/*
+	 * While building the chain of requests, we need to ensure
+	 * that no one can sneak into the timeline unnoticed.
+	 */
+	mutex_lock(&ce->timeline->mutex);
+
 	do {
 		int len;
 
-		rq = i915_request_create(ce);
+		rq = i915_request_create_locked(ce);
 		if (IS_ERR(rq)) {
 			err = PTR_ERR(rq);
-			goto out_ce;
+			break;
 		}
 
 		if (deps) {
@@ -878,10 +884,14 @@ intel_context_migrate_copy(struct intel_context *ce,
 
 		/* Arbitration is re-enabled between requests. */
 out_rq:
-		if (*out)
+		i915_sw_fence_await(&rq->submit);
+		i915_request_get(rq);
+		i915_request_add_locked(rq);
+		if (*out) {
+			i915_sw_fence_complete(&(*out)->submit);
 			i915_request_put(*out);
-		*out = i915_request_get(rq);
-		i915_request_add(rq);
+		}
+		*out = rq;
 
 		if (err)
 			break;
@@ -905,7 +915,10 @@ intel_context_migrate_copy(struct intel_context *ce,
 		cond_resched();
 	} while (1);
 
-out_ce:
+	mutex_unlock(&ce->timeline->mutex);
+
+	if (*out)
+		i915_sw_fence_complete(&(*out)->submit);
 	return err;
 }
 
@@ -1005,7 +1018,7 @@ intel_context_migrate_clear(struct intel_context *ce,
 		rq = i915_request_create(ce);
 		if (IS_ERR(rq)) {
 			err = PTR_ERR(rq);
-			goto out_ce;
+			break;
 		}
 
 		if (deps) {
@@ -1056,17 +1069,23 @@ intel_context_migrate_clear(struct intel_context *ce,
 
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
2.39.2

