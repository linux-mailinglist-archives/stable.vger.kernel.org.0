Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3C73C4F3D
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245402AbhGLHXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:23:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:32988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242520AbhGLHWV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:22:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 354C160FDC;
        Mon, 12 Jul 2021 07:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074372;
        bh=mveZEugygC5MY4rvkIqeNvkSeZCzNUZia+qsl3CGe40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n2YdmFyr/miTFXZV2V8z65WqDXj+E2ps39gzAgYSp/4BvpMmSQ9sOpwF6m65S7itw
         F3vNEDCC/m/jBJ6YumQNFzqHJBbRloQyR0YJThba9Fly5AjCZwqVfJCTdCvzQxOMvK
         5EdmEot9xjCUHpQXVvWCy9/fHQDYlJKbs37C710A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 558/700] ASoC: rsnd: tidyup loop on rsnd_adg_clk_query()
Date:   Mon, 12 Jul 2021 08:10:41 +0200
Message-Id: <20210712061035.581795193@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index abdfd9cf91e2..19c604b2e248 100644
--- a/sound/soc/sh/rcar/adg.c
+++ b/sound/soc/sh/rcar/adg.c
@@ -289,7 +289,6 @@ static void rsnd_adg_set_ssi_clk(struct rsnd_mod *ssi_mod, u32 val)
 int rsnd_adg_clk_query(struct rsnd_priv *priv, unsigned int rate)
 {
 	struct rsnd_adg *adg = rsnd_priv_to_adg(priv);
-	struct clk *clk;
 	int i;
 	int sel_table[] = {
 		[CLKA] = 0x1,
@@ -302,10 +301,9 @@ int rsnd_adg_clk_query(struct rsnd_priv *priv, unsigned int rate)
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



