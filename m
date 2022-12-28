Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 388E7657BF6
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbiL1P1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:27:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233766AbiL1P1S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:27:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9AB2140A7
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:27:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BDFDB8171F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:27:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B50C433D2;
        Wed, 28 Dec 2022 15:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241235;
        bh=DGaPBg+Nu5lemc3+T5MnkxmNCI3aF94uPN5NqbcKR3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yHBQ2JO+AcTEnARItD1EXAOtj5sYg4LwirLJPVtcHeTJ3ZhR/YzZSW+cvMFH5yEih
         u7V0ELnQupWZRCJYPM9d+TgZoW5765mzy9+7FSNTqWRQi6HHmB+Xlm1z9oEbm3xi23
         lddHGT9Pcr8/1AR2OMJXnSCh/HGr9v9yaBxGCvks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alan Previn <alan.previn.teres.alexis@intel.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        John Harrison <John.C.Harrison@Intel.com>,
        Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
        Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0256/1073] drm/i915/guc: Fix GuC error capture sizing estimation and reporting
Date:   Wed, 28 Dec 2022 15:30:44 +0100
Message-Id: <20221228144334.973142253@linuxfoundation.org>
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

From: Alan Previn <alan.previn.teres.alexis@intel.com>

[ Upstream commit befb231d5de2773f6c6f6cf918234e2e709110a5 ]

During GuC error capture initialization, we estimate the amount of size
we need for the error-capture-region of the shared GuC-log-buffer.
This calculation was incorrect so fix that. With the fixed calculation
we can reduce the allocation of error-capture region from 4MB to 1MB
(see note2 below for reasoning). Additionally, switch from drm_notice to
drm_debug for the 3X spare size check since that would be impossible to
hit without redesigning gpu_coredump framework to hold multiple captures.

NOTE1: Even for 1x the min size estimation case, actually running out
of space is a corner case because it can only occur if all engine
instances get reset all at once and i915 isn't able extract the capture
data fast enough within G2H handler worker.

NOTE2: With the corrected calculation, a DG2 part required ~77K and a PVC
required ~115K (1X min-est-size that is calculated as one-shot all-engine-
reset scenario).

Fixes: d7c15d76a554 ("drm/i915/guc: Check sizing of guc_capture output")
Cc: Alan Previn <alan.previn.teres.alexis@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: John Harrison <John.C.Harrison@Intel.com>
Cc: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Cc: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Chris Wilson <chris.p.wilson@intel.com>
Signed-off-by: Alan Previn <alan.previn.teres.alexis@intel.com>
Reviewed-by: John Harrison <John.C.Harrison@Intel.com>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221026060506.1007830-2-alan.previn.teres.alexis@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/i915/gt/uc/intel_guc_capture.c    | 29 ++++++++++++-------
 drivers/gpu/drm/i915/gt/uc/intel_guc_log.c    |  6 ++--
 2 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c
index c398bdd5403a..34e72675b7e4 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c
@@ -555,8 +555,9 @@ guc_capture_getlistsize(struct intel_guc *guc, u32 owner, u32 type, u32 classid,
 	if (!num_regs)
 		return -ENODATA;
 
-	*size = PAGE_ALIGN((sizeof(struct guc_debug_capture_list)) +
-			   (num_regs * sizeof(struct guc_mmio_reg)));
+	if (size)
+		*size = PAGE_ALIGN((sizeof(struct guc_debug_capture_list)) +
+				   (num_regs * sizeof(struct guc_mmio_reg)));
 
 	return 0;
 }
@@ -666,7 +667,7 @@ guc_capture_output_min_size_est(struct intel_guc *guc)
 	struct intel_gt *gt = guc_to_gt(guc);
 	struct intel_engine_cs *engine;
 	enum intel_engine_id id;
-	int worst_min_size = 0, num_regs = 0;
+	int worst_min_size = 0;
 	size_t tmp = 0;
 
 	if (!guc->capture)
@@ -688,20 +689,18 @@ guc_capture_output_min_size_est(struct intel_guc *guc)
 					 (3 * sizeof(struct guc_state_capture_header_t));
 
 		if (!guc_capture_getlistsize(guc, 0, GUC_CAPTURE_LIST_TYPE_GLOBAL, 0, &tmp, true))
