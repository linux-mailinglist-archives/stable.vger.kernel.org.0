Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E393823591
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730952AbfETMf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:35:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391174AbfETMfz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:35:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBAA2204FD;
        Mon, 20 May 2019 12:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355754;
        bh=MiMH7hyH2/SXYcicKGO2Aejx+dXIjKB+7Fpdd7mTGKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FyIlT6W+YkCdBp7BGNTnZY+J/MPa9u1j7nelrdt83g8xwUCtfkGJ9JHi/Ou/mBQMv
         PcrzNPgC7fZHs7Isyi0G5vlOGDjbG+y2uCGs3SCtpPKUE+I+Pfn5ZwpSr2CFYu6HDo
         cgCsJgDjNzdDIl0Pl2/sA1eIrbZf7Tlc4wvaji0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.1 112/128] ALSA: hda/realtek - Fixup headphone noise via runtime suspend
Date:   Mon, 20 May 2019 14:14:59 +0200
Message-Id: <20190520115256.477763402@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit dad3197da7a3817f27bb24f7fd3c135ffa707202 upstream.

Dell platform with ALC298.
system enter to runtime suspend. Headphone had noise.
Let Headset Mic not shutup will solve this issue.

[ Fixed minor coding style issues by tiwai ]

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   59 ++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 24 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -477,12 +477,45 @@ static void alc_auto_setup_eapd(struct h
 		set_eapd(codec, *p, on);
 }
 
+static int find_ext_mic_pin(struct hda_codec *codec);
+
+static void alc_headset_mic_no_shutup(struct hda_codec *codec)
+{
+	const struct hda_pincfg *pin;
+	int mic_pin = find_ext_mic_pin(codec);
+	int i;
+
+	/* don't shut up pins when unloading the driver; otherwise it breaks
+	 * the default pin setup at the next load of the driver
+	 */
+	if (codec->bus->shutdown)
+		return;
+
+	snd_array_for_each(&codec->init_pins, i, pin) {
+		/* use read here for syncing after issuing each verb */
+		if (pin->nid != mic_pin)
+			snd_hda_codec_read(codec, pin->nid, 0,
+					AC_VERB_SET_PIN_WIDGET_CONTROL, 0);
+	}
+
+	codec->pins_shutup = 1;
+}
+
 static void alc_shutup_pins(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
 
-	if (!spec->no_shutup_pins)
-		snd_hda_shutup_pins(codec);
+	switch (codec->core.vendor_id) {
+	case 0x10ec0286:
+	case 0x10ec0288:
+	case 0x10ec0298:
+		alc_headset_mic_no_shutup(codec);
+		break;
+	default:
+		if (!spec->no_shutup_pins)
+			snd_hda_shutup_pins(codec);
+		break;
+	}
 }
 
 /* generic shutup callback;
@@ -2923,27 +2956,6 @@ static int alc269_parse_auto_config(stru
 	return alc_parse_auto_config(codec, alc269_ignore, ssids);
 }
 
-static int find_ext_mic_pin(struct hda_codec *codec);
-
-static void alc286_shutup(struct hda_codec *codec)
-{
-	const struct hda_pincfg *pin;
-	int i;
-	int mic_pin = find_ext_mic_pin(codec);
-	/* don't shut up pins when unloading the driver; otherwise it breaks
-	 * the default pin setup at the next load of the driver
-	 */
-	if (codec->bus->shutdown)
-		return;
-	snd_array_for_each(&codec->init_pins, i, pin) {
-		/* use read here for syncing after issuing each verb */
-		if (pin->nid != mic_pin)
-			snd_hda_codec_read(codec, pin->nid, 0,
-					AC_VERB_SET_PIN_WIDGET_CONTROL, 0);
-	}
-	codec->pins_shutup = 1;
-}
-
 static void alc269vb_toggle_power_output(struct hda_codec *codec, int power_up)
 {
 	alc_update_coef_idx(codec, 0x04, 1 << 11, power_up ? (1 << 11) : 0);
@@ -7707,7 +7719,6 @@ static int patch_alc269(struct hda_codec
 	case 0x10ec0286:
 	case 0x10ec0288:
 		spec->codec_variant = ALC269_TYPE_ALC286;
-		spec->shutup = alc286_shutup;
 		break;
 	case 0x10ec0298:
 		spec->codec_variant = ALC269_TYPE_ALC298;


