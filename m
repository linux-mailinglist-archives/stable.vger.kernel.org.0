Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4B7469C89
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358537AbhLFPXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:23:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54494 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347500AbhLFPV0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:21:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDAECB81126;
        Mon,  6 Dec 2021 15:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B71EC341C2;
        Mon,  6 Dec 2021 15:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803874;
        bh=B1tPb4Y81YUEFcjknVtv2dgfbxahQigJmXfHtEaZks4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qyhGDQBM/OnSl511LmQoB3CnuTziCzIvxztZ68QxhZ5G2fM/67YB6GwkttRmbMQZO
         pG4Wdz1wGyxgt+cdv1GiEQp+gKag94r5J3RBTyYoSrr1vuW+/Ttry1pfARhUp02N+V
         mhl3DRCDC4gkXGte8h+SWr0USOIzKuDd+e9VqGNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Mark Brown <broonie@kernel.org>,
        Sameer Pujar <spujar@nvidia.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 078/130] ASoC: tegra: Fix kcontrol put callback in ADMAIF
Date:   Mon,  6 Dec 2021 15:56:35 +0100
Message-Id: <20211206145602.368698887@linuxfoundation.org>
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

commit e2b87a18a60c02d0dcd1de801d669587e516cc4d upstream.

The kcontrol put callback is expected to return 1 when there is change
in HW or when the update is acknowledged by driver. This would ensure
that change notifications are sent to subscribed applications. Update
the ADMAIF driver accordingly.

Fixes: f74028e159bb ("ASoC: tegra: Add Tegra210 based ADMAIF driver")
Suggested-by: Jaroslav Kysela <perex@perex.cz>
Suggested-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/1637219231-406-8-git-send-email-spujar@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/tegra/tegra210_admaif.c |  138 ++++++++++++++++++++++++++++++--------
 1 file changed, 109 insertions(+), 29 deletions(-)

--- a/sound/soc/tegra/tegra210_admaif.c
+++ b/sound/soc/tegra/tegra210_admaif.c
@@ -424,46 +424,122 @@ static const struct snd_soc_dai_ops tegr
 	.trigger	= tegra_admaif_trigger,
 };
 
-static int tegra_admaif_get_control(struct snd_kcontrol *kcontrol,
-				    struct snd_ctl_elem_value *ucontrol)
+static int tegra210_admaif_pget_mono_to_stereo(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_component *cmpnt = snd_soc_kcontrol_component(kcontrol);
+	struct tegra_admaif *admaif = snd_soc_component_get_drvdata(cmpnt);
 	struct soc_enum *ec = (struct soc_enum *)kcontrol->private_value;
+
+	ucontrol->value.enumerated.item[0] =
+		admaif->mono_to_stereo[ADMAIF_TX_PATH][ec->reg];
+
+	return 0;
+}
+
+static int tegra210_admaif_pput_mono_to_stereo(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *cmpnt = snd_soc_kcontrol_component(kcontrol);
 	struct tegra_admaif *admaif = snd_soc_component_get_drvdata(cmpnt);
-	unsigned int *uctl_val = &ucontrol->value.enumerated.item[0];
+	struct soc_enum *ec = (struct soc_enum *)kcontrol->private_value;
+	unsigned int value = ucontrol->value.enumerated.item[0];
 
-	if (strstr(kcontrol->id.name, "Playback Mono To Stereo"))
-		*uctl_val = admaif->mono_to_stereo[ADMAIF_TX_PATH][ec->reg];
-	else if (strstr(kcontrol->id.name, "Capture Mono To Stereo"))
-		*uctl_val = admaif->mono_to_stereo[ADMAIF_RX_PATH][ec->reg];
-	else if (strstr(kcontrol->id.name, "Playback Stereo To Mono"))
-		*uctl_val = admaif->stereo_to_mono[ADMAIF_TX_PATH][ec->reg];
-	else if (strstr(kcontrol->id.name, "Capture Stereo To Mono"))
-		*uctl_val = admaif->stereo_to_mono[ADMAIF_RX_PATH][ec->reg];
+	if (value == admaif->mono_to_stereo[ADMAIF_TX_PATH][ec->reg])
+		return 0;
+
+	admaif->mono_to_stereo[ADMAIF_TX_PATH][ec->reg] = value;
+
+	return 1;
+}
+
+static int tegra210_admaif_cget_mono_to_stereo(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *cmpnt = snd_soc_kcontrol_component(kcontrol);
+	struct tegra_admaif *admaif = snd_soc_component_get_drvdata(cmpnt);
+	struct soc_enum *ec = (struct soc_enum *)kcontrol->private_value;
+
+	ucontrol->value.enumerated.item[0] =
+		admaif->mono_to_stereo[ADMAIF_RX_PATH][ec->reg];
 
 	return 0;
 }
 
