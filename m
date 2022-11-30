Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C07363E032
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbiK3Syg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbiK3Sye (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:54:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020A963D41
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:54:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD629B81CA9
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:54:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23485C433D6;
        Wed, 30 Nov 2022 18:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834465;
        bh=NP08Bu41lnXELqkflD2hs9IQL0DrhHcjsLCdz4Yc2as=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S5wo2rM+c77omhdnKWj1jrQrgrEud9ShRjkJDkLNuQ21Yi5ic/2TyF26UowqY9UUB
         nS4xZaffPau+iW6NiILIhlfJgIgmfeGgmU6IKpx17kC1xjQ+XjP+iE5spyBROo/yIQ
         mIMEFc29fhNLn1djVvNoq2Q149kMLMarHwfAhvfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhu Ning <zhuning@everest-semi.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 236/289] ASoC: sof_es8336: reduce pop noise on speaker
Date:   Wed, 30 Nov 2022 19:23:41 +0100
Message-Id: <20221130180549.461699381@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhu Ning <zhuning0077@gmail.com>

[ Upstream commit 89cdb224f2abe37ec4ac21ba0d9ddeb5a6a9cf68 ]

The Speaker GPIO needs to be turned on slightly behind the codec turned on.
It also need to be turned off slightly before the codec turned down.
Current code uses delay in DAPM_EVENT to do it but the mdelay delays the
DAPM itself and thus has no effect. A delayed_work is added to turn on the
speaker.
The Speaker is turned off in .trigger since trigger is called slightly
before the DAPM events.

Signed-off-by: Zhu Ning <zhuning@everest-semi.com>

------------

v1: cancel delayed work while disabling speaker.
Link: https://lore.kernel.org/r/20221028020456.90286-1-zhuning0077@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_es8336.c | 60 ++++++++++++++++++++++-------
 1 file changed, 46 insertions(+), 14 deletions(-)

diff --git a/sound/soc/intel/boards/sof_es8336.c b/sound/soc/intel/boards/sof_es8336.c
index 606cc3242a60..5c218a39ca20 100644
--- a/sound/soc/intel/boards/sof_es8336.c
+++ b/sound/soc/intel/boards/sof_es8336.c
@@ -63,6 +63,7 @@ struct sof_es8336_private {
 	struct snd_soc_jack jack;
 	struct list_head hdmi_pcm_list;
 	bool speaker_en;
+	struct delayed_work pcm_pop_work;
 };
 
 struct sof_hdmi_pcm {
@@ -111,6 +112,46 @@ static void log_quirks(struct device *dev)
 		dev_info(dev, "quirk headset at mic1 port enabled\n");
 }
 
+static void pcm_pop_work_events(struct work_struct *work)
+{
+	struct sof_es8336_private *priv =
+		container_of(work, struct sof_es8336_private, pcm_pop_work.work);
+
+	gpiod_set_value_cansleep(priv->gpio_speakers, priv->speaker_en);
+
+	if (quirk & SOF_ES8336_HEADPHONE_GPIO)
+		gpiod_set_value_cansleep(priv->gpio_headphone, priv->speaker_en);
+
+}
+
+static int sof_8336_trigger(struct snd_pcm_substream *substream, int cmd)
+{
+	struct snd_soc_pcm_runtime *rtd = asoc_substream_to_rtd(substream);
+	struct snd_soc_card *card = rtd->card;
+	struct sof_es8336_private *priv = snd_soc_card_get_drvdata(card);
+
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+	case SNDRV_PCM_TRIGGER_RESUME:
+		break;
+
+	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+	case SNDRV_PCM_TRIGGER_STOP:
+		if (priv->speaker_en == false)
+			if (substream->stream == 0) {
+				cancel_delayed_work(&priv->pcm_pop_work);
+				gpiod_set_value_cansleep(priv->gpio_speakers, true);
+			}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int sof_es8316_speaker_power_event(struct snd_soc_dapm_widget *w,
 					  struct snd_kcontrol *kcontrol, int event)
 {
@@ -122,19 +163,7 @@ static int sof_es8316_speaker_power_event(struct snd_soc_dapm_widget *w,
 
 	priv->speaker_en = !SND_SOC_DAPM_EVENT_ON(event);
 
-	if (SND_SOC_DAPM_EVENT_ON(event))
-		msleep(70);
-
-	gpiod_set_value_cansleep(priv->gpio_speakers, priv->speaker_en);
-
-	if (!(quirk & SOF_ES8336_HEADPHONE_GPIO))
-		return 0;
-
-	if (SND_SOC_DAPM_EVENT_ON(event))
-		msleep(70);
-
-	gpiod_set_value_cansleep(priv->gpio_headphone, priv->speaker_en);
-
+	queue_delayed_work(system_wq, &priv->pcm_pop_work, msecs_to_jiffies(70));
 	return 0;
 }
 
@@ -344,6 +373,7 @@ static int sof_es8336_hw_params(struct snd_pcm_substream *substream,
 /* machine stream operations */
 static struct snd_soc_ops sof_es8336_ops = {
 	.hw_params = sof_es8336_hw_params,
+	.trigger = sof_8336_trigger,
 };
 
 static struct snd_soc_dai_link_component platform_component[] = {
@@ -722,7 +752,8 @@ static int sof_es8336_probe(struct platform_device *pdev)
 	}
 
 	INIT_LIST_HEAD(&priv->hdmi_pcm_list);
-
+	INIT_DELAYED_WORK(&priv->pcm_pop_work,
+				pcm_pop_work_events);
 	snd_soc_card_set_drvdata(card, priv);
 
 	if (mach->mach_params.dmic_num > 0) {
@@ -751,6 +782,7 @@ static int sof_es8336_remove(struct platform_device *pdev)
 	struct snd_soc_card *card = platform_get_drvdata(pdev);
 	struct sof_es8336_private *priv = snd_soc_card_get_drvdata(card);
 
+	cancel_delayed_work(&priv->pcm_pop_work);
 	gpiod_put(priv->gpio_speakers);
 	device_remove_software_node(priv->codec_dev);
 	put_device(priv->codec_dev);
-- 
2.35.1



