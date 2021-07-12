Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB973C46FC
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234795AbhGLGaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:30:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235646AbhGLG31 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:29:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9426D610FB;
        Mon, 12 Jul 2021 06:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071119;
        bh=U4zSdmJ99GzKDrZ0BLge98AWioq+uoZOKAU3R5rgYQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UM+JxYLmV5qKdWQ5D4pX7XnmdajjnuE9Exmn7V+KFx89HA6AUC+ZFwBIuW+TpXl5I
         VX/A8hMAGxRJCTEA5qFFd0pYKiT3ndYN5MkcHGsoy8qGQzzm5lsW4OzI/Go4PVUYcV
         BE0V2muIlmeAIYzsXSTiZHga0VjmXYgaCTYlfxBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 282/348] ASoC: rk3328: fix missing clk_disable_unprepare() on error in rk3328_platform_probe()
Date:   Mon, 12 Jul 2021 08:11:06 +0200
Message-Id: <20210712060741.071006503@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit d14eece945a8068a017995f7512ea2beac21e34b ]

Fix the missing clk_disable_unprepare() before return
from rk3328_platform_probe() in the error handling case.

Fixes: c32759035ad2 ("ASoC: rockchip: support ACODEC for rk3328")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20210518075847.1116983-1-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rk3328_codec.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/rk3328_codec.c b/sound/soc/codecs/rk3328_codec.c
index 287c962ba00d..514ebe16bbfa 100644
--- a/sound/soc/codecs/rk3328_codec.c
+++ b/sound/soc/codecs/rk3328_codec.c
@@ -472,7 +472,8 @@ static int rk3328_platform_probe(struct platform_device *pdev)
 	rk3328->pclk = devm_clk_get(&pdev->dev, "pclk");
 	if (IS_ERR(rk3328->pclk)) {
 		dev_err(&pdev->dev, "can't get acodec pclk\n");
-		return PTR_ERR(rk3328->pclk);
+		ret = PTR_ERR(rk3328->pclk);
+		goto err_unprepare_mclk;
 	}
 
 	ret = clk_prepare_enable(rk3328->pclk);
@@ -482,19 +483,34 @@ static int rk3328_platform_probe(struct platform_device *pdev)
 	}
 
 	base = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(base))
-		return PTR_ERR(base);
+	if (IS_ERR(base)) {
+		ret = PTR_ERR(base);
+		goto err_unprepare_pclk;
+	}
 
 	rk3328->regmap = devm_regmap_init_mmio(&pdev->dev, base,
 					       &rk3328_codec_regmap_config);
-	if (IS_ERR(rk3328->regmap))
-		return PTR_ERR(rk3328->regmap);
+	if (IS_ERR(rk3328->regmap)) {
+		ret = PTR_ERR(rk3328->regmap);
+		goto err_unprepare_pclk;
+	}
 
 	platform_set_drvdata(pdev, rk3328);
 
-	return devm_snd_soc_register_component(&pdev->dev, &soc_codec_rk3328,
+	ret = devm_snd_soc_register_component(&pdev->dev, &soc_codec_rk3328,
 					       rk3328_dai,
 					       ARRAY_SIZE(rk3328_dai));
+	if (ret)
+		goto err_unprepare_pclk;
+
+	return 0;
+
+err_unprepare_pclk:
+	clk_disable_unprepare(rk3328->pclk);
+
+err_unprepare_mclk:
+	clk_disable_unprepare(rk3328->mclk);
+	return ret;
 }
 
 static const struct of_device_id rk3328_codec_of_match[] = {
-- 
2.30.2



