Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFD2469ECE
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391048AbhLFPoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:44:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390317AbhLFPmT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80104C09CE68;
        Mon,  6 Dec 2021 07:26:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28652B81126;
        Mon,  6 Dec 2021 15:26:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AFDCC34900;
        Mon,  6 Dec 2021 15:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804369;
        bh=auCRjUVo1vbxCAQ/FDqW8Cra0byWIg6sKV/uXh++Pd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e1pgkcg8YoZJJ2sVZfWLem3ef48yxRKJyertx+b6qpaaAHJXSCnHXDTXmhT/cg3GJ
         Gi2EahjwGbObk+hCesnvEs6t+4MNfSdJ84SNdwJEDwndxHx/2LTU+leqRwA/K6heRX
         NwzBA+gen/7lhY0wCiJh4cuveCg5QEv1pkZ5KyQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Mark Brown <broonie@kernel.org>,
        Sameer Pujar <spujar@nvidia.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 122/207] ASoC: tegra: Fix kcontrol put callback in DSPK
Date:   Mon,  6 Dec 2021 15:56:16 +0100
Message-Id: <20211206145614.461876507@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sameer Pujar <spujar@nvidia.com>

commit d6202a57e79d102271d38c34481fedc9d4c79694 upstream.

The kcontrol put callback is expected to return 1 when there is change
in HW or when the update is acknowledged by driver. This would ensure
that change notifications are sent to subscribed applications. Update
the DSPK driver accordingly.

Fixes: 327ef6470266 ("ASoC: tegra: Add Tegra186 based DSPK driver")
Suggested-by: Jaroslav Kysela <perex@perex.cz>
Suggested-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/1637219231-406-11-git-send-email-spujar@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/tegra/tegra186_dspk.c |  178 ++++++++++++++++++++++++++++++++--------
 1 file changed, 146 insertions(+), 32 deletions(-)

--- a/sound/soc/tegra/tegra186_dspk.c
+++ b/sound/soc/tegra/tegra186_dspk.c
@@ -26,50 +26,162 @@ static const struct reg_default tegra186
 	{ TEGRA186_DSPK_CODEC_CTRL,  0x03000000 },
 };
 
