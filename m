Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76ACD6C1878
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbjCTPZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbjCTPY2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:24:28 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7937A2687B
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:17:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 61D3DCE12F6
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B25DC433D2;
        Mon, 20 Mar 2023 15:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325454;
        bh=PK/3hZvwqYSVjzxrOMQXZnQfliKl3x4tSfLN7K9vVhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0nC7m1dDAX1SVwwfrbu5WYZiZCVJXNwWDDVHDXmOWOWOTVvKyiRdRPf/Tu/O60Qi9
         o6NGGfj7dBIqFMQ/rfhoKBrsiofJVGFc62vqLmY9SEDJGRODYu5WTOiWhl9x2Li8cL
         ky/3w/u0Yx0SPHJ4iotNXG7g0VhGk4UfB3DhAttQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mika Kahola <mika.kahola@intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        =?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 045/211] drm/i915/psr: Use calculated io and fast wake lines
Date:   Mon, 20 Mar 2023 15:53:00 +0100
Message-Id: <20230320145515.121765287@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 1b6989001ee2b..af69521bd1e9b 100644
--- a/drivers/gpu/drm/i915/display/intel_display_types.h
+++ b/drivers/gpu/drm/i915/display/intel_display_types.h
@@ -1618,6 +1618,8 @@ struct intel_psr {
 	bool psr2_sel_fetch_cff_enabled;
 	bool req_psr2_sdp_prior_scanline;
 	u8 sink_sync_latency;
+	u8 io_wake_lines;
+	u8 fast_wake_lines;
 	ktime_t last_entry_attempt;
 	ktime_t last_exit;
 	bool sink_not_reliable;
diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 5b678916e6db5..8b984c88fd8b1 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -543,6 +543,14 @@ static void hsw_activate_psr2(struct intel_dp *intel_dp)
 	val |= EDP_PSR2_FRAME_BEFORE_SU(max_t(u8, intel_dp->psr.sink_sync_latency + 1, 2));
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
@@ -559,31 +567,21 @@ static void hsw_activate_psr2(struct intel_dp *intel_dp)
 		 * Still using the default IO_BUFFER_WAKE and FAST_WAKE, see
 		 * comments bellow for more information
 		 */
-		u32 tmp, lines = 7;
-
-		val |= TGL_EDP_PSR2_BLOCK_COUNT_NUM_2;
+		u32 tmp;
 
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
@@ -843,6 +841,46 @@ static bool _compute_psr2_sdp_prior_scanline_indication(struct intel_dp *intel_d
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
@@ -937,6 +975,12 @@ static bool intel_psr2_config_valid(struct intel_dp *intel_dp,
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



