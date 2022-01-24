Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20B1498E0B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349306AbiAXTiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:38:52 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57036 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346903AbiAXTbg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:31:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C08B61551;
        Mon, 24 Jan 2022 19:31:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6C1C340E5;
        Mon, 24 Jan 2022 19:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052694;
        bh=aUjhzXTyAHaJTVFOxM8vpuyzYbSsGkP8DhdJfquucl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yzqVMfPbodcLQM/BzRMJvgL3MDSzDKnX+0+3pT1IjxZiKZJ+7mlVQBCOIZls+snpJ
         p0wAi5WYaeY0C6I2wWRkqcvZNu58WCg5x/QX3HaQdI4kk7I+RA5yFHh3f0kSeBx6WB
         mWxr/M7Tl8CKqRzHMDLCxo7XcyayxhnzV56MMtZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 145/320] ASoC: mediatek: Check for error clk pointer
Date:   Mon, 24 Jan 2022 19:42:09 +0100
Message-Id: <20220124183958.566967543@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 9de2b9286a6dd16966959b3cb34fc2ddfd39213e ]

Yes, you are right and now the return code depending on the
init_clks().

Fixes: 6078c651947a ("soc: mediatek: Refine scpsys to support multiple platform")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20211222015157.1025853-1-jiasheng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-scpsys.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/mediatek/mtk-scpsys.c b/drivers/soc/mediatek/mtk-scpsys.c
index 75f25f08245fd..71afa2a99b17f 100644
--- a/drivers/soc/mediatek/mtk-scpsys.c
+++ b/drivers/soc/mediatek/mtk-scpsys.c
@@ -333,12 +333,17 @@ out:
 	return ret;
 }
 
-static void init_clks(struct platform_device *pdev, struct clk **clk)
+static int init_clks(struct platform_device *pdev, struct clk **clk)
 {
 	int i;
 
-	for (i = CLK_NONE + 1; i < CLK_MAX; i++)
+	for (i = CLK_NONE + 1; i < CLK_MAX; i++) {
 		clk[i] = devm_clk_get(&pdev->dev, clk_names[i]);
+		if (IS_ERR(clk[i]))
+			return PTR_ERR(clk[i]);
+	}
+
+	return 0;
 }
 
 static struct scp *init_scp(struct platform_device *pdev,
@@ -348,7 +353,7 @@ static struct scp *init_scp(struct platform_device *pdev,
 {
 	struct genpd_onecell_data *pd_data;
 	struct resource *res;
-	int i, j;
+	int i, j, ret;
 	struct scp *scp;
 	struct clk *clk[CLK_MAX];
 
@@ -403,7 +408,9 @@ static struct scp *init_scp(struct platform_device *pdev,
 
 	pd_data->num_domains = num;
 
-	init_clks(pdev, clk);
+	ret = init_clks(pdev, clk);
+	if (ret)
+		return ERR_PTR(ret);
 
 	for (i = 0; i < num; i++) {
 		struct scp_domain *scpd = &scp->domains[i];
-- 
2.34.1



