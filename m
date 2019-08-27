Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2599E150
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729735AbfH0IBQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:01:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731716AbfH0IBP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:01:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C648821881;
        Tue, 27 Aug 2019 08:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892874;
        bh=iiC1Qt9KSuo2sLbQduNQYmdPT7v3EU1qAFJ/FbFh6LI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OikTJubXJ1XE3Y4+AJFxyeIgl1UmEgX2GNfYpCII4MrR70q1MpczaAYhP7wgWP9fS
         qHY2iSzXjV5gRrgPv+oww2+t0/vwnXJoBB0+2/VRhmqPhjOwOfenlsjuSTgomRjimB
         GVFxBLw83/vkyTpbu4JJXLvxazBtUoWChq1ITB00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 043/162] ASoC: ti: davinci-mcasp: Correct slot_width posed constraint
Date:   Tue, 27 Aug 2019 09:49:31 +0200
Message-Id: <20190827072739.747310334@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1e112c35e3c96db7c8ca6ddaa96574f00c06e7db ]

The slot_width is a property for the bus while the constraint for
SNDRV_PCM_HW_PARAM_SAMPLE_BITS is for the in memory format.

Applying slot_width constraint to sample_bits works most of the time, but
it will blacklist valid formats in some cases.

With slot_width 24 we can support S24_3LE and S24_LE formats as they both
look the same on the bus, but a a 24 constraint on sample_bits would not
allow S24_LE as it is stored in 32bits in memory.

Implement a simple hw_rule function to allow all formats which require less
or equal number of bits on the bus as slot_width (if configured).

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/20190726064244.3762-2-peter.ujfalusi@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ti/davinci-mcasp.c | 43 ++++++++++++++++++++++++++++--------
 1 file changed, 34 insertions(+), 9 deletions(-)

diff --git a/sound/soc/ti/davinci-mcasp.c b/sound/soc/ti/davinci-mcasp.c
index dc01bbca0ff69..56009d1472084 100644
--- a/sound/soc/ti/davinci-mcasp.c
+++ b/sound/soc/ti/davinci-mcasp.c
@@ -1254,6 +1254,28 @@ static int davinci_mcasp_trigger(struct snd_pcm_substream *substream,
 	return ret;
 }
 
+static int davinci_mcasp_hw_rule_slot_width(struct snd_pcm_hw_params *params,
+					    struct snd_pcm_hw_rule *rule)
+{
+	struct davinci_mcasp_ruledata *rd = rule->private;
+	struct snd_mask *fmt = hw_param_mask(params, SNDRV_PCM_HW_PARAM_FORMAT);
+	struct snd_mask nfmt;
+	int i, slot_width;
+
+	snd_mask_none(&nfmt);
+	slot_width = rd->mcasp->slot_width;
+
+	for (i = 0; i <= SNDRV_PCM_FORMAT_LAST; i++) {
+		if (snd_mask_test(fmt, i)) {
+			if (snd_pcm_format_width(i) <= slot_width) {
+				snd_mask_set(&nfmt, i);
+			}
+		}
+	}
+
+	return snd_mask_refine(fmt, &nfmt);
+}
+
 static const unsigned int davinci_mcasp_dai_rates[] = {
 	8000, 11025, 16000, 22050, 32000, 44100, 48000, 64000,
 	88200, 96000, 176400, 192000,
@@ -1361,7 +1383,7 @@ static int davinci_mcasp_startup(struct snd_pcm_substream *substream,
 	struct davinci_mcasp_ruledata *ruledata =
 					&mcasp->ruledata[substream->stream];
 	u32 max_channels = 0;
-	int i, dir;
+	int i, dir, ret;
 	int tdm_slots = mcasp->tdm_slots;
 
 	/* Do not allow more then one stream per direction */
@@ -1390,6 +1412,7 @@ static int davinci_mcasp_startup(struct snd_pcm_substream *substream,
 			max_channels++;
 	}
 	ruledata->serializers = max_channels;
+	ruledata->mcasp = mcasp;
 	max_channels *= tdm_slots;
 	/*
 	 * If the already active stream has less channels than the calculated
@@ -1415,20 +1438,22 @@ static int davinci_mcasp_startup(struct snd_pcm_substream *substream,
 				   0, SNDRV_PCM_HW_PARAM_CHANNELS,
 				   &mcasp->chconstr[substream->stream]);
 
-	if (mcasp->slot_width)
-		snd_pcm_hw_constraint_minmax(substream->runtime,
-					     SNDRV_PCM_HW_PARAM_SAMPLE_BITS,
-					     8, mcasp->slot_width);
+	if (mcasp->slot_width) {
+		/* Only allow formats require <= slot_width bits on the bus */
+		ret = snd_pcm_hw_rule_add(substream->runtime, 0,
+					  SNDRV_PCM_HW_PARAM_FORMAT,
+					  davinci_mcasp_hw_rule_slot_width,
+					  ruledata,
+					  SNDRV_PCM_HW_PARAM_FORMAT, -1);
+		if (ret)
+			return ret;
+	}
 
 	/*
 	 * If we rely on implicit BCLK divider setting we should
 	 * set constraints based on what we can provide.
 	 */
 	if (mcasp->bclk_master && mcasp->bclk_div == 0 && mcasp->sysclk_freq) {
-		int ret;
-
-		ruledata->mcasp = mcasp;
-
 		ret = snd_pcm_hw_rule_add(substream->runtime, 0,
 					  SNDRV_PCM_HW_PARAM_RATE,
 					  davinci_mcasp_hw_rule_rate,
-- 
2.20.1



