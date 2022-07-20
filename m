Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76AD857AC12
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241039AbiGTBPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241069AbiGTBPW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:15:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027A866AF4;
        Tue, 19 Jul 2022 18:13:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D7AF6176B;
        Wed, 20 Jul 2022 01:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E8CC341CB;
        Wed, 20 Jul 2022 01:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279605;
        bh=fMqbzR7SId/DUvXvSKD+EqoQ7LAoMoNeLcQjc59Z3/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mm11sIwAiCgqSXllfxSOdXH1Uem6eIsyAPhgBVnKPkJrVyN0W1KQ9tJD3kjmS56Gd
         vJbH+34DOqieDXS1onfGjlEUQH37U0xvECmlf4pqJoax1KYoxFrGtoEYXG+T867RuS
         ZQxed778YBQ7/5XeLS+mOaknxeploAgd6zAqS921m9Ie+z95WzSw77vsWvUq0rprKe
         XxmzGEVbtoY1v5WCn246m3Nwxkju9RSZNAl1CSM/B8hK1qGufnmvHN6jWkLaoWXxBx
         THI+/vreu6hPhQSNyjFSgpVR1nivY21R63CyKSpa1I+M7Ez6h9ThNozdEBKp3lcp+d
         ZoykiY7MTpTkA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oder Chiou <oder_chiou@realtek.com>,
        Sameer Pujar <spujar@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 44/54] ASoC: rt5640: Fix the wrong state of JD1 and JD2
Date:   Tue, 19 Jul 2022 21:10:21 -0400
Message-Id: <20220720011031.1023305-44-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011031.1023305-1-sashal@kernel.org>
References: <20220720011031.1023305-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oder Chiou <oder_chiou@realtek.com>

[ Upstream commit 051dade346957d5b68ad986f497835805fa7a9dd ]

The patch fixes the wrong state of JD1 and JD2 while the bst1 or bst2 is
power on in the HDA JD using.

Signed-off-by: Oder Chiou <oder_chiou@realtek.com>
Reported-by: Sameer Pujar <spujar@nvidia.com>
Link: https://lore.kernel.org/r/20220705101134.16792-1-oder_chiou@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5640.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/sound/soc/codecs/rt5640.c b/sound/soc/codecs/rt5640.c
index 3559d9ecfa07..188c8f401a47 100644
--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -1984,7 +1984,12 @@ static int rt5640_set_bias_level(struct snd_soc_component *component,
 		snd_soc_component_write(component, RT5640_PWR_DIG2, 0x0000);
 		snd_soc_component_write(component, RT5640_PWR_VOL, 0x0000);
 		snd_soc_component_write(component, RT5640_PWR_MIXER, 0x0000);
-		snd_soc_component_write(component, RT5640_PWR_ANLG1, 0x0000);
+		if (rt5640->jd_src == RT5640_JD_SRC_HDA_HEADER)
+			snd_soc_component_write(component, RT5640_PWR_ANLG1,
+				0x0018);
+		else
+			snd_soc_component_write(component, RT5640_PWR_ANLG1,
+				0x0000);
 		snd_soc_component_write(component, RT5640_PWR_ANLG2, 0x0000);
 		break;
 
@@ -2393,9 +2398,15 @@ static void rt5640_jack_work(struct work_struct *work)
 static irqreturn_t rt5640_irq(int irq, void *data)
 {
 	struct rt5640_priv *rt5640 = data;
+	int delay = 0;
+
+	if (rt5640->jd_src == RT5640_JD_SRC_HDA_HEADER) {
+		cancel_delayed_work_sync(&rt5640->jack_work);
+		delay = 100;
+	}
 
 	if (rt5640->jack)
-		queue_delayed_work(system_long_wq, &rt5640->jack_work, 0);
+		queue_delayed_work(system_long_wq, &rt5640->jack_work, delay);
 
 	return IRQ_HANDLED;
 }
@@ -2580,6 +2591,12 @@ static void rt5640_enable_hda_jack_detect(
 
 	snd_soc_component_update_bits(component, RT5640_DUMMY1, 0x400, 0x0);
 
+	snd_soc_component_update_bits(component, RT5640_PWR_ANLG1,
+		RT5640_PWR_VREF2, RT5640_PWR_VREF2);
+	usleep_range(10000, 15000);
+	snd_soc_component_update_bits(component, RT5640_PWR_ANLG1,
+		RT5640_PWR_FV2, RT5640_PWR_FV2);
+
 	rt5640->jack = jack;
 
 	ret = request_irq(rt5640->irq, rt5640_irq,
@@ -2696,16 +2713,13 @@ static int rt5640_probe(struct snd_soc_component *component)
 
 	if (device_property_read_u32(component->dev,
 				     "realtek,jack-detect-source", &val) == 0) {
-		if (val <= RT5640_JD_SRC_GPIO4) {
+		if (val <= RT5640_JD_SRC_GPIO4)
 			rt5640->jd_src = val << RT5640_JD_SFT;
-		} else if (val == RT5640_JD_SRC_HDA_HEADER) {
+		else if (val == RT5640_JD_SRC_HDA_HEADER)
 			rt5640->jd_src = RT5640_JD_SRC_HDA_HEADER;
-			snd_soc_component_update_bits(component, RT5640_DUMMY1,
-				0x0300, 0x0);
-		} else {
+		else
 			dev_warn(component->dev, "Warning: Invalid jack-detect-source value: %d, leaving jack-detect disabled\n",
 				 val);
-		}
 	}
 
 	if (!device_property_read_bool(component->dev, "realtek,jack-detect-not-inverted"))
-- 
2.35.1

