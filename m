Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D143782F5
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhEJKlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:41:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231774AbhEJKia (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:38:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C69276194A;
        Mon, 10 May 2021 10:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642607;
        bh=7iK8f6MPL84cRA/GpDec5PAiOpDmO6m4+jmDr+v2oHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RGnQhHCMsx9soN5C87Ki5nzZycscBTPxEnKzPZOuiX5zoZPkUnJkk2cgGvAxm+JWq
         JALY5yHOx64OLjF/dO0LjtATSJWdHvOhio+xboMGI+AoOi0fl/3bHd7LGZFGX+kxwu
         5T52pdfgLCT5xKIP1MSxYnH5xErQQdeqHlSjyNyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 129/184] ALSA: usb-audio: More constifications
Date:   Mon, 10 May 2021 12:20:23 +0200
Message-Id: <20210510101954.394191769@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit a01df925d1bbc97d6f7fe07b157aadb565315337 upstream.

Apply const prefix to the remaining places: the static table for the
unit information, the mixer maps, the validator tables, etc.

Just for minor optimization and no functional changes.

Link: https://lore.kernel.org/r/20200105144823.29547-12-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer.c          |   60 ++++++++++++++++++++++-----------------------
 sound/usb/mixer_maps.c     |   56 +++++++++++++++++++++---------------------
 sound/usb/mixer_quirks.c   |    6 ++--
 sound/usb/mixer_scarlett.c |   14 +++++-----
 sound/usb/proc.c           |    2 -
 sound/usb/stream.c         |    4 +--
 sound/usb/validate.c       |    4 +--
 7 files changed, 73 insertions(+), 73 deletions(-)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1030,7 +1030,7 @@ struct usb_feature_control_info {
 	int type_uac2;	/* data type for uac2 if different from uac1, else -1 */
 };
 
