Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE24650256
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbiLRQpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232449AbiLRQot (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:44:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB65C10047;
        Sun, 18 Dec 2022 08:16:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D73E7B80BA4;
        Sun, 18 Dec 2022 16:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B01C433F0;
        Sun, 18 Dec 2022 16:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380157;
        bh=EMGTs2CiTzTav5yWj5PLgl4miUln49624MWwLzHyE5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nq02SClmnWa91IIC7gBAweu1gc/C9xYbYhgafmp20aPHOJl6oBf4wKLs/5wOOUVG2
         b5Rv4yoLxoPxO/HBgfsYCnORkb+T9BthzRs9r4W6r+ve5IyXI6fF1KwrT2qMgLsvV3
         lPWPBpsTDSukmkPy5MrLMQzTEGPmLXZvqHKvJhng7GLMBjuL0uVYT8QmrdP5Kt8niI
         +nqG0TqjfgRjXF2rMLmLcPfqee7L1JJC+kUCzvOzkKEyIlGlFqC+GskLM+eyQIdZMd
         cg5TezP74CDzuPfMYiEgk1mtDMuWdQaUmhj79O9NjY8RxERu8N5KIn4VruDCQuNx/K
         qJQPEhzrxA+FA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiu Jianfeng <xiujianfeng@huawei.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mturquette@baylibre.com,
        avolmat@me.com, windhl@126.com, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 46/46] clk: st: Fix memory leak in st_of_quadfs_setup()
Date:   Sun, 18 Dec 2022 11:12:44 -0500
Message-Id: <20221218161244.930785-46-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218161244.930785-1-sashal@kernel.org>
References: <20221218161244.930785-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiu Jianfeng <xiujianfeng@huawei.com>

[ Upstream commit cfd3ffb36f0d566846163118651d868e607300ba ]

If st_clk_register_quadfs_pll() fails, @lock should be freed before goto
@err_exit, otherwise will cause meory leak issue, fix it.

Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Link: https://lore.kernel.org/r/20221122133614.184910-1-xiujianfeng@huawei.com
Reviewed-by: Patrice Chotard <patrice.chotard@foss.st.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/st/clkgen-fsyn.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/st/clkgen-fsyn.c b/drivers/clk/st/clkgen-fsyn.c
index 164285d6be97..ba18e58f0aae 100644
--- a/drivers/clk/st/clkgen-fsyn.c
+++ b/drivers/clk/st/clkgen-fsyn.c
@@ -1008,9 +1008,10 @@ static void __init st_of_quadfs_setup(struct device_node *np,
 
 	clk = st_clk_register_quadfs_pll(pll_name, clk_parent_name, datac->data,
 			reg, lock);
-	if (IS_ERR(clk))
+	if (IS_ERR(clk)) {
+		kfree(lock);
 		goto err_exit;
-	else
+	} else
 		pr_debug("%s: parent %s rate %u\n",
 			__clk_get_name(clk),
 			__clk_get_name(clk_get_parent(clk)),
-- 
2.35.1

