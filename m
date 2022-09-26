Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8E25EA544
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238976AbiIZL7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239166AbiIZL62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:58:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700A57B1DC;
        Mon, 26 Sep 2022 03:52:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DB35B80943;
        Mon, 26 Sep 2022 10:42:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8993C43470;
        Mon, 26 Sep 2022 10:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188964;
        bh=Nzr51lwUrmbCck9szfNyKvBeqEsGN2UynDFvYwPfw8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IE/NHFB6P0FHcpMyO9iuyGrnKRl8Kwn+jyk9KJ89wyK+1Bl4Yk/MwzsdxcBmwgbTf
         zJw6TGrt7bI0YnVzxjgP1zzy82rNCs3uc6byxIHWGL0e33MsSOXlSQFADT3qELKNuZ
         WVJ2zSelMHzJ4O41Wt3Ps8K2RekaxfDSp7Gx29zQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mohan Kumar <mkumard@nvidia.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.19 029/207] ALSA: hda: Fix Nvidia dp infoframe
Date:   Mon, 26 Sep 2022 12:10:18 +0200
Message-Id: <20220926100807.779609294@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mohan Kumar <mkumard@nvidia.com>

commit f89e409402e2aeb3bc3aa44d2b7a597959e4e6af upstream.

Nvidia HDA HW expects infoframe data bytes order same for both
HDMI and DP i.e infoframe data starts from 5th bytes offset. As
dp infoframe structure has 4th byte as valid infoframe data, use
hdmi infoframe structure for nvidia dp infoframe to match HW behvaior.

Signed-off-by: Mohan Kumar <mkumard@nvidia.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220913065818.13015-1-mkumard@nvidia.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

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
@@ -679,15 +681,24 @@ static void hdmi_pin_setup_infoframe(str
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
@@ -3617,6 +3628,7 @@ static int patch_nvhdmi_2ch(struct hda_c
 	spec->pcm_playback.rates = SUPPORTED_RATES;
 	spec->pcm_playback.maxbps = SUPPORTED_MAXBPS;
 	spec->pcm_playback.formats = SUPPORTED_FORMATS;
+	spec->nv_dp_workaround = true;
 	return 0;
 }
 
@@ -3756,6 +3768,7 @@ static int patch_nvhdmi(struct hda_codec
 	spec->chmap.ops.chmap_cea_alloc_validate_get_type =
 		nvhdmi_chmap_cea_alloc_validate_get_type;
 	spec->chmap.ops.chmap_validate = nvhdmi_chmap_validate;
+	spec->nv_dp_workaround = true;
 
 	codec->link_down_at_suspend = 1;
 
@@ -3779,6 +3792,7 @@ static int patch_nvhdmi_legacy(struct hd
 	spec->chmap.ops.chmap_cea_alloc_validate_get_type =
 		nvhdmi_chmap_cea_alloc_validate_get_type;
 	spec->chmap.ops.chmap_validate = nvhdmi_chmap_validate;
+	spec->nv_dp_workaround = true;
 
 	codec->link_down_at_suspend = 1;
 
@@ -3993,6 +4007,7 @@ static int tegra_hdmi_init(struct hda_co
 	spec->chmap.ops.chmap_cea_alloc_validate_get_type =
 		nvhdmi_chmap_cea_alloc_validate_get_type;
 	spec->chmap.ops.chmap_validate = nvhdmi_chmap_validate;
+	spec->nv_dp_workaround = true;
 
 	return 0;
 }


