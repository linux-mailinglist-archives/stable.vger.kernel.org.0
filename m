Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E80E4F333F
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245177AbiDEJQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244979AbiDEIwx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCED4DFF6;
        Tue,  5 Apr 2022 01:48:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86AA8B81B18;
        Tue,  5 Apr 2022 08:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B79C385A0;
        Tue,  5 Apr 2022 08:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148507;
        bh=2lWJmGuyQdN4VsEYsnTq8dNPqie4I+PcjZElguCw8KU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=szdP6nugmG0TOY3iQBU5B0aMhnhs/2qxNwzc+CvGqesTIZlEGJeUH9mXnc9FClQZn
         CnzDErxo/d9TYREiRmKSl7Uu/gW0cEfH1vJPeRCB8lnny2J77M6mQjaKEfQ91vrCuR
         uga07EDW0X4aHey9vgat+eqCBBpRyPN7YLq9iXqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0379/1017] ASoC: rockchip: i2s: Fix missing clk_disable_unprepare() in rockchip_i2s_probe
Date:   Tue,  5 Apr 2022 09:21:32 +0200
Message-Id: <20220405070405.536537656@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit f725d20579807a68afbe5dba69e78b8fa05f5ef0 ]

Fix the missing clk_disable_unprepare() before return
from rockchip_i2s_probe() in the error handling case.

Fixes: 01605ad12875 ("ASoC: rockchip-i2s: enable "hclk" for rockchip I2S controller")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220307083553.26009-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_i2s.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
index a6d7656c206e..4ce5d2579387 100644
--- a/sound/soc/rockchip/rockchip_i2s.c
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -716,19 +716,23 @@ static int rockchip_i2s_probe(struct platform_device *pdev)
 	i2s->mclk = devm_clk_get(&pdev->dev, "i2s_clk");
 	if (IS_ERR(i2s->mclk)) {
 		dev_err(&pdev->dev, "Can't retrieve i2s master clock\n");
-		return PTR_ERR(i2s->mclk);
+		ret = PTR_ERR(i2s->mclk);
+		goto err_clk;
 	}
 
 	regs = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
-	if (IS_ERR(regs))
-		return PTR_ERR(regs);
+	if (IS_ERR(regs)) {
+		ret = PTR_ERR(regs);
+		goto err_clk;
+	}
 
 	i2s->regmap = devm_regmap_init_mmio(&pdev->dev, regs,
 					    &rockchip_i2s_regmap_config);
 	if (IS_ERR(i2s->regmap)) {
 		dev_err(&pdev->dev,
 			"Failed to initialise managed register map\n");
-		return PTR_ERR(i2s->regmap);
+		ret = PTR_ERR(i2s->regmap);
+		goto err_clk;
 	}
 
 	i2s->bclk_ratio = 64;
@@ -768,7 +772,8 @@ static int rockchip_i2s_probe(struct platform_device *pdev)
 		i2s_runtime_suspend(&pdev->dev);
 err_pm_disable:
 	pm_runtime_disable(&pdev->dev);
-
+err_clk:
+	clk_disable_unprepare(i2s->hclk);
 	return ret;
 }
 
-- 
2.34.1



