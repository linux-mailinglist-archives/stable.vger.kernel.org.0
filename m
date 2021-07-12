Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E107C3C5523
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353517AbhGLIJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:09:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352875AbhGLIAZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:00:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC22C6145F;
        Mon, 12 Jul 2021 07:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076426;
        bh=17ndaT0awGPfG3rICprw+qKb6vXqEx7aDN+fYNLbgec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z9eY/TSgUdG04e5tE+F8lUiQPL+PJJs2bYHYd0Vuqh6y2A8qNDGveBf1y7hj7Qd/1
         xvW8szfeSeoE1WN/PbYjIv6EhndY4RmUk24pnYczulzcMw7ALDyj5Job1DYEg7d2uC
         +Ttm1U//xcoLTddPK90ExhGD6BIHW31hkD2GK9qA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 638/800] ASoC: rk3328: fix missing clk_disable_unprepare() on error in rk3328_platform_probe()
Date:   Mon, 12 Jul 2021 08:11:01 +0200
Message-Id: <20210712061034.980918331@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index bfefefcc76d8..758d439e8c7a 100644
--- a/sound/soc/codecs/rk3328_codec.c
+++ b/sound/soc/codecs/rk3328_codec.c
@@ -474,7 +474,8 @@ static int rk3328_platform_probe(struct platform_device *pdev)
 	rk3328->pclk = devm_clk_get(&pdev->dev, "pclk");
 	if (IS_ERR(rk3328->pclk)) {
 		dev_err(&pdev->dev, "can't get acodec pclk\n");
-		return PTR_ERR(rk3328->pclk);
+		ret = PTR_ERR(rk3328->pclk);
+		goto err_unprepare_mclk;
 	}
 
 	ret = clk_prepare_enable(rk3328->pclk);
@@ -484,19 +485,34 @@ static int rk3328_platform_probe(struct platform_device *pdev)
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
 
 static const struct of_device_id rk3328_codec_of_match[] __maybe_unused = {
-- 
2.30.2



