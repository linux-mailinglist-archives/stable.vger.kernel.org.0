Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28DFC1D85BA
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730499AbgERRwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:52:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730198AbgERRwY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:52:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFFA620674;
        Mon, 18 May 2020 17:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824344;
        bh=Hu6rY2+B+FsZyOlVEIjwnv983HFrsjYCoZu3AjQrEyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rCnh2EfsTCfV4pV29qcR0AqL99MJ9LucX8f061wAqFzuDMPxc39/NVdAQdafiurw5
         Jk7cX1WvbAIWv6Ak7h2ogmYrk7hTzBbGx5cLxHqiW2eeW9V7HUB5qglTI8iQbvyWCC
         r4RPailfHoBcV7wD3KeNFAaLSUDwxbEUMtq2B7Jk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 53/80] ALSA: hda/realtek - Limit int mic boost for Thinkpad T530
Date:   Mon, 18 May 2020 19:37:11 +0200
Message-Id: <20200518173501.132932239@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.097837707@linuxfoundation.org>
References: <20200518173450.097837707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit b590b38ca305d6d7902ec7c4f7e273e0069f3bcc upstream.

Lenovo Thinkpad T530 seems to have a sensitive internal mic capture
that needs to limit the mic boost like a few other Thinkpad models.
Although we may change the quirk for ALC269_FIXUP_LENOVO_DOCK, this
hits way too many other laptop models, so let's add a new fixup model
that limits the internal mic boost on top of the existing quirk and
apply to only T530.

BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1171293
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200514160533.10337-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5616,6 +5616,7 @@ enum {
 	ALC269_FIXUP_HP_LINE1_MIC1_LED,
 	ALC269_FIXUP_INV_DMIC,
 	ALC269_FIXUP_LENOVO_DOCK,
+	ALC269_FIXUP_LENOVO_DOCK_LIMIT_BOOST,
 	ALC269_FIXUP_NO_SHUTUP,
 	ALC286_FIXUP_SONY_MIC_NO_PRESENCE,
 	ALC269_FIXUP_PINCFG_NO_HP_TO_LINEOUT,
@@ -5928,6 +5929,12 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC269_FIXUP_PINCFG_NO_HP_TO_LINEOUT
 	},
+	[ALC269_FIXUP_LENOVO_DOCK_LIMIT_BOOST] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc269_fixup_limit_int_mic_boost,
+		.chained = true,
+		.chain_id = ALC269_FIXUP_LENOVO_DOCK,
+	},
 	[ALC269_FIXUP_PINCFG_NO_HP_TO_LINEOUT] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc269_fixup_pincfg_no_hp_to_lineout,
@@ -7013,7 +7020,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x21b8, "Thinkpad Edge 14", ALC269_FIXUP_SKU_IGNORE),
 	SND_PCI_QUIRK(0x17aa, 0x21ca, "Thinkpad L412", ALC269_FIXUP_SKU_IGNORE),
 	SND_PCI_QUIRK(0x17aa, 0x21e9, "Thinkpad Edge 15", ALC269_FIXUP_SKU_IGNORE),
-	SND_PCI_QUIRK(0x17aa, 0x21f6, "Thinkpad T530", ALC269_FIXUP_LENOVO_DOCK),
+	SND_PCI_QUIRK(0x17aa, 0x21f6, "Thinkpad T530", ALC269_FIXUP_LENOVO_DOCK_LIMIT_BOOST),
 	SND_PCI_QUIRK(0x17aa, 0x21fa, "Thinkpad X230", ALC269_FIXUP_LENOVO_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x21f3, "Thinkpad T430", ALC269_FIXUP_LENOVO_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x21fb, "Thinkpad T430s", ALC269_FIXUP_LENOVO_DOCK),
@@ -7150,6 +7157,7 @@ static const struct hda_model_fixup alc2
 	{.id = ALC269_FIXUP_HEADSET_MODE, .name = "headset-mode"},
 	{.id = ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC, .name = "headset-mode-no-hp-mic"},
 	{.id = ALC269_FIXUP_LENOVO_DOCK, .name = "lenovo-dock"},
+	{.id = ALC269_FIXUP_LENOVO_DOCK_LIMIT_BOOST, .name = "lenovo-dock-limit-boost"},
 	{.id = ALC269_FIXUP_HP_GPIO_LED, .name = "hp-gpio-led"},
 	{.id = ALC269_FIXUP_HP_DOCK_GPIO_MIC1_LED, .name = "hp-dock-gpio-mic1-led"},
 	{.id = ALC269_FIXUP_DELL1_MIC_NO_PRESENCE, .name = "dell-headset-multi"},