-static struct usb_feature_control_info audio_feature_info[] = {
+static const struct usb_feature_control_info audio_feature_info[] = {
 	{ UAC_FU_MUTE,			"Mute",			USB_MIXER_INV_BOOLEAN, -1 },
 	{ UAC_FU_VOLUME,		"Volume",		USB_MIXER_S16, -1 },
 	{ UAC_FU_BASS,			"Tone Control - Bass",	USB_MIXER_S8, -1 },
@@ -1544,7 +1544,7 @@ static void check_no_speaker_on_headset(
 	strlcpy(kctl->id.name, "Headphone", sizeof(kctl->id.name));
 }
 
-static struct usb_feature_control_info *get_feature_control_info(int control)
+static const struct usb_feature_control_info *get_feature_control_info(int control)
 {
 	int i;
 
@@ -1562,7 +1562,7 @@ static void __build_feature_ctl(struct u
 				struct usb_audio_term *oterm,
 				int unitid, int nameid, int readonly_mask)
 {
-	struct usb_feature_control_info *ctl_info;
+	const struct usb_feature_control_info *ctl_info;
 	unsigned int len = 0;
 	int mapped_name = 0;
 	struct snd_kcontrol *kctl;
@@ -2237,7 +2237,7 @@ static const struct snd_kcontrol_new mix
  */
 struct procunit_value_info {
 	int control;
-	char *suffix;
+	const char *suffix;
 	int val_type;
 	int min_value;
 };
@@ -2245,44 +2245,44 @@ struct procunit_value_info {
 struct procunit_info {
 	int type;
 	char *name;
-	struct procunit_value_info *values;
+	const struct procunit_value_info *values;
 };
 
-static struct procunit_value_info undefined_proc_info[] = {
+static const struct procunit_value_info undefined_proc_info[] = {
 	{ 0x00, "Control Undefined", 0 },
 	{ 0 }
 };
 
-static struct procunit_value_info updown_proc_info[] = {
+static const struct procunit_value_info updown_proc_info[] = {
 	{ UAC_UD_ENABLE, "Switch", USB_MIXER_BOOLEAN },
 	{ UAC_UD_MODE_SELECT, "Mode Select", USB_MIXER_U8, 1 },
 	{ 0 }
 };
-static struct procunit_value_info prologic_proc_info[] = {
+static const struct procunit_value_info prologic_proc_info[] = {
 	{ UAC_DP_ENABLE, "Switch", USB_MIXER_BOOLEAN },
 	{ UAC_DP_MODE_SELECT, "Mode Select", USB_MIXER_U8, 1 },
 	{ 0 }
 };
-static struct procunit_value_info threed_enh_proc_info[] = {
+static const struct procunit_value_info threed_enh_proc_info[] = {
 	{ UAC_3D_ENABLE, "Switch", USB_MIXER_BOOLEAN },
 	{ UAC_3D_SPACE, "Spaciousness", USB_MIXER_U8 },
 	{ 0 }
 };
-static struct procunit_value_info reverb_proc_info[] = {
+static const struct procunit_value_info reverb_proc_info[] = {
 	{ UAC_REVERB_ENABLE, "Switch", USB_MIXER_BOOLEAN },
 	{ UAC_REVERB_LEVEL, "Level", USB_MIXER_U8 },
 	{ UAC_REVERB_TIME, "Time", USB_MIXER_U16 },
 	{ UAC_REVERB_FEEDBACK, "Feedback", USB_MIXER_U8 },
 	{ 0 }
 };
-static struct procunit_value_info chorus_proc_info[] = {
+static const struct procunit_value_info chorus_proc_info[] = {
 	{ UAC_CHORUS_ENABLE, "Switch", USB_MIXER_BOOLEAN },
 	{ UAC_CHORUS_LEVEL, "Level", USB_MIXER_U8 },
 	{ UAC_CHORUS_RATE, "Rate", USB_MIXER_U16 },
 	{ UAC_CHORUS_DEPTH, "Depth", USB_MIXER_U16 },
 	{ 0 }
 };
-static struct procunit_value_info dcr_proc_info[] = {
+static const struct procunit_value_info dcr_proc_info[] = {
 	{ UAC_DCR_ENABLE, "Switch", USB_MIXER_BOOLEAN },
 	{ UAC_DCR_RATE, "Ratio", USB_MIXER_U16 },
 	{ UAC_DCR_MAXAMPL, "Max Amp", USB_MIXER_S16 },
@@ -2292,7 +2292,7 @@ static struct procunit_value_info dcr_pr
 	{ 0 }
 };
 
-static struct procunit_info procunits[] = {
+static const struct procunit_info procunits[] = {
 	{ UAC_PROCESS_UP_DOWNMIX, "Up Down", updown_proc_info },
 	{ UAC_PROCESS_DOLBY_PROLOGIC, "Dolby Prologic", prologic_proc_info },
 	{ UAC_PROCESS_STEREO_EXTENDER, "3D Stereo Extender", threed_enh_proc_info },
@@ -2302,16 +2302,16 @@ static struct procunit_info procunits[]
 	{ 0 },
 };
 
-static struct procunit_value_info uac3_updown_proc_info[] = {
+static const struct procunit_value_info uac3_updown_proc_info[] = {
 	{ UAC3_UD_MODE_SELECT, "Mode Select", USB_MIXER_U8, 1 },
 	{ 0 }
 };
-static struct procunit_value_info uac3_stereo_ext_proc_info[] = {
+static const struct procunit_value_info uac3_stereo_ext_proc_info[] = {
 	{ UAC3_EXT_WIDTH_CONTROL, "Width Control", USB_MIXER_U8 },
 	{ 0 }
 };
 
-static struct procunit_info uac3_procunits[] = {
+static const struct procunit_info uac3_procunits[] = {
 	{ UAC3_PROCESS_UP_DOWNMIX, "Up Down", uac3_updown_proc_info },
 	{ UAC3_PROCESS_STEREO_EXTENDER, "3D Stereo Extender", uac3_stereo_ext_proc_info },
 	{ UAC3_PROCESS_MULTI_FUNCTION, "Multi-Function", undefined_proc_info },
@@ -2321,23 +2321,23 @@ static struct procunit_info uac3_procuni
 /*
  * predefined data for extension units
  */
-static struct procunit_value_info clock_rate_xu_info[] = {
+static const struct procunit_value_info clock_rate_xu_info[] = {
 	{ USB_XU_CLOCK_RATE_SELECTOR, "Selector", USB_MIXER_U8, 0 },
 	{ 0 }
 };
-static struct procunit_value_info clock_source_xu_info[] = {
+static const struct procunit_value_info clock_source_xu_info[] = {
 	{ USB_XU_CLOCK_SOURCE_SELECTOR, "External", USB_MIXER_BOOLEAN },
 	{ 0 }
 };
-static struct procunit_value_info spdif_format_xu_info[] = {
+static const struct procunit_value_info spdif_format_xu_info[] = {
 	{ USB_XU_DIGITAL_FORMAT_SELECTOR, "SPDIF/AC3", USB_MIXER_BOOLEAN },
 	{ 0 }
 };
-static struct procunit_value_info soft_limit_xu_info[] = {
+static const struct procunit_value_info soft_limit_xu_info[] = {
 	{ USB_XU_SOFT_LIMIT_SELECTOR, " ", USB_MIXER_BOOLEAN },
 	{ 0 }
 };
-static struct procunit_info extunits[] = {
+static const struct procunit_info extunits[] = {
 	{ USB_XU_CLOCK_RATE, "Clock rate", clock_rate_xu_info },
 	{ USB_XU_CLOCK_SOURCE, "DigitalIn CLK source", clock_source_xu_info },
 	{ USB_XU_DIGITAL_IO_STATUS, "DigitalOut format:", spdif_format_xu_info },
@@ -2349,7 +2349,7 @@ static struct procunit_info extunits[] =
  * build a processing/extension unit
  */
 static int build_audio_procunit(struct mixer_build *state, int unitid,
-				void *raw_desc, struct procunit_info *list,
+				void *raw_desc, const struct procunit_info *list,
 				bool extension_unit)
 {
 	struct uac_processing_unit_descriptor *desc = raw_desc;
@@ -2357,14 +2357,14 @@ static int build_audio_procunit(struct m
 	struct usb_mixer_elem_info *cval;
 	struct snd_kcontrol *kctl;
 	int i, err, nameid, type, len;
-	struct procunit_info *info;
-	struct procunit_value_info *valinfo;
+	const struct procunit_info *info;
+	const struct procunit_value_info *valinfo;
 	const struct usbmix_name_map *map;
-	static struct procunit_value_info default_value_info[] = {
+	static const struct procunit_value_info default_value_info[] = {
 		{ 0x01, "Switch", USB_MIXER_BOOLEAN },
 		{ 0 }
 	};
-	static struct procunit_info default_info = {
+	static const struct procunit_info default_info = {
 		0, NULL, default_value_info
 	};
 	const char *name = extension_unit ?
@@ -2842,7 +2842,7 @@ struct uac3_badd_profile {
 	int st_chmask;	/* side tone mixing channel mask */
 };
 
-static struct uac3_badd_profile uac3_badd_profiles[] = {
+static const struct uac3_badd_profile uac3_badd_profiles[] = {
 	{
 		/*
 		 * BAIF, BAOF or combination of both
@@ -2903,7 +2903,7 @@ static struct uac3_badd_profile uac3_bad
 };
 
 static bool uac3_badd_func_has_valid_channels(struct usb_mixer_interface *mixer,
-					      struct uac3_badd_profile *f,
+					      const struct uac3_badd_profile *f,
 					      int c_chmask, int p_chmask)
 {
 	/*
@@ -2947,7 +2947,7 @@ static int snd_usb_mixer_controls_badd(s
 	struct usb_device *dev = mixer->chip->dev;
 	struct usb_interface_assoc_descriptor *assoc;
 	int badd_profile = mixer->chip->badd_profile;
-	struct uac3_badd_profile *f;
+	const struct uac3_badd_profile *f;
 	const struct usbmix_ctl_map *map;
 	int p_chmask = 0, c_chmask = 0, st_chmask = 0;
 	int i;
@@ -3241,7 +3241,7 @@ static void snd_usb_mixer_dump_cval(stru
 				    struct usb_mixer_elem_list *list)
 {
 	struct usb_mixer_elem_info *cval = mixer_elem_list_to_info(list);
-	static char *val_types[] = {"BOOLEAN", "INV_BOOLEAN",
+	static const char * const val_types[] = {"BOOLEAN", "INV_BOOLEAN",
 				    "S8", "U8", "S16", "U16"};
 	snd_iprintf(buffer, "    Info: id=%i, control=%i, cmask=0x%x, "
 			    "channels=%i, type=\"%s\"\n", cval->head.id,
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -14,7 +14,7 @@ struct usbmix_name_map {
 	int id;
 	const char *name;
 	int control;
-	struct usbmix_dB_map *dB;
+	const struct usbmix_dB_map *dB;
 };
 
 struct usbmix_selector_map {
@@ -53,7 +53,7 @@ Mic-IN[9] --+->FU[10]-------------------
            ++--+->SU[11]-->FU[12] --------------------------------------------------------------------------------------> USB_OUT[13]
 */
 
-static struct usbmix_name_map extigy_map[] = {
+static const struct usbmix_name_map extigy_map[] = {
 	/* 1: IT pcm */
 	{ 2, "PCM Playback" }, /* FU */
 	/* 3: IT pcm */
@@ -94,12 +94,12 @@ static struct usbmix_name_map extigy_map
  * e.g. no Master and fake PCM volume
  *			Pavel Mihaylov <bin@bash.info>
  */
-static struct usbmix_dB_map mp3plus_dB_1 = {.min = -4781, .max = 0};
+static const struct usbmix_dB_map mp3plus_dB_1 = {.min = -4781, .max = 0};
 						/* just guess */
-static struct usbmix_dB_map mp3plus_dB_2 = {.min = -1781, .max = 618};
+static const struct usbmix_dB_map mp3plus_dB_2 = {.min = -1781, .max = 618};
 						/* just guess */
 
-static struct usbmix_name_map mp3plus_map[] = {
+static const struct usbmix_name_map mp3plus_map[] = {
 	/* 1: IT pcm */
 	/* 2: IT mic */
 	/* 3: IT line */
@@ -140,7 +140,7 @@ Lin_IN[7]-+--->FU[8]---+              +-
             |                                              ^
             +->FU[13]--------------------------------------+
 */
-static struct usbmix_name_map audigy2nx_map[] = {
+static const struct usbmix_name_map audigy2nx_map[] = {
 	/* 1: IT pcm playback */
 	/* 4: IT digital in */
 	{ 6, "Digital In Playback" }, /* FU */
@@ -168,12 +168,12 @@ static struct usbmix_name_map audigy2nx_
 	{ 0 } /* terminator */
 };
 
-static struct usbmix_name_map mbox1_map[] = {
+static const struct usbmix_name_map mbox1_map[] = {
 	{ 1, "Clock" },
 	{ 0 } /* terminator */
 };
 
-static struct usbmix_selector_map c400_selectors[] = {
+static const struct usbmix_selector_map c400_selectors[] = {
 	{
 		.id = 0x80,
 		.count = 2,
@@ -182,7 +182,7 @@ static struct usbmix_selector_map c400_s
 	{ 0 } /* terminator */
 };
 
-static struct usbmix_selector_map audigy2nx_selectors[] = {
+static const struct usbmix_selector_map audigy2nx_selectors[] = {
 	{
 		.id = 14, /* Capture Source */
 		.count = 3,
@@ -202,21 +202,21 @@ static struct usbmix_selector_map audigy
 };
 
 /* Creative SoundBlaster Live! 24-bit External */
-static struct usbmix_name_map live24ext_map[] = {
+static const struct usbmix_name_map live24ext_map[] = {
 	/* 2: PCM Playback Volume */
 	{ 5, "Mic Capture" }, /* FU, default PCM Capture Volume */
 	{ 0 } /* terminator */
 };
 
 /* LineX FM Transmitter entry - needed to bypass controls bug */
-static struct usbmix_name_map linex_map[] = {
+static const struct usbmix_name_map linex_map[] = {
 	/* 1: IT pcm */
 	/* 2: OT Speaker */ 
 	{ 3, "Master" }, /* FU: master volume - left / right / mute */
 	{ 0 } /* terminator */
 };
 
-static struct usbmix_name_map maya44_map[] = {
+static const struct usbmix_name_map maya44_map[] = {
 	/* 1: IT line */
 	{ 2, "Line Playback" }, /* FU */
 	/* 3: IT line */
@@ -239,7 +239,7 @@ static struct usbmix_name_map maya44_map
  * so this map removes all unwanted sliders from alsamixer
  */
 
-static struct usbmix_name_map justlink_map[] = {
+static const struct usbmix_name_map justlink_map[] = {
 	/* 1: IT pcm playback */
 	/* 2: Not present */
 	{ 3, NULL}, /* IT mic (No mic input on device) */
@@ -256,7 +256,7 @@ static struct usbmix_name_map justlink_m
 };
 
 /* TerraTec Aureon 5.1 MkII USB */
-static struct usbmix_name_map aureon_51_2_map[] = {
+static const struct usbmix_name_map aureon_51_2_map[] = {
 	/* 1: IT USB */
 	/* 2: IT Mic */
 	/* 3: IT Line */
@@ -275,7 +275,7 @@ static struct usbmix_name_map aureon_51_
 	{} /* terminator */
 };
 
-static struct usbmix_name_map scratch_live_map[] = {
+static const struct usbmix_name_map scratch_live_map[] = {
 	/* 1: IT Line 1 (USB streaming) */
 	/* 2: OT Line 1 (Speaker) */
 	/* 3: IT Line 1 (Line connector) */
@@ -291,7 +291,7 @@ static struct usbmix_name_map scratch_li
 	{ 0 } /* terminator */
 };
 
-static struct usbmix_name_map ebox44_map[] = {
+static const struct usbmix_name_map ebox44_map[] = {
 	{ 4, NULL }, /* FU */
 	{ 6, NULL }, /* MU */
 	{ 7, NULL }, /* FU */
@@ -306,7 +306,7 @@ static struct usbmix_name_map ebox44_map
  *  FIXME: or mp3plus_map should use "Capture Source" too,
  *  so this maps can be merget
  */
-static struct usbmix_name_map hercules_usb51_map[] = {
+static const struct usbmix_name_map hercules_usb51_map[] = {
 	{ 8, "Capture Source" },	/* SU, default "PCM Capture Source" */
 	{ 9, "Master Playback" },	/* FU, default "Speaker Playback" */
 	{ 10, "Mic Boost", 7 },		/* FU, default "Auto Gain Input" */
@@ -317,7 +317,7 @@ static struct usbmix_name_map hercules_u
 };
 
 /* Plantronics Gamecom 780 has a broken volume control, better to disable it */
-static struct usbmix_name_map gamecom780_map[] = {
+static const struct usbmix_name_map gamecom780_map[] = {
 	{ 9, NULL }, /* FU, speaker out */
 	{}
 };
@@ -331,8 +331,8 @@ static const struct usbmix_name_map scms
 };
 
 /* Bose companion 5, the dB conversion factor is 16 instead of 256 */
-static struct usbmix_dB_map bose_companion5_dB = {-5006, -6};
-static struct usbmix_name_map bose_companion5_map[] = {
+static const struct usbmix_dB_map bose_companion5_dB = {-5006, -6};
+static const struct usbmix_name_map bose_companion5_map[] = {
 	{ 3, NULL, .dB = &bose_companion5_dB },
 	{ 0 }	/* terminator */
 };
@@ -406,7 +406,7 @@ static const struct usbmix_name_map aoru
  * Control map entries
  */
 
-static struct usbmix_ctl_map usbmix_ctl_maps[] = {
+static const struct usbmix_ctl_map usbmix_ctl_maps[] = {
 	{
 		.id = USB_ID(0x041e, 0x3000),
 		.map = extigy_map,
@@ -560,37 +560,37 @@ static struct usbmix_ctl_map usbmix_ctl_
  * Control map entries for UAC3 BADD profiles
  */
 
-static struct usbmix_name_map uac3_badd_generic_io_map[] = {
+static const struct usbmix_name_map uac3_badd_generic_io_map[] = {
 	{ UAC3_BADD_FU_ID2, "Generic Out Playback" },
 	{ UAC3_BADD_FU_ID5, "Generic In Capture" },
 	{ 0 }					/* terminator */
 };
-static struct usbmix_name_map uac3_badd_headphone_map[] = {
+static const struct usbmix_name_map uac3_badd_headphone_map[] = {
 	{ UAC3_BADD_FU_ID2, "Headphone Playback" },
 	{ 0 }					/* terminator */
 };
-static struct usbmix_name_map uac3_badd_speaker_map[] = {
+static const struct usbmix_name_map uac3_badd_speaker_map[] = {
 	{ UAC3_BADD_FU_ID2, "Speaker Playback" },
 	{ 0 }					/* terminator */
 };
-static struct usbmix_name_map uac3_badd_microphone_map[] = {
+static const struct usbmix_name_map uac3_badd_microphone_map[] = {
 	{ UAC3_BADD_FU_ID5, "Mic Capture" },
 	{ 0 }					/* terminator */
 };
 /* Covers also 'headset adapter' profile */
-static struct usbmix_name_map uac3_badd_headset_map[] = {
+static const struct usbmix_name_map uac3_badd_headset_map[] = {
 	{ UAC3_BADD_FU_ID2, "Headset Playback" },
 	{ UAC3_BADD_FU_ID5, "Headset Capture" },
 	{ UAC3_BADD_FU_ID7, "Sidetone Mixing" },
 	{ 0 }					/* terminator */
 };
-static struct usbmix_name_map uac3_badd_speakerphone_map[] = {
+static const struct usbmix_name_map uac3_badd_speakerphone_map[] = {
 	{ UAC3_BADD_FU_ID2, "Speaker Playback" },
 	{ UAC3_BADD_FU_ID5, "Mic Capture" },
 	{ 0 }					/* terminator */
 };
 
-static struct usbmix_ctl_map uac3_badd_usbmix_ctl_maps[] = {
+static const struct usbmix_ctl_map uac3_badd_usbmix_ctl_maps[] = {
 	{
 		.id = UAC3_FUNCTION_SUBCLASS_GENERIC_IO,
 		.map = uac3_badd_generic_io_map,
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -119,7 +119,7 @@ static int snd_create_std_mono_ctl(struc
  * Create a set of standard UAC controls from a table
  */
 static int snd_create_std_mono_table(struct usb_mixer_interface *mixer,
-				struct std_mono_table *t)
+				     const struct std_mono_table *t)
 {
 	int err;
 
@@ -1388,7 +1388,7 @@ static int snd_c400_create_mixer(struct
  * are valid they presents mono controls as L and R channels of
  * stereo. So we provide a good mixer here.
  */
-static struct std_mono_table ebox44_table[] = {
+static const struct std_mono_table ebox44_table[] = {
 	{
 		.unitid = 4,
 		.control = 1,
@@ -1697,7 +1697,7 @@ static struct snd_kcontrol_new snd_micro
 static int snd_microii_controls_create(struct usb_mixer_interface *mixer)
 {
 	int err, i;
-	static usb_mixer_elem_resume_func_t resume_funcs[] = {
+	const static usb_mixer_elem_resume_func_t resume_funcs[] = {
 		snd_microii_spdif_default_update,
 		NULL,
 		snd_microii_spdif_switch_update
--- a/sound/usb/mixer_scarlett.c
+++ b/sound/usb/mixer_scarlett.c
@@ -623,7 +623,7 @@ static int add_output_ctls(struct usb_mi
 /********************** device-specific config *************************/
 
 /*  untested...  */
-static struct scarlett_device_info s6i6_info = {
+static const struct scarlett_device_info s6i6_info = {
 	.matrix_in = 18,
 	.matrix_out = 8,
 	.input_len = 6,
@@ -665,7 +665,7 @@ static struct scarlett_device_info s6i6_
 };
 
 /*  untested...  */
-static struct scarlett_device_info s8i6_info = {
+static const struct scarlett_device_info s8i6_info = {
 	.matrix_in = 18,
 	.matrix_out = 6,
 	.input_len = 8,
@@ -704,7 +704,7 @@ static struct scarlett_device_info s8i6_
 	}
 };
 
-static struct scarlett_device_info s18i6_info = {
+static const struct scarlett_device_info s18i6_info = {
 	.matrix_in = 18,
 	.matrix_out = 6,
 	.input_len = 18,
@@ -741,7 +741,7 @@ static struct scarlett_device_info s18i6
 	}
 };
 
-static struct scarlett_device_info s18i8_info = {
+static const struct scarlett_device_info s18i8_info = {
 	.matrix_in = 18,
 	.matrix_out = 8,
 	.input_len = 18,
@@ -783,7 +783,7 @@ static struct scarlett_device_info s18i8
 	}
 };
 
-static struct scarlett_device_info s18i20_info = {
+static const struct scarlett_device_info s18i20_info = {
 	.matrix_in = 18,
 	.matrix_out = 8,
 	.input_len = 18,
@@ -833,7 +833,7 @@ static struct scarlett_device_info s18i2
 
 
 static int scarlett_controls_create_generic(struct usb_mixer_interface *mixer,
-	struct scarlett_device_info *info)
+	const struct scarlett_device_info *info)
 {
 	int i, err;
 	char mx[SNDRV_CTL_ELEM_ID_NAME_MAXLEN];
@@ -896,7 +896,7 @@ int snd_scarlett_controls_create(struct
 {
 	int err, i, o;
 	char mx[SNDRV_CTL_ELEM_ID_NAME_MAXLEN];
-	struct scarlett_device_info *info;
+	const struct scarlett_device_info *info;
 	struct usb_mixer_elem_info *elem;
 	static char sample_rate_buffer[4] = { '\x80', '\xbb', '\x00', '\x00' };
 
--- a/sound/usb/proc.c
+++ b/sound/usb/proc.c
@@ -60,7 +60,7 @@ void snd_usb_audio_create_proc(struct sn
 static void proc_dump_substream_formats(struct snd_usb_substream *subs, struct snd_info_buffer *buffer)
 {
 	struct audioformat *fp;
-	static char *sync_types[4] = {
+	static const char * const sync_types[4] = {
 		"NONE", "ASYNC", "ADAPTIVE", "SYNC"
 	};
 
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -240,7 +240,7 @@ static int add_chmap(struct snd_pcm *pcm
 static struct snd_pcm_chmap_elem *convert_chmap(int channels, unsigned int bits,
 						int protocol)
 {
-	static unsigned int uac1_maps[] = {
+	static const unsigned int uac1_maps[] = {
 		SNDRV_CHMAP_FL,		/* left front */
 		SNDRV_CHMAP_FR,		/* right front */
 		SNDRV_CHMAP_FC,		/* center front */
@@ -255,7 +255,7 @@ static struct snd_pcm_chmap_elem *conver
 		SNDRV_CHMAP_TC,		/* top */
 		0 /* terminator */
 	};
-	static unsigned int uac2_maps[] = {
+	static const unsigned int uac2_maps[] = {
 		SNDRV_CHMAP_FL,		/* front left */
 		SNDRV_CHMAP_FR,		/* front right */
 		SNDRV_CHMAP_FC,		/* front center */
--- a/sound/usb/validate.c
+++ b/sound/usb/validate.c
@@ -233,7 +233,7 @@ static bool validate_midi_out_jack(const
 #define FIXED(p, t, s) { .protocol = (p), .type = (t), .size = sizeof(s) }
 #define FUNC(p, t, f) { .protocol = (p), .type = (t), .func = (f) }
 
-static struct usb_desc_validator audio_validators[] = {
+static const struct usb_desc_validator audio_validators[] = {
 	/* UAC1 */
 	FUNC(UAC_VERSION_1, UAC_HEADER, validate_uac1_header),
 	FIXED(UAC_VERSION_1, UAC_INPUT_TERMINAL,
@@ -288,7 +288,7 @@ static struct usb_desc_validator audio_v
 	{ } /* terminator */
 };
 
-static struct usb_desc_validator midi_validators[] = {
+static const struct usb_desc_validator midi_validators[] = {
 	FIXED(UAC_VERSION_ALL, USB_MS_HEADER,
 	      struct usb_ms_header_descriptor),
 	FIXED(UAC_VERSION_ALL, USB_MS_MIDI_IN_JACK,


