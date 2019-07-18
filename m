Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3956CB62
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 11:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389633AbfGRJCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 05:02:54 -0400
Received: from mail-eopbgr150109.outbound.protection.outlook.com ([40.107.15.109]:61477
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389548AbfGRJCx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 05:02:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iEoiMIu16Uffu2PLgxvXgdh4cPGX+tuWjO2prULf/mHQFpBeGgPvhHXsMUt09tx54oVeQTZK7kVs5k18vvpyNgaC+QbGoTGWmH9Tf1vEKik65A1JkdB2i/JbZOkO9OGHrMM5vCIyQsHcrZEOptAIKq+XS9zEWvQNow9eSFj28ONCq7mP3fGzs8YfRGnR66uKmO9sJYglN923w7udA4BbYyxQhkhREFmWUAGowwib/6hjGp9v0cDP5TUT5NttQh0odHydRkgcZnS6bGqQ6hcqQZfHKE28atCjypb8Fu+RDvnpJSpbC/yv9F/H4CnxHlDwkZQwNCIn6M07Hrp3jYLS6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KiI2/bqoHbF8ZhxZs3JQNAQmdgq1SbcQzRRycBmo97A=;
 b=nth9DTXu4T3u8ydWkrfhQvH7n8wKKzks0j/hFdd85befy6ybjIQ3RQclxwr8Hu25u6Y+QlAKZfynb7Beqn7vDRDaEsNf9GM/u4CPiA4cUOoviuTtLe8vl5P+mS4HXMsWjU9JyriVMbiLREVApnDU2m4+CPT7vsgC7yCb+ygrO5udGvhbnhLdRcNR98pjPjwrLRgIYsZ3+tJQ4Jq40WD9urfvE+YOw351qWWntPb7LkVqm8HQOSYVd2vbUetm0wKgTx+kXeCuiQBURYqxW2puruY4Lpjms1lSbu1+C43emiyYp/+oyzWrSFsEM6q0QZDeYKGmEerkZbcBbnL0TsoebA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=toradex.com;dmarc=pass action=none
 header.from=toradex.com;dkim=pass header.d=toradex.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KiI2/bqoHbF8ZhxZs3JQNAQmdgq1SbcQzRRycBmo97A=;
 b=nHDs67sGtWkUKUmH8+dBdKP2aJ2NPtaSXlqDchqQrJSOQ48mqO8DLhJW80m9rAk3G0+534kYg2zWGeAEa6ip0TPTddpd4PJ98KiiQrL2eVMMgRNkQFa7qvfX+az7aIB85IALInuOm1ztSB2Txdci8NwQxTxCw4hQwTuXCojmKjM=
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com (20.179.18.16) by
 AM6PR05MB5013.eurprd05.prod.outlook.com (20.177.35.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.12; Thu, 18 Jul 2019 09:02:48 +0000
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c860:b386:22a:8ec9]) by AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c860:b386:22a:8ec9%6]) with mapi id 15.20.2094.011; Thu, 18 Jul 2019
 09:02:47 +0000
From:   Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
To:     Fabio Estevam <festevam@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Sasha Levin <sashal@kernel.org>,
        Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: [PATCH v5 2/6] ASoC: sgtl5000: Improve VAG power and mute control
Thread-Topic: [PATCH v5 2/6] ASoC: sgtl5000: Improve VAG power and mute
 control
