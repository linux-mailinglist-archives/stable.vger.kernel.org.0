Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCBB4C435
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 01:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730815AbfFSXwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 19:52:10 -0400
Received: from mga18.intel.com ([134.134.136.126]:43648 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730812AbfFSXwK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jun 2019 19:52:10 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 16:52:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,394,1557212400"; 
   d="scan'208";a="162363853"
Received: from anusha.jf.intel.com ([10.54.75.56])
  by orsmga003.jf.intel.com with ESMTP; 19 Jun 2019 16:52:09 -0700
From:   Anusha Srivatsa <anusha.srivatsa@intel.com>
To:     gfx-internal-devel@eclists.intel.com
Cc:     =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Heinrich Fink <heinrich.fink@daqri.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 16/21] drm/i915: Fix per-pixel alpha with CCS
Date:   Wed, 19 Jun 2019 16:42:19 -0700
Message-Id: <20190619234224.7681-17-anusha.srivatsa@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190619234224.7681-1-anusha.srivatsa@intel.com>
References: <20190619234224.7681-1-anusha.srivatsa@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

We forgot to set .has_alpha=true for the A+CCS formats when the code
started to consult .has_alpha. This manifests as A+CCS being treated
as X+CCS which means no per-pixel alpha blending. Fix the format
list appropriately.

Cc: stable@vger.kernel.org
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Heinrich Fink <heinrich.fink@daqri.com>
Reported-by: Heinrich Fink <heinrich.fink@daqri.com>
Tested-by: Heinrich Fink <heinrich.fink@daqri.com>
Fixes: b20815255693 ("drm/i915: Add plane alpha blending support, v2.")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190603142500.25680-1-ville.syrjala@linux.intel.com
Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
(cherry picked from commit 38f300410f3e15b6fec76c8d8baed7111b5ea4e4)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 drivers/gpu/drm/i915/intel_display.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index ceb78f44f087..b69440cf41ea 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2432,10 +2432,14 @@ static unsigned int intel_fb_modifier_to_tiling(u64 fb_modifier)
  * main surface.
  */
 static const struct drm_format_info ccs_formats[] = {
-	{ .format = DRM_FORMAT_XRGB8888, .depth = 24, .num_planes = 2, .cpp = { 4, 1, }, .hsub = 8, .vsub = 16, },
-	{ .format = DRM_FORMAT_XBGR8888, .depth = 24, .num_planes = 2, .cpp = { 4, 1, }, .hsub = 8, .vsub = 16, },
-	{ .format = DRM_FORMAT_ARGB8888, .depth = 32, .num_planes = 2, .cpp = { 4, 1, }, .hsub = 8, .vsub = 16, },
-	{ .format = DRM_FORMAT_ABGR8888, .depth = 32, .num_planes = 2, .cpp = { 4, 1, }, .hsub = 8, .vsub = 16, },
+	{ .format = DRM_FORMAT_XRGB8888, .depth = 24, .num_planes = 2,
+	  .cpp = { 4, 1, }, .hsub = 8, .vsub = 16, },
+	{ .format = DRM_FORMAT_XBGR8888, .depth = 24, .num_planes = 2,
+	  .cpp = { 4, 1, }, .hsub = 8, .vsub = 16, },
+	{ .format = DRM_FORMAT_ARGB8888, .depth = 32, .num_planes = 2,
+	  .cpp = { 4, 1, }, .hsub = 8, .vsub = 16, .has_alpha = true, },
+	{ .format = DRM_FORMAT_ABGR8888, .depth = 32, .num_planes = 2,
+	  .cpp = { 4, 1, }, .hsub = 8, .vsub = 16, .has_alpha = true, },
 };
 
 static const struct drm_format_info *
