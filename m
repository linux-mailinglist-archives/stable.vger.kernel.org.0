Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E7866CA28
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbjAPRAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234132AbjAPQ7g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:59:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522A52ED74
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:42:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 067B7B81060
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:42:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6366CC433D2;
        Mon, 16 Jan 2023 16:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887339;
        bh=iIDSwKoqkIS4gT/auVBq1kLT031HYfYCGENsZJRVJPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O91cNDIq1wlWTk58tLuhcBcX6j9k/nKXx8tv8fJkafXWAylb8jT1jqtxj/+D/8mS0
         YNqsTZTmmzpRdB84j8/Ig8t2CUuskxvzlw7Je726aCuw+WYOJZYQ29tkXBF5gjVntf
         DD44BRAWlcnLYyqiB96W+o7ebrsf6Y5FHhPMrFnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiu Jianfeng <xiujianfeng@huawei.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 112/521] clk: rockchip: Fix memory leak in rockchip_clk_register_pll()
Date:   Mon, 16 Jan 2023 16:46:14 +0100
Message-Id: <20230116154852.254502387@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

[ Upstream commit 739a6a6bbdb793bd57938cb24aa5a6df89983546 ]

If clk_register() fails, @pll->rate_table may have allocated memory by
kmemdup(), so it needs to be freed, otherwise will cause memory leak
issue, this patch fixes it.

Fixes: 90c590254051 ("clk: rockchip: add clock type for pll clocks and pll used on rk3066")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Link: https://lore.kernel.org/r/20221123091201.199819-1-xiujianfeng@huawei.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk-pll.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/rockchip/clk-pll.c b/drivers/clk/rockchip/clk-pll.c
index dd0433d4753e..77aff5defac6 100644
--- a/drivers/clk/rockchip/clk-pll.c
+++ b/drivers/clk/rockchip/clk-pll.c
@@ -972,6 +972,7 @@ struct clk *rockchip_clk_register_pll(struct rockchip_clk_provider *ctx,
 	return mux_clk;
 
 err_pll:
+	kfree(pll->rate_table);
 	clk_unregister(mux_clk);
 	mux_clk = pll_clk;
 err_mux:
-- 
2.35.1



