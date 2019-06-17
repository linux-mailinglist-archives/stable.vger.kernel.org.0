Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25B30492D2
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbfFQVYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:24:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729215AbfFQVYO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:24:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F537206B7;
        Mon, 17 Jun 2019 21:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806653;
        bh=o3Gps6GCtngjv27MZM1x49qPFP+F9vBpgRLnHVdiYWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pkkc82RrWjQCrfXDj2rxZfBiIx4sEMFK4Cmi/BWmio3w3oeh/bku4alqIpSmDPupH
         1DXqhLgzx2iY5i1kGduCoPjBJMqIctvzGiAvwoVWveFews3LW/bG0nUJPMIIDSTECI
         KiI+lRShxNfEC+/PzMsYREWA6uGNfSmzH252tTY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 11/75] ALSA: hda/realtek - Update headset mode for ALC256
Date:   Mon, 17 Jun 2019 23:09:22 +0200
Message-Id: <20190617210753.299639843@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit 717f43d81afc1250300479075952a0e36d74ded3 upstream.

ALC255 and ALC256 were some difference for hidden register.
This update was suitable for ALC256.

Fixes: e69e7e03ed22 ("ALSA: hda/realtek - ALC256 speaker noise issue")
Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   75 +++++++++++++++++++++++++++++++++---------
 1 file changed, 60 insertions(+), 15 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4082,18 +4082,19 @@ static struct coef_fw alc225_pre_hsmode[
 static void alc_headset_mode_unplugged(struct hda_codec *codec)
 {
 	static struct coef_fw coef0255[] = {
+		WRITE_COEF(0x1b, 0x0c0b), /* LDO and MISC control */
 		WRITE_COEF(0x45, 0xd089), /* UAJ function set to menual mode */
 		UPDATE_COEFEX(0x57, 0x05, 1<<14, 0), /* Direct Drive HP Amp control(Set to verb control)*/
 		WRITE_COEF(0x06, 0x6104), /* Set MIC2 Vref gate with HP */
 		WRITE_COEFEX(0x57, 0x03, 0x8aa6), /* Direct Drive HP Amp control */
 		{}
 	};
-	static struct coef_fw coef0255_1[] = {
-		WRITE_COEF(0x1b, 0x0c0b), /* LDO and MISC control */
-		{}
-	};
 	static struct coef_fw coef0256[] = {
 		WRITE_COEF(0x1b, 0x0c4b), /* LDO and MISC control */
+		WRITE_COEF(0x45, 0xd089), /* UAJ function set to menual mode */
+		WRITE_COEF(0x06, 0x6104), /* Set MIC2 Vref gate with HP */
+		WRITE_COEFEX(0x57, 0x03, 0x09a3), /* Direct Drive HP Amp control */
+		UPDATE_COEFEX(0x57, 0x05, 1<<14, 0), /* Direct Drive HP Amp control(Set to verb control)*/
 		{}
 	};
 	static struct coef_fw coef0233[] = {
@@ -4156,13 +4157,11 @@ static void alc_headset_mode_unplugged(s
 
 	switch (codec->core.vendor_id) {
 	case 0x10ec0255:
-		alc_process_coef_fw(codec, coef0255_1);
 		alc_process_coef_fw(codec, coef0255);
 		break;
 	case 0x10ec0236:
 	case 0x10ec0256:
 		alc_process_coef_fw(codec, coef0256);
-		alc_process_coef_fw(codec, coef0255);
 		break;
 	case 0x10ec0234:
 	case 0x10ec0274:
@@ -4215,6 +4214,12 @@ static void alc_headset_mode_mic_in(stru
 		WRITE_COEF(0x06, 0x6100), /* Set MIC2 Vref gate to normal */
 		{}
 	};
+	static struct coef_fw coef0256[] = {
+		UPDATE_COEFEX(0x57, 0x05, 1<<14, 1<<14), /* Direct Drive HP Amp control(Set to verb control)*/
+		WRITE_COEFEX(0x57, 0x03, 0x09a3),
+		WRITE_COEF(0x06, 0x6100), /* Set MIC2 Vref gate to normal */
+		{}
+	};
 	static struct coef_fw coef0233[] = {
 		UPDATE_COEF(0x35, 0, 1<<14),
 		WRITE_COEF(0x06, 0x2100),
@@ -4262,14 +4267,19 @@ static void alc_headset_mode_mic_in(stru
 	};
 
 	switch (codec->core.vendor_id) {
-	case 0x10ec0236:
 	case 0x10ec0255:
-	case 0x10ec0256:
 		alc_write_coef_idx(codec, 0x45, 0xc489);
 		snd_hda_set_pin_ctl_cache(codec, hp_pin, 0);
 		alc_process_coef_fw(codec, coef0255);
 		snd_hda_set_pin_ctl_cache(codec, mic_pin, PIN_VREF50);
 		break;
+	case 0x10ec0236:
+	case 0x10ec0256:
+		alc_write_coef_idx(codec, 0x45, 0xc489);
+		snd_hda_set_pin_ctl_cache(codec, hp_pin, 0);
+		alc_process_coef_fw(codec, coef0256);
+		snd_hda_set_pin_ctl_cache(codec, mic_pin, PIN_VREF50);
+		break;
 	case 0x10ec0234:
 	case 0x10ec0274:
 	case 0x10ec0294:
@@ -4351,6 +4361,14 @@ static void alc_headset_mode_default(str
 		WRITE_COEF(0x49, 0x0049),
 		{}
 	};
+	static struct coef_fw coef0256[] = {
+		WRITE_COEF(0x45, 0xc489),
+		WRITE_COEFEX(0x57, 0x03, 0x0da3),
+		WRITE_COEF(0x49, 0x0049),
+		UPDATE_COEFEX(0x57, 0x05, 1<<14, 0), /* Direct Drive HP Amp control(Set to verb control)*/
+		WRITE_COEF(0x06, 0x6100),
+		{}
+	};
 	static struct coef_fw coef0233[] = {
 		WRITE_COEF(0x06, 0x2100),
 		WRITE_COEF(0x32, 0x4ea3),
@@ -4401,11 +4419,16 @@ static void alc_headset_mode_default(str
 		alc_process_coef_fw(codec, alc225_pre_hsmode);
 		alc_process_coef_fw(codec, coef0225);
 		break;
-	case 0x10ec0236:
 	case 0x10ec0255:
-	case 0x10ec0256:
 		alc_process_coef_fw(codec, coef0255);
 		break;
+	case 0x10ec0236:
+	case 0x10ec0256:
+		alc_write_coef_idx(codec, 0x1b, 0x0e4b);
+		alc_write_coef_idx(codec, 0x45, 0xc089);
+		msleep(50);
+		alc_process_coef_fw(codec, coef0256);
+		break;
 	case 0x10ec0234:
 	case 0x10ec0274:
 	case 0x10ec0294:
@@ -4449,8 +4472,7 @@ static void alc_headset_mode_ctia(struct
 	};
 	static struct coef_fw coef0256[] = {
 		WRITE_COEF(0x45, 0xd489), /* Set to CTIA type */
-		WRITE_COEF(0x1b, 0x0c6b),
-		WRITE_COEFEX(0x57, 0x03, 0x8ea6),
+		WRITE_COEF(0x1b, 0x0e6b),
 		{}
 	};
 	static struct coef_fw coef0233[] = {
@@ -4568,8 +4590,7 @@ static void alc_headset_mode_omtp(struct
 	};
 	static struct coef_fw coef0256[] = {
 		WRITE_COEF(0x45, 0xe489), /* Set to OMTP Type */
-		WRITE_COEF(0x1b, 0x0c6b),
-		WRITE_COEFEX(0x57, 0x03, 0x8ea6),
+		WRITE_COEF(0x1b, 0x0e6b),
 		{}
 	};
 	static struct coef_fw coef0233[] = {
@@ -4701,13 +4722,37 @@ static void alc_determine_headset_type(s
 	};
 
 	switch (codec->core.vendor_id) {
-	case 0x10ec0236:
 	case 0x10ec0255:
+		alc_process_coef_fw(codec, coef0255);
+		msleep(300);
+		val = alc_read_coef_idx(codec, 0x46);
+		is_ctia = (val & 0x0070) == 0x0070;
+		break;
+	case 0x10ec0236:
 	case 0x10ec0256:
+		alc_write_coef_idx(codec, 0x1b, 0x0e4b);
+		alc_write_coef_idx(codec, 0x06, 0x6104);
+		alc_write_coefex_idx(codec, 0x57, 0x3, 0x09a3);
+
+		snd_hda_codec_write(codec, 0x21, 0,
+			    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE);
+		msleep(80);
+		snd_hda_codec_write(codec, 0x21, 0,
+			    AC_VERB_SET_PIN_WIDGET_CONTROL, 0x0);
+
 		alc_process_coef_fw(codec, coef0255);
 		msleep(300);
 		val = alc_read_coef_idx(codec, 0x46);
 		is_ctia = (val & 0x0070) == 0x0070;
+
+		alc_write_coefex_idx(codec, 0x57, 0x3, 0x0da3);
+		alc_update_coefex_idx(codec, 0x57, 0x5, 1<<14, 0);
+
+		snd_hda_codec_write(codec, 0x21, 0,
+			    AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT);
+		msleep(80);
+		snd_hda_codec_write(codec, 0x21, 0,
+			    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE);
 		break;
 	case 0x10ec0234:
 	case 0x10ec0274:


