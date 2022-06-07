Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B20540582
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346286AbiFGR0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346967AbiFGRZg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:25:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B1D10636D;
        Tue,  7 Jun 2022 10:23:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A458360ADF;
        Tue,  7 Jun 2022 17:23:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16A0C385A5;
        Tue,  7 Jun 2022 17:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622625;
        bh=XCDoPkFzi2GCk4nu12Lh9MawcZyFKsIFhVf1GdmdXU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vllkgUYiZcGE+nSOGhVG1whqAq4kgbVAzIr3OpNDEl4pYZqU/9L8AWakPjIdAxLQA
         Li/0aRUoedZQUT4t4qAi/gxs2isx5ziwz88pQLuN4FGjgJEVrMbEMYHSI72LcfzwgL
         RNtyngxWdZr2oUkfQblOj6WoMayjBgIiCXfgLqPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 127/452] ASoC: mediatek: Fix error handling in mt8173_max98090_dev_probe
Date:   Tue,  7 Jun 2022 18:59:44 +0200
Message-Id: <20220607164912.343209503@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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

[ Upstream commit 4f4e0454e226de3bf4efd7e7924d1edc571c52d5 ]

Call of_node_put(platform_node) to avoid refcount leak in
the error path.

Fixes: 94319ba10eca ("ASoC: mediatek: Use platform_of_node for machine drivers")
Fixes: 493433785df0 ("ASoC: mediatek: mt8173: fix device_node leak")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20220404092903.26725-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8173/mt8173-max98090.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/mt8173/mt8173-max98090.c b/sound/soc/mediatek/mt8173/mt8173-max98090.c
index 3bdd4931316c..5f39e810e27a 100644
--- a/sound/soc/mediatek/mt8173/mt8173-max98090.c
+++ b/sound/soc/mediatek/mt8173/mt8173-max98090.c
@@ -167,7 +167,8 @@ static int mt8173_max98090_dev_probe(struct platform_device *pdev)
 	if (!codec_node) {
 		dev_err(&pdev->dev,
 			"Property 'audio-codec' missing or invalid\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_platform_node;
 	}
 	for_each_card_prelinks(card, i, dai_link) {
 		if (dai_link->codecs->name)
@@ -182,6 +183,8 @@ static int mt8173_max98090_dev_probe(struct platform_device *pdev)
 			__func__, ret);
 
 	of_node_put(codec_node);
+
+put_platform_node:
 	of_node_put(platform_node);
 	return ret;
 }
-- 
2.35.1



