Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB7B4B4A61
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344605AbiBNKCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:02:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345824AbiBNKB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:01:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643E820F73;
        Mon, 14 Feb 2022 01:48:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11A65B80DC4;
        Mon, 14 Feb 2022 09:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AD8C340EF;
        Mon, 14 Feb 2022 09:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832094;
        bh=zybIqScyJBaEatg0mvlE1d2Znth5fnOQfVQTSVp3Vv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c4kMQRYTBJjz/v742q3AVvcCrguJEuWLOQRWihg86/TrITNJvNhSFzMPpqGcuusqw
         Hp3GQwCShANEVOPsJ7HTzbtw+iMLp9I0Mbep5tOAkyf5JeH8C2QvxP80SYmBfXKfuL
         1UXQujEZkdv/nTnzeL8TFYOptZRiAmfcgxcyglUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 5.15 078/172] drm/i915: Allow !join_mbus cases for adlp+ dbuf configuration
Date:   Mon, 14 Feb 2022 10:25:36 +0100
Message-Id: <20220214092509.096447854@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 8fd5a26e43859547790a7995494c952b708ab3b5 upstream.

Reintroduce the !join_mbus single pipe cases for adlp+.

Due to the mbus relative dbuf offsets in PLANE_BUF_CFG we
need to know the actual slices used by the pipe when doing
readout, even when mbus joining isn't enabled. Accurate
readout will be needed to properly sanitize invalid BIOS
dbuf configurations.

This will also make it much easier to play around with the
!join_mbus configs for testin/workaround purposes.

Cc: <stable@vger.kernel.org> # v5.14+
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220204141818.1900-1-ville.syrjala@linux.intel.com
Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
(cherry picked from commit eef173954432fe0612acb63421a95deb41155cdc)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/intel_pm.c |   66 +++++++++++++++++++++++++++-------------
 1 file changed, 46 insertions(+), 20 deletions(-)

