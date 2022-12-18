Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD6A650388
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 18:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233314AbiLRRGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 12:06:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbiLRRFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 12:05:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE8D12AF6;
        Sun, 18 Dec 2022 08:21:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2757BB803F1;
        Sun, 18 Dec 2022 16:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D74C433F0;
        Sun, 18 Dec 2022 16:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380507;
        bh=JykKPLp5E47Pvk3hvRluPHp4WzY1rFpWUUIEsM5pWQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GDd01DMt1j3bmwclC00qr3eeQnrhuIrTy9uuf1wHqNqrgZK9B3O17BMEeaolqicje
         wBPYbcxzQpVGIyKvKFVe9KrIQDxGRM+RMHNMXEzZVFgq2T5wttysYZvDKUFTuvj4tj
         zcYmU4oQ7cw9+No0ejjrN1oxm4SgJfqmnUX0V4Y6Q4pMkfcxYBLqIk1h9JRdXiYR7z
         udEx4VzZCG0Z/qkUXmSaxuNmBsqdzgtENKYmFhBFj1TDn8czMS75jfYk1szLORXSsp
         xBT7XKqu5jns/Wiyz5Jn+qc4wvl07qrMDNDJnaMQ7Aa/gfuDVIr4roqyGASPO61eII
         P8fLYcCfZehrQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiu Jianfeng <xiujianfeng@huawei.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mturquette@baylibre.com,
        windhl@126.com, avolmat@me.com, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 26/26] clk: st: Fix memory leak in st_of_quadfs_setup()
Date:   Sun, 18 Dec 2022 11:20:16 -0500
Message-Id: <20221218162016.934280-26-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218162016.934280-1-sashal@kernel.org>
References: <20221218162016.934280-1-sashal@kernel.org>
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
index a79d81985c4e..bbe113159bc6 100644
--- a/drivers/clk/st/clkgen-fsyn.c
+++ b/drivers/clk/st/clkgen-fsyn.c
@@ -948,9 +948,10 @@ static void __init st_of_quadfs_setup(struct device_node *np,
 
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

