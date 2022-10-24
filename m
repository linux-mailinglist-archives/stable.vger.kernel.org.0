Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D276760B221
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234688AbiJXQmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234591AbiJXQlu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:41:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B81A4D4D1;
        Mon, 24 Oct 2022 08:28:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE703B819A7;
        Mon, 24 Oct 2022 12:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D143C433D6;
        Mon, 24 Oct 2022 12:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615379;
        bh=0M6ldLkPIHOA6wq73aLHiYig4mC6FQqYwNyvlLZ3uo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kvIEuqwSkk+kYcc4bL4jQfQmsNA8OLD07UQZu8vBUobTCMldb1DyXlxSqKwLi18xl
         W5I2COxLRK3LSs7hrdttxjgNQt7fEMkdS7CoHiDpMw/8GBAfdaJN0b1CoNB7j1Ac0b
         PxzWzzFvW0i6ec+PKO6AzuEuOyyZ2X5BsdwIw660=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 227/530] ASoC: rsnd: Add check for rsnd_mod_power_on
Date:   Mon, 24 Oct 2022 13:29:31 +0200
Message-Id: <20221024113055.362937639@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 376be51caf8871419bbcbb755e1e615d30dc3153 ]

As rsnd_mod_power_on() can return negative numbers,
it should be better to check the return value and
deal with the exception.

Fixes: e7d850dd10f4 ("ASoC: rsnd: use mod base common method on SSI-parent")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/20220902013030.3691266-1-jiasheng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rcar/ctu.c | 6 +++++-
 sound/soc/sh/rcar/dvc.c | 6 +++++-
 sound/soc/sh/rcar/mix.c | 6 +++++-
 sound/soc/sh/rcar/src.c | 5 ++++-
 sound/soc/sh/rcar/ssi.c | 4 +++-
 5 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/sound/soc/sh/rcar/ctu.c b/sound/soc/sh/rcar/ctu.c
index 6156445bcb69..e39eb2ac7e95 100644
--- a/sound/soc/sh/rcar/ctu.c
+++ b/sound/soc/sh/rcar/ctu.c
@@ -171,7 +171,11 @@ static int rsnd_ctu_init(struct rsnd_mod *mod,
 			 struct rsnd_dai_stream *io,
 			 struct rsnd_priv *priv)
 {
-	rsnd_mod_power_on(mod);
+	int ret;
+
+	ret = rsnd_mod_power_on(mod);
+	if (ret < 0)
+		return ret;
 
 	rsnd_ctu_activation(mod);
 
diff --git a/sound/soc/sh/rcar/dvc.c b/sound/soc/sh/rcar/dvc.c
index 5137e03a9d7c..16befcbc312c 100644
--- a/sound/soc/sh/rcar/dvc.c
+++ b/sound/soc/sh/rcar/dvc.c
@@ -186,7 +186,11 @@ static int rsnd_dvc_init(struct rsnd_mod *mod,
 			 struct rsnd_dai_stream *io,
 			 struct rsnd_priv *priv)
 {
-	rsnd_mod_power_on(mod);
+	int ret;
+
+	ret = rsnd_mod_power_on(mod);
+	if (ret < 0)
+		return ret;
 
 	rsnd_dvc_activation(mod);
 
diff --git a/sound/soc/sh/rcar/mix.c b/sound/soc/sh/rcar/mix.c
index 3572c2c5686c..1de0e085804c 100644
--- a/sound/soc/sh/rcar/mix.c
+++ b/sound/soc/sh/rcar/mix.c
@@ -146,7 +146,11 @@ static int rsnd_mix_init(struct rsnd_mod *mod,
 			 struct rsnd_dai_stream *io,
 			 struct rsnd_priv *priv)
 {
-	rsnd_mod_power_on(mod);
+	int ret;
+
+	ret = rsnd_mod_power_on(mod);
+	if (ret < 0)
+		return ret;
 
 	rsnd_mix_activation(mod);
 
diff --git a/sound/soc/sh/rcar/src.c b/sound/soc/sh/rcar/src.c
index 0ea84ae57c6a..f832165e46bc 100644
--- a/sound/soc/sh/rcar/src.c
+++ b/sound/soc/sh/rcar/src.c
@@ -463,11 +463,14 @@ static int rsnd_src_init(struct rsnd_mod *mod,
 			 struct rsnd_priv *priv)
 {
 	struct rsnd_src *src = rsnd_mod_to_src(mod);
+	int ret;
 
 	/* reset sync convert_rate */
 	src->sync.val = 0;
 
-	rsnd_mod_power_on(mod);
+	ret = rsnd_mod_power_on(mod);
+	if (ret < 0)
+		return ret;
 
 	rsnd_src_activation(mod);
 
diff --git a/sound/soc/sh/rcar/ssi.c b/sound/soc/sh/rcar/ssi.c
index 43c5e27dc5c8..7ade6c5ed96f 100644
--- a/sound/soc/sh/rcar/ssi.c
+++ b/sound/soc/sh/rcar/ssi.c
@@ -480,7 +480,9 @@ static int rsnd_ssi_init(struct rsnd_mod *mod,
 
 	ssi->usrcnt++;
 
-	rsnd_mod_power_on(mod);
+	ret = rsnd_mod_power_on(mod);
+	if (ret < 0)
+		return ret;
 
 	rsnd_ssi_config_init(mod, io);
 
-- 
2.35.1



