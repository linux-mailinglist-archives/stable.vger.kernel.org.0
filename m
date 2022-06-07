Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E250541803
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378759AbiFGVHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379790AbiFGVG0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:06:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1EC620FC40;
        Tue,  7 Jun 2022 11:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 935A2B82182;
        Tue,  7 Jun 2022 18:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB45C385A2;
        Tue,  7 Jun 2022 18:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627802;
        bh=z4wDMbAV2RS1G7aP/5ULZccvzCp/6WBnP3rMRzqLcME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZOiWZD5g2CpZW0SNsSlxqdM+76ILcNwrfl1JqM97u0nX5AYHMDVPdpAjmQugzU7Yo
         NG19ZtbV/1+K1n6NgPIUd5FXEXt7I5PA5rySRuBTTgMeWq0Ubhpr8evIiNl1IWBoUb
         fqIXDxdqD8fMPsUlxhRpGFCKW/+0XfHf4UlCoI3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 097/879] ASoC: rsnd: care return value from rsnd_node_fixed_index()
Date:   Tue,  7 Jun 2022 18:53:35 +0200
Message-Id: <20220607165005.510400183@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit d09a7db431c65aaa8303eb456439d1831ca2e6b4 ]

Renesas Sound is very complex, and thus it needs to use
rsnd_node_fixed_index() to know enabled pin index.

It returns error if strange pin was selected,
but some codes didn't check it.

This patch 1) indicates error message, 2) check return
value.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/87pmlbgn5t.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rcar/core.c | 15 ++++++++++-----
 sound/soc/sh/rcar/dma.c  |  9 ++++++++-
 sound/soc/sh/rcar/rsnd.h |  2 +-
 sound/soc/sh/rcar/src.c  |  7 ++++++-
 sound/soc/sh/rcar/ssi.c  | 14 ++++++++++++--
 sound/soc/sh/rcar/ssiu.c |  7 ++++++-
 6 files changed, 43 insertions(+), 11 deletions(-)

