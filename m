Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB9681C90
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730857AbfHENZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:25:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730691AbfHENZI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:25:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B34A20644;
        Mon,  5 Aug 2019 13:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011507;
        bh=RRV6MZPfpryWmJfI3TYE7p7hcAWQgxs1DRV86F8RDWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wHgBG+WTHBsNXmW2zo1rltcaCWCydgPn8/gog+4nm0TA5VaY6Dv/b+QqBT7gtpyuv
         YEtnC7MDoLaMgWUVccb91SH/mQbosOefPqgoIwFq59hwlfs114WBGBsMMeXO36p/7s
         xK3KBSrL8haM08D4CAKBiA5+WRvy7GE+pQmfultc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Weiyi Lu <weiyi.lu@mediatek.com>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.2 115/131] clk: mediatek: mt8183: Register 13MHz clock earlier for clocksource
Date:   Mon,  5 Aug 2019 15:03:22 +0200
Message-Id: <20190805124959.659590680@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weiyi Lu <weiyi.lu@mediatek.com>

commit c93d059a80450af99dd6c0e8c36790579343675a upstream.

The 13MHz clock should be registered before clocksource driver is
initialized. Use CLK_OF_DECLARE_DRIVER() to guarantee.

Fixes: acddfc2c261b ("clk: mediatek: Add MT8183 clock support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Weiyi Lu <weiyi.lu@mediatek.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/mediatek/clk-mt8183.c |   46 ++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 12 deletions(-)

--- a/drivers/clk/mediatek/clk-mt8183.c
+++ b/drivers/clk/mediatek/clk-mt8183.c
@@ -25,9 +25,11 @@ static const struct mtk_fixed_clk top_fi
 	FIXED_CLK(CLK_TOP_UNIVP_192M, "univpll_192m", "univpll", 192000000),
 };
 
+static const struct mtk_fixed_factor top_early_divs[] = {
+	FACTOR(CLK_TOP_CLK13M, "clk13m", "clk26m", 1, 2),
+};
+
 static const struct mtk_fixed_factor top_divs[] = {
-	FACTOR(CLK_TOP_CLK13M, "clk13m", "clk26m", 1,
-		2),
 	FACTOR(CLK_TOP_F26M_CK_D2, "csw_f26m_ck_d2", "clk26m", 1,
 		2),
 	FACTOR(CLK_TOP_SYSPLL_CK, "syspll_ck", "mainpll", 1,
@@ -1167,37 +1169,57 @@ static int clk_mt8183_apmixed_probe(stru
 	return of_clk_add_provider(node, of_clk_src_onecell_get, clk_data);
 }
 
+static struct clk_onecell_data *top_clk_data;
+
+static void clk_mt8183_top_init_early(struct device_node *node)
+{
+	int i;
+
+	top_clk_data = mtk_alloc_clk_data(CLK_TOP_NR_CLK);
+
+	for (i = 0; i < CLK_TOP_NR_CLK; i++)
+		top_clk_data->clks[i] = ERR_PTR(-EPROBE_DEFER);
+
+	mtk_clk_register_factors(top_early_divs, ARRAY_SIZE(top_early_divs),
+			top_clk_data);
+
+	of_clk_add_provider(node, of_clk_src_onecell_get, top_clk_data);
+}
+
+CLK_OF_DECLARE_DRIVER(mt8183_topckgen, "mediatek,mt8183-topckgen",
+			clk_mt8183_top_init_early);
+
 static int clk_mt8183_top_probe(struct platform_device *pdev)
 {
 	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	void __iomem *base;
-	struct clk_onecell_data *clk_data;
 	struct device_node *node = pdev->dev.of_node;
 
 	base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
-	clk_data = mtk_alloc_clk_data(CLK_TOP_NR_CLK);
-
 	mtk_clk_register_fixed_clks(top_fixed_clks, ARRAY_SIZE(top_fixed_clks),
-		clk_data);
+		top_clk_data);
+
+	mtk_clk_register_factors(top_early_divs, ARRAY_SIZE(top_early_divs),
+		top_clk_data);
 
-	mtk_clk_register_factors(top_divs, ARRAY_SIZE(top_divs), clk_data);
+	mtk_clk_register_factors(top_divs, ARRAY_SIZE(top_divs), top_clk_data);
 
 	mtk_clk_register_muxes(top_muxes, ARRAY_SIZE(top_muxes),
-		node, &mt8183_clk_lock, clk_data);
+		node, &mt8183_clk_lock, top_clk_data);
 
 	mtk_clk_register_composites(top_aud_muxes, ARRAY_SIZE(top_aud_muxes),
-		base, &mt8183_clk_lock, clk_data);
+		base, &mt8183_clk_lock, top_clk_data);
 
 	mtk_clk_register_composites(top_aud_divs, ARRAY_SIZE(top_aud_divs),
-		base, &mt8183_clk_lock, clk_data);
+		base, &mt8183_clk_lock, top_clk_data);
 
 	mtk_clk_register_gates(node, top_clks, ARRAY_SIZE(top_clks),
-		clk_data);
+		top_clk_data);
 
-	return of_clk_add_provider(node, of_clk_src_onecell_get, clk_data);
+	return of_clk_add_provider(node, of_clk_src_onecell_get, top_clk_data);
 }
 
 static int clk_mt8183_infra_probe(struct platform_device *pdev)


