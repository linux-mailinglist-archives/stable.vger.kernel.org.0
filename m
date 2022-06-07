Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04C3C540B66
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351232AbiFGS2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352758AbiFGSVR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:21:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B04CDBCEBB;
        Tue,  7 Jun 2022 10:54:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08281B82370;
        Tue,  7 Jun 2022 17:53:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58670C36AFF;
        Tue,  7 Jun 2022 17:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624426;
        bh=bldrSuRs9w48d/Y14nMxTJiA4/cL+zY0VajW3jAz720=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MoC3/hlGXY1IoaSwY40TTD2EKpLV06qQ6RuWvcuMTeRulHeStKKnk45wG61hyPoge
         KuCtHBxQ182S6jFQXC4yUpgfc5MzaKT3YKrzdzck28l/BfGyi1lFC6u8+ihp06wOjo
         kVqSmUshk2hUxUJz7zF3nnDd4UlIwFGRZvY8qEEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 306/667] ASoC: fsl: Fix refcount leak in imx_sgtl5000_probe
Date:   Tue,  7 Jun 2022 18:59:31 +0200
Message-Id: <20220607164943.954438636@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 41cd312dfe980af869c3503b4d38e62ed20dd3b7 ]

of_find_i2c_device_by_node() takes a reference,
In error paths, we should call put_device() to drop
the reference to aviod refount leak.

Fixes: 81e8e4926167 ("ASoC: fsl: add sgtl5000 clock support for imx-sgtl5000")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/r/20220511065803.3957-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-sgtl5000.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/sound/soc/fsl/imx-sgtl5000.c b/sound/soc/fsl/imx-sgtl5000.c
index 52bb1844f548..c4e3699ad305 100644
--- a/sound/soc/fsl/imx-sgtl5000.c
+++ b/sound/soc/fsl/imx-sgtl5000.c
@@ -120,19 +120,19 @@ static int imx_sgtl5000_probe(struct platform_device *pdev)
 	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
 	if (!data) {
 		ret = -ENOMEM;
-		goto fail;
+		goto put_device;
 	}
 
 	comp = devm_kzalloc(&pdev->dev, 3 * sizeof(*comp), GFP_KERNEL);
 	if (!comp) {
 		ret = -ENOMEM;
-		goto fail;
+		goto put_device;
 	}
 
 	data->codec_clk = clk_get(&codec_dev->dev, NULL);
 	if (IS_ERR(data->codec_clk)) {
 		ret = PTR_ERR(data->codec_clk);
-		goto fail;
+		goto put_device;
 	}
 
 	data->clk_frequency = clk_get_rate(data->codec_clk);
@@ -158,10 +158,10 @@ static int imx_sgtl5000_probe(struct platform_device *pdev)
 	data->card.dev = &pdev->dev;
 	ret = snd_soc_of_parse_card_name(&data->card, "model");
 	if (ret)
-		goto fail;
+		goto put_device;
 	ret = snd_soc_of_parse_audio_routing(&data->card, "audio-routing");
 	if (ret)
-		goto fail;
+		goto put_device;
 	data->card.num_links = 1;
 	data->card.owner = THIS_MODULE;
 	data->card.dai_link = &data->dai;
@@ -174,7 +174,7 @@ static int imx_sgtl5000_probe(struct platform_device *pdev)
 	ret = devm_snd_soc_register_card(&pdev->dev, &data->card);
 	if (ret) {
 		dev_err_probe(&pdev->dev, ret, "snd_soc_register_card failed\n");
-		goto fail;
+		goto put_device;
 	}
 
 	of_node_put(ssi_np);
@@ -182,6 +182,8 @@ static int imx_sgtl5000_probe(struct platform_device *pdev)
 
 	return 0;
 
+put_device:
+	put_device(&codec_dev->dev);
 fail:
 	if (data && !IS_ERR(data->codec_clk))
 		clk_put(data->codec_clk);
-- 
2.35.1



