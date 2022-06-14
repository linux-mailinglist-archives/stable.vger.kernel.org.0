Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B90854A5B7
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353846AbiFNCSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353736AbiFNCQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:16:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC863E5D5;
        Mon, 13 Jun 2022 19:09:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A601B816A4;
        Tue, 14 Jun 2022 02:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C53C341C0;
        Tue, 14 Jun 2022 02:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172572;
        bh=VF6NrMWzBo/eO6x+ty2crj7gcoSPsOB7AzeKEd6PNUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f4McSDGTVAuP7NIWihloUCY0LsTpBLhd3OoQ2xFA0uEz9fwX19z9AagcXXg457jvH
         u2GG+YU3O1T8PeAtSH6kXtcrpjELmrjCVCZbo8V22wfDTZYAgReEgATQmK8Jfum6nq
         de+R0Zze+ndHvjT8a2Mb+h9jg0gvHRZpFeQFAH/8gA4oUuJMIYR0UCGTA1B3HJAr1X
         pqt62j3ZnDTALbfJ6zouAytLyPEJ35+eOnV7bD5Xb4g7fySpIN2h6Ig46VM2Ma/GF4
         dJhNzynZ6iZE59W2Mi9zqspcr1J4Qq6shdnZbjVK+UYoUTkimBp3R/uG2VAwt1j7L0
         jVOLlAcVSSxpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     huangwenhui <huangwenhuia@uniontech.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 18/23] ALSA: hda/realtek - Add HW8326 support
Date:   Mon, 13 Jun 2022 22:08:54 -0400
Message-Id: <20220614020900.1100401-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020900.1100401-1-sashal@kernel.org>
References: <20220614020900.1100401-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: huangwenhui <huangwenhuia@uniontech.com>

[ Upstream commit 527f4643e03c298c1e3321cfa27866b1374a55e1 ]

Added the support of new Huawei codec HW8326. The HW8326 is developed
by Huawei with Realtek's IP Core, and it's compatible with ALC256.

Signed-off-by: huangwenhui <huangwenhuia@uniontech.com>
Link: https://lore.kernel.org/r/20220608082357.26898-1-huangwenhuia@uniontech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/hdac_device.c       |  1 +
 sound/pci/hda/patch_realtek.c | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/sound/hda/hdac_device.c b/sound/hda/hdac_device.c
index b84e12f4f804..489f996d86bc 100644
--- a/sound/hda/hdac_device.c
+++ b/sound/hda/hdac_device.c
@@ -656,6 +656,7 @@ static struct hda_vendor_id hda_vendor_ids[] = {
 	{ 0x14f1, "Conexant" },
 	{ 0x17e8, "Chrontel" },
 	{ 0x1854, "LG" },
+	{ 0x19e5, "Huawei" },
 	{ 0x1aec, "Wolfson Microelectronics" },
 	{ 0x1af4, "QEMU" },
 	{ 0x434d, "C-Media" },
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 78b5a0f22a41..57da27cd7498 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -382,6 +382,7 @@ static void alc_fill_eapd_coef(struct hda_codec *codec)
 	case 0x10ec0245:
 	case 0x10ec0255:
 	case 0x10ec0256:
+	case 0x19e58326:
 	case 0x10ec0257:
 	case 0x10ec0282:
 	case 0x10ec0283:
@@ -519,6 +520,7 @@ static void alc_shutup_pins(struct hda_codec *codec)
 	switch (codec->core.vendor_id) {
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 	case 0x10ec0283:
 	case 0x10ec0286:
 	case 0x10ec0288:
@@ -3184,6 +3186,7 @@ static void alc_disable_headset_jack_key(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_write_coef_idx(codec, 0x48, 0x0);
 		alc_update_coef_idx(codec, 0x49, 0x0045, 0x0);
 		break;
@@ -3212,6 +3215,7 @@ static void alc_enable_headset_jack_key(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_write_coef_idx(codec, 0x48, 0xd011);
 		alc_update_coef_idx(codec, 0x49, 0x007f, 0x0045);
 		break;
@@ -4674,6 +4678,7 @@ static void alc_headset_mode_unplugged(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_process_coef_fw(codec, coef0256);
 		break;
 	case 0x10ec0234:
@@ -4789,6 +4794,7 @@ static void alc_headset_mode_mic_in(struct hda_codec *codec, hda_nid_t hp_pin,
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_write_coef_idx(codec, 0x45, 0xc489);
 		snd_hda_set_pin_ctl_cache(codec, hp_pin, 0);
 		alc_process_coef_fw(codec, coef0256);
@@ -4939,6 +4945,7 @@ static void alc_headset_mode_default(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_write_coef_idx(codec, 0x1b, 0x0e4b);
 		alc_write_coef_idx(codec, 0x45, 0xc089);
 		msleep(50);
@@ -5038,6 +5045,7 @@ static void alc_headset_mode_ctia(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_process_coef_fw(codec, coef0256);
 		break;
 	case 0x10ec0234:
@@ -5152,6 +5160,7 @@ static void alc_headset_mode_omtp(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_process_coef_fw(codec, coef0256);
 		break;
 	case 0x10ec0234:
@@ -5248,6 +5257,7 @@ static void alc_determine_headset_type(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_write_coef_idx(codec, 0x1b, 0x0e4b);
 		alc_write_coef_idx(codec, 0x06, 0x6104);
 		alc_write_coefex_idx(codec, 0x57, 0x3, 0x09a3);
@@ -5542,6 +5552,7 @@ static void alc255_set_default_jack_type(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_process_coef_fw(codec, alc256fw);
 		break;
 	}
@@ -6145,6 +6156,7 @@ static void alc_combo_jack_hp_jd_restart(struct hda_codec *codec)
 	case 0x10ec0236:
 	case 0x10ec0255:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_update_coef_idx(codec, 0x1b, 0x8000, 1 << 15); /* Reset HP JD */
 		alc_update_coef_idx(codec, 0x1b, 0x8000, 0 << 15);
 		break;
@@ -9150,6 +9162,7 @@ static int patch_alc269(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		spec->codec_variant = ALC269_TYPE_ALC256;
 		spec->shutup = alc256_shutup;
 		spec->init_hook = alc256_init;
@@ -10592,6 +10605,7 @@ static const struct hda_device_id snd_hda_id_realtek[] = {
 	HDA_CODEC_ENTRY(0x10ec0b00, "ALCS1200A", patch_alc882),
 	HDA_CODEC_ENTRY(0x10ec1168, "ALC1220", patch_alc882),
 	HDA_CODEC_ENTRY(0x10ec1220, "ALC1220", patch_alc882),
+	HDA_CODEC_ENTRY(0x19e58326, "HW8326", patch_alc269),
 	{} /* terminator */
 };
 MODULE_DEVICE_TABLE(hdaudio, snd_hda_id_realtek);
-- 
2.35.1

