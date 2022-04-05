Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664124F399E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349757AbiDELg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234314AbiDEKGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:06:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04405A586;
        Tue,  5 Apr 2022 02:55:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30B016157A;
        Tue,  5 Apr 2022 09:55:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C62EC385A1;
        Tue,  5 Apr 2022 09:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152506;
        bh=Pr4aKhIQBUBvr2CVTrgZDggDkLUzxmhsvq+8w46iZfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YZQYowiXcbm1NHD8Bvuks1nwg8thJHtrYPE5WCKzIos7Zah+xUax1cPq/zpOJrYfG
         LBK+8u6GHhj2rAmReRvqLcNzSwhbSD2xpOKXTEvc540npb1rPsfdzBAc2CgSZsnqBp
         usxzjYi+nZc0DmFfAZRgJzJet66wNYYPjA1MPlkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 5.15 784/913] drm/i915: Treat SAGV block time 0 as SAGV disabled
Date:   Tue,  5 Apr 2022 09:30:46 +0200
Message-Id: <20220405070403.335304555@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 1937f3feb0e84089ae4065e09c871b8ab4676f01 upstream.

For modern platforms the spec explicitly states that a
SAGV block time of zero means that SAGV is not supported.
Let's extend that to all platforms. Supposedly there should
be no systems where this isn't true, and it'll allow us to:
- use the same code regardless of older vs. newer platform
- wm latencies already treat 0 as disabled, so this fits well
  with other related code
- make it a bit more clear when SAGV is used vs. not
- avoid overflows from adding U32_MAX with a u16 wm0 latency value
  which could cause us to miscalculate the SAGV watermarks on tgl+

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220309164948.10671-2-ville.syrjala@linux.intel.com
Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
(cherry picked from commit d8f5855b31c0523ea3b171db8dfb998830e8735d)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/intel_pm.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -3713,8 +3713,7 @@ skl_setup_sagv_block_time(struct drm_i91
 		MISSING_CASE(DISPLAY_VER(dev_priv));
 	}
 
-	/* Default to an unusable block time */
-	dev_priv->sagv_block_time_us = -1;
+	dev_priv->sagv_block_time_us = 0;
 }
 
 /*
@@ -5635,7 +5634,7 @@ static void skl_compute_plane_wm(const s
 	result->min_ddb_alloc = max(min_ddb_alloc, blocks) + 1;
 	result->enable = true;
 
-	if (DISPLAY_VER(dev_priv) < 12)
+	if (DISPLAY_VER(dev_priv) < 12 && dev_priv->sagv_block_time_us)
 		result->can_sagv = latency >= dev_priv->sagv_block_time_us;
 }
 
@@ -5666,7 +5665,10 @@ static void tgl_compute_sagv_wm(const st
 	struct drm_i915_private *dev_priv = to_i915(crtc_state->uapi.crtc->dev);
 	struct skl_wm_level *sagv_wm = &plane_wm->sagv.wm0;
 	struct skl_wm_level *levels = plane_wm->wm;
-	unsigned int latency = dev_priv->wm.skl_latency[0] + dev_priv->sagv_block_time_us;
+	unsigned int latency = 0;
+
+	if (dev_priv->sagv_block_time_us)
+		latency = dev_priv->sagv_block_time_us + dev_priv->wm.skl_latency[0];
 
 	skl_compute_plane_wm(crtc_state, 0, latency,
 			     wm_params, &levels[0],


