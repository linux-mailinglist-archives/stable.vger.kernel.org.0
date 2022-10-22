Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65436086A5
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbiJVHvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbiJVHtm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:49:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC5AA3BAF;
        Sat, 22 Oct 2022 00:46:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD7B460AD7;
        Sat, 22 Oct 2022 07:43:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C90C433C1;
        Sat, 22 Oct 2022 07:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424584;
        bh=3PR6sUObPij7sEd4A9yXYTD7viHJGZI8dn9CQg8XTVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P1T9xaAmWYKQT6mNc3MjKSvmfXEJcbBKiMA2bGnsMsjBNXzrFzJhMfwxF0DGs2il2
         lTPcJEjNdDwJB6GkRwkJs9lcEcChA2CmHZ9use8Jw0tH1WapR5RRI20jf2foZgpwWr
         xr13ziZDrUb2fWD8XKc38ycOEWZzQVe0v2nHwGGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 5.19 170/717] drm/i915: Fix watermark calculations for gen12+ CCS+CC modifier
Date:   Sat, 22 Oct 2022 09:20:49 +0200
Message-Id: <20221022072445.587997579@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 070a2855900de17b1e11a0dc35af9794e80f1a28 upstream.

Take the gen12+ CCS+CC modifier into account when calculating the
watermarks. Othwerwise we'll calculate the watermarks thinking this
Y-tiled modifier is linear.

The rc_surface part is actually a nop since that is not used
for any glk+ platform.

Cc: stable@vger.kernel.org
Fixes: d1e2775e9b96 ("drm/i915/tgl: Add Clear Color support for TGL Render Decompression")
Reviewed-by: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221003111544.8007-4-ville.syrjala@linux.intel.com
(cherry picked from commit a627455bbe50a111475d7a42beb58fa64bd96c83)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/intel_pm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -5309,12 +5309,14 @@ skl_compute_wm_params(const struct intel
 		      modifier == I915_FORMAT_MOD_Y_TILED_CCS ||
 		      modifier == I915_FORMAT_MOD_Yf_TILED_CCS ||
 		      modifier == I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS ||
-		      modifier == I915_FORMAT_MOD_Y_TILED_GEN12_MC_CCS;
+		      modifier == I915_FORMAT_MOD_Y_TILED_GEN12_MC_CCS ||
+		      modifier == I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS_CC;
 	wp->x_tiled = modifier == I915_FORMAT_MOD_X_TILED;
 	wp->rc_surface = modifier == I915_FORMAT_MOD_Y_TILED_CCS ||
 			 modifier == I915_FORMAT_MOD_Yf_TILED_CCS ||
 			 modifier == I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS ||
-			 modifier == I915_FORMAT_MOD_Y_TILED_GEN12_MC_CCS;
+			 modifier == I915_FORMAT_MOD_Y_TILED_GEN12_MC_CCS ||
+			 modifier == I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS_CC;
 	wp->is_planar = intel_format_info_is_yuv_semiplanar(format, modifier);
 
 	wp->width = width;


