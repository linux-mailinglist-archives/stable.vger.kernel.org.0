Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76D56635D44
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237340AbiKWMmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:42:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237106AbiKWMl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:41:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DF36BDC3;
        Wed, 23 Nov 2022 04:41:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A38C361C67;
        Wed, 23 Nov 2022 12:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35516C433D6;
        Wed, 23 Nov 2022 12:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207293;
        bh=NP08Bu41lnXELqkflD2hs9IQL0DrhHcjsLCdz4Yc2as=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TCVFyfqYC3cQZGgsnSlTrH9cKkkWgGW3fXkww52cyI+E5DODOR6UJ3X+oDUmlyGdW
         71QTEVPaC0o9855ZefGk3RZE7oowdLEpAChsGl0kWto8d5RfpPqzJlZ1WEeJAMfZkm
         KUtwWAQDgCDmpO2ItQXniygpUDmktszK0awy2yaZUn1jYVMNqDOlmRCvrDfqmI7/jn
         VvJWuIzXkUGYPfsE7aD3iWQV96JKMM/uGKqjKpWNX8tpt9X+EMQGMLVIc+f9QnocIE
         +DKxKJCU+mdX7HTPvYu/4GOolSsaglZ96xkhwszuKZMeL+ESIEdji+0j/j4ZQsa1KN
         x/GTH3xla3Hfw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhu Ning <zhuning0077@gmail.com>,
        Zhu Ning <zhuning@everest-semi.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, cezary.rojewski@intel.com,
        pierre-louis.bossart@linux.intel.com,
        liam.r.girdwood@linux.intel.com, peter.ujfalusi@linux.intel.com,
        yung-chuan.liao@linux.intel.com, ranjani.sridharan@linux.intel.com,
        kai.vehmanen@linux.intel.com, perex@perex.cz, tiwai@suse.com,
        mchehab@kernel.org, muralidhar.reddy@intel.com,
        andrey.turkin@gmail.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.0 14/44] ASoC: sof_es8336: reduce pop noise on speaker
Date:   Wed, 23 Nov 2022 07:40:23 -0500
Message-Id: <20221123124057.264822-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124057.264822-1-sashal@kernel.org>
References: <20221123124057.264822-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

