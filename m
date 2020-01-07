Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D19B013349E
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbgAGU6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:58:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:57052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727794AbgAGU6O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:58:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 104142081E;
        Tue,  7 Jan 2020 20:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430693;
        bh=a5JwpBB9jVORplUE4Cl0WF9azzaKIEA4qQ7p37Bo/WU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l6TkUdVmWA4Nf643Rs6OFaCKfgGMJZUtDHVlkJKmPD2mbnAkKahp2o4ZU5ng6+blV
         JKMIjK+heGq2USjYogSsy9eH4/UndpJR8PlUbmI9FXnHWqGiRVXEQFzKAhd4oSCBlc
         yKCvYYOxWiTXFjgikDfeuteazYdw/atr6gjoSRPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 058/191] ALSA: hda - fixup for the bass speaker on Lenovo Carbon X1 7th gen
Date:   Tue,  7 Jan 2020 21:52:58 +0100
Message-Id: <20200107205336.102253423@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaroslav Kysela <perex@perex.cz>

[ Upstream commit d2cd795c4ece1a24fda170c35eeb4f17d9826cbb ]

The auto-parser assigns the bass speaker to DAC3 (NID 0x06) which
is without the volume control. I do not see a reason to use DAC2,
because the shared output to all speakers produces the sufficient
and well balanced sound. The stereo support is enough for this
purpose (laptop).

Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20191129144027.14765-1-perex@perex.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index e849cf681e23..62a471b5fc87 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5547,6 +5547,16 @@ static void alc295_fixup_disable_dac3(struct hda_codec *codec,
 	}
 }
 
+/* force NID 0x17 (Bass Speaker) to DAC1 to share it with the main speaker */
+static void alc285_fixup_speaker2_to_dac1(struct hda_codec *codec,
+					  const struct hda_fixup *fix, int action)
+{
+	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
+		hda_nid_t conn[1] = { 0x02 };
+		snd_hda_override_conn_list(codec, 0x17, 1, conn);
+	}
+}
+
 /* Hook to update amp GPIO4 for automute */
 static void alc280_hp_gpio4_automute_hook(struct hda_codec *codec,
 					  struct hda_jack_callback *jack)
@@ -5849,6 +5859,7 @@ enum {
 	ALC225_FIXUP_DISABLE_MIC_VREF,
 	ALC225_FIXUP_DELL1_MIC_NO_PRESENCE,
 	ALC295_FIXUP_DISABLE_DAC3,
+	ALC285_FIXUP_SPEAKER2_TO_DAC1,
 	ALC280_FIXUP_HP_HEADSET_MIC,
 	ALC221_FIXUP_HP_FRONT_MIC,
 	ALC292_FIXUP_TPT460,
@@ -6652,6 +6663,10 @@ static const struct hda_fixup alc269_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc295_fixup_disable_dac3,
 	},
+	[ALC285_FIXUP_SPEAKER2_TO_DAC1] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc285_fixup_speaker2_to_dac1,
+	},
 	[ALC256_FIXUP_DELL_INSPIRON_7559_SUBWOOFER] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -7241,6 +7256,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x224c, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x224d, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x225d, "Thinkpad T480", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
+	SND_PCI_QUIRK(0x17aa, 0x2293, "Thinkpad X1 Carbon 7th", ALC285_FIXUP_SPEAKER2_TO_DAC1),
 	SND_PCI_QUIRK(0x17aa, 0x30bb, "ThinkCentre AIO", ALC233_FIXUP_LENOVO_LINE2_MIC_HOTKEY),
 	SND_PCI_QUIRK(0x17aa, 0x30e2, "ThinkCentre AIO", ALC233_FIXUP_LENOVO_LINE2_MIC_HOTKEY),
 	SND_PCI_QUIRK(0x17aa, 0x310c, "ThinkCentre Station", ALC294_FIXUP_LENOVO_MIC_LOCATION),
@@ -7425,6 +7441,7 @@ static const struct hda_model_fixup alc269_fixup_models[] = {
 	{.id = ALC255_FIXUP_DELL_SPK_NOISE, .name = "dell-spk-noise"},
 	{.id = ALC225_FIXUP_DELL1_MIC_NO_PRESENCE, .name = "alc225-dell1"},
 	{.id = ALC295_FIXUP_DISABLE_DAC3, .name = "alc295-disable-dac3"},
+	{.id = ALC285_FIXUP_SPEAKER2_TO_DAC1, .name = "alc285-speaker2-to-dac1"},
 	{.id = ALC280_FIXUP_HP_HEADSET_MIC, .name = "alc280-hp-headset"},
 	{.id = ALC221_FIXUP_HP_FRONT_MIC, .name = "alc221-hp-mic"},
 	{.id = ALC298_FIXUP_SPK_VOLUME, .name = "alc298-spk-volume"},
-- 
2.20.1



