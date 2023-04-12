Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7746DEFBA
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbjDLIxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbjDLIxT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:53:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2926A24B
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:52:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72DE762FF1
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:51:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87870C433EF;
        Wed, 12 Apr 2023 08:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289511;
        bh=8HeqEwN9bz79Z34xpNI0lFd2kG0CISYLc/kdcOkTMdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lCJzcV1w78ZJImnbJY1X7qEqPDcIVGKeZe/KzLf+06cmSINzjkqBgTjjPNPf5p40L
         ZW95YnQSm2aIvSFndzPvhJrHjhzVHzmSsUgDvcmRcwJVIL6295OpFErXk4Bg8xEqjt
         1rQ2Fh0tPD/6wrAcWbsLy5bcO+Wgtgp8iDM9pYDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jason Montleon <jmontleo@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.2 128/173] ASoC: hdac_hdmi: use set_stream() instead of set_tdm_slots()
Date:   Wed, 12 Apr 2023 10:34:14 +0200
Message-Id: <20230412082843.326160940@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Montleon <jmontleo@redhat.com>

commit f6887a71bdd2f0dcba9b8180dd2223cfa8637e85 upstream.

hdac_hdmi was not updated to use set_stream() instead of set_tdm_slots()
in the original commit so HDMI no longer produces audio.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/regressions/CAJD_bPKQdtaExvVEKxhQ47G-ZXDA=k+gzhMJRHLBe=mysPnuKA@mail.gmail.com/
Fixes: 636110411ca7 ("ASoC: Intel/SOF: use set_stream() instead of set_tdm_slots() for HDAudio")
Signed-off-by: Jason Montleon <jmontleo@redhat.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20230324170711.2526-1-jmontleo@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/hdac_hdmi.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/sound/soc/codecs/hdac_hdmi.c
+++ b/sound/soc/codecs/hdac_hdmi.c
@@ -436,23 +436,28 @@ static int hdac_hdmi_setup_audio_infofra
 	return 0;
 }
 
-static int hdac_hdmi_set_tdm_slot(struct snd_soc_dai *dai,
-		unsigned int tx_mask, unsigned int rx_mask,
-		int slots, int slot_width)
+static int hdac_hdmi_set_stream(struct snd_soc_dai *dai,
+				void *stream, int direction)
 {
 	struct hdac_hdmi_priv *hdmi = snd_soc_dai_get_drvdata(dai);
 	struct hdac_device *hdev = hdmi->hdev;
 	struct hdac_hdmi_dai_port_map *dai_map;
 	struct hdac_hdmi_pcm *pcm;
+	struct hdac_stream *hstream;
 
-	dev_dbg(&hdev->dev, "%s: strm_tag: %d\n", __func__, tx_mask);
+	if (!stream)
+		return -EINVAL;
+
+	hstream = (struct hdac_stream *)stream;
+
+	dev_dbg(&hdev->dev, "%s: strm_tag: %d\n", __func__, hstream->stream_tag);
 
 	dai_map = &hdmi->dai_map[dai->id];
 
 	pcm = hdac_hdmi_get_pcm_from_cvt(hdmi, dai_map->cvt);
 
 	if (pcm)
-		pcm->stream_tag = (tx_mask << 4);
+		pcm->stream_tag = (hstream->stream_tag << 4);
 
 	return 0;
 }
@@ -1544,7 +1549,7 @@ static const struct snd_soc_dai_ops hdmi
 	.startup = hdac_hdmi_pcm_open,
 	.shutdown = hdac_hdmi_pcm_close,
 	.hw_params = hdac_hdmi_set_hw_params,
-	.set_tdm_slot = hdac_hdmi_set_tdm_slot,
+	.set_stream = hdac_hdmi_set_stream,
 };
 
 /*


