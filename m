Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 587AE657FA5
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbiL1QH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:07:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233085AbiL1QHC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:07:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622211839D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:06:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2BE6B8172A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505B6C433D2;
        Wed, 28 Dec 2022 16:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243605;
        bh=7TqnwCsT1oUHJkOJRgf2HlNmIL3Ngnf8RQmgOAXpsCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lxhFen6uiAtG5JIwwHj69h6amiezy3ue+TNNxoZinqwpYQwKl7pNl0FNmBi2V+Y/r
         aTxh7OTBX59UOgKta4B7jdmZ7XmqI+LT2NBb8TA9oPspNJsxYHwaevbM8CJusgjt6n
         ymvHNNCErUHpoxW0cq5fmmJclJiOLKar6JGlXwzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiu Jianfeng <xiujianfeng@huawei.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0520/1146] clk: samsung: Fix memory leak in _samsung_clk_register_pll()
Date:   Wed, 28 Dec 2022 15:34:19 +0100
Message-Id: <20221228144344.299569305@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index fe383471c5f0..0ff28938943f 100644
--- a/drivers/clk/samsung/clk-pll.c
+++ b/drivers/clk/samsung/clk-pll.c
@@ -1583,6 +1583,7 @@ static void __init _samsung_clk_register_pll(struct samsung_clk_provider *ctx,
 	if (ret) {
 		pr_err("%s: failed to register pll clock %s : %d\n",
 			__func__, pll_clk->name, ret);
+		kfree(pll->rate_table);
 		kfree(pll);
 		return;
 	}
-- 
2.35.1



