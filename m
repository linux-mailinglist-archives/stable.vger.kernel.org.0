Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F61551DAF
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244519AbiFTOBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351818AbiFTNz1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:55:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC04E340FC;
        Mon, 20 Jun 2022 06:21:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D251B80E7D;
        Mon, 20 Jun 2022 13:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85852C3411B;
        Mon, 20 Jun 2022 13:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731296;
        bh=ft1wt8ROAo9j9gy+HvTwJB+2Qvm44BE1qdt8f510bCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nYto6iN/yxlOQahJ2LF1ETvShy+EdcjIlNgi1nGlqsm7iP/E4PeAH1bm8DfpAF5f7
         iasOPetU9vtE4Wd+fjyMwzcnEUmo+GMunB+Ah/ZQFz2kj45xjhR6QsaYfDyjSFi55j
         doUGG72UD0TjildAvl3n/oXRDfOIJiq9B7VLkTsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, huangwenhui <huangwenhuia@uniontech.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 198/240] ALSA: hda/realtek - Add HW8326 support
Date:   Mon, 20 Jun 2022 14:51:39 +0200
Message-Id: <20220620124744.723030678@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 8a221866ab01..9f55ee76861a 100644
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
@@ -3194,6 +3196,7 @@ static void alc_disable_headset_jack_key(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_write_coef_idx(codec, 0x48, 0x0);
 		alc_update_coef_idx(codec, 0x49, 0x0045, 0x0);
 		break;
@@ -3222,6 +3225,7 @@ static void alc_enable_headset_jack_key(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_write_coef_idx(codec, 0x48, 0xd011);
 		alc_update_coef_idx(codec, 0x49, 0x007f, 0x0045);
 		break;
@@ -4684,6 +4688,7 @@ static void alc_headset_mode_unplugged(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_process_coef_fw(codec, coef0256);
 		break;
 	case 0x10ec0234:
@@ -4799,6 +4804,7 @@ static void alc_headset_mode_mic_in(struct hda_codec *codec, hda_nid_t hp_pin,
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_write_coef_idx(codec, 0x45, 0xc489);
 		snd_hda_set_pin_ctl_cache(codec, hp_pin, 0);
 		alc_process_coef_fw(codec, coef0256);
@@ -4949,6 +4955,7 @@ static void alc_headset_mode_default(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_write_coef_idx(codec, 0x1b, 0x0e4b);
 		alc_write_coef_idx(codec, 0x45, 0xc089);
 		msleep(50);
@@ -5048,6 +5055,7 @@ static void alc_headset_mode_ctia(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_process_coef_fw(codec, coef0256);
 		break;
 	case 0x10ec0234:
@@ -5162,6 +5170,7 @@ static void alc_headset_mode_omtp(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_process_coef_fw(codec, coef0256);
 		break;
 	case 0x10ec0234:
@@ -5258,6 +5267,7 @@ static void alc_determine_headset_type(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_write_coef_idx(codec, 0x1b, 0x0e4b);
 		alc_write_coef_idx(codec, 0x06, 0x6104);
 		alc_write_coefex_idx(codec, 0x57, 0x3, 0x09a3);
@@ -5552,6 +5562,7 @@ static void alc255_set_default_jack_type(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_process_coef_fw(codec, alc256fw);
 		break;
 	}
@@ -6155,6 +6166,7 @@ static void alc_combo_jack_hp_jd_restart(struct hda_codec *codec)
 	case 0x10ec0236:
 	case 0x10ec0255:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_update_coef_idx(codec, 0x1b, 0x8000, 1 << 15); /* Reset HP JD */
 		alc_update_coef_idx(codec, 0x1b, 0x8000, 0 << 15);
 		break;
@@ -9160,6 +9172,7 @@ static int patch_alc269(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		spec->codec_variant = ALC269_TYPE_ALC256;
 		spec->shutup = alc256_shutup;
 		spec->init_hook = alc256_init;
@@ -10602,6 +10615,7 @@ static const struct hda_device_id snd_hda_id_realtek[] = {
 	HDA_CODEC_ENTRY(0x10ec0b00, "ALCS1200A", patch_alc882),
 	HDA_CODEC_ENTRY(0x10ec1168, "ALC1220", patch_alc882),
 	HDA_CODEC_ENTRY(0x10ec1220, "ALC1220", patch_alc882),
+	HDA_CODEC_ENTRY(0x19e58326, "HW8326", patch_alc269),
 	{} /* terminator */
 };
 MODULE_DEVICE_TABLE(hdaudio, snd_hda_id_realtek);
-- 
2.35.1



