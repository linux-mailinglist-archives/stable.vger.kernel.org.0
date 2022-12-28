Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790C6657BEB
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbiL1P1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233782AbiL1P0w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:26:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DDA14038
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:26:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23344B8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:26:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79821C433EF;
        Wed, 28 Dec 2022 15:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241207;
        bh=uZv/CWK8frLiw1+sihoCOGHynh4EZc70d5vM5HvSZGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S4Wc5LZV7Ou8vc+aeX+qgk4ucAkHMxl4yeczY3+D2aB5PahLBwuT1PNkyuX4u6wVb
         e8fuvmzIGOfWIWGbs073r6p+A++HyFNhxE6F3Y5ilIup177iCpGk4U2SRVzFUG2ESS
         jd9jbhWnljJqGSQvjkARMuc+JgbXDINaoPR9Z9Qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, John Harrison <John.C.Harrison@Intel.com>,
        Alan Previn <alan.previn.teres.alexis@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0253/1073] drm/i915/guc: Fix capture size warning and bump the size
Date:   Wed, 28 Dec 2022 15:30:41 +0100
Message-Id: <20221228144334.892515755@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Harrison <John.C.Harrison@Intel.com>

[ Upstream commit 56c7f0e2026328e56106b54cb0e2fe3a7e70ce4f ]

There was a size check to warn if the GuC error state capture buffer
allocation would be too small to fit a reasonable amount of capture
data for the current platform. Unfortunately, the test was done too
early in the boot sequence and was actually testing 'if(-ENODEV >
size)'.

Move the check to be later. The check is only used to print a warning
message, so it doesn't really matter how early or late it is done.
Note that it is not possible to dynamically size the buffer because
the allocation needs to be done before the engine information is
available (at least, it would be in the intended two-phase GuC init
process).

Now that the check works, it is reporting size too small for newer
platforms. The check includes a 3x oversample multiplier to allow for
multiple error captures to be bufferd by GuC before i915 has a chance
to read them out. This is less important than simply being big enough
to fit the first capture.

So a) bump the default size to be large enough for one capture minimum
and b) make the warning only if one capture won't fit, instead use a
notice for the 3x size.

Note that the size estimate is a worst case scenario. Actual captures
will likely be smaller.

Lastly, use drm_warn istead of DRM_WARN as the former provides more
infmration and the latter is deprecated.

Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Reviewed-by: Alan Previn <alan.previn.teres.alexis@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220728022028.2190627-3-John.C.Harrison@Intel.com
Stable-dep-of: befb231d5de2 ("drm/i915/guc: Fix GuC error capture sizing estimation and reporting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/i915/gt/uc/intel_guc_capture.c    | 40 ++++++++++++++-----
 .../gpu/drm/i915/gt/uc/intel_guc_capture.h    |  1 -
 drivers/gpu/drm/i915/gt/uc/intel_guc_log.c    |  4 --
 drivers/gpu/drm/i915/gt/uc/intel_guc_log.h    |  4 +-
 4 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c
index 75257bd20ff0..b54b7883320b 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c
@@ -600,10 +600,8 @@ intel_guc_capture_getnullheader(struct intel_guc *guc,
 	return 0;
 }
 
-#define GUC_CAPTURE_OVERBUFFER_MULTIPLIER 3
-
-int
-intel_guc_capture_output_min_size_est(struct intel_guc *guc)
+static int
+guc_capture_output_min_size_est(struct intel_guc *guc)
 {
 	struct intel_gt *gt = guc_to_gt(guc);
 	struct intel_engine_cs *engine;
@@ -623,13 +621,8 @@ intel_guc_capture_output_min_size_est(struct intel_guc *guc)
 	 * For each engine instance, there would be 1 x guc_state_capture_group_t output
 	 * followed by 3 x guc_state_capture_t lists. The latter is how the register
 	 * dumps are split across different register types (where the '3' are global vs class
-	 * vs instance). Finally, let's multiply the whole thing by 3x (just so we are
-	 * not limited to just 1 round of data in a worst case full register dump log)
-	 *
-	 * NOTE: intel_guc_log that allocates the log buffer would round this size up to
-	 * a power of two.
+	 * vs instance).
 	 */
