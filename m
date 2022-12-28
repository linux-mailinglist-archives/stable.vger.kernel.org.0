Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE654657BF2
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233767AbiL1P1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:27:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbiL1P1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:27:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3BBC140A7
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:27:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6078B6155C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:27:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703E9C433D2;
        Wed, 28 Dec 2022 15:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241223;
        bh=OsehrfCVepzrLYG4MYBET54fV+NhEi8UBELSWQAqfRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XeBTskXfWXiL4VhSwGaBuID3wTCb1Ze5nyOj08IKb4F+RsPkISaNLOJykD6HpDpC5
         jPk+z5S0ByOMCwKcURA+DdQFUEAQLBuR3DxdeLtxbfXw144wmnXD2D7XsJEosPcg4p
         iS2gc5YEzLXzd16+SkExIGyV3lBi0h22KU8gh7Eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alan Previn <alan.previn.teres.alexis@intel.com>,
        John Harrison <John.C.Harrison@Intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0255/1073] drm/i915/guc: Add error-capture init warnings when needed
Date:   Wed, 28 Dec 2022 15:30:43 +0100
Message-Id: <20221228144334.946333873@linuxfoundation.org>
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

[ Upstream commit a894077890ad118de88c97c03f67a611ca60882a ]

If GuC is being used and we initialized GuC-error-capture,
we need to be warning if we don't provide an error-capture
register list in the firmware ADS, for valid GT engines.
A warning makes sense as this would impact debugability
without realizing why a reglist wasn't retrieved and reported
by GuC.

However, depending on the platform, we might have certain
engines that have a register list for engine instance error state
but not for engine class. Thus, add a check only to warn if the
register list was non existent vs an empty list (use the
empty lists to skip the warning).

NOTE: if a future platform were to introduce new registers
in place of what was an empty list on existing / legacy hardware
engines no warning is provided as the empty list is meant
to be used intentionally. As an example, if a future hardware
were to add blitter engine-class-registers (new) on top
of the legacy blitter engine-instance-register (HEAD, TAIL, etc.),
no warning is generated.

Signed-off-by: Alan Previn <alan.previn.teres.alexis@intel.com>
Reviewed-by: John Harrison <John.C.Harrison@Intel.com>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221019072930.17755-2-alan.previn.teres.alexis@intel.com
Stable-dep-of: befb231d5de2 ("drm/i915/guc: Fix GuC error capture sizing estimation and reporting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/i915/gt/uc/intel_guc_capture.c    | 78 ++++++++++++++++---
 1 file changed, 69 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c
index d2ac53d4f3b6..c398bdd5403a 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c
@@ -419,6 +419,44 @@ guc_capture_get_device_reglist(struct intel_guc *guc)
 	return default_lists;
 }
 
+static const char *
+__stringify_type(u32 type)
+{
+	switch (type) {
+	case GUC_CAPTURE_LIST_TYPE_GLOBAL:
+		return "Global";
+	case GUC_CAPTURE_LIST_TYPE_ENGINE_CLASS:
+		return "Class";
+	case GUC_CAPTURE_LIST_TYPE_ENGINE_INSTANCE:
+		return "Instance";
+	default:
+		break;
+	}
+
+	return "unknown";
+}
+
+static const char *
+__stringify_engclass(u32 class)
+{
+	switch (class) {
+	case GUC_RENDER_CLASS:
+		return "Render";
+	case GUC_VIDEO_CLASS:
+		return "Video";
+	case GUC_VIDEOENHANCE_CLASS:
+		return "VideoEnhance";
+	case GUC_BLITTER_CLASS:
+		return "Blitter";
+	case GUC_COMPUTE_CLASS:
+		return "Compute";
+	default:
+		break;
+	}
+
+	return "unknown";
+}
+
 static int
 guc_capture_list_init(struct intel_guc *guc, u32 owner, u32 type, u32 classid,
 		      struct guc_mmio_reg *ptr, u16 num_entries)
