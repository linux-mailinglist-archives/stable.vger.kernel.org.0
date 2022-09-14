Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24DCE5B839B
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiINJBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbiINJBa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:01:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB94140C5;
        Wed, 14 Sep 2022 02:01:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 739EA61993;
        Wed, 14 Sep 2022 09:01:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE70C433C1;
        Wed, 14 Sep 2022 09:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146086;
        bh=y3lictP4Z1ea/tN0nU39rv17F8R5VC4Bbf21giCC80o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iqbXSlduODJ0Wluth+F1g0GZNhI5LNbSlB+IomSy1i0AUIqr6GEE3EbBjzqrwCfPx
         XMXNOvVIY4cd07q134ThxLug/VOEllW7BU9KtIQqn27MRiVBd+D6+hWM3pgd1xRFN6
         MTM6OttLn4N0p2jHxv8cQLwN8AV1EBboz42pXCfUiSxteZi9aE81fUBWGDEv26v4kW
         gjU1LBidt6a9PIxY0xSwsXr3OslPo6X5rZ3ypTVBUiWyiuEypaqa/mfjQIBZ9yqWBn
         YGf8mQzP1c7bw6SEBoZLNczMOOWUfyp0CjTlzojD7Bc7R2c4Y/B9QkvhFGXW7rX881
         LB6A1mh+3fr2Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, shengjiu.wang@gmail.com,
        Xiubo.Lee@gmail.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.19 06/22] ASoC: fsl_aud2htx: Add error handler for pm_runtime_enable
Date:   Wed, 14 Sep 2022 05:00:47 -0400
Message-Id: <20220914090103.470630-6-sashal@kernel.org>
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

[ Upstream commit b1cd3fd42db7593a2d24c06f1c53b8c886592080 ]

Call pm_runtime_disable() when error happens in probe()

Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1661430460-5234-2-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_aud2htx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/fsl/fsl_aud2htx.c b/sound/soc/fsl/fsl_aud2htx.c
index e09015e7e3c7c..38f3863739f4d 100644
--- a/sound/soc/fsl/fsl_aud2htx.c
+++ b/sound/soc/fsl/fsl_aud2htx.c
@@ -240,6 +240,7 @@ static int fsl_aud2htx_probe(struct platform_device *pdev)
 	ret = devm_snd_dmaengine_pcm_register(&pdev->dev, NULL, 0);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to pcm register\n");
+		pm_runtime_disable(&pdev->dev);
 		return ret;
 	}
 
@@ -248,6 +249,7 @@ static int fsl_aud2htx_probe(struct platform_device *pdev)
 					      &fsl_aud2htx_dai, 1);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register ASoC DAI\n");
+		pm_runtime_disable(&pdev->dev);
 		return ret;
 	}
 
-- 
2.35.1

