Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0928A498E86
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234514AbiAXTmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:42:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345601AbiAXTkg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:40:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C17C0613DE;
        Mon, 24 Jan 2022 11:19:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 316B2612F3;
        Mon, 24 Jan 2022 19:19:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E850FC340E5;
        Mon, 24 Jan 2022 19:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051973;
        bh=Yl19xK2S3Yrf+HDHivDr1Qg8Bb/pOf54XZ1Z8dK3gjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/hOYHoPlyrKbNPul/AbPfHTWi191C6dC8symJckAEkzyRvX2x2ht+ySynNYBJEp+
         p6x7Ms9++Cok2xxz07iJDQizdQ+3mJ50XzIO2oljU3tM/mUT9mwGOS1r87FzX96CJL
         kJYYgNPICz59AY2LiLTnEf6LJETku5xBsLGxS7TI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 114/239] ASoC: mediatek: Check for error clk pointer
Date:   Mon, 24 Jan 2022 19:42:32 +0100
Message-Id: <20220124183946.729470383@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
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
index ef54f1638d207..01fcad7c8fae8 100644
--- a/drivers/soc/mediatek/mtk-scpsys.c
+++ b/drivers/soc/mediatek/mtk-scpsys.c
@@ -341,12 +341,17 @@ out:
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
@@ -356,7 +361,7 @@ static struct scp *init_scp(struct platform_device *pdev,
 {
 	struct genpd_onecell_data *pd_data;
 	struct resource *res;
-	int i, j;
+	int i, j, ret;
 	struct scp *scp;
 	struct clk *clk[CLK_MAX];
 
@@ -411,7 +416,9 @@ static struct scp *init_scp(struct platform_device *pdev,
 
 	pd_data->num_domains = num;
 
-	init_clks(pdev, clk);
+	ret = init_clks(pdev, clk);
+	if (ret)
+		return ERR_PTR(ret);
 
 	for (i = 0; i < num; i++) {
 		struct scp_domain *scpd = &scp->domains[i];
-- 
2.34.1