-
 	for_each_engine(engine, gt, id) {
 		worst_min_size += sizeof(struct guc_state_capture_group_header_t) +
 					 (3 * sizeof(struct guc_state_capture_header_t));
@@ -649,7 +642,30 @@ intel_guc_capture_output_min_size_est(struct intel_guc *guc)
 
 	worst_min_size += (num_regs * sizeof(struct guc_mmio_reg));
 
-	return (worst_min_size * GUC_CAPTURE_OVERBUFFER_MULTIPLIER);
+	return worst_min_size;
+}
+
+/*
+ * Add on a 3x multiplier to allow for multiple back-to-back captures occurring
+ * before the i915 can read the data out and process it
+ */
+#define GUC_CAPTURE_OVERBUFFER_MULTIPLIER 3
+
+static void check_guc_capture_size(struct intel_guc *guc)
+{
+	struct drm_i915_private *i915 = guc_to_gt(guc)->i915;
+	int min_size = guc_capture_output_min_size_est(guc);
+	int spare_size = min_size * GUC_CAPTURE_OVERBUFFER_MULTIPLIER;
+
+	if (min_size < 0)
+		drm_warn(&i915->drm, "Failed to calculate GuC error state capture buffer minimum size: %d!\n",
+			 min_size);
+	else if (min_size > CAPTURE_BUFFER_SIZE)
+		drm_warn(&i915->drm, "GuC error state capture buffer is too small: %d < %d\n",
+			 CAPTURE_BUFFER_SIZE, min_size);
+	else if (spare_size > CAPTURE_BUFFER_SIZE)
+		drm_notice(&i915->drm, "GuC error state capture buffer maybe too small: %d < %d (min = %d)\n",
+			   CAPTURE_BUFFER_SIZE, spare_size, min_size);
 }
 
 /*
@@ -1580,5 +1596,7 @@ int intel_guc_capture_init(struct intel_guc *guc)
 	INIT_LIST_HEAD(&guc->capture->outlist);
 	INIT_LIST_HEAD(&guc->capture->cachelist);
 
+	check_guc_capture_size(guc);
+
 	return 0;
 }
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.h b/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.h
index d3d7bd0b6db6..fbd3713c7832 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.h
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.h
@@ -21,7 +21,6 @@ int intel_guc_capture_print_engine_node(struct drm_i915_error_state_buf *m,
 void intel_guc_capture_get_matching_node(struct intel_gt *gt, struct intel_engine_coredump *ee,
 					 struct intel_context *ce);
 void intel_guc_capture_process(struct intel_guc *guc);
-int intel_guc_capture_output_min_size_est(struct intel_guc *guc);
 int intel_guc_capture_getlist(struct intel_guc *guc, u32 owner, u32 type, u32 classid,
 			      void **outptr);
 int intel_guc_capture_getlistsize(struct intel_guc *guc, u32 owner, u32 type, u32 classid,
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_log.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_log.c
index 492bbf419d4d..991d4a02248d 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_log.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_log.c
@@ -487,10 +487,6 @@ int intel_guc_log_create(struct intel_guc_log *log)
 
 	GEM_BUG_ON(log->vma);
 
-	if (intel_guc_capture_output_min_size_est(guc) > CAPTURE_BUFFER_SIZE)
-		DRM_WARN("GuC log buffer for state_capture maybe too small. %d < %d\n",
-			 CAPTURE_BUFFER_SIZE, intel_guc_capture_output_min_size_est(guc));
-
 	guc_log_size = intel_guc_log_size(log);
 
 	vma = intel_guc_allocate_vma(guc, guc_log_size);
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_log.h b/drivers/gpu/drm/i915/gt/uc/intel_guc_log.h
index 18007e639be9..dc9715411d62 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_log.h
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_log.h
@@ -22,11 +22,11 @@ struct intel_guc;
 #elif defined(CONFIG_DRM_I915_DEBUG_GEM)
 #define CRASH_BUFFER_SIZE	SZ_1M
 #define DEBUG_BUFFER_SIZE	SZ_2M
-#define CAPTURE_BUFFER_SIZE	SZ_1M
+#define CAPTURE_BUFFER_SIZE	SZ_4M
 #else
 #define CRASH_BUFFER_SIZE	SZ_8K
 #define DEBUG_BUFFER_SIZE	SZ_64K
-#define CAPTURE_BUFFER_SIZE	SZ_16K
+#define CAPTURE_BUFFER_SIZE	SZ_2M
 #endif
 
 /*
-- 
2.35.1



