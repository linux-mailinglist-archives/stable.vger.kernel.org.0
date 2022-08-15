Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20BD4594558
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349590AbiHOWib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350610AbiHOWgr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:36:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFED7284E;
        Mon, 15 Aug 2022 12:50:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A50561280;
        Mon, 15 Aug 2022 19:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56099C433D6;
        Mon, 15 Aug 2022 19:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593010;
        bh=9BfOsXGYkTa11M5togV2qruCjwfFzZqEaoB6aX8G2+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yZxQWnuck1tqSU6q7ObMDeihJAREjb2Y4VRNYRojOkfyfBYHmT5h2dWBGbdeUOyTL
         UuNrLZuxyuN+rlxwbrPzR4M92by4hbVy6HwSBKB41wF4NfKuRjv5R1vx+U6ABn+R2v
         dNCi/B3qFWkDGgFNyjIg2QEjUq/hb+mGN49Qbj2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0879/1095] ASoc: audio-graph-card2: Fix refcount leak bug in __graph_get_type()
Date:   Mon, 15 Aug 2022 20:04:38 +0200
Message-Id: <20220815180505.728162110@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Liang He <windhl@126.com>

[ Upstream commit eda26893dabfc6da7a1e1ff5f8628ed9faab3ab9 ]

We should call of_node_put() for the reference before its replacement
as it returned by of_get_parent() which has increased the refcount.
Besides, we should also call of_node_put() before return.

Fixes: c8c74939f791 ("ASoC: audio-graph-card2: add Multi CPU/Codec support")
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220713071200.366729-1-windhl@126.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/audio-graph-card2.c | 35 +++++++++++++++++++--------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/sound/soc/generic/audio-graph-card2.c b/sound/soc/generic/audio-graph-card2.c
index 328af836cf53..ba3551d9a040 100644
--- a/sound/soc/generic/audio-graph-card2.c
+++ b/sound/soc/generic/audio-graph-card2.c
@@ -229,7 +229,8 @@ enum graph_type {
 
 static enum graph_type __graph_get_type(struct device_node *lnk)
 {
-	struct device_node *np;
+	struct device_node *np, *parent_np;
+	enum graph_type ret;
 
 	/*
 	 * target {
@@ -240,19 +241,33 @@ static enum graph_type __graph_get_type(struct device_node *lnk)
 	 * };
 	 */
 	np = of_get_parent(lnk);
-	if (of_node_name_eq(np, "ports"))
-		np = of_get_parent(np);
+	if (of_node_name_eq(np, "ports")) {
+		parent_np = of_get_parent(np);
+		of_node_put(np);
+		np = parent_np;
+	}
 
-	if (of_node_name_eq(np, GRAPH_NODENAME_MULTI))
-		return GRAPH_MULTI;
+	if (of_node_name_eq(np, GRAPH_NODENAME_MULTI)) {
+		ret = GRAPH_MULTI;
+		goto out_put;
+	}
 
-	if (of_node_name_eq(np, GRAPH_NODENAME_DPCM))
-		return GRAPH_DPCM;
+	if (of_node_name_eq(np, GRAPH_NODENAME_DPCM)) {
+		ret = GRAPH_DPCM;
+		goto out_put;
+	}
 
-	if (of_node_name_eq(np, GRAPH_NODENAME_C2C))
-		return GRAPH_C2C;
+	if (of_node_name_eq(np, GRAPH_NODENAME_C2C)) {
+		ret = GRAPH_C2C;
+		goto out_put;
+	}
+
+	ret = GRAPH_NORMAL;
+
+out_put:
+	of_node_put(np);
+	return ret;
 
-	return GRAPH_NORMAL;
 }
 
 static enum graph_type graph_get_type(struct asoc_simple_priv *priv,
-- 
2.35.1



