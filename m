Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC5F4ABB45
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384308AbiBGL1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:27:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382091AbiBGLSQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:18:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2056DC03FEDE;
        Mon,  7 Feb 2022 03:18:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEC4FB8111C;
        Mon,  7 Feb 2022 11:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15900C004E1;
        Mon,  7 Feb 2022 11:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232685;
        bh=2WvEFVURxo4yYW09fMtPpYrTd9dtqHtvlmttqsLZCVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0dT+KV4MoMZl5/5BUhitBSsE1sgmNxvKV61oMUWsbNEYTZGhDPHA2b0wW+tA58Wgt
         diCRINIEs227YYQDrOhCDRdpPM6c+h4hiOb3UIqFa1p0fHUJaoZm5TkXjtFwlKjySC
         Z0jt2cCuY8w4ynKO8BohqHrz4e/CGyKN+b0ovZv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Mark Brown <broonie@kernel.org>,
        James Liao <jamesjj.liao@mediatek.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Daniel Golle <daniel@makrotopia.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.19 63/86] Revert "ASoC: mediatek: Check for error clk pointer"
Date:   Mon,  7 Feb 2022 12:06:26 +0100
Message-Id: <20220207103759.630087537@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
References: <20220207103757.550973048@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

This reverts commit e4f5f2767cd2c14fcb7b2c16dac5fe21888de9c2 which is
commit 9de2b9286a6dd16966959b3cb34fc2ddfd39213e upstream

With this patch in the tree, Chromebooks running the affected hardware
no longer boot. Bisect points to this patch, and reverting it fixes
the problem.

An analysis of the code with this patch applied shows:

        ret = init_clks(pdev, clk);
        if (ret)
                return ERR_PTR(ret);
...
                for (j = 0; j < MAX_CLKS && data->clk_id[j]; j++) {
                        struct clk *c = clk[data->clk_id[j]];

                        if (IS_ERR(c)) {
                                dev_err(&pdev->dev, "%s: clk unavailable\n",
                                        data->name);
                                return ERR_CAST(c);
                        }

                        scpd->clk[j] = c;
                }

Not all clocks in the clk_names array have to be present. Only the clocks
in the data->clk_id array are actually needed. The code already checks if
the required clocks are available and bails out if not. The assumption that
all clocks have to be present is wrong, and commit 9de2b9286a6d needs to be
reverted.

Fixes: 9de2b9286a6d ("ASoC: mediatek: Check for error clk pointer")
Cc: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc: Mark Brown <broonie@kernel.org>
Cc: James Liao <jamesjj.liao@mediatek.com>
Cc: Kevin Hilman <khilman@baylibre.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com
Cc: Frank Wunderlich <frank-w@public-files.de>
Cc: Daniel Golle <daniel@makrotopia.org>
Link: https://lore.kernel.org/lkml/20220205014755.699603-1-linux@roeck-us.net/
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/mediatek/mtk-scpsys.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/drivers/soc/mediatek/mtk-scpsys.c
+++ b/drivers/soc/mediatek/mtk-scpsys.c
@@ -341,17 +341,12 @@ out:
 	return ret;
 }
 
-static int init_clks(struct platform_device *pdev, struct clk **clk)
+static void init_clks(struct platform_device *pdev, struct clk **clk)
 {
 	int i;
 
-	for (i = CLK_NONE + 1; i < CLK_MAX; i++) {
+	for (i = CLK_NONE + 1; i < CLK_MAX; i++)
 		clk[i] = devm_clk_get(&pdev->dev, clk_names[i]);
-		if (IS_ERR(clk[i]))
-			return PTR_ERR(clk[i]);
-	}
-
-	return 0;
 }
 
 static struct scp *init_scp(struct platform_device *pdev,
@@ -361,7 +356,7 @@ static struct scp *init_scp(struct platf
 {
 	struct genpd_onecell_data *pd_data;
 	struct resource *res;
-	int i, j, ret;
+	int i, j;
 	struct scp *scp;
 	struct clk *clk[CLK_MAX];
 
@@ -416,9 +411,7 @@ static struct scp *init_scp(struct platf
 
 	pd_data->num_domains = num;
 
-	ret = init_clks(pdev, clk);
-	if (ret)
-		return ERR_PTR(ret);
+	init_clks(pdev, clk);
 
 	for (i = 0; i < num; i++) {
 		struct scp_domain *scpd = &scp->domains[i];


