Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11DE75EA3B9
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238029AbiIZLbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238002AbiIZLbC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:31:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D016CD30;
        Mon, 26 Sep 2022 03:42:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 190ECB8095D;
        Mon, 26 Sep 2022 10:42:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E84FC433D6;
        Mon, 26 Sep 2022 10:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188933;
        bh=fl7+NFd7t7XQt+yzXGhU2ixASRe6bBzttRLfoiafxw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XL6R6J0lhKxzUQOgE575/9W7H3lq1Ovz/0MJo0smAP4PUX+IyPj77tKY5jX7iQ1UC
         76naupCr2wsOKoKB5B4l7qwlzrWHcNI5wp7AbOngGqjaiih7kNrLdUEuwqSs9i0nfP
         Bv+pwDIUI9iDsG1HDTKhIC1a8l0oql3hxlPgRkfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 002/207] drm/i915/pps: Split pps_init_delays() into distinct parts
Date:   Mon, 26 Sep 2022 12:09:51 +0200
Message-Id: <20220926100806.626926942@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 75bd0d5e4eadb9ce3e9b6fb71971b6e87c38799e ]

Split each of the hw/vbt/spec PPS delay initialization into
separate functions to make the whole thing less cluttered.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220510104242.6099-4-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Stable-dep-of: 607f41768a1e ("drm/i915/dsi: filter invalid backlight and CABC ports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_pps.c | 66 +++++++++++++++++-------
 1 file changed, 48 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_pps.c b/drivers/gpu/drm/i915/display/intel_pps.c
index 5a598dd06039..5b72c892a6f2 100644
--- a/drivers/gpu/drm/i915/display/intel_pps.c
+++ b/drivers/gpu/drm/i915/display/intel_pps.c
@@ -1159,53 +1159,83 @@ intel_pps_verify_state(struct intel_dp *intel_dp)
 	}
 }
 
-static void pps_init_delays(struct intel_dp *intel_dp)
+static void pps_init_delays_cur(struct intel_dp *intel_dp,
+				struct edp_power_seq *cur)
 {
 	struct drm_i915_private *dev_priv = dp_to_i915(intel_dp);
-	struct edp_power_seq cur, vbt, spec,
-		*final = &intel_dp->pps.pps_delays;
 
 	lockdep_assert_held(&dev_priv->pps_mutex);
 
-	/* already initialized? */
-	if (final->t11_t12 != 0)
-		return;
+	intel_pps_readout_hw_state(intel_dp, cur);
+
+	intel_pps_dump_state(intel_dp, "cur", cur);
+}
 
-	intel_pps_readout_hw_state(intel_dp, &cur);
+static void pps_init_delays_vbt(struct intel_dp *intel_dp,
+				struct edp_power_seq *vbt)
+{
+	struct drm_i915_private *dev_priv = dp_to_i915(intel_dp);
 
-	intel_pps_dump_state(intel_dp, "cur", &cur);
+	*vbt = dev_priv->vbt.edp.pps;
 
-	vbt = dev_priv->vbt.edp.pps;
 	/* On Toshiba Satellite P50-C-18C system the VBT T12 delay
 	 * of 500ms appears to be too short. Ocassionally the panel
 	 * just fails to power back on. Increasing the delay to 800ms
 	 * seems sufficient to avoid this problem.
 	 */
 	if (dev_priv->quirks & QUIRK_INCREASE_T12_DELAY) {
-		vbt.t11_t12 = max_t(u16, vbt.t11_t12, 1300 * 10);
+		vbt->t11_t12 = max_t(u16, vbt->t11_t12, 1300 * 10);
 		drm_dbg_kms(&dev_priv->drm,
 			    "Increasing T12 panel delay as per the quirk to %d\n",
-			    vbt.t11_t12);
+			    vbt->t11_t12);
 	}
+
 	/* T11_T12 delay is special and actually in units of 100ms, but zero
 	 * based in the hw (so we need to add 100 ms). But the sw vbt
 	 * table multiplies it with 1000 to make it in units of 100usec,
 	 * too. */
-	vbt.t11_t12 += 100 * 10;
+	vbt->t11_t12 += 100 * 10;
+
+	intel_pps_dump_state(intel_dp, "vbt", vbt);
+}
+
+static void pps_init_delays_spec(struct intel_dp *intel_dp,
+				 struct edp_power_seq *spec)
+{
+	struct drm_i915_private *dev_priv = dp_to_i915(intel_dp);
+
+	lockdep_assert_held(&dev_priv->pps_mutex);
 
 	/* Upper limits from eDP 1.3 spec. Note that we use the clunky units of
 	 * our hw here, which are all in 100usec. */
-	spec.t1_t3 = 210 * 10;
-	spec.t8 = 50 * 10; /* no limit for t8, use t7 instead */
-	spec.t9 = 50 * 10; /* no limit for t9, make it symmetric with t8 */
-	spec.t10 = 500 * 10;
+	spec->t1_t3 = 210 * 10;
+	spec->t8 = 50 * 10; /* no limit for t8, use t7 instead */
+	spec->t9 = 50 * 10; /* no limit for t9, make it symmetric with t8 */
+	spec->t10 = 500 * 10;
 	/* This one is special and actually in units of 100ms, but zero
 	 * based in the hw (so we need to add 100 ms). But the sw vbt
 	 * table multiplies it with 1000 to make it in units of 100usec,
 	 * too. */
-	spec.t11_t12 = (510 + 100) * 10;
+	spec->t11_t12 = (510 + 100) * 10;
+
+	intel_pps_dump_state(intel_dp, "spec", spec);
+}
+
+static void pps_init_delays(struct intel_dp *intel_dp)
+{
+	struct drm_i915_private *dev_priv = dp_to_i915(intel_dp);
+	struct edp_power_seq cur, vbt, spec,
+		*final = &intel_dp->pps.pps_delays;
+
+	lockdep_assert_held(&dev_priv->pps_mutex);
+
+	/* already initialized? */
+	if (final->t11_t12 != 0)
+		return;
 
-	intel_pps_dump_state(intel_dp, "vbt", &vbt);
+	pps_init_delays_cur(intel_dp, &cur);
+	pps_init_delays_vbt(intel_dp, &vbt);
+	pps_init_delays_spec(intel_dp, &spec);
 
 	/* Use the max of the register settings and vbt. If both are
 	 * unset, fall back to the spec limits. */
-- 
2.35.1



