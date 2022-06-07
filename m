Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42729540B89
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244919AbiFGS3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350325AbiFGSYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:24:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D72E8BB4;
        Tue,  7 Jun 2022 10:54:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BA3DB82368;
        Tue,  7 Jun 2022 17:54:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28654C385A5;
        Tue,  7 Jun 2022 17:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624465;
        bh=em96KUtmUxqjE/vQ9jFYTvRm6TL+GsA7DhhwCkaWuFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GBmvUdFqDKOBGq1Wkoa3Fvu4BIs7AopwMD1S9mVxDsD1lGHY1309CnEQAQdW5Ei/H
         HbQqGuW+WZWZ+0KHlM6IOTJFHe5kdW4xeqH9OkKVCS9kwIa6korXm7Jdr2Sxffivf3
         5CR+Z+9rxaI9f0oBWX9PRwxSA4dF3S6+KNlZljtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 336/667] ASoC: ti: j721e-evm: Fix refcount leak in j721e_soc_probe_*
Date:   Tue,  7 Jun 2022 19:00:01 +0200
Message-Id: <20220607164944.843427820@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit a34840c4eb3278a7c29c9c57a65ce7541c66f9f2 ]

of_parse_phandle() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not needed anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: 6748d0559059 ("ASoC: ti: Add custom machine driver for j721e EVM (CPB and IVI)")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220512111331.44774-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ti/j721e-evm.c | 44 ++++++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 11 deletions(-)

diff --git a/sound/soc/ti/j721e-evm.c b/sound/soc/ti/j721e-evm.c
index 9347f982c3e1..149f4e2ce999 100644
--- a/sound/soc/ti/j721e-evm.c
+++ b/sound/soc/ti/j721e-evm.c
@@ -634,17 +634,18 @@ static int j721e_soc_probe_cpb(struct j721e_priv *priv, int *link_idx,
 	codec_node = of_parse_phandle(node, "ti,cpb-codec", 0);
 	if (!codec_node) {
 		dev_err(priv->dev, "CPB codec node is not provided\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_dai_node;
 	}
 
 	domain = &priv->audio_domains[J721E_AUDIO_DOMAIN_CPB];
 	ret = j721e_get_clocks(priv->dev, &domain->codec, "cpb-codec-scki");
 	if (ret)
-		return ret;
+		goto put_codec_node;
 
 	ret = j721e_get_clocks(priv->dev, &domain->mcasp, "cpb-mcasp-auxclk");
 	if (ret)
-		return ret;
+		goto put_codec_node;
 
 	/*
 	 * Common Processor Board, two links
@@ -654,8 +655,10 @@ static int j721e_soc_probe_cpb(struct j721e_priv *priv, int *link_idx,
 	comp_count = 6;
 	compnent = devm_kzalloc(priv->dev, comp_count * sizeof(*compnent),
 				GFP_KERNEL);
-	if (!compnent)
-		return -ENOMEM;
+	if (!compnent) {
+		ret = -ENOMEM;
+		goto put_codec_node;
+	}
 
 	comp_idx = 0;
 	priv->dai_links[*link_idx].cpus = &compnent[comp_idx++];
@@ -706,6 +709,12 @@ static int j721e_soc_probe_cpb(struct j721e_priv *priv, int *link_idx,
 	(*conf_idx)++;
 
 	return 0;
+
+put_codec_node:
+	of_node_put(codec_node);
+put_dai_node:
+	of_node_put(dai_node);
+	return ret;
 }
 
 static int j721e_soc_probe_ivi(struct j721e_priv *priv, int *link_idx,
@@ -730,23 +739,25 @@ static int j721e_soc_probe_ivi(struct j721e_priv *priv, int *link_idx,
 	codeca_node = of_parse_phandle(node, "ti,ivi-codec-a", 0);
 	if (!codeca_node) {
 		dev_err(priv->dev, "IVI codec-a node is not provided\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_dai_node;
 	}
 
 	codecb_node = of_parse_phandle(node, "ti,ivi-codec-b", 0);
 	if (!codecb_node) {
 		dev_warn(priv->dev, "IVI codec-b node is not provided\n");
-		return 0;
+		ret = 0;
+		goto put_codeca_node;
 	}
 
 	domain = &priv->audio_domains[J721E_AUDIO_DOMAIN_IVI];
 	ret = j721e_get_clocks(priv->dev, &domain->codec, "ivi-codec-scki");
 	if (ret)
-		return ret;
+		goto put_codecb_node;
 
 	ret = j721e_get_clocks(priv->dev, &domain->mcasp, "ivi-mcasp-auxclk");
 	if (ret)
-		return ret;
+		goto put_codecb_node;
 
 	/*
 	 * IVI extension, two links
@@ -758,8 +769,10 @@ static int j721e_soc_probe_ivi(struct j721e_priv *priv, int *link_idx,
 	comp_count = 8;
 	compnent = devm_kzalloc(priv->dev, comp_count * sizeof(*compnent),
 				GFP_KERNEL);
-	if (!compnent)
-		return -ENOMEM;
+	if (!compnent) {
+		ret = -ENOMEM;
+		goto put_codecb_node;
+	}
 
 	comp_idx = 0;
 	priv->dai_links[*link_idx].cpus = &compnent[comp_idx++];
@@ -820,6 +833,15 @@ static int j721e_soc_probe_ivi(struct j721e_priv *priv, int *link_idx,
 	(*conf_idx)++;
 
 	return 0;
+
+
+put_codecb_node:
+	of_node_put(codecb_node);
+put_codeca_node:
+	of_node_put(codeca_node);
+put_dai_node:
+	of_node_put(dai_node);
+	return ret;
 }
 
 static int j721e_soc_probe(struct platform_device *pdev)
-- 
2.35.1



