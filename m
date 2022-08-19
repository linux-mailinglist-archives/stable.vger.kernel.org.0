Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 974D759A0D9
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352916AbiHSQ3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352767AbiHSQ1S (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:27:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37D511986B;
        Fri, 19 Aug 2022 09:04:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11F6161698;
        Fri, 19 Aug 2022 16:04:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9ACC433D6;
        Fri, 19 Aug 2022 16:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925047;
        bh=Z0NR9/jU7NPzm9A8SgemrFstoeQ930lhwENoftfU0xY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wl9R6O5jH70EqFbzm1L1cPCrLbDCjvL3OcIC8D72RB9hkuBLly1NQNxYG11YPfBZO
         p2ycYR/GNgUMgHyalxx24qFdops/+pc8y9ugVQe032vAFlvPYtWFYbqYeEylJiuHzK
         6MT/owEeOfnAZj9EFYXZBZ6HzZV7kbVbny6DSsws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 366/545] ASoC: mediatek: mt8173: Fix refcount leak in mt8173_rt5650_rt5676_dev_probe
Date:   Fri, 19 Aug 2022 17:42:16 +0200
Message-Id: <20220819153845.774509785@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

[ Upstream commit ae4f11c1ed2d67192fdf3d89db719ee439827c11 ]

of_parse_phandle() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Fix missing of_node_put() in error paths.

Fixes: 94319ba10eca ("ASoC: mediatek: Use platform_of_node for machine drivers")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220602034144.60159-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c b/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c
index c8e4e85e1057..94a9bbf144d1 100644
--- a/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c
+++ b/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c
@@ -256,14 +256,16 @@ static int mt8173_rt5650_rt5676_dev_probe(struct platform_device *pdev)
 	if (!mt8173_rt5650_rt5676_dais[DAI_LINK_CODEC_I2S].codecs[0].of_node) {
 		dev_err(&pdev->dev,
 			"Property 'audio-codec' missing or invalid\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_node;
 	}
 	mt8173_rt5650_rt5676_dais[DAI_LINK_CODEC_I2S].codecs[1].of_node =
 		of_parse_phandle(pdev->dev.of_node, "mediatek,audio-codec", 1);
 	if (!mt8173_rt5650_rt5676_dais[DAI_LINK_CODEC_I2S].codecs[1].of_node) {
 		dev_err(&pdev->dev,
 			"Property 'audio-codec' missing or invalid\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_node;
 	}
 	mt8173_rt5650_rt5676_codec_conf[0].dlc.of_node =
 		mt8173_rt5650_rt5676_dais[DAI_LINK_CODEC_I2S].codecs[1].of_node;
@@ -276,7 +278,8 @@ static int mt8173_rt5650_rt5676_dev_probe(struct platform_device *pdev)
 	if (!mt8173_rt5650_rt5676_dais[DAI_LINK_HDMI_I2S].codecs->of_node) {
 		dev_err(&pdev->dev,
 			"Property 'audio-codec' missing or invalid\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_node;
 	}
 
 	card->dev = &pdev->dev;
@@ -286,6 +289,7 @@ static int mt8173_rt5650_rt5676_dev_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "%s snd_soc_register_card fail %d\n",
 			__func__, ret);
 
+put_node:
 	of_node_put(platform_node);
 	return ret;
 }
-- 
2.35.1



