Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4694366F3B
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 17:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238663AbhDUPem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 11:34:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:22718 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236008AbhDUPem (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Apr 2021 11:34:42 -0400
IronPort-SDR: 7No2KlkRR/f7/N4c+pD0680GzvJujnWuGQYvho1pec4ezwvEOiPBCj/2HhSyKJNqwOAQUpM+xe
 RZ7xokdpIuMg==
X-IronPort-AV: E=McAfee;i="6200,9189,9961"; a="192529335"
X-IronPort-AV: E=Sophos;i="5.82,240,1613462400"; 
   d="scan'208";a="192529335"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2021 08:34:08 -0700
IronPort-SDR: pj12Ap58fv9meikbqUmVwvNvHwDVAEKoH3phfx0IC35Ngh0bxiKsKODYMNIaBc50pQ4DnHcS00
 OQ7msB/NgrAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,240,1613462400"; 
   d="scan'208";a="421025341"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by fmsmga008.fm.intel.com with SMTP; 21 Apr 2021 08:34:05 -0700
Received: by stinkbox (sSMTP sendmail emulation); Wed, 21 Apr 2021 18:34:04 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH 1/4] drm/i915: Avoid div-by-zero on gen2
Date:   Wed, 21 Apr 2021 18:33:58 +0300
Message-Id: <20210421153401.13847-2-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210421153401.13847-1-ville.syrjala@linux.intel.com>
References: <20210421153401.13847-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Gen2 tiles are 2KiB in size so i915_gem_object_get_tile_row_size()
can in fact return <4KiB, which leads to div-by-zero here.
Avoid that.

Not sure i915_gem_object_get_tile_row_size() is entirely
sane anyway since it doesn't account for the different tile
layouts on i8xx/i915...

I'm not able to hit this before commit 6846895fde05 ("drm/i915:
Replace PIN_NONFAULT with calls to PIN_NOEVICT") and it looks
like I also need to run recent version of Mesa. With those in
place xonotic trips on this quite easily on my 85x.

Cc: stable@vger.kernel.org
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/gem/i915_gem_mman.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
index 2561a2f1e54f..8598a1c78a4c 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -189,7 +189,7 @@ compute_partial_view(const struct drm_i915_gem_object *obj,
 	struct i915_ggtt_view view;
 
 	if (i915_gem_object_is_tiled(obj))
-		chunk = roundup(chunk, tile_row_pages(obj));
+		chunk = roundup(chunk, tile_row_pages(obj) ?: 1);
 
 	view.type = I915_GGTT_VIEW_PARTIAL;
 	view.partial.offset = rounddown(page_offset, chunk);
-- 
2.26.3

