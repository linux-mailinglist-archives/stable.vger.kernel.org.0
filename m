Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85DC33C5528
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354479AbhGLIJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:09:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352933AbhGLIAp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:00:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63BF961C44;
        Mon, 12 Jul 2021 07:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076437;
        bh=krQEekz+xGXC4oBXdWpzNl12PyKLo+4Onj6x+/Cdqwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xmPrRFr1o+I6hIOYVIWiazEqlPKNCNDdnk/p6uRgEDAlhy7Pl4xOwXfgPZW2r9QTR
         wiena/XlNcdN22gaNfqDL7RyjfscasEqIcHlLkVXdYHhpjHW5MO9VnWs5PTufZhEzg
         9M9LIcr94uE0yU+C7bSII7vVI2r67zzhSm6QVtZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 642/800] ASoC: rsnd: tidyup loop on rsnd_adg_clk_query()
Date:   Mon, 12 Jul 2021 08:11:05 +0200
Message-Id: <20210712061035.383158207@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index 0b8ae3eee148..93751099465d 100644
--- a/sound/soc/sh/rcar/adg.c
+++ b/sound/soc/sh/rcar/adg.c
@@ -290,7 +290,6 @@ static void rsnd_adg_set_ssi_clk(struct rsnd_mod *ssi_mod, u32 val)
 int rsnd_adg_clk_query(struct rsnd_priv *priv, unsigned int rate)
 {
 	struct rsnd_adg *adg = rsnd_priv_to_adg(priv);
-	struct clk *clk;
 	int i;
 	int sel_table[] = {
 		[CLKA] = 0x1,
@@ -303,10 +302,9 @@ int rsnd_adg_clk_query(struct rsnd_priv *priv, unsigned int rate)
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



