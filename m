Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E3A469DEF
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388722AbhLFPei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376273AbhLFP2r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:28:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC50C08ED39;
        Mon,  6 Dec 2021 07:18:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78DF6B81134;
        Mon,  6 Dec 2021 15:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E55C341C1;
        Mon,  6 Dec 2021 15:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803880;
        bh=ctAN86+aLtUg4P4YugcH9097oNHEOyVGq7zN1p44ofQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LEHCC29zkrQHahjfGjfsSvOsUBz8qNoiXNLGea2lhURcxNUki34QV2obqzQMEgYP5
         2fGBbNrlGNtSWFqIHowOsVGsXBcMJKODZh/X+pDpXPIa9anuizkecV1670Ro8Wzexg
         Ykzj8nUx9zZquVqzQBUmK9tzMVA9fDKVm6g4w1/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Mark Brown <broonie@kernel.org>,
        Sameer Pujar <spujar@nvidia.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 080/130] ASoC: tegra: Fix kcontrol put callback in DMIC
Date:   Mon,  6 Dec 2021 15:56:37 +0100
Message-Id: <20211206145602.434604446@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sameer Pujar <spujar@nvidia.com>

commit a347dfa10262fa0a10e2b1970ea0194e3d4a3251 upstream.

The kcontrol put callback is expected to return 1 when there is change
in HW or when the update is acknowledged by driver. This would ensure
that change notifications are sent to subscribed applications. Update
the DMIC driver accordingly.

Fixes: 8c8ff982e9e2 ("ASoC: tegra: Add Tegra210 based DMIC driver")
Suggested-by: Jaroslav Kysela <perex@perex.cz>
Suggested-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/1637219231-406-10-git-send-email-spujar@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/tegra/tegra210_dmic.c |  183 ++++++++++++++++++++++++++++++++--------
 1 file changed, 149 insertions(+), 34 deletions(-)

--- a/sound/soc/tegra/tegra210_dmic.c
+++ b/sound/soc/tegra/tegra210_dmic.c
@@ -156,50 +156,162 @@ static int tegra210_dmic_hw_params(struc
 	return 0;
 }
 
