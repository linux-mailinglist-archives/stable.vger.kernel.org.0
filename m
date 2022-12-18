Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D98A6500AB
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbiLRQRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:17:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbiLRQRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:17:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF96BCA9;
        Sun, 18 Dec 2022 08:07:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1E3660DD7;
        Sun, 18 Dec 2022 16:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FCCDC433D2;
        Sun, 18 Dec 2022 16:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379648;
        bh=NR1KHJq5MOKt4EP/CbVWkTiDQtdI+ZXlOGWYGcjxais=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/n89MEZImkNDOfAzUO4ugvBBKsVIavkw4DNCXP1JnXl5QmBxB4gcB7SE/M4mozmp
         5+DPq0uGtiTbMlrDQKgHN6JrJUR0fIDXHVaAI8787PmWgU64iLz9GUTTKNMYvTd1Ce
         tIwbualwxFEUqv5tHTWGBX+0H1Dss5BvgP1KpAtBLPYU/2+KPgsPTi0WESp8uNvyFh
         USSUroTO1A9gg/3R/mBagdam7cfF4KmJXWGO2AHY3DD1mglTfA/Pl/ZTdsxg7RaEpA
         OqHbuAy+PxY6885XYTnHZIhHt2EfZzDcF1npzytnan1YnOu9z8Sv6kWSb357XzpzQ4
         qk3kKQKQ4GFvA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiu Jianfeng <xiujianfeng@huawei.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mturquette@baylibre.com,
        avolmat@me.com, windhl@126.com, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 80/85] clk: st: Fix memory leak in st_of_quadfs_setup()
Date:   Sun, 18 Dec 2022 11:01:37 -0500
Message-Id: <20221218160142.925394-80-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160142.925394-1-sashal@kernel.org>
References: <20221218160142.925394-1-sashal@kernel.org>
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
index d820292a381d..40df1db102a7 100644
--- a/drivers/clk/st/clkgen-fsyn.c
+++ b/drivers/clk/st/clkgen-fsyn.c
@@ -1020,9 +1020,10 @@ static void __init st_of_quadfs_setup(struct device_node *np,
 
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

