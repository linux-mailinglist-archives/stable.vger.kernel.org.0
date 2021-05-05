Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B68C73745AD
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234209AbhEERHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 13:07:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236891AbhEERDj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 13:03:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5869E61401;
        Wed,  5 May 2021 16:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232913;
        bh=XxGGBWBfrbhWtYT8TV2T2lbojM3peR8A0GT50MPDk88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EzN1agRcFkRx1/6s4Bdw4lfuUgn580OJRTwQI0AZsWoW5KtOQui/eLC3M4w2lJXpI
         TvJOil9z87izfMjWNfbLdwNDH57Nn4dVdL2+wePqrHqtQUqILEDwu6ULNz4RBhPmm0
         d5S0OQfRFytEbuF9Nubhapgmfa6TewbN4VJ9PlxZk+IBnLIfgHDtahxWGtg4SFnW5u
         c3yBab/Mxp4CDpPCsiKV65glPIC6++fr0vlAjeGhuoV9Txht/CzjRmx3fyDGnVS4YM
         0fXZQkB5r6qFGy2kNnk15dExKbA3eGX8Xvco13A+hK2c1Jm08wcAU1tReSmVitMErT
         KqXRjwYkaj/5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Ward <david.ward@gatech.edu>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.9 16/22] ASoC: rt286: Generalize support for ALC3263 codec
Date:   Wed,  5 May 2021 12:41:23 -0400
Message-Id: <20210505164129.3464277-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505164129.3464277-1-sashal@kernel.org>
References: <20210505164129.3464277-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ward <david.ward@gatech.edu>

[ Upstream commit aa2f9c12821e6a4ba1df4fb34a3dbc6a2a1ee7fe ]

The ALC3263 codec on the XPS 13 9343 is also found on the Latitude 13 7350
and Venue 11 Pro 7140. They require the same handling for the combo jack to
work with a headset: GPIO pin 6 must be set.

The HDA driver always sets this pin on the ALC3263, which it distinguishes
by the codec vendor/device ID 0x10ec0288 and PCI subsystem vendor ID 0x1028
(Dell). The ASoC driver does not use PCI, so adapt this check to use DMI to
determine if Dell is the system vendor.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=150601
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=205961
Signed-off-by: David Ward <david.ward@gatech.edu>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210418134658.4333-6-david.ward@gatech.edu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt286.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/sound/soc/codecs/rt286.c b/sound/soc/codecs/rt286.c
index 7899a2cdeb42..4a0ab620983d 100644
--- a/sound/soc/codecs/rt286.c
+++ b/sound/soc/codecs/rt286.c
@@ -1119,12 +1119,11 @@ static const struct dmi_system_id force_combo_jack_table[] = {
 	{ }
 };
 
-static const struct dmi_system_id dmi_dell_dino[] = {
+static const struct dmi_system_id dmi_dell[] = {
 	{
-		.ident = "Dell Dino",
+		.ident = "Dell",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "XPS 13 9343")
 		}
 	},
 	{ }
@@ -1135,7 +1134,7 @@ static int rt286_i2c_probe(struct i2c_client *i2c,
 {
 	struct rt286_platform_data *pdata = dev_get_platdata(&i2c->dev);
 	struct rt286_priv *rt286;
-	int i, ret, val;
+	int i, ret, vendor_id;
 
 	rt286 = devm_kzalloc(&i2c->dev,	sizeof(*rt286),
 				GFP_KERNEL);
@@ -1151,14 +1150,15 @@ static int rt286_i2c_probe(struct i2c_client *i2c,
 	}
 
 	ret = regmap_read(rt286->regmap,
-		RT286_GET_PARAM(AC_NODE_ROOT, AC_PAR_VENDOR_ID), &val);
+		RT286_GET_PARAM(AC_NODE_ROOT, AC_PAR_VENDOR_ID), &vendor_id);
 	if (ret != 0) {
 		dev_err(&i2c->dev, "I2C error %d\n", ret);
 		return ret;
 	}
-	if (val != RT286_VENDOR_ID && val != RT288_VENDOR_ID) {
+	if (vendor_id != RT286_VENDOR_ID && vendor_id != RT288_VENDOR_ID) {
 		dev_err(&i2c->dev,
-			"Device with ID register %#x is not rt286\n", val);
+			"Device with ID register %#x is not rt286\n",
+			vendor_id);
 		return -ENODEV;
 	}
 
@@ -1182,8 +1182,8 @@ static int rt286_i2c_probe(struct i2c_client *i2c,
 	if (pdata)
 		rt286->pdata = *pdata;
 
-	if (dmi_check_system(force_combo_jack_table) ||
-		dmi_check_system(dmi_dell_dino))
+	if ((vendor_id == RT288_VENDOR_ID && dmi_check_system(dmi_dell)) ||
+		dmi_check_system(force_combo_jack_table))
 		rt286->pdata.cbj_en = true;
 
 	regmap_write(rt286->regmap, RT286_SET_AUDIO_POWER, AC_PWRST_D3);
@@ -1222,7 +1222,7 @@ static int rt286_i2c_probe(struct i2c_client *i2c,
 	regmap_update_bits(rt286->regmap, RT286_DEPOP_CTRL3, 0xf777, 0x4737);
 	regmap_update_bits(rt286->regmap, RT286_DEPOP_CTRL4, 0x00ff, 0x003f);
 
-	if (dmi_check_system(dmi_dell_dino)) {
+	if (vendor_id == RT288_VENDOR_ID && dmi_check_system(dmi_dell)) {
 		regmap_update_bits(rt286->regmap,
 			RT286_SET_GPIO_MASK, 0x40, 0x40);
 		regmap_update_bits(rt286->regmap,
-- 
2.30.2

