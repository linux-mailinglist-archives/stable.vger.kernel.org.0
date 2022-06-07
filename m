Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13C555405F4
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346992AbiFGRcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347825AbiFGRbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:31:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C2B10A630;
        Tue,  7 Jun 2022 10:28:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E89456145D;
        Tue,  7 Jun 2022 17:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2635C34115;
        Tue,  7 Jun 2022 17:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622911;
        bh=wgil/TspLU/IoPr0ptWLutstO43Ee6qM15+0zCrW37E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K0hgBuPRFTDXAoyLtL8N1PrFWbba80mn7boFEFChYZvMxjuhMk5+Co27wGkbTIou5
         kjOiHjuxDk2pRn9we8V0ueOOh5nn5rmXln1ucZlU2OWYc2m3AErzmDcNYP8ODwTm8N
         KbGC01H6wRky3vp2/QpbdRRwJEu5eu743O+ufQJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 227/452] ASoC: ti: j721e-evm: Fix refcount leak in j721e_soc_probe_*
Date:   Tue,  7 Jun 2022 19:01:24 +0200
Message-Id: <20220607164915.327688477@linuxfoundation.org>
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
index 265bbc5a2f96..756cd9694cbe 100644
--- a/sound/soc/ti/j721e-evm.c
+++ b/sound/soc/ti/j721e-evm.c
@@ -631,17 +631,18 @@ static int j721e_soc_probe_cpb(struct j721e_priv *priv, int *link_idx,
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
@@ -651,8 +652,10 @@ static int j721e_soc_probe_cpb(struct j721e_priv *priv, int *link_idx,
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
@@ -703,6 +706,12 @@ static int j721e_soc_probe_cpb(struct j721e_priv *priv, int *link_idx,
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
@@ -727,23 +736,25 @@ static int j721e_soc_probe_ivi(struct j721e_priv *priv, int *link_idx,
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
@@ -755,8 +766,10 @@ static int j721e_soc_probe_ivi(struct j721e_priv *priv, int *link_idx,
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
@@ -817,6 +830,15 @@ static int j721e_soc_probe_ivi(struct j721e_priv *priv, int *link_idx,
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



