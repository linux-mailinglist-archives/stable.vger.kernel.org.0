Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4562D285EA9
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 14:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgJGMDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 08:03:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:53865 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727861AbgJGMDd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Oct 2020 08:03:33 -0400
IronPort-SDR: blD4xUSA/X/IFcI7XC9aLb9dy7Peb69hXqg8YxtpMLoikmyW0eXs4a8LVaKf5Xwxu/uQKExgDy
 F5o6FIae0vkA==
X-IronPort-AV: E=McAfee;i="6000,8403,9766"; a="182383889"
X-IronPort-AV: E=Sophos;i="5.77,346,1596524400"; 
   d="scan'208";a="182383889"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 05:03:32 -0700
IronPort-SDR: 5IciWRUol0eucRyf79KKEpVjTJKH9fC/6OvYgm/2E5v4T8DnTEfAjWTMYp1lbG9LMGmIxo2SaT
 43n1mmQzZoyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,346,1596524400"; 
   d="scan'208";a="316183592"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by orsmga006.jf.intel.com with SMTP; 07 Oct 2020 05:03:30 -0700
Received: by stinkbox (sSMTP sendmail emulation); Wed, 07 Oct 2020 15:03:29 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH 1/3] drm/i915: Mark ininitial fb obj as WT on eLLC machines to avoid rcu lockup during fbdev init
Date:   Wed,  7 Oct 2020 15:03:27 +0300
Message-Id: <20201007120329.17076-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Currently we leave the cache_level of the initial fb obj
set to NONE. This means on eLLC machines the first pin_to_display()
will try to switch it to WT which requires a vma unbind+bind.
If that happens during the fbdev initialization rcu does not
seem operational which causes the unbind to get stuck. To
most appearances this looks like a dead machine on boot.

Avoid the unbind by already marking the object cache_level
as WT when creating it. We still do an excplicit ggtt pin
which will rewrite the PTEs anyway, so they will match whatever
cache level we set.

Cc: <stable@vger.kernel.org> # v5.7+
Suggested-by: Chris Wilson <chris@chris-wilson.co.uk>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2381
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_display.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 907e1d155443..00c08600c60a 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -3445,6 +3445,14 @@ initial_plane_vma(struct drm_i915_private *i915,
 	if (IS_ERR(obj))
 		return NULL;
 
+	/*
+	 * Mark it WT ahead of time to avoid changing the
+	 * cache_level during fbdev initialization. The
+	 * unbind there would get stuck waiting for rcu.
+	 */
+	i915_gem_object_set_cache_coherency(obj, HAS_WT(i915) ?
+					    I915_CACHE_WT : I915_CACHE_NONE);
+
 	switch (plane_config->tiling) {
 	case I915_TILING_NONE:
 		break;
-- 
2.26.2

