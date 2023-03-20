Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6406C170A
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbjCTPLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232306AbjCTPKl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:10:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F8126840
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:06:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E7C8B80ECF
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:05:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00750C433D2;
        Mon, 20 Mar 2023 15:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324736;
        bh=GEfrb+5ONX0q7ZCoedmIIX8jolUzN6u2QVFLAC6nq58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gMjReHSVm5mdx5rYDZkOzQ34IVB7lkGCF1ieFxpYR48IRlKw1yF91PLV227xJEOYA
         Iv5FpNMUp7KdppaQq8zi9EeFhNGRewrDLr+fuEV2HCnhWZ0kFc33z7/Jz/oIsrx26y
         3EyKwepSLAa2A2V37fBmKvtumcxo2mT/yuUm8KYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mika Kahola <mika.kahola@intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        =?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/115] drm/i915/psr: Use calculated io and fast wake lines
Date:   Mon, 20 Mar 2023 15:53:57 +0100
Message-Id: <20230320145450.486672818@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jouni Högander <jouni.hogander@intel.com>

[ Upstream commit 71c602103c74b277bef3d20a308874a33ec8326d ]

Currently we are using hardcoded 7 for io and fast wake lines.

According to Bspec io and fast wake times are both 42us for
DISPLAY_VER >= 12 and 50us and 32us for older platforms.

Calculate line counts for these and configure them into PSR2_CTL
accordingly

Use 45 us for the fast wake calculation as 42 seems to be too
tight based on testing.

Bspec: 49274, 4289

Cc: Mika Kahola <mika.kahola@intel.com>
Cc: José Roberto de Souza <jose.souza@intel.com>
Fixes: 64cf40a125ff ("drm/i915/psr: Program default IO buffer Wake and Fast Wake")
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/7725
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230221085304.3382297-1-jouni.hogander@intel.com
(cherry picked from commit cb42e8ede5b475c096e473b86c356b1158b4bc3b)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/i915/display/intel_display_types.h    |  2 +
 drivers/gpu/drm/i915/display/intel_psr.c      | 78 +++++++++++++++----
 2 files changed, 63 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display_types.h b/drivers/gpu/drm/i915/display/intel_display_types.h
