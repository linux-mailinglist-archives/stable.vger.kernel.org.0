Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F16D0D24FE
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390239AbfJJIwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:52:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390231AbfJJIwP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:52:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DF8D20B7C;
        Thu, 10 Oct 2019 08:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697534;
        bh=ewGB37NXeQtrBLB8F06yNZ+4UFA58+P8ECgrSRw5JII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w4Uvwzjeib70+rxJIkrXUppYAB02Xv3X4C+xzAdTQv5pK1oxajUD+l1tANpzZQPFa
         nSxJH6REQevAigme/SV6q801rUTaxVy5DMc0++wiEvKNR0T6dEO76J1Cn7qTK1ytki
         VsbJvJqTG6xmT6Uc+RNY2Ap8u8IaBcq/OISFeZ4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Fabio Estevam <festevam@gmail.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 61/61] ASoC: sgtl5000: Improve VAG power and mute control
Date:   Thu, 10 Oct 2019 10:37:26 +0200
Message-Id: <20191010083528.179896623@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083449.500442342@linuxfoundation.org>
References: <20191010083449.500442342@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>

[ Upstream commit b1f373a11d25fc9a5f7679c9b85799fe09b0dc4a ]

VAG power control is improved to fit the manual [1]. This patch fixes as
minimum one bug: if customer muxes Headphone to Line-In right after boot,
the VAG power remains off that leads to poor sound quality from line-in.

I.e. after boot:
  - Connect sound source to Line-In jack;
  - Connect headphone to HP jack;
  - Run following commands:
  $ amixer set 'Headphone' 80%
  $ amixer set 'Headphone Mux' LINE_IN

Change VAG power on/off control according to the following algorithm:
  - turn VAG power ON on the 1st incoming event.
  - keep it ON if there is any active VAG consumer (ADC/DAC/HP/Line-In).
  - turn VAG power OFF when there is the latest consumer's pre-down event
    come.
  - always delay after VAG power OFF to avoid pop.
  - delay after VAG power ON if the initiative consumer is Line-In, this
    prevents pop during line-in muxing.

According to the data sheet [1], to avoid any pops/clicks,
the outputs should be muted during input/output
routing changes.

[1] https://www.nxp.com/docs/en/data-sheet/SGTL5000.pdf

Cc: stable@vger.kernel.org
Fixes: 9b34e6cc3bc2 ("ASoC: Add Freescale SGTL5000 codec support")
Signed-off-by: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Reviewed-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20190719100524.23300-3-oleksandr.suvorov@toradex.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/sgtl5000.c | 232 +++++++++++++++++++++++++++++++-----
 1 file changed, 202 insertions(+), 30 deletions(-)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index b649675d190d2..10764c1e854e2 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -35,6 +35,13 @@
 #define SGTL5000_DAP_REG_OFFSET	0x0100
 #define SGTL5000_MAX_REG_OFFSET	0x013A
 
