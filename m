Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D663F65B014
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 11:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbjABKys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 05:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbjABKyR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 05:54:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724C465B3
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 02:53:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94A3960F2D
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 10:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1F7C433F0;
        Mon,  2 Jan 2023 10:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672656773;
        bh=UBd7JjlDFNINawTerTFrCj0yw6mFFNMisvszroDIZT4=;
        h=Subject:To:Cc:From:Date:From;
        b=0lR5FOXqgEh/mu9suzpvsza7QINNwicUQdvTGvMCykPEcPlOu68rLpP3XFf7e5iif
         BXleS59z2UbuJ/bQrdOZIfwGuSN2332JVI30CgXe83A2yjDkgU31JT5f1w9bPO2zOs
         z9h6KbdcTx6McR9MFRb+iEHxhGLcuk8kRUdkPIZk=
Subject: FAILED: patch "[PATCH] ALSA: hda/realtek: Apply dual codec fixup for Dell Latitude" failed to apply to 5.10-stable tree
To:     chris.chiu@canonical.com, stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 02 Jan 2023 11:52:46 +0100
Message-ID: <1672656766189240@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

a4517c4f3423 ("ALSA: hda/realtek: Apply dual codec fixup for Dell Latitude laptops")
2912cdda734d ("ALSA: patch_realtek: Fix Dell Inspiron Plus 16")
bdc9b7396f7d ("ALSA: hda/realtek: Enable 4-speaker output Dell Precision 5570 laptop")
3790a3d6dbbc ("ALSA: hda/realtek: Add quirk for Lenovo Yoga9 14IAP7")
1e24881d8b2a ("ALSA: hda: cs35l41: Support CLSA0101")
f81ee579c089 ("ALSA: hda: cs35l41: Use the CS35L41 HDA internal define")
63f4b99f0089 ("ALSA: hda: cs35l41: Support Speaker ID for laptops")
bb6eb621f522 ("ALSA: hda: cs35l41: Support multiple load paths for firmware")
eef375960210 ("ALSA: hda: cs35l41: Support reading subsystem id from ACPI")
e99f3c7e3250 ("ALSA: hda: cs35l41: Save Subsystem ID inside CS35L41 Driver")
2e81e1fffd53 ("ALSA: hda: cs35l41: Add initial DSP support and firmware loading")
22d5cbd273a2 ("ALSA: hda: cs35l41: Save codec object inside component struct")
33c1f401939c ("ALSA: hda: cs35l41: Consolidate selections under SND_HDA_SCODEC_CS35L41")
642999365da3 ("ALSA: hda: cs35l41: Fix comments wrt serial-multi-instantiate reference")
85743a847cae ("ALSA: hda/realtek: Fix for quirk to enable speaker output on the Lenovo Yoga DuetITL 2021")
15dad62f4bdb ("ALSA: hda/realtek: Enable 4-speaker output for Dell XPS 15 9520 laptop")
1212fa1b482e ("Merge branch 'for-linus' into for-next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a4517c4f3423c7c448f2c359218f97c1173523a1 Mon Sep 17 00:00:00 2001
From: Chris Chiu <chris.chiu@canonical.com>
Date: Mon, 26 Dec 2022 19:43:03 +0800
Subject: [PATCH] ALSA: hda/realtek: Apply dual codec fixup for Dell Latitude
 laptops

The Dell Latiture 3340/3440/3540 laptops with Realtek ALC3204 have
dual codecs and need the ALC1220_FIXUP_GB_DUAL_CODECS to fix the
conflicts of Master controls. The existing headset mic fixup for
Dell is also required to enable the jack sense and the headset mic.

Introduce a new fixup to fix the dual codec and headset mic issues
for particular Dell laptops since other old Dell laptops with the
same codec configuration are already well handled by the fixup in
alc269_fallback_pin_fixup_tbl[].

Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221226114303.4027500-1-chris.chiu@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index e443d88f627f..3794b522c222 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7175,6 +7175,7 @@ enum {
 	ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK,
 	ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN,
 	ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS,
+	ALC236_FIXUP_DELL_DUAL_CODECS,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -9130,6 +9131,12 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,
 	},
+	[ALC236_FIXUP_DELL_DUAL_CODECS] = {
+		.type = HDA_FIXUP_PINS,
+		.v.func = alc1220_fixup_gb_dual_codecs,
+		.chained = true,
+		.chain_id = ALC255_FIXUP_DELL1_MIC_NO_PRESENCE,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -9232,6 +9239,12 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x0b1a, "Dell Precision 5570", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x0b37, "Dell Inspiron 16 Plus 7620 2-in-1", ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS),
 	SND_PCI_QUIRK(0x1028, 0x0b71, "Dell Inspiron 16 Plus 7620", ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS),
+	SND_PCI_QUIRK(0x1028, 0x0c19, "Dell Precision 3340", ALC236_FIXUP_DELL_DUAL_CODECS),
+	SND_PCI_QUIRK(0x1028, 0x0c1a, "Dell Precision 3340", ALC236_FIXUP_DELL_DUAL_CODECS),
+	SND_PCI_QUIRK(0x1028, 0x0c1b, "Dell Precision 3440", ALC236_FIXUP_DELL_DUAL_CODECS),
+	SND_PCI_QUIRK(0x1028, 0x0c1c, "Dell Precision 3540", ALC236_FIXUP_DELL_DUAL_CODECS),
+	SND_PCI_QUIRK(0x1028, 0x0c1d, "Dell Precision 3440", ALC236_FIXUP_DELL_DUAL_CODECS),
+	SND_PCI_QUIRK(0x1028, 0x0c1e, "Dell Precision 3540", ALC236_FIXUP_DELL_DUAL_CODECS),
 	SND_PCI_QUIRK(0x1028, 0x164a, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x164b, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1586, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC2),

