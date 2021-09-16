Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C83F540E831
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354006AbhIPRiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:38:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344609AbhIPRf5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:35:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0518963234;
        Thu, 16 Sep 2021 16:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810943;
        bh=AV9wRD9lEMp2Qb/zjeTJnb2M22/TDCzs8tAi3oi+/+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nEimV/dCU9q+02yVvzlaspJG4ur67oCy3+/l7nqxOX/9qSNdQCe0HvskmuTpL1LpT
         zAorar9Rw2yKVSqkYKB0tdD+jZbUOqz6nDp7JeiGZ0zZeVTKUhvMVMUvoHxEYwdT7B
         5SGuc39d4kWbDbOuooXu2jVO438Pd/Ckv60hgeGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 325/432] ASoC: rsnd: adg: clearly handle clock error / NULL case
Date:   Thu, 16 Sep 2021 18:01:14 +0200
Message-Id: <20210916155821.859668974@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit cc64c390b215b404524725a94857d6fb58d9a62a ]

This driver is assuming that all adg->clk[i] is not NULL.
Because of this prerequisites, for_each_rsnd_clk() is possible to work
for all clk without checking NULL. In other words, all adg->clk[i]
should not NULL.

Some SoC might doesn't have clk_a/b/c/i. devm_clk_get() returns error in
such case. This driver calls rsnd_adg_null_clk_get() and use null_clk
instead of NULL in such cases.

But devm_clk_get() might returns NULL even though such clocks exist, but
it doesn't mean error (user deliberately chose to disable the feature).
NULL clk itself is not error from clk point of view, but is error from
this driver point of view because it is not assuming such case.

But current code is using IS_ERR() which doesn't care NULL.
This driver uses IS_ERR_OR_NULL() instead of IS_ERR() for clk check.
And it uses ERR_CAST() to clarify null_clk error.

One concern here is that it unconditionally uses null_clk if clk_a/b/c/i
was error. It is correct if it doesn't exist, but is not correct if it
returns error even though it exist.
It needs to check "clock-names" from DT before calling devm_clk_get() to
handling such case. But let's assume it is overkill so far.

Link: https://lore.kernel.org/r/YMCmhfQUimHCSH/n@mwanda
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/87v940wyf9.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rcar/adg.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/sh/rcar/adg.c b/sound/soc/sh/rcar/adg.c
index 0ebee1ed06a9..5f1e72edfee0 100644
--- a/sound/soc/sh/rcar/adg.c
+++ b/sound/soc/sh/rcar/adg.c
@@ -391,9 +391,9 @@ static struct clk *rsnd_adg_create_null_clk(struct rsnd_priv *priv,
 	struct clk *clk;
 
 	clk = clk_register_fixed_rate(dev, name, parent, 0, 0);
-	if (IS_ERR(clk)) {
+	if (IS_ERR_OR_NULL(clk)) {
 		dev_err(dev, "create null clk error\n");
-		return NULL;
+		return ERR_CAST(clk);
 	}
 
 	return clk;
@@ -430,9 +430,9 @@ static int rsnd_adg_get_clkin(struct rsnd_priv *priv)
 	for (i = 0; i < CLKMAX; i++) {
 		clk = devm_clk_get(dev, clk_name[i]);
 
-		if (IS_ERR(clk))
+		if (IS_ERR_OR_NULL(clk))
 			clk = rsnd_adg_null_clk_get(priv);
-		if (IS_ERR(clk))
+		if (IS_ERR_OR_NULL(clk))
 			goto err;
 
 		adg->clk[i] = clk;
@@ -582,7 +582,7 @@ static int rsnd_adg_get_clkout(struct rsnd_priv *priv)
 	if (!count) {
 		clk = clk_register_fixed_rate(dev, clkout_name[CLKOUT],
 					      parent_clk_name, 0, req_rate[0]);
-		if (IS_ERR(clk))
+		if (IS_ERR_OR_NULL(clk))
 			goto err;
 
 		adg->clkout[CLKOUT] = clk;
@@ -596,7 +596,7 @@ static int rsnd_adg_get_clkout(struct rsnd_priv *priv)
 			clk = clk_register_fixed_rate(dev, clkout_name[i],
 						      parent_clk_name, 0,
 						      req_rate[0]);
-			if (IS_ERR(clk))
+			if (IS_ERR_OR_NULL(clk))
 				goto err;
 
 			adg->clkout[i] = clk;
-- 
2.30.2



