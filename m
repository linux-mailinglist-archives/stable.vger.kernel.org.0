Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B297D1167
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 16:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731397AbfJIOit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 10:38:49 -0400
Received: from mail-eopbgr60120.outbound.protection.outlook.com ([40.107.6.120]:11655
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729491AbfJIOis (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 10:38:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXBPitbm5e9rGQqS2z+Sznryh32BgVnVMlpOYoccb+6NRa1nZseQ1qLzKYRc9O2vcY95xqXuPU8udx3vGli0PdkHGQCU5qCO4lyGJjFGMnD5+SimRwc8EIcO88+puSSG4RQLnE62IvhV0n2lYu9eEVWNP6cBEO1dZpepEYZ+WYEke1bbOuiH6NvQysS7koByGqBk4US4v0ZkcIlMDHP091R8ixLe6KkoJfng1JYnaGtBVG9U6QbVPe7NFQo0xyXXuONaLDbb8nlujqo4itbJHrzDT7yocKjIeLRvQyVrAqOg0C9DsK/noEJlp0iLz3rKIeR2PL2SWW6jzzSo8NSQFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CZnNAd8QjBNW+IsZGqQuAFd0pafhzOvD4GoYzQkR6u4=;
 b=gs2X4VOD/ABgvUAuvQj11wyu9hNHpzIxWJDiKfh1WOUQWZirTHUo52QzxZro49C/JjtXz0tR7P+MQLkUUjN43MwSH2+InneST7rXyLWV4xiklo2ixe6ZLO/YGuSDjca34P72I6FJXb/lCVVnvMKjfji2Fx9N7YVWu6QB3Kbj+HowCeNYTMemEsVMAfp8slV4ElGMzvcHJbSeA7oBq3nZxLoYgLzd/FfbRzz+sjbQwWtiKdRbq1b3GkeZV3waDSVaVY6XBqA/2ArCTAmJ1NGYjGGIXv8PlnIl6HFZUrUpH1vT8Qzd25mYnZ6TrYE303NrTyODf0TifZeXVOwrgEmquA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CZnNAd8QjBNW+IsZGqQuAFd0pafhzOvD4GoYzQkR6u4=;
 b=iGs+wOGTB8e5MkpCI//h67r6hazx3YmQ9ig15vIeKljrRQVAu2H+zCquxIuRGEtF3cxxw0c8L47DNjOVdKnUMRoPQDOnLoDW2xrDNllVO436q7e/BC4uGYLZlT6hYJbPk8CwQ7da+m6tt/PyDlYs62cfGnUCbPypsPDv2gHj2zs=
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com (20.179.18.212) by
 AM6PR05MB6038.eurprd05.prod.outlook.com (20.179.3.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 9 Oct 2019 14:38:42 +0000
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c9f9:f21d:d401:7f35]) by AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c9f9:f21d:d401:7f35%5]) with mapi id 15.20.2347.016; Wed, 9 Oct 2019
 14:38:42 +0000
