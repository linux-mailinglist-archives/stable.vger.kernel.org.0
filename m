Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E2947D3F9
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 15:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343588AbhLVOxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 09:53:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:51264 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343584AbhLVOxz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Dec 2021 09:53:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640184835; x=1671720835;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bAseApf6JW1lbHQZ+HyK2OYNwYtMAdNiHOC3b7ofL/8=;
  b=gMnLDzgO+jzgn/nMfvbU+3o3D2fNQdkjYM8OUSNgv5wnkJmPBPsftKiY
   G8S/J0hbk/BpI7XbZpS1gi1/yrpdbnB3M0EiXxZ4trQCXEhtPy1OPdSel
   NUkXR0m669y3BFQq8sFxMAeJbT+BvvvQX5BZGkHJquOae4+4Kcms/mIco
   fZZp43Z9AYenYQHFAM9xgXQaY74riTlMd+CiUHU5FmkHkSZsPcm4HErcg
   isJvtDElODKtd5dDQNXzNoedKNOVMD9q15xjQrrYkCK4jz+UOUNFrnlJL
   2Sh5E5QCxgpabuTkIoO568VHkl+xqGhOMGwOZaRfEZ/Q4QUWm0SwYs35s
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="238167602"
X-IronPort-AV: E=Sophos;i="5.88,226,1635231600"; 
   d="scan'208";a="238167602"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 06:53:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,226,1635231600"; 
   d="scan'208";a="549456049"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.147])
  by orsmga001.jf.intel.com with SMTP; 22 Dec 2021 06:53:50 -0800
Received: by stinkbox (sSMTP sendmail emulation); Wed, 22 Dec 2021 16:53:50 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     alsa-devel@alsa-project.org
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        Harsha Priya <harshapriya.n@intel.com>,
        Emmanuel Jillela <emmanuel.jillela@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH] ALSA: hda/hdmi: Disable silent stream on GLK
Date:   Wed, 22 Dec 2021 16:53:50 +0200
Message-Id: <20211222145350.24342-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

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
---
 sound/pci/hda/patch_hdmi.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

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
 
-- 
2.32.0

