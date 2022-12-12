Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 936E664A157
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbiLLNiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbiLLNiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:38:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65210614D
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:37:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11C02B8068B
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812CEC433EF;
        Mon, 12 Dec 2022 13:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852261;
        bh=TQybE/fXDNsPC++k5vcAQ2SGEpCTDyeVoShqFMvk/JI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TV/Pnc4UYQVdxMt7VQ2GqGzAHShjgJ5XPZpdTQZYy9ZjQxYuCTOb0gqm8cqERDA2R
         R0k5qfdC6RDZpO4ca9go5lKcqhQgHB+fAxFT9OqC6kPU0rdh9dKr/i2P7fzwEl41VS
         sq8pIK/dq9AGrzOsD/b3Z90k0KjEl4hYsq0qwHNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 046/157] ALSA: hda/realtek: More robust component matching for CS35L41
Date:   Mon, 12 Dec 2022 14:16:34 +0100
Message-Id: <20221212130936.401048854@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 35a1744423743247026668e2323d1b932583fc2a ]

As the previous commit implies, a system may have a different SPI bus
number that is embedded in the device string.  And, assuming the fixed
bus number is rather fragile; it may be assigned differently depending
on the configuration or on the boot environment.  Once when a bus
number change happens, the binding fails, resulting in the silence.

This patch tries to make the matching a bit more relaxed, allowing to
bind with a different bus number (or without it).  So the previous
fix, the introduction of ALC245_FIXUP_CS35L41_SPI1_2 fixup became
superfluous, and this is unified to ALC245_FIXUP_CS35L41_SPI_2.

Fixes: 225f6e1bc151 ("ALSA: hda/realtek: Add quirk for HP Zbook Firefly 14 G9 model")
Link: https://lore.kernel.org/r/20220930084810.10435-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 62 +++++++++++++++++++++--------------
 1 file changed, 37 insertions(+), 25 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index bf58e98c7a69..d8c6af9e43ad 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/input.h>
 #include <linux/leds.h>
+#include <linux/ctype.h>
 #include <sound/core.h>
 #include <sound/jack.h>
 #include <sound/hda_codec.h>
@@ -6704,23 +6705,51 @@ static void comp_generic_playback_hook(struct hda_pcm_stream *hinfo, struct hda_
 	}
 }
 
+struct cs35l41_dev_name {
+	const char *bus;
+	const char *hid;
+	int index;
+};
+
+/* match the device name in a slightly relaxed manner */
+static int comp_match_cs35l41_dev_name(struct device *dev, void *data)
+{
+	struct cs35l41_dev_name *p = data;
+	const char *d = dev_name(dev);
+	int n = strlen(p->bus);
+	char tmp[32];
+
+	/* check the bus name */
+	if (strncmp(d, p->bus, n))
+		return 0;
+	/* skip the bus number */
+	if (isdigit(d[n]))
+		n++;
+	/* the rest must be exact matching */
+	snprintf(tmp, sizeof(tmp), "-%s:00-cs35l41-hda.%d", p->hid, p->index);
+	return !strcmp(d + n, tmp);
+}
+
 static void cs35l41_generic_fixup(struct hda_codec *cdc, int action, const char *bus,
 				  const char *hid, int count)
 {
 	struct device *dev = hda_codec_dev(cdc);
 	struct alc_spec *spec = cdc->spec;
-	char *name;
+	struct cs35l41_dev_name *rec;
 	int ret, i;
 
 	switch (action) {
 	case HDA_FIXUP_ACT_PRE_PROBE:
 		for (i = 0; i < count; i++) {
-			name = devm_kasprintf(dev, GFP_KERNEL,
-					      "%s-%s:00-cs35l41-hda.%d", bus, hid, i);
-			if (!name)
+			rec = devm_kmalloc(dev, sizeof(*rec), GFP_KERNEL);
+			if (!rec)
 				return;
+			rec->bus = bus;
+			rec->hid = hid;
+			rec->index = i;
 			spec->comps[i].codec = cdc;
-			component_match_add(dev, &spec->match, component_compare_dev_name, name);
+			component_match_add(dev, &spec->match,
+					    comp_match_cs35l41_dev_name, rec);
 		}
 		ret = component_master_add_with_match(dev, &comp_master_ops, spec->match);
 		if (ret)
@@ -6738,17 +6767,12 @@ static void cs35l41_fixup_i2c_two(struct hda_codec *cdc, const struct hda_fixup
 
 static void cs35l41_fixup_spi_two(struct hda_codec *codec, const struct hda_fixup *fix, int action)
 {
-	cs35l41_generic_fixup(codec, action, "spi0", "CSC3551", 2);
-}
-
-static void cs35l41_fixup_spi1_two(struct hda_codec *codec, const struct hda_fixup *fix, int action)
-{
-	cs35l41_generic_fixup(codec, action, "spi1", "CSC3551", 2);
+	cs35l41_generic_fixup(codec, action, "spi", "CSC3551", 2);
 }
 
 static void cs35l41_fixup_spi_four(struct hda_codec *codec, const struct hda_fixup *fix, int action)
 {
-	cs35l41_generic_fixup(codec, action, "spi0", "CSC3551", 4);
+	cs35l41_generic_fixup(codec, action, "spi", "CSC3551", 4);
 }
 
 static void alc287_fixup_legion_16achg6_speakers(struct hda_codec *cdc, const struct hda_fixup *fix,
@@ -7137,8 +7161,6 @@ enum {
 	ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED,
 	ALC245_FIXUP_CS35L41_SPI_2,
 	ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED,
-	ALC245_FIXUP_CS35L41_SPI1_2,
-	ALC245_FIXUP_CS35L41_SPI1_2_HP_GPIO_LED,
 	ALC245_FIXUP_CS35L41_SPI_4,
 	ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED,
 	ALC285_FIXUP_HP_SPEAKERS_MICMUTE_LED,
@@ -8988,16 +9010,6 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC285_FIXUP_HP_GPIO_LED,
 	},
-	[ALC245_FIXUP_CS35L41_SPI1_2] = {
-		.type = HDA_FIXUP_FUNC,
-		.v.func = cs35l41_fixup_spi1_two,
-	},
-	[ALC245_FIXUP_CS35L41_SPI1_2_HP_GPIO_LED] = {
-		.type = HDA_FIXUP_FUNC,
-		.v.func = cs35l41_fixup_spi1_two,
-		.chained = true,
-		.chain_id = ALC285_FIXUP_HP_GPIO_LED,
-	},
 	[ALC245_FIXUP_CS35L41_SPI_4] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = cs35l41_fixup_spi_four,
@@ -9361,7 +9373,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8aa3, "HP ProBook 450 G9 (MB 8AA1)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8aa8, "HP EliteBook 640 G9 (MB 8AA6)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8aab, "HP EliteBook 650 G9 (MB 8AA9)", ALC236_FIXUP_HP_GPIO_LED),
-	 SND_PCI_QUIRK(0x103c, 0x8abb, "HP ZBook Firefly 14 G9", ALC245_FIXUP_CS35L41_SPI1_2_HP_GPIO_LED),
+	 SND_PCI_QUIRK(0x103c, 0x8abb, "HP ZBook Firefly 14 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ad1, "HP EliteBook 840 14 inch G9 Notebook PC", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ad2, "HP EliteBook 860 16 inch G9 Notebook PC", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
-- 
2.35.1



