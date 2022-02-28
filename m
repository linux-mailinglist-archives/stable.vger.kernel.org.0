Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E74424C7621
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234919AbiB1R74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239983AbiB1R7J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:59:09 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22785B3E6;
        Mon, 28 Feb 2022 09:45:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 547C4CE17D1;
        Mon, 28 Feb 2022 17:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648B9C340E7;
        Mon, 28 Feb 2022 17:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070308;
        bh=0+G/jHiDBvpeRX0yJRZinnxdfXV2KZtk2TgUzypQAWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C6aDWtSFOEWNrapkbjNYsCTIEBObqTi32EOs+lfB6gf0kDtZfeUy+k0SDKsLcOjB9
         qr/hM15WnXzB+1vmds9oAo0euODU+a3TSdiKRo8Y29AitxoBrZf///sbKkWdP3D5uM
         MrCy6xPxYFQRfrPZOzA51A/pV+EH36RqsHhrWSEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 5.16 025/164] drm/i915: Correctly populate use_sagv_wm for all pipes
Date:   Mon, 28 Feb 2022 18:23:07 +0100
Message-Id: <20220228172402.400359034@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit afc189df6bcc6be65961deb54e15ec60e7f85337 upstream.

When changing between SAGV vs. no SAGV on tgl+ we have to
update the use_sagv_wm flag for all the crtcs or else
an active pipe not already in the state will end up using
the wrong watermarks. That is especially bad when we end up
with the tighter non-SAGV watermarks with SAGV enabled.
Usually ends up in underruns.

Cc: stable@vger.kernel.org
Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Fixes: 7241c57d3140 ("drm/i915: Add TGL+ SAGV support")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220218064039.12834-2-ville.syrjala@linux.intel.com
(cherry picked from commit 8dd8ffb824ca7b897ce9f2082ffa7e64831c22dc)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/intel_pm.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -4019,6 +4019,17 @@ static int intel_compute_sagv_mask(struc
 			return ret;
 	}
 
+	if (intel_can_enable_sagv(dev_priv, new_bw_state) !=
+	    intel_can_enable_sagv(dev_priv, old_bw_state)) {
+		ret = intel_atomic_serialize_global_state(&new_bw_state->base);
+		if (ret)
+			return ret;
+	} else if (new_bw_state->pipe_sagv_reject != old_bw_state->pipe_sagv_reject) {
+		ret = intel_atomic_lock_global_state(&new_bw_state->base);
+		if (ret)
+			return ret;
+	}
+
 	for_each_new_intel_crtc_in_state(state, crtc,
 					 new_crtc_state, i) {
 		struct skl_pipe_wm *pipe_wm = &new_crtc_state->wm.skl.optimal;
@@ -4034,17 +4045,6 @@ static int intel_compute_sagv_mask(struc
 			intel_can_enable_sagv(dev_priv, new_bw_state);
 	}
 
-	if (intel_can_enable_sagv(dev_priv, new_bw_state) !=
-	    intel_can_enable_sagv(dev_priv, old_bw_state)) {
-		ret = intel_atomic_serialize_global_state(&new_bw_state->base);
-		if (ret)
-			return ret;
-	} else if (new_bw_state->pipe_sagv_reject != old_bw_state->pipe_sagv_reject) {
-		ret = intel_atomic_lock_global_state(&new_bw_state->base);
-		if (ret)
-			return ret;
-	}
-
 	return 0;
 }
 


