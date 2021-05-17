Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF0438344E
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242002AbhEQPHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:07:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242882AbhEQPE5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:04:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D51F613DD;
        Mon, 17 May 2021 14:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261717;
        bh=crQZifefxFB5zTrNmQ8E/W5S9724KgP2XqK90+Y+VD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kechI9/jX/TcaQIts5RmeNidT07n8TaPa/xUr0bjWWpTYiQLFg4Gd2GyvGX+JtSee
         pmkltaqOt/Wk0TPJVVyLP3Tsy1+UGE4XsxImvNHIzCoN/lqGT3o+yo9NA5CdzvX4eZ
         FKQiOC9RG30zO/141/m/ZqXBIQ32aOxnthrar094=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Linh Phung T. Y." <linh.phung.jy@renesas.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/289] ASoC: rsnd: call rsnd_ssi_master_clk_start() from rsnd_ssi_init()
Date:   Mon, 17 May 2021 15:59:41 +0200
Message-Id: <20210517140307.087144453@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit a122a116fc6d8fcf2f202dcd185173a54268f239 ]

Current rsnd needs to call .prepare (P) for clock settings,
.trigger for playback start (S) and stop (E).
It should be called as below from SSI point of view.

	P -> S -> E -> P -> S -> E -> ...

But, if you used MIXer, below case might happen

	              (2)
	1: P -> S ---> E -> ...
	2:         P ----> S -> ...
	          (1)     (3)

P(1) setups clock, but E(2) resets it. and starts playback (3).
In such case, it will reports "SSI parent/child should use same rate".

rsnd_ssi_master_clk_start() which is the main function at (P)
was called from rsnd_ssi_init() (= S) before,
but was moved by below patch to rsnd_soc_dai_prepare() (= P) to avoid
using clk_get_rate() which shouldn't be used under atomic context.

	commit 4d230d1271064 ("ASoC: rsnd: fixup not to call clk_get/set
				under non-atomic")

Because of above patch, rsnd_ssi_master_clk_start() is now called at (P)
which is for non atomic context. But (P) is assuming that spin lock is
*not* used.
One issue now is rsnd_ssi_master_clk_start() is checking ssi->xxx
which should be protected by spin lock.

After above patch, adg.c had below patch for other reasons.

	commit 06e8f5c842f2d ("ASoC: rsnd: don't call clk_get_rate()
				under atomic context")

clk_get_rate() is used at probe() timing by this patch.
In other words, rsnd_ssi_master_clk_start() is no longer using
clk_get_rate() any more.

This means we can call it from rsnd_ssi_init() (= S) again which is
protected by spin lock.
This patch re-move it to under spin lock, and solves
1. checking ssi->xxx without spin lock issue.
2. clk setting / device start / device stop race condition.

Reported-by: Linh Phung T. Y. <linh.phung.jy@renesas.com>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/875z0x1jt5.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rcar/ssi.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/sound/soc/sh/rcar/ssi.c b/sound/soc/sh/rcar/ssi.c
index d0ded427a836..a2f8138d40c7 100644
--- a/sound/soc/sh/rcar/ssi.c
+++ b/sound/soc/sh/rcar/ssi.c
@@ -507,10 +507,15 @@ static int rsnd_ssi_init(struct rsnd_mod *mod,
 			 struct rsnd_priv *priv)
 {
 	struct rsnd_ssi *ssi = rsnd_mod_to_ssi(mod);
+	int ret;
 
 	if (!rsnd_ssi_is_run_mods(mod, io))
 		return 0;
 
+	ret = rsnd_ssi_master_clk_start(mod, io);
+	if (ret < 0)
+		return ret;
+
 	ssi->usrcnt++;
 
 	rsnd_mod_power_on(mod);
@@ -1060,13 +1065,6 @@ static int rsnd_ssi_pio_pointer(struct rsnd_mod *mod,
 	return 0;
 }
 
-static int rsnd_ssi_prepare(struct rsnd_mod *mod,
-			    struct rsnd_dai_stream *io,
-			    struct rsnd_priv *priv)
-{
-	return rsnd_ssi_master_clk_start(mod, io);
-}
-
 static struct rsnd_mod_ops rsnd_ssi_pio_ops = {
 	.name		= SSI_NAME,
 	.probe		= rsnd_ssi_common_probe,
@@ -1079,7 +1077,6 @@ static struct rsnd_mod_ops rsnd_ssi_pio_ops = {
 	.pointer	= rsnd_ssi_pio_pointer,
 	.pcm_new	= rsnd_ssi_pcm_new,
 	.hw_params	= rsnd_ssi_hw_params,
-	.prepare	= rsnd_ssi_prepare,
 	.get_status	= rsnd_ssi_get_status,
 };
 
@@ -1166,7 +1163,6 @@ static struct rsnd_mod_ops rsnd_ssi_dma_ops = {
 	.pcm_new	= rsnd_ssi_pcm_new,
 	.fallback	= rsnd_ssi_fallback,
 	.hw_params	= rsnd_ssi_hw_params,
-	.prepare	= rsnd_ssi_prepare,
 	.get_status	= rsnd_ssi_get_status,
 };
 
-- 
2.30.2



