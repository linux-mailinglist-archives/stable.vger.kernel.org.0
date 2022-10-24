Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E76D60B56A
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 20:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiJXSYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 14:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbiJXSY0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 14:24:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E7520F5C;
        Mon, 24 Oct 2022 10:05:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 094BC612B1;
        Mon, 24 Oct 2022 12:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9490C433D6;
        Mon, 24 Oct 2022 12:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615499;
        bh=X38VWH2et6l8j7ErF92H2f0hZx1DchmzPhdw98JHFCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VroJbDnu6tpBQKoof3DD5+frb3CYeY2AcTV/8ylrMG7blE62h+Qmh63wJgLAQFl+P
         hF7sV9P4bagNmmnB3viw0QcVTPFmqWFhCAilrahmP2xuyZRHfnMrcms9eVnyDhpk/1
         tY3wH/Wcq8wlCSi6U8aUmq90Y5J4ylAujUcO/Pf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 275/530] clk: oxnas: Hold reference returned by of_get_parent()
Date:   Mon, 24 Oct 2022 13:30:19 +0200
Message-Id: <20221024113057.523545189@linuxfoundation.org>
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

[ Upstream commit 1d6aa08c54cd0e005210ab8e3b1e92ede70f8a4f ]

In oxnas_stdclk_probe(), we need to hold the reference returned by
of_get_parent() and use it to call of_node_put() for refcount
balance.

Fixes: 0bbd72b4c64f ("clk: Add Oxford Semiconductor OXNAS Standard Clocks")
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220628143155.170550-1-windhl@126.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-oxnas.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-oxnas.c b/drivers/clk/clk-oxnas.c
index 78d5ea669fea..2fe36f579ac5 100644
--- a/drivers/clk/clk-oxnas.c
+++ b/drivers/clk/clk-oxnas.c
@@ -207,7 +207,7 @@ static const struct of_device_id oxnas_stdclk_dt_ids[] = {
 
 static int oxnas_stdclk_probe(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node;
+	struct device_node *np = pdev->dev.of_node, *parent_np;
 	const struct oxnas_stdclk_data *data;
 	const struct of_device_id *id;
 	struct regmap *regmap;
@@ -219,7 +219,9 @@ static int oxnas_stdclk_probe(struct platform_device *pdev)
 		return -ENODEV;
 	data = id->data;
 
-	regmap = syscon_node_to_regmap(of_get_parent(np));
+	parent_np = of_get_parent(np);
+	regmap = syscon_node_to_regmap(parent_np);
+	of_node_put(parent_np);
 	if (IS_ERR(regmap)) {
 		dev_err(&pdev->dev, "failed to have parent regmap\n");
 		return PTR_ERR(regmap);
-- 
2.35.1



