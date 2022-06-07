Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3728A540A79
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352939AbiFGSWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348997AbiFGSSY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:18:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62EFDE732F;
        Tue,  7 Jun 2022 10:53:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8897B8234A;
        Tue,  7 Jun 2022 17:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BA1C341C0;
        Tue,  7 Jun 2022 17:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624396;
        bh=iNab9yIrCCieKssBqHt39K2CfW9y3HdUyNf5D2URuPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X80D5YbNMvu1KH4pFAECmBH/PMaFYWkMkeMSnzrFYWBOPmf54jZELxNLkhFOZSydC
         +8oERdDcsaJeDtyjRvahvFfm5hG4TZXO0+YEVwWNsKOuIB6Do87Q6K4ohL5HHI6q4I
         3Dnsgrj7XCmOdlbJukQd+g1xqqMsPSJkFV1LqyrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 305/667] ASoC: fsl: Use dev_err_probe() helper
Date:   Tue,  7 Jun 2022 18:59:30 +0200
Message-Id: <20220607164943.924793050@linuxfoundation.org>
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

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 2e6f557ca35aa330dbf31c5e1cc8119eff1526fa ]

Use the dev_err_probe() helper, instead of open-coding the same
operation.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/20211214020843.2225831-14-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl-asoc-card.c |  3 +--
 sound/soc/fsl/imx-card.c      | 17 ++++++-----------
 sound/soc/fsl/imx-sgtl5000.c  |  4 +---
 sound/soc/fsl/imx-spdif.c     |  4 ++--
 4 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/sound/soc/fsl/fsl-asoc-card.c b/sound/soc/fsl/fsl-asoc-card.c
index 06107ae46e20..95286c839b57 100644
--- a/sound/soc/fsl/fsl-asoc-card.c
+++ b/sound/soc/fsl/fsl-asoc-card.c
@@ -842,8 +842,7 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 
 	ret = devm_snd_soc_register_card(&pdev->dev, &priv->card);
 	if (ret) {
-		if (ret != -EPROBE_DEFER)
-			dev_err(&pdev->dev, "snd_soc_register_card failed (%d)\n", ret);
+		dev_err_probe(&pdev->dev, ret, "snd_soc_register_card failed\n");
 		goto asrc_fail;
 	}
 
diff --git a/sound/soc/fsl/imx-card.c b/sound/soc/fsl/imx-card.c
index db947180617a..55bc1bb0dbbd 100644
--- a/sound/soc/fsl/imx-card.c
+++ b/sound/soc/fsl/imx-card.c
@@ -579,9 +579,8 @@ static int imx_card_parse_of(struct imx_card_data *data)
 
 		ret = snd_soc_of_get_dai_name(cpu, &link->cpus->dai_name);
 		if (ret) {
-			if (ret != -EPROBE_DEFER)
-				dev_err(card->dev, "%s: error getting cpu dai name: %d\n",
-					link->name, ret);
+			dev_err_probe(card->dev, ret,
+				      "%s: error getting cpu dai name\n", link->name);
 			goto err;
 		}
 
@@ -589,9 +588,8 @@ static int imx_card_parse_of(struct imx_card_data *data)
 		if (codec) {
 			ret = snd_soc_of_get_dai_link_codecs(dev, codec, link);
 			if (ret < 0) {
-				if (ret != -EPROBE_DEFER)
-					dev_err(dev, "%s: codec dai not found: %d\n",
-						link->name, ret);
+				dev_err_probe(dev, ret, "%s: codec dai not found\n",
+						link->name);
 				goto err;
 			}
 
@@ -830,11 +828,8 @@ static int imx_card_probe(struct platform_device *pdev)
 	}
 
 	ret = devm_snd_soc_register_card(&pdev->dev, &data->card);
-	if (ret) {
-		if (ret != -EPROBE_DEFER)
-			dev_err(&pdev->dev, "snd_soc_register_card failed (%d)\n", ret);
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(&pdev->dev, ret, "snd_soc_register_card failed\n");
 
 	return 0;
 }
diff --git a/sound/soc/fsl/imx-sgtl5000.c b/sound/soc/fsl/imx-sgtl5000.c
index f45cb4bbb6c4..52bb1844f548 100644
--- a/sound/soc/fsl/imx-sgtl5000.c
+++ b/sound/soc/fsl/imx-sgtl5000.c
@@ -173,9 +173,7 @@ static int imx_sgtl5000_probe(struct platform_device *pdev)
 
 	ret = devm_snd_soc_register_card(&pdev->dev, &data->card);
 	if (ret) {
-		if (ret != -EPROBE_DEFER)
-			dev_err(&pdev->dev, "snd_soc_register_card failed (%d)\n",
-				ret);
+		dev_err_probe(&pdev->dev, ret, "snd_soc_register_card failed\n");
 		goto fail;
 	}
 
diff --git a/sound/soc/fsl/imx-spdif.c b/sound/soc/fsl/imx-spdif.c
index 6c4dadf60355..4446fba755b9 100644
--- a/sound/soc/fsl/imx-spdif.c
+++ b/sound/soc/fsl/imx-spdif.c
@@ -70,8 +70,8 @@ static int imx_spdif_audio_probe(struct platform_device *pdev)
 		goto end;
 
 	ret = devm_snd_soc_register_card(&pdev->dev, &data->card);
-	if (ret && ret != -EPROBE_DEFER)
-		dev_err(&pdev->dev, "snd_soc_register_card failed: %d\n", ret);
+	if (ret)
+		dev_err_probe(&pdev->dev, ret, "snd_soc_register_card failed\n");
 
 end:
 	of_node_put(spdif_np);
-- 
2.35.1



