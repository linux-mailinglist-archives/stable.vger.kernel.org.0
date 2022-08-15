Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00DA95939D8
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245487AbiHOT2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344301AbiHOT0i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:26:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60912F390;
        Mon, 15 Aug 2022 11:42:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D5EE611C2;
        Mon, 15 Aug 2022 18:42:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377DCC433C1;
        Mon, 15 Aug 2022 18:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588951;
        bh=Fq2/Qa+l2s9n7XYaDXSNDg2FJSRH8B8oFrH9I8yNc8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wWtzQjqso+rCC6DI90nFOwY/P0sYwv0yo1F/bYCy5SQseMOA1GeHSaawep2FuDI7D
         fcqelvfW0hcFdBYl8MjAZuGA55D4nDuDx2nfrfbZ7fdKBzfUrp5VHaDfDfES8Ej/JU
         TI7Jca6FGA4/rUlLtD5c2shNNcZOQtwucPI6g4dI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 567/779] ASoC: mediatek: mt8173-rt5650: Fix refcount leak in mt8173_rt5650_dev_probe
Date:   Mon, 15 Aug 2022 20:03:31 +0200
Message-Id: <20220815180401.558005945@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit efe2178d1a32492f99e7f1f2568eea5c88a85729 ]

of_parse_phandle() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Fix refcount leak in some error paths.

Fixes: 0f83f9296d5c ("ASoC: mediatek: Add machine driver for ALC5650 codec")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220603124243.31358-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8173/mt8173-rt5650.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8173/mt8173-rt5650.c b/sound/soc/mediatek/mt8173/mt8173-rt5650.c
index e168d31f4445..1de9dab218c6 100644
--- a/sound/soc/mediatek/mt8173/mt8173-rt5650.c
+++ b/sound/soc/mediatek/mt8173/mt8173-rt5650.c
@@ -280,7 +280,8 @@ static int mt8173_rt5650_dev_probe(struct platform_device *pdev)
 	if (!mt8173_rt5650_dais[DAI_LINK_CODEC_I2S].codecs[0].of_node) {
 		dev_err(&pdev->dev,
 			"Property 'audio-codec' missing or invalid\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_platform_node;
 	}
 	mt8173_rt5650_dais[DAI_LINK_CODEC_I2S].codecs[1].of_node =
 		mt8173_rt5650_dais[DAI_LINK_CODEC_I2S].codecs[0].of_node;
@@ -293,7 +294,7 @@ static int mt8173_rt5650_dev_probe(struct platform_device *pdev)
 			dev_err(&pdev->dev,
 				"%s codec_capture_dai name fail %d\n",
 				__func__, ret);
-			return ret;
+			goto put_platform_node;
 		}
 		mt8173_rt5650_dais[DAI_LINK_CODEC_I2S].codecs[1].dai_name =
 			codec_capture_dai;
@@ -315,7 +316,8 @@ static int mt8173_rt5650_dev_probe(struct platform_device *pdev)
 	if (!mt8173_rt5650_dais[DAI_LINK_HDMI_I2S].codecs->of_node) {
 		dev_err(&pdev->dev,
 			"Property 'audio-codec' missing or invalid\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_platform_node;
 	}
 	card->dev = &pdev->dev;
 
@@ -324,6 +326,7 @@ static int mt8173_rt5650_dev_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "%s snd_soc_register_card fail %d\n",
 			__func__, ret);
 
+put_platform_node:
 	of_node_put(platform_node);
 	return ret;
 }
-- 
2.35.1



