Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7950E5A97
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 15:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfJZNQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 09:16:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726695AbfJZNQ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Oct 2019 09:16:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81B562070B;
        Sat, 26 Oct 2019 13:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095785;
        bh=Offh/w1Mjf4rhXqvosLloF1HixEhncRyO8AIHqZcNkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NLRDYWAvLxgMHwcgnUTLyGG1klmKJXqcBfJj+QYCFW9jU7sFIGXDH53B0FSsDO/rn
         xImh+ncXP42DP4BM4IB/WIx9YS3cv6hF0lifEpshBT7V+Cp59J8hrmrT/Ph7bKeKBa
         O4ZutsV671oV5iv0G8eLhQbtTgYsRllKQgzWx5rw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 14/99] ALSA: hda/realtek: Reduce the Headphone static noise on XPS 9350/9360
Date:   Sat, 26 Oct 2019 09:14:35 -0400
Message-Id: <20191026131600.2507-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 1099f48457d06b816359fb43ac32a4a07e33219b ]

Headphone on XPS 9350/9360 produces a background white noise. The The
noise level somehow correlates with "Headphone Mic Boost", when it sets
to 1 the noise disappears. However, doing this has a side effect, which
also decreases the overall headphone volume so I didn't send the patch
upstream.

The noise was bearable back then, but after commit 717f43d81afc ("ALSA:
hda/realtek - Update headset mode for ALC256") the noise exacerbates to
a point it starts hurting ears.

So let's use the workaround to set "Headphone Mic Boost" to 1 and lock
it so it's not touchable by userspace.

Fixes: 717f43d81afc ("ALSA: hda/realtek - Update headset mode for ALC256")
BugLink: https://bugs.launchpad.net/bugs/1654448
BugLink: https://bugs.launchpad.net/bugs/1845810
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20191003043919.10960-1-kai.heng.feng@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 36aee8ad20547..096af7d114233 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5357,6 +5357,17 @@ static void alc271_hp_gate_mic_jack(struct hda_codec *codec,
 	}
 }
 
+static void alc256_fixup_dell_xps_13_headphone_noise2(struct hda_codec *codec,
+						      const struct hda_fixup *fix,
+						      int action)
+{
+	if (action != HDA_FIXUP_ACT_PRE_PROBE)
+		return;
+
+	snd_hda_codec_amp_stereo(codec, 0x1a, HDA_INPUT, 0, HDA_AMP_VOLMASK, 1);
+	snd_hda_override_wcaps(codec, 0x1a, get_wcaps(codec, 0x1a) & ~AC_WCAP_IN_AMP);
+}
+
 static void alc269_fixup_limit_int_mic_boost(struct hda_codec *codec,
 					     const struct hda_fixup *fix,
 					     int action)
@@ -5820,6 +5831,7 @@ enum {
 	ALC298_FIXUP_DELL_AIO_MIC_NO_PRESENCE,
 	ALC275_FIXUP_DELL_XPS,
 	ALC256_FIXUP_DELL_XPS_13_HEADPHONE_NOISE,
+	ALC256_FIXUP_DELL_XPS_13_HEADPHONE_NOISE2,
 	ALC293_FIXUP_LENOVO_SPK_NOISE,
 	ALC233_FIXUP_LENOVO_LINE2_MIC_HOTKEY,
 	ALC255_FIXUP_DELL_SPK_NOISE,
@@ -6547,6 +6559,12 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC255_FIXUP_DELL1_MIC_NO_PRESENCE
 	},
+	[ALC256_FIXUP_DELL_XPS_13_HEADPHONE_NOISE2] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc256_fixup_dell_xps_13_headphone_noise2,
+		.chained = true,
+		.chain_id = ALC256_FIXUP_DELL_XPS_13_HEADPHONE_NOISE
+	},
 	[ALC293_FIXUP_LENOVO_SPK_NOISE] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc_fixup_disable_aamix,
@@ -6990,17 +7008,17 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x06de, "Dell", ALC293_FIXUP_DISABLE_AAMIX_MULTIJACK),
 	SND_PCI_QUIRK(0x1028, 0x06df, "Dell", ALC293_FIXUP_DISABLE_AAMIX_MULTIJACK),
 	SND_PCI_QUIRK(0x1028, 0x06e0, "Dell", ALC293_FIXUP_DISABLE_AAMIX_MULTIJACK),
-	SND_PCI_QUIRK(0x1028, 0x0704, "Dell XPS 13 9350", ALC256_FIXUP_DELL_XPS_13_HEADPHONE_NOISE),
+	SND_PCI_QUIRK(0x1028, 0x0704, "Dell XPS 13 9350", ALC256_FIXUP_DELL_XPS_13_HEADPHONE_NOISE2),
 	SND_PCI_QUIRK(0x1028, 0x0706, "Dell Inspiron 7559", ALC256_FIXUP_DELL_INSPIRON_7559_SUBWOOFER),
 	SND_PCI_QUIRK(0x1028, 0x0725, "Dell Inspiron 3162", ALC255_FIXUP_DELL_SPK_NOISE),
 	SND_PCI_QUIRK(0x1028, 0x0738, "Dell Precision 5820", ALC269_FIXUP_NO_SHUTUP),
-	SND_PCI_QUIRK(0x1028, 0x075b, "Dell XPS 13 9360", ALC256_FIXUP_DELL_XPS_13_HEADPHONE_NOISE),
+	SND_PCI_QUIRK(0x1028, 0x075b, "Dell XPS 13 9360", ALC256_FIXUP_DELL_XPS_13_HEADPHONE_NOISE2),
 	SND_PCI_QUIRK(0x1028, 0x075c, "Dell XPS 27 7760", ALC298_FIXUP_SPK_VOLUME),
 	SND_PCI_QUIRK(0x1028, 0x075d, "Dell AIO", ALC298_FIXUP_SPK_VOLUME),
 	SND_PCI_QUIRK(0x1028, 0x07b0, "Dell Precision 7520", ALC295_FIXUP_DISABLE_DAC3),
 	SND_PCI_QUIRK(0x1028, 0x0798, "Dell Inspiron 17 7000 Gaming", ALC256_FIXUP_DELL_INSPIRON_7559_SUBWOOFER),
 	SND_PCI_QUIRK(0x1028, 0x080c, "Dell WYSE", ALC225_FIXUP_DELL_WYSE_MIC_NO_PRESENCE),
-	SND_PCI_QUIRK(0x1028, 0x082a, "Dell XPS 13 9360", ALC256_FIXUP_DELL_XPS_13_HEADPHONE_NOISE),
+	SND_PCI_QUIRK(0x1028, 0x082a, "Dell XPS 13 9360", ALC256_FIXUP_DELL_XPS_13_HEADPHONE_NOISE2),
 	SND_PCI_QUIRK(0x1028, 0x084b, "Dell", ALC274_FIXUP_DELL_AIO_LINEOUT_VERB),
 	SND_PCI_QUIRK(0x1028, 0x084e, "Dell", ALC274_FIXUP_DELL_AIO_LINEOUT_VERB),
 	SND_PCI_QUIRK(0x1028, 0x0871, "Dell Precision 3630", ALC255_FIXUP_DELL_HEADSET_MIC),
-- 
2.20.1

