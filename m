Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A860C38EE62
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233221AbhEXPug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:50:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234480AbhEXPrP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:47:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F26B461418;
        Mon, 24 May 2021 15:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870621;
        bh=V0C9B+zUpn1072ephJd2FbH9OGcdlVz8QySBhr+jhJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZmU3qJwaYmMQGWLh0Dbdou2J6rg3qeLUn5mcDzG00qyo08ROOn08QxumpkCYJu5n3
         GjdTAR5Z9zbd886fac2570NkcjqCGYo98CUkWggDXVF0Z+Z3j29JmYND4PMWJFpwPt
         DbhHP7luMUCziyda1q4Sj2ou8YEJToH/fZn3KIfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 30/71] ALSA: hda/realtek: Fix silent headphone output on ASUS UX430UA
Date:   Mon, 24 May 2021 17:25:36 +0200
Message-Id: <20210524152327.436903747@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152326.447759938@linuxfoundation.org>
References: <20210524152326.447759938@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 8eedd3a70a70f51fa963f3ad7fa97afd0c75bd44 upstream.

It was reported that the headphone output on ASUS UX430UA (SSID
1043:1740) with ALC295 codec is silent while the speaker works.
After the investigation, it turned out that the DAC assignment has to
be fixed on this machine; unlike others, it expects DAC 0x02 to be
assigned to the speaker pin 0x07 while DAC 0x03 to headphone pin
0x21.

This patch provides a fixup for the fixed DAC/pin mapping for this
device.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=212933
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210504082057.6913-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5608,6 +5608,18 @@ static void alc_fixup_tpt470_dacs(struct
 		spec->gen.preferred_dacs = preferred_pairs;
 }
 
+static void alc295_fixup_asus_dacs(struct hda_codec *codec,
+				   const struct hda_fixup *fix, int action)
+{
+	static const hda_nid_t preferred_pairs[] = {
+		0x17, 0x02, 0x21, 0x03, 0
+	};
+	struct alc_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE)
+		spec->gen.preferred_dacs = preferred_pairs;
+}
+
 static void alc_shutup_dell_xps13(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
@@ -6377,6 +6389,7 @@ enum {
 	ALC274_FIXUP_HP_HEADSET_MIC,
 	ALC256_FIXUP_ASUS_HPE,
 	ALC285_FIXUP_THINKPAD_NO_BASS_SPK_HEADSET_JACK,
+	ALC295_FIXUP_ASUS_DACS,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -7842,6 +7855,10 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC269_FIXUP_THINKPAD_ACPI
 	},
+	[ALC295_FIXUP_ASUS_DACS] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc295_fixup_asus_dacs,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -8018,6 +8035,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x1427, "Asus Zenbook UX31E", ALC269VB_FIXUP_ASUS_ZENBOOK),
 	SND_PCI_QUIRK(0x1043, 0x1517, "Asus Zenbook UX31A", ALC269VB_FIXUP_ASUS_ZENBOOK_UX31A),
 	SND_PCI_QUIRK(0x1043, 0x16e3, "ASUS UX50", ALC269_FIXUP_STEREO_DMIC),
+	SND_PCI_QUIRK(0x1043, 0x1740, "ASUS UX430UA", ALC295_FIXUP_ASUS_DACS),
 	SND_PCI_QUIRK(0x1043, 0x17d1, "ASUS UX431FL", ALC294_FIXUP_ASUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1881, "ASUS Zephyrus S/M", ALC294_FIXUP_ASUS_GX502_PINS),
 	SND_PCI_QUIRK(0x1043, 0x18b1, "Asus MJ401TA", ALC256_FIXUP_ASUS_HEADSET_MIC),


