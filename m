Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7158BFA40C
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729867AbfKMB5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:57:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:51158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728795AbfKMB5o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:57:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 410A22245C;
        Wed, 13 Nov 2019 01:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610263;
        bh=cps95J12ZBs95Tga0IarAZLjU6eKhhQzMyHwqKsN98Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LVprY+VXfPD7XOshl1Xd4+LtF2Ur+tVgGTfsLUdH4sn+Hp8Mvh37unRM6cfGSOhuu
         NwNeQ3NABOjd8n+xJnU0OX+4nFGJ/4/TwXRn2vHd7I/WywIyTw9q/7m+95RAIJ7LGA
         UGR16jTxOygqM64KxVmFyShxa8KWLkIkqP/mlbio=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Pobega <mpobega@neverware.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 054/115] ALSA: hda/sigmatel - Disable automute for Elo VuPoint
Date:   Tue, 12 Nov 2019 20:55:21 -0500
Message-Id: <20191113015622.11592-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Pobega <mpobega@neverware.com>

[ Upstream commit d153135e93a50cdb6f1b52e238909e9965b56056 ]

The Elo VuPoint 15MX has two headphone jacks of which neither work by
default. Disabling automute allows ALSA to work normally with the
speakers & left headphone jack.

Future pin configuration changes may be required in the future to get
the right headphone jack working in tandem.

Signed-off-by: Michael Pobega <mpobega@neverware.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_sigmatel.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 63d15b545b333..7cd147411b22d 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -77,6 +77,7 @@ enum {
 	STAC_DELL_M6_BOTH,
 	STAC_DELL_EQ,
 	STAC_ALIENWARE_M17X,
+	STAC_ELO_VUPOINT_15MX,
 	STAC_92HD89XX_HP_FRONT_JACK,
 	STAC_92HD89XX_HP_Z1_G2_RIGHT_MIC_JACK,
 	STAC_92HD73XX_ASUS_MOBO,
@@ -1897,6 +1898,18 @@ static void stac92hd73xx_fixup_no_jd(struct hda_codec *codec,
 		codec->no_jack_detect = 1;
 }
 
+
+static void stac92hd73xx_disable_automute(struct hda_codec *codec,
+				     const struct hda_fixup *fix, int action)
+{
+	struct sigmatel_spec *spec = codec->spec;
+
+	if (action != HDA_FIXUP_ACT_PRE_PROBE)
+		return;
+
+	spec->gen.suppress_auto_mute = 1;
+}
+
 static const struct hda_fixup stac92hd73xx_fixups[] = {
 	[STAC_92HD73XX_REF] = {
 		.type = HDA_FIXUP_FUNC,
@@ -1922,6 +1935,10 @@ static const struct hda_fixup stac92hd73xx_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = stac92hd73xx_fixup_alienware_m17x,
 	},
+	[STAC_ELO_VUPOINT_15MX] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = stac92hd73xx_disable_automute,
+	},
 	[STAC_92HD73XX_INTEL] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = intel_dg45id_pin_configs,
@@ -1960,6 +1977,7 @@ static const struct hda_model_fixup stac92hd73xx_models[] = {
 	{ .id = STAC_DELL_M6_BOTH, .name = "dell-m6" },
 	{ .id = STAC_DELL_EQ, .name = "dell-eq" },
 	{ .id = STAC_ALIENWARE_M17X, .name = "alienware" },
+	{ .id = STAC_ELO_VUPOINT_15MX, .name = "elo-vupoint-15mx" },
 	{ .id = STAC_92HD73XX_ASUS_MOBO, .name = "asus-mobo" },
 	{}
 };
@@ -2009,6 +2027,8 @@ static const struct snd_pci_quirk stac92hd73xx_fixup_tbl[] = {
 		      "Alienware M17x", STAC_ALIENWARE_M17X),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x0490,
 		      "Alienware M17x R3", STAC_DELL_EQ),
+	SND_PCI_QUIRK(0x1059, 0x1011,
+		      "ELO VuPoint 15MX", STAC_ELO_VUPOINT_15MX),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x1927,
 				"HP Z1 G2", STAC_92HD89XX_HP_Z1_G2_RIGHT_MIC_JACK),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x2b17,
-- 
2.20.1

