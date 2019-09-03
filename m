Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA54AA7042
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730604AbfICQ0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:26:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730602AbfICQ0T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:26:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B02C238CE;
        Tue,  3 Sep 2019 16:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527979;
        bh=eK+L9MGfvPLzftIEDXerbgiNvYTvBEHJUW/ZcohqNQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0aYXvjI637FZDGFn+OUoO1heyMML8XpiH82IRX6SFiWP2VExCSySFfJLNwlAU3x9M
         9DqHBhSR0Evu5NeljLb+eX2QH5nrY/HvEUch3CkUMQ6PxipQI4Wolx7tVXdPvCVztS
         7/DtvTmi6ivZMFj+fLVukkJUpeSBJu8dR+Wr+H5w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 034/167] drm/i915: Cleanup gt powerstate from gem
Date:   Tue,  3 Sep 2019 12:23:06 -0400
Message-Id: <20190903162519.7136-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

[ Upstream commit 30b710840e4b9c9699d3d4b33fb19ad8880d4614 ]

Since the gt powerstate is allocated by i915_gem_init, clean it from
i915_gem_fini for symmetry and to correct the imbalance on error.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20180812223642.24865-1-chris@chris-wilson.co.uk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_gem.c      | 3 +++
 drivers/gpu/drm/i915/intel_display.c | 4 ----
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 5019dfd8bcf16..e81abd468a15d 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -5624,6 +5624,7 @@ int i915_gem_init(struct drm_i915_private *dev_priv)
 void i915_gem_fini(struct drm_i915_private *dev_priv)
 {
 	i915_gem_suspend_late(dev_priv);
+	intel_disable_gt_powersave(dev_priv);
 
 	/* Flush any outstanding unpin_work. */
 	i915_gem_drain_workqueue(dev_priv);
@@ -5635,6 +5636,8 @@ void i915_gem_fini(struct drm_i915_private *dev_priv)
 	i915_gem_contexts_fini(dev_priv);
 	mutex_unlock(&dev_priv->drm.struct_mutex);
 
+	intel_cleanup_gt_powersave(dev_priv);
+
 	intel_uc_fini_misc(dev_priv);
 	i915_gem_cleanup_userptr(dev_priv);
 
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 2622dfc7d2d9a..6902fd2da19ca 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -15972,8 +15972,6 @@ void intel_modeset_cleanup(struct drm_device *dev)
 	flush_work(&dev_priv->atomic_helper.free_work);
 	WARN_ON(!llist_empty(&dev_priv->atomic_helper.free_list));
 
-	intel_disable_gt_powersave(dev_priv);
-
 	/*
 	 * Interrupts and polling as the first thing to avoid creating havoc.
 	 * Too much stuff here (turning of connectors, ...) would
@@ -16001,8 +15999,6 @@ void intel_modeset_cleanup(struct drm_device *dev)
 
 	intel_cleanup_overlay(dev_priv);
 
-	intel_cleanup_gt_powersave(dev_priv);
-
 	intel_teardown_gmbus(dev_priv);
 
 	destroy_workqueue(dev_priv->modeset_wq);
-- 
2.20.1

