Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBE51AC95D
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440989AbgDPPW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:22:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441625AbgDPNpv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:45:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4BCA21744;
        Thu, 16 Apr 2020 13:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044750;
        bh=GC7P3y7Dy+E6t3Dg2e24lsZ2vsRQWKY2LNgLclPIFq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o5+snebEog2yzhWMc0uAh1fJMfk78g29RstlKvoYyJUud4CGHTCz+flUnsiUNdQT6
         uddSFmZXTsNsBZbxrXdBBhtYl3USHzwmua7tROaSvfE6pVBU9DN54IZhaCcA1Yzkm2
         8uPVoYe7wRlh2y9NYA9GP+MbGOt0AR/cdcEhvq2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Hebb <tommyhebb@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 084/232] ALSA: hda/realtek - Remove now-unnecessary XPS 13 headphone noise fixups
Date:   Thu, 16 Apr 2020 15:22:58 +0200
Message-Id: <20200416131325.562559458@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Hebb <tommyhebb@gmail.com>

commit f36938aa7440f46a0a365f1cfde5f5985af2bef3 upstream.

patch_realtek.c has historically failed to properly configure the PC
Beep Hidden Register for the ALC256 codec (among others). Depending on
your kernel version, symptoms of this misconfiguration can range from
chassis noise, picked up by a poorly-shielded PCBEEP trace, getting
amplified and played on your internal speaker and/or headphones to loud
feedback, which responds to the "Headphone Mic Boost" ALSA control,
getting played through your headphones. For details of the problem, see
the patch in this series titled "ALSA: hda/realtek - Set principled PC
Beep configuration for ALC256", which fixes the configuration.

These symptoms have been most noticed on the Dell XPS 13 9350 and 9360,
popular laptops that use the ALC256. As a result, several model-specific
fixups have been introduced to try and fix the problem, the most
egregious of which locks the "Headphone Mic Boost" control as a hack to
minimize noise from a feedback loop that shouldn't have been there in
the first place.

Now that the underlying issue has been fixed, remove all these fixups.
Remaining fixups needed by the XPS 13 are all picked up by existing pin
quirks.

This change should, for the XPS 13 9350/9360

 - Significantly increase volume and audio quality on headphones
 - Eliminate headphone popping on suspend/resume
 - Allow "Headphone Mic Boost" to be set again, making the headphone
   jack fully usable as a microphone jack too.

Fixes: 8c69729b4439 ("ALSA: hda - Fix headphone noise after Dell XPS 13 resume back from S3")
Fixes: 423cd785619a ("ALSA: hda - Fix headphone noise on Dell XPS 13 9360")
Fixes: e4c9fd10eb21 ("ALSA: hda - Apply headphone noise quirk for another Dell XPS 13 variant")
Fixes: 1099f48457d0 ("ALSA: hda/realtek: Reduce the Headphone static noise on XPS 9350/9360")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
Link: https://lore.kernel.org/r/b649a00edfde150cf6eebbb4390e15e0c2deb39a.1585584498.git.tommyhebb@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/sound/hd-audio/models.rst |    2 -
 sound/pci/hda/patch_realtek.c           |   34 --------------------------------
 2 files changed, 36 deletions(-)

--- a/Documentation/sound/hd-audio/models.rst
+++ b/Documentation/sound/hd-audio/models.rst
@@ -216,8 +216,6 @@ alc298-dell-aio
     ALC298 fixups on Dell AIO machines
 alc275-dell-xps
     ALC275 fixups on Dell XPS models
-alc256-dell-xps13
-    ALC256 fixups on Dell XPS13
 lenovo-spk-noise
     Workaround for speaker noise on Lenovo machines
 lenovo-hotkey
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5491,17 +5491,6 @@ static void alc271_hp_gate_mic_jack(stru
 	}
 }
 
-static void alc256_fixup_dell_xps_13_headphone_noise2(struct hda_codec *codec,
-						      const struct hda_fixup *fix,
-						      int action)
-{
-	if (action != HDA_FIXUP_ACT_PRE_PROBE)
-		return;
-
-	snd_hda_codec_amp_stereo(codec, 0x1a, HDA_INPUT, 0, HDA_AMP_VOLMASK, 1);
-	snd_hda_override_wcaps(codec, 0x1a, get_wcaps(codec, 0x1a) & ~AC_WCAP_IN_AMP);
-}
-
 static void alc269_fixup_limit_int_mic_boost(struct hda_codec *codec,
 					     const struct hda_fixup *fix,
 					     int action)
@@ -5916,8 +5905,6 @@ enum {
 	ALC298_FIXUP_DELL1_MIC_NO_PRESENCE,
 	ALC298_FIXUP_DELL_AIO_MIC_NO_PRESENCE,
 	ALC275_FIXUP_DELL_XPS,
-	ALC256_FIXUP_DELL_XPS_13_HEADPHONE_NOISE,
-	ALC256_FIXUP_DELL_XPS_13_HEADPHONE_NOISE2,
 	ALC293_FIXUP_LENOVO_SPK_NOISE,
 	ALC233_FIXUP_LENOVO_LINE2_MIC_HOTKEY,
 	ALC255_FIXUP_DELL_SPK_NOISE,
@@ -6658,23 +6645,6 @@ static const struct hda_fixup alc269_fix
 			{}
 		}
 	},
