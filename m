Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700193E2564
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237310AbhHFITu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:19:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243819AbhHFITD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:19:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 960AF61131;
        Fri,  6 Aug 2021 08:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237922;
        bh=9Ekw3+9sj0iwmU+tEstdxAwWf8wSv4kj+Ikag/p3grk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cfq3rmL2BAe95FC1OVUGBFmoyS1ReVQ3uSWEoF8796NSBUGCmR/UZJeBRLAP4tESF
         r3lR/Di5RjP61X6u+noUK/CFVdWvW2vduLkSa13rE4QMUYQrL5MUpyTNciSPIxa5Dy
         QXqW8iJA7n+2Uxv9D9vOTmELeG47J3JIXiR83HfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/30] ASoC: ti: j721e-evm: Fix unbalanced domain activity tracking during startup
Date:   Fri,  6 Aug 2021 10:16:51 +0200
Message-Id: <20210806081113.583966316@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.126861800@linuxfoundation.org>
References: <20210806081113.126861800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@gmail.com>

[ Upstream commit 78d2a05ef22e7b5863b01e073dd6a06b3979bb00 ]

In case of an error within j721e_audio_startup() the domain->active must
be decremented to avoid unbalanced counter.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Link: https://lore.kernel.org/r/20210717122820.1467-2-peter.ujfalusi@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ti/j721e-evm.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/sound/soc/ti/j721e-evm.c b/sound/soc/ti/j721e-evm.c
index a7c0484d44ec..017c4ad11ca6 100644
--- a/sound/soc/ti/j721e-evm.c
+++ b/sound/soc/ti/j721e-evm.c
@@ -278,23 +278,29 @@ static int j721e_audio_startup(struct snd_pcm_substream *substream)
 					  j721e_rule_rate, &priv->rate_range,
 					  SNDRV_PCM_HW_PARAM_RATE, -1);
 
-	mutex_unlock(&priv->mutex);
 
 	if (ret)
-		return ret;
+		goto out;
 
 	/* Reset TDM slots to 32 */
 	ret = snd_soc_dai_set_tdm_slot(cpu_dai, 0x3, 0x3, 2, 32);
 	if (ret && ret != -ENOTSUPP)
-		return ret;
+		goto out;
 
 	for_each_rtd_codec_dais(rtd, i, codec_dai) {
 		ret = snd_soc_dai_set_tdm_slot(codec_dai, 0x3, 0x3, 2, 32);
 		if (ret && ret != -ENOTSUPP)
-			return ret;
+			goto out;
 	}
 
-	return 0;
+	if (ret == -ENOTSUPP)
+		ret = 0;
+out:
+	if (ret)
+		domain->active--;
+	mutex_unlock(&priv->mutex);
+
+	return ret;
 }
 
 static int j721e_audio_hw_params(struct snd_pcm_substream *substream,
-- 
2.30.2



