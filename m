Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F50382E81
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238113AbhEQOIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:08:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237903AbhEQOHA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:07:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57636611EE;
        Mon, 17 May 2021 14:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260343;
        bh=U8rsntay85eppEKTFN+l4F5otujEXnDUOLfZdQ9xdp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k39anp4r/gdLye6UtBYak5TpBeMRcCPB3LF4GFRDQCiRkK/i/3TlB/jLOqgfQXdfC
         y860y2Bb2+/Cl81gUht9kTJ9nwbkEzlcLJm6d1hZFSJfJWe3zw/IX/S9eaM5Vx0Q/t
         CnsIOnKj59RX/oyiOh8vOIHPPooL9GdXiY/4GFhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 039/363] ALSA: hda/hdmi: fix max DP-MST dev_num for Intel TGL+ platforms
Date:   Mon, 17 May 2021 15:58:25 +0200
Message-Id: <20210517140303.915074176@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit e839fbed26e8b8713803b8ac73da92fd2b0c7594 ]

Increase the device select range to 4 on platforms supporting
4 concurrent displays.

This fixes a problem in scenario where total of 4 displays are active,
and 3 of these are audio capable DP receivers and connected to a DP-MST
hub. Due to incorrect range for device select, audio could not be played
to the 3rd monitor in DP-MST hub.

BugLink: https://github.com/thesofproject/linux/issues/2798
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Link: https://lore.kernel.org/r/20210324172337.51730-1-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 45ae845e82df..5de3666a7101 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1848,16 +1848,12 @@ static int hdmi_add_pin(struct hda_codec *codec, hda_nid_t pin_nid)
 	 */
 	if (spec->intel_hsw_fixup) {
 		/*
-		 * On Intel platforms, device entries number is
-		 * changed dynamically. If there is a DP MST
-		 * hub connected, the device entries number is 3.
-		 * Otherwise, it is 1.
-		 * Here we manually set dev_num to 3, so that
-		 * we can initialize all the device entries when
-		 * bootup statically.
+		 * On Intel platforms, device entries count returned
+		 * by AC_PAR_DEVLIST_LEN is dynamic, and depends on
+		 * the type of receiver that is connected. Allocate pin
+		 * structures based on worst case.
 		 */
-		dev_num = 3;
-		spec->dev_num = 3;
+		dev_num = spec->dev_num;
 	} else if (spec->dyn_pcm_assign && codec->dp_mst) {
 		dev_num = snd_hda_get_num_devices(codec, pin_nid) + 1;
 		/*
@@ -2942,7 +2938,7 @@ static int parse_intel_hdmi(struct hda_codec *codec)
 
 /* Intel Haswell and onwards; audio component with eld notifier */
 static int intel_hsw_common_init(struct hda_codec *codec, hda_nid_t vendor_nid,
-				 const int *port_map, int port_num)
+				 const int *port_map, int port_num, int dev_num)
 {
 	struct hdmi_spec *spec;
 	int err;
@@ -2957,6 +2953,7 @@ static int intel_hsw_common_init(struct hda_codec *codec, hda_nid_t vendor_nid,
 	spec->port_map = port_map;
 	spec->port_num = port_num;
 	spec->intel_hsw_fixup = true;
+	spec->dev_num = dev_num;
 
 	intel_haswell_enable_all_pins(codec, true);
 	intel_haswell_fixup_enable_dp12(codec);
@@ -2982,12 +2979,12 @@ static int intel_hsw_common_init(struct hda_codec *codec, hda_nid_t vendor_nid,
 
 static int patch_i915_hsw_hdmi(struct hda_codec *codec)
 {
-	return intel_hsw_common_init(codec, 0x08, NULL, 0);
+	return intel_hsw_common_init(codec, 0x08, NULL, 0, 3);
 }
 
 static int patch_i915_glk_hdmi(struct hda_codec *codec)
 {
-	return intel_hsw_common_init(codec, 0x0b, NULL, 0);
+	return intel_hsw_common_init(codec, 0x0b, NULL, 0, 3);
 }
 
 static int patch_i915_icl_hdmi(struct hda_codec *codec)
@@ -2998,7 +2995,7 @@ static int patch_i915_icl_hdmi(struct hda_codec *codec)
 	 */
 	static const int map[] = {0x0, 0x4, 0x6, 0x8, 0xa, 0xb};
 
-	return intel_hsw_common_init(codec, 0x02, map, ARRAY_SIZE(map));
+	return intel_hsw_common_init(codec, 0x02, map, ARRAY_SIZE(map), 3);
 }
 
 static int patch_i915_tgl_hdmi(struct hda_codec *codec)
@@ -3010,7 +3007,7 @@ static int patch_i915_tgl_hdmi(struct hda_codec *codec)
 	static const int map[] = {0x4, 0x6, 0x8, 0xa, 0xb, 0xc, 0xd, 0xe, 0xf};
 	int ret;
 
-	ret = intel_hsw_common_init(codec, 0x02, map, ARRAY_SIZE(map));
+	ret = intel_hsw_common_init(codec, 0x02, map, ARRAY_SIZE(map), 4);
 	if (!ret) {
 		struct hdmi_spec *spec = codec->spec;
 
-- 
2.30.2



