Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22105333DF9
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233037AbhCJNZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:45716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232946AbhCJNYn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0E5364FEE;
        Wed, 10 Mar 2021 13:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382683;
        bh=n6Yd9CQ6SzzewvAlhegUUD/z3Q82BsASuXXUWZyr2YE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n+N4Vd6O6x1aBhPSyS9LMGqDR0h+SHE2u/JFmW3yfrjXBp6HtSZC568ChQUsDOPT6
         EgL+kFs3eLhpd+i0y7UsjqKt+3V9C3JKlhx3ldtuips8Vr4XeqTm7gyHPlgDp1WWTW
         A5MLfbR9e5/8S1KrQZLGqVH48P7ZftaSwc9NZkMI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivia Mackintosh <livvy@base.nu>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 27/36] ALSA: usb-audio: Add DJM750 to Pioneer mixer quirk
Date:   Wed, 10 Mar 2021 14:23:40 +0100
Message-Id: <20210310132321.361313439@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.510840709@linuxfoundation.org>
References: <20210310132320.510840709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Olivia Mackintosh <livvy@base.nu>

[ Upstream commit a07df82c799013236aa90a140785775eda9f9523 ]

This allows for N different devices to use the pioneer mixer quirk for
setting capture/record type and recording level. The impementation has
not changed much with the exception of an additional mask on
private_value to allow storing of a device index:
	DEVICE MASK	0xff000000
	GROUP_MASK	0x00ff0000
	VALUE_MASK	0x0000ffff

This could be improved by changing the arrays of wValues for each
channel to contain named definitions (e.g. SND_DJM_CAP_LINE). It would
improve readability and perhaps would allow using the same array for
multiple channels. The channel number can be specified on the control
next to the wIndex.

Feedback is very much appreciated as I'm not the most proficient C
programmer but am learning as I go.

Signed-off-by: Olivia Mackintosh <livvy@base.nu>
Link: https://lore.kernel.org/r/20210205184256.10201-2-livvy@base.nu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c | 336 +++++++++++++++++++++++++--------------
 1 file changed, 216 insertions(+), 120 deletions(-)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index df036a359f2f..788b75cb9447 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -2603,141 +2603,221 @@ static int snd_bbfpro_controls_create(struct usb_mixer_interface *mixer)
 }
 
 /*
- * Pioneer DJ DJM-250MK2 and maybe other DJM models
+ * Pioneer DJ DJM Mixers
  *
- * For playback, no duplicate mapping should be set.
- * There are three mixer stereo channels (CH1, CH2, AUX)
- * and three stereo sources (Playback 1-2, Playback 3-4, Playback 5-6).
- * Each channel should be mapped just once to one source.
- * If mapped multiple times, only one source will play on given channel
- * (sources are not mixed together).
+ * These devices generally have options for soft-switching the playback and
+ * capture sources in addition to the recording level. Although different
+ * devices have different configurations, there seems to be canonical values
+ * for specific capture/playback types:  See the definitions of these below.
  *
- * For recording, duplicate mapping is OK. We will get the same signal multiple times.
- *
- * Channels 7-8 are in both directions fixed to FX SEND / FX RETURN.
- *
- * See also notes in the quirks-table.h file.
+ * The wValue is masked with the stereo channel number. e.g. Setting Ch2 to
+ * capture phono would be 0x0203. Capture, playback and capture level have
+ * different wIndexes.
  */
 