-static int tegra186_dspk_get_control(struct snd_kcontrol *kcontrol,
+static int tegra186_dspk_get_fifo_th(struct snd_kcontrol *kcontrol,
 				     struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_component *codec = snd_soc_kcontrol_component(kcontrol);
 	struct tegra186_dspk *dspk = snd_soc_component_get_drvdata(codec);
 
-	if (strstr(kcontrol->id.name, "FIFO Threshold"))
-		ucontrol->value.integer.value[0] = dspk->rx_fifo_th;
-	else if (strstr(kcontrol->id.name, "OSR Value"))
-		ucontrol->value.enumerated.item[0] = dspk->osr_val;
-	else if (strstr(kcontrol->id.name, "LR Polarity Select"))
-		ucontrol->value.enumerated.item[0] = dspk->lrsel;
-	else if (strstr(kcontrol->id.name, "Channel Select"))
-		ucontrol->value.enumerated.item[0] = dspk->ch_sel;
-	else if (strstr(kcontrol->id.name, "Mono To Stereo"))
-		ucontrol->value.enumerated.item[0] = dspk->mono_to_stereo;
-	else if (strstr(kcontrol->id.name, "Stereo To Mono"))
-		ucontrol->value.enumerated.item[0] = dspk->stereo_to_mono;
+	ucontrol->value.integer.value[0] = dspk->rx_fifo_th;
 
 	return 0;
 }
 
-static int tegra186_dspk_put_control(struct snd_kcontrol *kcontrol,
+static int tegra186_dspk_put_fifo_th(struct snd_kcontrol *kcontrol,
 				     struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_component *codec = snd_soc_kcontrol_component(kcontrol);
 	struct tegra186_dspk *dspk = snd_soc_component_get_drvdata(codec);
+	int value = ucontrol->value.integer.value[0];
 
-	if (strstr(kcontrol->id.name, "FIFO Threshold"))
-		dspk->rx_fifo_th = ucontrol->value.integer.value[0];
-	else if (strstr(kcontrol->id.name, "OSR Value"))
-		dspk->osr_val = ucontrol->value.enumerated.item[0];
-	else if (strstr(kcontrol->id.name, "LR Polarity Select"))
-		dspk->lrsel = ucontrol->value.enumerated.item[0];
-	else if (strstr(kcontrol->id.name, "Channel Select"))
-		dspk->ch_sel = ucontrol->value.enumerated.item[0];
-	else if (strstr(kcontrol->id.name, "Mono To Stereo"))
-		dspk->mono_to_stereo = ucontrol->value.enumerated.item[0];
-	else if (strstr(kcontrol->id.name, "Stereo To Mono"))
-		dspk->stereo_to_mono = ucontrol->value.enumerated.item[0];
+	if (value == dspk->rx_fifo_th)
+		return 0;
+
+	dspk->rx_fifo_th = value;
+
+	return 1;
+}
+
+static int tegra186_dspk_get_osr_val(struct snd_kcontrol *kcontrol,
+				     struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *codec = snd_soc_kcontrol_component(kcontrol);
+	struct tegra186_dspk *dspk = snd_soc_component_get_drvdata(codec);
+
+	ucontrol->value.enumerated.item[0] = dspk->osr_val;
+
+	return 0;
+}
+
+static int tegra186_dspk_put_osr_val(struct snd_kcontrol *kcontrol,
+				     struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *codec = snd_soc_kcontrol_component(kcontrol);
+	struct tegra186_dspk *dspk = snd_soc_component_get_drvdata(codec);
+	unsigned int value = ucontrol->value.enumerated.item[0];
+
+	if (value == dspk->osr_val)
+		return 0;
+
+	dspk->osr_val = value;
+
+	return 1;
+}
+
+static int tegra186_dspk_get_pol_sel(struct snd_kcontrol *kcontrol,
+				     struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *codec = snd_soc_kcontrol_component(kcontrol);
+	struct tegra186_dspk *dspk = snd_soc_component_get_drvdata(codec);
+
+	ucontrol->value.enumerated.item[0] = dspk->lrsel;
+
+	return 0;
+}
+
+static int tegra186_dspk_put_pol_sel(struct snd_kcontrol *kcontrol,
+				     struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *codec = snd_soc_kcontrol_component(kcontrol);
+	struct tegra186_dspk *dspk = snd_soc_component_get_drvdata(codec);
+	unsigned int value = ucontrol->value.enumerated.item[0];
+
+	if (value == dspk->lrsel)
+		return 0;
+
+	dspk->lrsel = value;
+
+	return 1;
+}
+
+static int tegra186_dspk_get_ch_sel(struct snd_kcontrol *kcontrol,
+				    struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *codec = snd_soc_kcontrol_component(kcontrol);
+	struct tegra186_dspk *dspk = snd_soc_component_get_drvdata(codec);
+
+	ucontrol->value.enumerated.item[0] = dspk->ch_sel;
+
+	return 0;
+}
+
+static int tegra186_dspk_put_ch_sel(struct snd_kcontrol *kcontrol,
+				    struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *codec = snd_soc_kcontrol_component(kcontrol);
+	struct tegra186_dspk *dspk = snd_soc_component_get_drvdata(codec);
+	unsigned int value = ucontrol->value.enumerated.item[0];
+
+	if (value == dspk->ch_sel)
+		return 0;
+
+	dspk->ch_sel = value;
+
+	return 1;
+}
+
+static int tegra186_dspk_get_mono_to_stereo(struct snd_kcontrol *kcontrol,
+					    struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *codec = snd_soc_kcontrol_component(kcontrol);
+	struct tegra186_dspk *dspk = snd_soc_component_get_drvdata(codec);
+
+	ucontrol->value.enumerated.item[0] = dspk->mono_to_stereo;
+
+	return 0;
+}
+
+static int tegra186_dspk_put_mono_to_stereo(struct snd_kcontrol *kcontrol,
+					    struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *codec = snd_soc_kcontrol_component(kcontrol);
+	struct tegra186_dspk *dspk = snd_soc_component_get_drvdata(codec);
+	unsigned int value = ucontrol->value.enumerated.item[0];
+
+	if (value == dspk->mono_to_stereo)
+		return 0;
+
+	dspk->mono_to_stereo = value;
+
+	return 1;
+}
+
+static int tegra186_dspk_get_stereo_to_mono(struct snd_kcontrol *kcontrol,
+					    struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *codec = snd_soc_kcontrol_component(kcontrol);
+	struct tegra186_dspk *dspk = snd_soc_component_get_drvdata(codec);
+
+	ucontrol->value.enumerated.item[0] = dspk->stereo_to_mono;
 
 	return 0;
 }
 
+static int tegra186_dspk_put_stereo_to_mono(struct snd_kcontrol *kcontrol,
+					    struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *codec = snd_soc_kcontrol_component(kcontrol);
+	struct tegra186_dspk *dspk = snd_soc_component_get_drvdata(codec);
+	unsigned int value = ucontrol->value.enumerated.item[0];
+
+	if (value == dspk->stereo_to_mono)
+		return 0;
+
+	dspk->stereo_to_mono = value;
+
+	return 1;
+}
+
 static int __maybe_unused tegra186_dspk_runtime_suspend(struct device *dev)
 {
 	struct tegra186_dspk *dspk = dev_get_drvdata(dev);
@@ -278,17 +390,19 @@ static const struct soc_enum tegra186_ds
 static const struct snd_kcontrol_new tegrat186_dspk_controls[] = {
 	SOC_SINGLE_EXT("FIFO Threshold", SND_SOC_NOPM, 0,
 		       TEGRA186_DSPK_RX_FIFO_DEPTH - 1, 0,
-		       tegra186_dspk_get_control, tegra186_dspk_put_control),
+		       tegra186_dspk_get_fifo_th, tegra186_dspk_put_fifo_th),
 	SOC_ENUM_EXT("OSR Value", tegra186_dspk_osr_enum,
-		     tegra186_dspk_get_control, tegra186_dspk_put_control),
+		     tegra186_dspk_get_osr_val, tegra186_dspk_put_osr_val),
 	SOC_ENUM_EXT("LR Polarity Select", tegra186_dspk_lrsel_enum,
-		     tegra186_dspk_get_control, tegra186_dspk_put_control),
+		     tegra186_dspk_get_pol_sel, tegra186_dspk_put_pol_sel),
 	SOC_ENUM_EXT("Channel Select", tegra186_dspk_ch_sel_enum,
-		     tegra186_dspk_get_control, tegra186_dspk_put_control),
+		     tegra186_dspk_get_ch_sel, tegra186_dspk_put_ch_sel),
 	SOC_ENUM_EXT("Mono To Stereo", tegra186_dspk_mono_conv_enum,
-		     tegra186_dspk_get_control, tegra186_dspk_put_control),
+		     tegra186_dspk_get_mono_to_stereo,
+		     tegra186_dspk_put_mono_to_stereo),
 	SOC_ENUM_EXT("Stereo To Mono", tegra186_dspk_stereo_conv_enum,
-		     tegra186_dspk_get_control, tegra186_dspk_put_control),
+		     tegra186_dspk_get_stereo_to_mono,
+		     tegra186_dspk_put_stereo_to_mono),
 };
 
 static const struct snd_soc_component_driver tegra186_dspk_cmpnt = {


