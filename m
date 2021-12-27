Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7EF47FC1E
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 12:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236312AbhL0LRa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 06:17:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233404AbhL0LRa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 06:17:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF48C06173E
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 03:17:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F183EB808C2
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 11:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44990C36AEA;
        Mon, 27 Dec 2021 11:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640603847;
        bh=EVXaLu9HaY7C0R55MvW/6fCp4/7aAJmixWE1Tk6ewpA=;
        h=Subject:To:Cc:From:Date:From;
        b=E50sG2oLR3WSr7GkhRxLQA+5x8bFM7LOie4Er+/qIEmlu/DoajbTkHpRzRzL//PmU
         Jsiut9WgVWDJ91sXlkAYrXF62iO2UAWJmhjBS6bABDf0eo4unNZ26+6obXLHgumZrQ
         Gw5eJ8cMMFKha1eqKn/rNPZDsSln+xXRPHfwn3L8=
Subject: FAILED: patch "[PATCH] ALSA: hda/realtek: Fix quirk for Clevo NJ51CU" failed to apply to 4.19-stable tree
To:     wse@tuxedocomputers.com, stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Dec 2021 12:17:25 +0100
Message-ID: <1640603845244153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From edca7cc4b0accfa69dc032442fe0684e59c691b8 Mon Sep 17 00:00:00 2001
From: Werner Sembach <wse@tuxedocomputers.com>
Date: Wed, 15 Dec 2021 20:16:46 +0100
Subject: [PATCH] ALSA: hda/realtek: Fix quirk for Clevo NJ51CU

The Clevo NJ51CU comes either with the ALC293 or the ALC256 codec, but uses
the 0x8686 subproduct id in both cases. The ALC256 codec needs a different
quirk for the headset microphone working and and edditional quirk for sound
working after suspend and resume.

When waking up from s3 suspend the Coef 0x10 is set to 0x0220 instead of
0x0020 on  the ALC256 codec. Setting the value manually makes the sound
work again. This patch does this automatically.

[ minor coding style fix by tiwai ]

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Fixes: b5acfe152abaa ("ALSA: hda/realtek: Add some Clove SSID in the ALC293(ALC1220)")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211215191646.844644-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index e59ff75eea75..28255e752c4a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6546,6 +6546,23 @@ static void alc233_fixup_no_audio_jack(struct hda_codec *codec,
 	alc_process_coef_fw(codec, alc233_fixup_no_audio_jack_coefs);
 }
 
+static void alc256_fixup_mic_no_presence_and_resume(struct hda_codec *codec,
+						    const struct hda_fixup *fix,
+						    int action)
+{
+	/*
+	 * The Clevo NJ51CU comes either with the ALC293 or the ALC256 codec,
+	 * but uses the 0x8686 subproduct id in both cases. The ALC256 codec
+	 * needs an additional quirk for sound working after suspend and resume.
+	 */
+	if (codec->core.vendor_id == 0x10ec0256) {
+		alc_update_coef_idx(codec, 0x10, 1<<9, 0);
+		snd_hda_codec_set_pincfg(codec, 0x19, 0x04a11120);
+	} else {
+		snd_hda_codec_set_pincfg(codec, 0x1a, 0x04a1113c);
+	}
+}
+
 enum {
 	ALC269_FIXUP_GPIO2,
 	ALC269_FIXUP_SONY_VAIO,
@@ -6766,6 +6783,7 @@ enum {
 	ALC256_FIXUP_SET_COEF_DEFAULTS,
 	ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE,
 	ALC233_FIXUP_NO_AUDIO_JACK,
+	ALC256_FIXUP_MIC_NO_PRESENCE_AND_RESUME,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -8490,6 +8508,12 @@ static const struct hda_fixup alc269_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc233_fixup_no_audio_jack,
 	},
+	[ALC256_FIXUP_MIC_NO_PRESENCE_AND_RESUME] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc256_fixup_mic_no_presence_and_resume,
+		.chained = true,
+		.chain_id = ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -8831,7 +8855,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x8562, "Clevo NH[57][0-9]RZ[Q]", ALC269_FIXUP_DMIC),
 	SND_PCI_QUIRK(0x1558, 0x8668, "Clevo NP50B[BE]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8680, "Clevo NJ50LU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
-	SND_PCI_QUIRK(0x1558, 0x8686, "Clevo NH50[CZ]U", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x8686, "Clevo NH50[CZ]U", ALC256_FIXUP_MIC_NO_PRESENCE_AND_RESUME),
 	SND_PCI_QUIRK(0x1558, 0x8a20, "Clevo NH55DCQ-Y", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8a51, "Clevo NH70RCQ-Y", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8d50, "Clevo NH55RCQ-M", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),

