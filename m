Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8D83786A1
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234932AbhEJLJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:09:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231951AbhEJLBo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:01:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2C9F61C52;
        Mon, 10 May 2021 10:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644018;
        bh=C0kbrCsgyDr8o88l0aKatdUORPeRqWEa/ybH6nlAdZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G9CR78+di83qjzmLCEjhF6pib/ZJukKBB/+O6N9uoqvcZ3xm/HJJrI6JFVSL4z1lJ
         ZCvK2zRJF8KttVRgQs/cxD28A5YHNYGXIci/LsVTz9edwnwtpcwwXNFQq1c0nVTXeZ
         U0xC0wXN6XhpIGYBStrMvUD7xBkP0sZecKL0bSJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Calvin <phil@philcalvin.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 247/342] ALSA: hda/realtek: fix mic boost on Intel NUC 8
Date:   Mon, 10 May 2021 12:20:37 +0200
Message-Id: <20210510102018.244352578@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phil Calvin <phil@philcalvin.com>

commit d1ee66c5d3c5a0498dd5e3f2af5b8c219a98bba5 upstream.

Fix two bugs with the Intel HDA Realtek ALC233 sound codec
present in Intel NUC NUC8i7BEH and probably a few other similar
NUC models.

These codecs advertise a 4-level microphone input boost amplifier on
pin 0x19, but the highest two boost settings do not work correctly,
and produce only low analog noise that does not seem to contain any
discernible signal. There is an existing fixup for this exact problem
but for a different PCI subsystem ID, so we re-use that logic.

Changing the boost level also triggers a DC spike in the input signal
that bleeds off over about a second and overwhelms any input during
that time. Thankfully, the existing fixup has the side effect of
making the boost control show up in userspace as a mute/unmute switch,
and this keeps (e.g.) PulseAudio from fiddling with it during normal
input volume adjustments.

Finally, the NUC hardware has built-in inverted stereo mics. This
patch also enables the usual fixup for this so the two channels cancel
noise instead of the actual signal.

[ Re-ordered the quirk entry point by tiwai ]

Signed-off-by: Phil Calvin <phil@philcalvin.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/80dc5663-7734-e7e5-25ef-15b5df24511a@philcalvin.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6435,6 +6435,8 @@ enum {
 	ALC269_FIXUP_LEMOTE_A1802,
 	ALC269_FIXUP_LEMOTE_A190X,
 	ALC256_FIXUP_INTEL_NUC8_RUGGED,
+	ALC233_FIXUP_INTEL_NUC8_DMIC,
+	ALC233_FIXUP_INTEL_NUC8_BOOST,
 	ALC256_FIXUP_INTEL_NUC10,
 	ALC255_FIXUP_XIAOMI_HEADSET_MIC,
 	ALC274_FIXUP_HP_MIC,
@@ -7156,6 +7158,16 @@ static const struct hda_fixup alc269_fix
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc233_fixup_lenovo_line2_mic_hotkey,
 	},
+	[ALC233_FIXUP_INTEL_NUC8_DMIC] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc_fixup_inv_dmic,
+		.chained = true,
+		.chain_id = ALC233_FIXUP_INTEL_NUC8_BOOST,
+	},
+	[ALC233_FIXUP_INTEL_NUC8_BOOST] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc269_fixup_limit_int_mic_boost
+	},
 	[ALC255_FIXUP_DELL_SPK_NOISE] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc_fixup_disable_aamix,
@@ -8305,6 +8317,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x10ec, 0x118c, "Medion EE4254 MD62100", ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1c06, 0x2013, "Lemote A1802", ALC269_FIXUP_LEMOTE_A1802),
 	SND_PCI_QUIRK(0x1c06, 0x2015, "Lemote A190X", ALC269_FIXUP_LEMOTE_A190X),
+	SND_PCI_QUIRK(0x8086, 0x2074, "Intel NUC 8", ALC233_FIXUP_INTEL_NUC8_DMIC),
 	SND_PCI_QUIRK(0x8086, 0x2080, "Intel NUC 8 Rugged", ALC256_FIXUP_INTEL_NUC8_RUGGED),
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", ALC256_FIXUP_INTEL_NUC10),
 


