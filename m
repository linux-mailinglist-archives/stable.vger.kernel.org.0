Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B48423A624
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbgHCMpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:45:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:53682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728598AbgHCM1s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:27:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC38B204EC;
        Mon,  3 Aug 2020 12:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457667;
        bh=jMTM9Awye6xGmKCtwUVQ9PWUR+npLdpUHGaUO7Onh5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=16Ouo7KUCEnq/i+wXshO8x5rLOTegum72edg/vuqoQiewmGcTHwfJvm1shUMU5sE4
         +z6d9Md+FfpdGPk4GzyyD0B3WVQk9FnMm8ZV+IVST3H8chrWXq6Fl5pNU/1mLR3MFi
         6B3fXs/3xctYnO8/SuW+3iCUNQwTOUB5xEL5PAOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Armas Spann <zappel@retarded.farm>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 08/90] ALSA: hda/realtek: enable headset mic of ASUS ROG Zephyrus G15(GA502) series with ALC289
Date:   Mon,  3 Aug 2020 14:18:30 +0200
Message-Id: <20200803121857.948708603@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Armas Spann <zappel@retarded.farm>

commit 4b43d05a1978a93a19374c6e6b817c9c1ff4ba4b upstream.

This patch adds support for headset mic to the ASUS ROG Zephyrus
G15(GA502) notebook series by adding the corresponding
vendor/pci_device id, as well as adding a new fixup for the used
realtek ALC289. The fixup stets the correct pin to get the headset mic
correctly recognized on audio-jack.

Signed-off-by: Armas Spann <zappel@retarded.farm>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200724140616.298892-1-zappel@retarded.farm
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6118,6 +6118,7 @@ enum {
 	ALC269VC_FIXUP_ACER_HEADSET_MIC,
 	ALC269VC_FIXUP_ACER_MIC_NO_PRESENCE,
 	ALC289_FIXUP_ASUS_G401,
+	ALC289_FIXUP_ASUS_GA502,
 	ALC256_FIXUP_ACER_MIC_NO_PRESENCE,
 };
 
@@ -7335,6 +7336,13 @@ static const struct hda_fixup alc269_fix
 			{ }
 		},
 	},
+	[ALC289_FIXUP_ASUS_GA502] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x03a11020 }, /* headset mic with jack detect */
+			{ }
+		},
+	},
 	[ALC256_FIXUP_ACER_MIC_NO_PRESENCE] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -7526,6 +7534,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x1bbd, "ASUS Z550MA", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1c23, "Asus X55U", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x1043, 0x1ccd, "ASUS X555UB", ALC256_FIXUP_ASUS_MIC),
+	SND_PCI_QUIRK(0x1043, 0x1e11, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA502),
 	SND_PCI_QUIRK(0x1043, 0x1f11, "ASUS Zephyrus G14", ALC289_FIXUP_ASUS_G401),
 	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),
 	SND_PCI_QUIRK(0x1043, 0x831a, "ASUS P901", ALC269_FIXUP_STEREO_DMIC),


