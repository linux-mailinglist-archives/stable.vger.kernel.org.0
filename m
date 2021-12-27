Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C957D4800BF
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240091AbhL0PtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240115AbhL0PrJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:47:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A65AC061799;
        Mon, 27 Dec 2021 07:43:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41F29B810AA;
        Mon, 27 Dec 2021 15:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896A5C36AEA;
        Mon, 27 Dec 2021 15:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619785;
        bh=Is5ajmjBZ3pPB360/05m2xzCA3wiVN8ciGCE2IAx1jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9ARz3xkmDpIZGdwOJjctMloHu3DD9kDW+WaMpwtuM932pv8jd0KB+zdH+YYscc9E
         JnKmvrT9Pcbt7IHjPwCHVN5G43CcvAAU7bKnPyJegEHx0q5Mi6a6o1RwMUwQpMQhOU
         s5yZZMldu0F6rEFaKwLAjFJYbslucvKbEvVVAtBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harsha Priya <harshapriya.n@intel.com>,
        Emmanuel Jillela <emmanuel.jillela@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>
Subject: [PATCH 5.15 068/128] ALSA: hda/hdmi: Disable silent stream on GLK
Date:   Mon, 27 Dec 2021 16:30:43 +0100
Message-Id: <20211227151333.763895602@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit b6fd77472dea76b7a2bad3a338ade920152972b8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2947,7 +2947,8 @@ static int parse_intel_hdmi(struct hda_c
 
 /* Intel Haswell and onwards; audio component with eld notifier */
 static int intel_hsw_common_init(struct hda_codec *codec, hda_nid_t vendor_nid,
-				 const int *port_map, int port_num, int dev_num)
+				 const int *port_map, int port_num, int dev_num,
+				 bool send_silent_stream)
 {
 	struct hdmi_spec *spec;
 	int err;
@@ -2980,7 +2981,7 @@ static int intel_hsw_common_init(struct
 	 * Enable silent stream feature, if it is enabled via
 	 * module param or Kconfig option
 	 */
-	if (enable_silent_stream)
+	if (send_silent_stream)
 		spec->send_silent_stream = true;
 
 	return parse_intel_hdmi(codec);
@@ -2988,12 +2989,18 @@ static int intel_hsw_common_init(struct
 
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
@@ -3004,7 +3011,8 @@ static int patch_i915_icl_hdmi(struct hd
 	 */
 	static const int map[] = {0x0, 0x4, 0x6, 0x8, 0xa, 0xb};
 
-	return intel_hsw_common_init(codec, 0x02, map, ARRAY_SIZE(map), 3);
+	return intel_hsw_common_init(codec, 0x02, map, ARRAY_SIZE(map), 3,
+				     enable_silent_stream);
 }
 
 static int patch_i915_tgl_hdmi(struct hda_codec *codec)
@@ -3016,7 +3024,8 @@ static int patch_i915_tgl_hdmi(struct hd
 	static const int map[] = {0x4, 0x6, 0x8, 0xa, 0xb, 0xc, 0xd, 0xe, 0xf};
 	int ret;
 
-	ret = intel_hsw_common_init(codec, 0x02, map, ARRAY_SIZE(map), 4);
+	ret = intel_hsw_common_init(codec, 0x02, map, ARRAY_SIZE(map), 4,
+				    enable_silent_stream);
 	if (!ret) {
 		struct hdmi_spec *spec = codec->spec;
 


