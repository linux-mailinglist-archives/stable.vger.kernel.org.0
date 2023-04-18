Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05FBD6E63B8
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbjDRMmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbjDRMmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:42:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7021314456
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:42:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F2D863345
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:42:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223F1C433D2;
        Tue, 18 Apr 2023 12:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821751;
        bh=QIjYVfhD4/s7Kmz/eMUMK44QfMHT9KQvNLUIggOotl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OggXmGaGWC4JDjenHtj6KpMw94/X96gJgPzbeR2bCACMn44A3R/fRZA9SFwZrY6Zr
         ZAC5btIJbnGUyeQgVwhMmH5PsPDwpk1bT3jlZ8IXgCbqxSG49BWrJ9OpLZC+4odiIl
         4c/BPNC5bZSr59PmgoILuDz26SsDksxBEMmiTm+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/134] clk: sprd: set max_register according to mapping range
Date:   Tue, 18 Apr 2023 14:21:24 +0200
Message-Id: <20230418120313.981638098@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunyan Zhang <chunyan.zhang@unisoc.com>

[ Upstream commit 47d43086531f10539470a63e8ad92803e686a3dd ]

In sprd clock driver, regmap_config.max_register was set to a fixed value
which is likely larger than the address range configured in device tree,
when reading registers through debugfs it would cause access violation.

Fixes: d41f59fd92f2 ("clk: sprd: Add common infrastructure")
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Link: https://lore.kernel.org/r/20230316023624.758204-1-chunyan.zhang@unisoc.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sprd/common.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/sprd/common.c b/drivers/clk/sprd/common.c
index ce81e4087a8fc..2bfbab8db94bf 100644
--- a/drivers/clk/sprd/common.c
+++ b/drivers/clk/sprd/common.c
@@ -17,7 +17,6 @@ static const struct regmap_config sprdclk_regmap_config = {
 	.reg_bits	= 32,
 	.reg_stride	= 4,
 	.val_bits	= 32,
-	.max_register	= 0xffff,
 	.fast_io	= true,
 };
 
@@ -43,6 +42,8 @@ int sprd_clk_regmap_init(struct platform_device *pdev,
 	struct device *dev = &pdev->dev;
 	struct device_node *node = dev->of_node, *np;
 	struct regmap *regmap;
+	struct resource *res;
+	struct regmap_config reg_config = sprdclk_regmap_config;
 
 	if (of_find_property(node, "sprd,syscon", NULL)) {
 		regmap = syscon_regmap_lookup_by_phandle(node, "sprd,syscon");
@@ -59,12 +60,14 @@ int sprd_clk_regmap_init(struct platform_device *pdev,
 			return PTR_ERR(regmap);
 		}
 	} else {
-		base = devm_platform_ioremap_resource(pdev, 0);
+		base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 		if (IS_ERR(base))
 			return PTR_ERR(base);
 
+		reg_config.max_register = resource_size(res) - reg_config.reg_stride;
+
 		regmap = devm_regmap_init_mmio(&pdev->dev, base,
-					       &sprdclk_regmap_config);
+					       &reg_config);
 		if (IS_ERR(regmap)) {
 			pr_err("failed to init regmap\n");
 			return PTR_ERR(regmap);
-- 
2.39.2



