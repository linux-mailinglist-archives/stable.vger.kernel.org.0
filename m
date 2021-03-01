Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E32932911F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243246AbhCAUTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:19:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:39932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242662AbhCAUMI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:12:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A548A64F11;
        Mon,  1 Mar 2021 18:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621671;
        bh=rEMFEs4meQcHSpuNcflRtLxgpxQkIL2cAepKw1jjmw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cKn7SHM1PtdjaC6COXBFPNAuMkqNcYNpE7eregL9dQHaqGboRiT2TqV65YuIrR36T
         k72u4erTH508BggTrwSbtwgqU3H0+031O3HkzOqT8KRpep4bT5C5vkAiz7G7f1gxjj
         uGX0eyAPXcxXYV9vVk5bd892pXqUBkmLzFFIPjSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 602/775] ALSA: hda/realtek: Quirk for HP Spectre x360 14 amp setup
Date:   Mon,  1 Mar 2021 17:12:50 +0100
Message-Id: <20210301161231.160061851@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit c3bb2b521944ffbbc8c24b849f81977a9915fb5e upstream.

HP Spectre x360 14 model (PCI SSID 103c:87f7) seems requiring a unique
setup for its external amp: the GPIO0 needs to be toggled on and off
shortly at each device initialization via runtime PM.

This patch implements that workaround as well as the model option
string, so that users with other devices may try the same workaround
more easily.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=210633
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210215082540.4520-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4291,6 +4291,28 @@ static void alc280_fixup_hp_gpio4(struct
 	}
 }
 
+/* HP Spectre x360 14 model needs a unique workaround for enabling the amp;
+ * it needs to toggle the GPIO0 once on and off at each time (bko#210633)
+ */
+static void alc245_fixup_hp_x360_amp(struct hda_codec *codec,
+				     const struct hda_fixup *fix, int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	switch (action) {
+	case HDA_FIXUP_ACT_PRE_PROBE:
+		spec->gpio_mask |= 0x01;
+		spec->gpio_dir |= 0x01;
+		break;
+	case HDA_FIXUP_ACT_INIT:
+		/* need to toggle GPIO to enable the amp */
+		alc_update_gpio_data(codec, 0x01, true);
+		msleep(100);
+		alc_update_gpio_data(codec, 0x01, false);
+		break;
+	}
+}
+
 static void alc_update_coef_led(struct hda_codec *codec,
 				struct alc_coef_led *led,
 				bool polarity, bool on)
@@ -6277,6 +6299,7 @@ enum {
 	ALC280_FIXUP_HP_DOCK_PINS,
 	ALC269_FIXUP_HP_DOCK_GPIO_MIC1_LED,
 	ALC280_FIXUP_HP_9480M,
+	ALC245_FIXUP_HP_X360_AMP,
 	ALC288_FIXUP_DELL_HEADSET_MODE,
 	ALC288_FIXUP_DELL1_MIC_NO_PRESENCE,
 	ALC288_FIXUP_DELL_XPS_13,
@@ -6982,6 +7005,10 @@ static const struct hda_fixup alc269_fix
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc280_fixup_hp_9480m,
 	},
+	[ALC245_FIXUP_HP_X360_AMP] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc245_fixup_hp_x360_amp,
+	},
 	[ALC288_FIXUP_DELL_HEADSET_MODE] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc_fixup_headset_mode_dell_alc288,
@@ -7996,6 +8023,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f4, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f5, "HP", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x87f7, "HP Spectre x360 14", ALC245_FIXUP_HP_X360_AMP),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
@@ -8368,6 +8396,7 @@ static const struct hda_model_fixup alc2
 	{.id = ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET, .name = "alc298-samsung-headphone"},
 	{.id = ALC255_FIXUP_XIAOMI_HEADSET_MIC, .name = "alc255-xiaomi-headset"},
 	{.id = ALC274_FIXUP_HP_MIC, .name = "alc274-hp-mic-detect"},
+	{.id = ALC245_FIXUP_HP_X360_AMP, .name = "alc245-hp-x360-amp"},
 	{}
 };
 #define ALC225_STANDARD_PINS \


