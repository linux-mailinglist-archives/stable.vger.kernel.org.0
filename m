Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1679B5B8399
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiINJBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiINJB0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:01:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD829FFE;
        Wed, 14 Sep 2022 02:01:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54E646199A;
        Wed, 14 Sep 2022 09:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4E2C433B5;
        Wed, 14 Sep 2022 09:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146083;
        bh=SZXFFr6fQE4QYpoEaaMaZI/GyemsfR2Ojv/xm40sKWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBeoQ0352di0SC94Yge257rfx+gw9hYXb9XSgAdJkagbrVq9iC98hX26J7x9PdPNn
         6MhCoMrICFvWBaG92Ul53ie1+rK5RC8JC4hEfN9CPFo4kiDPPg8UW9qg1+VEEWAPBo
         K4MhRod+xfO5SYjeH6qsXkypLp9RhZpPWlvO0uUuKmdbjLDmqi0BvvOt2Ct/fnNzPP
         SxXvxvRxM1HPP8AERqRrFzXgPefW0bj2NoifP51A2FktKNdzXEQMifMhMnJifIYhAf
         19y2p6jMUxPrElIeKnkCJ0mt1pOOa6qnRb9iz2B+t29AG/SuvVQAfMzkwESKdxosoj
         YqAMIyg/2OF5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, shengjiu.wang@gmail.com,
        Xiubo.Lee@gmail.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.19 05/22] ASoC: fsl_aud2htx: register platform component before registering cpu dai
Date:   Wed, 14 Sep 2022 05:00:46 -0400
Message-Id: <20220914090103.470630-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090103.470630-1-sashal@kernel.org>
References: <20220914090103.470630-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit ea532c29972df96fda20393d9bf057e898f5e965 ]

There is no defer probe when adding platform component to
snd_soc_pcm_runtime(rtd), the code is in snd_soc_add_pcm_runtime()

snd_soc_register_card()
  -> snd_soc_bind_card()
    -> snd_soc_add_pcm_runtime()
      -> adding cpu dai
      -> adding codec dai
      -> adding platform component.

So if the platform component is not ready at that time, then the
sound card still registered successfully, but platform component
is empty, the sound card can't be used.

As there is defer probe checking for cpu dai component, then register
platform component before cpu dai to avoid such issue.

And the behavior of imx_pcm_dma_init() is same as common
devm_snd_dmaengine_pcm_register(), so use
devm_snd_dmaengine_pcm_register() instead

Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1661430460-5234-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_aud2htx.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/sound/soc/fsl/fsl_aud2htx.c b/sound/soc/fsl/fsl_aud2htx.c
index 422922146f2a5..e09015e7e3c7c 100644
--- a/sound/soc/fsl/fsl_aud2htx.c
+++ b/sound/soc/fsl/fsl_aud2htx.c
@@ -233,6 +233,16 @@ static int fsl_aud2htx_probe(struct platform_device *pdev)
 
 	regcache_cache_only(aud2htx->regmap, true);
 
+	/*
+	 * Register platform component before registering cpu dai for there
+	 * is not defer probe for platform component in snd_soc_add_pcm_runtime().
+	 */
+	ret = devm_snd_dmaengine_pcm_register(&pdev->dev, NULL, 0);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to pcm register\n");
+		return ret;
+	}
+
 	ret = devm_snd_soc_register_component(&pdev->dev,
 					      &fsl_aud2htx_component,
 					      &fsl_aud2htx_dai, 1);
@@ -241,10 +251,6 @@ static int fsl_aud2htx_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	ret = imx_pcm_dma_init(pdev);
-	if (ret)
-		dev_err(&pdev->dev, "failed to init imx pcm dma: %d\n", ret);
-
 	return ret;
 }
 
-- 
2.35.1

