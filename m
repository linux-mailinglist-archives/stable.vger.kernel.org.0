Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A634A3C444A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbhGLGSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:18:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233499AbhGLGSJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:18:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D217261042;
        Mon, 12 Jul 2021 06:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070520;
        bh=5/Y7ew45YuoPjNtagYkY5XIePDS8vM5uxqtzY86VDSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U8Bx1wk0irgH0I1W6M0EbaVcdIyS/Ich/wcqNiIs3bouOnFl2YIkAUqb4Ygp59l3i
         eJ41AyAhtiXt2BJKzpdCkYGzM4NxamL0bR8P0DlRh16Qn84HU4N1ERdR+cblqbd1wQ
         rHdvoM2MRbqGiPLkRT87zZQ4LgtC4SH9UWxmTEIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 005/348] ALSA: hda/realtek: Add another ALC236 variant support
Date:   Mon, 12 Jul 2021 08:06:29 +0200
Message-Id: <20210712060700.691324147@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
@@ -375,6 +375,7 @@ static void alc_fill_eapd_coef(struct hd
 		alc_update_coef_idx(codec, 0x67, 0xf000, 0x3000);
 		/* fallthrough */
 	case 0x10ec0215:
+	case 0x10ec0230:
 	case 0x10ec0233:
 	case 0x10ec0235:
 	case 0x10ec0236:
@@ -3143,6 +3144,7 @@ static void alc_disable_headset_jack_key
 		alc_update_coef_idx(codec, 0x49, 0x0045, 0x0);
 		alc_update_coef_idx(codec, 0x44, 0x0045 << 8, 0x0);
 		break;
+	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
 		alc_write_coef_idx(codec, 0x48, 0x0);
@@ -3170,6 +3172,7 @@ static void alc_enable_headset_jack_key(
 		alc_update_coef_idx(codec, 0x49, 0x007f, 0x0045);
 		alc_update_coef_idx(codec, 0x44, 0x007f << 8, 0x0045 << 8);
 		break;
+	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
 		alc_write_coef_idx(codec, 0x48, 0xd011);
@@ -4630,6 +4633,7 @@ static void alc_headset_mode_unplugged(s
 	case 0x10ec0255:
 		alc_process_coef_fw(codec, coef0255);
 		break;
+	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
 		alc_process_coef_fw(codec, coef0256);
@@ -4744,6 +4748,7 @@ static void alc_headset_mode_mic_in(stru
 		alc_process_coef_fw(codec, coef0255);
 		snd_hda_set_pin_ctl_cache(codec, mic_pin, PIN_VREF50);
 		break;
+	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
 		alc_write_coef_idx(codec, 0x45, 0xc489);
@@ -4893,6 +4898,7 @@ static void alc_headset_mode_default(str
 	case 0x10ec0255:
 		alc_process_coef_fw(codec, coef0255);
 		break;
+	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
 		alc_write_coef_idx(codec, 0x1b, 0x0e4b);
@@ -4991,6 +4997,7 @@ static void alc_headset_mode_ctia(struct
 	case 0x10ec0255:
 		alc_process_coef_fw(codec, coef0255);
 		break;
+	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
 		alc_process_coef_fw(codec, coef0256);
@@ -5104,6 +5111,7 @@ static void alc_headset_mode_omtp(struct
 	case 0x10ec0255:
 		alc_process_coef_fw(codec, coef0255);
 		break;
+	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
 		alc_process_coef_fw(codec, coef0256);
@@ -5199,6 +5207,7 @@ static void alc_determine_headset_type(s
 		val = alc_read_coef_idx(codec, 0x46);
 		is_ctia = (val & 0x0070) == 0x0070;
 		break;
+	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
 		alc_write_coef_idx(codec, 0x1b, 0x0e4b);
@@ -5492,6 +5501,7 @@ static void alc255_set_default_jack_type
 	case 0x10ec0255:
 		alc_process_coef_fw(codec, alc255fw);
 		break;
+	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
 		alc_process_coef_fw(codec, alc256fw);
@@ -6092,6 +6102,7 @@ static void alc_combo_jack_hp_jd_restart
 		alc_update_coef_idx(codec, 0x4a, 0x8000, 1 << 15); /* Reset HP JD */
 		alc_update_coef_idx(codec, 0x4a, 0x8000, 0 << 15);
 		break;
+	case 0x10ec0230:
 	case 0x10ec0235:
 	case 0x10ec0236:
 	case 0x10ec0255:
@@ -9063,6 +9074,7 @@ static int patch_alc269(struct hda_codec
 		spec->shutup = alc256_shutup;
 		spec->init_hook = alc256_init;
 		break;
+	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
 		spec->codec_variant = ALC269_TYPE_ALC256;
@@ -10354,6 +10366,7 @@ static const struct hda_device_id snd_hd
 	HDA_CODEC_ENTRY(0x10ec0221, "ALC221", patch_alc269),
 	HDA_CODEC_ENTRY(0x10ec0222, "ALC222", patch_alc269),
 	HDA_CODEC_ENTRY(0x10ec0225, "ALC225", patch_alc269),
+	HDA_CODEC_ENTRY(0x10ec0230, "ALC236", patch_alc269),
 	HDA_CODEC_ENTRY(0x10ec0231, "ALC231", patch_alc269),
 	HDA_CODEC_ENTRY(0x10ec0233, "ALC233", patch_alc269),
 	HDA_CODEC_ENTRY(0x10ec0234, "ALC234", patch_alc269),


