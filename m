Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 707AD8C996
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbfHNCKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:10:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbfHNCKw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:10:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF3052084D;
        Wed, 14 Aug 2019 02:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748651;
        bh=x2byiKTwlxzg6k5db6cf1XwNeXRnTfzALjIqoBBeesU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tuuZ0smIBkBPNoVcVPs4Yet01BSAFsxROdiDq0/XHrkX4t2oloacGeLaY03jBkNJw
         b6E94xjeRYLTpzyciX2dY9+Eba6+hn2JTrHGTcw2n9awisBQmZBXXgtB/wATuvGAxQ
         X4/H5JmOmLVneHUFptOl+Iugr7kpRRxnASzP+zpc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Yang <wen.yang99@zte.com.cn>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 002/123] ASoC: simple-card: fix an use-after-free in simple_dai_link_of_dpcm()
Date:   Tue, 13 Aug 2019 22:08:46 -0400
Message-Id: <20190814021047.14828-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wen.yang99@zte.com.cn>

[ Upstream commit 724808ad556c15e9473418d082f8aae81dd267f6 ]

The node variable is still being used after the of_node_put() call,
which may result in use-after-free.

Fixes: cfc652a73331 ("ASoC: simple-card: tidyup prefix for snd_soc_codec_conf")
Link: https://lore.kernel.org/r/1562743509-30496-2-git-send-email-wen.yang99@zte.com.cn
Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/simple-card.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 9b568f578bcd2..544064fdc780c 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -138,8 +138,6 @@ static int simple_dai_link_of_dpcm(struct asoc_simple_priv *priv,
 
 	li->link++;
 
-	of_node_put(node);
-
 	/* For single DAI link & old style of DT node */
 	if (is_top)
 		prefix = PREFIX;
@@ -161,17 +159,17 @@ static int simple_dai_link_of_dpcm(struct asoc_simple_priv *priv,
 
 		ret = asoc_simple_parse_cpu(np, dai_link, &is_single_links);
 		if (ret)
-			return ret;
+			goto out_put_node;
 
 		ret = asoc_simple_parse_clk_cpu(dev, np, dai_link, dai);
 		if (ret < 0)
-			return ret;
+			goto out_put_node;
 
 		ret = asoc_simple_set_dailink_name(dev, dai_link,
 						   "fe.%s",
 						   dai_link->cpu_dai_name);
 		if (ret < 0)
-			return ret;
+			goto out_put_node;
 
 		asoc_simple_canonicalize_cpu(dai_link, is_single_links);
 	} else {
@@ -194,17 +192,17 @@ static int simple_dai_link_of_dpcm(struct asoc_simple_priv *priv,
 
 		ret = asoc_simple_parse_codec(np, dai_link);
 		if (ret < 0)
-			return ret;
+			goto out_put_node;
 
 		ret = asoc_simple_parse_clk_codec(dev, np, dai_link, dai);
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
@@ -222,19 +220,21 @@ static int simple_dai_link_of_dpcm(struct asoc_simple_priv *priv,
 
 	ret = asoc_simple_parse_tdm(np, dai);
 	if (ret)
-		return ret;
+		goto out_put_node;
 
 	ret = asoc_simple_parse_daifmt(dev, node, codec,
 				       prefix, &dai_link->dai_fmt);
 	if (ret < 0)
-		return ret;
+		goto out_put_node;
 
 	dai_link->dpcm_playback		= 1;
 	dai_link->dpcm_capture		= 1;
 	dai_link->ops			= &simple_ops;
 	dai_link->init			= asoc_simple_dai_init;
 
-	return 0;
+out_put_node:
+	of_node_put(node);
+	return ret;
 }
 
 static int simple_dai_link_of(struct asoc_simple_priv *priv,
-- 
2.20.1

