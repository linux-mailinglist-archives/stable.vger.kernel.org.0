Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914AA608624
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbiJVHpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbiJVHoN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:44:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29C024E41E;
        Sat, 22 Oct 2022 00:42:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8ACC3B82E11;
        Sat, 22 Oct 2022 07:41:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01325C433C1;
        Sat, 22 Oct 2022 07:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424506;
        bh=vDh+4og9bBnPj3fOvVgtxmdHkxQfnDXV9tv1ixuoxjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M0EFJcciNZPZurLKtKHJLA+wgQbm0zqErRdvc8bR5ro39mP8BZ6BdPSGVv/W0o3ra
         OHd6wJrvfxISBEg7ywKWTWfhmR7cFkE41Z9erClLbRikchw0GbQUb++OSuulyfPYaj
         3GpGXTbZgpwUJh9BccZI6F2BceS8/9oF2ZcrzfKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 5.19 172/717] drm/i915: Fix watermark calculations for DG2 CCS+CC modifier
Date:   Sat, 22 Oct 2022 09:20:51 +0200
Message-Id: <20221022072445.967040206@linuxfoundation.org>
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

commit b2e3a1af8cce4117de06ff1a4eab0749753ede27 upstream.

Take the DG2 CCS+CC modifier into account when calculating the
watermarks. Othwerwise we'll calculate the watermarks thinking this
tile-4 modifier is linear.

The rc_surface part is actually a nop since that is not used
for any glk+ platform.

Cc: stable@vger.kernel.org
Fixes: 680025dcc400 ("drm/i915/dg2: Add support for DG2 clear color compression")
Reviewed-by: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221003111544.8007-6-ville.syrjala@linux.intel.com
(cherry picked from commit 334810f82024815283a6e7febd3d2de1fed6c232)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/intel_pm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -5312,7 +5312,8 @@ skl_compute_wm_params(const struct intel
 		      modifier == I915_FORMAT_MOD_Y_TILED_GEN12_MC_CCS ||
 		      modifier == I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS_CC ||
 		      modifier == I915_FORMAT_MOD_4_TILED_DG2_RC_CCS ||
-		      modifier == I915_FORMAT_MOD_4_TILED_DG2_MC_CCS;
+		      modifier == I915_FORMAT_MOD_4_TILED_DG2_MC_CCS ||
+		      modifier == I915_FORMAT_MOD_4_TILED_DG2_RC_CCS_CC;
 	wp->x_tiled = modifier == I915_FORMAT_MOD_X_TILED;
 	wp->rc_surface = modifier == I915_FORMAT_MOD_Y_TILED_CCS ||
 			 modifier == I915_FORMAT_MOD_Yf_TILED_CCS ||
@@ -5320,7 +5321,8 @@ skl_compute_wm_params(const struct intel
 			 modifier == I915_FORMAT_MOD_Y_TILED_GEN12_MC_CCS ||
 			 modifier == I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS_CC ||
 			 modifier == I915_FORMAT_MOD_4_TILED_DG2_RC_CCS ||
-			 modifier == I915_FORMAT_MOD_4_TILED_DG2_MC_CCS;
+			 modifier == I915_FORMAT_MOD_4_TILED_DG2_MC_CCS ||
+			 modifier == I915_FORMAT_MOD_4_TILED_DG2_RC_CCS_CC;
 	wp->is_planar = intel_format_info_is_yuv_semiplanar(format, modifier);
 
 	wp->width = width;


