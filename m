Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A926A3744F4
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236591AbhEERDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 13:03:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237128AbhEEQ5W (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:57:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F10D96199C;
        Wed,  5 May 2021 16:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232769;
        bh=+ot4lMWqUX257JwO3GAOUxyrX4ItBLZ8PY+M32gOzHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XDPMnvpqWPxQvUy/2+Mvw39UPOCKJ6wI8MpXeY7vmu8RByPQSPHl9ypQxyEjqUu8N
         lG3uM8o4NpKa3DY7zkC4o7w2RF16giugRb3Dy7fSV44+RVxYw3cTEQs5esTGMjhbJQ
         quG00Nzpa/U8e9F49h9H6BwmHEYh9RMCAIKUskm5x/zFqSmURmMoKOueFYjBpOr9G4
         q5DDLRKjLvs19thEv0eJHgfH06aM6n69fIWPUl7XR6ssxAsyv1L6AZiXt51hWfRvi+
         1A18OT4vEZwxz/MVTcQZWon2Fa07VlbjbQhpm8co2i/AmHoV93n7SeIUZayOAF5GTk
         dNRXEPSRZD07Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        "Linh Phung T . Y ." <linh.phung.jy@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 23/46] ASoC: rsnd: call rsnd_ssi_master_clk_start() from rsnd_ssi_init()
Date:   Wed,  5 May 2021 12:38:33 -0400
Message-Id: <20210505163856.3463279-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163856.3463279-1-sashal@kernel.org>
References: <20210505163856.3463279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 47d5ddb526f2..8926dd69e8b8 100644
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

