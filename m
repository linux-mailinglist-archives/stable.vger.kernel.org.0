Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279644F3158
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235842AbiDEJCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238607AbiDEIao (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:30:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70422AC73;
        Tue,  5 Apr 2022 01:22:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 232BD6144D;
        Tue,  5 Apr 2022 08:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDB2C385A5;
        Tue,  5 Apr 2022 08:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146949;
        bh=CdMizYcg0vqRMBZy3nZIQsY6pEwDwVuUydNu+uhIk38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SzHksLl+OVhgh24cIoUm6ikRxy8HAZq4e4CUTI3mhvOPyt+oLMWIG6KBBdybPVoEm
         1B9hZgMm+OZ88UintzNYodF3UMvrb9t5p4P6kF+c/+92uB49L4epWPCuGeeH7c6UHH
         T4goHWGu4K+QiZRbHScR/vgcc+d8gvu28nuBtZsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Tzung-Bi Shih <tzungbi@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0947/1126] ASoC: mediatek: Fix error handling in mt8183_da7219_max98357_dev_probe
Date:   Tue,  5 Apr 2022 09:28:14 +0200
Message-Id: <20220405070435.303337904@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

[ Upstream commit 28a265a1ee11febeec5ea73a804f30dcec3181ca ]

The device_node pointer is returned by of_parse_phandle()  with refcount
incremented. We should use of_node_put() on it when done.

This function only calls of_node_put() in the regular path.
And it will cause refcount leak in error paths.
Fix this by calling of_node_put() in error handling too.

Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://lore.kernel.org/r/20220316014059.19292-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mediatek/mt8183/mt8183-da7219-max98357.c  | 23 +++++++++++++------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c b/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c
index 718505c75418..f090dee0c7a4 100644
--- a/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c
+++ b/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c
@@ -695,8 +695,11 @@ static int mt8183_da7219_max98357_dev_probe(struct platform_device *pdev)
 	}
 
 	card = (struct snd_soc_card *)of_device_get_match_data(&pdev->dev);
-	if (!card)
-		return -EINVAL;
+	if (!card) {
+		ret = -EINVAL;
+		goto put_platform_node;
+	}
+
 	card->dev = &pdev->dev;
 
 	hdmi_codec = of_parse_phandle(pdev->dev.of_node,
@@ -761,12 +764,15 @@ static int mt8183_da7219_max98357_dev_probe(struct platform_device *pdev)
 	if (!mt8183_da7219_max98357_headset_dev.dlc.of_node) {
 		dev_err(&pdev->dev,
 			"Property 'mediatek,headset-codec' missing/invalid\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_hdmi_codec;
 	}
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
+	if (!priv) {
+		ret = -ENOMEM;
+		goto put_hdmi_codec;
+	}
 
 	snd_soc_card_set_drvdata(card, priv);
 
@@ -775,13 +781,16 @@ static int mt8183_da7219_max98357_dev_probe(struct platform_device *pdev)
 		ret = PTR_ERR(pinctrl);
 		dev_err(&pdev->dev, "%s failed to select default state %d\n",
 			__func__, ret);
-		return ret;
+		goto put_hdmi_codec;
 	}
 
 	ret = devm_snd_soc_register_card(&pdev->dev, card);
 
-	of_node_put(platform_node);
+
+put_hdmi_codec:
 	of_node_put(hdmi_codec);
+put_platform_node:
+	of_node_put(platform_node);
 	return ret;
 }
 
-- 
2.34.1



