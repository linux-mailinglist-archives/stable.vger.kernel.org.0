Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946633F6408
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234442AbhHXRAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:00:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236021AbhHXQ6m (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:58:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17FA1613BD;
        Tue, 24 Aug 2021 16:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824239;
        bh=+m/H46yUj6Pnb1GVwDaYm+DyOa2Z7PlBMv1Qyhe2ebM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NGRyaXdne5C5RcEb00fDoHMzBBs8qOmsezK3toZAs/y1iQQfMJpvkQOf5BYiu9/Ey
         vA9mhBFmFZ2yr+Zaw3d/FPALCjBu5YhkXg2M/7u+3sPHAW7fmmkM6ZCK/rHMlWYKs2
         XjSNYSSQbBQA01ZEyECj/SH9LQ+bLNmCebbGFpFJnwGMbl52/CSsa7VBEo2TC7oIW7
         4pRw97z7KbgQDPWTJFkBDQEi6rFPuvb5Xr8h0VTomarYEsArM0DF8iLu4qcE4VnQc9
         WxG4LKIosKTnpCqHrQoee7pOdYZP8SVMfFdQs9Se7kpaJDiEK7qjPknEMfKQrgLZpg
         TWwoxPu3ucKdg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anshuman Gupta <anshuman.gupta@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 072/127] drm/i915: Tweaked Wa_14010685332 for all PCHs
Date:   Tue, 24 Aug 2021 12:55:12 -0400
Message-Id: <20210824165607.709387-73-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anshuman Gupta <anshuman.gupta@intel.com>

[ Upstream commit b8441b288d6031eac21390891ba36487b2cb398b ]

dispcnlunit1_cp_xosc_clkreq clock observed to be active on TGL-H platform
despite Wa_14010685332 original sequence,
thus blocks entry to deeper s0ix state.

The Tweaked Wa_14010685332 sequence fixes this issue, therefore use tweaked
Wa_14010685332 sequence for every PCH since PCH_CNP.

v2:
- removed RKL from comment and simplified condition. [Rodrigo]

Fixes: b896898c7369 ("drm/i915: Tweaked Wa_14010685332 for PCHs used on gen11 platforms")
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Signed-off-by: Anshuman Gupta <anshuman.gupta@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210810113112.31739-2-anshuman.gupta@intel.com
(cherry picked from commit 8b46cc6577f4bbef7e5909bb926da31d705f350f)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/i915/display/intel_display_power.c    | 16 +++++++-------
 drivers/gpu/drm/i915/i915_irq.c               | 21 -------------------
 2 files changed, 8 insertions(+), 29 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display_power.c b/drivers/gpu/drm/i915/display/intel_display_power.c
index 99126caf5747..a8597444d515 100644
--- a/drivers/gpu/drm/i915/display/intel_display_power.c
+++ b/drivers/gpu/drm/i915/display/intel_display_power.c
@@ -5910,13 +5910,13 @@ void intel_display_power_suspend_late(struct drm_i915_private *i915)
 {
 	if (DISPLAY_VER(i915) >= 11 || IS_GEN9_LP(i915)) {
 		bxt_enable_dc9(i915);
-		/* Tweaked Wa_14010685332:icp,jsp,mcc */
-		if (INTEL_PCH_TYPE(i915) >= PCH_ICP && INTEL_PCH_TYPE(i915) <= PCH_MCC)
-			intel_de_rmw(i915, SOUTH_CHICKEN1,
-				     SBCLK_RUN_REFCLK_DIS, SBCLK_RUN_REFCLK_DIS);
 	} else if (IS_HASWELL(i915) || IS_BROADWELL(i915)) {
 		hsw_enable_pc8(i915);
 	}
+
+	/* Tweaked Wa_14010685332:cnp,icp,jsp,mcc,tgp,adp */
+	if (INTEL_PCH_TYPE(i915) >= PCH_CNP && INTEL_PCH_TYPE(i915) < PCH_DG1)
+		intel_de_rmw(i915, SOUTH_CHICKEN1, SBCLK_RUN_REFCLK_DIS, SBCLK_RUN_REFCLK_DIS);
 }
 
 void intel_display_power_resume_early(struct drm_i915_private *i915)