+/* Delay for the VAG ramp up */
+#define SGTL5000_VAG_POWERUP_DELAY 500 /* ms */
+/* Delay for the VAG ramp down */
+#define SGTL5000_VAG_POWERDOWN_DELAY 500 /* ms */
+
+#define SGTL5000_OUTPUTS_MUTE (SGTL5000_HP_MUTE | SGTL5000_LINE_OUT_MUTE)
+
 /* default value of sgtl5000 registers */
 static const struct reg_default sgtl5000_reg_defaults[] = {
 	{ SGTL5000_CHIP_DIG_POWER,		0x0000 },
@@ -120,6 +127,13 @@ enum  {
 	I2S_LRCLK_STRENGTH_HIGH,
 };
 
+enum {
+	HP_POWER_EVENT,
+	DAC_POWER_EVENT,
+	ADC_POWER_EVENT,
+	LAST_POWER_EVENT = ADC_POWER_EVENT
+};
+
 /* sgtl5000 private structure in codec */
 struct sgtl5000_priv {
 	int sysclk;	/* sysclk rate */
@@ -133,8 +147,117 @@ struct sgtl5000_priv {
 	u8 micbias_resistor;
 	u8 micbias_voltage;
 	u8 lrclk_strength;
+	u16 mute_state[LAST_POWER_EVENT + 1];
 };
 
+static inline int hp_sel_input(struct snd_soc_component *component)
+{
+	unsigned int ana_reg = 0;
+
+	snd_soc_component_read(component, SGTL5000_CHIP_ANA_CTRL, &ana_reg);
+
+	return (ana_reg & SGTL5000_HP_SEL_MASK) >> SGTL5000_HP_SEL_SHIFT;
+}
+
+static inline u16 mute_output(struct snd_soc_component *component,
+			      u16 mute_mask)
+{
+	unsigned int mute_reg = 0;
+
+	snd_soc_component_read(component, SGTL5000_CHIP_ANA_CTRL, &mute_reg);
+
+	snd_soc_component_update_bits(component, SGTL5000_CHIP_ANA_CTRL,
+			    mute_mask, mute_mask);
+	return mute_reg;
+}
+
+static inline void restore_output(struct snd_soc_component *component,
+				  u16 mute_mask, u16 mute_reg)
+{
+	snd_soc_component_update_bits(component, SGTL5000_CHIP_ANA_CTRL,
+		mute_mask, mute_reg);
+}
+
+static void vag_power_on(struct snd_soc_component *component, u32 source)
+{
+	unsigned int ana_reg = 0;
+
+	snd_soc_component_read(component, SGTL5000_CHIP_ANA_POWER, &ana_reg);
+
+	if (ana_reg & SGTL5000_VAG_POWERUP)
+		return;
+
+	snd_soc_component_update_bits(component, SGTL5000_CHIP_ANA_POWER,
+			    SGTL5000_VAG_POWERUP, SGTL5000_VAG_POWERUP);
+
+	/* When VAG powering on to get local loop from Line-In, the sleep
+	 * is required to avoid loud pop.
+	 */
+	if (hp_sel_input(component) == SGTL5000_HP_SEL_LINE_IN &&
+	    source == HP_POWER_EVENT)
+		msleep(SGTL5000_VAG_POWERUP_DELAY);
+}
+
+static int vag_power_consumers(struct snd_soc_component *component,
+			       u16 ana_pwr_reg, u32 source)
+{
+	int consumers = 0;
+
+	/* count dac/adc consumers unconditional */
+	if (ana_pwr_reg & SGTL5000_DAC_POWERUP)
+		consumers++;
+	if (ana_pwr_reg & SGTL5000_ADC_POWERUP)
+		consumers++;
+
+	/*
+	 * If the event comes from HP and Line-In is selected,
+	 * current action is 'DAC to be powered down'.
+	 * As HP_POWERUP is not set when HP muxed to line-in,
+	 * we need to keep VAG power ON.
+	 */
+	if (source == HP_POWER_EVENT) {
+		if (hp_sel_input(component) == SGTL5000_HP_SEL_LINE_IN)
+			consumers++;
+	} else {
+		if (ana_pwr_reg & SGTL5000_HP_POWERUP)
+			consumers++;
+	}
+
+	return consumers;
+}
+
+static void vag_power_off(struct snd_soc_component *component, u32 source)
+{
+	unsigned int ana_pwr = SGTL5000_VAG_POWERUP;
+
+	snd_soc_component_read(component, SGTL5000_CHIP_ANA_POWER, &ana_pwr);
+
+	if (!(ana_pwr & SGTL5000_VAG_POWERUP))
+		return;
+
+	/*
+	 * This function calls when any of VAG power consumers is disappearing.
+	 * Thus, if there is more than one consumer at the moment, as minimum
+	 * one consumer will definitely stay after the end of the current
+	 * event.
+	 * Don't clear VAG_POWERUP if 2 or more consumers of VAG present:
+	 * - LINE_IN (for HP events) / HP (for DAC/ADC events)
+	 * - DAC
+	 * - ADC
+	 * (the current consumer is disappearing right now)
+	 */
+	if (vag_power_consumers(component, ana_pwr, source) >= 2)
+		return;
+
+	snd_soc_component_update_bits(component, SGTL5000_CHIP_ANA_POWER,
+		SGTL5000_VAG_POWERUP, 0);
+	/* In power down case, we need wait 400-1000 ms
+	 * when VAG fully ramped down.
+	 * As longer we wait, as smaller pop we've got.
+	 */
+	msleep(SGTL5000_VAG_POWERDOWN_DELAY);
+}
+
 /*
  * mic_bias power on/off share the same register bits with
  * output impedance of mic bias, when power on mic bias, we
@@ -166,36 +289,46 @@ static int mic_bias_event(struct snd_soc_dapm_widget *w,
 	return 0;
 }
 
-/*
- * As manual described, ADC/DAC only works when VAG powerup,
- * So enabled VAG before ADC/DAC up.
- * In power down case, we need wait 400ms when vag fully ramped down.
- */
-static int power_vag_event(struct snd_soc_dapm_widget *w,
-	struct snd_kcontrol *kcontrol, int event)
+static int vag_and_mute_control(struct snd_soc_component *component,
+				 int event, int event_source)
 {
-	struct snd_soc_codec *codec = snd_soc_dapm_to_codec(w->dapm);
-	const u32 mask = SGTL5000_DAC_POWERUP | SGTL5000_ADC_POWERUP;
+	static const u16 mute_mask[] = {
+		/*
+		 * Mask for HP_POWER_EVENT.
+		 * Muxing Headphones have to be wrapped with mute/unmute
+		 * headphones only.
+		 */
+		SGTL5000_HP_MUTE,
+		/*
+		 * Masks for DAC_POWER_EVENT/ADC_POWER_EVENT.
+		 * Muxing DAC or ADC block have to be wrapped with mute/unmute
+		 * both headphones and line-out.
+		 */
+		SGTL5000_OUTPUTS_MUTE,
+		SGTL5000_OUTPUTS_MUTE
+	};
+
+	struct sgtl5000_priv *sgtl5000 =
+		snd_soc_component_get_drvdata(component);
 
 	switch (event) {
+	case SND_SOC_DAPM_PRE_PMU:
+		sgtl5000->mute_state[event_source] =
+			mute_output(component, mute_mask[event_source]);
+		break;
 	case SND_SOC_DAPM_POST_PMU:
-		snd_soc_update_bits(codec, SGTL5000_CHIP_ANA_POWER,
-			SGTL5000_VAG_POWERUP, SGTL5000_VAG_POWERUP);
-		msleep(400);
+		vag_power_on(component, event_source);
+		restore_output(component, mute_mask[event_source],
+			       sgtl5000->mute_state[event_source]);
 		break;
-
 	case SND_SOC_DAPM_PRE_PMD:
-		/*
-		 * Don't clear VAG_POWERUP, when both DAC and ADC are
-		 * operational to prevent inadvertently starving the
-		 * other one of them.
-		 */
-		if ((snd_soc_read(codec, SGTL5000_CHIP_ANA_POWER) &
-				mask) != mask) {
-			snd_soc_update_bits(codec, SGTL5000_CHIP_ANA_POWER,
-				SGTL5000_VAG_POWERUP, 0);
-			msleep(400);
-		}
+		sgtl5000->mute_state[event_source] =
+			mute_output(component, mute_mask[event_source]);
+		vag_power_off(component, event_source);
+		break;
+	case SND_SOC_DAPM_POST_PMD:
+		restore_output(component, mute_mask[event_source],
+			       sgtl5000->mute_state[event_source]);
 		break;
 	default:
 		break;
@@ -204,6 +337,41 @@ static int power_vag_event(struct snd_soc_dapm_widget *w,
 	return 0;
 }
 
+/*
+ * Mute Headphone when power it up/down.
+ * Control VAG power on HP power path.
+ */
+static int headphone_pga_event(struct snd_soc_dapm_widget *w,
+	struct snd_kcontrol *kcontrol, int event)
+{
+	struct snd_soc_component *component =
+		snd_soc_dapm_to_component(w->dapm);
+
+	return vag_and_mute_control(component, event, HP_POWER_EVENT);
+}
+
+/* As manual describes, ADC/DAC powering up/down requires
+ * to mute outputs to avoid pops.
+ * Control VAG power on ADC/DAC power path.
+ */
+static int adc_updown_depop(struct snd_soc_dapm_widget *w,
+	struct snd_kcontrol *kcontrol, int event)
+{
+	struct snd_soc_component *component =
+		snd_soc_dapm_to_component(w->dapm);
+
+	return vag_and_mute_control(component, event, ADC_POWER_EVENT);
+}
+
+static int dac_updown_depop(struct snd_soc_dapm_widget *w,
+	struct snd_kcontrol *kcontrol, int event)
+{
+	struct snd_soc_component *component =
+		snd_soc_dapm_to_component(w->dapm);
+
+	return vag_and_mute_control(component, event, DAC_POWER_EVENT);
+}
+
 /* input sources for ADC */
 static const char *adc_mux_text[] = {
 	"MIC_IN", "LINE_IN"
@@ -239,7 +407,10 @@ static const struct snd_soc_dapm_widget sgtl5000_dapm_widgets[] = {
 			    mic_bias_event,
 			    SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD),
 
-	SND_SOC_DAPM_PGA("HP", SGTL5000_CHIP_ANA_POWER, 4, 0, NULL, 0),
+	SND_SOC_DAPM_PGA_E("HP", SGTL5000_CHIP_ANA_POWER, 4, 0, NULL, 0,
+			   headphone_pga_event,
+			   SND_SOC_DAPM_PRE_POST_PMU |
+			   SND_SOC_DAPM_PRE_POST_PMD),
 	SND_SOC_DAPM_PGA("LO", SGTL5000_CHIP_ANA_POWER, 0, 0, NULL, 0),
 
 	SND_SOC_DAPM_MUX("Capture Mux", SND_SOC_NOPM, 0, 0, &adc_mux),
@@ -255,11 +426,12 @@ static const struct snd_soc_dapm_widget sgtl5000_dapm_widgets[] = {
 				0, SGTL5000_CHIP_DIG_POWER,
 				1, 0),
 
-	SND_SOC_DAPM_ADC("ADC", "Capture", SGTL5000_CHIP_ANA_POWER, 1, 0),
-	SND_SOC_DAPM_DAC("DAC", "Playback", SGTL5000_CHIP_ANA_POWER, 3, 0),
-
-	SND_SOC_DAPM_PRE("VAG_POWER_PRE", power_vag_event),
-	SND_SOC_DAPM_POST("VAG_POWER_POST", power_vag_event),
+	SND_SOC_DAPM_ADC_E("ADC", "Capture", SGTL5000_CHIP_ANA_POWER, 1, 0,
+			   adc_updown_depop, SND_SOC_DAPM_PRE_POST_PMU |
+			   SND_SOC_DAPM_PRE_POST_PMD),
+	SND_SOC_DAPM_DAC_E("DAC", "Playback", SGTL5000_CHIP_ANA_POWER, 3, 0,
+			   dac_updown_depop, SND_SOC_DAPM_PRE_POST_PMU |
+			   SND_SOC_DAPM_PRE_POST_PMD),
 };
 
 /* routes for sgtl5000 */
-- 
2.20.1



