Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F335F29B9
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiJCHYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbiJCHXj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:23:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBBE43324;
        Mon,  3 Oct 2022 00:17:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82BBD60FA2;
        Mon,  3 Oct 2022 07:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94900C433C1;
        Mon,  3 Oct 2022 07:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781458;
        bh=htqVCF0HyYsDh3mu3tSMuDRWcNQhdX16wkn6ddp+3kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=szKz28dECdQ3vbWtaCzPg0wuy30+9+mVrFje11EYyZUwT+jVSTkezDhwcZpQwKRVu
         /8EDo3BfWD1NVE3o/MYN0NPVCLrdNaXTYc7w+MuqudA0xezP0jtdIh8QuzZioGPcBU
         qGHLq1kUmHr8QcQlop1xmo2l3xMZvtthJeqcKicM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mohan Kumar <mkumard@nvidia.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 03/83] ALSA: hda: Fix Nvidia dp infoframe
Date:   Mon,  3 Oct 2022 09:10:28 +0200
Message-Id: <20221003070722.064064094@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mohan Kumar <mkumard@nvidia.com>

[ Upstream commit f89e409402e2aeb3bc3aa44d2b7a597959e4e6af ]

Nvidia HDA HW expects infoframe data bytes order same for both
HDMI and DP i.e infoframe data starts from 5th bytes offset. As
dp infoframe structure has 4th byte as valid infoframe data, use
hdmi infoframe structure for nvidia dp infoframe to match HW behvaior.

Signed-off-by: Mohan Kumar <mkumard@nvidia.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220913065818.13015-1-mkumard@nvidia.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index d19bc2b9f778..d3da42e0e7b3 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -162,6 +162,8 @@ struct hdmi_spec {
 	bool dyn_pin_out;
 	bool dyn_pcm_assign;
 	bool dyn_pcm_no_legacy;
+	bool nv_dp_workaround; /* workaround DP audio infoframe for Nvidia */
+
 	bool intel_hsw_fixup;	/* apply Intel platform-specific fixups */
 	/*
 	 * Non-generic VIA/NVIDIA specific
@@ -671,15 +673,24 @@ static void hdmi_pin_setup_infoframe(struct hda_codec *codec,
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
@@ -3539,6 +3550,7 @@ static int patch_nvhdmi_2ch(struct hda_codec *codec)
 	spec->pcm_playback.rates = SUPPORTED_RATES;
 	spec->pcm_playback.maxbps = SUPPORTED_MAXBPS;
 	spec->pcm_playback.formats = SUPPORTED_FORMATS;
+	spec->nv_dp_workaround = true;
 	return 0;
 }
 
@@ -3678,6 +3690,7 @@ static int patch_nvhdmi(struct hda_codec *codec)
 	spec->chmap.ops.chmap_cea_alloc_validate_get_type =
 		nvhdmi_chmap_cea_alloc_validate_get_type;
 	spec->chmap.ops.chmap_validate = nvhdmi_chmap_validate;
+	spec->nv_dp_workaround = true;
 
 	codec->link_down_at_suspend = 1;
 
@@ -3701,6 +3714,7 @@ static int patch_nvhdmi_legacy(struct hda_codec *codec)
 	spec->chmap.ops.chmap_cea_alloc_validate_get_type =
 		nvhdmi_chmap_cea_alloc_validate_get_type;
 	spec->chmap.ops.chmap_validate = nvhdmi_chmap_validate;
+	spec->nv_dp_workaround = true;
 
 	codec->link_down_at_suspend = 1;
 
@@ -3874,6 +3888,7 @@ static int patch_tegra_hdmi(struct hda_codec *codec)
 	spec->chmap.ops.chmap_cea_alloc_validate_get_type =
 		nvhdmi_chmap_cea_alloc_validate_get_type;
 	spec->chmap.ops.chmap_validate = nvhdmi_chmap_validate;
+	spec->nv_dp_workaround = true;
 
 	return 0;
 }
-- 
2.35.1