-struct snd_pioneer_djm_option {
-	const u16 wIndex;
-	const u16 wValue;
+// Capture types
+#define SND_DJM_CAP_LINE	0x00
+#define SND_DJM_CAP_CDLINE	0x01
+#define SND_DJM_CAP_PHONO	0x03
+#define SND_DJM_CAP_PFADER	0x06
+#define SND_DJM_CAP_XFADERA	0x07
+#define SND_DJM_CAP_XFADERB	0x08
+#define SND_DJM_CAP_MIC		0x09
+#define SND_DJM_CAP_AUX		0x0d
+#define SND_DJM_CAP_RECOUT	0x0a
+#define SND_DJM_CAP_NONE	0x0f
+#define SND_DJM_CAP_CH1PFADER	0x11
+#define SND_DJM_CAP_CH2PFADER	0x12
+
+// Playback types
+#define SND_DJM_PB_CH1		0x00
+#define SND_DJM_PB_CH2		0x01
+#define SND_DJM_PB_AUX		0x04
+
+#define SND_DJM_WINDEX_CAP	0x8002
+#define SND_DJM_WINDEX_CAPLVL	0x8003
+#define SND_DJM_WINDEX_PB	0x8016
+
+// kcontrol->private_value layout
+#define SND_DJM_VALUE_MASK	0x0000ffff
+#define SND_DJM_GROUP_MASK	0x00ff0000
+#define SND_DJM_DEVICE_MASK	0xff000000
+#define SND_DJM_GROUP_SHIFT	16
+#define SND_DJM_DEVICE_SHIFT	24
+
+// device table index
+#define SND_DJM_250MK2_IDX	0x0
+#define SND_DJM_750_IDX		0x1
+
+
+#define SND_DJM_CTL(_name, suffix, _default_value, _windex) { \
+	.name = _name, \
+	.options = snd_djm_opts_##suffix, \
+	.noptions = ARRAY_SIZE(snd_djm_opts_##suffix), \
+	.default_value = _default_value, \
+	.wIndex = _windex }
+
+#define SND_DJM_DEVICE(suffix) { \
+	.controls = snd_djm_ctls_##suffix, \
+	.ncontrols = ARRAY_SIZE(snd_djm_ctls_##suffix) }
+
+
+struct snd_djm_device {
 	const char *name;
+	const struct snd_djm_ctl *controls;
+	size_t ncontrols;
 };
 
-static const struct snd_pioneer_djm_option snd_pioneer_djm_options_capture_level[] = {
-	{ .name =  "-5 dB",                  .wValue = 0x0300, .wIndex = 0x8003 },
-	{ .name = "-10 dB",                  .wValue = 0x0200, .wIndex = 0x8003 },
-	{ .name = "-15 dB",                  .wValue = 0x0100, .wIndex = 0x8003 },
-	{ .name = "-19 dB",                  .wValue = 0x0000, .wIndex = 0x8003 }
+struct snd_djm_ctl {
+	const char *name;
+	const u16 *options;
+	size_t noptions;
+	u16 default_value;
+	u16 wIndex;
 };
 
-static const struct snd_pioneer_djm_option snd_pioneer_djm_options_capture_ch12[] = {
-	{ .name =  "CH1 Control Tone PHONO", .wValue = 0x0103, .wIndex = 0x8002 },
-	{ .name =  "CH1 Control Tone LINE",  .wValue = 0x0100, .wIndex = 0x8002 },
-	{ .name =  "Post CH1 Fader",         .wValue = 0x0106, .wIndex = 0x8002 },
-	{ .name =  "Cross Fader A",          .wValue = 0x0107, .wIndex = 0x8002 },
-	{ .name =  "Cross Fader B",          .wValue = 0x0108, .wIndex = 0x8002 },
-	{ .name =  "MIC",                    .wValue = 0x0109, .wIndex = 0x8002 },
-	{ .name =  "AUX",                    .wValue = 0x010d, .wIndex = 0x8002 },
-	{ .name =  "REC OUT",                .wValue = 0x010a, .wIndex = 0x8002 }
+static const char *snd_djm_get_label_caplevel(u16 wvalue)
+{
+	switch (wvalue) {
+	case 0x0000:	return "-19dB";
+	case 0x0100:	return "-15dB";
+	case 0x0200:	return "-10dB";
+	case 0x0300:	return "-5dB";
+	default:	return NULL;
+	}
 };
 
-static const struct snd_pioneer_djm_option snd_pioneer_djm_options_capture_ch34[] = {
-	{ .name =  "CH2 Control Tone PHONO", .wValue = 0x0203, .wIndex = 0x8002 },
-	{ .name =  "CH2 Control Tone LINE",  .wValue = 0x0200, .wIndex = 0x8002 },
-	{ .name =  "Post CH2 Fader",         .wValue = 0x0206, .wIndex = 0x8002 },
-	{ .name =  "Cross Fader A",          .wValue = 0x0207, .wIndex = 0x8002 },
-	{ .name =  "Cross Fader B",          .wValue = 0x0208, .wIndex = 0x8002 },
-	{ .name =  "MIC",                    .wValue = 0x0209, .wIndex = 0x8002 },
-	{ .name =  "AUX",                    .wValue = 0x020d, .wIndex = 0x8002 },
-	{ .name =  "REC OUT",                .wValue = 0x020a, .wIndex = 0x8002 }
+static const char *snd_djm_get_label_cap(u16 wvalue)
+{
+	switch (wvalue & 0x00ff) {
+	case SND_DJM_CAP_LINE:		return "Control Tone LINE";
+	case SND_DJM_CAP_CDLINE:	return "Control Tone CD/LINE";
+	case SND_DJM_CAP_PHONO:		return "Control Tone PHONO";
+	case SND_DJM_CAP_PFADER:	return "Post Fader";
+	case SND_DJM_CAP_XFADERA:	return "Cross Fader A";
+	case SND_DJM_CAP_XFADERB:	return "Cross Fader B";
+	case SND_DJM_CAP_MIC:		return "Mic";
+	case SND_DJM_CAP_RECOUT:	return "Rec Out";
+	case SND_DJM_CAP_AUX:		return "Aux";
+	case SND_DJM_CAP_NONE:		return "None";
+	case SND_DJM_CAP_CH1PFADER:	return "Post Fader Ch1";
+	case SND_DJM_CAP_CH2PFADER:	return "Post Fader Ch2";
+	default:			return NULL;
+	}
 };
 
-static const struct snd_pioneer_djm_option snd_pioneer_djm_options_capture_ch56[] = {
-	{ .name =  "REC OUT",                .wValue = 0x030a, .wIndex = 0x8002 },
-	{ .name =  "Post CH1 Fader",         .wValue = 0x0311, .wIndex = 0x8002 },
-	{ .name =  "Post CH2 Fader",         .wValue = 0x0312, .wIndex = 0x8002 },
-	{ .name =  "Cross Fader A",          .wValue = 0x0307, .wIndex = 0x8002 },
-	{ .name =  "Cross Fader B",          .wValue = 0x0308, .wIndex = 0x8002 },
-	{ .name =  "MIC",                    .wValue = 0x0309, .wIndex = 0x8002 },
-	{ .name =  "AUX",                    .wValue = 0x030d, .wIndex = 0x8002 }
+static const char *snd_djm_get_label_pb(u16 wvalue)
+{
+	switch (wvalue & 0x00ff) {
+	case SND_DJM_PB_CH1:	return "Ch1";
+	case SND_DJM_PB_CH2:	return "Ch2";
+	case SND_DJM_PB_AUX:	return "Aux";
+	default:		return NULL;
+	}
 };
 
-static const struct snd_pioneer_djm_option snd_pioneer_djm_options_playback_12[] = {
-	{ .name =  "CH1",                    .wValue = 0x0100, .wIndex = 0x8016 },
-	{ .name =  "CH2",                    .wValue = 0x0101, .wIndex = 0x8016 },
-	{ .name =  "AUX",                    .wValue = 0x0104, .wIndex = 0x8016 }
+static const char *snd_djm_get_label(u16 wvalue, u16 windex)
+{
+	switch (windex) {
+	case SND_DJM_WINDEX_CAPLVL:	return snd_djm_get_label_caplevel(wvalue);
+	case SND_DJM_WINDEX_CAP:	return snd_djm_get_label_cap(wvalue);
+	case SND_DJM_WINDEX_PB:		return snd_djm_get_label_pb(wvalue);
+	default:			return NULL;
+	}
 };
 
-static const struct snd_pioneer_djm_option snd_pioneer_djm_options_playback_34[] = {
-	{ .name =  "CH1",                    .wValue = 0x0200, .wIndex = 0x8016 },
-	{ .name =  "CH2",                    .wValue = 0x0201, .wIndex = 0x8016 },
-	{ .name =  "AUX",                    .wValue = 0x0204, .wIndex = 0x8016 }
-};
 
-static const struct snd_pioneer_djm_option snd_pioneer_djm_options_playback_56[] = {
-	{ .name =  "CH1",                    .wValue = 0x0300, .wIndex = 0x8016 },
-	{ .name =  "CH2",                    .wValue = 0x0301, .wIndex = 0x8016 },
-	{ .name =  "AUX",                    .wValue = 0x0304, .wIndex = 0x8016 }
+// DJM-250MK2
+static const u16 snd_djm_opts_cap_level[] = {
+	0x0000, 0x0100, 0x0200, 0x0300 };
+
+static const u16 snd_djm_opts_250mk2_cap1[] = {
+	0x0103, 0x0100, 0x0106, 0x0107, 0x0108, 0x0109, 0x010d, 0x010a };
+
+static const u16 snd_djm_opts_250mk2_cap2[] = {
+	0x0203, 0x0200, 0x0206, 0x0207, 0x0208, 0x0209, 0x020d, 0x020a };
+
+static const u16 snd_djm_opts_250mk2_cap3[] = {
+	0x030a, 0x0311, 0x0312, 0x0307, 0x0308, 0x0309, 0x030d };
+
+static const u16 snd_djm_opts_250mk2_pb1[] = { 0x0100, 0x0101, 0x0104 };
+static const u16 snd_djm_opts_250mk2_pb2[] = { 0x0200, 0x0201, 0x0204 };
+static const u16 snd_djm_opts_250mk2_pb3[] = { 0x0300, 0x0301, 0x0304 };
+
+static const struct snd_djm_ctl snd_djm_ctls_250mk2[] = {
+	SND_DJM_CTL("Capture Level", cap_level, 0, SND_DJM_WINDEX_CAPLVL),
+	SND_DJM_CTL("Ch1 Input",   250mk2_cap1, 2, SND_DJM_WINDEX_CAP),
+	SND_DJM_CTL("Ch2 Input",   250mk2_cap2, 2, SND_DJM_WINDEX_CAP),
+	SND_DJM_CTL("Ch3 Input",   250mk2_cap3, 0, SND_DJM_WINDEX_CAP),
+	SND_DJM_CTL("Ch1 Output",   250mk2_pb1, 0, SND_DJM_WINDEX_PB),
+	SND_DJM_CTL("Ch2 Output",   250mk2_pb2, 1, SND_DJM_WINDEX_PB),
+	SND_DJM_CTL("Ch3 Output",   250mk2_pb3, 2, SND_DJM_WINDEX_PB)
 };
 
-struct snd_pioneer_djm_option_group {
-	const char *name;
-	const struct snd_pioneer_djm_option *options;
-	const size_t count;
-	const u16 default_value;
+
+// DJM-750
+static const u16 snd_djm_opts_750_cap1[] = {
+	0x0101, 0x0103, 0x0106, 0x0107, 0x0108, 0x0109, 0x010a, 0x010f };
+static const u16 snd_djm_opts_750_cap2[] = {
+	0x0200, 0x0201, 0x0206, 0x0207, 0x0208, 0x0209, 0x020a, 0x020f };
+static const u16 snd_djm_opts_750_cap3[] = {
+	0x0300, 0x0301, 0x0306, 0x0307, 0x0308, 0x0309, 0x030a, 0x030f };
+static const u16 snd_djm_opts_750_cap4[] = {
+	0x0401, 0x0403, 0x0406, 0x0407, 0x0408, 0x0409, 0x040a, 0x040f };
+
+static const struct snd_djm_ctl snd_djm_ctls_750[] = {
+	SND_DJM_CTL("Capture Level", cap_level, 0, SND_DJM_WINDEX_CAPLVL),
+	SND_DJM_CTL("Ch1 Input",   750_cap1, 2, SND_DJM_WINDEX_CAP),
+	SND_DJM_CTL("Ch2 Input",   750_cap2, 2, SND_DJM_WINDEX_CAP),
+	SND_DJM_CTL("Ch3 Input",   750_cap3, 0, SND_DJM_WINDEX_CAP),
+	SND_DJM_CTL("Ch4 Input",   750_cap4, 0, SND_DJM_WINDEX_CAP)
 };
 
-#define snd_pioneer_djm_option_group_item(_name, suffix, _default_value) { \
-	.name = _name, \
-	.options = snd_pioneer_djm_options_##suffix, \
-	.count = ARRAY_SIZE(snd_pioneer_djm_options_##suffix), \
-	.default_value = _default_value }
-
-static const struct snd_pioneer_djm_option_group snd_pioneer_djm_option_groups[] = {
-	snd_pioneer_djm_option_group_item("Master Capture Level Capture Switch", capture_level, 0),
-	snd_pioneer_djm_option_group_item("Capture 1-2 Capture Switch",          capture_ch12,  2),
-	snd_pioneer_djm_option_group_item("Capture 3-4 Capture Switch",          capture_ch34,  2),
-	snd_pioneer_djm_option_group_item("Capture 5-6 Capture Switch",          capture_ch56,  0),
-	snd_pioneer_djm_option_group_item("Playback 1-2 Playback Switch",        playback_12,   0),
-	snd_pioneer_djm_option_group_item("Playback 3-4 Playback Switch",        playback_34,   1),
-	snd_pioneer_djm_option_group_item("Playback 5-6 Playback Switch",        playback_56,   2)
+
+static const struct snd_djm_device snd_djm_devices[] = {
+	SND_DJM_DEVICE(250mk2),
+	SND_DJM_DEVICE(750)
 };
 
-// layout of the kcontrol->private_value:
-#define SND_PIONEER_DJM_VALUE_MASK 0x0000ffff
-#define SND_PIONEER_DJM_GROUP_MASK 0xffff0000
-#define SND_PIONEER_DJM_GROUP_SHIFT 16
 
-static int snd_pioneer_djm_controls_info(struct snd_kcontrol *kctl, struct snd_ctl_elem_info *info)
+static int snd_djm_controls_info(struct snd_kcontrol *kctl,
+				struct snd_ctl_elem_info *info)
 {
-	u16 group_index = kctl->private_value >> SND_PIONEER_DJM_GROUP_SHIFT;
-	size_t count;
+	unsigned long private_value = kctl->private_value;
+	u8 device_idx = (private_value & SND_DJM_DEVICE_MASK) >> SND_DJM_DEVICE_SHIFT;
+	u8 ctl_idx = (private_value & SND_DJM_GROUP_MASK) >> SND_DJM_GROUP_SHIFT;
+	const struct snd_djm_device *device = &snd_djm_devices[device_idx];
 	const char *name;
-	const struct snd_pioneer_djm_option_group *group;
+	const struct snd_djm_ctl *ctl;
+	size_t noptions;
+
+	if (ctl_idx >= device->ncontrols)
+		return -EINVAL;
+
+	ctl = &device->controls[ctl_idx];
+	noptions = ctl->noptions;
+	if (info->value.enumerated.item >= noptions)
+		info->value.enumerated.item = noptions - 1;
 
-	if (group_index >= ARRAY_SIZE(snd_pioneer_djm_option_groups))
+	name = snd_djm_get_label(ctl->options[info->value.enumerated.item],
+				ctl->wIndex);
+	if (!name)
 		return -EINVAL;
 
-	group = &snd_pioneer_djm_option_groups[group_index];
-	count = group->count;
-	if (info->value.enumerated.item >= count)
-		info->value.enumerated.item = count - 1;
-	name = group->options[info->value.enumerated.item].name;
 	strlcpy(info->value.enumerated.name, name, sizeof(info->value.enumerated.name));
 	info->type = SNDRV_CTL_ELEM_TYPE_ENUMERATED;
 	info->count = 1;
-	info->value.enumerated.items = count;
+	info->value.enumerated.items = noptions;
 	return 0;
 }
 
-static int snd_pioneer_djm_controls_update(struct usb_mixer_interface *mixer, u16 group, u16 value)
+static int snd_djm_controls_update(struct usb_mixer_interface *mixer,
+				u8 device_idx, u8 group, u16 value)
 {
 	int err;
+	const struct snd_djm_device *device = &snd_djm_devices[device_idx];
 
-	if (group >= ARRAY_SIZE(snd_pioneer_djm_option_groups)
-			|| value >= snd_pioneer_djm_option_groups[group].count)
+	if ((group >= device->ncontrols) || value >= device->controls[group].noptions)
 		return -EINVAL;
 
 	err = snd_usb_lock_shutdown(mixer->chip);
@@ -2748,63 +2828,76 @@ static int snd_pioneer_djm_controls_update(struct usb_mixer_interface *mixer, u1
 		mixer->chip->dev, usb_sndctrlpipe(mixer->chip->dev, 0),
 		USB_REQ_SET_FEATURE,
 		USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-		snd_pioneer_djm_option_groups[group].options[value].wValue,
-		snd_pioneer_djm_option_groups[group].options[value].wIndex,
+		device->controls[group].options[value],
+		device->controls[group].wIndex,
 		NULL, 0);
 
 	snd_usb_unlock_shutdown(mixer->chip);
 	return err;
 }
 
-static int snd_pioneer_djm_controls_get(struct snd_kcontrol *kctl, struct snd_ctl_elem_value *elem)
+static int snd_djm_controls_get(struct snd_kcontrol *kctl,
+				struct snd_ctl_elem_value *elem)
 {
-	elem->value.enumerated.item[0] = kctl->private_value & SND_PIONEER_DJM_VALUE_MASK;
+	elem->value.enumerated.item[0] = kctl->private_value & SND_DJM_VALUE_MASK;
 	return 0;
 }
 
-static int snd_pioneer_djm_controls_put(struct snd_kcontrol *kctl, struct snd_ctl_elem_value *elem)
+static int snd_djm_controls_put(struct snd_kcontrol *kctl, struct snd_ctl_elem_value *elem)
 {
 	struct usb_mixer_elem_list *list = snd_kcontrol_chip(kctl);
 	struct usb_mixer_interface *mixer = list->mixer;
 	unsigned long private_value = kctl->private_value;
-	u16 group = (private_value & SND_PIONEER_DJM_GROUP_MASK) >> SND_PIONEER_DJM_GROUP_SHIFT;
+
+	u8 device = (private_value & SND_DJM_DEVICE_MASK) >> SND_DJM_DEVICE_SHIFT;
+	u8 group = (private_value & SND_DJM_GROUP_MASK) >> SND_DJM_GROUP_SHIFT;
 	u16 value = elem->value.enumerated.item[0];
 
-	kctl->private_value = (group << SND_PIONEER_DJM_GROUP_SHIFT) | value;
+	kctl->private_value = ((device << SND_DJM_DEVICE_SHIFT) |
+			      (group << SND_DJM_GROUP_SHIFT) |
+			      value);
 
-	return snd_pioneer_djm_controls_update(mixer, group, value);
+	return snd_djm_controls_update(mixer, device, group, value);
 }
 
-static int snd_pioneer_djm_controls_resume(struct usb_mixer_elem_list *list)
+static int snd_djm_controls_resume(struct usb_mixer_elem_list *list)
 {
 	unsigned long private_value = list->kctl->private_value;
-	u16 group = (private_value & SND_PIONEER_DJM_GROUP_MASK) >> SND_PIONEER_DJM_GROUP_SHIFT;
-	u16 value = (private_value & SND_PIONEER_DJM_VALUE_MASK);
+	u8 device = (private_value & SND_DJM_DEVICE_MASK) >> SND_DJM_DEVICE_SHIFT;
+	u8 group = (private_value & SND_DJM_GROUP_MASK) >> SND_DJM_GROUP_SHIFT;
+	u16 value = (private_value & SND_DJM_VALUE_MASK);
 
-	return snd_pioneer_djm_controls_update(list->mixer, group, value);
+	return snd_djm_controls_update(list->mixer, device, group, value);
 }
 
-static int snd_pioneer_djm_controls_create(struct usb_mixer_interface *mixer)
+static int snd_djm_controls_create(struct usb_mixer_interface *mixer,
+		const u8 device_idx)
 {
 	int err, i;
-	const struct snd_pioneer_djm_option_group *group;
+	u16 value;
+
+	const struct snd_djm_device *device = &snd_djm_devices[device_idx];
+
 	struct snd_kcontrol_new knew = {
 		.iface  = SNDRV_CTL_ELEM_IFACE_MIXER,
 		.access = SNDRV_CTL_ELEM_ACCESS_READWRITE,
 		.index = 0,
-		.info = snd_pioneer_djm_controls_info,
-		.get  = snd_pioneer_djm_controls_get,
-		.put  = snd_pioneer_djm_controls_put
+		.info = snd_djm_controls_info,
+		.get  = snd_djm_controls_get,
+		.put  = snd_djm_controls_put
 	};
 
-	for (i = 0; i < ARRAY_SIZE(snd_pioneer_djm_option_groups); i++) {
-		group = &snd_pioneer_djm_option_groups[i];
-		knew.name = group->name;
-		knew.private_value = (i << SND_PIONEER_DJM_GROUP_SHIFT) | group->default_value;
-		err = snd_pioneer_djm_controls_update(mixer, i, group->default_value);
+	for (i = 0; i < device->ncontrols; i++) {
+		value = device->controls[i].default_value;
+		knew.name = device->controls[i].name;
+		knew.private_value = (
+			(device_idx << SND_DJM_DEVICE_SHIFT) |
+			(i << SND_DJM_GROUP_SHIFT) |
+			value);
+		err = snd_djm_controls_update(mixer, device_idx, i, value);
 		if (err)
 			return err;
-		err = add_single_ctl_with_resume(mixer, 0, snd_pioneer_djm_controls_resume,
+		err = add_single_ctl_with_resume(mixer, 0, snd_djm_controls_resume,
 						 &knew, NULL);
 		if (err)
 			return err;
@@ -2917,7 +3010,10 @@ int snd_usb_mixer_apply_create_quirk(struct usb_mixer_interface *mixer)
 		err = snd_bbfpro_controls_create(mixer);
 		break;
 	case USB_ID(0x2b73, 0x0017): /* Pioneer DJ DJM-250MK2 */
-		err = snd_pioneer_djm_controls_create(mixer);
+		err = snd_djm_controls_create(mixer, SND_DJM_250MK2_IDX);
+		break;
+	case USB_ID(0x08e4, 0x017f): /* Pioneer DJ DJM-750 */
+		err = snd_djm_controls_create(mixer, SND_DJM_750_IDX);
 		break;
 	}
 
-- 
2.30.1



