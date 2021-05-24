Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6931E38EFDC
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234771AbhEXQAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:00:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235772AbhEXP7K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:59:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43A1561458;
        Mon, 24 May 2021 15:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871100;
        bh=eadT2zUv5c4+LfVwgG4BewoW5XfhCB48vrFx2JGtniw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iPYCi3jNlFz5QFivpIspq0pjPAZoNQCBNWDoodNWOsKQLe0oNwwgN2cfHnpB0Vo78
         VZ9rOt8veEG/6fk034R3aGYEhzfjKeoJSxNm+Hvu6m609ZvqO2iOiRmC05pxLmZT2W
         zRBf2uLqyekGAvZk+fcTTkhPOzKUoSmXcLhED2z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Matthew Auld <matthew.auld@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.12 074/127] drm/i915/gem: Pin the L-shape quirked object as unshrinkable
Date:   Mon, 24 May 2021 17:26:31 +0200
Message-Id: <20210524152337.361689558@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 036867e93ebf4d7e70eba6a8c72db74ee3760bc3 upstream.

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
Reported-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Tested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: <stable@vger.kernel.org> # v5.12+
Link: https://patchwork.freedesktop.org/patch/msgid/20210517084640.18862-1-matthew.auld@intel.com
(cherry picked from commit 8777d17b68dcfbfbd4d524f444adefae56f41225)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_pages.c |    2 ++
 drivers/gpu/drm/i915/i915_gem.c           |   11 +++++------
 2 files changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
@@ -63,6 +63,8 @@ void __i915_gem_object_set_pages(struct
 	    i915->quirks & QUIRK_PIN_SWIZZLED_PAGES) {
 		GEM_BUG_ON(i915_gem_object_has_tiling_quirk(obj));
 		i915_gem_object_set_tiling_quirk(obj);
+		GEM_BUG_ON(!list_empty(&obj->mm.link));
+		atomic_inc(&obj->mm.shrink_pin);
 		shrinkable = false;
 	}
 
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -972,12 +972,11 @@ i915_gem_madvise_ioctl(struct drm_device
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
@@ -985,8 +984,8 @@ i915_gem_madvise_ioctl(struct drm_device
 				list = &i915->mm.shrink_list;
 			list_move_tail(&obj->mm.link, list);
 
-			spin_unlock_irqrestore(&i915->mm.obj_lock, flags);
 		}
+		spin_unlock_irqrestore(&i915->mm.obj_lock, flags);
 	}
 
 	/* if the object is no longer attached, discard its backing storage */


