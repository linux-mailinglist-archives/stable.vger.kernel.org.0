Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3B60191DE
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbfEITBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 15:01:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727262AbfEISuq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:50:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2917F2177E;
        Thu,  9 May 2019 18:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427845;
        bh=YX3+YfrWcRrg3w26p8h5VeKNgG+y16CzzzJAS8dUiDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gb0Z302z7OW7gsgbGJy4QUIsJ3H4RTJWM8ZfPPOUS+zLyMmYRNcWZyDFDizTIAQLL
         pRysTX0eEKVvLZTdHWPIx0BmD4YbKXHKivbIsB4HnNwmbgK6iMriYGktWeUDqWkb6Z
         sk5D3e5icZm7DpS+I3Bee3cMlvqr6UbOO3sfYSrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivier Moysan <olivier.moysan@st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 25/95] ASoC: stm32: dfsdm: manage multiple prepare
Date:   Thu,  9 May 2019 20:41:42 +0200
Message-Id: <20190509181311.082186104@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 19441e35a43b616ea6afad91ed0d9e77268d8f6a ]

The DFSDM must be stopped when a new setting is applied.
restart systematically DFSDM on multiple prepare calls,
to apply changes.

Signed-off-by: Olivier Moysan <olivier.moysan@st.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_adfsdm.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/sound/soc/stm/stm32_adfsdm.c b/sound/soc/stm/stm32_adfsdm.c
index 706ff005234f3..71d341b732a4d 100644
--- a/sound/soc/stm/stm32_adfsdm.c
+++ b/sound/soc/stm/stm32_adfsdm.c
@@ -9,6 +9,7 @@
 
 #include <linux/clk.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
@@ -37,6 +38,8 @@ struct stm32_adfsdm_priv {
 	/* PCM buffer */
 	unsigned char *pcm_buff;
 	unsigned int pos;
+
+	struct mutex lock; /* protect against race condition on iio state */
 };
 
 static const struct snd_pcm_hardware stm32_adfsdm_pcm_hw = {
@@ -62,10 +65,12 @@ static void stm32_adfsdm_shutdown(struct snd_pcm_substream *substream,
 {
 	struct stm32_adfsdm_priv *priv = snd_soc_dai_get_drvdata(dai);
 
+	mutex_lock(&priv->lock);
 	if (priv->iio_active) {
 		iio_channel_stop_all_cb(priv->iio_cb);
 		priv->iio_active = false;
 	}
+	mutex_unlock(&priv->lock);
 }
 
 static int stm32_adfsdm_dai_prepare(struct snd_pcm_substream *substream,
@@ -74,13 +79,19 @@ static int stm32_adfsdm_dai_prepare(struct snd_pcm_substream *substream,
 	struct stm32_adfsdm_priv *priv = snd_soc_dai_get_drvdata(dai);
 	int ret;
 
+	mutex_lock(&priv->lock);
+	if (priv->iio_active) {
+		iio_channel_stop_all_cb(priv->iio_cb);
+		priv->iio_active = false;
+	}
+
 	ret = iio_write_channel_attribute(priv->iio_ch,
 					  substream->runtime->rate, 0,
 					  IIO_CHAN_INFO_SAMP_FREQ);
 	if (ret < 0) {
 		dev_err(dai->dev, "%s: Failed to set %d sampling rate\n",
 			__func__, substream->runtime->rate);
-		return ret;
+		goto out;
 	}
 
 	if (!priv->iio_active) {
@@ -92,6 +103,9 @@ static int stm32_adfsdm_dai_prepare(struct snd_pcm_substream *substream,
 				__func__, ret);
 	}
 
+out:
+	mutex_unlock(&priv->lock);
+
 	return ret;
 }
 
@@ -298,6 +312,7 @@ static int stm32_adfsdm_probe(struct platform_device *pdev)
 
 	priv->dev = &pdev->dev;
 	priv->dai_drv = stm32_adfsdm_dai;
+	mutex_init(&priv->lock);
 
 	dev_set_drvdata(&pdev->dev, priv);
 
-- 
2.20.1