@@ -482,23 +520,38 @@ guc_cap_list_num_regs(struct intel_guc_state_capture *gc, u32 owner, u32 type, u
 	return num_regs;
 }
 
-int
-intel_guc_capture_getlistsize(struct intel_guc *guc, u32 owner, u32 type, u32 classid,
-			      size_t *size)
+static int
+guc_capture_getlistsize(struct intel_guc *guc, u32 owner, u32 type, u32 classid,
+			size_t *size, bool is_purpose_est)
 {
 	struct intel_guc_state_capture *gc = guc->capture;
+	struct drm_i915_private *i915 = guc_to_gt(guc)->i915;
 	struct __guc_capture_ads_cache *cache = &gc->ads_cache[owner][type][classid];
 	int num_regs;
 
-	if (!gc->reglists)
+	if (!gc->reglists) {
+		drm_warn(&i915->drm, "GuC-capture: No reglist on this device\n");
 		return -ENODEV;
+	}
 
 	if (cache->is_valid) {
 		*size = cache->size;
 		return cache->status;
 	}
 
+	if (!is_purpose_est && owner == GUC_CAPTURE_LIST_INDEX_PF &&
+	    !guc_capture_get_one_list(gc->reglists, owner, type, classid)) {
+		if (type == GUC_CAPTURE_LIST_TYPE_GLOBAL)
+			drm_warn(&i915->drm, "Missing GuC-Err-Cap reglist Global!\n");
+		else
+			drm_warn(&i915->drm, "Missing GuC-Err-Cap reglist %s(%u):%s(%u)!\n",
+				 __stringify_type(type), type,
+				 __stringify_engclass(classid), classid);
+		return -ENODATA;
+	}
+
 	num_regs = guc_cap_list_num_regs(gc, owner, type, classid);
+	/* intentional empty lists can exist depending on hw config */
 	if (!num_regs)
 		return -ENODATA;
 
@@ -508,6 +561,13 @@ intel_guc_capture_getlistsize(struct intel_guc *guc, u32 owner, u32 type, u32 cl
 	return 0;
 }
 
+int
+intel_guc_capture_getlistsize(struct intel_guc *guc, u32 owner, u32 type, u32 classid,
+			      size_t *size)
+{
+	return guc_capture_getlistsize(guc, owner, type, classid, size, false);
+}
+
 static void guc_capture_create_prealloc_nodes(struct intel_guc *guc);
 
 int
@@ -627,15 +687,15 @@ guc_capture_output_min_size_est(struct intel_guc *guc)
 		worst_min_size += sizeof(struct guc_state_capture_group_header_t) +
 					 (3 * sizeof(struct guc_state_capture_header_t));
 
-		if (!intel_guc_capture_getlistsize(guc, 0, GUC_CAPTURE_LIST_TYPE_GLOBAL, 0, &tmp))
+		if (!guc_capture_getlistsize(guc, 0, GUC_CAPTURE_LIST_TYPE_GLOBAL, 0, &tmp, true))
 			num_regs += tmp;
 
-		if (!intel_guc_capture_getlistsize(guc, 0, GUC_CAPTURE_LIST_TYPE_ENGINE_CLASS,
-						   engine->class, &tmp)) {
+		if (!guc_capture_getlistsize(guc, 0, GUC_CAPTURE_LIST_TYPE_ENGINE_CLASS,
+					     engine->class, &tmp, true)) {
 			num_regs += tmp;
 		}
-		if (!intel_guc_capture_getlistsize(guc, 0, GUC_CAPTURE_LIST_TYPE_ENGINE_INSTANCE,
-						   engine->class, &tmp)) {
+		if (!guc_capture_getlistsize(guc, 0, GUC_CAPTURE_LIST_TYPE_ENGINE_INSTANCE,
+					     engine->class, &tmp, true)) {
 			num_regs += tmp;
 		}
 	}
-- 
2.35.1