-static int tegra_admaif_put_control(struct snd_kcontrol *kcontrol,
-				    struct snd_ctl_elem_value *ucontrol)
+static int tegra210_admaif_cput_mono_to_stereo(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_component *cmpnt = snd_soc_kcontrol_component(kcontrol);
+	struct tegra_admaif *admaif = snd_soc_component_get_drvdata(cmpnt);
 	struct soc_enum *ec = (struct soc_enum *)kcontrol->private_value;
+	unsigned int value = ucontrol->value.enumerated.item[0];
+
+	if (value == admaif->mono_to_stereo[ADMAIF_RX_PATH][ec->reg])
+		return 0;
+
+	admaif->mono_to_stereo[ADMAIF_RX_PATH][ec->reg] = value;
+
+	return 1;
+}
+
+static int tegra210_admaif_pget_stereo_to_mono(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *cmpnt = snd_soc_kcontrol_component(kcontrol);
 	struct tegra_admaif *admaif = snd_soc_component_get_drvdata(cmpnt);
+	struct soc_enum *ec = (struct soc_enum *)kcontrol->private_value;
+
+	ucontrol->value.enumerated.item[0] =
+		admaif->stereo_to_mono[ADMAIF_TX_PATH][ec->reg];
+
+	return 0;
+}
+
+static int tegra210_admaif_pput_stereo_to_mono(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *cmpnt = snd_soc_kcontrol_component(kcontrol);
+	struct tegra_admaif *admaif = snd_soc_component_get_drvdata(cmpnt);
+	struct soc_enum *ec = (struct soc_enum *)kcontrol->private_value;
 	unsigned int value = ucontrol->value.enumerated.item[0];
 
-	if (strstr(kcontrol->id.name, "Playback Mono To Stereo"))
-		admaif->mono_to_stereo[ADMAIF_TX_PATH][ec->reg] = value;
-	else if (strstr(kcontrol->id.name, "Capture Mono To Stereo"))
-		admaif->mono_to_stereo[ADMAIF_RX_PATH][ec->reg] = value;
-	else if (strstr(kcontrol->id.name, "Playback Stereo To Mono"))
-		admaif->stereo_to_mono[ADMAIF_TX_PATH][ec->reg] = value;
-	else if (strstr(kcontrol->id.name, "Capture Stereo To Mono"))
-		admaif->stereo_to_mono[ADMAIF_RX_PATH][ec->reg] = value;
+	if (value == admaif->stereo_to_mono[ADMAIF_TX_PATH][ec->reg])
+		return 0;
+
+	admaif->stereo_to_mono[ADMAIF_TX_PATH][ec->reg] = value;
+
+	return 1;
+}
+
+static int tegra210_admaif_cget_stereo_to_mono(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *cmpnt = snd_soc_kcontrol_component(kcontrol);
+	struct tegra_admaif *admaif = snd_soc_component_get_drvdata(cmpnt);
+	struct soc_enum *ec = (struct soc_enum *)kcontrol->private_value;
+
+	ucontrol->value.enumerated.item[0] =
+		admaif->stereo_to_mono[ADMAIF_RX_PATH][ec->reg];
 
 	return 0;
 }
 
+static int tegra210_admaif_cput_stereo_to_mono(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *cmpnt = snd_soc_kcontrol_component(kcontrol);
+	struct tegra_admaif *admaif = snd_soc_component_get_drvdata(cmpnt);
+	struct soc_enum *ec = (struct soc_enum *)kcontrol->private_value;
+	unsigned int value = ucontrol->value.enumerated.item[0];
+
+	if (value == admaif->stereo_to_mono[ADMAIF_RX_PATH][ec->reg])
+		return 0;
+
+	admaif->stereo_to_mono[ADMAIF_RX_PATH][ec->reg] = value;
+
+	return 1;
+}
+
 static int tegra_admaif_dai_probe(struct snd_soc_dai *dai)
 {
 	struct tegra_admaif *admaif = snd_soc_dai_get_drvdata(dai);
@@ -559,17 +635,21 @@ static const char * const tegra_admaif_m
 }
 
 #define TEGRA_ADMAIF_CIF_CTRL(reg)					       \
-	NV_SOC_ENUM_EXT("ADMAIF" #reg " Playback Mono To Stereo", reg - 1,\
-			tegra_admaif_get_control, tegra_admaif_put_control,    \
+	NV_SOC_ENUM_EXT("ADMAIF" #reg " Playback Mono To Stereo", reg - 1,     \
+			tegra210_admaif_pget_mono_to_stereo,		       \
+			tegra210_admaif_pput_mono_to_stereo,		       \
 			tegra_admaif_mono_conv_text),			       \
-	NV_SOC_ENUM_EXT("ADMAIF" #reg " Playback Stereo To Mono", reg - 1,\
-			tegra_admaif_get_control, tegra_admaif_put_control,    \
+	NV_SOC_ENUM_EXT("ADMAIF" #reg " Playback Stereo To Mono", reg - 1,     \
+			tegra210_admaif_pget_stereo_to_mono,		       \
+			tegra210_admaif_pput_stereo_to_mono,		       \
 			tegra_admaif_stereo_conv_text),			       \
-	NV_SOC_ENUM_EXT("ADMAIF" #reg " Capture Mono To Stereo", reg - 1, \
-			tegra_admaif_get_control, tegra_admaif_put_control,    \
+	NV_SOC_ENUM_EXT("ADMAIF" #reg " Capture Mono To Stereo", reg - 1,      \
+			tegra210_admaif_cget_mono_to_stereo,		       \
+			tegra210_admaif_cput_mono_to_stereo,		       \
 			tegra_admaif_mono_conv_text),			       \
-	NV_SOC_ENUM_EXT("ADMAIF" #reg " Capture Stereo To Mono", reg - 1, \
-			tegra_admaif_get_control, tegra_admaif_put_control,    \
+	NV_SOC_ENUM_EXT("ADMAIF" #reg " Capture Stereo To Mono", reg - 1,      \
+			tegra210_admaif_cget_stereo_to_mono,		       \
+			tegra210_admaif_cput_stereo_to_mono,		       \
 			tegra_admaif_stereo_conv_text)
 
 static struct snd_kcontrol_new tegra210_admaif_controls[] = {


