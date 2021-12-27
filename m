Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2EA147FC1C
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 12:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236311AbhL0LQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 06:16:29 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39898 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233404AbhL0LQ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 06:16:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09677B80E73
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 11:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623FBC36AEA;
        Mon, 27 Dec 2021 11:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640603786;
        bh=KGl0tCRJpH0AZvSEIvkzQ0gRDJp/mSctLs1UFI6Lds0=;
        h=Subject:To:Cc:From:Date:From;
        b=brorPxpGz7dEiqHXRBvYmI1j024Un7JzV88oNafvAqFN0ZoPvgigmWBUZcdl1sF0y
         pWNMUi7NzYnYqJk8IJFthnHJXxAZsa7IqZIrcce80+aUPgY53862dzkQYpDO/KWMbO
         f77yctWlBvTbcNh2cbGqUd5OrEVv9BU6CfK3z59A=
Subject: FAILED: patch "[PATCH] ALSA: hda/hdmi: Disable silent stream on GLK" failed to apply to 5.10-stable tree
To:     ville.syrjala@linux.intel.com, emmanuel.jillela@intel.com,
        harshapriya.n@intel.com, kai.vehmanen@linux.intel.com,
        tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Dec 2021 12:16:24 +0100
Message-ID: <164060378324814@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b6fd77472dea76b7a2bad3a338ade920152972b8 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Wed, 22 Dec 2021 16:53:50 +0200
Subject: [PATCH] ALSA: hda/hdmi: Disable silent stream on GLK
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The silent stream stuff recurses back into i915 audio
component .get_power() from the .pin_eld_notify() hook.
On GLK this will deadlock as i915 may already be holding
the relevant modeset locks during .pin_eld_notify() and
the GLK audio vs. CDCLK workaround will try to grab the
same locks from .get_power().

Until someone comes up with a better fix just disable the
silent stream support on GLK.

Cc: stable@vger.kernel.org
Cc: Harsha Priya <harshapriya.n@intel.com>
Cc: Emmanuel Jillela <emmanuel.jillela@intel.com>
Cc: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Cc: Takashi Iwai <tiwai@suse.de>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2623
Fixes: 951894cf30f4 ("ALSA: hda/hdmi: Add Intel silent stream support")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20211222145350.24342-1-ville.syrjala@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 415701bd10ac..ffcde7409d2a 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2947,7 +2947,8 @@ static int parse_intel_hdmi(struct hda_codec *codec)
 
 /* Intel Haswell and onwards; audio component with eld notifier */
 static int intel_hsw_common_init(struct hda_codec *codec, hda_nid_t vendor_nid,
-				 const int *port_map, int port_num, int dev_num)
+				 const int *port_map, int port_num, int dev_num,
+				 bool send_silent_stream)
 {
 	struct hdmi_spec *spec;
 	int err;
@@ -2980,7 +2981,7 @@ static int intel_hsw_common_init(struct hda_codec *codec, hda_nid_t vendor_nid,
 	 * Enable silent stream feature, if it is enabled via
 	 * module param or Kconfig option
 	 */
-	if (enable_silent_stream)
+	if (send_silent_stream)
 		spec->send_silent_stream = true;
 
 	return parse_intel_hdmi(codec);
@@ -2988,12 +2989,18 @@ static int intel_hsw_common_init(struct hda_codec *codec, hda_nid_t vendor_nid,
 
 static int patch_i915_hsw_hdmi(struct hda_codec *codec)
 {
-	return intel_hsw_common_init(codec, 0x08, NULL, 0, 3);
+	return intel_hsw_common_init(codec, 0x08, NULL, 0, 3,
+				     enable_silent_stream);
 }
 
 static int patch_i915_glk_hdmi(struct hda_codec *codec)
 {
-	return intel_hsw_common_init(codec, 0x0b, NULL, 0, 3);
+	/*
+	 * Silent stream calls audio component .get_power() from
+	 * .pin_eld_notify(). On GLK this will deadlock in i915 due
+	 * to the audio vs. CDCLK workaround.
+	 */
+	return intel_hsw_common_init(codec, 0x0b, NULL, 0, 3, false);
 }
 
 static int patch_i915_icl_hdmi(struct hda_codec *codec)
@@ -3004,7 +3011,8 @@ static int patch_i915_icl_hdmi(struct hda_codec *codec)
 	 */
 	static const int map[] = {0x0, 0x4, 0x6, 0x8, 0xa, 0xb};
 
-	return intel_hsw_common_init(codec, 0x02, map, ARRAY_SIZE(map), 3);
+	return intel_hsw_common_init(codec, 0x02, map, ARRAY_SIZE(map), 3,
+				     enable_silent_stream);
 }
 
 static int patch_i915_tgl_hdmi(struct hda_codec *codec)
@@ -3016,7 +3024,8 @@ static int patch_i915_tgl_hdmi(struct hda_codec *codec)
 	static const int map[] = {0x4, 0x6, 0x8, 0xa, 0xb, 0xc, 0xd, 0xe, 0xf};
 	int ret;
 
-	ret = intel_hsw_common_init(codec, 0x02, map, ARRAY_SIZE(map), 4);
+	ret = intel_hsw_common_init(codec, 0x02, map, ARRAY_SIZE(map), 4,
+				    enable_silent_stream);
 	if (!ret) {
 		struct hdmi_spec *spec = codec->spec;
 

