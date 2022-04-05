Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6621D4F2BFD
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353777AbiDEKJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345602AbiDEJWw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:22:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B3D4E39A;
        Tue,  5 Apr 2022 02:11:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECDF2B81A22;
        Tue,  5 Apr 2022 09:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F3EC385A2;
        Tue,  5 Apr 2022 09:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149876;
        bh=kkViTKLxtjTpFBT2dicv1m1kwZOz0euKBQaPrCLNz78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tHimlaVn766KIMMpbatMDM4yVwIFAwlmt5drOftk3pzMDbTordOCIiPMFZc6udYYP
         VYCdf3ntt+FsOkoFCe0rtx5VK7exQiHtgzB7RClheQ2E5lo4LWCAaldUtEhHoUS5X8
         w8GzAZuBed5slWguVsfQSV0jlFWsZ/jsBgCGTffA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 5.16 0872/1017] drm/i915: Treat SAGV block time 0 as SAGV disabled
Date:   Tue,  5 Apr 2022 09:29:45 +0200
Message-Id: <20220405070420.120133998@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
@@ -3712,8 +3712,7 @@ skl_setup_sagv_block_time(struct drm_i91
 		MISSING_CASE(DISPLAY_VER(dev_priv));
 	}
 
-	/* Default to an unusable block time */
-	dev_priv->sagv_block_time_us = -1;
+	dev_priv->sagv_block_time_us = 0;
 }
 
 /*
@@ -5634,7 +5633,7 @@ static void skl_compute_plane_wm(const s
 	result->min_ddb_alloc = max(min_ddb_alloc, blocks) + 1;
 	result->enable = true;
 
-	if (DISPLAY_VER(dev_priv) < 12)
+	if (DISPLAY_VER(dev_priv) < 12 && dev_priv->sagv_block_time_us)
 		result->can_sagv = latency >= dev_priv->sagv_block_time_us;
 }
 
@@ -5665,7 +5664,10 @@ static void tgl_compute_sagv_wm(const st
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