diff --git a/sound/soc/sh/rcar/core.c b/sound/soc/sh/rcar/core.c
index 6a8fe0da7670..af8ef2a27d34 100644
--- a/sound/soc/sh/rcar/core.c
+++ b/sound/soc/sh/rcar/core.c
@@ -1159,6 +1159,7 @@ void rsnd_parse_connect_common(struct rsnd_dai *rdai, char *name,
 		struct device_node *capture)
 {
 	struct rsnd_priv *priv = rsnd_rdai_to_priv(rdai);
+	struct device *dev = rsnd_priv_to_dev(priv);
 	struct device_node *np;
 	int i;
 
@@ -1169,7 +1170,11 @@ void rsnd_parse_connect_common(struct rsnd_dai *rdai, char *name,
 	for_each_child_of_node(node, np) {
 		struct rsnd_mod *mod;
 
-		i = rsnd_node_fixed_index(np, name, i);
+		i = rsnd_node_fixed_index(dev, np, name, i);
+		if (i < 0) {
+			of_node_put(np);
+			break;
+		}
 
 		mod = mod_get(priv, i);
 
@@ -1183,7 +1188,7 @@ void rsnd_parse_connect_common(struct rsnd_dai *rdai, char *name,
 	of_node_put(node);
 }
 
-int rsnd_node_fixed_index(struct device_node *node, char *name, int idx)
+int rsnd_node_fixed_index(struct device *dev, struct device_node *node, char *name, int idx)
 {
 	char node_name[16];
 
@@ -1210,6 +1215,8 @@ int rsnd_node_fixed_index(struct device_node *node, char *name, int idx)
 			return idx;
 	}
 
+	dev_err(dev, "strange node numbering (%s)",
+		of_node_full_name(node));
 	return -EINVAL;
 }
 
@@ -1221,10 +1228,8 @@ int rsnd_node_count(struct rsnd_priv *priv, struct device_node *node, char *name
 
 	i = 0;
 	for_each_child_of_node(node, np) {
-		i = rsnd_node_fixed_index(np, name, i);
+		i = rsnd_node_fixed_index(dev, np, name, i);
 		if (i < 0) {
-			dev_err(dev, "strange node numbering (%s)",
-				of_node_full_name(node));
 			of_node_put(np);
 			return 0;
 		}
diff --git a/sound/soc/sh/rcar/dma.c b/sound/soc/sh/rcar/dma.c
index 03e0d4eca781..463ab237d7bd 100644
--- a/sound/soc/sh/rcar/dma.c
+++ b/sound/soc/sh/rcar/dma.c
@@ -240,12 +240,19 @@ static int rsnd_dmaen_start(struct rsnd_mod *mod,
 struct dma_chan *rsnd_dma_request_channel(struct device_node *of_node, char *name,
 					  struct rsnd_mod *mod, char *x)
 {
+	struct rsnd_priv *priv = rsnd_mod_to_priv(mod);
+	struct device *dev = rsnd_priv_to_dev(priv);
 	struct dma_chan *chan = NULL;
 	struct device_node *np;
 	int i = 0;
 
 	for_each_child_of_node(of_node, np) {
-		i = rsnd_node_fixed_index(np, name, i);
+		i = rsnd_node_fixed_index(dev, np, name, i);
+		if (i < 0) {
+			chan = NULL;
+			of_node_put(np);
+			break;
+		}
 
 		if (i == rsnd_mod_id_raw(mod) && (!chan))
 			chan = of_dma_request_slave_channel(np, x);
diff --git a/sound/soc/sh/rcar/rsnd.h b/sound/soc/sh/rcar/rsnd.h
index 6580bab0e229..d9cd190d7e19 100644
--- a/sound/soc/sh/rcar/rsnd.h
+++ b/sound/soc/sh/rcar/rsnd.h
@@ -460,7 +460,7 @@ void rsnd_parse_connect_common(struct rsnd_dai *rdai, char *name,
 		struct device_node *playback,
 		struct device_node *capture);
 int rsnd_node_count(struct rsnd_priv *priv, struct device_node *node, char *name);
-int rsnd_node_fixed_index(struct device_node *node, char *name, int idx);
+int rsnd_node_fixed_index(struct device *dev, struct device_node *node, char *name, int idx);
 
 int rsnd_channel_normalization(int chan);
 #define rsnd_runtime_channel_original(io) \
diff --git a/sound/soc/sh/rcar/src.c b/sound/soc/sh/rcar/src.c
index 42a100c6303d..0ea84ae57c6a 100644
--- a/sound/soc/sh/rcar/src.c
+++ b/sound/soc/sh/rcar/src.c
@@ -676,7 +676,12 @@ int rsnd_src_probe(struct rsnd_priv *priv)
 		if (!of_device_is_available(np))
 			goto skip;
 
-		i = rsnd_node_fixed_index(np, SRC_NAME, i);
+		i = rsnd_node_fixed_index(dev, np, SRC_NAME, i);
+		if (i < 0) {
+			ret = -EINVAL;
+			of_node_put(np);
+			goto rsnd_src_probe_done;
+		}
 
 		src = rsnd_src_get(priv, i);
 
diff --git a/sound/soc/sh/rcar/ssi.c b/sound/soc/sh/rcar/ssi.c
index 87e606f688d3..43c5e27dc5c8 100644
--- a/sound/soc/sh/rcar/ssi.c
+++ b/sound/soc/sh/rcar/ssi.c
@@ -1105,6 +1105,7 @@ void rsnd_parse_connect_ssi(struct rsnd_dai *rdai,
 			    struct device_node *capture)
 {
 	struct rsnd_priv *priv = rsnd_rdai_to_priv(rdai);
+	struct device *dev = rsnd_priv_to_dev(priv);
 	struct device_node *node;
 	struct device_node *np;
 	int i;
@@ -1117,7 +1118,11 @@ void rsnd_parse_connect_ssi(struct rsnd_dai *rdai,
 	for_each_child_of_node(node, np) {
 		struct rsnd_mod *mod;
 
-		i = rsnd_node_fixed_index(np, SSI_NAME, i);
+		i = rsnd_node_fixed_index(dev, np, SSI_NAME, i);
+		if (i < 0) {
+			of_node_put(np);
+			break;
+		}
 
 		mod = rsnd_ssi_mod_get(priv, i);
 
@@ -1182,7 +1187,12 @@ int rsnd_ssi_probe(struct rsnd_priv *priv)
 		if (!of_device_is_available(np))
 			goto skip;
 
-		i = rsnd_node_fixed_index(np, SSI_NAME, i);
+		i = rsnd_node_fixed_index(dev, np, SSI_NAME, i);
+		if (i < 0) {
+			ret = -EINVAL;
+			of_node_put(np);
+			goto rsnd_ssi_probe_done;
+		}
 
 		ssi = rsnd_ssi_get(priv, i);
 
diff --git a/sound/soc/sh/rcar/ssiu.c b/sound/soc/sh/rcar/ssiu.c
index 138f95dd9f4a..4b8a63e336c7 100644
--- a/sound/soc/sh/rcar/ssiu.c
+++ b/sound/soc/sh/rcar/ssiu.c
@@ -462,6 +462,7 @@ void rsnd_parse_connect_ssiu(struct rsnd_dai *rdai,
 			     struct device_node *capture)
 {
 	struct rsnd_priv *priv = rsnd_rdai_to_priv(rdai);
+	struct device *dev = rsnd_priv_to_dev(priv);
 	struct device_node *node = rsnd_ssiu_of_node(priv);
 	struct rsnd_dai_stream *io_p = &rdai->playback;
 	struct rsnd_dai_stream *io_c = &rdai->capture;
@@ -474,7 +475,11 @@ void rsnd_parse_connect_ssiu(struct rsnd_dai *rdai,
 		for_each_child_of_node(node, np) {
 			struct rsnd_mod *mod;
 
-			i = rsnd_node_fixed_index(np, SSIU_NAME, i);
+			i = rsnd_node_fixed_index(dev, np, SSIU_NAME, i);
+			if (i < 0) {
+				of_node_put(np);
+				break;
+			}
 
 			mod = rsnd_ssiu_mod_get(priv, i);
 
-- 
2.35.1



