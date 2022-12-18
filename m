Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C21646502D1
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbiLRQx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:53:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232841AbiLRQxO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:53:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D6C1B9D3;
        Sun, 18 Dec 2022 08:18:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C2A6B80BA8;
        Sun, 18 Dec 2022 16:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFC8C433F0;
        Sun, 18 Dec 2022 16:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380314;
        bh=j7AMXqA6UutmlOa0DqAvRRIKjbXaFBBgrVpU+1Oe9Rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X8TdD+DgkgVxYneXKca2eM3kS3WUgiLvxcaaYO6KK9+z8fqeet7JYsR+GmNad3hc8
         obCmQPakHNGgQBcJKFW67iI5zGzGm28C86XAkixm/JhUWAZ6Uj/bSwf7+0ZBIhr2Eh
         hoDIVCN0VO+Ki2Hr7Uzd/zk7i8KNI/jPOGPwGS7KoKIwCG40ooVsN4HjYM/SyQP+qD
         PAb1ofKlw2tc4Zs8U3G4ec1p46hAohNzzPe7cL8oBk1L8a/2RSZYGkZVCEQce8PEOP
         Rq0vogkEOK38WvXFP89PR6rQ+8M/uaqzBbNw26pTkaJ03dA1b8fc9lmNiCiu1Bph6g
         WvpnEflNHx9Lw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiu Jianfeng <xiujianfeng@huawei.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mturquette@baylibre.com,
        windhl@126.com, avolmat@me.com, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 39/39] clk: st: Fix memory leak in st_of_quadfs_setup()
Date:   Sun, 18 Dec 2022 11:15:59 -0500
Message-Id: <20221218161559.932604-39-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218161559.932604-1-sashal@kernel.org>
References: <20221218161559.932604-1-sashal@kernel.org>
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
index f1adc858b590..0e58a7cda427 100644
--- a/drivers/clk/st/clkgen-fsyn.c
+++ b/drivers/clk/st/clkgen-fsyn.c
@@ -942,9 +942,10 @@ static void __init st_of_quadfs_setup(struct device_node *np,
 
 	clk = st_clk_register_quadfs_pll(pll_name, clk_parent_name, data,
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

