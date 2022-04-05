Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616874F36CE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352333AbiDELH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348749AbiDEJsa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C614614A;
        Tue,  5 Apr 2022 02:34:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92AC8B81B93;
        Tue,  5 Apr 2022 09:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0272FC385A0;
        Tue,  5 Apr 2022 09:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151282;
        bh=yAda317M2Z65PuEC2lAT8iX47juOXHrIBRet/BLsE54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UAor8SvOQ/x9GCn3MFM4qHqmVAsZwbHWioDM5AJ4evceAuWNn9gH7JRq8p2Zy0hBb
         ol2oNWXy8uQl779B+cl/uSZTMaBRAm1FKjkuVEODTOk72wy3a0LEQdSa2IL7mc+xP5
         vSYc9GpUdRLJ+ZU2+RjIknOAGlobDHTAW4zRN3EA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tzung-Bi Shih <tzungbi@google.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 358/913] ASoC: mediatek: use of_device_get_match_data()
Date:   Tue,  5 Apr 2022 09:23:40 +0200
Message-Id: <20220405070350.576536265@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Tzung-Bi Shih <tzungbi@google.com>

[ Upstream commit 3667a037e50a31555276a7989435126e501f0f15 ]

Uses of_device_get_match_data() helper to clean some boilerplate code.

Signed-off-by: Tzung-Bi Shih <tzungbi@google.com>
Link: https://lore.kernel.org/r/20211227062153.3887447-1-tzungbi@google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c         | 7 ++-----
 sound/soc/mediatek/mt8183/mt8183-mt6358-ts3a227-max98357.c | 7 ++-----
 sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c    | 7 ++-----
 3 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c b/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c
index bda103211e0b..0ab8b050b305 100644
--- a/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c
+++ b/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c
@@ -685,7 +685,6 @@ static int mt8183_da7219_max98357_dev_probe(struct platform_device *pdev)
 	struct snd_soc_dai_link *dai_link;
 	struct mt8183_da7219_max98357_priv *priv;
 	struct pinctrl *pinctrl;
-	const struct of_device_id *match;
 	int ret, i;
 
 	platform_node = of_parse_phandle(pdev->dev.of_node,
@@ -695,11 +694,9 @@ static int mt8183_da7219_max98357_dev_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	match = of_match_device(pdev->dev.driver->of_match_table, &pdev->dev);
-	if (!match || !match->data)
+	card = (struct snd_soc_card *)of_device_get_match_data(&pdev->dev);
+	if (!card)
 		return -EINVAL;
-
-	card = (struct snd_soc_card *)match->data;
 	card->dev = &pdev->dev;
 
 	hdmi_codec = of_parse_phandle(pdev->dev.of_node,
diff --git a/sound/soc/mediatek/mt8183/mt8183-mt6358-ts3a227-max98357.c b/sound/soc/mediatek/mt8183/mt8183-mt6358-ts3a227-max98357.c
index c7b10c48c6c2..a56c1e87d564 100644
--- a/sound/soc/mediatek/mt8183/mt8183-mt6358-ts3a227-max98357.c
+++ b/sound/soc/mediatek/mt8183/mt8183-mt6358-ts3a227-max98357.c
@@ -637,7 +637,6 @@ mt8183_mt6358_ts3a227_max98357_dev_probe(struct platform_device *pdev)
 	struct device_node *platform_node, *ec_codec, *hdmi_codec;
 	struct snd_soc_dai_link *dai_link;
 	struct mt8183_mt6358_ts3a227_max98357_priv *priv;
-	const struct of_device_id *match;
 	int ret, i;
 
 	platform_node = of_parse_phandle(pdev->dev.of_node,
@@ -647,11 +646,9 @@ mt8183_mt6358_ts3a227_max98357_dev_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	match = of_match_device(pdev->dev.driver->of_match_table, &pdev->dev);
-	if (!match || !match->data)
+	card = (struct snd_soc_card *)of_device_get_match_data(&pdev->dev);
+	if (!card)
 		return -EINVAL;
-
-	card = (struct snd_soc_card *)match->data;
 	card->dev = &pdev->dev;
 
 	ec_codec = of_parse_phandle(pdev->dev.of_node, "mediatek,ec-codec", 0);
diff --git a/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c b/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c
index 24a5d0adec1b..ab449d0e4e9b 100644
--- a/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c
+++ b/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c
@@ -1106,7 +1106,6 @@ static int mt8192_mt6359_dev_probe(struct platform_device *pdev)
 	struct device_node *platform_node, *hdmi_codec;
 	int ret, i;
 	struct snd_soc_dai_link *dai_link;
-	const struct of_device_id *match;
 	struct mt8192_mt6359_priv *priv;
 
 	platform_node = of_parse_phandle(pdev->dev.of_node,
@@ -1116,11 +1115,9 @@ static int mt8192_mt6359_dev_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	match = of_match_device(pdev->dev.driver->of_match_table, &pdev->dev);
-	if (!match || !match->data)
+	card = (struct snd_soc_card *)of_device_get_match_data(&pdev->dev);
+	if (!card)
 		return -EINVAL;
-
-	card = (struct snd_soc_card *)match->data;
 	card->dev = &pdev->dev;
 
 	hdmi_codec = of_parse_phandle(pdev->dev.of_node,
-- 
2.34.1



