Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D67657D49
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233976AbiL1Plt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbiL1Plf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:41:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A591741C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:41:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A865CB81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025D2C433EF;
        Wed, 28 Dec 2022 15:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242089;
        bh=EyQ++/BKTEpOyoxOhcI6CKqke6ZcQmhSGSi5ClADbY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sFEEdnYsqDyoxdJntZH1En8nMgbK5UrPER1b/7PGnC8wmb05rMOLUlbKbGvMHOJvj
         EOUrFqcw9EeRojfcU70kpYln+El7y9zJl3f23gMtzPxy//OyWd9lRdwUy7yxjUl+a9
         UfYCh5K3eGK1ResEQqPtHh6aqeJycsJIlhxGSPks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiu Jianfeng <xiujianfeng@huawei.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0366/1073] clk: rockchip: Fix memory leak in rockchip_clk_register_pll()
Date:   Wed, 28 Dec 2022 15:32:34 +0100
Message-Id: <20221228144337.945347529@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index f7827b3b7fc1..6e5e502be44a 100644
--- a/drivers/clk/rockchip/clk-pll.c
+++ b/drivers/clk/rockchip/clk-pll.c
@@ -981,6 +981,7 @@ struct clk *rockchip_clk_register_pll(struct rockchip_clk_provider *ctx,
 	return mux_clk;
 
 err_pll:
+	kfree(pll->rate_table);
 	clk_unregister(mux_clk);
 	mux_clk = pll_clk;
 err_mux:
-- 
2.35.1



