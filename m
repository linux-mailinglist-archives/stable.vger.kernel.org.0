Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25611196BDE
	for <lists+stable@lfdr.de>; Sun, 29 Mar 2020 10:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgC2IUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Mar 2020 04:20:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52296 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbgC2IUk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Mar 2020 04:20:40 -0400
Received: from [222.130.137.59] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <hui.wang@canonical.com>)
        id 1jITBM-0005M1-6d; Sun, 29 Mar 2020 08:20:37 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de, stable@vger.kernel.org,
        kailang@realtek.com
Subject: [PATCH v2] ALSA: hda/realtek - a fake key event is triggered by running shutup
Date:   Sun, 29 Mar 2020 16:20:18 +0800
Message-Id: <20200329082018.20486-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On the Lenovo X1C7 machines, after we plug the headset, the rt_resume()
and rt_suspend() of the codec driver will be called periodically, the
driver can't stay in the rt_suspend state even users doen't use the
sound card.

Through debugging, I found  when running rt_suspend(), it will call
alc225_shutup(), in this function, it will change 3k pull down control
by alc_update_coef_idx(codec, 0x4a, 0, 3 << 10), this will trigger a
fake key event and that event will resume the codec, when codec
suspend agin, it will trigger the fake key event one more time, this
process will repeat.

If disable the key event before changing the pull down control, it
will not trigger fake key event. It also needs to restore the pull
down control and re-enable the key event, otherwise the system can't
get key event when codec is in rt_suspend state.

Also move some functions ahead of alc225_shutup(), this can save the
function declaration.

Fixes: 76f7dec08fd6 (ALSA: hda/realtek - Add Headset Button supported for ThinkPad X1)
Cc: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 170 +++++++++++++++++++++-------------
 1 file changed, 107 insertions(+), 63 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 1ad8c2e2d1af..0af33f00617a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -107,6 +107,7 @@ struct alc_spec {
 	unsigned int done_hp_init:1;
 	unsigned int no_shutup_pins:1;
 	unsigned int ultra_low_power:1;
+	unsigned int has_hs_key:1;
 
 	/* for PLL fix */
 	hda_nid_t pll_nid;
@@ -2982,6 +2983,107 @@ static int alc269_parse_auto_config(struct hda_codec *codec)
 	return alc_parse_auto_config(codec, alc269_ignore, ssids);
 }
 
+static const struct hda_jack_keymap alc_headset_btn_keymap[] = {
+	{ SND_JACK_BTN_0, KEY_PLAYPAUSE },
+	{ SND_JACK_BTN_1, KEY_VOICECOMMAND },
+	{ SND_JACK_BTN_2, KEY_VOLUMEUP },
+	{ SND_JACK_BTN_3, KEY_VOLUMEDOWN },
+	{}
+};
+
+static void alc_headset_btn_callback(struct hda_codec *codec,
+				     struct hda_jack_callback *jack)
+{
+	int report = 0;
+
+	if (jack->unsol_res & (7 << 13))
+		report |= SND_JACK_BTN_0;
+
+	if (jack->unsol_res  & (1 << 16 | 3 << 8))
+		report |= SND_JACK_BTN_1;
+
+	/* Volume up key */
+	if (jack->unsol_res & (7 << 23))
+		report |= SND_JACK_BTN_2;
+
+	/* Volume down key */
+	if (jack->unsol_res & (7 << 10))
+		report |= SND_JACK_BTN_3;
+
+	jack->jack->button_state = report;
+}
+
+static void alc_disable_headset_jack_key(struct hda_codec *codec)
+{
+	struct alc_spec *spec = codec->spec;
+
+	if (!spec->has_hs_key)
+		return;
+
+	switch (codec->core.vendor_id) {
+	case 0x10ec0215:
+	case 0x10ec0225:
+	case 0x10ec0285:
+	case 0x10ec0295:
+	case 0x10ec0289:
+	case 0x10ec0299:
+		alc_write_coef_idx(codec, 0x48, 0x0);
+		alc_update_coef_idx(codec, 0x49, 0x0045, 0x0);
+		alc_update_coef_idx(codec, 0x44, 0x0045 << 8, 0x0);
+		break;
+	case 0x10ec0236:
+	case 0x10ec0256:
+		alc_write_coef_idx(codec, 0x48, 0x0);
+		alc_update_coef_idx(codec, 0x49, 0x0045, 0x0);
+		break;
+	}
+}
+
+static void alc_enable_headset_jack_key(struct hda_codec *codec)
+{
+	struct alc_spec *spec = codec->spec;
+
+	if (!spec->has_hs_key)
+		return;
+
+	switch (codec->core.vendor_id) {
+	case 0x10ec0215:
+	case 0x10ec0225:
+	case 0x10ec0285:
+	case 0x10ec0295:
+	case 0x10ec0289:
+	case 0x10ec0299:
+		alc_write_coef_idx(codec, 0x48, 0xd011);
+		alc_update_coef_idx(codec, 0x49, 0x007f, 0x0045);
+		alc_update_coef_idx(codec, 0x44, 0x007f << 8, 0x0045 << 8);
+		break;
+	case 0x10ec0236:
+	case 0x10ec0256:
+		alc_write_coef_idx(codec, 0x48, 0xd011);
+		alc_update_coef_idx(codec, 0x49, 0x007f, 0x0045);
+		break;
+	}
+}
+
+static void alc_fixup_headset_jack(struct hda_codec *codec,
+				    const struct hda_fixup *fix, int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	switch (action) {
+	case HDA_FIXUP_ACT_PRE_PROBE:
+		spec->has_hs_key = 1;
+		snd_hda_jack_detect_enable_callback(codec, 0x55,
+						    alc_headset_btn_callback);
+		snd_hda_jack_add_kctl(codec, 0x55, "Headset Jack", false,
+				      SND_JACK_HEADSET, alc_headset_btn_keymap);
+		break;
+	case HDA_FIXUP_ACT_INIT:
+		alc_enable_headset_jack_key(codec);
+		break;
+	}
+}
+
 static void alc269vb_toggle_power_output(struct hda_codec *codec, int power_up)
 {
 	alc_update_coef_idx(codec, 0x04, 1 << 11, power_up ? (1 << 11) : 0);
@@ -3372,6 +3474,8 @@ static void alc225_shutup(struct hda_codec *codec)
 
 	if (!hp_pin)
 		hp_pin = 0x21;
+
+	alc_disable_headset_jack_key(codec);
 	/* 3k pull low control for Headset jack. */
 	alc_update_coef_idx(codec, 0x4a, 0, 3 << 10);
 
@@ -3411,6 +3515,9 @@ static void alc225_shutup(struct hda_codec *codec)
 		alc_update_coef_idx(codec, 0x4a, 3<<4, 2<<4);
 		msleep(30);
 	}
