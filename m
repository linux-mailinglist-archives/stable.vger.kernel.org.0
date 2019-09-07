Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56CD2AC55A
	for <lists+stable@lfdr.de>; Sat,  7 Sep 2019 10:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406506AbfIGIfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Sep 2019 04:35:21 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:50982 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726027AbfIGIfV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Sep 2019 04:35:21 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 18406665-1500050 
        for multiple; Sat, 07 Sep 2019 09:35:15 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Martin Peres <martin.peres@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915: Perform GGTT restore much earlier during resume
Date:   Sat,  7 Sep 2019 09:35:13 +0100
Message-Id: <20190907083513.28625-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As soon as we re-enable the various functions within the HW, they may go
off and read data via a GGTT offset. Hence, if we have not yet restored
the GGTT PTE before then, they may read and even *write* random locations
in memory.

Detected by DMAR faults during resume.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Martin Peres <martin.peres@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/gem/i915_gem_pm.c | 3 ---
 drivers/gpu/drm/i915/i915_drv.c        | 5 +++++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_pm.c b/drivers/gpu/drm/i915/gem/i915_gem_pm.c
index b3993d24b83d..9b1129aaacfe 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_pm.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_pm.c
@@ -242,9 +242,6 @@ void i915_gem_resume(struct drm_i915_private *i915)
 	mutex_lock(&i915->drm.struct_mutex);
 	intel_uncore_forcewake_get(&i915->uncore, FORCEWAKE_ALL);
 
-	i915_gem_restore_gtt_mappings(i915);
-	i915_gem_restore_fences(i915);
-
 	if (i915_gem_init_hw(i915))
 		goto err_wedged;
 
diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 7b2c81a8bbaa..1af4eba968c0 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -1877,6 +1877,11 @@ static int i915_drm_resume(struct drm_device *dev)
 	if (ret)
 		DRM_ERROR("failed to re-enable GGTT\n");
 
+	mutex_lock(&dev_priv->drm.struct_mutex);
+	i915_gem_restore_gtt_mappings(dev_priv);
+	i915_gem_restore_fences(dev_priv);
+	mutex_unlock(&dev_priv->drm.struct_mutex);
+
 	intel_csr_ucode_resume(dev_priv);
 
 	i915_restore_state(dev_priv);
-- 
2.23.0

