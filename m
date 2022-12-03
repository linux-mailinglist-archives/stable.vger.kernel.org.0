Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D04A641697
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 13:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiLCMPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 07:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiLCMPB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 07:15:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730D14A040
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 04:14:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4C2060C1B
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 12:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA505C433C1;
        Sat,  3 Dec 2022 12:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670069698;
        bh=DK1TcX8NnJG/6ELS8j/nk+0v9CV1tVVg51doP3/eR3s=;
        h=Subject:To:Cc:From:Date:From;
        b=kvsPPFPost7PWD5E2kYhLbG52PMdYgTjM8TV5PxAndlJ8nG3qU8ChWq5snp6fpSxM
         I9C3PQRgr+PB9t3B2kAh7AjpcnxM2Ig2ViIwGWEgLBqAFWweXEbSsGPYuccPPAzvf3
         7nv+MSypEfD2I8P1ngySzxfN7h1lCms/z9AH7Ztg=
Subject: FAILED: patch "[PATCH] drm/i915: Remove non-existent pipes from bigjoiner pipe mask" failed to apply to 6.0-stable tree
To:     ville.syrjala@linux.intel.com, arun.r.murthy@intel.com,
        tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 03 Dec 2022 13:14:54 +0100
Message-ID: <16700696941440@kroah.com>
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


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

3c1ea6a5f4f5 ("drm/i915: Remove non-existent pipes from bigjoiner pipe mask")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3c1ea6a5f4f55d4e376675dda16945eb5d9bb4de Mon Sep 17 00:00:00 2001
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
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 461c62c88413..de77054195c6 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -3723,12 +3723,16 @@ static bool ilk_get_pipe_config(struct intel_crtc *crtc,
 
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

