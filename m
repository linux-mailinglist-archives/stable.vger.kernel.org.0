Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05F0DCA643
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390993AbfJCQly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:41:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392305AbfJCQly (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:41:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76A1A2070B;
        Thu,  3 Oct 2019 16:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120913;
        bh=J/bs4XMxCxNjfRh834VKdeds3kY5JdHtFEJmnLUJIb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2MaUw6kgzrrirYSfOKX1nsBGV4A32c5MQyXhlm7GjGQL3iTnEpzRIGCOl3ZideMOG
         majMnZOocy9GIWir8IkQ9Kx2F/AzxEeRlSS/rdalB67TGk+2bdWTQDcaWVdfd93bgG
         Nv27sfemaR/jOwcO391sPYhEqH5/JLZB3KNixaOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Kong <Leon.KONG@cn.bosch.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 084/344] ASoC: rsnd: dont call clk_get_rate() under atomic context
Date:   Thu,  3 Oct 2019 17:50:49 +0200
Message-Id: <20191003154548.464548706@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
>From SW point of view, we want to impletent it as
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
index fce4e050a9b70..b9aacf3d3b29c 100644
--- a/sound/soc/sh/rcar/adg.c
+++ b/sound/soc/sh/rcar/adg.c
@@ -30,6 +30,7 @@ struct rsnd_adg {
 	struct clk *clkout[CLKOUTMAX];
 	struct clk_onecell_data onecell;
 	struct rsnd_mod mod;
+	int clk_rate[CLKMAX];
 	u32 flags;
 	u32 ckr;
 	u32 rbga;
@@ -114,9 +115,9 @@ static void __rsnd_adg_get_timesel_ratio(struct rsnd_priv *priv,
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
@@ -302,7 +303,7 @@ int rsnd_adg_clk_query(struct rsnd_priv *priv, unsigned int rate)
 	 * AUDIO_CLKA/AUDIO_CLKB/AUDIO_CLKC/AUDIO_CLKI.
 	 */
 	for_each_rsnd_clk(clk, adg, i) {
-		if (rate == clk_get_rate(clk))
+		if (rate == adg->clk_rate[i])
 			return sel_table[i];
 	}
 
@@ -369,10 +370,18 @@ void rsnd_adg_clk_control(struct rsnd_priv *priv, int enable)
 
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



