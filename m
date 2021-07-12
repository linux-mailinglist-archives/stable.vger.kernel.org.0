Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F673C5063
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240283AbhGLHcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:32:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345622AbhGLHaC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:30:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06A426052B;
        Mon, 12 Jul 2021 07:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074833;
        bh=2/Y+Yno9vJ6l3ce1w0SCr7fSeuvyc0BdSgPs6KAqUck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rWFJPPupssvh/D+XkG43F4BNLUm2k7vV4mHmDSiiS3FlIR9smpDm7VMjpTcswCERU
         7caI5sSmVXoKSeLMdscF/ewpkQkFq0Qe5qVP7zmrcfCBPpFzA7g7KckbDMLR/4XC9h
         +kxFy8zLbw50cTqB0TnM7ccW816/D2zhQPtACMic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.13 013/800] ALSA: hda/realtek: Add another ALC236 variant support
Date:   Mon, 12 Jul 2021 08:00:36 +0200
Message-Id: <20210712060915.041576263@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 1948fc065a89f18d057b8ffaef6d7242ad99edb8 upstream.

The codec chip 10ec:0230 is another variant of ALC236, combined with a
card reader.  Apply the equivalent setup as 10ec:0236.

BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1184869
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210618161720.28694-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -385,6 +385,7 @@ static void alc_fill_eapd_coef(struct hd
 		alc_update_coef_idx(codec, 0x67, 0xf000, 0x3000);
 		fallthrough;
 	case 0x10ec0215:
+	case 0x10ec0230:
 	case 0x10ec0233:
 	case 0x10ec0235:
 	case 0x10ec0236:
@@ -3153,6 +3154,7 @@ static void alc_disable_headset_jack_key
 		alc_update_coef_idx(codec, 0x49, 0x0045, 0x0);
 		alc_update_coef_idx(codec, 0x44, 0x0045 << 8, 0x0);
 		break;
+	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
 		alc_write_coef_idx(codec, 0x48, 0x0);
@@ -3180,6 +3182,7 @@ static void alc_enable_headset_jack_key(
 		alc_update_coef_idx(codec, 0x49, 0x007f, 0x0045);
 		alc_update_coef_idx(codec, 0x44, 0x007f << 8, 0x0045 << 8);
 		break;
+	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
 		alc_write_coef_idx(codec, 0x48, 0xd011);
@@ -4744,6 +4747,7 @@ static void alc_headset_mode_unplugged(s
 	case 0x10ec0255:
 		alc_process_coef_fw(codec, coef0255);
 		break;
+	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
 		alc_process_coef_fw(codec, coef0256);
@@ -4858,6 +4862,7 @@ static void alc_headset_mode_mic_in(stru
 		alc_process_coef_fw(codec, coef0255);
 		snd_hda_set_pin_ctl_cache(codec, mic_pin, PIN_VREF50);
 		break;
+	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
 		alc_write_coef_idx(codec, 0x45, 0xc489);
@@ -5007,6 +5012,7 @@ static void alc_headset_mode_default(str
 	case 0x10ec0255:
 		alc_process_coef_fw(codec, coef0255);
 		break;
+	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
 		alc_write_coef_idx(codec, 0x1b, 0x0e4b);
@@ -5105,6 +5111,7 @@ static void alc_headset_mode_ctia(struct
 	case 0x10ec0255:
 		alc_process_coef_fw(codec, coef0255);
 		break;
+	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
 		alc_process_coef_fw(codec, coef0256);
@@ -5218,6 +5225,7 @@ static void alc_headset_mode_omtp(struct
 	case 0x10ec0255:
 		alc_process_coef_fw(codec, coef0255);
 		break;
+	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
 		alc_process_coef_fw(codec, coef0256);
@@ -5318,6 +5326,7 @@ static void alc_determine_headset_type(s
 		val = alc_read_coef_idx(codec, 0x46);
 		is_ctia = (val & 0x0070) == 0x0070;
 		break;
+	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
 		alc_write_coef_idx(codec, 0x1b, 0x0e4b);
@@ -5611,6 +5620,7 @@ static void alc255_set_default_jack_type
 	case 0x10ec0255:
 		alc_process_coef_fw(codec, alc255fw);
 		break;
+	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
 		alc_process_coef_fw(codec, alc256fw);
@@ -6211,6 +6221,7 @@ static void alc_combo_jack_hp_jd_restart
 		alc_update_coef_idx(codec, 0x4a, 0x8000, 1 << 15); /* Reset HP JD */
 		alc_update_coef_idx(codec, 0x4a, 0x8000, 0 << 15);
 		break;
+	case 0x10ec0230:
 	case 0x10ec0235:
 	case 0x10ec0236:
 	case 0x10ec0255:
@@ -9345,6 +9356,7 @@ static int patch_alc269(struct hda_codec
 		spec->shutup = alc256_shutup;
 		spec->init_hook = alc256_init;
 		break;
+	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
 		spec->codec_variant = ALC269_TYPE_ALC256;
@@ -10636,6 +10648,7 @@ static const struct hda_device_id snd_hd
 	HDA_CODEC_ENTRY(0x10ec0221, "ALC221", patch_alc269),
 	HDA_CODEC_ENTRY(0x10ec0222, "ALC222", patch_alc269),
 	HDA_CODEC_ENTRY(0x10ec0225, "ALC225", patch_alc269),
+	HDA_CODEC_ENTRY(0x10ec0230, "ALC236", patch_alc269),
 	HDA_CODEC_ENTRY(0x10ec0231, "ALC231", patch_alc269),
 	HDA_CODEC_ENTRY(0x10ec0233, "ALC233", patch_alc269),
 	HDA_CODEC_ENTRY(0x10ec0234, "ALC234", patch_alc269),


