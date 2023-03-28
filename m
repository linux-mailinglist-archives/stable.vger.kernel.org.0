Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A0D6CC2A9
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbjC1Orb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233273AbjC1OrT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:47:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21611D539
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:46:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9E7F5CE1DA1
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:46:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EE9C433EF;
        Tue, 28 Mar 2023 14:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014793;
        bh=FYkuUBMAd/7uNUhkt0DBP5K4FPPU/LDpCkKi8+0Kk/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VkTBQ3Fvmtw6JkfrdEDhKHwIUJjHu+IeJ+2lyXMbztOFBOzyAPEnNAh169aFQFPAL
         keQBt6eYyPZxBg8FBwfp/bLrnbvl39EQIZqktYPNyc/oHxo5cCnac1QcLhve3rZmDZ
         Z01BUpPyYdElFWRWrqh/6/DkxLBscteMo4NcMZ6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Badal Nilawar <badal.nilawar@intel.com>,
        Anshuman Gupta <anshuman.gupta@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 054/240] drm/i915/mtl: Disable MC6 for MTL A step
Date:   Tue, 28 Mar 2023 16:40:17 +0200
Message-Id: <20230328142621.963423625@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Badal Nilawar <badal.nilawar@intel.com>

[ Upstream commit 088a422c3fa3ee9268d400078626b0c202cfe9dd ]

The Wa_14017073508 require to send Media Busy/Idle mailbox while
accessing Media tile. As of now it is getting handled while __gt_unpark,
__gt_park. But there are various corner cases where forcewakes are taken
without __gt_unpark i.e. without sending Busy Mailbox especially during
register reads. Forcewakes are taken without busy mailbox leads to
GPU HANG. So bringing mailbox calls under forcewake calls are no feasible
option as forcewake calls are atomic and mailbox calls are blocking.
The issue already fixed in B step so disabling MC6 on A step and
reverting previous commit which handles Wa_14017073508

Fixes: 8f70f1ec587d ("drm/i915/mtl: Add Wa_14017073508 for SAMedia")
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Badal Nilawar <badal.nilawar@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Anshuman Gupta <anshuman.gupta@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230310061339.2495416-2-badal.nilawar@intel.com
(cherry picked from commit 038a24835ab68f341eaa7a0e3bcc6ce0f9b22e17)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_gt_pm.c     | 27 -----------------------
 drivers/gpu/drm/i915/gt/intel_rc6.c       |  8 +++++++
 drivers/gpu/drm/i915/gt/uc/intel_guc_rc.c | 13 +----------
 drivers/gpu/drm/i915/i915_reg.h           |  9 --------
 4 files changed, 9 insertions(+), 48 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_gt_pm.c b/drivers/gpu/drm/i915/gt/intel_gt_pm.c
index 16db85fab0b19..3fbf70a587474 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_pm.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt_pm.c
@@ -20,31 +20,10 @@
 #include "intel_rc6.h"
 #include "intel_rps.h"
 #include "intel_wakeref.h"
-#include "intel_pcode.h"
 #include "pxp/intel_pxp_pm.h"
 
 #define I915_GT_SUSPEND_IDLE_TIMEOUT (HZ / 2)
 
