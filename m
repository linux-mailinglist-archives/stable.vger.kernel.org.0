Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9652F144D
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733116AbhAKNSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:18:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:36802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732895AbhAKNSN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:18:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7997A2251F;
        Mon, 11 Jan 2021 13:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371051;
        bh=istfdwy1GHaquLZc+z5BSMnM9h/sGtSaQ5CR9kxqBuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8oYhBFruJAvK4Bpbp8Fe2nAz1xNei5tNgxn74d0/WC6RO/zgDCXnfBw163IG1TEk
         scFpzuD2rMr3a0JrTE4yIAh4brub8NSIYwyfQFvNsK5zbNbBPsaFhjHGcLYWzmcS6/
         XXDPnbnXb9rqkD23XDPu/bT+XJ+1t0kJoyxAS990=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 120/145] ALSA: hda/realtek - Fix speaker volume control on Lenovo C940
Date:   Mon, 11 Jan 2021 14:02:24 +0100
Message-Id: <20210111130054.279607759@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit f86de9b1c0663b0a3ca2dcddec9aa910ff0fbf2c upstream.

Cannot adjust speaker's volume on Lenovo C940.
Applying the alc298_fixup_speaker_volume function can fix the issue.

[ Additional note: C940 has I2S amp for the speaker and this needs the
  same initialization as Dell machines.
  The patch was slightly modified so that the quirk entry is moved
  next to the corresponding Dell quirk entry. -- tiwai ]

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/ea25b4e5c468491aa2e9d6cb1f2fced3@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6289,6 +6289,7 @@ enum {
 	ALC221_FIXUP_HP_FRONT_MIC,
 	ALC292_FIXUP_TPT460,
 	ALC298_FIXUP_SPK_VOLUME,
+	ALC298_FIXUP_LENOVO_SPK_VOLUME,
 	ALC256_FIXUP_DELL_INSPIRON_7559_SUBWOOFER,
 	ALC269_FIXUP_ATIV_BOOK_8,
 	ALC221_FIXUP_HP_MIC_NO_PRESENCE,
@@ -7119,6 +7120,10 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC298_FIXUP_DELL_AIO_MIC_NO_PRESENCE,
 	},
+	[ALC298_FIXUP_LENOVO_SPK_VOLUME] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc298_fixup_speaker_volume,
+	},
 	[ALC295_FIXUP_DISABLE_DAC3] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc295_fixup_disable_dac3,
@@ -8126,6 +8131,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x3151, "ThinkCentre Station", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3176, "ThinkCentre Station", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3178, "ThinkCentre Station", ALC283_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x17aa, 0x3818, "Lenovo C940", ALC298_FIXUP_LENOVO_SPK_VOLUME),
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x3977, "IdeaPad S210", ALC283_FIXUP_INT_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3978, "Lenovo B50-70", ALC269_FIXUP_DMIC_THINKPAD_ACPI),


