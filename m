Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8211455C1D3
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234856AbiF0LZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234789AbiF0LYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:24:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D49446570;
        Mon, 27 Jun 2022 04:24:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E61EB8111E;
        Mon, 27 Jun 2022 11:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9BDC3411D;
        Mon, 27 Jun 2022 11:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329086;
        bh=Xgj1dqUKzp6xWvuluirbzCnrOgVBiBH4xbbDXJS7GeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BQCNIV7BVEr9XgkVhAH+ccT6QEFokszay62XNzPN7DeRZd0aFuIb0RaJzcqoZ+/3H
         TYbhX2pSjlSiC8Q7qkzGtTtupBcKcMz31RCr0N2VhGmIUprC+PgpS7Daj69Ue9ek4Z
         mAutpzVQjGo8N4Rrirk+98pgrkM+ShJSA5AHFYsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        nikitashvets@flyium.com, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 008/102] ALSA: hda/realtek: Apply fixup for Lenovo Yoga Duet 7 properly
Date:   Mon, 27 Jun 2022 13:20:19 +0200
Message-Id: <20220627111933.709907499@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 56ec3e755bd1041d35bdec020a99b327697ee470 upstream.

It turned out that Lenovo shipped two completely different products
with the very same PCI SSID, where both require different quirks;
namely, Lenovo C940 has already the fixup for its speaker
(ALC298_FIXUP_LENOVO_SPK_VOLUME) with the PCI SSID 17aa:3818, while
Yoga Duet 7 has also the very same PCI SSID but requires a different
quirk, ALC287_FIXUP_YOGA7_14TIL_SPEAKERS.

Fortunately, both are with different codecs (C940 with ALC298 and Duet
7 with ALC287), hence we can apply different fixes by checking the
codec ID.  This patch implements that special fixup function.

For easier handling, the internal function for applying a specific
fixup entry is exported as __snd_hda_apply_fixup(), so that it can be
called from the codec driver.  The rest is simply calling it with a
different fixup ID depending on the codec ID.

Reported-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: nikitashvets@flyium.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/5ca147d1-3a2d-60c6-c491-8aa844183222@redhat.com
Link: https://lore.kernel.org/r/20220614054831.14648-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_auto_parser.c |    7 ++++---
 sound/pci/hda/hda_local.h       |    1 +
 sound/pci/hda/patch_realtek.c   |   24 +++++++++++++++++++++++-
 3 files changed, 28 insertions(+), 4 deletions(-)

--- a/sound/pci/hda/hda_auto_parser.c
+++ b/sound/pci/hda/hda_auto_parser.c
@@ -823,7 +823,7 @@ static void set_pin_targets(struct hda_c
 		snd_hda_set_pin_ctl_cache(codec, cfg->nid, cfg->val);
 }
 
