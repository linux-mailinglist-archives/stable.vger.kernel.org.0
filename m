Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B42414E184
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730965AbgA3SpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:45:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:54634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730690AbgA3SpJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:45:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8ECFA205F4;
        Thu, 30 Jan 2020 18:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409908;
        bh=CKCrECNmgHj6S4af5+GDElQKarJnX+Ott2IWHk8nNoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UcaGNdzj9gmyz52f93wZtCh9OSy2ahCC/J1jhPxka90VPpZtp6FI+Z52ga4S4iMhR
         bjjylz6UqN90eq3U/M5VfnEKjmcLR34iV8aKgGXWaCQs6FC1xqHTLK6d2hCKBGOiwr
         y/5HNEN9QtaBkAJLiTt0fvnywoGT15NMQTG+VwTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 053/110] ASoC: SOF: Intel: hda: hda-dai: fix oops on hda_link .hw_free
Date:   Thu, 30 Jan 2020 19:38:29 +0100
Message-Id: <20200130183621.422518579@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 921162c81a089aa2f442103290f1af9ba281fc9f ]

When the PCM_PARAM IPC fails while configuring the FE, the kernel
oopses in the HDaudio link DMA .hw_free operation. The root cause is a
NULL dma_data since the BE .hw_params was never called by the SOC
core.

This error can also happen if the HDaudio link DMA configuration IPC
fails in the BE .hw_params.

This patches makes sure the dma_data is properly saved in .hw_params,
and tested before being use in hw_free.

GitHub issue: https://github.com/thesofproject/linux/issues/1417

Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20191218000518.5830-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-dai.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/intel/hda-dai.c b/sound/soc/sof/intel/hda-dai.c
index 8796f385be76c..896d21984b735 100644
--- a/sound/soc/sof/intel/hda-dai.c
+++ b/sound/soc/sof/intel/hda-dai.c
@@ -216,6 +216,8 @@ static int hda_link_hw_params(struct snd_pcm_substream *substream,
 		link_dev = hda_link_stream_assign(bus, substream);
 		if (!link_dev)
 			return -EBUSY;
+
+		snd_soc_dai_set_dma_data(dai, substream, (void *)link_dev);
 	}
 
 	stream_tag = hdac_stream(link_dev)->stream_tag;
@@ -228,8 +230,6 @@ static int hda_link_hw_params(struct snd_pcm_substream *substream,
 	if (ret < 0)
 		return ret;
 
-	snd_soc_dai_set_dma_data(dai, substream, (void *)link_dev);
-
 	link = snd_hdac_ext_bus_get_link(bus, codec_dai->component->name);
 	if (!link)
 		return -EINVAL;
@@ -361,6 +361,13 @@ static int hda_link_hw_free(struct snd_pcm_substream *substream,
 	bus = hstream->bus;
 	rtd = snd_pcm_substream_chip(substream);
 	link_dev = snd_soc_dai_get_dma_data(dai, substream);
+
+	if (!link_dev) {
+		dev_dbg(dai->dev,
+			"%s: link_dev is not assigned\n", __func__);
+		return -EINVAL;
+	}
+
 	hda_stream = hstream_to_sof_hda_stream(link_dev);
 
 	/* free the link DMA channel in the FW */
-- 
2.20.1



