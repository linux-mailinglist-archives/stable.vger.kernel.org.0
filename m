Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99D161216AE
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730063AbfLPSLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:11:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:56176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730832AbfLPSLs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:11:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD9352072D;
        Mon, 16 Dec 2019 18:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519908;
        bh=00g5RKiIENXMC3oLyUK6qvQXapP1X6bpjKBjMZkmUmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qGIFrQaobMNG/LsTmsqCpIuCF47JVbxBxTt8vdWD+/lrpzWx8NmT+OHYOd8delBqY
         Z+CIwFn7FYDwtpX2a65M258xAH4691aNuKe9hJtzDRj+clrM5MKbGGQRYhIYqTz+Z4
         NC2teG/eE+XygGsQ0ngiKrN60Sd1fU9Q+elI0UvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.3 078/180] ASoC: fsl_audmix: Add spin lock to protect tdms
Date:   Mon, 16 Dec 2019 18:48:38 +0100
Message-Id: <20191216174830.960022512@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

commit fe965096c9495ddcf78ec163348105e2baf8d185 upstream.

Audmix support two substream, When two substream start
to run, the trigger function may be called by two substream
in same time, that the priv->tdms may be updated wrongly.

The expected priv->tdms is 0x3, but sometimes the
result is 0x2, or 0x1.

Fixes: be1df61cf06e ("ASoC: fsl: Add Audio Mixer CPU DAI driver")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Acked-by: Nicolin Chen <nicoleotsuka@gmail.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://lore.kernel.org/r/1e706afe53fdd1fbbbc79277c48a98f8416ba873.1573458378.git.shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/fsl/fsl_audmix.c |    6 ++++++
 sound/soc/fsl/fsl_audmix.h |    1 +
 2 files changed, 7 insertions(+)

--- a/sound/soc/fsl/fsl_audmix.c
+++ b/sound/soc/fsl/fsl_audmix.c
@@ -286,6 +286,7 @@ static int fsl_audmix_dai_trigger(struct
 				  struct snd_soc_dai *dai)
 {
 	struct fsl_audmix *priv = snd_soc_dai_get_drvdata(dai);
+	unsigned long lock_flags;
 
 	/* Capture stream shall not be handled */
 	if (substream->stream == SNDRV_PCM_STREAM_CAPTURE)
@@ -295,12 +296,16 @@ static int fsl_audmix_dai_trigger(struct
 	case SNDRV_PCM_TRIGGER_START:
 	case SNDRV_PCM_TRIGGER_RESUME:
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+		spin_lock_irqsave(&priv->lock, lock_flags);
 		priv->tdms |= BIT(dai->driver->id);
+		spin_unlock_irqrestore(&priv->lock, lock_flags);
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
+		spin_lock_irqsave(&priv->lock, lock_flags);
 		priv->tdms &= ~BIT(dai->driver->id);
+		spin_unlock_irqrestore(&priv->lock, lock_flags);
 		break;
 	default:
 		return -EINVAL;
@@ -493,6 +498,7 @@ static int fsl_audmix_probe(struct platf
 		return PTR_ERR(priv->ipg_clk);
 	}
 
+	spin_lock_init(&priv->lock);
 	platform_set_drvdata(pdev, priv);
 	pm_runtime_enable(dev);
 
--- a/sound/soc/fsl/fsl_audmix.h
+++ b/sound/soc/fsl/fsl_audmix.h
@@ -96,6 +96,7 @@ struct fsl_audmix {
 	struct platform_device *pdev;
 	struct regmap *regmap;
 	struct clk *ipg_clk;
+	spinlock_t lock; /* Protect tdms */
 	u8 tdms;
 };
 