-			num_regs += tmp;
+			worst_min_size += tmp;
 
 		if (!guc_capture_getlistsize(guc, 0, GUC_CAPTURE_LIST_TYPE_ENGINE_CLASS,
 					     engine->class, &tmp, true)) {
-			num_regs += tmp;
+			worst_min_size += tmp;
 		}
 		if (!guc_capture_getlistsize(guc, 0, GUC_CAPTURE_LIST_TYPE_ENGINE_INSTANCE,
 					     engine->class, &tmp, true)) {
-			num_regs += tmp;
+			worst_min_size += tmp;
 		}
 	}
 
-	worst_min_size += (num_regs * sizeof(struct guc_mmio_reg));
-
 	return worst_min_size;
 }
 
@@ -718,15 +717,23 @@ static void check_guc_capture_size(struct intel_guc *guc)
 	int spare_size = min_size * GUC_CAPTURE_OVERBUFFER_MULTIPLIER;
 	u32 buffer_size = intel_guc_log_section_size_capture(&guc->log);
 
+	/*
+	 * NOTE: min_size is much smaller than the capture region allocation (DG2: <80K vs 1MB)
+	 * Additionally, its based on space needed to fit all engines getting reset at once
+	 * within the same G2H handler task slot. This is very unlikely. However, if GuC really
+	 * does run out of space for whatever reason, we will see an separate warning message
+	 * when processing the G2H event capture-notification, search for:
+	 * INTEL_GUC_STATE_CAPTURE_EVENT_STATUS_NOSPACE.
+	 */
 	if (min_size < 0)
 		drm_warn(&i915->drm, "Failed to calculate GuC error state capture buffer minimum size: %d!\n",
 			 min_size);
 	else if (min_size > buffer_size)
-		drm_warn(&i915->drm, "GuC error state capture buffer is too small: %d < %d\n",
+		drm_warn(&i915->drm, "GuC error state capture buffer maybe small: %d < %d\n",
 			 buffer_size, min_size);
 	else if (spare_size > buffer_size)
-		drm_notice(&i915->drm, "GuC error state capture buffer maybe too small: %d < %d (min = %d)\n",
-			   buffer_size, spare_size, min_size);
+		drm_dbg(&i915->drm, "GuC error state capture buffer lacks spare size: %d < %d (min = %d)\n",
+			buffer_size, spare_size, min_size);
 }
 
 /*
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_log.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_log.c
index 2b878030d3e1..8d755d285247 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_log.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_log.c
@@ -16,15 +16,15 @@
 #if defined(CONFIG_DRM_I915_DEBUG_GUC)
 #define GUC_LOG_DEFAULT_CRASH_BUFFER_SIZE	SZ_2M
 #define GUC_LOG_DEFAULT_DEBUG_BUFFER_SIZE	SZ_16M
-#define GUC_LOG_DEFAULT_CAPTURE_BUFFER_SIZE	SZ_4M
+#define GUC_LOG_DEFAULT_CAPTURE_BUFFER_SIZE	SZ_1M
 #elif defined(CONFIG_DRM_I915_DEBUG_GEM)
 #define GUC_LOG_DEFAULT_CRASH_BUFFER_SIZE	SZ_1M
 #define GUC_LOG_DEFAULT_DEBUG_BUFFER_SIZE	SZ_2M
-#define GUC_LOG_DEFAULT_CAPTURE_BUFFER_SIZE	SZ_4M
+#define GUC_LOG_DEFAULT_CAPTURE_BUFFER_SIZE	SZ_1M
 #else
 #define GUC_LOG_DEFAULT_CRASH_BUFFER_SIZE	SZ_8K
 #define GUC_LOG_DEFAULT_DEBUG_BUFFER_SIZE	SZ_64K
-#define GUC_LOG_DEFAULT_CAPTURE_BUFFER_SIZE	SZ_2M
+#define GUC_LOG_DEFAULT_CAPTURE_BUFFER_SIZE	SZ_1M
 #endif
 
 static void guc_log_copy_debuglogs_for_relay(struct intel_guc_log *log);
-- 
2.35.1



