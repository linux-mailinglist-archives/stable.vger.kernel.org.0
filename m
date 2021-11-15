Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCEB4524EB
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353683AbhKPBqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:46:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:59060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241469AbhKOSUi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:20:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 682EA63408;
        Mon, 15 Nov 2021 17:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998755;
        bh=JV8eWlf2Ua7TymUANMbdIWzBVW2RBueilevNCsNFq14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iP9y793rAXLraXU/hRVgK2PtMPstWoo9/ICFhHJoODmvotN/rxK6opfiflkBYTT4C
         P2w2t9UyaqpC9yrHoSMoBocc5NNa0kFaCs+rY0uvgK6TSi9ftwk81DH7TTf3aEOmR4
         cBAT4/cqEfOkca1fL5uoYY2ymFwYTKNOCLYICdvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Soller <jeremy@system76.com>,
        Tim Crawford <tcrawford@system76.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.14 032/849] ALSA: hda/realtek: Headset fixup for Clevo NH77HJQ
Date:   Mon, 15 Nov 2021 17:51:55 +0100
Message-Id: <20211115165421.093071785@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Soller <jeremy@system76.com>

commit 1278cc5ac2f96bab50dd55c8c05e0a6a77ce323e upstream.

On Clevo NH77HJ, NH77HP, and their 15" variants, there is a headset
microphone input attached to 0x19 that does not have a jack detect. In
order to get it working, the pin configuration needs to be set
correctly, and a new ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE fixup is
applied. This is similar to the existing System76 quirk for ALC293, but
for ALC256.

Signed-off-by: Jeremy Soller <jeremy@system76.com>
Signed-off-by: Tim Crawford <tcrawford@system76.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211102172104.10610-1-tcrawford@system76.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6713,6 +6713,7 @@ enum {
 	ALC287_FIXUP_YOGA7_14ITL_SPEAKERS,
 	ALC287_FIXUP_13S_GEN2_SPEAKERS,
 	ALC256_FIXUP_TONGFANG_RESET_PERSISTENT_SETTINGS,
+	ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -8420,6 +8421,15 @@ static const struct hda_fixup alc269_fix
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc245_fixup_hp_gpio_led,
 	},
+	[ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x03a11120 }, /* use as headset mic, without its own jack detect */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -8718,11 +8728,15 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1558, 0x40a1, "Clevo NL40GU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x40c1, "Clevo NL40[CZ]U", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x40d1, "Clevo NL41DU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x5015, "Clevo NH5[58]H[HJK]Q", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x5017, "Clevo NH7[79]H[HJK]Q", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x50a3, "Clevo NJ51GU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x50b3, "Clevo NK50S[BEZ]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x50b6, "Clevo NK50S5", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x50b8, "Clevo NK50SZ", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x50d5, "Clevo NP50D5", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x50e1, "Clevo NH5[58]HPQ", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x50e2, "Clevo NH7[79]HPQ", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x50f0, "Clevo NH50A[CDF]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x50f2, "Clevo NH50E[PR]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x50f3, "Clevo NH58DPQ", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),


