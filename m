Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E511068111D
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237226AbjA3OKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237181AbjA3OKE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:10:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39E83B3D7
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:10:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B4B6B8117E
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:09:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99545C433EF;
        Mon, 30 Jan 2023 14:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087798;
        bh=YfOqNJE3zTnMBXhCwcZu+FEL09OpJJqkJOQhP+BX/x4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C8+pIXDV3LbJNxD1H+GszEueMj6zyYSriGusHZt/ubkx6gz+zh/o/7KfwoieTxKwJ
         EIbTQrS+XDfqlFO27K69RS95WlWYwIuBZJB4nGBYBBhmQe39MXfB2YnEsfm7m93twe
         p26arXrzon5TURpmPgHtWhLCWqMRtckr2d/yyWEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Philipp Zabel <p.zabel@pengutronix.de>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/204] reset: uniphier-glue: Use reset_control_bulk API
Date:   Mon, 30 Jan 2023 14:49:39 +0100
Message-Id: <20230130134316.922412599@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Zabel <p.zabel@pengutronix.de>

[ Upstream commit 176cae38719196a43cd8ae08377413a3884a9f15 ]

This driver already uses the clk_bulk API. Simplify the driver by using
the reset_control_bulk API as well.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Link: https://lore.kernel.org/r/20211215093829.3209416-1-p.zabel@pengutronix.de
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Stable-dep-of: 3a2390c6777e ("reset: uniphier-glue: Fix possible null-ptr-deref")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/reset-uniphier-glue.c | 33 ++++++++++++-----------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/reset/reset-uniphier-glue.c b/drivers/reset/reset-uniphier-glue.c
index 027990b79f61..6d422c69532c 100644
--- a/drivers/reset/reset-uniphier-glue.c
+++ b/drivers/reset/reset-uniphier-glue.c
@@ -23,7 +23,7 @@ struct uniphier_glue_reset_soc_data {
 
 struct uniphier_glue_reset_priv {
 	struct clk_bulk_data clk[MAX_CLKS];
-	struct reset_control *rst[MAX_RSTS];
+	struct reset_control_bulk_data rst[MAX_RSTS];
 	struct reset_simple_data rdata;
 	const struct uniphier_glue_reset_soc_data *data;
 };
@@ -34,8 +34,7 @@ static int uniphier_glue_reset_probe(struct platform_device *pdev)
 	struct uniphier_glue_reset_priv *priv;
 	struct resource *res;
 	resource_size_t size;
-	const char *name;
-	int i, ret, nr;
+	int i, ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -58,22 +57,20 @@ static int uniphier_glue_reset_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	for (i = 0; i < priv->data->nrsts; i++) {
-		name = priv->data->reset_names[i];
-		priv->rst[i] = devm_reset_control_get_shared(dev, name);
-		if (IS_ERR(priv->rst[i]))
-			return PTR_ERR(priv->rst[i]);
-	}
+	for (i = 0; i < priv->data->nrsts; i++)
+		priv->rst[i].id = priv->data->reset_names[i];
+	ret = devm_reset_control_bulk_get_shared(dev, priv->data->nrsts,
+						 priv->rst);
+	if (ret)
+		return ret;
 
 	ret = clk_bulk_prepare_enable(priv->data->nclks, priv->clk);
 	if (ret)
 		return ret;
 
-	for (nr = 0; nr < priv->data->nrsts; nr++) {
-		ret = reset_control_deassert(priv->rst[nr]);
-		if (ret)
-			goto out_rst_assert;
-	}
+	ret = reset_control_bulk_deassert(priv->data->nrsts, priv->rst);
+	if (ret)
+		goto out_clk_disable;
 
 	spin_lock_init(&priv->rdata.lock);
 	priv->rdata.rcdev.owner = THIS_MODULE;
@@ -91,9 +88,9 @@ static int uniphier_glue_reset_probe(struct platform_device *pdev)
 	return 0;
 
 out_rst_assert:
-	while (nr--)
-		reset_control_assert(priv->rst[nr]);
+	reset_control_bulk_assert(priv->data->nrsts, priv->rst);
 
+out_clk_disable:
 	clk_bulk_disable_unprepare(priv->data->nclks, priv->clk);
 
 	return ret;
@@ -102,10 +99,8 @@ static int uniphier_glue_reset_probe(struct platform_device *pdev)
 static int uniphier_glue_reset_remove(struct platform_device *pdev)
 {
 	struct uniphier_glue_reset_priv *priv = platform_get_drvdata(pdev);
-	int i;
 
-	for (i = 0; i < priv->data->nrsts; i++)
-		reset_control_assert(priv->rst[i]);
+	reset_control_bulk_assert(priv->data->nrsts, priv->rst);
 
 	clk_bulk_disable_unprepare(priv->data->nclks, priv->clk);
 
-- 
2.39.0



