Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82AB13D7692
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 15:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236939AbhG0NaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 09:30:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236759AbhG0NTw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 09:19:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7047961A8F;
        Tue, 27 Jul 2021 13:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627391967;
        bh=9Ekw3+9sj0iwmU+tEstdxAwWf8wSv4kj+Ikag/p3grk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tswn5y/LoxdKAl8jUC9VvP3ryxW460G2u8qp1yBie8HVo2tDdqn9X74pVfEbbp7Co
         UW9dydCCooxhzNJE8Gt8a/StUJR/KBrWZVcPSqBu9wkq+6v5vYXatMekzUkxE/Wnwg
         JLNzbAs99jt35Um5uFo2a2sbz4ZE0OWUHEs6hEa75nlZQiF2NQ3w1J2tjNcd5/8SiD
         9eOGiPZxYgDk1bmIYfpTC00ntqNoJmNVCsL0cKTiwAD9UKiFsh7mjuNDnrp1n7Rsyt
         svT9UTl56LznkO/IQT86nwcuoVhlTlits2YR3+RNCm6O2DlRAUyjBxNaE+np+oqHhu
         xqmNi+128wwYw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.13 13/21] ASoC: ti: j721e-evm: Fix unbalanced domain activity tracking during startup
Date:   Tue, 27 Jul 2021 09:19:00 -0400
Message-Id: <20210727131908.834086-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727131908.834086-1-sashal@kernel.org>
References: <20210727131908.834086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

