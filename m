Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9444960BAE1
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234968AbiJXUmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234715AbiJXUlS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:41:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC8718BE1D;
        Mon, 24 Oct 2022 11:50:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0ED0FB819C4;
        Mon, 24 Oct 2022 12:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6399BC433D6;
        Mon, 24 Oct 2022 12:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615496;
        bh=4FXFAW603LAsvbX5JZ1c3QgnDtBja9JGedXoo4+jkPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0nfAx4MD2ibJI3hDsIu0C9Q9JTwOg3Nu4j9gCDlvPZGSiK/Fu6WWpe7+304KNDrn3
         fVcX1/xBkox/0G3wkSUejiHZ/qY8LUeOe93RFVqlIdjB6KiAJ5xOtp51gxOwovS6x2
         bAjIx9Mu4LcQy5EKEsb6TJNe5Fua3GmR9YRqvRQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 274/530] clk: meson: Hold reference returned by of_get_parent()
Date:   Mon, 24 Oct 2022 13:30:18 +0200
Message-Id: <20221024113057.474234882@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 89ab396d712f7c91fe94f55cff23460426f5fc81 ]

We should hold the reference returned by of_get_parent() and use it
to call of_node_put() for refcount balance.

Fixes: 88e2da81241e ("clk: meson: aoclk: refactor common code into dedicated file")
Fixes: 6682bd4d443f ("clk: meson: factorise meson64 peripheral clock controller drivers")
Fixes: bb6eddd1d28c ("clk: meson: meson8b: use the HHI syscon if available")

Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220628141038.168383-1-windhl@126.com
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/meson/meson-aoclk.c | 5 ++++-
 drivers/clk/meson/meson-eeclk.c | 5 ++++-
 drivers/clk/meson/meson8b.c     | 5 ++++-
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/meson/meson-aoclk.c b/drivers/clk/meson/meson-aoclk.c
index 27cd2c1f3f61..434cd8f9de82 100644
--- a/drivers/clk/meson/meson-aoclk.c
+++ b/drivers/clk/meson/meson-aoclk.c
@@ -38,6 +38,7 @@ int meson_aoclkc_probe(struct platform_device *pdev)
 	struct meson_aoclk_reset_controller *rstc;
 	struct meson_aoclk_data *data;
 	struct device *dev = &pdev->dev;
+	struct device_node *np;
 	struct regmap *regmap;
 	int ret, clkid;
 
@@ -49,7 +50,9 @@ int meson_aoclkc_probe(struct platform_device *pdev)
 	if (!rstc)
 		return -ENOMEM;
 
-	regmap = syscon_node_to_regmap(of_get_parent(dev->of_node));
+	np = of_get_parent(dev->of_node);
+	regmap = syscon_node_to_regmap(np);
+	of_node_put(np);
 	if (IS_ERR(regmap)) {
 		dev_err(dev, "failed to get regmap\n");
 		return PTR_ERR(regmap);
diff --git a/drivers/clk/meson/meson-eeclk.c b/drivers/clk/meson/meson-eeclk.c
index 8d5a5dab955a..0e5e6b57eb20 100644
--- a/drivers/clk/meson/meson-eeclk.c
+++ b/drivers/clk/meson/meson-eeclk.c
@@ -18,6 +18,7 @@ int meson_eeclkc_probe(struct platform_device *pdev)
 {
 	const struct meson_eeclkc_data *data;
 	struct device *dev = &pdev->dev;
+	struct device_node *np;
 	struct regmap *map;
 	int ret, i;
 
@@ -26,7 +27,9 @@ int meson_eeclkc_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	/* Get the hhi system controller node */
-	map = syscon_node_to_regmap(of_get_parent(dev->of_node));
+	np = of_get_parent(dev->of_node);
+	map = syscon_node_to_regmap(np);
+	of_node_put(np);
 	if (IS_ERR(map)) {
 		dev_err(dev,
 			"failed to get HHI regmap\n");
diff --git a/drivers/clk/meson/meson8b.c b/drivers/clk/meson/meson8b.c
index a844d35b553a..809a0bfb670d 100644
--- a/drivers/clk/meson/meson8b.c
+++ b/drivers/clk/meson/meson8b.c
@@ -3717,12 +3717,15 @@ static void __init meson8b_clkc_init_common(struct device_node *np,
 			struct clk_hw_onecell_data *clk_hw_onecell_data)
 {
 	struct meson8b_clk_reset *rstc;
+	struct device_node *parent_np;
 	const char *notifier_clk_name;
 	struct clk *notifier_clk;
 	struct regmap *map;
 	int i, ret;
 
-	map = syscon_node_to_regmap(of_get_parent(np));
+	parent_np = of_get_parent(np);
+	map = syscon_node_to_regmap(parent_np);
+	of_node_put(parent_np);
 	if (IS_ERR(map)) {
 		pr_err("failed to get HHI regmap - Trying obsolete regs\n");
 		return;
-- 
2.35.1



