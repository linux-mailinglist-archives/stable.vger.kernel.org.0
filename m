Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABCD4800DD
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239311AbhL0PvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbhL0Pra (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:47:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7938FC08EADB;
        Mon, 27 Dec 2021 07:43:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1946B610A3;
        Mon, 27 Dec 2021 15:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF910C36AEA;
        Mon, 27 Dec 2021 15:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619796;
        bh=QNddPiVulJZnH+TLfCJhU/0S1x0Uz8iQIPXfM0D1kq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xcbN1Gh11dYTTAgqmY6JWK6+9iDoHCDwusAzPLS+EFOzaz+zo4Sp8j8n0w+YBn0nL
         HBoQLK/aJJrrQjp4s5xByqUG5snrddgyHDmoOKgSgB0CFSfNbNqg5yIOgUCv6T7+p5
         zKEe6wEHLYzoA/ekqJUyfhSRubZPGqR5CUgHeIHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Werner Sembach <wse@tuxedocomputers.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 072/128] ALSA: hda/realtek: Fix quirk for Clevo NJ51CU
Date:   Mon, 27 Dec 2021 16:30:47 +0100
Message-Id: <20211227151333.897360825@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Werner Sembach <wse@tuxedocomputers.com>

commit edca7cc4b0accfa69dc032442fe0684e59c691b8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6546,6 +6546,23 @@ static void alc233_fixup_no_audio_jack(s
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
@@ -8490,6 +8508,12 @@ static const struct hda_fixup alc269_fix
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
@@ -8831,7 +8855,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1558, 0x8562, "Clevo NH[57][0-9]RZ[Q]", ALC269_FIXUP_DMIC),
 	SND_PCI_QUIRK(0x1558, 0x8668, "Clevo NP50B[BE]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8680, "Clevo NJ50LU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
-	SND_PCI_QUIRK(0x1558, 0x8686, "Clevo NH50[CZ]U", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x8686, "Clevo NH50[CZ]U", ALC256_FIXUP_MIC_NO_PRESENCE_AND_RESUME),
 	SND_PCI_QUIRK(0x1558, 0x8a20, "Clevo NH55DCQ-Y", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8a51, "Clevo NH70RCQ-Y", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8d50, "Clevo NH55RCQ-M", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),


