Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2D860BB1C
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234482AbiJXUrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235142AbiJXUqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:46:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B5911A3D;
        Mon, 24 Oct 2022 11:54:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98481612FB;
        Mon, 24 Oct 2022 12:39:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7C0C433C1;
        Mon, 24 Oct 2022 12:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615167;
        bh=EYLYx3bDsQItGVbTLVcNlZR3otBYcw1zafLK5+iRb7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v+ioCZkFsCjljdMPqCEt9PvzHeOKHxQ2sbwLlM5kA4+MA7YD25skNqxjlEo7I2Nuz
         bQE7zQgnSYvRVeXzCKcJ43hdikaNrBOg5/R5MtLF4e4NW1k3vCPyhvzvxTorJ74J57
         oDIBVNVbF6b7UQRe6BoJjGd03rut7pxkRK6+scPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 5.15 130/530] drm/i915: Fix watermark calculations for gen12+ RC CCS modifier
Date:   Mon, 24 Oct 2022 13:27:54 +0200
Message-Id: <20221024113050.937271224@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit c56453a00f19ccddee302f5f9fe96b80e0b47fd3 upstream.

Take the gen12+ RC CCS modifier into account when calculating the
watermarks. Othwerwise we'll calculate the watermarks thinking this
Y-tiled modifier is linear.

The rc_surface part is actually a nop since that is not used
for any glk+ platform.

v2: Split RC CCS vs. MC CCS to separate patches

Cc: stable@vger.kernel.org
Fixes: b3e57bccd68a ("drm/i915/tgl: Gen-12 render decompression")
Reviewed-by: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221003111544.8007-2-ville.syrjala@linux.intel.com
(cherry picked from commit a89a96a586114f67598c6391c75678b4dba5c2da)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/intel_pm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -5402,10 +5402,12 @@ skl_compute_wm_params(const struct intel
 	wp->y_tiled = modifier == I915_FORMAT_MOD_Y_TILED ||
 		      modifier == I915_FORMAT_MOD_Yf_TILED ||
 		      modifier == I915_FORMAT_MOD_Y_TILED_CCS ||
-		      modifier == I915_FORMAT_MOD_Yf_TILED_CCS;
+		      modifier == I915_FORMAT_MOD_Yf_TILED_CCS ||
+		      modifier == I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS;
 	wp->x_tiled = modifier == I915_FORMAT_MOD_X_TILED;
 	wp->rc_surface = modifier == I915_FORMAT_MOD_Y_TILED_CCS ||
-			 modifier == I915_FORMAT_MOD_Yf_TILED_CCS;
+			 modifier == I915_FORMAT_MOD_Yf_TILED_CCS ||
+			 modifier == I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS;
 	wp->is_planar = intel_format_info_is_yuv_semiplanar(format, modifier);
 
 	wp->width = width;


