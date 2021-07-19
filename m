Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E29F3CDE24
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245717AbhGSPCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:02:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343562AbhGSO7N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:59:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCC4F613FD;
        Mon, 19 Jul 2021 15:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709013;
        bh=ekly2r3/9OhVJ9p26++FHPxq7FNSFnXO8gg1d7hT8Xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ixK4zwIZbgPQXfKQoJGVbW3nlKqjKs+pl8ZFFz2FIULQHQ9Sh6Z3fVcgsStN1PrM0
         xAVf7efRlXYiaGeoi9LDJ6hXvFrPqGwVI0M6A9NyBdiT9NqFiP5ll16mCpNzvdqBS/
         3DLUNDBqmIpjacm73V/D6isRZIk67S6PYN1U5SP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 186/421] ASoC: rsnd: tidyup loop on rsnd_adg_clk_query()
Date:   Mon, 19 Jul 2021 16:49:57 +0200
Message-Id: <20210719144952.872823027@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit cf9d5c6619fadfc41cf8f5154cb990cc38e3da85 ]

commit 06e8f5c842f2d ("ASoC: rsnd: don't call clk_get_rate() under
atomic context") used saved clk_rate, thus for_each_rsnd_clk()
is no longer needed. This patch fixes it.

Fixes: 06e8f5c842f2d ("ASoC: rsnd: don't call clk_get_rate() under atomic context")
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/87v978oe2u.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rcar/adg.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/sh/rcar/adg.c b/sound/soc/sh/rcar/adg.c
index 549a137878a6..dc08260031ee 100644
--- a/sound/soc/sh/rcar/adg.c
+++ b/sound/soc/sh/rcar/adg.c
@@ -318,7 +318,6 @@ static void rsnd_adg_set_ssi_clk(struct rsnd_mod *ssi_mod, u32 val)
 int rsnd_adg_clk_query(struct rsnd_priv *priv, unsigned int rate)
 {
 	struct rsnd_adg *adg = rsnd_priv_to_adg(priv);
-	struct clk *clk;
 	int i;
 	int sel_table[] = {
 		[CLKA] = 0x1,
@@ -331,10 +330,9 @@ int rsnd_adg_clk_query(struct rsnd_priv *priv, unsigned int rate)
 	 * find suitable clock from
 	 * AUDIO_CLKA/AUDIO_CLKB/AUDIO_CLKC/AUDIO_CLKI.
 	 */
-	for_each_rsnd_clk(clk, adg, i) {
+	for (i = 0; i < CLKMAX; i++)
 		if (rate == adg->clk_rate[i])
 			return sel_table[i];
-	}
 
 	/*
 	 * find divided clock from BRGA/BRGB
-- 
2.30.2