Thread-Index: AQHVPUeRRPlk8qJu2UinCpynQ1zx8A==
Date:   Thu, 18 Jul 2019 09:02:47 +0000
Message-ID: <20190718090240.18432-3-oleksandr.suvorov@toradex.com>
References: <20190718090240.18432-1-oleksandr.suvorov@toradex.com>
In-Reply-To: <20190718090240.18432-1-oleksandr.suvorov@toradex.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR05CA0078.eurprd05.prod.outlook.com
 (2603:10a6:208:136::18) To AM6PR05MB6535.eurprd05.prod.outlook.com
 (2603:10a6:20b:71::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=oleksandr.suvorov@toradex.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [194.105.145.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6cad9cd2-fcfd-40f2-23cf-08d70b5eb3ed
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR05MB5013;
x-ms-traffictypediagnostic: AM6PR05MB5013:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR05MB5013DA2CEE4C509131B318DBF9C80@AM6PR05MB5013.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:236;
x-forefront-prvs: 01026E1310
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39850400004)(346002)(366004)(376002)(396003)(136003)(199004)(189003)(2616005)(99286004)(68736007)(476003)(446003)(50226002)(11346002)(486006)(86362001)(8936002)(81166006)(76176011)(81156014)(26005)(14454004)(4326008)(186003)(386003)(6506007)(316002)(102836004)(6916009)(54906003)(52116002)(36756003)(6486002)(6436002)(71190400001)(71200400001)(6306002)(6512007)(25786009)(14444005)(66066001)(256004)(966005)(66946007)(64756008)(66476007)(66556008)(66446008)(1076003)(1411001)(5660300002)(8676002)(478600001)(7736002)(44832011)(6116002)(3846002)(305945005)(53936002)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR05MB5013;H:AM6PR05MB6535.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: toradex.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: R8rq0yQW7HsKhrB6fjKX6L76F4EIfeQjEdsVZHg8eaLpM2HH5b9sZkhOjgm0zZUqauv5Hwe9yqxzELd6rb/LHxgPVJVt/pi7CO1T8h6G/cViGT7Qh5ebtwheYKnBLvYcOX6/EwiwF/wUonysbvS5f5DjAjCyDyhDLJOu9Yg5BU+rV4yybnyQ21WEw0i5wugw8A3Jyh9itnsGy07aEltUdC47L+j7Lko3h7lz7s1bH+YEv16495wwunTLNeq3PQX1WbYSWJc4qd8k5V+V71QV3YpQDj78BPady4GJc3z1QWoZgo0Z2JMLrX0aTw4TCoU1r/3C/eATCjNGyP8N8kptRlGpViRViPylsr0hmAdPCmB3kI+E0LobaXGXgK7yc73ddL3pVGRbOyWbg5IKNobbBvyiVSir8K+4kkq/79nvm7M=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cad9cd2-fcfd-40f2-23cf-08d70b5eb3ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2019 09:02:47.0998
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oleksandr.suvorov@toradex.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5013
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

---

Changes in v5:
- Improve commit message
- Add explicit stable tag

Changes in v4:
- Code optimization, simplify function signature
  (thanks to Cezary Rojewski <cezary.rojewski@intel.com> for an idea)
- CC the patch to kernel-stable
- Add a Fixes tag

Changes in v3:
- Add the reference to NXP SGTL5000 data sheet to commit message

Changes in v2:
- Fix patch formatting

 sound/soc/codecs/sgtl5000.c | 216 ++++++++++++++++++++++++++++++------
 1 file changed, 185 insertions(+), 31 deletions(-)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index a6a4748c97f9d..a2aeb5fb9b537 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -31,6 +31,13 @@
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
@@ -123,6 +130,19 @@ enum  {
 	I2S_SCLK_STRENGTH_HIGH,
 };
=20
+enum {
+	HP_POWER_EVENT,
+	DAC_POWER_EVENT,
+	ADC_POWER_EVENT,
+	LAST_POWER_EVENT
+};
+
+static u16 mute_mask[] =3D {
+	SGTL5000_HP_MUTE,
+	SGTL5000_OUTPUTS_MUTE,
+	SGTL5000_OUTPUTS_MUTE
+};
+
 /* sgtl5000 private structure in codec */
 struct sgtl5000_priv {
 	int sysclk;	/* sysclk rate */
@@ -137,8 +157,109 @@ struct sgtl5000_priv {
 	u8 micbias_voltage;
 	u8 lrclk_strength;
 	u8 sclk_strength;
+	u16 mute_state[LAST_POWER_EVENT];
 };
=20
+static inline int hp_sel_input(struct snd_soc_component *component)
+{
+	return (snd_soc_component_read32(component, SGTL5000_CHIP_ANA_CTRL) &
+		SGTL5000_HP_SEL_MASK) >> SGTL5000_HP_SEL_SHIFT;
+}
+
+static inline u16 mute_output(struct snd_soc_component *component,
+			      u16 mute_mask)
+{
+	u16 mute_reg =3D snd_soc_component_read32(component,
+					      SGTL5000_CHIP_ANA_CTRL);
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
+	if (snd_soc_component_read32(component, SGTL5000_CHIP_ANA_POWER) &
+	    SGTL5000_VAG_POWERUP)
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
+	u16 ana_pwr =3D snd_soc_component_read32(component,
+					     SGTL5000_CHIP_ANA_POWER);
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
@@ -170,36 +291,30 @@ static int mic_bias_event(struct snd_soc_dapm_widget =
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
-	struct snd_soc_component *component =3D snd_soc_dapm_to_component(w->dapm=
);
-	const u32 mask =3D SGTL5000_DAC_POWERUP | SGTL5000_ADC_POWERUP;
+	struct sgtl5000_priv *sgtl5000 =3D
+		snd_soc_component_get_drvdata(component);
=20
 	switch (event) {
-	case SND_SOC_DAPM_POST_PMU:
-		snd_soc_component_update_bits(component, SGTL5000_CHIP_ANA_POWER,
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
-		if ((snd_soc_component_read32(component, SGTL5000_CHIP_ANA_POWER) &
-				mask) !=3D mask) {
-			snd_soc_component_update_bits(component, SGTL5000_CHIP_ANA_POWER,
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
@@ -208,6 +323,41 @@ static int power_vag_event(struct snd_soc_dapm_widget =
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
@@ -280,7 +430,10 @@ static const struct snd_soc_dapm_widget sgtl5000_dapm_=
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
@@ -301,11 +454,12 @@ static const struct snd_soc_dapm_widget sgtl5000_dapm=
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

