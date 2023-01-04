Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45FBB65D5FF
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbjADOjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjADOjI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:39:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A362726E1
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:39:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A65CB81339
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7ACCC43392;
        Wed,  4 Jan 2023 14:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672843145;
        bh=0pEbflMFQGLzFj+BJ5lJs8ojA7FjmiXJJZ3z9tlOYN0=;
        h=Subject:To:Cc:From:Date:From;
        b=NFhRUpnn0JDYNSs3w2j2lLSXfPwx7a6tZqNWtV1C1IvAXZ0XvXW2YFFqytVXousmO
         8h82tj3AzjiF2lnURI2T/JB/Ihqk1wep9639kbuprbpYsNrlKnQl7XKKcC/Xc2Tw61
         HWfpOMHrC+FttphHwhcRFmu2ddHmylSoyz8uYSAY=
Subject: FAILED: patch "[PATCH] drm/i915: Remove non-existent pipes from bigjoiner pipe mask" failed to apply to 5.10-stable tree
To:     ville.syrjala@linux.intel.com, arun.r.murthy@intel.com,
        rodrigo.vivi@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:38:50 +0100
Message-ID: <167284313024765@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

ddb97ea7cdb6 ("drm/i915: Remove non-existent pipes from bigjoiner pipe mask")
723559f379af ("drm/i915: Perform correct cpu_transcoder readout for bigjoiner")
a471a526bc38 ("drm/i915: Pimp HSW+ transcoder state readout")
262d88baad8d ("drm/i915: Extract hsw_panel_transcoders()")
005e95377249 ("drm/i915/display: Eliminate most usage of INTEL_GEN()")
984982f3ef7b ("drm/i915/ilk-glk: Fix link training on links with LTTPRs")
d0ab409d05fe ("drm/i915/bios: add helper functions to check output support")
dbd440d8e088 ("drm/i915/bios: mass convert dev_priv to i915")
35bb28ece90d ("Merge drm/drm-next into drm-intel-next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ddb97ea7cdb6462d7a719c649f58858b083f7eed Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Fri, 18 Nov 2022 20:52:01 +0200
Subject: [PATCH] drm/i915: Remove non-existent pipes from bigjoiner pipe mask
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

bigjoiner_pipes() doesn't consider that:
- RKL only has three pipes
- some pipes may be fused off

This means that intel_atomic_check_bigjoiner() won't reject
all configurations that would need a non-existent pipe.
Instead we just keep on rolling witout actually having
reserved the slave pipe we need.

It's possible that we don't outright explode anywhere due to
this since eg. for_each_intel_crtc_in_pipe_mask() will only
walk the crtcs we've registered even though the passed in
pipe_mask asks for more of them. But clearly the thing won't
do what is expected of it when the required pipes are not
present.

Fix the problem by consulting the device info pipe_mask already
in bigjoiner_pipes().

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221118185201.10469-1-ville.syrjala@linux.intel.com
Reviewed-by: Arun R Murthy <arun.r.murthy@intel.com>
(cherry picked from commit f1c87a94a1087a26f41007ee83264033007421b5)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index b3e23708d194..6c2686ecb62a 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -3733,12 +3733,16 @@ static bool ilk_get_pipe_config(struct intel_crtc *crtc,
 
 static u8 bigjoiner_pipes(struct drm_i915_private *i915)
 {
+	u8 pipes;
+
 	if (DISPLAY_VER(i915) >= 12)
-		return BIT(PIPE_A) | BIT(PIPE_B) | BIT(PIPE_C) | BIT(PIPE_D);
+		pipes = BIT(PIPE_A) | BIT(PIPE_B) | BIT(PIPE_C) | BIT(PIPE_D);
 	else if (DISPLAY_VER(i915) >= 11)
-		return BIT(PIPE_B) | BIT(PIPE_C);
+		pipes = BIT(PIPE_B) | BIT(PIPE_C);
 	else
-		return 0;
+		pipes = 0;
+
+	return pipes & RUNTIME_INFO(i915)->pipe_mask;
 }
 
 static bool transcoder_ddi_func_is_enabled(struct drm_i915_private *dev_priv,

