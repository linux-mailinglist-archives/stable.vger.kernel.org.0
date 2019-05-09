Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE181190F5
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbfEISvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:51:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727321AbfEISvN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:51:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9B9920578;
        Thu,  9 May 2019 18:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427872;
        bh=tn/Owjpp3Jru80bpgmicmEK6vh4fN5P+SJ+VHX4bfv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rJdltkQsTYTfk8XnQ2Vs7DMi2pYct6JE+lGfixv+CZirGk3A9zHh5yAki75x2de1h
         qlepIyLYZ6aUHFyPxX7AjvD4zc7uHRvL3b/q4FY4JRudNdJMc9+DskJlQ/8gx1V1RJ
         HM/ByzOjhhUjfSpcul/YBJFxP8NH6TEIgAUTh700=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Jyri Sarha <jsarha@ti.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 09/95] ASoC: hdmi-codec: fix S/PDIF DAI
Date:   Thu,  9 May 2019 20:41:26 +0200
Message-Id: <20190509181309.978659199@linuxfoundation.org>
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

[ Upstream commit 2e95f984aae4cf0608d0ba2189c756f2bd50b44a ]

When using the S/PDIF DAI, there is no requirement to call
snd_soc_dai_set_fmt() as there is no DAI format definition that defines
S/PDIF.  In any case, S/PDIF does not have separate clocks, this is
embedded into the data stream.

Consequently, when attempting to use TDA998x in S/PDIF mode, the attempt
to configure TDA998x via the hw_params callback fails as the
hdmi_codec_daifmt is left initialised to zero.

Since the S/PDIF DAI will only be used by S/PDIF, prepare the
hdmi_codec_daifmt structure for this format.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Jyri Sarha <jsarha@ti.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdmi-codec.c | 118 +++++++++++++++++-----------------
 1 file changed, 59 insertions(+), 59 deletions(-)

diff --git a/sound/soc/codecs/hdmi-codec.c b/sound/soc/codecs/hdmi-codec.c
index e5b6769b97977..d5f73c8372817 100644
--- a/sound/soc/codecs/hdmi-codec.c
+++ b/sound/soc/codecs/hdmi-codec.c
@@ -529,73 +529,71 @@ static int hdmi_codec_set_fmt(struct snd_soc_dai *dai,
 {
 	struct hdmi_codec_priv *hcp = snd_soc_dai_get_drvdata(dai);
 	struct hdmi_codec_daifmt cf = { 0 };
-	int ret = 0;
 
 	dev_dbg(dai->dev, "%s()\n", __func__);
 
-	if (dai->id == DAI_ID_SPDIF) {
-		cf.fmt = HDMI_SPDIF;
-	} else {
-		switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
-		case SND_SOC_DAIFMT_CBM_CFM:
-			cf.bit_clk_master = 1;
-			cf.frame_clk_master = 1;
-			break;
-		case SND_SOC_DAIFMT_CBS_CFM:
-			cf.frame_clk_master = 1;
-			break;
-		case SND_SOC_DAIFMT_CBM_CFS:
-			cf.bit_clk_master = 1;
-			break;
-		case SND_SOC_DAIFMT_CBS_CFS:
-			break;
-		default:
-			return -EINVAL;
-		}
+	if (dai->id == DAI_ID_SPDIF)
+		return 0;
+
+	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
+	case SND_SOC_DAIFMT_CBM_CFM:
+		cf.bit_clk_master = 1;
+		cf.frame_clk_master = 1;
+		break;
+	case SND_SOC_DAIFMT_CBS_CFM:
+		cf.frame_clk_master = 1;
+		break;
+	case SND_SOC_DAIFMT_CBM_CFS:
+		cf.bit_clk_master = 1;
+		break;
+	case SND_SOC_DAIFMT_CBS_CFS:
+		break;
+	default:
+		return -EINVAL;
+	}
 
-		switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
-		case SND_SOC_DAIFMT_NB_NF:
-			break;
-		case SND_SOC_DAIFMT_NB_IF:
-			cf.frame_clk_inv = 1;
-			break;
-		case SND_SOC_DAIFMT_IB_NF:
-			cf.bit_clk_inv = 1;
-			break;
-		case SND_SOC_DAIFMT_IB_IF:
-			cf.frame_clk_inv = 1;
-			cf.bit_clk_inv = 1;
-			break;
-		}
+	switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
+	case SND_SOC_DAIFMT_NB_NF:
+		break;
+	case SND_SOC_DAIFMT_NB_IF:
+		cf.frame_clk_inv = 1;
+		break;
+	case SND_SOC_DAIFMT_IB_NF:
+		cf.bit_clk_inv = 1;
+		break;
+	case SND_SOC_DAIFMT_IB_IF:
+		cf.frame_clk_inv = 1;
+		cf.bit_clk_inv = 1;
+		break;
+	}
 
-		switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
-		case SND_SOC_DAIFMT_I2S:
-			cf.fmt = HDMI_I2S;
-			break;
-		case SND_SOC_DAIFMT_DSP_A:
-			cf.fmt = HDMI_DSP_A;
-			break;
-		case SND_SOC_DAIFMT_DSP_B:
-			cf.fmt = HDMI_DSP_B;
-			break;
-		case SND_SOC_DAIFMT_RIGHT_J:
-			cf.fmt = HDMI_RIGHT_J;
-			break;
-		case SND_SOC_DAIFMT_LEFT_J:
-			cf.fmt = HDMI_LEFT_J;
-			break;
-		case SND_SOC_DAIFMT_AC97:
-			cf.fmt = HDMI_AC97;
-			break;
-		default:
-			dev_err(dai->dev, "Invalid DAI interface format\n");
-			return -EINVAL;
-		}
+	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
+	case SND_SOC_DAIFMT_I2S:
+		cf.fmt = HDMI_I2S;
+		break;
+	case SND_SOC_DAIFMT_DSP_A:
+		cf.fmt = HDMI_DSP_A;
+		break;
+	case SND_SOC_DAIFMT_DSP_B:
+		cf.fmt = HDMI_DSP_B;
+		break;
+	case SND_SOC_DAIFMT_RIGHT_J:
+		cf.fmt = HDMI_RIGHT_J;
+		break;
+	case SND_SOC_DAIFMT_LEFT_J:
+		cf.fmt = HDMI_LEFT_J;
+		break;
+	case SND_SOC_DAIFMT_AC97:
+		cf.fmt = HDMI_AC97;
+		break;
+	default:
+		dev_err(dai->dev, "Invalid DAI interface format\n");
+		return -EINVAL;
 	}
 
 	hcp->daifmt[dai->id] = cf;
 
-	return ret;
+	return 0;
 }
 
 static int hdmi_codec_digital_mute(struct snd_soc_dai *dai, int mute)
@@ -792,8 +790,10 @@ static int hdmi_codec_probe(struct platform_device *pdev)
 		i++;
 	}
 
-	if (hcd->spdif)
+	if (hcd->spdif) {
 		hcp->daidrv[i] = hdmi_spdif_dai;
+		hcp->daifmt[DAI_ID_SPDIF].fmt = HDMI_SPDIF;
+	}
 
 	dev_set_drvdata(dev, hcp);
 
-- 
2.20.1