index b56850d964919..90e055f056994 100644
--- a/drivers/gpu/drm/i915/display/intel_display_types.h
+++ b/drivers/gpu/drm/i915/display/intel_display_types.h
@@ -1520,6 +1520,8 @@ struct intel_psr {
 	bool psr2_sel_fetch_enabled;
 	bool req_psr2_sdp_prior_scanline;
 	u8 sink_sync_latency;
+	u8 io_wake_lines;
+	u8 fast_wake_lines;
 	ktime_t last_entry_attempt;
 	ktime_t last_exit;
 	bool sink_not_reliable;
diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 5f9894e3c7aa7..cf1e92486cbc9 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -549,6 +549,14 @@ static void hsw_activate_psr2(struct intel_dp *intel_dp)
 	val |= EDP_PSR2_FRAME_BEFORE_SU(intel_dp->psr.sink_sync_latency + 1);
 	val |= intel_psr2_get_tp_time(intel_dp);
 
+	if (DISPLAY_VER(dev_priv) >= 12) {
+		if (intel_dp->psr.io_wake_lines < 9 &&
+		    intel_dp->psr.fast_wake_lines < 9)
+			val |= TGL_EDP_PSR2_BLOCK_COUNT_NUM_2;
+		else
+			val |= TGL_EDP_PSR2_BLOCK_COUNT_NUM_3;
+	}
+
 	/* Wa_22012278275:adl-p */
 	if (IS_ADLP_DISPLAY_STEP(dev_priv, STEP_A0, STEP_E0)) {
 		static const u8 map[] = {
@@ -565,31 +573,21 @@ static void hsw_activate_psr2(struct intel_dp *intel_dp)
 		 * Still using the default IO_BUFFER_WAKE and FAST_WAKE, see
 		 * comments bellow for more information
 		 */
-		u32 tmp, lines = 7;
+		u32 tmp;
 
-		val |= TGL_EDP_PSR2_BLOCK_COUNT_NUM_2;
-
-		tmp = map[lines - TGL_EDP_PSR2_IO_BUFFER_WAKE_MIN_LINES];
+		tmp = map[intel_dp->psr.io_wake_lines - TGL_EDP_PSR2_IO_BUFFER_WAKE_MIN_LINES];
 		tmp = tmp << TGL_EDP_PSR2_IO_BUFFER_WAKE_SHIFT;
 		val |= tmp;
 
-		tmp = map[lines - TGL_EDP_PSR2_FAST_WAKE_MIN_LINES];
+		tmp = map[intel_dp->psr.fast_wake_lines - TGL_EDP_PSR2_FAST_WAKE_MIN_LINES];
 		tmp = tmp << TGL_EDP_PSR2_FAST_WAKE_MIN_SHIFT;
 		val |= tmp;
 	} else if (DISPLAY_VER(dev_priv) >= 12) {
-		/*
-		 * TODO: 7 lines of IO_BUFFER_WAKE and FAST_WAKE are default
-		 * values from BSpec. In order to setting an optimal power
-		 * consumption, lower than 4k resolution mode needs to decrease
-		 * IO_BUFFER_WAKE and FAST_WAKE. And higher than 4K resolution
-		 * mode needs to increase IO_BUFFER_WAKE and FAST_WAKE.
-		 */
-		val |= TGL_EDP_PSR2_BLOCK_COUNT_NUM_2;
-		val |= TGL_EDP_PSR2_IO_BUFFER_WAKE(7);
-		val |= TGL_EDP_PSR2_FAST_WAKE(7);
+		val |= TGL_EDP_PSR2_IO_BUFFER_WAKE(intel_dp->psr.io_wake_lines);
+		val |= TGL_EDP_PSR2_FAST_WAKE(intel_dp->psr.fast_wake_lines);
 	} else if (DISPLAY_VER(dev_priv) >= 9) {
-		val |= EDP_PSR2_IO_BUFFER_WAKE(7);
-		val |= EDP_PSR2_FAST_WAKE(7);
+		val |= EDP_PSR2_IO_BUFFER_WAKE(intel_dp->psr.io_wake_lines);
+		val |= EDP_PSR2_FAST_WAKE(intel_dp->psr.fast_wake_lines);
 	}
 
 	if (intel_dp->psr.req_psr2_sdp_prior_scanline)
@@ -842,6 +840,46 @@ static bool _compute_psr2_sdp_prior_scanline_indication(struct intel_dp *intel_d
 	return true;
 }
 
+static bool _compute_psr2_wake_times(struct intel_dp *intel_dp,
+				     struct intel_crtc_state *crtc_state)
+{
+	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
+	int io_wake_lines, io_wake_time, fast_wake_lines, fast_wake_time;
+	u8 max_wake_lines;
+
+	if (DISPLAY_VER(i915) >= 12) {
+		io_wake_time = 42;
+		/*
+		 * According to Bspec it's 42us, but based on testing
+		 * it is not enough -> use 45 us.
+		 */
+		fast_wake_time = 45;
+		max_wake_lines = 12;
+	} else {
+		io_wake_time = 50;
+		fast_wake_time = 32;
+		max_wake_lines = 8;
+	}
+
+	io_wake_lines = intel_usecs_to_scanlines(
+		&crtc_state->uapi.adjusted_mode, io_wake_time);
+	fast_wake_lines = intel_usecs_to_scanlines(
+		&crtc_state->uapi.adjusted_mode, fast_wake_time);
+
+	if (io_wake_lines > max_wake_lines ||
+	    fast_wake_lines > max_wake_lines)
+		return false;
+
+	if (i915->params.psr_safest_params)
+		io_wake_lines = fast_wake_lines = max_wake_lines;
+
+	/* According to Bspec lower limit should be set as 7 lines. */
+	intel_dp->psr.io_wake_lines = max(io_wake_lines, 7);
+	intel_dp->psr.fast_wake_lines = max(fast_wake_lines, 7);
+
+	return true;
+}
+
 static bool intel_psr2_config_valid(struct intel_dp *intel_dp,
 				    struct intel_crtc_state *crtc_state)
 {
@@ -939,6 +977,12 @@ static bool intel_psr2_config_valid(struct intel_dp *intel_dp,
 		return false;
 	}
 
+	if (!_compute_psr2_wake_times(intel_dp, crtc_state)) {
+		drm_dbg_kms(&dev_priv->drm,
+			    "PSR2 not enabled, Unable to use long enough wake times\n");
+		return false;
+	}
+
 	if (HAS_PSR2_SEL_FETCH(dev_priv)) {
 		if (!intel_psr2_sel_fetch_config_valid(intel_dp, crtc_state) &&
 		    !HAS_PSR_HW_TRACKING(dev_priv)) {
-- 
2.39.2



