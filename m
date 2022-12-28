Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25F346584D8
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbiL1RDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234867AbiL1RCv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:02:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB121D65E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:56:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BCD3B8188A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:56:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F408C433EF;
        Wed, 28 Dec 2022 16:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246610;
        bh=dWOUIC4lWl1H/r/f0Yhnw95AW1Fz3+G6gkfyIPLXOvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1mlnjzwZdmZBqJMEl0ijubn39bgMz0gxHrhx8LaeAPH7D1Zo9IVEJoukb2CnQOTD3
         CfrwYmnKJ9nhuBPnHKnQXTAGvxh7tu/X+gkprUeRyb81JX/GwTkulKvl9r4XysfLL7
         tvq3GXxrP8mKleK2QcM+yVYvA+hh70YdbNKLmudo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Edward Pacman <edward@edward-p.xyz>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 1100/1146] ALSA: hda/realtek: Add quirk for Lenovo TianYi510Pro-14IOB
Date:   Wed, 28 Dec 2022 15:43:59 +0100
Message-Id: <20221228144400.042505459@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Edward Pacman <edward@edward-p.xyz>

commit 4bf5bf54476dffe60e6b6d8d539f67309ff599e2 upstream.

Lenovo TianYi510Pro-14IOB (17aa:3742)
require quirk for enabling headset-mic

Signed-off-by: Edward Pacman <edward@edward-p.xyz>
Cc: <stable@vger.kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216756
Link: https://lore.kernel.org/r/20221207133218.18989-1-edward@edward-p.xyz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10962,6 +10962,17 @@ static void alc897_fixup_lenovo_headset_
 	}
 }
 
+static void alc897_fixup_lenovo_headset_mode(struct hda_codec *codec,
+				     const struct hda_fixup *fix, int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
+		spec->parse_flags |= HDA_PINCFG_HEADSET_MIC;
+		spec->gen.hp_automute_hook = alc897_hp_automute_hook;
+	}
+}
+
 static const struct coef_fw alc668_coefs[] = {
 	WRITE_COEF(0x01, 0xbebe), WRITE_COEF(0x02, 0xaaaa), WRITE_COEF(0x03,    0x0),
 	WRITE_COEF(0x04, 0x0180), WRITE_COEF(0x06,    0x0), WRITE_COEF(0x07, 0x0f80),
@@ -11045,6 +11056,8 @@ enum {
 	ALC897_FIXUP_LENOVO_HEADSET_MIC,
 	ALC897_FIXUP_HEADSET_MIC_PIN,
 	ALC897_FIXUP_HP_HSMIC_VERB,
+	ALC897_FIXUP_LENOVO_HEADSET_MODE,
+	ALC897_FIXUP_HEADSET_MIC_PIN2,
 };
 
 static const struct hda_fixup alc662_fixups[] = {
@@ -11471,6 +11484,19 @@ static const struct hda_fixup alc662_fix
 			{ }
 		},
 	},
+	[ALC897_FIXUP_LENOVO_HEADSET_MODE] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc897_fixup_lenovo_headset_mode,
+	},
+	[ALC897_FIXUP_HEADSET_MIC_PIN2] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x1a, 0x01a11140 }, /* use as headset mic, without its own jack detect */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC897_FIXUP_LENOVO_HEADSET_MODE
+	},
 };
 
 static const struct snd_pci_quirk alc662_fixup_tbl[] = {
@@ -11523,6 +11549,7 @@ static const struct snd_pci_quirk alc662
 	SND_PCI_QUIRK(0x17aa, 0x32cb, "Lenovo ThinkCentre M70", ALC897_FIXUP_HEADSET_MIC_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x32cf, "Lenovo ThinkCentre M950", ALC897_FIXUP_HEADSET_MIC_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x32f7, "Lenovo ThinkCentre M90", ALC897_FIXUP_HEADSET_MIC_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x3742, "Lenovo TianYi510Pro-14IOB", ALC897_FIXUP_HEADSET_MIC_PIN2),
 	SND_PCI_QUIRK(0x17aa, 0x38af, "Lenovo Ideapad Y550P", ALC662_FIXUP_IDEAPAD),
 	SND_PCI_QUIRK(0x17aa, 0x3a0d, "Lenovo Ideapad Y550", ALC662_FIXUP_IDEAPAD),
 	SND_PCI_QUIRK(0x1849, 0x5892, "ASRock B150M", ALC892_FIXUP_ASROCK_MOBO),


