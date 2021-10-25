Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E35B43A232
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235285AbhJYTqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:46:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237525AbhJYTnw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:43:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50ED4611AF;
        Mon, 25 Oct 2021 19:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190687;
        bh=qYsNP/l+MZRZIRFNJdlObLPFTqVPQVpYD6kvhsBtoNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xsVIKCHxvOoPMEf5QziyoFcz5Ua6gD5FSERroYGeFMTaYjy1b0tQK/4M7orQk3ghf
         T/OEHwpczaJnv24auafAxi7qNXhntc4Hlr37Q63qTNhX6XSuq5JQexllnMoDLA8FXm
         G98X8lwYjpLH2w1p1gkY4ZmgRo8RYs/OHGxnPs8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 019/169] ASoC: fsl_xcvr: Fix channel swap issue with ARC
Date:   Mon, 25 Oct 2021 21:13:20 +0200
Message-Id: <20211025191020.107936717@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 74b7ee0e7b61838a0a161a84d105aeff0d042646 ]

With pause and resume test for ARC, there is occasionally
channel swap issue. The reason is that currently driver set
the DPATH out of reset first, then start the DMA, the first
data got from FIFO may not be the Left channel.

Moving DPATH out of reset operation after the dma enablement
to fix this issue.

Fixes: 28564486866f ("ASoC: fsl_xcvr: Add XCVR ASoC CPU DAI driver")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1631265510-27384-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_xcvr.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/sound/soc/fsl/fsl_xcvr.c b/sound/soc/fsl/fsl_xcvr.c
index 477d16713e72..a9b6c2b0c871 100644
--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -487,8 +487,9 @@ static int fsl_xcvr_prepare(struct snd_pcm_substream *substream,
 		return ret;
 	}
 
-	/* clear DPATH RESET */
+	/* set DPATH RESET */
 	m_ctl |= FSL_XCVR_EXT_CTRL_DPTH_RESET(tx);
+	v_ctl |= FSL_XCVR_EXT_CTRL_DPTH_RESET(tx);
 	ret = regmap_update_bits(xcvr->regmap, FSL_XCVR_EXT_CTRL, m_ctl, v_ctl);
 	if (ret < 0) {
 		dev_err(dai->dev, "Error while setting EXT_CTRL: %d\n", ret);
@@ -590,10 +591,6 @@ static void fsl_xcvr_shutdown(struct snd_pcm_substream *substream,
 		val  |= FSL_XCVR_EXT_CTRL_CMDC_RESET(tx);
 	}
 
-	/* set DPATH RESET */
-	mask |= FSL_XCVR_EXT_CTRL_DPTH_RESET(tx);
-	val  |= FSL_XCVR_EXT_CTRL_DPTH_RESET(tx);
-
 	ret = regmap_update_bits(xcvr->regmap, FSL_XCVR_EXT_CTRL, mask, val);
 	if (ret < 0) {
 		dev_err(dai->dev, "Err setting DPATH RESET: %d\n", ret);
@@ -643,6 +640,16 @@ static int fsl_xcvr_trigger(struct snd_pcm_substream *substream, int cmd,
 			dev_err(dai->dev, "Failed to enable DMA: %d\n", ret);
 			return ret;
 		}
+
+		/* clear DPATH RESET */
+		ret = regmap_update_bits(xcvr->regmap, FSL_XCVR_EXT_CTRL,
+					 FSL_XCVR_EXT_CTRL_DPTH_RESET(tx),
+					 0);
+		if (ret < 0) {
+			dev_err(dai->dev, "Failed to clear DPATH RESET: %d\n", ret);
+			return ret;
+		}
+
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
-- 
2.33.0



