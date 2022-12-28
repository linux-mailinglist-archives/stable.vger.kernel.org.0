Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B71B657A3B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbiL1PJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:09:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233648AbiL1PJD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:09:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5ED13DE1
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:09:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8841261555
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB79C433D2;
        Wed, 28 Dec 2022 15:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240142;
        bh=PuDAklRmi/NF7zOK5vz/Tf1o6kBLQnq7PkHBlGB3xzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HYieBLqeDSUR2RE86pUed8qjCon9i0OuFbp6JEnVc9YBAKb8kIl8pfspd4hQ1gz12
         RjOglRLjokFJlOHdZeh+a5U6di+wn/jhcJ8xZW7kQBTH4p+KlTW8ndyrc20gVCxy5w
         i9XKsp58kUF/8pGuuDxzBL4P3uGZSQ6VdVcywnsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiu Jianfeng <xiujianfeng@huawei.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 314/731] clk: samsung: Fix memory leak in _samsung_clk_register_pll()
Date:   Wed, 28 Dec 2022 15:37:01 +0100
Message-Id: <20221228144305.679030004@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

[ Upstream commit 5174e5b0d1b669a489524192b6adcbb3c54ebc72 ]

If clk_register() fails, @pll->rate_table may have allocated memory by
kmemdup(), so it needs to be freed, otherwise will cause memory leak
issue, this patch fixes it.

Fixes: 3ff6e0d8d64d ("clk: samsung: Add support to register rate_table for samsung plls")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Link: https://lore.kernel.org/r/20221123032015.63980-1-xiujianfeng@huawei.com
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/samsung/clk-pll.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/samsung/clk-pll.c b/drivers/clk/samsung/clk-pll.c
index 5873a9354b50..4909e940f0ab 100644
--- a/drivers/clk/samsung/clk-pll.c
+++ b/drivers/clk/samsung/clk-pll.c
@@ -1385,6 +1385,7 @@ static void __init _samsung_clk_register_pll(struct samsung_clk_provider *ctx,
 	if (ret) {
 		pr_err("%s: failed to register pll clock %s : %d\n",
 			__func__, pll_clk->name, ret);
+		kfree(pll->rate_table);
 		kfree(pll);
 		return;
 	}
-- 
2.35.1



