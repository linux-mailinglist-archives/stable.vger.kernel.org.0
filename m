Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9336459D8BB
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243012AbiHWJ5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243219AbiHWJwj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:52:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04C37B78A;
        Tue, 23 Aug 2022 01:46:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8282CB81C53;
        Tue, 23 Aug 2022 08:45:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E690AC433C1;
        Tue, 23 Aug 2022 08:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244314;
        bh=OIFz9Puy2x0e9AK+d1L7NJn2m8YPZnlzGVGHvm1SSgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mtK2VeYkMUPGo7bihZHvYN48T03TepmRCSYPYZRsDiKKpypI1P/dEKVAsUV/1rWN+
         TOviHoiExTcQv7OUe6crxPABS9510xdvw6EkrmJz0oUWiddmIHcAsxqPajj5ABAE0j
         /Eo4a09bV1uF+QFr/8Vfi5BVRcP3DXyUSD1qksLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 118/229] ASoC: mediatek: mt8173: Fix refcount leak in mt8173_rt5650_rt5676_dev_probe
Date:   Tue, 23 Aug 2022 10:24:39 +0200
Message-Id: <20220823080057.908983731@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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
index 61b0d8f8678e..90606b177eaf 100644
--- a/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c
+++ b/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c
@@ -255,14 +255,16 @@ static int mt8173_rt5650_rt5676_dev_probe(struct platform_device *pdev)
 	if (!mt8173_rt5650_rt5676_codecs[0].of_node) {
 		dev_err(&pdev->dev,
 			"Property 'audio-codec' missing or invalid\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_node;
 	}
 	mt8173_rt5650_rt5676_codecs[1].of_node =
 		of_parse_phandle(pdev->dev.of_node, "mediatek,audio-codec", 1);
 	if (!mt8173_rt5650_rt5676_codecs[1].of_node) {
 		dev_err(&pdev->dev,
 			"Property 'audio-codec' missing or invalid\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_node;
 	}
 	mt8173_rt5650_rt5676_codec_conf[0].of_node =
 		mt8173_rt5650_rt5676_codecs[1].of_node;
@@ -275,7 +277,8 @@ static int mt8173_rt5650_rt5676_dev_probe(struct platform_device *pdev)
 	if (!mt8173_rt5650_rt5676_dais[DAI_LINK_HDMI_I2S].codec_of_node) {
 		dev_err(&pdev->dev,
 			"Property 'audio-codec' missing or invalid\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_node;
 	}
 
 	card->dev = &pdev->dev;
@@ -285,6 +288,7 @@ static int mt8173_rt5650_rt5676_dev_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "%s snd_soc_register_card fail %d\n",
 			__func__, ret);
 
+put_node:
 	of_node_put(platform_node);
 	return ret;
 }
-- 
2.35.1



