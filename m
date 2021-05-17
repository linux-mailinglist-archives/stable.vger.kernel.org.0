Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB6338310B
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240303AbhEQOdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:33:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239959AbhEQObv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:31:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 961C3613E1;
        Mon, 17 May 2021 14:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260944;
        bh=nx11xL8CuWTnWQiIfxjPr8UVxD5TotRu0UoYZvTy9Uo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cFdSoScqzE7cY2ZDNiTioEoqEVLCb8Hm9Luje1HoNOd9YS+8BmfEcs1+SvoIJ2mNC
         IbT38Whhu8754lzQYEgCvKoPsnR4x6onGVELzh1XjRSlK24POItx3EIKZTokTe2y9e
         4ja6+t53ztQjz2zcoSpyrJ7ZabSpvO3Vu2L36Zko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.12 272/363] drm/i915/dp: Use slow and wide link training for everything
Date:   Mon, 17 May 2021 16:02:18 +0200
Message-Id: <20210517140311.812995043@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit a5c936add6a23c15c6ae538ab7a12f80751fdf0f upstream.

Screen flickers on Innolux eDP 1.3 panel when clock rate 540000 is in use.

According to the panel vendor, though clock rate 540000 is advertised,
but the max clock rate it really supports is 270000.

Ville Syrjälä mentioned that fast and narrow also breaks some eDP 1.4
panel, so use slow and wide training for all panels to resolve the
issue.

User also confirmed that the new strategy doesn't introduce any
regression on XPS 9380.

v2:
 - Use slow and wide for everything.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/3384
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210421052054.1434718-1-kai.heng.feng@canonical.com
(cherry picked from commit acca7762eb71bc05a8f28d29320d193150051f79)
Fixes: 2bbd6dba84d4 ("drm/i915: Try to use fast+narrow link on eDP again and fall back to the old max strategy on failure")
Cc: <stable@vger.kernel.org> # v5.12+
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c |   59 ++------------------------------
 1 file changed, 5 insertions(+), 54 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -1174,44 +1174,6 @@ intel_dp_compute_link_config_wide(struct
 	return -EINVAL;
 }
 
-/* Optimize link config in order: max bpp, min lanes, min clock */
-static int
-intel_dp_compute_link_config_fast(struct intel_dp *intel_dp,
-				  struct intel_crtc_state *pipe_config,
-				  const struct link_config_limits *limits)
-{
-	const struct drm_display_mode *adjusted_mode = &pipe_config->hw.adjusted_mode;
-	int bpp, clock, lane_count;
-	int mode_rate, link_clock, link_avail;
-
-	for (bpp = limits->max_bpp; bpp >= limits->min_bpp; bpp -= 2 * 3) {
-		int output_bpp = intel_dp_output_bpp(pipe_config->output_format, bpp);
-
-		mode_rate = intel_dp_link_required(adjusted_mode->crtc_clock,
-						   output_bpp);
-
-		for (lane_count = limits->min_lane_count;
-		     lane_count <= limits->max_lane_count;
-		     lane_count <<= 1) {
-			for (clock = limits->min_clock; clock <= limits->max_clock; clock++) {
-				link_clock = intel_dp->common_rates[clock];
-				link_avail = intel_dp_max_data_rate(link_clock,
-								    lane_count);
-
-				if (mode_rate <= link_avail) {
-					pipe_config->lane_count = lane_count;
-					pipe_config->pipe_bpp = bpp;
-					pipe_config->port_clock = link_clock;
-
-					return 0;
-				}
-			}
-		}
-	}
-
-	return -EINVAL;
-}
-
 static int intel_dp_dsc_compute_bpp(struct intel_dp *intel_dp, u8 dsc_max_bpc)
 {
 	int i, num_bpc;
@@ -1461,22 +1423,11 @@ intel_dp_compute_link_config(struct inte
 	    intel_dp_can_bigjoiner(intel_dp))
 		pipe_config->bigjoiner = true;
 
-	if (intel_dp_is_edp(intel_dp))
-		/*
-		 * Optimize for fast and narrow. eDP 1.3 section 3.3 and eDP 1.4
-		 * section A.1: "It is recommended that the minimum number of
-		 * lanes be used, using the minimum link rate allowed for that
-		 * lane configuration."
-		 *
-		 * Note that we fall back to the max clock and lane count for eDP
-		 * panels that fail with the fast optimal settings (see
-		 * intel_dp->use_max_params), in which case the fast vs. wide
-		 * choice doesn't matter.
-		 */
-		ret = intel_dp_compute_link_config_fast(intel_dp, pipe_config, &limits);
-	else
-		/* Optimize for slow and wide. */
-		ret = intel_dp_compute_link_config_wide(intel_dp, pipe_config, &limits);
+	/*
+	 * Optimize for slow and wide for everything, because there are some
+	 * eDP 1.3 and 1.4 panels don't work well with fast and narrow.
+	 */
+	ret = intel_dp_compute_link_config_wide(intel_dp, pipe_config, &limits);
 
 	/* enable compression if the mode doesn't fit available BW */
 	drm_dbg_kms(&i915->drm, "Force DSC en = %d\n", intel_dp->force_dsc_en);