+
+	alc_update_coef_idx(codec, 0x4a, 3 << 10, 0);
+	alc_enable_headset_jack_key(codec);
 }
 
 static void alc_default_init(struct hda_codec *codec)
@@ -5668,69 +5775,6 @@ static void alc285_fixup_invalidate_dacs(struct hda_codec *codec,
 	snd_hda_override_wcaps(codec, 0x03, 0);
 }
 
-static const struct hda_jack_keymap alc_headset_btn_keymap[] = {
-	{ SND_JACK_BTN_0, KEY_PLAYPAUSE },
-	{ SND_JACK_BTN_1, KEY_VOICECOMMAND },
-	{ SND_JACK_BTN_2, KEY_VOLUMEUP },
-	{ SND_JACK_BTN_3, KEY_VOLUMEDOWN },
-	{}
-};
-
-static void alc_headset_btn_callback(struct hda_codec *codec,
-				     struct hda_jack_callback *jack)
-{
-	int report = 0;
-
-	if (jack->unsol_res & (7 << 13))
-		report |= SND_JACK_BTN_0;
-
-	if (jack->unsol_res  & (1 << 16 | 3 << 8))
-		report |= SND_JACK_BTN_1;
-
-	/* Volume up key */
-	if (jack->unsol_res & (7 << 23))
-		report |= SND_JACK_BTN_2;
-
-	/* Volume down key */
-	if (jack->unsol_res & (7 << 10))
-		report |= SND_JACK_BTN_3;
-
-	jack->jack->button_state = report;
-}
-
-static void alc_fixup_headset_jack(struct hda_codec *codec,
-				    const struct hda_fixup *fix, int action)
-{
-
-	switch (action) {
-	case HDA_FIXUP_ACT_PRE_PROBE:
-		snd_hda_jack_detect_enable_callback(codec, 0x55,
-						    alc_headset_btn_callback);
-		snd_hda_jack_add_kctl(codec, 0x55, "Headset Jack", false,
-				      SND_JACK_HEADSET, alc_headset_btn_keymap);
-		break;
-	case HDA_FIXUP_ACT_INIT:
-		switch (codec->core.vendor_id) {
-		case 0x10ec0215:
-		case 0x10ec0225:
-		case 0x10ec0285:
-		case 0x10ec0295:
-		case 0x10ec0289:
-		case 0x10ec0299:
-			alc_write_coef_idx(codec, 0x48, 0xd011);
-			alc_update_coef_idx(codec, 0x49, 0x007f, 0x0045);
-			alc_update_coef_idx(codec, 0x44, 0x007f << 8, 0x0045 << 8);
-			break;
-		case 0x10ec0236:
-		case 0x10ec0256:
-			alc_write_coef_idx(codec, 0x48, 0xd011);
-			alc_update_coef_idx(codec, 0x49, 0x007f, 0x0045);
-			break;
-		}
-		break;
-	}
-}
-
 static void alc295_fixup_chromebook(struct hda_codec *codec,
 				    const struct hda_fixup *fix, int action)
 {
-- 
2.17.1

