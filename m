Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284454B4AF0
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233286AbiBNKC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:02:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345834AbiBNKB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:01:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C9621814;
        Mon, 14 Feb 2022 01:48:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C02F612B9;
        Mon, 14 Feb 2022 09:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727EFC340E9;
        Mon, 14 Feb 2022 09:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832098;
        bh=MbSHCHXogXO/l9udJIk4KccQimuLH1gcj/TSEWYt/1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kCzvxMMUho8RmknQVUx60cMF2IF/3uVO2NJsJtVuMPoJSw0or/T/i2mqEyp2+rVF5
         fb1pi816WZ6zdD9+wl749Hk0eKxdO/pobpO3tONhhulC8nyUwgHtb0DzPjAYRCEtun
         JDQETn3vNpdAwQ0l8QIXo0SfPIXW2Mb9nSNNfzXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 5.15 079/172] drm/i915: Populate pipe dbuf slices more accurately during readout
Date:   Mon, 14 Feb 2022 10:25:37 +0100
Message-Id: <20220214092509.136792344@linuxfoundation.org>
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
@@ -6634,6 +6634,7 @@ void skl_wm_get_hw_state(struct drm_i915
 		enum pipe pipe = crtc->pipe;
 		unsigned int mbus_offset;
 		enum plane_id plane_id;
+		u8 slices;
 
 		skl_pipe_wm_get_hw_state(crtc, &crtc_state->wm.skl.optimal);
 		crtc_state->wm.skl.raw = crtc_state->wm.skl.optimal;
@@ -6653,20 +6654,22 @@ void skl_wm_get_hw_state(struct drm_i915
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