-static void mtl_media_busy(struct intel_gt *gt)
-{
-	/* Wa_14017073508: mtl */
-	if (IS_MTL_GRAPHICS_STEP(gt->i915, P, STEP_A0, STEP_B0) &&
-	    gt->type == GT_MEDIA)
-		snb_pcode_write_p(gt->uncore, PCODE_MBOX_GT_STATE,
-				  PCODE_MBOX_GT_STATE_MEDIA_BUSY,
-				  PCODE_MBOX_GT_STATE_DOMAIN_MEDIA, 0);
-}
-
-static void mtl_media_idle(struct intel_gt *gt)
-{
-	/* Wa_14017073508: mtl */
-	if (IS_MTL_GRAPHICS_STEP(gt->i915, P, STEP_A0, STEP_B0) &&
-	    gt->type == GT_MEDIA)
-		snb_pcode_write_p(gt->uncore, PCODE_MBOX_GT_STATE,
-				  PCODE_MBOX_GT_STATE_MEDIA_NOT_BUSY,
-				  PCODE_MBOX_GT_STATE_DOMAIN_MEDIA, 0);
-}
-
 static void user_forcewake(struct intel_gt *gt, bool suspend)
 {
 	int count = atomic_read(&gt->user_wakeref);
@@ -92,9 +71,6 @@ static int __gt_unpark(struct intel_wakeref *wf)
 
 	GT_TRACE(gt, "\n");
 
-	/* Wa_14017073508: mtl */
-	mtl_media_busy(gt);
-
 	/*
 	 * It seems that the DMC likes to transition between the DC states a lot
 	 * when there are no connected displays (no active power domains) during
@@ -144,9 +120,6 @@ static int __gt_park(struct intel_wakeref *wf)
 	GEM_BUG_ON(!wakeref);
 	intel_display_power_put_async(i915, POWER_DOMAIN_GT_IRQ, wakeref);
 
-	/* Wa_14017073508: mtl */
-	mtl_media_idle(gt);
-
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/i915/gt/intel_rc6.c b/drivers/gpu/drm/i915/gt/intel_rc6.c
index 2ee4051e4d961..6184fcc169877 100644
--- a/drivers/gpu/drm/i915/gt/intel_rc6.c
+++ b/drivers/gpu/drm/i915/gt/intel_rc6.c
@@ -486,6 +486,7 @@ static bool bxt_check_bios_rc6_setup(struct intel_rc6 *rc6)
 static bool rc6_supported(struct intel_rc6 *rc6)
 {
 	struct drm_i915_private *i915 = rc6_to_i915(rc6);
+	struct intel_gt *gt = rc6_to_gt(rc6);
 
 	if (!HAS_RC6(i915))
 		return false;
@@ -502,6 +503,13 @@ static bool rc6_supported(struct intel_rc6 *rc6)
 		return false;
 	}
 
+	if (IS_MTL_MEDIA_STEP(gt->i915, STEP_A0, STEP_B0) &&
+	    gt->type == GT_MEDIA) {
+		drm_notice(&i915->drm,
+			   "Media RC6 disabled on A step\n");
+		return false;
+	}
+
 	return true;
 }
 
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_rc.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_rc.c
index b5855091cf6a9..8f8dd05835c5a 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_rc.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_rc.c
@@ -11,20 +11,9 @@
 
 static bool __guc_rc_supported(struct intel_guc *guc)
 {
-	struct intel_gt *gt = guc_to_gt(guc);
-
-	/*
-	 * Wa_14017073508: mtl
-	 * Do not enable gucrc to avoid additional interrupts which
-	 * may disrupt pcode wa.
-	 */
-	if (IS_MTL_GRAPHICS_STEP(gt->i915, P, STEP_A0, STEP_B0) &&
-	    gt->type == GT_MEDIA)
-		return false;
-
 	/* GuC RC is unavailable for pre-Gen12 */
 	return guc->submission_supported &&
-		GRAPHICS_VER(gt->i915) >= 12;
+		GRAPHICS_VER(guc_to_gt(guc)->i915) >= 12;
 }
 
 static bool __guc_rc_selected(struct intel_guc *guc)
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 9161768725449..4f84cda3f9b5e 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -6616,15 +6616,6 @@
 /*   XEHP_PCODE_FREQUENCY_CONFIG param2 */
 #define     PCODE_MBOX_DOMAIN_NONE		0x0
 #define     PCODE_MBOX_DOMAIN_MEDIAFF		0x3
-
-/* Wa_14017210380: mtl */
-#define   PCODE_MBOX_GT_STATE			0x50
-/* sub-commands (param1) */
-#define     PCODE_MBOX_GT_STATE_MEDIA_BUSY	0x1
-#define     PCODE_MBOX_GT_STATE_MEDIA_NOT_BUSY	0x2
-/* param2 */
-#define     PCODE_MBOX_GT_STATE_DOMAIN_MEDIA	0x1
-
 #define GEN6_PCODE_DATA				_MMIO(0x138128)
 #define   GEN6_PCODE_FREQ_IA_RATIO_SHIFT	8
 #define   GEN6_PCODE_FREQ_RING_RATIO_SHIFT	16
-- 
2.39.2



