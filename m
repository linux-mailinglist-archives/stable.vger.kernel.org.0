Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2C7663DF5B
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiK3Sq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbiK3SqK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:46:10 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11849894E
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:46:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6CA17CE1AD9
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:46:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32497C433D6;
        Wed, 30 Nov 2022 18:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833965;
        bh=SACIet4rI6RT99ooF1BnEEeciyx4H/mj7PXOQzGF7t4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gHmPUMCs9UcwgJZLthJiN2DNwfF77ZV5OnUOXB+BGdiXBN1H1ZMtgICZJE+NXnd/o
         LTyxj3OKsJq10iJcluXZb4McU9DjRlJ6nJE5X/ojO35qwE2T3Kdm6zk7/eiPDmTIyX
         2IcG7dFtkxNQyYFNwfQvBl6XhIJ42Qic7/W0s8Vs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 052/289] ASoC: SOF: Intel: Introduce HDA codec init and exit routines
Date:   Wed, 30 Nov 2022 19:20:37 +0100
Message-Id: <20221130180545.309338514@linuxfoundation.org>
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

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 829c67319806009abfe3b0b82b3b8b153a2c5e32 ]

Preliminary step in making snd_hda_codec_device_init() the only
constructor for struct hda_codec instances. To do that, existing usage
of hdac_ext equivalents has to be dropped.

Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Acked-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220816111727.3218543-3-cezary.rojewski@intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 37882100cd06 ("ASoC: hdac_hda: fix hda pcm buffer overflow issue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-codec.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/sound/soc/sof/intel/hda-codec.c b/sound/soc/sof/intel/hda-codec.c
index 2f3f4a733d9e..4c128ba02340 100644
--- a/sound/soc/sof/intel/hda-codec.c
+++ b/sound/soc/sof/intel/hda-codec.c
@@ -109,6 +109,36 @@ EXPORT_SYMBOL_NS(hda_codec_jack_check, SND_SOC_SOF_HDA_AUDIO_CODEC);
 #define is_generic_config(x)	0
 #endif
 
+static void hda_codec_device_exit(struct device *dev)
+{
+	snd_hdac_device_exit(dev_to_hdac_dev(dev));
+}
+
+static __maybe_unused struct hda_codec *
+hda_codec_device_init(struct hdac_bus *bus, int addr, int type)
+{
+	struct hda_codec *codec;
+	int ret;
+
+	codec = snd_hda_codec_device_init(to_hda_bus(bus), addr, "ehdaudio%dD%d", bus->idx, addr);
+	if (IS_ERR(codec)) {
+		dev_err(bus->dev, "device init failed for hdac device\n");
+		return codec;
+	}
+
+	codec->core.type = type;
+	codec->core.dev.release = hda_codec_device_exit;
+
+	ret = snd_hdac_device_register(&codec->core);
+	if (ret) {
+		dev_err(bus->dev, "failed to register hdac device\n");
+		snd_hdac_device_exit(&codec->core);
+		return ERR_PTR(ret);
+	}
+
+	return codec;
+}
+
 /* probe individual codec */
 static int hda_codec_probe(struct snd_sof_dev *sdev, int address,
 			   bool hda_codec_use_common_hdmi)
-- 
2.35.1



