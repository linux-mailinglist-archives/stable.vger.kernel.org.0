Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBE8657C7A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233836AbiL1PdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:33:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233847AbiL1Pc5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:32:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA47B15FDC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:32:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20440B81716
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E14C433D2;
        Wed, 28 Dec 2022 15:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241572;
        bh=q105xRqxZikIOkvgMp4BgO/aQMyJ5kujQvzxvPi/V6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m6zeutHTIZl+YtjgSyHYCFaNDM5Mo6/TLK7eyWW6RPOVStrul5AAOvB3NJbkwl0zc
         Nmqtgljs+dX6sPyTao5B+dJM/7uIlxU930ywyijpBqtaHBl5yGEnm5c7IIuzABe4tL
         3syz8A7AblizhtIRm2EkBslje3KT9jRK+KzSMlgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0262/1146] drm/i915: Handle all GTs on driver (un)load paths
Date:   Wed, 28 Dec 2022 15:30:01 +0100
Message-Id: <20221228144337.253874090@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

[ Upstream commit f569ae759472fbe1f6fdddc7398360d43fdcc199 ]

This, along with the changes already landed in commit 1c66a12ab431
("drm/i915: Handle each GT on init/release and suspend/resume") makes
engines from all GTs actually known to the driver.

To accomplish this we need to sprinkle a lot of for_each_gt calls around
but is otherwise pretty un-eventuful.

v2:
 - Consolidate adjacent GT loops in a couple places.  (Daniele)

Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220915232654.3283095-5-matthew.d.roper@intel.com
Stable-dep-of: 1cacd6894d5f ("drm/i915/dgfx: Grab wakeref at i915_ttm_unmap_virtual")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_driver.c |  3 ++-
 drivers/gpu/drm/i915/i915_gem.c    | 43 +++++++++++++++++++++---------
 2 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_driver.c b/drivers/gpu/drm/i915/i915_driver.c
index f2a15d8155f4..2ce30cff461a 100644
--- a/drivers/gpu/drm/i915/i915_driver.c
+++ b/drivers/gpu/drm/i915/i915_driver.c
@@ -1662,7 +1662,8 @@ static int intel_runtime_suspend(struct device *kdev)
 
 		intel_runtime_pm_enable_interrupts(dev_priv);
 
-		intel_gt_runtime_resume(to_gt(dev_priv));
+		for_each_gt(gt, dev_priv, i)
+			intel_gt_runtime_resume(gt);
 
 		enable_rpm_wakeref_asserts(rpm);
 
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 2bdddb61ebd7..88df9a35e0fe 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1128,6 +1128,8 @@ void i915_gem_drain_workqueue(struct drm_i915_private *i915)
 
 int i915_gem_init(struct drm_i915_private *dev_priv)
 {
+	struct intel_gt *gt;
+	unsigned int i;
 	int ret;
 
 	/* We need to fallback to 4K pages if host doesn't support huge gtt. */
@@ -1158,9 +1160,11 @@ int i915_gem_init(struct drm_i915_private *dev_priv)
 	 */
 	intel_init_clock_gating(dev_priv);
 
-	ret = intel_gt_init(to_gt(dev_priv));
-	if (ret)
-		goto err_unlock;
+	for_each_gt(gt, dev_priv, i) {
+		ret = intel_gt_init(gt);
+		if (ret)
+			goto err_unlock;
+	}
 
 	return 0;
 
@@ -1173,8 +1177,13 @@ int i915_gem_init(struct drm_i915_private *dev_priv)
 err_unlock:
 	i915_gem_drain_workqueue(dev_priv);
 
-	if (ret != -EIO)
-		intel_uc_cleanup_firmwares(&to_gt(dev_priv)->uc);
+	if (ret != -EIO) {
+		for_each_gt(gt, dev_priv, i) {
+			intel_gt_driver_remove(gt);
+			intel_gt_driver_release(gt);
+			intel_uc_cleanup_firmwares(&gt->uc);
+		}
+	}
 
 	if (ret == -EIO) {
 		/*
@@ -1182,10 +1191,12 @@ int i915_gem_init(struct drm_i915_private *dev_priv)
 		 * as wedged. But we only want to do this when the GPU is angry,
 		 * for all other failure, such as an allocation failure, bail.
 		 */
-		if (!intel_gt_is_wedged(to_gt(dev_priv))) {
-			i915_probe_error(dev_priv,
-					 "Failed to initialize GPU, declaring it wedged!\n");
-			intel_gt_set_wedged(to_gt(dev_priv));
+		for_each_gt(gt, dev_priv, i) {
+			if (!intel_gt_is_wedged(gt)) {
+				i915_probe_error(dev_priv,
+						 "Failed to initialize GPU, declaring it wedged!\n");
+				intel_gt_set_wedged(gt);
+			}
 		}
 
 		/* Minimal basic recovery for KMS */
@@ -1213,10 +1224,14 @@ void i915_gem_driver_unregister(struct drm_i915_private *i915)
 
 void i915_gem_driver_remove(struct drm_i915_private *dev_priv)
 {
+	struct intel_gt *gt;
+	unsigned int i;
+
 	intel_wakeref_auto_fini(&to_gt(dev_priv)->userfault_wakeref);
 
 	i915_gem_suspend_late(dev_priv);
-	intel_gt_driver_remove(to_gt(dev_priv));
+	for_each_gt(gt, dev_priv, i)
+		intel_gt_driver_remove(gt);
 	dev_priv->uabi_engines = RB_ROOT;
 
 	/* Flush any outstanding unpin_work. */
@@ -1227,9 +1242,13 @@ void i915_gem_driver_remove(struct drm_i915_private *dev_priv)
 
 void i915_gem_driver_release(struct drm_i915_private *dev_priv)
 {
-	intel_gt_driver_release(to_gt(dev_priv));
+	struct intel_gt *gt;
+	unsigned int i;
 
-	intel_uc_cleanup_firmwares(&to_gt(dev_priv)->uc);
+	for_each_gt(gt, dev_priv, i) {
+		intel_gt_driver_release(gt);
+		intel_uc_cleanup_firmwares(&gt->uc);
+	}
 
 	/* Flush any outstanding work, including i915_gem_context.release_work. */
 	i915_gem_drain_workqueue(dev_priv);
-- 
2.35.1