-	[ALC256_FIXUP_DELL_XPS_13_HEADPHONE_NOISE] = {
-		.type = HDA_FIXUP_VERBS,
-		.v.verbs = (const struct hda_verb[]) {
-			/* Disable pass-through path for FRONT 14h */
-			{0x20, AC_VERB_SET_COEF_INDEX, 0x36},
-			{0x20, AC_VERB_SET_PROC_COEF, 0x1737},
-			{}
-		},
-		.chained = true,
-		.chain_id = ALC255_FIXUP_DELL1_MIC_NO_PRESENCE
-	},
-	[ALC256_FIXUP_DELL_XPS_13_HEADPHONE_NOISE2] = {
-		.type = HDA_FIXUP_FUNC,
-		.v.func = alc256_fixup_dell_xps_13_headphone_noise2,
-		.chained = true,
-		.chain_id = ALC256_FIXUP_DELL_XPS_13_HEADPHONE_NOISE
-	},
 	[ALC293_FIXUP_LENOVO_SPK_NOISE] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc_fixup_disable_aamix,
@@ -7172,17 +7142,14 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1028, 0x06de, "Dell", ALC293_FIXUP_DISABLE_AAMIX_MULTIJACK),
 	SND_PCI_QUIRK(0x1028, 0x06df, "Dell", ALC293_FIXUP_DISABLE_AAMIX_MULTIJACK),
 	SND_PCI_QUIRK(0x1028, 0x06e0, "Dell", ALC293_FIXUP_DISABLE_AAMIX_MULTIJACK),
-	SND_PCI_QUIRK(0x1028, 0x0704, "Dell XPS 13 9350", ALC256_FIXUP_DELL_XPS_13_HEADPHONE_NOISE2),
 	SND_PCI_QUIRK(0x1028, 0x0706, "Dell Inspiron 7559", ALC256_FIXUP_DELL_INSPIRON_7559_SUBWOOFER),
 	SND_PCI_QUIRK(0x1028, 0x0725, "Dell Inspiron 3162", ALC255_FIXUP_DELL_SPK_NOISE),
 	SND_PCI_QUIRK(0x1028, 0x0738, "Dell Precision 5820", ALC269_FIXUP_NO_SHUTUP),
-	SND_PCI_QUIRK(0x1028, 0x075b, "Dell XPS 13 9360", ALC256_FIXUP_DELL_XPS_13_HEADPHONE_NOISE2),
 	SND_PCI_QUIRK(0x1028, 0x075c, "Dell XPS 27 7760", ALC298_FIXUP_SPK_VOLUME),
 	SND_PCI_QUIRK(0x1028, 0x075d, "Dell AIO", ALC298_FIXUP_SPK_VOLUME),
 	SND_PCI_QUIRK(0x1028, 0x07b0, "Dell Precision 7520", ALC295_FIXUP_DISABLE_DAC3),
 	SND_PCI_QUIRK(0x1028, 0x0798, "Dell Inspiron 17 7000 Gaming", ALC256_FIXUP_DELL_INSPIRON_7559_SUBWOOFER),
 	SND_PCI_QUIRK(0x1028, 0x080c, "Dell WYSE", ALC225_FIXUP_DELL_WYSE_MIC_NO_PRESENCE),
-	SND_PCI_QUIRK(0x1028, 0x082a, "Dell XPS 13 9360", ALC256_FIXUP_DELL_XPS_13_HEADPHONE_NOISE2),
 	SND_PCI_QUIRK(0x1028, 0x084b, "Dell", ALC274_FIXUP_DELL_AIO_LINEOUT_VERB),
 	SND_PCI_QUIRK(0x1028, 0x084e, "Dell", ALC274_FIXUP_DELL_AIO_LINEOUT_VERB),
 	SND_PCI_QUIRK(0x1028, 0x0871, "Dell Precision 3630", ALC255_FIXUP_DELL_HEADSET_MIC),
@@ -7536,7 +7503,6 @@ static const struct hda_model_fixup alc2
 	{.id = ALC298_FIXUP_DELL1_MIC_NO_PRESENCE, .name = "alc298-dell1"},
 	{.id = ALC298_FIXUP_DELL_AIO_MIC_NO_PRESENCE, .name = "alc298-dell-aio"},
 	{.id = ALC275_FIXUP_DELL_XPS, .name = "alc275-dell-xps"},
-	{.id = ALC256_FIXUP_DELL_XPS_13_HEADPHONE_NOISE, .name = "alc256-dell-xps13"},
 	{.id = ALC293_FIXUP_LENOVO_SPK_NOISE, .name = "lenovo-spk-noise"},
 	{.id = ALC233_FIXUP_LENOVO_LINE2_MIC_HOTKEY, .name = "lenovo-hotkey"},
 	{.id = ALC255_FIXUP_DELL_SPK_NOISE, .name = "dell-spk-noise"},