-static int tegra210_dmic_get_control(struct snd_kcontrol *kcontrol,
+static int tegra210_dmic_get_boost_gain(struct snd_kcontrol *kcontrol,
+					struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *comp = snd_soc_kcontrol_component(kcontrol);
+	struct tegra210_dmic *dmic = snd_soc_component_get_drvdata(comp);
+
+	ucontrol->value.integer.value[0] = dmic->boost_gain;
+
+	return 0;
+}
+
+static int tegra210_dmic_put_boost_gain(struct snd_kcontrol *kcontrol,
+					struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *comp = snd_soc_kcontrol_component(kcontrol);
+	struct tegra210_dmic *dmic = snd_soc_component_get_drvdata(comp);
+	int value = ucontrol->value.integer.value[0];
+
+	if (value == dmic->boost_gain)
+		return 0;
+
+	dmic->boost_gain = value;
+
+	return 1;
+}
+
+static int tegra210_dmic_get_ch_select(struct snd_kcontrol *kcontrol,
+				       struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *comp = snd_soc_kcontrol_component(kcontrol);
+	struct tegra210_dmic *dmic = snd_soc_component_get_drvdata(comp);
+
+	ucontrol->value.enumerated.item[0] = dmic->ch_select;
+
+	return 0;
+}
+
+static int tegra210_dmic_put_ch_select(struct snd_kcontrol *kcontrol,
+				       struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *comp = snd_soc_kcontrol_component(kcontrol);
+	struct tegra210_dmic *dmic = snd_soc_component_get_drvdata(comp);
+	unsigned int value = ucontrol->value.enumerated.item[0];
+
+	if (value == dmic->ch_select)
+		return 0;
+
+	dmic->ch_select = value;
+
+	return 1;
+}
+
+static int tegra210_dmic_get_mono_to_stereo(struct snd_kcontrol *kcontrol,
+					    struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *comp = snd_soc_kcontrol_component(kcontrol);
+	struct tegra210_dmic *dmic = snd_soc_component_get_drvdata(comp);
+
+	ucontrol->value.enumerated.item[0] = dmic->mono_to_stereo;
+
+	return 0;
+}
+
+static int tegra210_dmic_put_mono_to_stereo(struct snd_kcontrol *kcontrol,
+					    struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *comp = snd_soc_kcontrol_component(kcontrol);
+	struct tegra210_dmic *dmic = snd_soc_component_get_drvdata(comp);
+	unsigned int value = ucontrol->value.enumerated.item[0];
+
+	if (value == dmic->mono_to_stereo)
+		return 0;
+
+	dmic->mono_to_stereo = value;
+
+	return 1;
+}
+
+static int tegra210_dmic_get_stereo_to_mono(struct snd_kcontrol *kcontrol,
+					    struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *comp = snd_soc_kcontrol_component(kcontrol);
+	struct tegra210_dmic *dmic = snd_soc_component_get_drvdata(comp);
+
+	ucontrol->value.enumerated.item[0] = dmic->stereo_to_mono;
+
+	return 0;
+}
+
+static int tegra210_dmic_put_stereo_to_mono(struct snd_kcontrol *kcontrol,
+					    struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *comp = snd_soc_kcontrol_component(kcontrol);
+	struct tegra210_dmic *dmic = snd_soc_component_get_drvdata(comp);
+	unsigned int value = ucontrol->value.enumerated.item[0];
+
+	if (value == dmic->stereo_to_mono)
+		return 0;
+
+	dmic->stereo_to_mono = value;
+
+	return 1;
+}
+
+static int tegra210_dmic_get_osr_val(struct snd_kcontrol *kcontrol,
 				     struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_component *comp = snd_soc_kcontrol_component(kcontrol);
 	struct tegra210_dmic *dmic = snd_soc_component_get_drvdata(comp);
 
-	if (strstr(kcontrol->id.name, "Boost Gain Volume"))
-		ucontrol->value.integer.value[0] = dmic->boost_gain;
-	else if (strstr(kcontrol->id.name, "Channel Select"))
-		ucontrol->value.enumerated.item[0] = dmic->ch_select;
-	else if (strstr(kcontrol->id.name, "Mono To Stereo"))
-		ucontrol->value.enumerated.item[0] = dmic->mono_to_stereo;
-	else if (strstr(kcontrol->id.name, "Stereo To Mono"))
-		ucontrol->value.enumerated.item[0] = dmic->stereo_to_mono;
-	else if (strstr(kcontrol->id.name, "OSR Value"))
-		ucontrol->value.enumerated.item[0] = dmic->osr_val;
-	else if (strstr(kcontrol->id.name, "LR Polarity Select"))
-		ucontrol->value.enumerated.item[0] = dmic->lrsel;
+	ucontrol->value.enumerated.item[0] = dmic->osr_val;
 
 	return 0;
 }
 
-static int tegra210_dmic_put_control(struct snd_kcontrol *kcontrol,
+static int tegra210_dmic_put_osr_val(struct snd_kcontrol *kcontrol,
+				     struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *comp = snd_soc_kcontrol_component(kcontrol);
+	struct tegra210_dmic *dmic = snd_soc_component_get_drvdata(comp);
+	unsigned int value = ucontrol->value.enumerated.item[0];
+
+	if (value == dmic->osr_val)
+		return 0;
+
+	dmic->osr_val = value;
+
+	return 1;
+}
+
+static int tegra210_dmic_get_pol_sel(struct snd_kcontrol *kcontrol,
 				     struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_component *comp = snd_soc_kcontrol_component(kcontrol);
 	struct tegra210_dmic *dmic = snd_soc_component_get_drvdata(comp);
 
-	if (strstr(kcontrol->id.name, "Boost Gain Volume"))
-		dmic->boost_gain = ucontrol->value.integer.value[0];
-	else if (strstr(kcontrol->id.name, "Channel Select"))
-		dmic->ch_select = ucontrol->value.enumerated.item[0];
-	else if (strstr(kcontrol->id.name, "Mono To Stereo"))
-		dmic->mono_to_stereo = ucontrol->value.enumerated.item[0];
-	else if (strstr(kcontrol->id.name, "Stereo To Mono"))
-		dmic->stereo_to_mono = ucontrol->value.enumerated.item[0];
-	else if (strstr(kcontrol->id.name, "OSR Value"))
-		dmic->osr_val = ucontrol->value.enumerated.item[0];
-	else if (strstr(kcontrol->id.name, "LR Polarity Select"))
-		dmic->lrsel = ucontrol->value.enumerated.item[0];
+	ucontrol->value.enumerated.item[0] = dmic->lrsel;
 
 	return 0;
 }
 
+static int tegra210_dmic_put_pol_sel(struct snd_kcontrol *kcontrol,
+				     struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *comp = snd_soc_kcontrol_component(kcontrol);
+	struct tegra210_dmic *dmic = snd_soc_component_get_drvdata(comp);
+	unsigned int value = ucontrol->value.enumerated.item[0];
+
+	if (value == dmic->lrsel)
+		return 0;
+
+	dmic->lrsel = value;
+
+	return 1;
+}
+
 static const struct snd_soc_dai_ops tegra210_dmic_dai_ops = {
 	.hw_params	= tegra210_dmic_hw_params,
 };
@@ -286,19 +398,22 @@ static const struct soc_enum tegra210_dm
 
 static const struct snd_kcontrol_new tegra210_dmic_controls[] = {
 	SOC_SINGLE_EXT("Boost Gain Volume", 0, 0, MAX_BOOST_GAIN, 0,
-		       tegra210_dmic_get_control, tegra210_dmic_put_control),
+		       tegra210_dmic_get_boost_gain,
+		       tegra210_dmic_put_boost_gain),
 	SOC_ENUM_EXT("Channel Select", tegra210_dmic_ch_enum,
-		     tegra210_dmic_get_control, tegra210_dmic_put_control),
+		     tegra210_dmic_get_ch_select, tegra210_dmic_put_ch_select),
 	SOC_ENUM_EXT("Mono To Stereo",
-		     tegra210_dmic_mono_conv_enum, tegra210_dmic_get_control,
-		     tegra210_dmic_put_control),
+		     tegra210_dmic_mono_conv_enum,
+		     tegra210_dmic_get_mono_to_stereo,
+		     tegra210_dmic_put_mono_to_stereo),
 	SOC_ENUM_EXT("Stereo To Mono",
-		     tegra210_dmic_stereo_conv_enum, tegra210_dmic_get_control,
-		     tegra210_dmic_put_control),
+		     tegra210_dmic_stereo_conv_enum,
+		     tegra210_dmic_get_stereo_to_mono,
+		     tegra210_dmic_put_stereo_to_mono),
 	SOC_ENUM_EXT("OSR Value", tegra210_dmic_osr_enum,
-		     tegra210_dmic_get_control, tegra210_dmic_put_control),
+		     tegra210_dmic_get_osr_val, tegra210_dmic_put_osr_val),
 	SOC_ENUM_EXT("LR Polarity Select", tegra210_dmic_lrsel_enum,
-		     tegra210_dmic_get_control, tegra210_dmic_put_control),
+		     tegra210_dmic_get_pol_sel, tegra210_dmic_put_pol_sel),
 };
 
 static const struct snd_soc_component_driver tegra210_dmic_compnt = {


