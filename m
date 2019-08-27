Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 185BF9E004
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 09:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730030AbfH0H7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:59:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731291AbfH0H7r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:59:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B81D52186A;
        Tue, 27 Aug 2019 07:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892786;
        bh=OkhriDzPXJ2ft+U5w8rso8ZEaQTThAc6E1KDJGi771c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vo7aFEJ3Q75DhwL6EiDb1kyPX5Ubny+pHuRyinfZm6gu15jTc7+nP1uIu7RZNkT00
         pkqovgymDE6fFaO0xssvlYzLk+ZOCuzGdjpKd3B5Ufaw9WH5THUN6R9qHFelCQdcj7
         NzvEfblyMCJHrzgxzcxb2SmStKyklFIbfWJ532Zc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 004/162] ASoC: audio-graph-card: fix use-after-free in graph_dai_link_of_dpcm()
Date:   Tue, 27 Aug 2019 09:48:52 +0200
Message-Id: <20190827072738.306153730@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit aa2e362cb6b3f5ca88093ada01e1a0ace8a517b2 ]

After calling of_node_put() on the ports, port, and node variables,
they are still being used, which may result in use-after-free.
Fix this issue by calling of_node_put() after the last usage.

Fixes: dd98fbc558a0 ("ASoC: audio-graph-card: cleanup DAI link loop method - step1")
Link: https://lore.kernel.org/r/1562743509-30496-4-git-send-email-wen.yang99@zte.com.cn
Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/audio-graph-card.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/sound/soc/generic/audio-graph-card.c b/sound/soc/generic/audio-graph-card.c
index 70ed28d97d497..d5188a179378f 100644
--- a/sound/soc/generic/audio-graph-card.c
+++ b/sound/soc/generic/audio-graph-card.c
@@ -222,10 +222,6 @@ static int graph_dai_link_of_dpcm(struct asoc_simple_priv *priv,
 
 	dev_dbg(dev, "link_of DPCM (%pOF)\n", ep);
 
-	of_node_put(ports);
-	of_node_put(port);
-	of_node_put(node);
-
 	if (li->cpu) {
 		int is_single_links = 0;
 
@@ -243,17 +239,17 @@ static int graph_dai_link_of_dpcm(struct asoc_simple_priv *priv,
 
 		ret = asoc_simple_parse_cpu(ep, dai_link, &is_single_links);
 		if (ret)
-			return ret;
+			goto out_put_node;
 
 		ret = asoc_simple_parse_clk_cpu(dev, ep, dai_link, dai);
 		if (ret < 0)
-			return ret;
+			goto out_put_node;
 
 		ret = asoc_simple_set_dailink_name(dev, dai_link,
 						   "fe.%s",
 						   dai_link->cpu_dai_name);
 		if (ret < 0)
-			return ret;
+			goto out_put_node;
 
 		/* card->num_links includes Codec */
 		asoc_simple_canonicalize_cpu(dai_link, is_single_links);
@@ -277,17 +273,17 @@ static int graph_dai_link_of_dpcm(struct asoc_simple_priv *priv,
 
 		ret = asoc_simple_parse_codec(ep, dai_link);
 		if (ret < 0)
-			return ret;
+			goto out_put_node;
 
 		ret = asoc_simple_parse_clk_codec(dev, ep, dai_link, dai);
 		if (ret < 0)
-			return ret;
+			goto out_put_node;
 
 		ret = asoc_simple_set_dailink_name(dev, dai_link,
 						   "be.%s",
 						   codecs->dai_name);
 		if (ret < 0)
-			return ret;
+			goto out_put_node;
 
 		/* check "prefix" from top node */
 		snd_soc_of_parse_node_prefix(top, cconf, codecs->of_node,
@@ -307,19 +303,23 @@ static int graph_dai_link_of_dpcm(struct asoc_simple_priv *priv,
 
 	ret = asoc_simple_parse_tdm(ep, dai);
 	if (ret)
-		return ret;
+		goto out_put_node;
 
 	ret = asoc_simple_parse_daifmt(dev, cpu_ep, codec_ep,
 				       NULL, &dai_link->dai_fmt);
 	if (ret < 0)
-		return ret;
+		goto out_put_node;
 
 	dai_link->dpcm_playback		= 1;
 	dai_link->dpcm_capture		= 1;
 	dai_link->ops			= &graph_ops;
 	dai_link->init			= asoc_simple_dai_init;
 
-	return 0;
+out_put_node:
+	of_node_put(ports);
+	of_node_put(port);
+	of_node_put(node);
+	return ret;
 }
 
 static int graph_dai_link_of(struct asoc_simple_priv *priv,
-- 
2.20.1