@@ -5924,13 +5924,13 @@ void intel_display_power_resume_early(struct drm_i915_private *i915)
 	if (DISPLAY_VER(i915) >= 11 || IS_GEN9_LP(i915)) {
 		gen9_sanitize_dc_state(i915);
 		bxt_disable_dc9(i915);
-		/* Tweaked Wa_14010685332:icp,jsp,mcc */
-		if (INTEL_PCH_TYPE(i915) >= PCH_ICP && INTEL_PCH_TYPE(i915) <= PCH_MCC)
-			intel_de_rmw(i915, SOUTH_CHICKEN1, SBCLK_RUN_REFCLK_DIS, 0);
-
 	} else if (IS_HASWELL(i915) || IS_BROADWELL(i915)) {
 		hsw_disable_pc8(i915);
 	}
+
+	/* Tweaked Wa_14010685332:cnp,icp,jsp,mcc,tgp,adp */
+	if (INTEL_PCH_TYPE(i915) >= PCH_CNP && INTEL_PCH_TYPE(i915) < PCH_DG1)
+		intel_de_rmw(i915, SOUTH_CHICKEN1, SBCLK_RUN_REFCLK_DIS, 0);
 }
 
 void intel_display_power_suspend(struct drm_i915_private *i915)
diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index e0d0b300c4aa..783f25920d00 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -3042,24 +3042,6 @@ static void valleyview_irq_reset(struct drm_i915_private *dev_priv)
 	spin_unlock_irq(&dev_priv->irq_lock);
 }
 
-static void cnp_display_clock_wa(struct drm_i915_private *dev_priv)
-{
-	struct intel_uncore *uncore = &dev_priv->uncore;
-
-	/*
-	 * Wa_14010685332:cnp/cmp,tgp,adp
-	 * TODO: Clarify which platforms this applies to
-	 * TODO: Figure out if this workaround can be applied in the s0ix suspend/resume handlers as
-	 * on earlier platforms and whether the workaround is also needed for runtime suspend/resume
-	 */
-	if (INTEL_PCH_TYPE(dev_priv) == PCH_CNP ||
-	    (INTEL_PCH_TYPE(dev_priv) >= PCH_TGP && INTEL_PCH_TYPE(dev_priv) < PCH_DG1)) {
-		intel_uncore_rmw(uncore, SOUTH_CHICKEN1, SBCLK_RUN_REFCLK_DIS,
-				 SBCLK_RUN_REFCLK_DIS);
-		intel_uncore_rmw(uncore, SOUTH_CHICKEN1, SBCLK_RUN_REFCLK_DIS, 0);
-	}
-}
-
 static void gen8_display_irq_reset(struct drm_i915_private *dev_priv)
 {
 	struct intel_uncore *uncore = &dev_priv->uncore;
@@ -3093,7 +3075,6 @@ static void gen8_irq_reset(struct drm_i915_private *dev_priv)
 	if (HAS_PCH_SPLIT(dev_priv))
 		ibx_irq_reset(dev_priv);
 
-	cnp_display_clock_wa(dev_priv);
 }
 
 static void gen11_display_irq_reset(struct drm_i915_private *dev_priv)
@@ -3137,8 +3118,6 @@ static void gen11_display_irq_reset(struct drm_i915_private *dev_priv)
 
 	if (INTEL_PCH_TYPE(dev_priv) >= PCH_ICP)
 		GEN3_IRQ_RESET(uncore, SDE);
-
-	cnp_display_clock_wa(dev_priv);
 }
 
 static void gen11_irq_reset(struct drm_i915_private *dev_priv)
-- 
2.30.2

