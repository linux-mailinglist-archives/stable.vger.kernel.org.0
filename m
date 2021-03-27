Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010DA34B378
	for <lists+stable@lfdr.de>; Sat, 27 Mar 2021 02:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhC0BAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Mar 2021 21:00:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:29226 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230423AbhC0A7t (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Mar 2021 20:59:49 -0400
IronPort-SDR: 1X13VypM9fICquA8eXGdQFMePziQbnntl8FKGcg8+a+WN8lhsy6EZbxBFRej4CTnNki/4cQ6KB
 rIf8BK37MBIw==
X-IronPort-AV: E=McAfee;i="6000,8403,9935"; a="178373927"
X-IronPort-AV: E=Sophos;i="5.81,282,1610438400"; 
   d="scan'208";a="178373927"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 17:59:48 -0700
IronPort-SDR: uTZTtY7Mwedb4yLJbbslq2jD280+L5SoYbHmVQRJQKhZkdEqC1CiJpLpPDK+B1eqlGDXVPfhpd
 O6TzxnK+q8OQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,282,1610438400"; 
   d="scan'208";a="377429846"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by orsmga006.jf.intel.com with SMTP; 26 Mar 2021 17:59:46 -0700
Received: by stinkbox (sSMTP sendmail emulation); Sat, 27 Mar 2021 02:59:45 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Subject: [PATCH] drm/i915: Don't zero out the Y plane's watermarks
Date:   Sat, 27 Mar 2021 02:59:45 +0200
Message-Id: <20210327005945.4929-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Don't zero out the watermarks for the Y plane since we've already
computed them when computing the UV plane's watermarks (since the
UV plane always appears before ethe Y plane when iterating through
the planes).

This leads to allocating no DDB for the Y plane since .min_ddb_alloc
also gets zeroed. And that of course leads to underruns when scanning
out planar formats.

We really need to re-enable the pre-merge pixel format tests or else
I'll just keep breaking this stuff...

Cc: stable@vger.kernel.org
Cc: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Fixes: dbf71381d733 ("drm/i915: Nuke intel_atomic_crtc_state_for_each_plane_state() from skl+ wm code")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/intel_pm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index b2aede2be89d..49c19acdb7c6 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -5511,12 +5511,12 @@ static int icl_build_plane_wm(struct intel_crtc_state *crtc_state,
 	struct skl_plane_wm *wm = &crtc_state->wm.skl.raw.planes[plane_id];
 	int ret;
 
-	memset(wm, 0, sizeof(*wm));
-
 	/* Watermarks calculated in master */
 	if (plane_state->planar_slave)
 		return 0;
 
+	memset(wm, 0, sizeof(*wm));
+
 	if (plane_state->planar_linked_plane) {
 		const struct drm_framebuffer *fb = plane_state->hw.fb;
 		enum plane_id y_plane_id = plane_state->planar_linked_plane->id;
-- 
2.26.2

