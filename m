Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B122B314622
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 03:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhBICVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 21:21:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:14746 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229683AbhBICVK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 21:21:10 -0500
IronPort-SDR: O6LSxs1uecRWtrZEH8ZuBriNB4yh8PV6drK0yPj+CDnKMDUsBij65y7gfxVOJ/wRruJ0xLXnFF
 BZgad9gKFYGQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="200883083"
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="200883083"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 18:19:24 -0800
IronPort-SDR: 1jbcVHYf39RRD4rtwe6dTx0zixvQAT3ZaLNzTf3lO5YW7n7PaCNbvXzS62dYaliSt5B3ja3ekm
 PUMNIvOe1B+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="395864610"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by orsmga008.jf.intel.com with SMTP; 08 Feb 2021 18:19:22 -0800
Received: by stinkbox (sSMTP sendmail emulation); Tue, 09 Feb 2021 04:19:21 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 2/3] drm/i915: Fix overlay frontbuffer tracking
Date:   Tue,  9 Feb 2021 04:19:17 +0200
Message-Id: <20210209021918.16234-2-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210209021918.16234-1-ville.syrjala@linux.intel.com>
References: <20210209021918.16234-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

We don't have a persistent fb holding a reference to the frontbuffer
object, so every time we do the get+put we throw the frontbuffer object
immediately away. And so the next time around we get a pristine
frontbuffer object with bits==0 even for the old vma. This confuses
the frontbuffer tracking code which understandably expects the old
frontbuffer to have the overlay's bit set.

Fix this by hanging on to the frontbuffer reference until the next
flip. And just to make this a bit more clear let's track the frontbuffer
explicitly instead of just grabbing it via the old vma.

Cc: stable@vger.kernel.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1136
Fixes: da42104f589d ("drm/i915: Hold reference to intel_frontbuffer as we track activity")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_overlay.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_overlay.c b/drivers/gpu/drm/i915/display/intel_overlay.c
index 9c0113f15b58..ef8f44f5e751 100644
--- a/drivers/gpu/drm/i915/display/intel_overlay.c
+++ b/drivers/gpu/drm/i915/display/intel_overlay.c
@@ -183,6 +183,7 @@ struct intel_overlay {
 	struct intel_crtc *crtc;
 	struct i915_vma *vma;
 	struct i915_vma *old_vma;
+	struct intel_frontbuffer *frontbuffer;
 	bool active;
 	bool pfit_active;
 	u32 pfit_vscale_ratio; /* shifted-point number, (1<<12) == 1.0 */
@@ -283,21 +284,19 @@ static void intel_overlay_flip_prepare(struct intel_overlay *overlay,
 				       struct i915_vma *vma)
 {
 	enum pipe pipe = overlay->crtc->pipe;
-	struct intel_frontbuffer *from = NULL, *to = NULL;
+	struct intel_frontbuffer *frontbuffer = NULL;
 
 	drm_WARN_ON(&overlay->i915->drm, overlay->old_vma);
 
-	if (overlay->vma)
-		from = intel_frontbuffer_get(overlay->vma->obj);
 	if (vma)
-		to = intel_frontbuffer_get(vma->obj);
+		frontbuffer = intel_frontbuffer_get(vma->obj);
 
-	intel_frontbuffer_track(from, to, INTEL_FRONTBUFFER_OVERLAY(pipe));
+	intel_frontbuffer_track(overlay->frontbuffer, frontbuffer,
+				INTEL_FRONTBUFFER_OVERLAY(pipe));
 
-	if (to)
-		intel_frontbuffer_put(to);
-	if (from)
-		intel_frontbuffer_put(from);
+	if (overlay->frontbuffer)
+		intel_frontbuffer_put(overlay->frontbuffer);
+	overlay->frontbuffer = frontbuffer;
 
 	intel_frontbuffer_flip_prepare(overlay->i915,
 				       INTEL_FRONTBUFFER_OVERLAY(pipe));
-- 
2.26.2