From:   Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Fabio Estevam <festevam@gmail.com>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: [PATCH 1/1] ASoC: sgtl5000: Improve VAG power and mute control
Thread-Topic: [PATCH 1/1] ASoC: sgtl5000: Improve VAG power and mute control
Thread-Index: AQHVfq8/DKiOAcjBBkK7Pk4ZDvrKxQ==
Date:   Wed, 9 Oct 2019 14:38:41 +0000
Message-ID: <20191009143836.16009-2-oleksandr.suvorov@toradex.com>
References: <20191009143836.16009-1-oleksandr.suvorov@toradex.com>
In-Reply-To: <20191009143836.16009-1-oleksandr.suvorov@toradex.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR05CA0077.eurprd05.prod.outlook.com
 (2603:10a6:208:136::17) To AM6PR05MB6535.eurprd05.prod.outlook.com
 (2603:10a6:20b:74::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=oleksandr.suvorov@toradex.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [194.105.145.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 91f2d5dd-d196-438d-c510-08d74cc6616d
x-ms-traffictypediagnostic: AM6PR05MB6038:
x-ms-exchange-purlcount: 2
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB60386C15C8AA5571BF3E4005F9950@AM6PR05MB6038.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:248;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(136003)(366004)(396003)(376002)(39850400004)(199004)(189003)(14444005)(71200400001)(966005)(14454004)(54906003)(6512007)(6306002)(25786009)(1076003)(5640700003)(30864003)(256004)(2906002)(6486002)(66066001)(71190400001)(5660300002)(6436002)(478600001)(66946007)(66476007)(64756008)(66446008)(6116002)(186003)(316002)(50226002)(26005)(66556008)(8936002)(81166006)(7736002)(3846002)(44832011)(36756003)(4326008)(305945005)(446003)(11346002)(486006)(2616005)(476003)(2351001)(76176011)(2501003)(8676002)(86362001)(52116002)(6506007)(102836004)(99286004)(81156014)(1730700003)(6916009)(386003);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR05MB6038;H:AM6PR05MB6535.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: toradex.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9032BcP0XtbfrF6FW1J8frNKaSy7m6N1EFJYpMqsNuY+ctImAVMepl2m3gQrlOwEoDjJK1o3jI1ZlqHA+PWmyXx0V5dcPXbHqkQ/8vgb31Pzm9dfr1ULugqcf4BynCrIj8OlBHVyKRozLusJGmp8EoCh+z64hPmxXd1yzWLAiZfmmyrvcCK0Df2WO+VkFudbJIccvRb/CE98AmONj4/twVWfzKN3+9ISsGA6IXUDuSeJxqpkJj4FwlAhKCXR/mq9TkYFeNRLRA5s8Vyj4WSv7xm3/L9+oCKiPjVBlAu0LQxX7yv49MpOm0QCqhXotDHMDnP7xn4Pu9Z3831vRolxiyppw3bkfzM5nT8sTRkwRq/q0ho8dNb+Q9VBph51CTJjKV+kE8tYuJ5gcP+OBgkcIe3+Dfa1cMLW6gx9Rn5YnEDUv/vdaW7SlF5EOCPjH/ht8hTdGeSsX7F4L5vQ/ljBWw==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91f2d5dd-d196-438d-c510-08d74cc6616d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 14:38:41.9642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fs/nTQ6sWOxEoxjIzq65ODi6yajn/L/2IT8ONVn82E9kuk8yma9Ih7hzO3PUZLEjyM35/zXl8GKegB1DZRnawU5dVJ0pA0fwnPIWHmfX3GQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6038
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b1f373a11d25 ("ASoC: sgtl5000: Improve VAG power and mute
control") upstream.

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
the outputs should be muted upon input/output
routing changes.

[1] https://www.nxp.com/docs/en/data-sheet/SGTL5000.pdf

Cc: stable@vger.kernel.org
Fixes: 9b34e6cc3bc2 ("ASoC: Add Freescale SGTL5000 codec support")
Signed-off-by: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
[Backport: Replace snd_soc_component_read32() with snd_soc_component_read()=
]
Reviewed-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20190719100524.23300-3-oleksandr.suvorov@to=
radex.com
Signed-off-by: Mark Brown <broonie@kernel.org>

---

 sound/soc/codecs/sgtl5000.c | 234 +++++++++++++++++++++++++++++++-----
 1 file changed, 203 insertions(+), 31 deletions(-)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index b649675d190d..10764c1e854e 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -35,6 +35,13 @@
 #define SGTL5000_DAP_REG_OFFSET	0x0100
 #define SGTL5000_MAX_REG_OFFSET	0x013A
=20
+/* Delay for the VAG ramp up */
+#define SGTL5000_VAG_POWERUP_DELAY 500 /* ms */
+/* Delay for the VAG ramp down */
+#define SGTL5000_VAG_POWERDOWN_DELAY 500 /* ms */
+
+#define SGTL5000_OUTPUTS_MUTE (SGTL5000_HP_MUTE | SGTL5000_LINE_OUT_MUTE)
+
 /* default value of sgtl5000 registers */
 static const struct reg_default sgtl5000_reg_defaults[] =3D {
 	{ SGTL5000_CHIP_DIG_POWER,		0x0000 },
@@ -120,6 +127,13 @@ enum  {
 	I2S_LRCLK_STRENGTH_HIGH,
 };
=20
+enum {
+	HP_POWER_EVENT,
+	DAC_POWER_EVENT,
+	ADC_POWER_EVENT,
+	LAST_POWER_EVENT =3D ADC_POWER_EVENT
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
=20
+static inline int hp_sel_input(struct snd_soc_component *component)
+{
+	unsigned int ana_reg =3D 0;
+
+	snd_soc_component_read(component, SGTL5000_CHIP_ANA_CTRL, &ana_reg);
+
+	return (ana_reg & SGTL5000_HP_SEL_MASK) >> SGTL5000_HP_SEL_SHIFT;
+}
+
+static inline u16 mute_output(struct snd_soc_component *component,
+			      u16 mute_mask)
+{
+	unsigned int mute_reg =3D 0;
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
+	unsigned int ana_reg =3D 0;
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
+	if (hp_sel_input(component) =3D=3D SGTL5000_HP_SEL_LINE_IN &&
+	    source =3D=3D HP_POWER_EVENT)
+		msleep(SGTL5000_VAG_POWERUP_DELAY);
+}
+
+static int vag_power_consumers(struct snd_soc_component *component,
+			       u16 ana_pwr_reg, u32 source)
+{
+	int consumers =3D 0;
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
+	if (source =3D=3D HP_POWER_EVENT) {
+		if (hp_sel_input(component) =3D=3D SGTL5000_HP_SEL_LINE_IN)
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
+	unsigned int ana_pwr =3D SGTL5000_VAG_POWERUP;
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
+	if (vag_power_consumers(component, ana_pwr, source) >=3D 2)
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
@@ -166,36 +289,46 @@ static int mic_bias_event(struct snd_soc_dapm_widget =
*w,
 	return 0;
 }
=20
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
-	struct snd_soc_codec *codec =3D snd_soc_dapm_to_codec(w->dapm);
-	const u32 mask =3D SGTL5000_DAC_POWERUP | SGTL5000_ADC_POWERUP;
+	static const u16 mute_mask[] =3D {
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
+	struct sgtl5000_priv *sgtl5000 =3D
+		snd_soc_component_get_drvdata(component);
=20
 	switch (event) {
-	case SND_SOC_DAPM_POST_PMU:
-		snd_soc_update_bits(codec, SGTL5000_CHIP_ANA_POWER,
-			SGTL5000_VAG_POWERUP, SGTL5000_VAG_POWERUP);
-		msleep(400);
+	case SND_SOC_DAPM_PRE_PMU:
+		sgtl5000->mute_state[event_source] =3D
+			mute_output(component, mute_mask[event_source]);
+		break;
+	case SND_SOC_DAPM_POST_PMU:
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
-				mask) !=3D mask) {
-			snd_soc_update_bits(codec, SGTL5000_CHIP_ANA_POWER,
-				SGTL5000_VAG_POWERUP, 0);
-			msleep(400);
-		}
+		sgtl5000->mute_state[event_source] =3D
+			mute_output(component, mute_mask[event_source]);
+		vag_power_off(component, event_source);
+		break;
+	case SND_SOC_DAPM_POST_PMD:
+		restore_output(component, mute_mask[event_source],
+			       sgtl5000->mute_state[event_source]);
 		break;
 	default:
 		break;
@@ -204,6 +337,41 @@ static int power_vag_event(struct snd_soc_dapm_widget =
*w,
 	return 0;
 }
=20
+/*
+ * Mute Headphone when power it up/down.
+ * Control VAG power on HP power path.
+ */
+static int headphone_pga_event(struct snd_soc_dapm_widget *w,
+	struct snd_kcontrol *kcontrol, int event)
+{
+	struct snd_soc_component *component =3D
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
+	struct snd_soc_component *component =3D
+		snd_soc_dapm_to_component(w->dapm);
+
+	return vag_and_mute_control(component, event, ADC_POWER_EVENT);
+}
+
+static int dac_updown_depop(struct snd_soc_dapm_widget *w,
+	struct snd_kcontrol *kcontrol, int event)
+{
+	struct snd_soc_component *component =3D
+		snd_soc_dapm_to_component(w->dapm);
+
+	return vag_and_mute_control(component, event, DAC_POWER_EVENT);
+}
+
 /* input sources for ADC */
 static const char *adc_mux_text[] =3D {
 	"MIC_IN", "LINE_IN"
@@ -239,7 +407,10 @@ static const struct snd_soc_dapm_widget sgtl5000_dapm_=
widgets[] =3D {
 			    mic_bias_event,
 			    SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD),
=20
-	SND_SOC_DAPM_PGA("HP", SGTL5000_CHIP_ANA_POWER, 4, 0, NULL, 0),
+	SND_SOC_DAPM_PGA_E("HP", SGTL5000_CHIP_ANA_POWER, 4, 0, NULL, 0,
+			   headphone_pga_event,
+			   SND_SOC_DAPM_PRE_POST_PMU |
+			   SND_SOC_DAPM_PRE_POST_PMD),
 	SND_SOC_DAPM_PGA("LO", SGTL5000_CHIP_ANA_POWER, 0, 0, NULL, 0),
=20
 	SND_SOC_DAPM_MUX("Capture Mux", SND_SOC_NOPM, 0, 0, &adc_mux),
@@ -255,11 +426,12 @@ static const struct snd_soc_dapm_widget sgtl5000_dapm=
_widgets[] =3D {
 				0, SGTL5000_CHIP_DIG_POWER,
 				1, 0),
=20
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
=20
 /* routes for sgtl5000 */
--=20
2.20.1

