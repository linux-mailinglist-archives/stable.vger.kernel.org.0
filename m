Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3594593AF1
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242911AbiHOUF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243529AbiHOUEk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:04:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AAEB7FE41;
        Mon, 15 Aug 2022 11:54:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0968B61029;
        Mon, 15 Aug 2022 18:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F100EC433D7;
        Mon, 15 Aug 2022 18:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589670;
        bh=UKoz1PGPR+E+r9maSyIwijWrm6IDiVNZfDrz561NEUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jXV6p5fzexoIxPkOp3TDn+y2UgDaYm8BwxEgrIfnCa6CASi18tlRLlAJeq0Jc16Wu
         N5y0zna/AzHh1iWJcDqWuxtMMKGePAKvsSPppwINCaOw1jF/RbitUdpMY7HgRjgzCo
         vSy8FziK60kcdiZS8et2oq7ykeiUBnHSIqRgQOyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Jungkamp <p.jungkamp@gmx.net>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.18 0012/1095] ALSA: hda/realtek: Add quirk for Lenovo Yoga9 14IAP7
Date:   Mon, 15 Aug 2022 19:50:11 +0200
Message-Id: <20220815180429.829496146@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Jungkamp <p.jungkamp@gmx.net>

commit 3790a3d6dbbc48e30586e9c3fc752a00e2e11946 upstream.

The Lenovo Yoga 9 14IAP7 is set up similarly to the Thinkpad X1 7th and
8th Gen. It also has the speakers attached to NID 0x14 and the bass
speakers to NID 0x17, but here the codec misreports the NID 0x17 as
unconnected.

The pincfg and hda verbs connect and activate the bass speaker
amplifiers, but the generic driver will connect them to NID 0x06 which
has no volume control. Set connection list/preferred connections is
required to gain volume control.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=208555
Signed-off-by: Philipp Jungkamp <p.jungkamp@gmx.net>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220729162103.6062-1-p.jungkamp@gmx.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |  109 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 109 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6839,6 +6839,43 @@ static void alc_fixup_dell4_mic_no_prese
 	}
 }
 
+static void alc287_fixup_yoga9_14iap7_bass_spk_pin(struct hda_codec *codec,
+					  const struct hda_fixup *fix, int action)
+{
+	/*
+	 * The Pin Complex 0x17 for the bass speakers is wrongly reported as
+	 * unconnected.
+	 */
+	static const struct hda_pintbl pincfgs[] = {
+		{ 0x17, 0x90170121 },
+		{ }
+	};
+	/*
+	 * Avoid DAC 0x06 and 0x08, as they have no volume controls.
+	 * DAC 0x02 and 0x03 would be fine.
+	 */
+	static const hda_nid_t conn[] = { 0x02, 0x03 };
+	/*
+	 * Prefer both speakerbar (0x14) and bass speakers (0x17) connected to DAC 0x02.
+	 * Headphones (0x21) are connected to DAC 0x03.
+	 */
+	static const hda_nid_t preferred_pairs[] = {
+		0x14, 0x02,
+		0x17, 0x02,
+		0x21, 0x03,
+		0
+	};
+	struct alc_spec *spec = codec->spec;
+
+	switch (action) {
+	case HDA_FIXUP_ACT_PRE_PROBE:
+		snd_hda_apply_pincfgs(codec, pincfgs);
+		snd_hda_override_conn_list(codec, 0x17, ARRAY_SIZE(conn), conn);
+		spec->gen.preferred_dacs = preferred_pairs;
+		break;
+	}
+}
+
 enum {
 	ALC269_FIXUP_GPIO2,
 	ALC269_FIXUP_SONY_VAIO,
@@ -7075,6 +7112,8 @@ enum {
 	ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED,
 	ALC285_FIXUP_HP_SPEAKERS_MICMUTE_LED,
 	ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE,
+	ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK,
+	ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -8917,6 +8956,74 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC
 	},
+	[ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			// enable left speaker
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x24 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x41 },
+
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0xc },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x1a },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0xf },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x42 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x10 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x40 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x2 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+
+			// enable right speaker
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x24 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x46 },
+
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0xc },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x2a },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0xf },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x46 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x10 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x44 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x2 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+
+			{ },
+		},
+	},
+	[ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc287_fixup_yoga9_14iap7_bass_spk_pin,
+		.chained = true,
+		.chain_id = ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -9370,6 +9477,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x3176, "ThinkCentre Station", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3178, "ThinkCentre Station", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x31af, "ThinkCentre Station", ALC623_FIXUP_LENOVO_THINKSTATION_P340),
+	SND_PCI_QUIRK(0x17aa, 0x3801, "Lenovo Yoga9 14IAP7", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3802, "Lenovo Yoga DuetITL 2021", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3813, "Legion 7i 15IMHG05", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3818, "Lenovo C940 / Yoga Duet 7", ALC298_FIXUP_LENOVO_C940_DUET7),
@@ -9615,6 +9723,7 @@ static const struct hda_model_fixup alc2
 	{.id = ALC285_FIXUP_HP_SPECTRE_X360, .name = "alc285-hp-spectre-x360"},
 	{.id = ALC285_FIXUP_HP_SPECTRE_X360_EB1, .name = "alc285-hp-spectre-x360-eb1"},
 	{.id = ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP, .name = "alc287-ideapad-bass-spk-amp"},
+	{.id = ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN, .name = "alc287-yoga9-bass-spk-pin"},
 	{.id = ALC623_FIXUP_LENOVO_THINKSTATION_P340, .name = "alc623-lenovo-thinkstation-p340"},
 	{.id = ALC255_FIXUP_ACER_HEADPHONE_AND_MIC, .name = "alc255-acer-headphone-and-mic"},
 	{.id = ALC285_FIXUP_HP_GPIO_AMP_INIT, .name = "alc285-hp-amp-init"},


