Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0057047297F
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245445AbhLMKVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241338AbhLMKTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:19:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E292C07E5E8;
        Mon, 13 Dec 2021 01:57:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D93FFB80E3B;
        Mon, 13 Dec 2021 09:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0403EC34602;
        Mon, 13 Dec 2021 09:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389448;
        bh=WSBMlSj3netYVws4JHsCVsVxkph0WtAYIZlKgy23Xbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NLb/vmb9SEGispZhPaRo2WJjL4IcsTnlEsT+7mKfXsPPqTZHAw2Eye0v2Nx4fUdGG
         Y5o0En+Uk8XqjN98KYWNffHbQRK8nwnIAPQXQgh+7Rpg3iIrN0X/RTuCUbB/u1oQ16
         wafRZmtEuVgxnbxuFFqZ+wpAqsW4P+X0VAozD5cg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Werner Sembach <wse@tuxedocomputers.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 066/171] ALSA: hda/realtek: Fix quirk for TongFang PHxTxX1
Date:   Mon, 13 Dec 2021 10:29:41 +0100
Message-Id: <20211213092947.299796514@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Werner Sembach <wse@tuxedocomputers.com>

commit 619764cc2ec9ce1283a8bbcd89a1376a7c68293b upstream.

This fixes the SND_PCI_QUIRK(...) of the TongFang PHxTxX1 barebone. This
fixes the issue of sound not working after s3 suspend.

When waking up from s3 suspend the Coef 0x10 is set to 0x0220 instead of
0x0020. Setting the value manually makes the sound work again. This patch
does this automatically.

While being on it, I also fixed the comment formatting of the quirk and
shortened variable and function names.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Fixes: dd6dd6e3c791 ("ALSA: hda/realtek: Add quirk for TongFang PHxTxX1")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211202165010.876431-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6503,22 +6503,26 @@ static void alc287_fixup_legion_15imhg05
 /* for alc285_fixup_ideapad_s740_coef() */
 #include "ideapad_s740_helper.c"
 
-static void alc256_fixup_tongfang_reset_persistent_settings(struct hda_codec *codec,
-							    const struct hda_fixup *fix,
-							    int action)
+static const struct coef_fw alc256_fixup_set_coef_defaults_coefs[] = {
+	WRITE_COEF(0x10, 0x0020), WRITE_COEF(0x24, 0x0000),
+	WRITE_COEF(0x26, 0x0000), WRITE_COEF(0x29, 0x3000),
+	WRITE_COEF(0x37, 0xfe05), WRITE_COEF(0x45, 0x5089),
+	{}
+};
+
+static void alc256_fixup_set_coef_defaults(struct hda_codec *codec,
+					   const struct hda_fixup *fix,
+					   int action)
 {
 	/*
-	* A certain other OS sets these coeffs to different values. On at least one TongFang
-	* barebone these settings might survive even a cold reboot. So to restore a clean slate the
-	* values are explicitly reset to default here. Without this, the external microphone is
-	* always in a plugged-in state, while the internal microphone is always in an unplugged
-	* state, breaking the ability to use the internal microphone.
-	*/
-	alc_write_coef_idx(codec, 0x24, 0x0000);
-	alc_write_coef_idx(codec, 0x26, 0x0000);
-	alc_write_coef_idx(codec, 0x29, 0x3000);
-	alc_write_coef_idx(codec, 0x37, 0xfe05);
-	alc_write_coef_idx(codec, 0x45, 0x5089);
+	 * A certain other OS sets these coeffs to different values. On at least
+	 * one TongFang barebone these settings might survive even a cold
+	 * reboot. So to restore a clean slate the values are explicitly reset
+	 * to default here. Without this, the external microphone is always in a
+	 * plugged-in state, while the internal microphone is always in an
+	 * unplugged state, breaking the ability to use the internal microphone.
+	 */
+	alc_process_coef_fw(codec, alc256_fixup_set_coef_defaults_coefs);
 }
 
 static const struct coef_fw alc233_fixup_no_audio_jack_coefs[] = {
@@ -6759,7 +6763,7 @@ enum {
 	ALC287_FIXUP_LEGION_15IMHG05_AUTOMUTE,
 	ALC287_FIXUP_YOGA7_14ITL_SPEAKERS,
 	ALC287_FIXUP_13S_GEN2_SPEAKERS,
-	ALC256_FIXUP_TONGFANG_RESET_PERSISTENT_SETTINGS,
+	ALC256_FIXUP_SET_COEF_DEFAULTS,
 	ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE,
 	ALC233_FIXUP_NO_AUDIO_JACK,
 };
@@ -8465,9 +8469,9 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC269_FIXUP_HEADSET_MODE,
 	},
-	[ALC256_FIXUP_TONGFANG_RESET_PERSISTENT_SETTINGS] = {
+	[ALC256_FIXUP_SET_COEF_DEFAULTS] = {
 		.type = HDA_FIXUP_FUNC,
-		.v.func = alc256_fixup_tongfang_reset_persistent_settings,
+		.v.func = alc256_fixup_set_coef_defaults,
 	},
 	[ALC245_FIXUP_HP_GPIO_LED] = {
 		.type = HDA_FIXUP_FUNC,
@@ -8929,7 +8933,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1b7d, 0xa831, "Ordissimo EVE2 ", ALC269VB_FIXUP_ORDISSIMO_EVE2), /* Also known as Malata PC-B1303 */
 	SND_PCI_QUIRK(0x1c06, 0x2013, "Lemote A1802", ALC269_FIXUP_LEMOTE_A1802),
 	SND_PCI_QUIRK(0x1c06, 0x2015, "Lemote A190X", ALC269_FIXUP_LEMOTE_A190X),
-	SND_PCI_QUIRK(0x1d05, 0x1132, "TongFang PHxTxX1", ALC256_FIXUP_TONGFANG_RESET_PERSISTENT_SETTINGS),
+	SND_PCI_QUIRK(0x1d05, 0x1132, "TongFang PHxTxX1", ALC256_FIXUP_SET_COEF_DEFAULTS),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1d72, 0x1901, "RedmiBook 14", ALC256_FIXUP_ASUS_HEADSET_MIC),