--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -4708,6 +4708,10 @@ static const struct dbuf_slice_conf_entr
 };
 
 static const struct dbuf_slice_conf_entry adlp_allowed_dbufs[] = {
+	/*
+	 * Keep the join_mbus cases first so check_mbus_joined()
+	 * will prefer them over the !join_mbus cases.
+	 */
 	{
 		.active_pipes = BIT(PIPE_A),
 		.dbuf_mask = {
@@ -4723,6 +4727,20 @@ static const struct dbuf_slice_conf_entr
 		.join_mbus = true,
 	},
 	{
+		.active_pipes = BIT(PIPE_A),
+		.dbuf_mask = {
+			[PIPE_A] = BIT(DBUF_S1) | BIT(DBUF_S2),
+		},
+		.join_mbus = false,
+	},
+	{
+		.active_pipes = BIT(PIPE_B),
+		.dbuf_mask = {
+			[PIPE_B] = BIT(DBUF_S3) | BIT(DBUF_S4),
+		},
+		.join_mbus = false,
+	},
+	{
 		.active_pipes = BIT(PIPE_A) | BIT(PIPE_B),
 		.dbuf_mask = {
 			[PIPE_A] = BIT(DBUF_S1) | BIT(DBUF_S2),
@@ -4838,13 +4856,14 @@ static bool adlp_check_mbus_joined(u8 ac
 	return check_mbus_joined(active_pipes, adlp_allowed_dbufs);
 }
 
-static u8 compute_dbuf_slices(enum pipe pipe, u8 active_pipes,
+static u8 compute_dbuf_slices(enum pipe pipe, u8 active_pipes, bool join_mbus,
 			      const struct dbuf_slice_conf_entry *dbuf_slices)
 {
 	int i;
 
 	for (i = 0; i < dbuf_slices[i].active_pipes; i++) {
-		if (dbuf_slices[i].active_pipes == active_pipes)
+		if (dbuf_slices[i].active_pipes == active_pipes &&
+		    dbuf_slices[i].join_mbus == join_mbus)
 			return dbuf_slices[i].dbuf_mask[pipe];
 	}
 	return 0;
@@ -4855,7 +4874,7 @@ static u8 compute_dbuf_slices(enum pipe
  * returns correspondent DBuf slice mask as stated in BSpec for particular
  * platform.
  */
-static u8 icl_compute_dbuf_slices(enum pipe pipe, u8 active_pipes)
+static u8 icl_compute_dbuf_slices(enum pipe pipe, u8 active_pipes, bool join_mbus)
 {
 	/*
 	 * FIXME: For ICL this is still a bit unclear as prev BSpec revision
@@ -4869,37 +4888,41 @@ static u8 icl_compute_dbuf_slices(enum p
 	 * still here - we will need it once those additional constraints
 	 * pop up.
 	 */
-	return compute_dbuf_slices(pipe, active_pipes, icl_allowed_dbufs);
+	return compute_dbuf_slices(pipe, active_pipes, join_mbus,
+				   icl_allowed_dbufs);
 }
 
-static u8 tgl_compute_dbuf_slices(enum pipe pipe, u8 active_pipes)
+static u8 tgl_compute_dbuf_slices(enum pipe pipe, u8 active_pipes, bool join_mbus)
 {
-	return compute_dbuf_slices(pipe, active_pipes, tgl_allowed_dbufs);
+	return compute_dbuf_slices(pipe, active_pipes, join_mbus,
+				   tgl_allowed_dbufs);
 }
 
-static u32 adlp_compute_dbuf_slices(enum pipe pipe, u32 active_pipes)
+static u8 adlp_compute_dbuf_slices(enum pipe pipe, u8 active_pipes, bool join_mbus)
 {
-	return compute_dbuf_slices(pipe, active_pipes, adlp_allowed_dbufs);
+	return compute_dbuf_slices(pipe, active_pipes, join_mbus,
+				   adlp_allowed_dbufs);
 }
 
-static u32 dg2_compute_dbuf_slices(enum pipe pipe, u32 active_pipes)
+static u8 dg2_compute_dbuf_slices(enum pipe pipe, u8 active_pipes, bool join_mbus)
 {
-	return compute_dbuf_slices(pipe, active_pipes, dg2_allowed_dbufs);
+	return compute_dbuf_slices(pipe, active_pipes, join_mbus,
+				   dg2_allowed_dbufs);
 }
 
-static u8 skl_compute_dbuf_slices(struct intel_crtc *crtc, u8 active_pipes)
+static u8 skl_compute_dbuf_slices(struct intel_crtc *crtc, u8 active_pipes, bool join_mbus)
 {
 	struct drm_i915_private *dev_priv = to_i915(crtc->base.dev);
 	enum pipe pipe = crtc->pipe;
 
 	if (IS_DG2(dev_priv))
-		return dg2_compute_dbuf_slices(pipe, active_pipes);
+		return dg2_compute_dbuf_slices(pipe, active_pipes, join_mbus);
 	else if (IS_ALDERLAKE_P(dev_priv))
-		return adlp_compute_dbuf_slices(pipe, active_pipes);
+		return adlp_compute_dbuf_slices(pipe, active_pipes, join_mbus);
 	else if (DISPLAY_VER(dev_priv) == 12)
-		return tgl_compute_dbuf_slices(pipe, active_pipes);
+		return tgl_compute_dbuf_slices(pipe, active_pipes, join_mbus);
 	else if (DISPLAY_VER(dev_priv) == 11)
-		return icl_compute_dbuf_slices(pipe, active_pipes);
+		return icl_compute_dbuf_slices(pipe, active_pipes, join_mbus);
 	/*
 	 * For anything else just return one slice yet.
 	 * Should be extended for other platforms.
@@ -6110,11 +6133,16 @@ skl_compute_ddb(struct intel_atomic_stat
 			return ret;
 	}
 
+	if (IS_ALDERLAKE_P(dev_priv))
+		new_dbuf_state->joined_mbus =
+			adlp_check_mbus_joined(new_dbuf_state->active_pipes);
+
 	for_each_intel_crtc(&dev_priv->drm, crtc) {
 		enum pipe pipe = crtc->pipe;
 
 		new_dbuf_state->slices[pipe] =
-			skl_compute_dbuf_slices(crtc, new_dbuf_state->active_pipes);
+			skl_compute_dbuf_slices(crtc, new_dbuf_state->active_pipes,
+						new_dbuf_state->joined_mbus);
 
 		if (old_dbuf_state->slices[pipe] == new_dbuf_state->slices[pipe])
 			continue;
@@ -6126,9 +6154,6 @@ skl_compute_ddb(struct intel_atomic_stat
 
 	new_dbuf_state->enabled_slices = intel_dbuf_enabled_slices(new_dbuf_state);
 
-	if (IS_ALDERLAKE_P(dev_priv))
-		new_dbuf_state->joined_mbus = adlp_check_mbus_joined(new_dbuf_state->active_pipes);
-
 	if (old_dbuf_state->enabled_slices != new_dbuf_state->enabled_slices ||
 	    old_dbuf_state->joined_mbus != new_dbuf_state->joined_mbus) {
 		ret = intel_atomic_serialize_global_state(&new_dbuf_state->base);
@@ -6629,7 +6654,8 @@ void skl_wm_get_hw_state(struct drm_i915
 		}
 
 		dbuf_state->slices[pipe] =
-			skl_compute_dbuf_slices(crtc, dbuf_state->active_pipes);
+			skl_compute_dbuf_slices(crtc, dbuf_state->active_pipes,
+						dbuf_state->joined_mbus);
 
 		dbuf_state->weight[pipe] = intel_crtc_ddb_weight(crtc_state);
 


