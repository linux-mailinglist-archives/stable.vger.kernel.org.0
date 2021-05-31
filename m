Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9FD3960EA
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbhEaOdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:33:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233302AbhEaObH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:31:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C6EF6142C;
        Mon, 31 May 2021 13:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468940;
        bh=LIeUETAqjCaD7D1hU95MpgwlUM7UXyBG0fj42aJQ5Gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uaN02PfLr6m1/fBqrLsv67a1SvJpx8wO+OEzBDXxMNKO1P3/nDfAgvk8NNDqew+6Y
         QuE4+oiBfQmy2xBTM40Rt6AAGTfhuWtKh3eHixMC42yx2EZAgmSQXiaDsw0pUh5eOF
         EIwoU1Lv7dLhZrXWkddoGi/ASYMBKtGDIL0pPvdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.12 001/296] ALSA: hda/realtek: the bass speaker cant output sound on Yoga 9i
Date:   Mon, 31 May 2021 15:10:56 +0200
Message-Id: <20210531130703.812185747@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit 9ebaef0540a981093bce5df15af32354d32391d9 upstream.

The Lenovo Yoga 9i has bass speaker, but the bass speaker can't work,
that is because there is an i2s amplifier on that speaker, need to
run ideapad_s740_coef() to initialize the amplifier.

And also needs to apply ALC285_FIXUP_THINKPAD_HEADSET_JACK to rename
the speaker's mixer control name, otherwise the PA can't handle them.

BugLink: http://bugs.launchpad.net/bugs/1926165
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210522042645.14221-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6535,6 +6535,7 @@ enum {
 	ALC295_FIXUP_ASUS_DACS,
 	ALC295_FIXUP_HP_OMEN,
 	ALC285_FIXUP_HP_SPECTRE_X360,
+	ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -8095,6 +8096,12 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC285_FIXUP_SPEAKER2_TO_DAC1,
 	},
+	[ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc285_fixup_ideapad_s740_coef,
+		.chained = true,
+		.chain_id = ALC285_FIXUP_THINKPAD_HEADSET_JACK,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -8462,6 +8469,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x3178, "ThinkCentre Station", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3818, "Lenovo C940", ALC298_FIXUP_LENOVO_SPK_VOLUME),
 	SND_PCI_QUIRK(0x17aa, 0x3827, "Ideapad S740", ALC285_FIXUP_IDEAPAD_S740_COEF),
+	SND_PCI_QUIRK(0x17aa, 0x3843, "Yoga 9i", ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP),
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x3977, "IdeaPad S210", ALC283_FIXUP_INT_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3978, "Lenovo B50-70", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
@@ -8677,6 +8685,7 @@ static const struct hda_model_fixup alc2
 	{.id = ALC245_FIXUP_HP_X360_AMP, .name = "alc245-hp-x360-amp"},
 	{.id = ALC295_FIXUP_HP_OMEN, .name = "alc295-hp-omen"},
 	{.id = ALC285_FIXUP_HP_SPECTRE_X360, .name = "alc285-hp-spectre-x360"},
+	{.id = ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP, .name = "alc287-ideapad-bass-spk-amp"},
 	{}
 };
 #define ALC225_STANDARD_PINS \


