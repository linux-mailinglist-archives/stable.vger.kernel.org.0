Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EABA465D661
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239683AbjADOpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:45:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239685AbjADOo5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:44:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458B038AC8
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:44:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6DB9B81673
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B20C433F1;
        Wed,  4 Jan 2023 14:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672843493;
        bh=7seQsMiRD//vfxQ5uMyEOR7EbMakIyhQHhXk4cs3SU0=;
        h=Subject:To:Cc:From:Date:From;
        b=krMIe/fctnN4qMudnChSy7l8yVhzsMoXnHsKDeyvb6d8dq+ddD96Oj6ui41+3jrjl
         vUwzMmzwIEB/uRdqeK1ovjOVKOoNTUYVrTfbTKagqqDl1QdxnBKTq41ipQplHTNtR7
         4nvDSgIVGnXi8xlihc4Zj4J/5V1sXLpfsUTHoFTg=
Subject: FAILED: patch "[PATCH] drm/i915/sdvo: Filter out invalid outputs more sensibly" failed to apply to 6.0-stable tree
To:     ville.syrjala@linux.intel.com, jani.nikula@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:44:44 +0100
Message-ID: <16728434849887@kroah.com>
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

cc1e66394daa ("drm/i915/sdvo: Filter out invalid outputs more sensibly")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cc1e66394daaa7e9f005e2487a84e34a39f9308b Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Wed, 26 Oct 2022 13:11:27 +0300
Subject: [PATCH] drm/i915/sdvo: Filter out invalid outputs more sensibly
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We try to filter out the corresponding xxx1 output
if the xxx0 output is not present. But the way that is
being done is pretty awkward. Make it less so.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221026101134.20865-2-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_sdvo.c b/drivers/gpu/drm/i915/display/intel_sdvo.c
index 8852564b5fbf..c38b75fbabd3 100644
--- a/drivers/gpu/drm/i915/display/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/display/intel_sdvo.c
@@ -2934,16 +2934,33 @@ intel_sdvo_lvds_init(struct intel_sdvo *intel_sdvo, int device)
 	return false;
 }
 
+static u16 intel_sdvo_filter_output_flags(u16 flags)
+{
+	flags &= SDVO_OUTPUT_MASK;
+
+	/* SDVO requires XXX1 function may not exist unless it has XXX0 function.*/
+	if (!(flags & SDVO_OUTPUT_TMDS0))
+		flags &= ~SDVO_OUTPUT_TMDS1;
+
+	if (!(flags & SDVO_OUTPUT_RGB0))
+		flags &= ~SDVO_OUTPUT_RGB1;
+
+	if (!(flags & SDVO_OUTPUT_LVDS0))
+		flags &= ~SDVO_OUTPUT_LVDS1;
+
+	return flags;
+}
+
 static bool
 intel_sdvo_output_setup(struct intel_sdvo *intel_sdvo, u16 flags)
 {
-	/* SDVO requires XXX1 function may not exist unless it has XXX0 function.*/
+	flags = intel_sdvo_filter_output_flags(flags);
 
 	if (flags & SDVO_OUTPUT_TMDS0)
 		if (!intel_sdvo_dvi_init(intel_sdvo, 0))
 			return false;
 
-	if ((flags & SDVO_TMDS_MASK) == SDVO_TMDS_MASK)
+	if (flags & SDVO_OUTPUT_TMDS1)
 		if (!intel_sdvo_dvi_init(intel_sdvo, 1))
 			return false;
 
@@ -2964,7 +2981,7 @@ intel_sdvo_output_setup(struct intel_sdvo *intel_sdvo, u16 flags)
 		if (!intel_sdvo_analog_init(intel_sdvo, 0))
 			return false;
 
-	if ((flags & SDVO_RGB_MASK) == SDVO_RGB_MASK)
+	if (flags & SDVO_OUTPUT_RGB1)
 		if (!intel_sdvo_analog_init(intel_sdvo, 1))
 			return false;
 
@@ -2972,11 +2989,11 @@ intel_sdvo_output_setup(struct intel_sdvo *intel_sdvo, u16 flags)
 		if (!intel_sdvo_lvds_init(intel_sdvo, 0))
 			return false;
 
-	if ((flags & SDVO_LVDS_MASK) == SDVO_LVDS_MASK)
+	if (flags & SDVO_OUTPUT_LVDS1)
 		if (!intel_sdvo_lvds_init(intel_sdvo, 1))
 			return false;
 
-	if ((flags & SDVO_OUTPUT_MASK) == 0) {
+	if (flags == 0) {
 		unsigned char bytes[2];
 
 		intel_sdvo->controlled_output = 0;

