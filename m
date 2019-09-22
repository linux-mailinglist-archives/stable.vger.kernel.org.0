Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E24ABBA93A
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730634AbfIVTMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:12:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438677AbfIVS5y (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:57:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01BB12190F;
        Sun, 22 Sep 2019 18:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178673;
        bh=nyBBVxg56+WBbZRAr6q8/BdvcmxX1/Rphjj2hQEMees=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=klX9sMY74bCnMhZZiST0sEL9LPNEd3or/l0ImT4BzmqXS0ndS4sgzgE7AQpth7YMg
         8uz5di1xJNf84qqj6OFVXtx+UpCF0UiaR7ynv4V6C5kKdFm6UURjdhKphs3un6V3Li
         Cu+UnIoEv/ZwVUlv+nVZv5olVdGnMFJmeYKG6Vqw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Leon Kong <Leon.KONG@cn.bosch.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 23/89] ASoC: rsnd: don't call clk_get_rate() under atomic context
Date:   Sun, 22 Sep 2019 14:56:11 -0400
Message-Id: <20190922185717.3412-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185717.3412-1-sashal@kernel.org>
References: <20190922185717.3412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 06e8f5c842f2dbb232897ba967ea7b422745c271 ]

ADG is using clk_get_rate() under atomic context, thus, we might
have scheduling issue.
To avoid this issue, we need to get/keep clk rate under
non atomic context.

We need to handle ADG as special device at Renesas Sound driver.
From SW point of view, we want to impletent it as
rsnd_mod_ops :: prepare, but it makes code just complicate.

To avoid complicated code/patch, this patch adds new clk_rate[] array,
and keep clk IN rate when rsnd_adg_clk_enable() was called.

Reported-by: Leon Kong <Leon.KONG@cn.bosch.com>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Tested-by: Leon Kong <Leon.KONG@cn.bosch.com>
Link: https://lore.kernel.org/r/87v9vb0xkp.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rcar/adg.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/sound/soc/sh/rcar/adg.c b/sound/soc/sh/rcar/adg.c
index eb7879bcc6a79..686401bcd1f53 100644
--- a/sound/soc/sh/rcar/adg.c
+++ b/sound/soc/sh/rcar/adg.c
@@ -33,6 +33,7 @@ struct rsnd_adg {
 	struct clk *clkout[CLKOUTMAX];
 	struct clk_onecell_data onecell;
 	struct rsnd_mod mod;
+	int clk_rate[CLKMAX];
 	u32 flags;
 	u32 ckr;
 	u32 rbga;
@@ -110,9 +111,9 @@ static void __rsnd_adg_get_timesel_ratio(struct rsnd_priv *priv,
 	unsigned int val, en;
 	unsigned int min, diff;
 	unsigned int sel_rate[] = {
-		clk_get_rate(adg->clk[CLKA]),	/* 0000: CLKA */
-		clk_get_rate(adg->clk[CLKB]),	/* 0001: CLKB */
-		clk_get_rate(adg->clk[CLKC]),	/* 0010: CLKC */
+		adg->clk_rate[CLKA],	/* 0000: CLKA */
+		adg->clk_rate[CLKB],	/* 0001: CLKB */
+		adg->clk_rate[CLKC],	/* 0010: CLKC */
 		adg->rbga_rate_for_441khz,	/* 0011: RBGA */
 		adg->rbgb_rate_for_48khz,	/* 0100: RBGB */
 	};
@@ -328,7 +329,7 @@ int rsnd_adg_clk_query(struct rsnd_priv *priv, unsigned int rate)
 	 * AUDIO_CLKA/AUDIO_CLKB/AUDIO_CLKC/AUDIO_CLKI.
 	 */
 	for_each_rsnd_clk(clk, adg, i) {
-		if (rate == clk_get_rate(clk))
+		if (rate == adg->clk_rate[i])
 			return sel_table[i];
 	}
 
@@ -394,10 +395,18 @@ void rsnd_adg_clk_control(struct rsnd_priv *priv, int enable)
 
 	for_each_rsnd_clk(clk, adg, i) {
 		ret = 0;
-		if (enable)
+		if (enable) {
 			ret = clk_prepare_enable(clk);
-		else
+
+			/*
+			 * We shouldn't use clk_get_rate() under
+			 * atomic context. Let's keep it when
+			 * rsnd_adg_clk_enable() was called
+			 */
+			adg->clk_rate[i] = clk_get_rate(adg->clk[i]);
+		} else {
 			clk_disable_unprepare(clk);
+		}
 
 		if (ret < 0)
 			dev_warn(dev, "can't use clk %d\n", i);
-- 
2.20.1

