Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A7D50F677
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244599AbiDZIwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346315AbiDZIuB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:50:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7960FC8BCE;
        Tue, 26 Apr 2022 01:38:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33F1DB81CFA;
        Tue, 26 Apr 2022 08:38:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823F7C385A4;
        Tue, 26 Apr 2022 08:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962284;
        bh=mtv+VgBzDjnbTuKpFHhkxzk0FgNmf/fS99cTFIUNMfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1M5N9kg+GFgS6J2J7GpZKC3lqfbXjU8nwojMQHm6sW53X0b+4d8bFW5j6sebYc40V
         M3iZdA8VTwzQDLXK088mCfbMJeiv0onNCyChdaiReiLFLdXqGYhaTtsmXAJUE+K0Fj
         jc4SLx25MmBoV45ny+RV9+TXarctddxxmAQEI/+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/124] drm/i915/display/psr: Unset enable_psr2_sel_fetch if other checks in intel_psr2_config_valid() fails
Date:   Tue, 26 Apr 2022 10:20:47 +0200
Message-Id: <20220426081748.611187531@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Roberto de Souza <jose.souza@intel.com>

[ Upstream commit bb02330408a7bde33b5f46aa14fd5d7bfe6093b7 ]

If any of the PSR2 checks after intel_psr2_sel_fetch_config_valid()
fails, enable_psr2_sel_fetch will be kept enabled causing problems
in the functions that only checks for it and not for has_psr2.

So here moving the check that do not depend on enable_psr2_sel_fetch
and for the remaning ones jumping to a section that unset
enable_psr2_sel_fetch in case of failure to support PSR2.

Fixes: 6e43e276b8c9 ("drm/i915: Initial implementation of PSR2 selective fetch")
Cc: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220414151118.21980-1-jose.souza@intel.com
(cherry picked from commit 554ae8dce1268789e72767a67f0635cb743b3cea)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c | 38 +++++++++++++-----------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 1b0daf649e82..a3d0c57ec0f0 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -936,6 +936,20 @@ static bool intel_psr2_config_valid(struct intel_dp *intel_dp,
 		return false;
 	}
 
+	/* Wa_16011303918:adl-p */
+	if (crtc_state->vrr.enable &&
+	    IS_ADLP_DISPLAY_STEP(dev_priv, STEP_A0, STEP_B0)) {
+		drm_dbg_kms(&dev_priv->drm,
+			    "PSR2 not enabled, not compatible with HW stepping + VRR\n");
+		return false;
+	}
+
+	if (!_compute_psr2_sdp_prior_scanline_indication(intel_dp, crtc_state)) {
+		drm_dbg_kms(&dev_priv->drm,
+			    "PSR2 not enabled, PSR2 SDP indication do not fit in hblank\n");
+		return false;
+	}
+
 	if (HAS_PSR2_SEL_FETCH(dev_priv)) {
 		if (!intel_psr2_sel_fetch_config_valid(intel_dp, crtc_state) &&
 		    !HAS_PSR_HW_TRACKING(dev_priv)) {
@@ -949,12 +963,12 @@ static bool intel_psr2_config_valid(struct intel_dp *intel_dp,
 	if (!crtc_state->enable_psr2_sel_fetch &&
 	    IS_TGL_DISPLAY_STEP(dev_priv, STEP_A0, STEP_C0)) {
 		drm_dbg_kms(&dev_priv->drm, "PSR2 HW tracking is not supported this Display stepping\n");
-		return false;
+		goto unsupported;
 	}
 
 	if (!psr2_granularity_check(intel_dp, crtc_state)) {
 		drm_dbg_kms(&dev_priv->drm, "PSR2 not enabled, SU granularity not compatible\n");
-		return false;
+		goto unsupported;
 	}
 
 	if (!crtc_state->enable_psr2_sel_fetch &&
@@ -963,25 +977,15 @@ static bool intel_psr2_config_valid(struct intel_dp *intel_dp,
 			    "PSR2 not enabled, resolution %dx%d > max supported %dx%d\n",
 			    crtc_hdisplay, crtc_vdisplay,
 			    psr_max_h, psr_max_v);
-		return false;
-	}
-
-	if (!_compute_psr2_sdp_prior_scanline_indication(intel_dp, crtc_state)) {
-		drm_dbg_kms(&dev_priv->drm,
-			    "PSR2 not enabled, PSR2 SDP indication do not fit in hblank\n");
-		return false;
-	}
-
-	/* Wa_16011303918:adl-p */
-	if (crtc_state->vrr.enable &&
-	    IS_ADLP_DISPLAY_STEP(dev_priv, STEP_A0, STEP_B0)) {
-		drm_dbg_kms(&dev_priv->drm,
-			    "PSR2 not enabled, not compatible with HW stepping + VRR\n");
-		return false;
+		goto unsupported;
 	}
 
 	tgl_dc3co_exitline_compute_config(intel_dp, crtc_state);
 	return true;
+
+unsupported:
+	crtc_state->enable_psr2_sel_fetch = false;
+	return false;
 }
 
 void intel_psr_compute_config(struct intel_dp *intel_dp,
-- 
2.35.1



