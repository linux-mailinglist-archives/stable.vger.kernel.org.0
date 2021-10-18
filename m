Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107A4431BD9
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbhJRNfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:35:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232390AbhJRNeI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:34:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F3A361354;
        Mon, 18 Oct 2021 13:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563796;
        bh=+rm77VMA07kGpepxIYwls/OaoeJjBtAI1v3bXgCzprU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eLVkcRbaYE1atR+YY/A4CRnPFpCxg/+e/TtMeTT3FQ4xXpfWdcu8Xqkg1Fwg+PB9c
         VtQDGlVmrETPMRp8nrM7cqU6ImX9oGq3w0areyCRQNzcjZOHGq+lakGIpImg/TcVFJ
         kQmmhMO0tLmTIctV1kLoyoEpJRjLSI6vXORVO7Ks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, msd <msd.mmq@gmail.com>
Subject: [PATCH 5.4 07/69] ALSA: hda/realtek: Fix the mic type detection issue for ASUS G551JW
Date:   Mon, 18 Oct 2021 15:24:05 +0200
Message-Id: <20211018132329.705332055@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132329.453964125@linuxfoundation.org>
References: <20211018132329.453964125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit a3fd1a986e499a06ac5ef95c3a39aa4611e7444c upstream.

We need to define the codec pin 0x1b to be the mic, but somehow
the mic doesn't support hot plugging detection, and Windows also has
this issue, so we set it to phantom headset-mic.

Also the determine_headset_type() often returns the omtp type by a
mistake when we plug a ctia headset, this makes the mic can't record
sound at all. Because most of the headset are ctia type nowadays and
some machines have the fixed ctia type audio jack, it is possible this
machine has the fixed ctia jack too. Here we set this mic jack to
fixed ctia type, this could avoid the mic type detection mistake and
make the ctia headset work stable.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=214537
Reported-and-tested-by: msd <msd.mmq@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20211012114748.5238-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9692,6 +9692,9 @@ enum {
 	ALC671_FIXUP_HP_HEADSET_MIC2,
 	ALC662_FIXUP_ACER_X2660G_HEADSET_MODE,
 	ALC662_FIXUP_ACER_NITRO_HEADSET_MODE,
+	ALC668_FIXUP_ASUS_NO_HEADSET_MIC,
+	ALC668_FIXUP_HEADSET_MIC,
+	ALC668_FIXUP_MIC_DET_COEF,
 };
 
 static const struct hda_fixup alc662_fixups[] = {
@@ -10075,6 +10078,29 @@ static const struct hda_fixup alc662_fix
 		.chained = true,
 		.chain_id = ALC662_FIXUP_USI_FUNC
 	},
+	[ALC668_FIXUP_ASUS_NO_HEADSET_MIC] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x1b, 0x04a1112c },
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC668_FIXUP_HEADSET_MIC
+	},
+	[ALC668_FIXUP_HEADSET_MIC] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc269_fixup_headset_mic,
+		.chained = true,
+		.chain_id = ALC668_FIXUP_MIC_DET_COEF
+	},
+	[ALC668_FIXUP_MIC_DET_COEF] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x15 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x0d60 },
+			{}
+		},
+	},
 };
 
 static const struct snd_pci_quirk alc662_fixup_tbl[] = {
@@ -10110,6 +10136,7 @@ static const struct snd_pci_quirk alc662
 	SND_PCI_QUIRK(0x1043, 0x15a7, "ASUS UX51VZH", ALC662_FIXUP_BASS_16),
 	SND_PCI_QUIRK(0x1043, 0x177d, "ASUS N551", ALC668_FIXUP_ASUS_Nx51),
 	SND_PCI_QUIRK(0x1043, 0x17bd, "ASUS N751", ALC668_FIXUP_ASUS_Nx51),
+	SND_PCI_QUIRK(0x1043, 0x185d, "ASUS G551JW", ALC668_FIXUP_ASUS_NO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1963, "ASUS X71SL", ALC662_FIXUP_ASUS_MODE8),
 	SND_PCI_QUIRK(0x1043, 0x1b73, "ASUS N55SF", ALC662_FIXUP_BASS_16),
 	SND_PCI_QUIRK(0x1043, 0x1bf3, "ASUS N76VZ", ALC662_FIXUP_BASS_MODE4_CHMAP),


