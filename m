Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2193E1070E7
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbfKVKg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:36:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:37678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727208AbfKVKg7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:36:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8FC820656;
        Fri, 22 Nov 2019 10:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419018;
        bh=iufa2eP/TUMfHuSqsOfMqcEWWdjpkgEBSDuAnm64Qv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Q8p4Xb2D9aaLeDLm4XKYVwZtgFyacZZAhL3Yway8G0MRkCqt4xIXcl5Quh2Dk6Nu
         9j3noTI29X64DVoIvVwp3Pr+wjuS8FO5NBhwoNnuM0e4n9Lq+Wea/AQhg7RYqnFE0U
         tULJyA95JHYTWzNiaHqE8K3Si+oBjG6Vl9KIlkLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Pobega <mpobega@neverware.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 130/159] ALSA: hda/sigmatel - Disable automute for Elo VuPoint
Date:   Fri, 22 Nov 2019 11:28:41 +0100
Message-Id: <20191122100833.459550266@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 0abab7926dca3..d1a6d20ace0da 100644
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
@@ -1875,6 +1876,18 @@ static void stac92hd73xx_fixup_no_jd(struct hda_codec *codec,
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
@@ -1900,6 +1913,10 @@ static const struct hda_fixup stac92hd73xx_fixups[] = {
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
@@ -1938,6 +1955,7 @@ static const struct hda_model_fixup stac92hd73xx_models[] = {
 	{ .id = STAC_DELL_M6_BOTH, .name = "dell-m6" },
 	{ .id = STAC_DELL_EQ, .name = "dell-eq" },
 	{ .id = STAC_ALIENWARE_M17X, .name = "alienware" },
+	{ .id = STAC_ELO_VUPOINT_15MX, .name = "elo-vupoint-15mx" },
 	{ .id = STAC_92HD73XX_ASUS_MOBO, .name = "asus-mobo" },
 	{}
 };
@@ -1987,6 +2005,8 @@ static const struct snd_pci_quirk stac92hd73xx_fixup_tbl[] = {
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



