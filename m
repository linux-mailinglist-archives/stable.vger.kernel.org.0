Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4456422F09B
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731577AbgG0O0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:26:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732547AbgG0O0D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:26:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1375520838;
        Mon, 27 Jul 2020 14:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859962;
        bh=ep+d7Iv3rXTIYLLXt+Mv1bQln7FvbbqZkmnX3wbQM+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=md2rF+uOelaF7J097qGRfPJcv9O5m+ccwLJehlF5E5y4zV4W2J38cTUZ3MIi3RrKt
         UUcowL8wR0Zp0A1uUQNdMu+DduFkN8rdvcET69KtC5yzb9eSfWqT+UMQdnuUvHKQna
         8RZoLb4Mz1nbVw9FtS04J6iJgzoSeG3HjEn0xZ/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.7 172/179] ASoC: rt5670: Add new gpio1_is_ext_spk_en quirk and enable it on the Lenovo Miix 2 10
Date:   Mon, 27 Jul 2020 16:05:47 +0200
Message-Id: <20200727134941.037310637@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 85ca6b17e2bb96b19caac3b02c003d670b66de96 upstream.

The Lenovo Miix 2 10 has a keyboard dock with extra speakers in the dock.
Rather then the ACL5672's GPIO1 pin being used as IRQ to the CPU, it is
actually used to enable the amplifier for these speakers
(the IRQ to the CPU comes directly from the jack-detect switch).

Add a quirk for having an ext speaker-amplifier enable pin on GPIO1
and replace the Lenovo Miix 2 10's dmi_system_id table entry's wrong
GPIO_DEV quirk (which needs to be renamed to GPIO1_IS_IRQ) with the
new RT5670_GPIO1_IS_EXT_SPK_EN quirk, so that we enable the external
speaker-amplifier as necessary.

Also update the ident field for the dmi_system_id table entry, the
Miix models are not Thinkpads.

Fixes: 67e03ff3f32f ("ASoC: codecs: rt5670: add Thinkpad Tablet 10 quirk")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1786723
Link: https://lore.kernel.org/r/20200628155231.71089-4-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/sound/rt5670.h    |    1 
 sound/soc/codecs/rt5670.c |   71 ++++++++++++++++++++++++++++++++++++----------
 2 files changed, 57 insertions(+), 15 deletions(-)

