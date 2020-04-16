Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A49E1AC425
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409113AbgDPNzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:55:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409086AbgDPNzB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:55:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEA4E20732;
        Thu, 16 Apr 2020 13:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045300;
        bh=QacHWWHP2ypjKPjprKD6bhOij6cFw/F0WEMxr8v+1t4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zWg5XFU2AJiDxqFRnRUJTN4o4cIAs9Tn/nAec8WwqWpB+N/y9ma7AaJhidT1spUus
         KWSdGqgSDMkOH6Mxnj8sYzEDhOIYK/1kjvJ5uAn88eaEa+8KlWgmtG6dA+I/FqoqUr
         jRfQOWyX8DNVhQQPDXMDszWjgalc0yooyAJarXYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Hui Wang <hui.wang@canonical.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.6 078/254] ALSA: hda/realtek - a fake key event is triggered by running shutup
Date:   Thu, 16 Apr 2020 15:22:47 +0200
Message-Id: <20200416131335.630555331@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit 476c02e0b4fd9071d158f6a1a1dfea1d36ee0ffd upstream.

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
Link: https://lore.kernel.org/r/20200329082018.20486-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |  170 ++++++++++++++++++++++++++----------------
 1 file changed, 107 insertions(+), 63 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -107,6 +107,7 @@ struct alc_spec {
 	unsigned int done_hp_init:1;
 	unsigned int no_shutup_pins:1;
 	unsigned int ultra_low_power:1;
+	unsigned int has_hs_key:1;
 
 	/* for PLL fix */
 	hda_nid_t pll_nid;
@@ -2982,6 +2983,107 @@ static int alc269_parse_auto_config(stru
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
@@ -3372,6 +3474,8 @@ static void alc225_shutup(struct hda_cod
 
 	if (!hp_pin)
 		hp_pin = 0x21;
+
+	alc_disable_headset_jack_key(codec);
 	/* 3k pull low control for Headset jack. */
 	alc_update_coef_idx(codec, 0x4a, 0, 3 << 10);
 
@@ -3411,6 +3515,9 @@ static void alc225_shutup(struct hda_cod
 		alc_update_coef_idx(codec, 0x4a, 3<<4, 2<<4);
 		msleep(30);
 	}
+
+	alc_update_coef_idx(codec, 0x4a, 3 << 10, 0);
+	alc_enable_headset_jack_key(codec);
 }
 
 static void alc_default_init(struct hda_codec *codec)
@@ -5668,69 +5775,6 @@ static void alc285_fixup_invalidate_dacs
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


