Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 347825E811A
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 19:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbiIWRuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 13:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiIWRuB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 13:50:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF433B736
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 10:49:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FF8F61E54
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 17:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DDB8C433D6;
        Fri, 23 Sep 2022 17:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663955397;
        bh=k6N/80+pTwFG67f5Inh0ukvK5duh3gzsvJUWfvmiqcY=;
        h=Subject:To:Cc:From:Date:From;
        b=RRJ+OWyYbJU1aCW+JGvf+zEvRcslRjcTXHrNYuRAI4956D0XiviHC85V/lwiF6SEa
         w7ztQi6EYFy5RmF4MF631G9nWRkgVvy1YzKaWquD3/1Q7epei2McgBbtbALlm00gY8
         rGH12RMsDPAW2GJ2T40P5LnlqZ5nnTiuiYBtHrsw=
Subject: FAILED: patch "[PATCH] ALSA: hda: Fix Nvidia dp infoframe" failed to apply to 5.15-stable tree
To:     mkumard@nvidia.com, stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 23 Sep 2022 19:49:55 +0200
Message-ID: <166395539518089@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

f89e409402e2 ("ALSA: hda: Fix Nvidia dp infoframe")
85f29492929b ("ALSA: hda/tegra: Update scratch reg. communication")
f43156a9563f ("ALSA: hda/tegra: Add Tegra234 hda driver support")
d278dc9151a0 ("ALSA: hda/tegra: Fix Tegra194 HDA reset failure")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f89e409402e2aeb3bc3aa44d2b7a597959e4e6af Mon Sep 17 00:00:00 2001
From: Mohan Kumar <mkumard@nvidia.com>
Date: Tue, 13 Sep 2022 12:28:18 +0530
Subject: [PATCH] ALSA: hda: Fix Nvidia dp infoframe

Nvidia HDA HW expects infoframe data bytes order same for both
HDMI and DP i.e infoframe data starts from 5th bytes offset. As
dp infoframe structure has 4th byte as valid infoframe data, use
hdmi infoframe structure for nvidia dp infoframe to match HW behvaior.

Signed-off-by: Mohan Kumar <mkumard@nvidia.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220913065818.13015-1-mkumard@nvidia.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index acaf6b790ee1..c9d9aa6351ec 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -170,6 +170,8 @@ struct hdmi_spec {
 	bool dyn_pcm_no_legacy;
 	/* hdmi interrupt trigger control flag for Nvidia codec */
 	bool hdmi_intr_trig_ctrl;
+	bool nv_dp_workaround; /* workaround DP audio infoframe for Nvidia */
+
 	bool intel_hsw_fixup;	/* apply Intel platform-specific fixups */
 	/*
 	 * Non-generic VIA/NVIDIA specific
@@ -679,15 +681,24 @@ static void hdmi_pin_setup_infoframe(struct hda_codec *codec,
 				     int ca, int active_channels,
 				     int conn_type)
 {
+	struct hdmi_spec *spec = codec->spec;
 	union audio_infoframe ai;
 
 	memset(&ai, 0, sizeof(ai));
-	if (conn_type == 0) { /* HDMI */
+	if ((conn_type == 0) || /* HDMI */
+		/* Nvidia DisplayPort: Nvidia HW expects same layout as HDMI */
+		(conn_type == 1 && spec->nv_dp_workaround)) {
 		struct hdmi_audio_infoframe *hdmi_ai = &ai.hdmi;
 
-		hdmi_ai->type		= 0x84;
-		hdmi_ai->ver		= 0x01;
-		hdmi_ai->len		= 0x0a;
+		if (conn_type == 0) { /* HDMI */
+			hdmi_ai->type		= 0x84;
+			hdmi_ai->ver		= 0x01;
+			hdmi_ai->len		= 0x0a;
+		} else {/* Nvidia DP */
+			hdmi_ai->type		= 0x84;
+			hdmi_ai->ver		= 0x1b;
+			hdmi_ai->len		= 0x11 << 2;
+		}
 		hdmi_ai->CC02_CT47	= active_channels - 1;
 		hdmi_ai->CA		= ca;
 		hdmi_checksum_audio_infoframe(hdmi_ai);
@@ -3617,6 +3628,7 @@ static int patch_nvhdmi_2ch(struct hda_codec *codec)
 	spec->pcm_playback.rates = SUPPORTED_RATES;
 	spec->pcm_playback.maxbps = SUPPORTED_MAXBPS;
 	spec->pcm_playback.formats = SUPPORTED_FORMATS;
+	spec->nv_dp_workaround = true;
 	return 0;
 }
 
@@ -3756,6 +3768,7 @@ static int patch_nvhdmi(struct hda_codec *codec)
 	spec->chmap.ops.chmap_cea_alloc_validate_get_type =
 		nvhdmi_chmap_cea_alloc_validate_get_type;
 	spec->chmap.ops.chmap_validate = nvhdmi_chmap_validate;
+	spec->nv_dp_workaround = true;
 
 	codec->link_down_at_suspend = 1;
 
@@ -3779,6 +3792,7 @@ static int patch_nvhdmi_legacy(struct hda_codec *codec)
 	spec->chmap.ops.chmap_cea_alloc_validate_get_type =
 		nvhdmi_chmap_cea_alloc_validate_get_type;
 	spec->chmap.ops.chmap_validate = nvhdmi_chmap_validate;
+	spec->nv_dp_workaround = true;
 
 	codec->link_down_at_suspend = 1;
 
@@ -3993,6 +4007,7 @@ static int tegra_hdmi_init(struct hda_codec *codec)
 	spec->chmap.ops.chmap_cea_alloc_validate_get_type =
 		nvhdmi_chmap_cea_alloc_validate_get_type;
 	spec->chmap.ops.chmap_validate = nvhdmi_chmap_validate;
+	spec->nv_dp_workaround = true;
 
 	return 0;
 }

