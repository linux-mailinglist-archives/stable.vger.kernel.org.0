Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9116549A354
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2366243AbiAXXwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1845409AbiAXXMO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:12:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C86FC028C17;
        Mon, 24 Jan 2022 13:19:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73D46B80FA1;
        Mon, 24 Jan 2022 21:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3327C340E5;
        Mon, 24 Jan 2022 21:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059166;
        bh=CjNurEu/6+GsUqTQ4NQoldgfbFXncMWtPF0rfbat62k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E92vEJtcPCkzkqsLYZn4fiUMytUYzCiXPoQHY0avIeZa2rVc63L45Ble4419bwICz
         /osIhah8Bt+lhXJHp2qteLnp8jHnvhLaWSGMURrl1VxvOiSLGwKz6RPocA6xjtHEtg
         lpxTPGUqp3Sn9HR5cnxNoGqceSxyCHa0Z3Jsxl8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0526/1039] ASoC: imx-card: Fix mclk calculation issue for akcodec
Date:   Mon, 24 Jan 2022 19:38:35 +0100
Message-Id: <20220124184142.962408139@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit f331ae5fa59fbfb748317b290648fc3f1a50d932 ]

Transfer the refined slots and slot_width to akcodec_get_mclk_rate()
for mclk calculation, otherwise the mclk frequency does not match
with the slots and slot_width for S16_LE format, because the default
slot_width is 32.

Fixes: aa736700f42f ("ASoC: imx-card: Add imx-card machine driver")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1641292835-19085-3-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-card.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/soc/fsl/imx-card.c b/sound/soc/fsl/imx-card.c
index 96ac1e465fade..84a8dcdee9316 100644
--- a/sound/soc/fsl/imx-card.c
+++ b/sound/soc/fsl/imx-card.c
@@ -247,13 +247,14 @@ static bool codec_is_akcodec(unsigned int type)
 }
 
 static unsigned long akcodec_get_mclk_rate(struct snd_pcm_substream *substream,
-					   struct snd_pcm_hw_params *params)
+					   struct snd_pcm_hw_params *params,
+					   int slots, int slot_width)
 {
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
 	struct imx_card_data *data = snd_soc_card_get_drvdata(rtd->card);
 	const struct imx_card_plat_data *plat_data = data->plat_data;
 	struct dai_link_data *link_data = &data->link_data[rtd->num];
-	unsigned int width = link_data->slots * link_data->slot_width;
+	unsigned int width = slots * slot_width;
 	unsigned int rate = params_rate(params);
 	int i;
 
@@ -349,7 +350,7 @@ static int imx_aif_hw_params(struct snd_pcm_substream *substream,
 
 	/* Set MCLK freq */
 	if (codec_is_akcodec(plat_data->type))
-		mclk_freq = akcodec_get_mclk_rate(substream, params);
+		mclk_freq = akcodec_get_mclk_rate(substream, params, slots, slot_width);
 	else
 		mclk_freq = params_rate(params) * slots * slot_width;
 	/* Use the maximum freq from DSD512 (512*44100 = 22579200) */
-- 
2.34.1



