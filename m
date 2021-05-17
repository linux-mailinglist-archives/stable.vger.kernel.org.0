Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 317AD382760
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 10:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235721AbhEQIsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 04:48:13 -0400
Received: from mga06.intel.com ([134.134.136.31]:16515 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235718AbhEQIsK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 04:48:10 -0400
IronPort-SDR: mlm9sBOno+sxetPuwKyHpbKws5oJuF35GiUbHg93gbrMIciB73+8bIzA25acE84/vjAaCWtn4+
 oTzscMDSASQQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9986"; a="261655878"
X-IronPort-AV: E=Sophos;i="5.82,306,1613462400"; 
   d="scan'208";a="261655878"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 01:46:54 -0700
IronPort-SDR: qbnw3j/sMfnpND7O8/DvWfpGFo0sYfwtiNxOnebd0UPggG7Uuk+I075QNOhjLNc92YdaN8G6mb
 hoXrMONyEjGg==
X-IronPort-AV: E=Sophos;i="5.82,306,1613462400"; 
   d="scan'208";a="438820736"
Received: from cqi-mobl.ccr.corp.intel.com (HELO mwauld-desk1.intel.com) ([10.215.160.214])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 01:46:50 -0700
From:   Matthew Auld <matthew.auld@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH] drm/i915/gem: Pin the L-shape quirked object as unshrinkable
Date:   Mon, 17 May 2021 09:46:40 +0100
Message-Id: <20210517084640.18862-1-matthew.auld@intel.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

When instantiating a tiled object on an L-shaped memory machine, we mark
the object as unshrinkable to prevent the shrinker from trying to swap
out the pages. We have to do this as we do not know the swizzling on the
individual pages, and so the data will be scrambled across swap out/in.

Not only do we need to move the object off the shrinker list, we need to
mark the object with shrink_pin so that the counter is consistent across
calls to madvise.

v2: in the madvise ioctl we need to check if the object is currently
shrinkable/purgeable, not if the object type supports shrinking

Fixes: 0175969e489a ("drm/i915/gem: Use shrinkable status for unknown swizzle quirks")
References: https://gitlab.freedesktop.org/drm/intel/-/issues/3293
References: https://gitlab.freedesktop.org/drm/intel/-/issues/3450
Reported-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Tested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: <stable@vger.kernel.org> # v5.12+
---
 drivers/gpu/drm/i915/gem/i915_gem_pages.c |  2 ++
 drivers/gpu/drm/i915/i915_gem.c           | 11 +++++------
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_pages.c b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
index aed8a37ccdc9..7361971c177d 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
@@ -63,6 +63,8 @@ void __i915_gem_object_set_pages(struct drm_i915_gem_object *obj,
 	    i915->quirks & QUIRK_PIN_SWIZZLED_PAGES) {
 		GEM_BUG_ON(i915_gem_object_has_tiling_quirk(obj));
 		i915_gem_object_set_tiling_quirk(obj);
+		GEM_BUG_ON(!list_empty(&obj->mm.link));
+		atomic_inc(&obj->mm.shrink_pin);
 		shrinkable = false;
 	}
 
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index d0018c5f88bd..cffd7f4f87dc 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1009,12 +1009,11 @@ i915_gem_madvise_ioctl(struct drm_device *dev, void *data,
 		obj->mm.madv = args->madv;
 
 	if (i915_gem_object_has_pages(obj)) {
-		struct list_head *list;
+		unsigned long flags;
 
-		if (i915_gem_object_is_shrinkable(obj)) {
-			unsigned long flags;
-
-			spin_lock_irqsave(&i915->mm.obj_lock, flags);
+		spin_lock_irqsave(&i915->mm.obj_lock, flags);
+		if (!list_empty(&obj->mm.link)) {
+			struct list_head *list;
 
 			if (obj->mm.madv != I915_MADV_WILLNEED)
 				list = &i915->mm.purge_list;
@@ -1022,8 +1021,8 @@ i915_gem_madvise_ioctl(struct drm_device *dev, void *data,
 				list = &i915->mm.shrink_list;
 			list_move_tail(&obj->mm.link, list);
 
-			spin_unlock_irqrestore(&i915->mm.obj_lock, flags);
 		}
+		spin_unlock_irqrestore(&i915->mm.obj_lock, flags);
 	}
 
 	/* if the object is no longer attached, discard its backing storage */
-- 
2.26.3

