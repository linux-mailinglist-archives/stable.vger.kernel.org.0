Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7B59A7E6
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 08:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388946AbfHWG5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 02:57:42 -0400
Received: from mga14.intel.com ([192.55.52.115]:48558 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388916AbfHWG5l (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Aug 2019 02:57:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 23:57:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,420,1559545200"; 
   d="scan'208";a="179091192"
Received: from xzhan34-mobl3.bj.intel.com ([10.238.154.72])
  by fmsmga008.fm.intel.com with ESMTP; 22 Aug 2019 23:57:39 -0700
From:   Xiaolin Zhang <xiaolin.zhang@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org
Cc:     zhenyu.z.wang@intel.com, Xiaolin Zhang <xiaolin.zhang@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] drm/i915: to make vgpu ppgtt notificaiton as atomic operation
Date:   Fri, 23 Aug 2019 14:57:31 +0800
Message-Id: <1566543451-13955-1-git-send-email-xiaolin.zhang@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

vgpu ppgtt notification was split into 2 steps, the first step is to
update PVINFO's pdp register and then write PVINFO's g2v_notify register
with action code to tirgger ppgtt notification to GVT side.

currently these steps were not atomic operations due to no any protection,
so it is easy to enter race condition state during the MTBF, stress and
IGT test to cause GPU hang.

the solution is to add a lock to make vgpu ppgtt notication as atomic
operation.

Cc: stable@vger.kernel.org
Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
---
 drivers/gpu/drm/i915/i915_drv.h     | 1 +
 drivers/gpu/drm/i915/i915_gem_gtt.c | 4 ++++
 drivers/gpu/drm/i915/i915_vgpu.c    | 1 +
 3 files changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index eb31c16..32e17c4 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -961,6 +961,7 @@ struct i915_frontbuffer_tracking {
 };
 
 struct i915_virtual_gpu {
+	struct mutex lock;
 	bool active;
 	u32 caps;
 };
diff --git a/drivers/gpu/drm/i915/i915_gem_gtt.c b/drivers/gpu/drm/i915/i915_gem_gtt.c
index 2cd2dab..ff0b178 100644
--- a/drivers/gpu/drm/i915/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -833,6 +833,8 @@ static int gen8_ppgtt_notify_vgt(struct i915_ppgtt *ppgtt, bool create)
 	enum vgt_g2v_type msg;
 	int i;
 
+	mutex_lock(&dev_priv->vgpu.lock);
+
 	if (create)
 		atomic_inc(px_used(ppgtt->pd)); /* never remove */
 	else
@@ -860,6 +862,8 @@ static int gen8_ppgtt_notify_vgt(struct i915_ppgtt *ppgtt, bool create)
 
 	I915_WRITE(vgtif_reg(g2v_notify), msg);
 
+	mutex_unlock(&dev_priv->vgpu.lock);
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/i915/i915_vgpu.c b/drivers/gpu/drm/i915/i915_vgpu.c
index bf2b837..7493544 100644
--- a/drivers/gpu/drm/i915/i915_vgpu.c
+++ b/drivers/gpu/drm/i915/i915_vgpu.c
@@ -94,6 +94,7 @@ void i915_detect_vgpu(struct drm_i915_private *dev_priv)
 	dev_priv->vgpu.caps = readl(shared_area + vgtif_offset(vgt_caps));
 
 	dev_priv->vgpu.active = true;
+	mutex_init(&dev_priv->vgpu.lock);
 	DRM_INFO("Virtual GPU for Intel GVT-g detected.\n");
 
 out:
-- 
2.7.4

