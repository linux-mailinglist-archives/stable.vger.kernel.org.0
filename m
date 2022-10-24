Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2422260B099
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbiJXQGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232803AbiJXQDZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:03:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7775814030;
        Mon, 24 Oct 2022 07:56:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB5C3B81670;
        Mon, 24 Oct 2022 12:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC1AC433D6;
        Mon, 24 Oct 2022 12:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614276;
        bh=I0US6l38rqGsDxa7m8QNmS8D7lDmiOG+/urZP2mhyxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=19aNddWxjDTkK+DCtGgp+KPgsSZdyRn+LiQfUlFg6XVgfslTj/MkGd14omW/xjTAw
         LHuSWeX6WXi/3utR+Sw5IdKmU0vr9Li7of4X0HBvgJ7wzO1516IWVWW8uyLIWfFOFo
         nsVXS5Jhqab5KEa8wmrJelNsltDA///M0WRLoeoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Orson Zhai <orsonzhai@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 200/390] clk: sprd: Hold reference returned by of_get_parent()
Date:   Mon, 24 Oct 2022 13:29:57 +0200
Message-Id: <20221024113031.292062805@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
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

[ Upstream commit 91e6455bf715fb1558a0bf8f645ec1c131254a3c ]

We should hold the reference returned by of_get_parent() and use it
to call of_node_put() for refcount balance.

Fixes: f95e8c7923d1 ("clk: sprd: support to get regmap from parent node")
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220704004729.272481-1-windhl@126.com
Reviewed-by: Orson Zhai <orsonzhai@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sprd/common.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/sprd/common.c b/drivers/clk/sprd/common.c
index d620bbbcdfc8..ce81e4087a8f 100644
--- a/drivers/clk/sprd/common.c
+++ b/drivers/clk/sprd/common.c
@@ -41,7 +41,7 @@ int sprd_clk_regmap_init(struct platform_device *pdev,
 {
 	void __iomem *base;
 	struct device *dev = &pdev->dev;
-	struct device_node *node = dev->of_node;
+	struct device_node *node = dev->of_node, *np;
 	struct regmap *regmap;
 
 	if (of_find_property(node, "sprd,syscon", NULL)) {
@@ -50,9 +50,10 @@ int sprd_clk_regmap_init(struct platform_device *pdev,
 			pr_err("%s: failed to get syscon regmap\n", __func__);
 			return PTR_ERR(regmap);
 		}
-	} else if (of_device_is_compatible(of_get_parent(dev->of_node),
-			   "syscon")) {
-		regmap = device_node_to_regmap(of_get_parent(dev->of_node));
+	} else if (of_device_is_compatible(np =	of_get_parent(node), "syscon") ||
+		   (of_node_put(np), 0)) {
+		regmap = device_node_to_regmap(np);
+		of_node_put(np);
 		if (IS_ERR(regmap)) {
 			dev_err(dev, "failed to get regmap from its parent.\n");
 			return PTR_ERR(regmap);
-- 
2.35.1



