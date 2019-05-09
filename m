Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A180190C5
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbfEISsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:48:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726906AbfEISsm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:48:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D3AF2183E;
        Thu,  9 May 2019 18:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427721;
        bh=AYeoGN273AXyjiMv89OcvbcdISNL0ikD9NfcKVEP0pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h0T19ikhrg3IBow/8936KD1zvqinR9emRhULnJxjrbpoFO72oWL9jv81ufFj9lCi/
         7zv4SP+nHJv6pHiOHtvnPSi56+6CZ/JD8qXyx2COrGnAIciYX0iGqSSOalVpctscn5
         /M1SmXnQdN2hJ5YlF6DAbWA1MOsZG701Ek9mUEbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rander Wang <rander.wang@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/66] ASoC:intel:skl:fix a simultaneous playback & capture issue on hda platform
Date:   Thu,  9 May 2019 20:41:47 +0200
Message-Id: <20190509181303.215614019@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181301.719249738@linuxfoundation.org>
References: <20190509181301.719249738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c899df3e9b0bf7b76e642aed1a214582ea7012d5 ]

If playback and capture are enabled concurrently, when the capture stops
the output becomes inaudile. The playback application will become stuck
and underrun after a timeout.

This is caused by mistaken use of the stream_id, which should only be
set for playback and not for capture

Tested on Apollolake and Kabylake with SST driver.

Signed-off-by: Rander Wang <rander.wang@linux.intel.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/skylake/skl-pcm.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/sound/soc/intel/skylake/skl-pcm.c b/sound/soc/intel/skylake/skl-pcm.c
index 823e39103edd3..6b2c8c6e7a00f 100644
--- a/sound/soc/intel/skylake/skl-pcm.c
+++ b/sound/soc/intel/skylake/skl-pcm.c
@@ -180,6 +180,7 @@ int skl_pcm_link_dma_prepare(struct device *dev, struct skl_pipe_params *params)
 	struct hdac_stream *hstream;
 	struct hdac_ext_stream *stream;
 	struct hdac_ext_link *link;
+	unsigned char stream_tag;
 
 	hstream = snd_hdac_get_stream(bus, params->stream,
 					params->link_dma_id + 1);
@@ -198,10 +199,13 @@ int skl_pcm_link_dma_prepare(struct device *dev, struct skl_pipe_params *params)
 
 	snd_hdac_ext_link_stream_setup(stream, format_val);
 
-	list_for_each_entry(link, &bus->hlink_list, list) {
-		if (link->index == params->link_index)
-			snd_hdac_ext_link_set_stream_id(link,
-					hstream->stream_tag);
+	stream_tag = hstream->stream_tag;
+	if (stream->hstream.direction == SNDRV_PCM_STREAM_PLAYBACK) {
+		list_for_each_entry(link, &bus->hlink_list, list) {
+			if (link->index == params->link_index)
+				snd_hdac_ext_link_set_stream_id(link,
+								stream_tag);
+		}
 	}
 
 	stream->link_prepared = 1;
@@ -640,6 +644,7 @@ static int skl_link_hw_free(struct snd_pcm_substream *substream,
 	struct hdac_ext_stream *link_dev =
 				snd_soc_dai_get_dma_data(dai, substream);
 	struct hdac_ext_link *link;
+	unsigned char stream_tag;
 
 	dev_dbg(dai->dev, "%s: %s\n", __func__, dai->name);
 
@@ -649,7 +654,11 @@ static int skl_link_hw_free(struct snd_pcm_substream *substream,
 	if (!link)
 		return -EINVAL;
 
-	snd_hdac_ext_link_clear_stream_id(link, hdac_stream(link_dev)->stream_tag);
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		stream_tag = hdac_stream(link_dev)->stream_tag;
+		snd_hdac_ext_link_clear_stream_id(link, stream_tag);
+	}
+
 	snd_hdac_ext_stream_release(link_dev, HDAC_EXT_STREAM_TYPE_LINK);
 	return 0;
 }
-- 
2.20.1