-static void apply_fixup(struct hda_codec *codec, int id, int action, int depth)
+void __snd_hda_apply_fixup(struct hda_codec *codec, int id, int action, int depth)
 {
 	const char *modelname = codec->fixup_name;
 
@@ -833,7 +833,7 @@ static void apply_fixup(struct hda_codec
 		if (++depth > 10)
 			break;
 		if (fix->chained_before)
-			apply_fixup(codec, fix->chain_id, action, depth + 1);
+			__snd_hda_apply_fixup(codec, fix->chain_id, action, depth + 1);
 
 		switch (fix->type) {
 		case HDA_FIXUP_PINS:
@@ -874,6 +874,7 @@ static void apply_fixup(struct hda_codec
 		id = fix->chain_id;
 	}
 }
+EXPORT_SYMBOL_GPL(__snd_hda_apply_fixup);
 
 /**
  * snd_hda_apply_fixup - Apply the fixup chain with the given action
@@ -883,7 +884,7 @@ static void apply_fixup(struct hda_codec
 void snd_hda_apply_fixup(struct hda_codec *codec, int action)
 {
 	if (codec->fixup_list)
-		apply_fixup(codec, codec->fixup_id, action, 0);
+		__snd_hda_apply_fixup(codec, codec->fixup_id, action, 0);
 }
 EXPORT_SYMBOL_GPL(snd_hda_apply_fixup);
 
--- a/sound/pci/hda/hda_local.h
+++ b/sound/pci/hda/hda_local.h
@@ -357,6 +357,7 @@ void snd_hda_apply_verbs(struct hda_code
 void snd_hda_apply_pincfgs(struct hda_codec *codec,
 			   const struct hda_pintbl *cfg);
 void snd_hda_apply_fixup(struct hda_codec *codec, int action);
+void __snd_hda_apply_fixup(struct hda_codec *codec, int id, int action, int depth);
 void snd_hda_pick_fixup(struct hda_codec *codec,
 			const struct hda_model_fixup *models,
 			const struct snd_pci_quirk *quirk,
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6827,6 +6827,7 @@ enum {
 	ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS,
 	ALC287_FIXUP_LEGION_15IMHG05_AUTOMUTE,
 	ALC287_FIXUP_YOGA7_14ITL_SPEAKERS,
+	ALC298_FIXUP_LENOVO_C940_DUET7,
 	ALC287_FIXUP_13S_GEN2_SPEAKERS,
 	ALC256_FIXUP_SET_COEF_DEFAULTS,
 	ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE,
@@ -6836,6 +6837,23 @@ enum {
 	ALC285_FIXUP_LEGION_Y9000X_AUTOMUTE,
 };
 
+/* A special fixup for Lenovo C940 and Yoga Duet 7;
+ * both have the very same PCI SSID, and we need to apply different fixups
+ * depending on the codec ID
+ */
+static void alc298_fixup_lenovo_c940_duet7(struct hda_codec *codec,
+					   const struct hda_fixup *fix,
+					   int action)
+{
+	int id;
+
+	if (codec->core.vendor_id == 0x10ec0298)
+		id = ALC298_FIXUP_LENOVO_SPK_VOLUME; /* C940 */
+	else
+		id = ALC287_FIXUP_YOGA7_14ITL_SPEAKERS; /* Duet 7 */
+	__snd_hda_apply_fixup(codec, id, action, 0);
+}
+
 static const struct hda_fixup alc269_fixups[] = {
 	[ALC269_FIXUP_GPIO2] = {
 		.type = HDA_FIXUP_FUNC,
@@ -8529,6 +8547,10 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC269_FIXUP_HEADSET_MODE,
 	},
+	[ALC298_FIXUP_LENOVO_C940_DUET7] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc298_fixup_lenovo_c940_duet7,
+	},
 	[ALC287_FIXUP_13S_GEN2_SPEAKERS] = {
 		.type = HDA_FIXUP_VERBS,
 		.v.verbs = (const struct hda_verb[]) {
@@ -8993,7 +9015,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x31af, "ThinkCentre Station", ALC623_FIXUP_LENOVO_THINKSTATION_P340),
 	SND_PCI_QUIRK(0x17aa, 0x3802, "Lenovo Yoga DuetITL 2021", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3813, "Legion 7i 15IMHG05", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),
-	SND_PCI_QUIRK(0x17aa, 0x3818, "Lenovo C940", ALC298_FIXUP_LENOVO_SPK_VOLUME),
+	SND_PCI_QUIRK(0x17aa, 0x3818, "Lenovo C940 / Yoga Duet 7", ALC298_FIXUP_LENOVO_C940_DUET7),
 	SND_PCI_QUIRK(0x17aa, 0x3819, "Lenovo 13s Gen2 ITL", ALC287_FIXUP_13S_GEN2_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3820, "Yoga Duet 7 13ITL6", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3824, "Legion Y9000X 2020", ALC285_FIXUP_LEGION_Y9000X_SPEAKERS),


