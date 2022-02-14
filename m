Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9914B4BAE
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347146AbiBNK1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:27:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348474AbiBNK1G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:27:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C1C70301;
        Mon, 14 Feb 2022 01:58:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEC72B80DC4;
        Mon, 14 Feb 2022 09:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2527C340E9;
        Mon, 14 Feb 2022 09:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832678;
        bh=d1WcnwbYcvx7Jr2kzW+21IfSV6rX6uum7WSctazv07o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JKgl2EcGLBRA/ptVvzyKLR3s76yVFPUzTj3FeS1hoVZyhYG7hNR6ImervO8X469bh
         AOWRiJT/ISVOAeFQ/PWDwgme+3c/dvGi47uKW3ix+RqtWZSiYbdqWRFO83VseXu8Kl
         biBKplek+B2b20GiEOEOxsRMGj7Pp/Ngi/j9KQP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 5.16 091/203] drm/i915: Populate pipe dbuf slices more accurately during readout
Date:   Mon, 14 Feb 2022 10:25:35 +0100
Message-Id: <20220214092513.353139500@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
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

commit 85bb289215cf37e05e9581b39b114db1293f9ecd upstream.

During readout we cannot assume the planes are actually using the
slices they are supposed to use. The BIOS may have misprogrammed
things and put the planes onto the wrong dbuf slices. So let's
do the readout more carefully to make sure we really know which
dbuf slices are actually in use by the pipe at the time.

Cc: <stable@vger.kernel.org> # v5.14+
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220204141818.1900-2-ville.syrjala@linux.intel.com
Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
(cherry picked from commit b3dcc6dc0f32612d04839c2fb32e94d0ebf92c98)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/intel_pm.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -6633,6 +6633,7 @@ void skl_wm_get_hw_state(struct drm_i915
 		enum pipe pipe = crtc->pipe;
 		unsigned int mbus_offset;
 		enum plane_id plane_id;
+		u8 slices;
 
 		skl_pipe_wm_get_hw_state(crtc, &crtc_state->wm.skl.optimal);
 		crtc_state->wm.skl.raw = crtc_state->wm.skl.optimal;
@@ -6652,20 +6653,22 @@ void skl_wm_get_hw_state(struct drm_i915
 			skl_ddb_entry_union(&dbuf_state->ddb[pipe], ddb_uv);
 		}
 
-		dbuf_state->slices[pipe] =
-			skl_compute_dbuf_slices(crtc, dbuf_state->active_pipes,
-						dbuf_state->joined_mbus);
-
 		dbuf_state->weight[pipe] = intel_crtc_ddb_weight(crtc_state);
 
 		/*
 		 * Used for checking overlaps, so we need absolute
 		 * offsets instead of MBUS relative offsets.
 		 */
-		mbus_offset = mbus_ddb_offset(dev_priv, dbuf_state->slices[pipe]);
+		slices = skl_compute_dbuf_slices(crtc, dbuf_state->active_pipes,
+						 dbuf_state->joined_mbus);
+		mbus_offset = mbus_ddb_offset(dev_priv, slices);
 		crtc_state->wm.skl.ddb.start = mbus_offset + dbuf_state->ddb[pipe].start;
 		crtc_state->wm.skl.ddb.end = mbus_offset + dbuf_state->ddb[pipe].end;
 
+		/* The slices actually used by the planes on the pipe */
+		dbuf_state->slices[pipe] =
+			skl_ddb_dbuf_slice_mask(dev_priv, &crtc_state->wm.skl.ddb);
+
 		drm_dbg_kms(&dev_priv->drm,
 			    "[CRTC:%d:%s] dbuf slices 0x%x, ddb (%d - %d), active pipes 0x%x, mbus joined: %s\n",
 			    crtc->base.base.id, crtc->base.name,


