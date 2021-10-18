Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4478F431CB6
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbhJRNoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:44:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232676AbhJRNm1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:42:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82B54613A9;
        Mon, 18 Oct 2021 13:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564046;
        bh=JsB8+ZpDQxEtfM1n5ZKEWS9tUxx2VaainVumcXrUszE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A65R4T4layXNbHEKIVWiX6frrBmjRtpOBKxgrT3tr/iLwLg4CWRLWx0qZAc8GN2uW
         w+rEUT+1HpWhVUZBspeKvY0jrAI823ThHq1LOyQmttloJ+pa4DBJaqvT2vsTd69T3V
         fbtkraF6WPF/SWpdEVpS9yILwTU1/tep3WRCvD30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, msd <msd.mmq@gmail.com>
Subject: [PATCH 5.10 011/103] ALSA: hda/realtek: Fix the mic type detection issue for ASUS G551JW
Date:   Mon, 18 Oct 2021 15:23:47 +0200
Message-Id: <20211018132335.072333077@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
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
@@ -10129,6 +10129,9 @@ enum {
 	ALC671_FIXUP_HP_HEADSET_MIC2,
 	ALC662_FIXUP_ACER_X2660G_HEADSET_MODE,
 	ALC662_FIXUP_ACER_NITRO_HEADSET_MODE,
+	ALC668_FIXUP_ASUS_NO_HEADSET_MIC,
+	ALC668_FIXUP_HEADSET_MIC,
+	ALC668_FIXUP_MIC_DET_COEF,
 };
 
 static const struct hda_fixup alc662_fixups[] = {
@@ -10512,6 +10515,29 @@ static const struct hda_fixup alc662_fix
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
@@ -10547,6 +10573,7 @@ static const struct snd_pci_quirk alc662
 	SND_PCI_QUIRK(0x1043, 0x15a7, "ASUS UX51VZH", ALC662_FIXUP_BASS_16),
 	SND_PCI_QUIRK(0x1043, 0x177d, "ASUS N551", ALC668_FIXUP_ASUS_Nx51),
 	SND_PCI_QUIRK(0x1043, 0x17bd, "ASUS N751", ALC668_FIXUP_ASUS_Nx51),
+	SND_PCI_QUIRK(0x1043, 0x185d, "ASUS G551JW", ALC668_FIXUP_ASUS_NO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1963, "ASUS X71SL", ALC662_FIXUP_ASUS_MODE8),
 	SND_PCI_QUIRK(0x1043, 0x1b73, "ASUS N55SF", ALC662_FIXUP_BASS_16),
 	SND_PCI_QUIRK(0x1043, 0x1bf3, "ASUS N76VZ", ALC662_FIXUP_BASS_MODE4_CHMAP),