--- a/include/sound/rt5670.h
+++ b/include/sound/rt5670.h
@@ -12,6 +12,7 @@ struct rt5670_platform_data {
 	int jd_mode;
 	bool in2_diff;
 	bool dev_gpio;
+	bool gpio1_is_ext_spk_en;
 
 	bool dmic_en;
 	unsigned int dmic1_data_pin;
--- a/sound/soc/codecs/rt5670.c
+++ b/sound/soc/codecs/rt5670.c
@@ -31,18 +31,19 @@
 #include "rt5670.h"
 #include "rt5670-dsp.h"
 
-#define RT5670_DEV_GPIO     BIT(0)
-#define RT5670_IN2_DIFF     BIT(1)
-#define RT5670_DMIC_EN      BIT(2)
-#define RT5670_DMIC1_IN2P   BIT(3)
-#define RT5670_DMIC1_GPIO6  BIT(4)
-#define RT5670_DMIC1_GPIO7  BIT(5)
-#define RT5670_DMIC2_INR    BIT(6)
-#define RT5670_DMIC2_GPIO8  BIT(7)
-#define RT5670_DMIC3_GPIO5  BIT(8)
-#define RT5670_JD_MODE1     BIT(9)
-#define RT5670_JD_MODE2     BIT(10)
-#define RT5670_JD_MODE3     BIT(11)
+#define RT5670_DEV_GPIO			BIT(0)
+#define RT5670_IN2_DIFF			BIT(1)
+#define RT5670_DMIC_EN			BIT(2)
+#define RT5670_DMIC1_IN2P		BIT(3)
+#define RT5670_DMIC1_GPIO6		BIT(4)
+#define RT5670_DMIC1_GPIO7		BIT(5)
+#define RT5670_DMIC2_INR		BIT(6)
+#define RT5670_DMIC2_GPIO8		BIT(7)
+#define RT5670_DMIC3_GPIO5		BIT(8)
+#define RT5670_JD_MODE1			BIT(9)
+#define RT5670_JD_MODE2			BIT(10)
+#define RT5670_JD_MODE3			BIT(11)
+#define RT5670_GPIO1_IS_EXT_SPK_EN	BIT(12)
 
 static unsigned long rt5670_quirk;
 static unsigned int quirk_override;
@@ -1447,6 +1448,33 @@ static int rt5670_hp_event(struct snd_so
 	return 0;
 }
 
+static int rt5670_spk_event(struct snd_soc_dapm_widget *w,
+	struct snd_kcontrol *kcontrol, int event)
+{
+	struct snd_soc_component *component = snd_soc_dapm_to_component(w->dapm);
+	struct rt5670_priv *rt5670 = snd_soc_component_get_drvdata(component);
+
+	if (!rt5670->pdata.gpio1_is_ext_spk_en)
+		return 0;
+
+	switch (event) {
+	case SND_SOC_DAPM_POST_PMU:
+		regmap_update_bits(rt5670->regmap, RT5670_GPIO_CTRL2,
+				   RT5670_GP1_OUT_MASK, RT5670_GP1_OUT_HI);
+		break;
+
+	case SND_SOC_DAPM_PRE_PMD:
+		regmap_update_bits(rt5670->regmap, RT5670_GPIO_CTRL2,
+				   RT5670_GP1_OUT_MASK, RT5670_GP1_OUT_LO);
+		break;
+
+	default:
+		return 0;
+	}
+
+	return 0;
+}
+
 static int rt5670_bst1_event(struct snd_soc_dapm_widget *w,
 	struct snd_kcontrol *kcontrol, int event)
 {
@@ -1860,7 +1888,9 @@ static const struct snd_soc_dapm_widget
 };
 
 static const struct snd_soc_dapm_widget rt5672_specific_dapm_widgets[] = {
-	SND_SOC_DAPM_PGA("SPO Amp", SND_SOC_NOPM, 0, 0, NULL, 0),
+	SND_SOC_DAPM_PGA_E("SPO Amp", SND_SOC_NOPM, 0, 0, NULL, 0,
+			   rt5670_spk_event, SND_SOC_DAPM_PRE_PMD |
+			   SND_SOC_DAPM_POST_PMU),
 	SND_SOC_DAPM_OUTPUT("SPOLP"),
 	SND_SOC_DAPM_OUTPUT("SPOLN"),
 	SND_SOC_DAPM_OUTPUT("SPORP"),
@@ -2857,14 +2887,14 @@ static const struct dmi_system_id dmi_pl
 	},
 	{
 		.callback = rt5670_quirk_cb,
-		.ident = "Lenovo Thinkpad Tablet 10",
+		.ident = "Lenovo Miix 2 10",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo Miix 2 10"),
 		},
 		.driver_data = (unsigned long *)(RT5670_DMIC_EN |
 						 RT5670_DMIC1_IN2P |
-						 RT5670_DEV_GPIO |
+						 RT5670_GPIO1_IS_EXT_SPK_EN |
 						 RT5670_JD_MODE2),
 	},
 	{
@@ -2924,6 +2954,10 @@ static int rt5670_i2c_probe(struct i2c_c
 		rt5670->pdata.dev_gpio = true;
 		dev_info(&i2c->dev, "quirk dev_gpio\n");
 	}
+	if (rt5670_quirk & RT5670_GPIO1_IS_EXT_SPK_EN) {
+		rt5670->pdata.gpio1_is_ext_spk_en = true;
+		dev_info(&i2c->dev, "quirk GPIO1 is external speaker enable\n");
+	}
 	if (rt5670_quirk & RT5670_IN2_DIFF) {
 		rt5670->pdata.in2_diff = true;
 		dev_info(&i2c->dev, "quirk IN2_DIFF\n");
@@ -3022,6 +3056,13 @@ static int rt5670_i2c_probe(struct i2c_c
 		regmap_update_bits(rt5670->regmap, RT5670_GPIO_CTRL2,
 				   RT5670_GP1_PF_MASK, RT5670_GP1_PF_OUT);
 	}
+
+	if (rt5670->pdata.gpio1_is_ext_spk_en) {
+		regmap_update_bits(rt5670->regmap, RT5670_GPIO_CTRL1,
+				   RT5670_GP1_PIN_MASK, RT5670_GP1_PIN_GPIO1);
+		regmap_update_bits(rt5670->regmap, RT5670_GPIO_CTRL2,
+				   RT5670_GP1_PF_MASK, RT5670_GP1_PF_OUT);
+	}
 
 	if (rt5670->pdata.jd_mode) {
 		regmap_update_bits(rt5670->regmap, RT5670_GLB_CLK,


